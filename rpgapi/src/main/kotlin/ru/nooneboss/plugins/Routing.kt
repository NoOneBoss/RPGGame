package ru.nooneboss.plugins

import com.google.gson.Gson
import com.google.gson.GsonBuilder
import io.ktor.http.*
import io.ktor.serialization.gson.*
import io.ktor.server.application.*
import io.ktor.server.auth.*
import io.ktor.server.locations.*
import io.ktor.server.plugins.*
import io.ktor.server.plugins.contentnegotiation.*
import io.ktor.server.request.*
import io.ktor.server.response.*
import io.ktor.server.routing.*
import ru.nooneboss.database.arena.ArenaController
import ru.nooneboss.database.arena.ArenaSave
import ru.nooneboss.database.characters.CharacterController
import ru.nooneboss.database.chat.ChatController
import ru.nooneboss.database.chat.ChatMessage
import ru.nooneboss.database.friends.FriendController
import ru.nooneboss.database.friends.FriendReq
import ru.nooneboss.database.friends.SessionStatus
import ru.nooneboss.database.friends.StatusController
import ru.nooneboss.database.invenory.InventoryController
import ru.nooneboss.database.invenory.Item
import ru.nooneboss.database.logs.LogMessage
import ru.nooneboss.database.logs.PostgresLogsController
import ru.nooneboss.database.users.PlayerSession
import ru.nooneboss.database.users.PostgresAuthController
import ru.nooneboss.database.users.User
import java.util.*

@OptIn(KtorExperimentalLocationsAPI::class)
fun Application.configureRouting() {
    install(Locations) {
    }

    routing {
        get("/serverstatus") {
            call.respondText("Server is running", status = HttpStatusCode.OK)
        }

        get<LocationUser> {
            call.respondText(Gson().toJson(PostgresAuthController.getUser(it.login)), status = HttpStatusCode.OK)
        }

        authenticate {
            /*
            * Get user login by uuid
            * */
            get<LocationUserUUID>{
                val user = call.principal<User>() ?: return@get call.respondText("Unauthorized", status = HttpStatusCode.Unauthorized)

                val targetUser = if(PlayerSession.getSession(UUID.fromString(it.uuid)) != null) PlayerSession.getSession(UUID.fromString(it.uuid))
                else PostgresAuthController.getUser(UUID.fromString(it.uuid)) ?: return@get call.respondText("User not found", status = HttpStatusCode.NotFound)

                return@get call.respondText(targetUser!!.login)
            }

            /*
            * Get user uuid by login
            * */
            get<LocationUserLogin> {
                val user = call.principal<User>() ?: return@get call.respondText("Unauthorized", status = HttpStatusCode.Unauthorized)

                val targetUser = if(PlayerSession.getSession(it.login) != null) PlayerSession.getSession(it.login)
                else PostgresAuthController.getUser(it.login) ?: return@get call.respondText("User not found", status = HttpStatusCode.NotFound)

                return@get call.respondText(targetUser!!.user_uuid.toString())
            }


            get("/chat/messages") {
                val user = call.principal<User>() ?: return@get call.respondText("Unauthorized", status = HttpStatusCode.Unauthorized)

                call.respondText(Gson().toJson(ChatController.getMessages()), status = HttpStatusCode.OK)
            }

            post("/chat/send") {
                val user = call.principal<User>() ?: return@post call.respondText("Unauthorized", status = HttpStatusCode.Unauthorized)

                val message = call.receive<ChatMessage>()
                message.message_id = UUID.randomUUID()

                ChatController.addMessage(message)
                call.respondText("Message sent", status = HttpStatusCode.OK)

                println("[LOG] User ${user.user_uuid} sent message: '${message.message}'")
                PostgresLogsController.log(LogMessage(user.user_uuid, null, "Sent message: '${message.message}'", call.request.origin.remoteHost, false))
            }

            post("/logs/send") {
                if(call.principal<User>() == null) return@post call.respondText("Unauthorized", status = HttpStatusCode.Unauthorized)

                val log = call.receive<LogMessage>()
                PostgresLogsController.log(log)
            }

            get<LocationFriends>{
                val user = call.principal<User>() ?: return@get call.respondText("Unauthorized", status = HttpStatusCode.Unauthorized)
                if(it.uuid != user.user_uuid) return@get call.respondText("Forbidden", status = HttpStatusCode.Forbidden)

                call.respondText(Gson().toJson(FriendController.getFriends(user.user_uuid)), status = HttpStatusCode.OK)
            }

            post("/friends/add") {
                val user = call.principal<User>() ?: return@post call.respondText("Unauthorized", status = HttpStatusCode.Unauthorized)

                val friendReq = call.receive<FriendReq>()
                if(friendReq.friend_uuid == friendReq.user_uuid) return@post call.respondText("Forbidden", status = HttpStatusCode.Forbidden)
                else if(FriendController.isFriend(friendReq.user_uuid, friendReq.friend_uuid)) return@post call.respondText("Already friends", status = HttpStatusCode.Conflict)

                FriendController.addFriend(friendReq.user_uuid, friendReq.friend_uuid)
                call.respondText("Friend added", status = HttpStatusCode.OK)
                println("[LOG] User ${user.user_uuid} added friend ${friendReq.friend_uuid}")
            }

            post("/friends/remove") {
                val user = call.principal<User>() ?: return@post call.respondText("Unauthorized", status = HttpStatusCode.Unauthorized)

                val friendReq = call.receive<FriendReq>()
                if(!FriendController.isFriend(friendReq.user_uuid, friendReq.friend_uuid)) return@post call.respondText("Not friends", status = HttpStatusCode.Conflict)

                FriendController.removeFriends(friendReq.user_uuid, friendReq.friend_uuid)
                call.respondText("Friend remove", status = HttpStatusCode.OK)
                println("[LOG] User ${user.user_uuid} removed friend ${friendReq.friend_uuid}")
            }

            get<LocationStatus> {
                val user = call.principal<User>() ?: return@get call.respondText("Unauthorized", status = HttpStatusCode.Unauthorized)

                call.respondText(Gson().toJson(StatusController.getStatus(it.uuid)), status = HttpStatusCode.OK)
            }

            post("/status/update") {
                val user = call.principal<User>() ?: return@post call.respondText("Unauthorized", status = HttpStatusCode.Unauthorized)

                val status = call.receive<SessionStatus>()

                StatusController.setStatus(status)
                call.respondText("Status updated", status = HttpStatusCode.OK)
                println("[LOG] User ${user.user_uuid} updated status to ${status.status}")
            }

            get<LocationCharacters> {
                val user = call.principal<User>() ?: return@get call.respondText("Unauthorized", status = HttpStatusCode.Unauthorized)
                if(it.uuid != user.user_uuid) return@get call.respondText("Forbidden", status = HttpStatusCode.Forbidden)
                CharacterController.updateCharacters(user.user_uuid)

                call.respondText(Gson().toJson(CharacterController.getCharacters(it.uuid)), status = HttpStatusCode.OK)
            }

            post("/characters/create") {
                val user = call.principal<User>() ?: return@post call.respondText("Unauthorized", status = HttpStatusCode.Unauthorized)

                val characterSkin = call.receive<String>()

                val uuid = UUID.randomUUID()
                CharacterController.addCharacter(user.user_uuid, characterSkin,uuid)
                call.respondText("Character created", status = HttpStatusCode.OK)
                println("[LOG] User ${user.user_uuid} created character.")
                PostgresLogsController.log(LogMessage(user.user_uuid, uuid, "Created character", call.request.origin.remoteHost, true))
            }

            get<ArenaStatesCharacters> {
                val user = call.principal<User>() ?: return@get call.respondText("Unauthorized", status = HttpStatusCode.Unauthorized)


                try{
                    call.respondText(GsonBuilder().create().toJson(ArenaController.getArenaState(it.uuid)), status = HttpStatusCode.OK)
                }
                catch (e: Exception){
                    call.respondText("null", status = HttpStatusCode.NotFound)
                }
            }

            post("/arenastates/update"){
                val user = call.principal<User>() ?: return@post call.respondText("Unauthorized", status = HttpStatusCode.Unauthorized)

                val arenaSave = call.receive<ArenaSave>()
                ArenaController.updateArenaState(arenaSave)
                call.respondText("Arena state updated", status = HttpStatusCode.OK)
            }

            post("/characters/updatestats") {
                val user = call.principal<User>() ?: return@post call.respondText("Unauthorized", status = HttpStatusCode.Unauthorized)
                val charactersUpgrader = call.receive<CharactersUpgrader>()

                CharacterController.updateCharacterStats(charactersUpgrader)
            }

            get<LocationInventory>{
                val user = call.principal<User>() ?: return@get call.respondText("Unauthorized", status = HttpStatusCode.Unauthorized)

                val inventory = Gson().toJson(InventoryController.getInventory(it.uuid))
                call.respondText(inventory, status = HttpStatusCode.OK)
                println("[LOG] User ${user.user_uuid} requested inventory ${inventory}.")
            }

            post("/inventory/add") {
                val user = call.principal<User>() ?: return@post call.respondText("Unauthorized", status = HttpStatusCode.Unauthorized)

                val item = call.receive<Item>()

                println(GsonBuilder().create().toJson(item).toString())
                InventoryController.addItem(item)
                call.respondText("Item added", status = HttpStatusCode.OK)
                println("[LOG] User ${user.user_uuid} added item ${item.item_uuid} to inventory.")
                PostgresLogsController.log(LogMessage(user.user_uuid, item.character_uuid, "Created character", call.request.origin.remoteHost, true))
            }

        }

    }
}

@OptIn(KtorExperimentalLocationsAPI::class)
@Location("/users/{login}/{password}")
class LocationUser(val login: String, val password: String)

@OptIn(KtorExperimentalLocationsAPI::class)
@Location("/users/uuid/{uuid}")
class LocationUserUUID(val uuid: String)

@OptIn(KtorExperimentalLocationsAPI::class)
@Location("/users/login/{login}")
class LocationUserLogin(val login: String)

@OptIn(KtorExperimentalLocationsAPI::class)
@Location("/friends/{uuid}")
class LocationFriends(val uuid: UUID)

@OptIn(KtorExperimentalLocationsAPI::class)
@Location("/status/{uuid}")
class LocationStatus(val uuid: UUID)

@OptIn(KtorExperimentalLocationsAPI::class)
@Location("/characters/{uuid}")
class LocationCharacters(val uuid: UUID)

class CharactersUpgrader(val character_uuid: UUID, val money : Int, val level: Int)

@OptIn(KtorExperimentalLocationsAPI::class)
@Location("/arenastates/{uuid}")
class ArenaStatesCharacters(val uuid: UUID)

@OptIn(KtorExperimentalLocationsAPI::class)
@Location("/inventory/{uuid}")
class LocationInventory(val uuid: UUID)
