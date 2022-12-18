package ru.nooneboss.plugins

import com.auth0.jwt.JWT
import com.auth0.jwt.JWTVerifier
import com.auth0.jwt.algorithms.Algorithm
import io.ktor.http.*
import io.ktor.server.application.*
import io.ktor.server.auth.*
import io.ktor.server.auth.jwt.*
import io.ktor.server.plugins.*
import io.ktor.server.request.*
import io.ktor.server.response.*
import io.ktor.server.routing.*
import ru.nooneboss.database.logs.LogMessage
import ru.nooneboss.database.logs.PostgresLogsController
import ru.nooneboss.database.users.PlayerSession
import ru.nooneboss.database.users.PostgresAuthController
import ru.nooneboss.database.users.User

fun Application.configureSecurity() {
    install(Authentication){
        jwt {
            realm = JWTConfig.realm
            verifier(JWTConfig.verifyToken())
            validate{
                val userLogin = it.payload.getClaim("login").asString()
                val userPassword = it.payload.getClaim("password").asString()
                if(PostgresAuthController.login(userLogin, userPassword)){
                    PostgresAuthController.getUser(userLogin)
                }
                else null
            }
        }
    }

    routing {
        post("/login"){
            val user = call.receive<User>()
            if(PostgresAuthController.login(user.login, user.password)){
                val token = JWTConfig.generateToken(user)
                call.respondText(token)

                PlayerSession.join(user)
                PostgresLogsController.log(
                    LogMessage(user.user_uuid,
                        null, "Authenticate", call.request.origin.remoteHost, true)
                )
                println("[LOG] User ${user.user_uuid} joined")
            }
            else {
                call.respondText("Login failed, incorrect login or password", status = HttpStatusCode.Unauthorized)
                println("[LOG] User ${user.user_uuid} failed to login!")
                PostgresLogsController.log(
                    LogMessage(user.user_uuid,
                        null, "Failed login", call.request.origin.remoteHost, true)
                )
            }
        }

        post("/register"){
            val user = call.receive<User>()
            if(!PostgresAuthController.alreadyExists(user.login)){
                PostgresAuthController.register(user.login, user.password)

                println("[LOG] User ${user.login} registered")
                PostgresLogsController.log(
                    LogMessage(PostgresAuthController.getUser(user.login)!!.user_uuid,
                        null, "Registered", call.request.origin.remoteHost, false)
                )
                call.respondText ("Successfully registration!", status = HttpStatusCode.OK)
            }
            else call.respondText("Registration failed, user with this login already exists", status = HttpStatusCode.Unauthorized)
        }
    }

}

private object JWTConfig{
    val secret = "rpgtraderapiASFDKF13RKSDKF00$21MSDKASDFR$"
    val realm = "Access to the /api path"

    fun generateToken(user: User): String {
        return JWT.create()
            .withClaim("login", user.login)
            .withClaim("password", user.password)
            .sign(Algorithm.HMAC256(secret))
    }

    fun verifyToken() : JWTVerifier{
        return JWT.require(Algorithm.HMAC256(secret))
            .build()
    }
}
