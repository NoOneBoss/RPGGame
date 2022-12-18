package ru.nooneboss.database.chat

import ru.nooneboss.database.users.PlayerSession
import ru.nooneboss.database.users.PostgresAuthController
import java.sql.Timestamp
import java.util.*
import kotlin.concurrent.schedule

object ChatController {
    private var messages = mutableListOf<ChatMessage>()
    private val stuffConnection = PlayerSession.datasource.connection
    private val saveConnection = PlayerSession.datasource.connection

    fun addMessage(message: ChatMessage){
        messages.add(message)
    }

    fun getMessages() : List<ChatMessage>{
        return messages.takeLast(15)
    }


    fun saveMessages() {
        Timer().schedule(0, 100000) {
            println("[LOG] Saving ${messages.size} messages to database")
            messages.forEach { chatMessage -> sendMessageToDb(chatMessage)  }
        }
    }

    fun forceSaveMessages() {
        println("[LOG] Saving ${messages.size} messages to database")
        messages.forEach { chatMessage -> sendMessageToDb(chatMessage)  }
    }

    fun loadMessages() {
        val connection = stuffConnection
        val resultSet = connection.createStatement().executeQuery("SELECT * FROM rpgtrader.play.chat ORDER BY send_time DESC LIMIT 15")

        val msgs = mutableListOf<ChatMessage>()

        while(resultSet.next()){
            val message = ChatMessage(PostgresAuthController.getUser(UUID.fromString(resultSet.getString("sender")))?.login ?: "Unknown",
                resultSet.getString("message"), UUID.fromString(resultSet.getString("message_id")))
            msgs.add(message)
        }

        messages = msgs.reversed().toMutableList()
        println("[LOG] Loaded ${messages.size} messages from database")
    }

    private fun sendMessageToDb(message: ChatMessage){
        val sql = "INSERT INTO rpgtrader.play.chat (send_time, sender, message, message_id) VALUES (?, ?, ?, ?) ON CONFLICT (message_id) DO NOTHING"
        val statement =  saveConnection.prepareStatement(sql)


        statement.setTimestamp(1, Timestamp(System.currentTimeMillis()))
        statement.setObject(2, PostgresAuthController.getUser(message.sender)!!.user_uuid)
        statement.setString(3, message.message)
        statement.setObject(4, message.message_id)

        statement.execute()
    }
}


class ChatMessage(val sender: String, val message: String){
    var message_id: UUID? = null
    constructor(sender: String, message: String, message_id: UUID) : this(sender, message){
        this.message_id = message_id
    }

    init {
        message_id = UUID.randomUUID()
    }
}