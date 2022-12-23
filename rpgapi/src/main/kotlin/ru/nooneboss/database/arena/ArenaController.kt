package ru.nooneboss.database.arena

import com.google.gson.GsonBuilder
import ru.nooneboss.database.users.PlayerSession
import java.io.Serializable
import java.util.UUID


object ArenaController {
    private val arenaSaveConnection = PlayerSession.datasource.connection
    private val arenaGetConnection = PlayerSession.datasource.connection

    fun getArenaState(uuid: UUID) : ArenaSave? {
        val gson = GsonBuilder().create()
        val statement = arenaGetConnection.createStatement()
        val resultSet = statement.executeQuery("SELECT * FROM rpgtrader.play.arena_states  WHERE character_uuid = '${uuid}' LIMIT 1")

        if(resultSet.wasNull()) return null
        resultSet.next()

        return ArenaSave(resultSet.getString("character_uuid"),
                        resultSet.getInt("health"),
                        gson.fromJson(resultSet.getString("character_position"),Vector::class.java),
                        gson.fromJson(resultSet.getString("character_rotation"),Vector::class.java),
                        gson.fromJson(resultSet.getString("camera_position"),Vector::class.java),
                        gson.fromJson(resultSet.getString("camera_rotation"),Vector::class.java),
                        gson.fromJson(resultSet.getString("camera_pivot_rotation"),Vector::class.java),
                        resultSet.getString("picked_up_items")
                )
    }

    fun updateArenaState(arenaSave: ArenaSave){
        val gson = GsonBuilder().create()
        val statement = arenaSaveConnection.createStatement()
        statement.execute("INSERT INTO rpgtrader.play.arena_states (character_uuid, health, character_position, character_rotation, camera_position, camera_rotation, camera_pivot_rotation, picked_up_items)" +
                " VALUES ('${arenaSave.character_uuid}'::uuid, '${arenaSave.health}', '${gson.toJson(arenaSave.character_position)}'::jsonb," +
                "'${gson.toJson(arenaSave.character_rotation)}'::jsonb, '${gson.toJson(arenaSave.camera_position)}'::jsonb, '${gson.toJson(arenaSave.camera_rotation)}'::jsonb," +
                " '${gson.toJson(arenaSave.camera_pivot_rotation)}'::jsonb, '${arenaSave.picked_up_items}')" +
                " ON CONFLICT (character_uuid) DO UPDATE " +
                "SET health = '${arenaSave.health}'," +
                " character_position = '${gson.toJson(arenaSave.character_position)}', character_rotation = '${gson.toJson(arenaSave.character_rotation)}'," +
                " camera_position = '${gson.toJson(arenaSave.camera_position)}', camera_rotation = '${gson.toJson(arenaSave.camera_rotation)}'," +
                " camera_pivot_rotation = '${gson.toJson(arenaSave.camera_pivot_rotation)}', picked_up_items = '${arenaSave.picked_up_items}'")
    }
}

class ArenaSave(
    val character_uuid: String,
    val health: Int,
    val character_position: Vector,
    val character_rotation: Vector,
    val camera_position: Vector,
    val camera_rotation: Vector,
    val camera_pivot_rotation: Vector,
    val picked_up_items: String
)

data class Vector(val x: Double, val y: Double, val z: Double) : Serializable