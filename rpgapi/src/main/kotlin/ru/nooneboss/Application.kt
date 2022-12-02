package ru.nooneboss

import io.ktor.server.application.*
import io.ktor.server.auth.*
import io.ktor.server.engine.*
import io.ktor.server.netty.*
import org.jetbrains.exposed.sql.Database
import ru.nooneboss.database.users.User
import ru.nooneboss.plugins.*

fun main() {
    Database.connect("jdbc:postgresql://localhost:5432/rpgtrader", driver = "org.postgresql.Driver",
        user = "postgres", password = "qwe123")
    embeddedServer(Netty, port = 8080, host = "0.0.0.0", module = Application::module)
        .start(wait = true)

}

fun Application.module() {
    configureSecurity()
    configureSerialization()
    configureRouting()
}
