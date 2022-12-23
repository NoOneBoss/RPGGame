package ru.nooneboss.database.logs

import java.sql.DriverManager
import java.util.*

object PostgresLogsController {
    private val jdbc = "jdbc:postgresql://localhost:5432/rpgtrader"
    private val dbusername = "rpgtraderlogs"
    private val dbpassword = "r1D46d*?H7~*0*zwMeuNOy4T3"
    val connection = DriverManager.getConnection(jdbc, dbusername, dbpassword)

    init {
        connection.schema = "play"
    }

    fun removeLogs(){
        val statement = connection.prepareStatement("DELETE FROM rpgtrader.play.logs WHERE (execution_time > now() - interval '1 day') and (\"isPersistence\" = false)")
        statement.execute()
    }

    fun log(logMessage: LogMessage){
        val statement = connection.prepareStatement("call rpgtrader.play.log(?, ?, ?, ?, ?)")

        statement.setObject(1, logMessage.executor)
        statement.setObject(2, logMessage.character)
        statement.setString(3, logMessage.action)
        statement.setString(4, logMessage.ipAddress)
        statement.setBoolean(5, logMessage.isPersistance)

        statement.execute()
    }
}

class LogMessage(val executor: UUID, val character: UUID?, val action: String, val ipAddress: String, val isPersistance: Boolean)