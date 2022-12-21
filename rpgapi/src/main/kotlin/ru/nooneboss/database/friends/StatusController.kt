package ru.nooneboss.database.friends

import ru.nooneboss.database.users.PlayerSession
import ru.nooneboss.database.users.PostgresAuthController
import java.util.*
import kotlin.concurrent.schedule

object StatusController {
    var sessionStatus = mutableListOf<SessionStatus>()
    private val statusConnection = PlayerSession.datasource.connection

    fun setStatus(status: SessionStatus){
        sessionStatus.apply {
            this.map {
                if(it.user_uuid == status.user_uuid){
                    it.status = status.status
                }
            }
        }
    }

    fun getStatus(uuid: UUID): SessionStatus{
        return sessionStatus.find { it.user_uuid == uuid } ?: SessionStatus(uuid, SessionStatusEnum.NOT_IN_GAME)
    }

    fun saveStatuses(){
        Timer().schedule(0, 100000) {
            forceSaveStatuses()
        }
    }

    fun forceSaveStatuses(){
        sessionStatus.forEach { status ->
            updateStatus(status)
        }
        println("[LOG] Saved ${sessionStatus.size} statuses to database")
    }

    fun loadStatuses(){
        val statement = PostgresAuthController.connection.createStatement()

        val result = statement.executeQuery("SELECT user_uuid, last_status FROM rpgtrader.play.users")
        while (result.next()){
            val uuid = UUID.fromString(result.getString("user_uuid"))
            val status = SessionStatusEnum.valueOf(result.getString("last_status"))

            sessionStatus.add(SessionStatus(uuid, status))
        }

        println("[LOG] Loaded ${sessionStatus.size} statuses from database")
    }

    private fun updateStatus(status: SessionStatus){
        val statement = PostgresAuthController.connection.prepareStatement("UPDATE rpgtrader.play.users SET last_status = ? WHERE user_uuid = ?")
        statement.setString(1, status.status.toString())
        statement.setObject(2, status.user_uuid)

        statement.execute()
    }

}

class SessionStatus(val user_uuid: UUID, var status: SessionStatusEnum)

enum class SessionStatusEnum {
    MAIN_MENU,
    ARENA,
    NOT_IN_GAME
}