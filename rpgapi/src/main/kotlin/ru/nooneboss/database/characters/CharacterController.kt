package ru.nooneboss.database.characters

import com.google.gson.GsonBuilder
import ru.nooneboss.database.users.PlayerSession
import ru.nooneboss.plugins.CharactersUpgrader
import java.util.*

object CharacterController {
    private val characterConnection = PlayerSession.datasource.connection
    val characters = mutableListOf<Character>()


    fun getCharacters(uuid: UUID) : List<Character>{
        return characters.filter { it.owner == uuid }
    }

    fun updateCharacterStats(charactersUpgrader: CharactersUpgrader){
        val statement = characterConnection.prepareStatement("UPDATE rpgtrader.play.characters SET level = level + ?, money = money + ? where character_uuid = ?")
        statement.setInt(1,charactersUpgrader.level)
        statement.setInt(2,charactersUpgrader.money)
        statement.setObject(3,charactersUpgrader.character_uuid)

        statement.execute()
    }

    fun addCharacter(owner: UUID, skin: String, character_uuid: UUID){
        val statement = characterConnection.prepareStatement("call rpgtrader.play.createCharacter(?,?,?::jsonb)")
        statement.setObject(1, character_uuid)
        statement.setObject(2, owner)
        statement.setString(3, skin)

        statement.execute()

        updateCharacters(owner)
    }

    fun updateCharacters(uuid: UUID){
        val statement = characterConnection.prepareStatement("SELECT * FROM rpgtrader.play.characterView WHERE owner = ?")
        statement.setObject(1, uuid)

        val result = statement.executeQuery()
        while (result.next()){
            val character = Character(
                UUID.fromString(result.getString("character_uuid")),
                result.getInt("level"),
                result.getInt("money"),
                UUID.fromString(result.getString("owner")),
                GsonBuilder().create().fromJson(result.getString("skin"), CharacterSkin::class.java)
            )

            if(!characters.any{ it.character_uuid == character.character_uuid }){
                characters.add(character)
            }
        }
    }

    fun loadCharacters(){
        val statement = characterConnection.createStatement()
        val result = statement.executeQuery("SELECT * FROM rpgtrader.play.characterView")

        while (result.next()){
            val character = Character(
                UUID.fromString(result.getString("character_uuid")),
                result.getInt("level"),
                result.getInt("money"),
                UUID.fromString(result.getString("owner")),
                GsonBuilder().create().fromJson(result.getString("skin"), CharacterSkin::class.java)
            )

            characters.add(character)
        }
    }
}

class Character(val character_uuid: UUID, val level : Int, val money : Int,val owner: UUID, val skin: CharacterSkin){
}

class CharacterSkin(
    val gender: Int,
    val head: Int,
    val hair: Int,
    val torso: Int,
    val armUpper: Int,
    val armLower: Int,
    val hand: Int,
    val hips: Int,
    val leg: Int,
    val helmet: Int,
    val backAttachment: Int,
    val shoulderAttachment: Int,
    val elbow: Int,
    val hipsAttachment: Int,
    val knee: Int
)