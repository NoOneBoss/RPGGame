package ru.nooneboss.database.friends

import ru.nooneboss.database.users.PlayerSession
import java.util.*
import kotlin.concurrent.schedule

object FriendController {
    var friends = listOf<Friend>()

    val friendStuffConnection = PlayerSession.datasource.connection
    val friendAddConnection = PlayerSession.datasource.connection
    val friendDeleteConnection = PlayerSession.datasource.connection

    fun getFriends(uuid: UUID) : List<Friend> {
        return friends.filter { it.user_uuid == uuid || it.friend_uuid == uuid }
    }

    fun isFriend(uuid: UUID, friend_uuid: UUID) : Boolean {
        return friends.any { (it.user_uuid == uuid && it.friend_uuid == friend_uuid) || (it.user_uuid == friend_uuid && it.friend_uuid == uuid) }
    }

    fun addFriend(uuid: UUID, friend_uuid: UUID){
        val connection = friendAddConnection
        val sql = "INSERT INTO rpgtrader.play.friends (first, second) VALUES (?, ?)"
        val statement =  connection.prepareStatement(sql)

        statement.setObject(1, uuid)
        statement.setObject(2, friend_uuid)

        statement.execute()
    }

    fun removeFriends(uuid: UUID, friend_uuid: UUID){
        val connection = friendDeleteConnection
        val sql = "DELETE FROM rpgtrader.play.friends WHERE (first = ? AND second = ?) OR (first = ? AND second = ?)"
        val statement =  connection.prepareStatement(sql)

        statement.setObject(1, uuid)
        statement.setObject(2, friend_uuid)
        statement.setObject(3, friend_uuid)
        statement.setObject(4, uuid)

        statement.execute()
    }

    fun loadFriends() {
        val connection = friendStuffConnection
        Timer().schedule(0, 10000) {
            val resultSet = connection.createStatement().executeQuery("SELECT * FROM rpgtrader.play.friendView")

            val frs = mutableListOf<Friend>()

            while (resultSet.next()) {
                frs.add(
                    Friend(
                        UUID.fromString(resultSet.getString("user_uuid")),
                        UUID.fromString(resultSet.getString("friend_uuid")),
                        resultSet.getString("user_name"),
                        resultSet.getString("friend_name"),
                        resultSet.getString("friend_date")
                    )
                )
            }

            friends = frs
        }
    }
}

data class Friend(val user_uuid: UUID, val friend_uuid: UUID, val user_name: String, val friend_name: String, val friend_date: String)
data class FriendReq(val user_uuid: UUID, val friend_uuid: UUID)