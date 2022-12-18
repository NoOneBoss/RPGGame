package ru.nooneboss.database.users

import java.sql.DriverManager
import java.util.*

object PostgresAuthController {
    private val jdbc = "jdbc:postgresql://localhost:5432/rpgtrader"
    private val dbusername = "rpgtraderauth"
    private val dbpassword = "CC?2Zxls70dBK{5vQ1@H}p3Ng"
    val connection = DriverManager.getConnection(jdbc, dbusername, dbpassword)

    init {
        connection.schema = "play"
    }

    fun login(login: String, password: String): Boolean {
        val statement = connection.prepareStatement("select  rpgtrader.play.auth(?, ?)")

        statement.setString(1, login)
        statement.setString(2, password)

        val result = statement.executeQuery()
        result.next()

        return result.getBoolean(1)
    }

    fun register(login: String, password: String){
        val statement = connection.prepareStatement("call rpgtrader.play.register(?, ?)")

        statement.setString(1, login)
        statement.setString(2, password)

        statement.execute()
    }

    fun alreadyExists(login: String): Boolean{
        val statement = connection.prepareStatement("select rpgtrader.play.account_already_exist(?)")

        statement.setString(1, login)

        val result = statement.executeQuery()
        result.next()

        return result.getBoolean(1)
    }

    fun getUser(userLogin: String): User? {
        val statement = connection.prepareStatement("select * from rpgtrader.play.users where login = ?")
        statement.setString(1, userLogin)
        val result = statement.executeQuery()
        return if(result.next()) {
            User(
                UUID.fromString(result.getString("user_uuid")),
                result.getString("login"),
                result.getString("password"),
                result.getString("role"))
            } else {
                null
            }
    }

    fun getUser(uuid: UUID) : User? {
        if(PlayerSession.sessions.any { it.user_uuid == uuid }) return PlayerSession.sessions.first { it.user_uuid == uuid }

        val statement = connection.prepareStatement("select * from rpgtrader.play.users where user_uuid = ?")
        statement.setObject(1, uuid)
        val result = statement.executeQuery()
        return if(result.next()) {
            User(
                UUID.fromString(result.getString("user_uuid")),
                result.getString("login"),
                result.getString("password"),
                result.getString("role"))
            } else {
                null
            }
    }
}