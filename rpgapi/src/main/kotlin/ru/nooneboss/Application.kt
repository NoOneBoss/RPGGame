package ru.nooneboss

import io.ktor.server.application.*
import io.ktor.server.engine.*
import io.ktor.server.netty.*
import org.jetbrains.exposed.sql.Database
import ru.nooneboss.database.chat.ChatController
import ru.nooneboss.database.friends.StatusController
import ru.nooneboss.database.users.PlayerSession
import ru.nooneboss.plugins.configureRouting
import ru.nooneboss.plugins.configureSecurity
import ru.nooneboss.plugins.configureSerialization
import java.util.concurrent.TimeUnit

fun main() {
    Database.connect("jdbc:postgresql://localhost:5432/rpgtrader", driver = "org.postgresql.Driver",
        user = "postgres", password = "qwe123")
    val server = embeddedServer(Netty, port = 8080, host = "0.0.0.0", module = Application::module)
        .start(wait = false)
    Runtime.getRuntime().addShutdownHook(Thread {
        server.stop(1, 5, TimeUnit.SECONDS)
    })
    Thread.currentThread().join()
}


fun Application.module() {
    configureSecurity()
    configureSerialization()
    configureRouting()

    environment.monitor.subscribe(ApplicationStarted) { application ->
        application.environment.log.info("Server is started")

        PlayerSession.init()
    }
    environment.monitor.subscribe(ApplicationStopped) { application ->
        application.environment.log.info("Server is stopped")

        ChatController.forceSaveMessages()
        StatusController.forceSaveStatuses()
    }
}
