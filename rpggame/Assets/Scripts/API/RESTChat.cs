using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using JetBrains.Annotations;
using TMPro;
using UnityEngine;
using UnityEngine.Networking;
using UnityEngine.UI;

public class RESTChat : MonoBehaviour
{
    [SerializeField] public String message;
    [SerializeField] public TextMeshProUGUI text;
    [SerializeField] public TMP_InputField inputField;
    void Start()
    {
        StartCoroutine(GetMessages());
    }

    public void SendMessageToChat()
    {
        if(message.Length == 0)
        {
            return;
        }
        StartCoroutine(SendMessage());
    }

    IEnumerator GetMessages()
    {
        while (true)
        {
            UnityWebRequest getRequest = UnityWebRequest.Get("http://localhost:8080/chat/messages");
            getRequest.SetRequestHeader("Authorization", "Bearer " + PlayerCharacter.token);
            getRequest.downloadHandler = new DownloadHandlerBuffer();
        
            yield return getRequest.SendWebRequest();

            if (getRequest.result != UnityWebRequest.Result.Success)
            {
                continue;
            }
 
            ChatMessages messages = JsonUtility.FromJson<ChatMessages>("{\"messages\":" + getRequest.downloadHandler.text + "}");
            text.text = messages.messages.Aggregate("", (current, chatMessage) => current + (chatMessage.sender + ": " + chatMessage.message + "\n"));
        

            yield return new WaitForSeconds(1);
        }
    }

    public IEnumerator SendMessage()
    {
        var request = new UnityWebRequest("http://localhost:8080/chat/send", "POST");
        
        var json = JsonUtility.ToJson(new ChatMessage(PlayerCharacter.user.login, message));
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
        
        message = "";
        inputField.text = "";
    }

    

    public string Message
    {
        get => message;
        set => message = value;
    }
}

[Serializable]
public class ChatMessages
{
    public ChatMessage[] messages;
}

[Serializable]
public class ChatMessage
{
    public string sender;
    public string message;

    public ChatMessage(string sender, string message)
    {
        this.sender = sender;
        this.message = message;
    }
}
