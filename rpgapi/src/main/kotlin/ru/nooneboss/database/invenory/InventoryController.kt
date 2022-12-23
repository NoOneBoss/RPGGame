package ru.nooneboss.database.invenory

import ru.nooneboss.database.users.PlayerSession
import java.util.*


object InventoryController {
    private val inventoryConnection = PlayerSession.datasource.connection


    fun getInventory(uuid: UUID) : List<Item>{
        val statement = inventoryConnection.prepareStatement("SELECT * FROM rpgtrader.play.inventory WHERE character_uuid = ?")
        statement.setObject(1, uuid)

        val result = statement.executeQuery()
        val items = mutableListOf<Item>()

        while (result.next()){
            items.add(Item(
                result.getString("character_uuid"),
                result.getString("item_uuid"),
                result.getString("item_name"),
                result.getString("item_description"),
                result.getString("item_category"),
                result.getString("sprite_name"),
            ))
        }

        return items
    }

    fun addItem(item: Item){
        val statement = inventoryConnection.prepareStatement("INSERT INTO rpgtrader.play.inventory (character_uuid, item_name, item_description, item_category, sprite_name)" +
                " VALUES (?::uuid,?,?,?,?)")
        statement.setString(1, item.character_uuid)
        statement.setString(2, item.item_name)
        statement.setString(3, item.item_description)
        statement.setString(4, item.item_category)
        statement.setString(5, item.sprite_name)

        statement.execute()
    }

}

class Item(val character_uuid: String, val item_uuid: String, val item_name: String, val item_description: String, val item_category: String, val sprite_name: String)