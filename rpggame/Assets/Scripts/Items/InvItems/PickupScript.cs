
using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Networking;

public class PickupScript : MonoBehaviour
{
    public PickupType pickupType;
    public int amount;
    private bool isPickedUp = false;
    
    [Header("Item")]
    public string itemName;
    public string itemDescription;
    public string itemCategory;
    public string iconName;
    

    public void Start()
    {
        StartCoroutine(removeItem());
    }

    private IEnumerator removeItem()
    {
        yield return new WaitForSeconds(0.5f);
        if(ArenaSaver.pickedUpItems.Contains(gameObject.name)) Destroy(gameObject);
        isPickedUp = true;
    }

    public void OnTriggerEnter(Collider other)
    {
        if(!isPickedUp) return;
        if (other.gameObject.CompareTag("Player"))
        {
            switch (pickupType)
            {
                case PickupType.MONEY:
                    StartCoroutine(MoneyOrLevel(amount, 0));
                    break;
                case PickupType.LEVEL:
                    StartCoroutine(MoneyOrLevel(0, amount));
                    break;
                case PickupType.ITEM:
                    StartCoroutine(AddItem(new DBItem(itemName, itemDescription, itemCategory, iconName)));
                    break;
            }
            ArenaSaver.pickedUpItems.Add(gameObject.name);
            Destroy(gameObject);
        }
    }

    private IEnumerator MoneyOrLevel(int money, int level)
    {
        var request = new UnityWebRequest("http://localhost:8080/characters/updatestats", "POST");
    
        var json = JsonUtility.ToJson(new CharactersUpgrader(PlayerCharacter.characterList.characters[CharacterLoader.characterIndex].character_uuid, money, level));
        byte[] jsonToSend = new System.Text.UTF8Encoding().GetBytes(json);

        request.uploadHandler = new UploadHandlerRaw(jsonToSend);
        request.downloadHandler = new DownloadHandlerBuffer();
        request.SetRequestHeader("Content-Type", "application/json");
        request.SetRequestHeader("Authorization", "Bearer " + PlayerCharacter.token);
    
        yield return request.SendWebRequest();

        if (request.result != UnityWebRequest.Result.Success)
        {
            yield break;
        }
    }

    private IEnumerator AddItem(DBItem dbItem)
    {
        dbItem.character_uuid = PlayerCharacter.characterList.characters[CharacterLoader.characterIndex].character_uuid;
        var request = new UnityWebRequest("http://localhost:8080/inventory/add", "POST");
        
        var json = JsonUtility.ToJson(dbItem);
        byte[] jsonToSend = new System.Text.UTF8Encoding().GetBytes(json);

        request.uploadHandler = new UploadHandlerRaw(jsonToSend);
        request.downloadHandler = new DownloadHandlerBuffer();
        request.SetRequestHeader("Content-Type", "application/json");
        request.SetRequestHeader("Authorization", "Bearer " + PlayerCharacter.token);
    
        yield return request.SendWebRequest();

        if (request.result != UnityWebRequest.Result.Success)
        {
            yield break;
        }
    }
}

[Serializable]
class CharactersUpgrader
{
    public string character_uuid;
    public int money;
    public int level;

    public CharactersUpgrader(string characterUuid, int money, int level)
    {
        character_uuid = characterUuid;
        this.money = money;
        this.level = level;
    }
}
public enum PickupType
{
    MONEY, LEVEL, ITEM
};