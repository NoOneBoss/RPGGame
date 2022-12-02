package ru.nooneboss.plugins

import com.google.gson.Gson
import io.ktor.server.routing.*
import io.ktor.http.*
import io.ktor.serialization.gson.*
import io.ktor.server.locations.*
import io.ktor.server.application.*
import io.ktor.server.plugins.contentnegotiation.*
import io.ktor.server.response.*
import io.ktor.server.request.*
import ru.nooneboss.database.users.PostgresAuthController
import java.util.*

@OptIn(KtorExperimentalLocationsAPI::class)
fun Application.configureRouting() {
    install(Locations) {
    }

    routing {
        get<LocationUser> {
            call.respondText(Gson().toJson(PostgresAuthController.getUser(it.login)), status = HttpStatusCode.OK)
        }
    }
}

@OptIn(KtorExperimentalLocationsAPI::class)
@Location("/users/{login}/{password}")
class LocationUser(val login: String, val password: String)
