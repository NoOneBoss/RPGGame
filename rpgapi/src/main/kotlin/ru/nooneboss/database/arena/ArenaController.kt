package ru.nooneboss.database.arena

import com.google.gson.GsonBuilder
import ru.nooneboss.database.users.PlayerSession
import java.io.Serializable


object ArenaController {
    private val arenaConnection = PlayerSession.datasource.connection

    fun updateArenaState(arenaSave: ArenaSave){
        val gson = GsonBuilder().create()
        val statement = arenaConnection.createStatement()
        statement.execute("INSERT INTO rpgtrader.play.arena_states (character_uuid, health, character_position, character_rotation, camera_position, camera_rotation, camera_pivot_rotation)" +
                " VALUES ('${arenaSave.character_uuid}'::uuid, '${arenaSave.health}', '${gson.toJson(arenaSave.character_position)}'::jsonb," +
                "'${gson.toJson(arenaSave.character_rotation)}'::jsonb, '${gson.toJson(arenaSave.camera_position)}'::jsonb, '${gson.toJson(arenaSave.camera_rotation)}'::jsonb," +
                " '${gson.toJson(arenaSave.camera_pivot_rotation)}'::jsonb)" +
                " ON CONFLICT (character_uuid) DO UPDATE " +
                "SET health = '${arenaSave.health}'," +
                " character_position = '${gson.toJson(arenaSave.character_position)}', character_rotation = '${gson.toJson(arenaSave.character_rotation)}'," +
                " camera_position = '${gson.toJson(arenaSave.camera_position)}', camera_rotation = '${gson.toJson(arenaSave.camera_rotation)}'," +
                " camera_pivot_rotation = '${gson.toJson(arenaSave.camera_pivot_rotation)}'")
    }
}

class ArenaSave(
    val character_uuid: String,
    val health: Int,
    val character_position: Vector<Double, Double, Double>,
    val character_rotation: Vector<Double, Double, Double>,
    val camera_position: Vector<Double, Double, Double>,
    val camera_rotation: Vector<Double, Double, Double>,
    val camera_pivot_rotation: Vector<Double, Double, Double>
)

data class Vector<out A, out B, out C>(
    public val x: A,
    public val y: B,
    public val z: C
) : Serializable {
    public override fun toString(): String = "($x, $y, $z)"
}