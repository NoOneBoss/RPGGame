using System;
using System.Collections;
using UnityEngine;
using UnityEngine.Networking;
public class RESTStatus : MonoBehaviour
{
    public void UpdateStatus(SessionStatusEnum status)
    {
        StartCoroutine(UpdateStatusOfPlayer(status));
    }

    private IEnumerator UpdateStatusOfPlayer(SessionStatusEnum status)
    {
        var request = new UnityWebRequest("http://localhost:8080/status/update", "POST");
    
        var json = JsonUtility.ToJson(new Status(PlayerCharacter.user.user_uuid, status));
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
public class Status
{
    private string uuid;
    SessionStatusEnum status;

    public Status(string uuid, SessionStatusEnum status)
    {
        this.uuid = uuid;
        this.status = status;
    }
}

[Serializable]
public enum SessionStatusEnum {
    MAIN_MENU,
    ARENA,
    NOT_IN_GAME
}
    