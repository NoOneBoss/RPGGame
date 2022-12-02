package ru.nooneboss.database.users

import java.sql.Connection
import java.sql.DriverManager

class PostgresSession(user: User) {
    var connection: Connection

    init {
        connection = DriverManager.getConnection("jdbc:postgresql://localhost:5432/rpgtrader", user.login, user.password)
        connection.schema = "play"
    }



}