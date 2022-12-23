using System;
using System.Collections;
using System.Collections.Generic;
using System.Text.RegularExpressions;
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
    
    private int iPasswordScore = 0;
    public Slider slider;
    public Gradient gradient;
    public Image fill;


    private void Start()
    {
        slider.maxValue = 10;
        sceneNavigator = GetComponent<SceneNavigator>();
    }
    
    public void Register()
    {
        if(login == "" || password == "")
        {
            SceneNavigator.openErrorPanel(errorPanel, activeUI, "Вы не ввели логин/пароль!");
            return;
        }

        if (login.Length < 8)
        {
            SceneNavigator.openErrorPanel(errorPanel, activeUI, "Минимальная длина логина - 8!");
            return;
        }

        if (iPasswordScore <= 5)
        {
            SceneNavigator.openErrorPanel(errorPanel, activeUI, "Ваш пароль слишком слабый! Используйте разный регистр, цифры и спецсимволы!");
            return;
        }
        
        
        
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
    
    public void calculatePasswordStrength() {
        iPasswordScore = 0;
        if (password.Length < 8)
        {
            iPasswordScore = 0;
            return;
        }
        if (password.Length  >= 10) {
            iPasswordScore += 2;
        }
        else {
            iPasswordScore++;
        }
        Regex numRegex = new Regex("(?=.*[0-9]).*");
        Regex lowRegex = new Regex("(?=.*[a-z]).*");
        Regex upRegex = new Regex("(?=.*[A-Z]).*");
        Regex specRegex = new Regex("(?=.*[~!@#$%^&*()_-]).*");
        
        if (numRegex.Matches(password).Count > 0) {
            iPasswordScore += 2;
        }
        
        if (lowRegex.Matches(password).Count > 0) {
            iPasswordScore += 2;
        }
        
        if (upRegex.Matches(password).Count > 0) {
            iPasswordScore += 2;
        }
        
        if (specRegex.Matches(password).Count > 0) {
            iPasswordScore += 2;
        }
        
        slider.value = iPasswordScore;
        fill.color = gradient.Evaluate(slider.normalizedValue);
    }
}
