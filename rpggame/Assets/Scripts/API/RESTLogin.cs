using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Networking;
using UnityEngine.UI;

public class RESTLogin : MonoBehaviour
{
    [SerializeField] private string url = "http://localhost:8080/login";
    [SerializeField] private GameObject activeUI;
    [SerializeField] private GameObject errorPanel;
    private SceneNavigator sceneNavigator;
    [SerializeField] public String login;
    [SerializeField] public String password;
    

    private void Start()
    {
        sceneNavigator = GetComponent<SceneNavigator>();
    }
    
    public void LogIn()
    {
        StartCoroutine(SendLoginRequest());
    }

    private IEnumerator GetUser()
    {
        var request = UnityWebRequest.Get("http://localhost:8080/users/" + login + "/" + password);
        yield return request.SendWebRequest();
        
        User user = JsonUtility.FromJson<User>(request.downloadHandler.text);
        
        PlayerCharacter.user = user;
        PlayerCharacter.user.password = password;
    }

    private IEnumerator SendLoginRequest()
    {
        var request = new UnityWebRequest(url, "POST");

        yield return StartCoroutine(GetUser());
        
        var json = JsonUtility.ToJson(PlayerCharacter.user);
        byte[] jsonToSend = new System.Text.UTF8Encoding().GetBytes(json);
        request.uploadHandler = new UploadHandlerRaw(jsonToSend);
        request.downloadHandler = new DownloadHandlerBuffer();
        request.SetRequestHeader("Content-Type", "application/json");

        yield return request.SendWebRequest();
        
        if (request.result != UnityWebRequest.Result.Success)
        {
            switch (request.responseCode)
            {
                case 0:
                    SceneNavigator.openErrorPanel(errorPanel, activeUI, "Игровой сервер недоступен!");
                    break;
                case 401:
                    SceneNavigator.openErrorPanel(errorPanel, activeUI, "Неверный логин или пароль!");
                    break;
                default:
                    SceneNavigator.openErrorPanel(errorPanel, activeUI, "Неизвестная ошибка!");
                    break;
            }

        }
        else if(request.result == UnityWebRequest.Result.Success)
        {
            PlayerCharacter.token = request.downloadHandler.text;
            sceneNavigator.openScene("Main");
        }
    }

    public string Login
    {
        get => login;
        set => login = value;
    }

    public string Password
    {
        get => password;
        set => password = value;
    }
}

