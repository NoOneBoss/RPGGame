using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Networking;
public class RESTStatus : MonoBehaviour
{
    public SessionStatusEnum status;
    [HideInInspector] public Dictionary<string,string> statuses = new Dictionary<string, string>();

    public void Start()
    {
        UpdateStatus();
    }

    public void OnApplicationQuit()
    {
        status = SessionStatusEnum.NOT_IN_GAME;
        UpdateStatus();
    }

    public void UpdateStatus()
    {
        StartCoroutine(UpdateStatusOfPlayer(status));
    }

    public void GetStatus(string uuid)
    {
        StartCoroutine(getStatusOfPlayer(uuid));
    }

    private IEnumerator UpdateStatusOfPlayer(SessionStatusEnum status)
    {
        var request = new UnityWebRequest("http://localhost:8080/status/update", "POST");
    
        var json = JsonUtility.ToJson(new Status(PlayerCharacter.user.user_uuid, status.ToString()));
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

    private IEnumerator getStatusOfPlayer(string uuid)
    {
        var request = UnityWebRequest.Get("http://localhost:8080/status/" + uuid);
        request.SetRequestHeader("Authorization", "Bearer " + PlayerCharacter.token);
        yield return request.SendWebRequest();
        
        if (request.result != UnityWebRequest.Result.Success)
        {
            yield break;
        }
        
        if(statuses.ContainsKey(uuid)) statuses.Remove(uuid);
        statuses.Add(uuid, JsonUtility.FromJson<Status>(request.downloadHandler.text).status);
    }
}

[Serializable]
public class Status
{
    public string user_uuid;
    public string status;

    public Status(string user_uuid, string status)
    {
        this.user_uuid = user_uuid;
        this.status = status;
    }
}

[Serializable]
public enum SessionStatusEnum {
    MAIN_MENU,
    ARENA,
    NOT_IN_GAME
}
    