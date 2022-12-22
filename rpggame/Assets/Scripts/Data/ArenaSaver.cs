using System;
using System.Collections;
using System.Collections.Generic;
using Unity.VisualScripting;
using UnityEngine;
using UnityEngine.Networking;

public class ArenaSaver : MonoBehaviour
{
    public CharacterLoader characterLoader;
    public PlayerStats playerStats;
    public Transform player;
    public Transform camera;
    public Transform cameraPivot;
    public void OnApplicationQuit()
    {
        ArenaSave save = new ArenaSave(PlayerCharacter.characterList.characters[characterLoader.characterIndex].character_uuid,
            playerStats.currentHealth, player.position, player.rotation.eulerAngles,
            camera.position, camera.rotation.eulerAngles, cameraPivot.rotation.eulerAngles);
        StartCoroutine(Save(save));
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

    public ArenaSave(string characterUuid, int health, Vector3 characterPosition, Vector3 characterRotation, Vector3 cameraPosition, Vector3 cameraRotation, Vector3 cameraPivotRotation)
    {
        character_uuid = characterUuid;
        this.health = health;
        character_position = characterPosition;
        character_rotation = characterRotation;
        camera_position = cameraPosition;
        camera_rotation = cameraRotation;
        camera_pivot_rotation = cameraPivotRotation;
    }
}