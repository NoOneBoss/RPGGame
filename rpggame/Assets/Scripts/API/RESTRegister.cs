using System;
using System.Collections;
using System.Collections.Generic;
using TMPro;
using UnityEngine;
using UnityEngine.Networking;
using UnityEngine.UI;

public class RESTRegister : MonoBehaviour
{
    [SerializeField] private string url = "http://localhost:8080/register";
    [SerializeField] private GameObject activeUI;
    [SerializeField] private GameObject errorPanel;
    
    private SceneNavigator sceneNavigator;
    [SerializeField] public String login;
    [SerializeField] public String password;


    private void Start()
    {
        sceneNavigator = GetComponent<SceneNavigator>();
    }
    
    public void Register()
    {
        StartCoroutine(SendRegisterRequest());
    }

    private IEnumerator SendRegisterRequest()
    {
        var request = new UnityWebRequest(url, "POST");
        
        var json = JsonUtility.ToJson(new User(Guid.NewGuid().ToString(), login, password, "player"));
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
                    SceneNavigator.openErrorPanel(errorPanel, activeUI, "Такой аккаунт уже существует!");
                    break;
                default:
                    SceneNavigator.openErrorPanel(errorPanel, activeUI, "Неизвестная ошибка!");
                    break;
            }

        }
        else
        {
            sceneNavigator.openScene("AuthScene");
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
