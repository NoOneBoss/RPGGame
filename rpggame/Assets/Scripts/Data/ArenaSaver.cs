using System;
using System.Collections;
using System.Collections.Generic;
using Unity.VisualScripting;
using UnityEngine;
using UnityEngine.Networking;
using UnityEngine.SceneManagement;

public class ArenaSaver : MonoBehaviour
{
    public PlayerStats playerStats;
    public Transform player;
    public Transform camera;
    public Transform cameraPivot;
    public static List<string> pickedUpItems = new List<string>();


    public void Update()
    {
        if (Input.GetKeyDown(KeyCode.Escape))
        {
            SceneManager.LoadScene("Main");
            InstantSave();
        }
    }

    public void OnApplicationQuit()
    {
        ArenaSave save = new ArenaSave(PlayerCharacter.characterList.characters[CharacterLoader.characterIndex].character_uuid,
            playerStats.currentHealth, player.position, player.rotation.eulerAngles,
            camera.position, camera.rotation.eulerAngles, cameraPivot.rotation.eulerAngles, String.Join(", ", pickedUpItems.ToArray()));
        StartCoroutine(Save(save));
    }

    public void InstantSave()
    {
        ArenaSave save = new ArenaSave(PlayerCharacter.characterList.characters[CharacterLoader.characterIndex].character_uuid,
            playerStats.currentHealth, player.position, player.rotation.eulerAngles,
            camera.position, camera.rotation.eulerAngles, cameraPivot.rotation.eulerAngles, String.Join(", ", pickedUpItems.ToArray()));
        StartCoroutine(Save(save));
    }

    public void Start()
    {
        StartCoroutine(Load());
    }
    
    IEnumerator Save(ArenaSave save)
    {
        var request = new UnityWebRequest("http://localhost:8080/arenastates/update", "POST");
    
        var json = JsonUtility.ToJson(save);
        Debug.Log(json);
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
    
    IEnumerator Load() {
        var request = UnityWebRequest.Get("http://localhost:8080/arenastates/" + PlayerCharacter.characterList.characters[CharacterLoader.characterIndex].character_uuid);
        request.SetRequestHeader("Authorization", "Bearer " + PlayerCharacter.token);
        yield return request.SendWebRequest();
        
        if (request.result != UnityWebRequest.Result.Success)
        {
            yield break;
        }
        
        var json = request.downloadHandler.text;
        if (json.Contains("null")) yield break;
        
        var save = JsonUtility.FromJson<ArenaSave>(json);
        
        playerStats.currentHealth = save.health;
        playerStats.healthBar.SetHealth(playerStats.currentHealth);
        player.position = save.character_position;
        player.rotation = Quaternion.Euler(save.character_rotation);
        camera.position = save.camera_position;
        camera.rotation = Quaternion.Euler(save.camera_rotation);
        cameraPivot.rotation = Quaternion.Euler(save.camera_pivot_rotation);
        pickedUpItems = new List<string>(save.picked_up_items.Split(", "));
    }
}


[Serializable]
public class ArenaSave
{
    public string character_uuid;
    public int health;
    public Vector3 character_position;
    public Vector3 character_rotation;
    public Vector3 camera_position;
    public Vector3 camera_rotation;
    public Vector3 camera_pivot_rotation;
    public string picked_up_items;

    public ArenaSave(string characterUuid, int health, Vector3 characterPosition, Vector3 characterRotation, Vector3 cameraPosition, Vector3 cameraRotation, Vector3 cameraPivotRotation, string pickedUpItems)
    {
        character_uuid = characterUuid;
        this.health = health;
        character_position = characterPosition;
        character_rotation = characterRotation;
        camera_position = cameraPosition;
        camera_rotation = cameraRotation;
        camera_pivot_rotation = cameraPivotRotation;
        picked_up_items = pickedUpItems;
    }
}