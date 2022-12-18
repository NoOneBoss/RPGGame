package ru.nooneboss.database.users

import com.zaxxer.hikari.HikariDataSource
import ru.nooneboss.database.chat.ChatController
import ru.nooneboss.database.friends.FriendController
import ru.nooneboss.database.friends.StatusController
import java.sql.Timestamp
import java.time.Duration
import java.util.*

object PlayerSession {
    val sessions = mutableListOf<User>()
    val connectionTimes = mutableMapOf<User,Timestamp>()

    fun join(user: User){
        if(!sessions.contains(user)){
            sessions.add(user)
            connectionTimes[user] = Timestamp(System.currentTimeMillis())
        }
    }

    fun leave(user: User){
        sessions.remove(user)
    }

    fun getSession(uuid: UUID) : User? {
        return sessions.find { it.user_uuid == uuid }
    }

    fun getSession(login: String): User? {
        return sessions.find { it.login == login }
    }

    val datasource = HikariDataSource()
    fun init(){
        datasource.poolName = "rpgtrader"
        datasource.jdbcUrl = "jdbc:postgresql://localhost:5432/rpgtrader"
        datasource.username = "rpgtraderplayer"
        datasource.password = "nbL?f5HSzRDZLA||~f\$#7cbO#"

        datasource.minimumIdle = 5
        datasource.maximumPoolSize = 25
        datasource.connectionTimeout = Duration.ofSeconds(30).toMillis()
        datasource.schema = "play"

        ChatController.saveMessages()
        ChatController.loadMessages()

        FriendController.loadFriends()

        StatusController.saveStatuses()
        StatusController.loadStatuses()
    }
}