package ru.nooneboss.database.friends

import ru.nooneboss.database.users.PlayerSession
import java.util.*
import kotlin.concurrent.schedule

object StatusController {
    val sessionStatus = mutableListOf<SessionStatus>()
    private val statusConnection = PlayerSession.datasource.connection

    fun setStatus(status: SessionStatus){
        sessionStatus.replaceAll { if(status.user_uuid == it.user_uuid) status else it }
    }

    fun getStatus(uuid: UUID): SessionStatus{
        return sessionStatus.find { it.user_uuid == uuid } ?: SessionStatus(uuid, SessionStatusEnum.NOT_IN_GAME)
    }

    fun saveStatuses(){
        Timer().schedule(0, 100000) {
            sessionStatus.forEach { status ->
                updateStatus(status)
            }
        }
    }

    fun forceSaveStatuses(){
        sessionStatus.forEach { status ->
            updateStatus(status)
        }
    }

    fun loadStatuses(){
        val statement = statusConnection.createStatement()

        val result = statement.executeQuery("SELECT (user_uuid, last_status) FROM rpgtrader.play.users")
        while (result.next()){
            val uuid = UUID.fromString(result.getString("user_uuid"))
            val status = SessionStatusEnum.valueOf(result.getString("last_status"))

            sessionStatus.add(SessionStatus(uuid, status))
        }
    }

    private fun updateStatus(status: SessionStatus){
        val statement = statusConnection.prepareStatement("UPDATE rpgtrader.play.users SET last_status = ? WHERE user_uuid = ?")
        statement.setString(1, status.status.toString())
        statement.setObject(2, status.user_uuid)

        statement.execute()
    }

}

class SessionStatus(val user_uuid: UUID, val status: SessionStatusEnum)

enum class SessionStatusEnum {
    MAIN_MENU,
    ARENA,
    NOT_IN_GAME
}