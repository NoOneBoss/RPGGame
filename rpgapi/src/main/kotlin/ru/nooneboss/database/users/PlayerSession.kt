package ru.nooneboss.database.users

object PlayerSession {
    private val sessions = mutableMapOf<User, PostgresSession>()

    fun join(user: User){
        if(!sessions.containsKey(user)){
            sessions[user] = PostgresSession(user)
        }
    }

    fun leave(user: User){
        sessions.remove(user)
    }
}