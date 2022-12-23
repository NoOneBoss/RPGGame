using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using TMPro;
using UnityEngine;
using UnityEngine.Networking;
using UnityEngine.SceneManagement;

public class InvManager : MonoBehaviour
{
    
    public static Inv inv;
    public GameObject itemPrefab;
    public GameObject invPanel;
    void Start()
    {
        StartCoroutine(UpdatingItems());
    }

    private void Update()
    {
        if (Input.GetKey(KeyCode.Escape))
        {
            SceneManager.LoadScene("Main");
        }
    }


    public IEnumerator GetItems()
    {
        StartCoroutine(getItemsCoroutine());
        yield return new WaitForSeconds(1);
        GameObject.FindGameObjectsWithTag("DBItem").ToList().ForEach(f => Destroy(f));
        foreach (DBItem invItem in inv.items)
        {
            Debug.Log(JsonUtility.ToJson(invItem));
            GameObject itemObject = Instantiate(itemPrefab, invPanel.transform);
            itemObject.GetComponent<InvItem>().LoadItem(invItem);
            foreach (TextMeshProUGUI text in itemObject.GetComponentsInChildren<TextMeshProUGUI>())
            {
                if (text.text.Equals("ITEMNAME"))
                {
                    text.text = invItem.item_name;
                }
                if (text.text.Equals("ITEMCATEGORY"))
                {
                    text.text = invItem.item_category;
                }
                if (text.text.Equals("ITEMDESCRIPTION"))
                {
                    text.text = invItem.item_description;
                }
            }
        }
    }

    IEnumerator UpdatingItems()
    {
        while (true)
        {
            StartCoroutine(GetItems());
            yield return new WaitForSeconds(10);
        }
    }

    IEnumerator getItemsCoroutine()
    {
        var request = UnityWebRequest.Get("http://localhost:8080/inventory/" +  PlayerCharacter.characterList.characters[CharacterLoader.characterIndex].character_uuid);
        request.SetRequestHeader("Authorization", "Bearer " + PlayerCharacter.token);
        yield return request.SendWebRequest();
        
        if (request.result != UnityWebRequest.Result.Success)
        {
            yield break;
        }
        
        var json = request.downloadHandler.text;
        inv = JsonUtility.FromJson<Inv>("{\"items\":" + json + "}");
    }
}

[Serializable]
public class Inv
{
    public List<DBItem> items = new List<DBItem>();
}

