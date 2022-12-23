using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[Serializable]
public class DBItem
{
    public string character_uuid; 
    private string item_uuid;
    public string item_name;
    public string item_description;
    public string item_category;
    public string sprite_name;

    public DBItem(string itemName, string itemDescription, string itemCategory, string spriteName)
    {
        item_name = itemName;
        item_description = itemDescription;
        item_category = itemCategory;
        sprite_name = spriteName;
    }
}
