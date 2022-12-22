using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using TMPro;
using UnityEngine;
using UnityEngine.SceneManagement;
using UnityEngine.UI;

public class MainSceneController : MonoBehaviour
{
    [Header("Friends")]
    public GameObject friendsPanel;
    public GameObject friendOpenButton;
    public GameObject friendCloseButton;
    public GameObject friendInputPlaceholder;
    public TMP_InputField friendInputField;

    public GameObject friendContent;
    public GameObject friendPrefab;

    private bool friendsIsOpen = false;
    private RESTStatus statusScript;
    
    public void InputFieldError(int delay, string message)
    {
        StartCoroutine(InputFieldErrorCoroutine(delay, message));
    }

    IEnumerator InputFieldErrorCoroutine(int delay, string message)
    {
        friendInputField.text = "";
        friendInputPlaceholder.GetComponent<TextMeshProUGUI>().text = message;
        friendInputPlaceholder.GetComponent<TextMeshProUGUI>().color = Color.red;
        yield return new WaitForSeconds(delay);
        friendInputPlaceholder.GetComponent<TextMeshProUGUI>().text = "Введите имя...";
        friendInputPlaceholder.GetComponent<TextMeshProUGUI>().color = Color.white;
    }


    public void UpdateFriendsOnUI()
    {
        if(!friendsIsOpen) return;
        
        RESTFriend friend = GetComponent<RESTFriend>();

        GameObject.FindGameObjectsWithTag("Friend").ToList().ForEach(f => Destroy(f));
        foreach (Friend f in friend.friends.friends)
        {
            GameObject friendObject = Instantiate(friendPrefab, friendContent.transform);
            foreach (TextMeshProUGUI text in friendObject.GetComponentsInChildren<TextMeshProUGUI>())
            {
                if (text.text.Equals("NICKNAME"))
                {
                    text.text = f.friend_name;
                }
                if (text.text.Equals("STATUS"))
                {
                    statusScript.GetStatus(f.friend_uuid);
                    if(!statusScript.statuses.ContainsKey(f.friend_uuid)) statusScript.statuses.Add(f.friend_uuid, "Неизвестно");


                    switch (statusScript.statuses[f.friend_uuid])
                    {
                        case "ARENA":
                            text.text = "На арене";
                            text.color = Color.white;
                            break;
                        case "MAIN_MENU":
                            text.text = "В главном меню";
                            text.color = Color.white;
                            break;
                        case "NOT_IN_GAME":
                            text.text = "Не в игре";
                            text.color = Color.gray;
                            break;
                    }

                }
            }
            friendObject.GetComponentInChildren<Button>().onClick.AddListener(() => friend.removeFriendVoid(f.friend_name));
        }
    }

    public void ToggleFriends()
    {
        UpdateFriendsOnUI();
        friendsIsOpen = !friendsIsOpen;
        friendsPanel.SetActive(friendsIsOpen);
        if (friendsIsOpen)
        {
            friendOpenButton.SetActive(false);
            friendCloseButton.SetActive(true);
            
            chatOpenButton.SetActive(false);
        }
        else
        {
            friendOpenButton.SetActive(true);
            friendCloseButton.SetActive(false);
            
            chatOpenButton.SetActive(true);
        }
    }
    
    
    
    [Header("Chat")]
    public GameObject chatPanel;
    public GameObject chatOpenButton;
    public GameObject chatCloseButton;
    public Image chatButtonImage;
    private bool chatIsOpen = false;
    
    public void ToggleChat()
    {
        chatIsOpen = !chatIsOpen;
        chatPanel.SetActive(chatIsOpen);
        if (chatIsOpen)
        {
            chatOpenButton.SetActive(false);
            chatCloseButton.SetActive(true);
            
            friendOpenButton.SetActive(false);
        }
        else
        {
            chatOpenButton.SetActive(true);
            chatCloseButton.SetActive(false);
            
            friendOpenButton.SetActive(true);
        }
    }
    
    
    [Header("Nickname")]
    public TextMeshPro nickname;
    public void Start()
    {
        nickname.text = PlayerCharacter.user.login;
        statusScript = GetComponent<RESTStatus>();
    }
    
    
    /*scene*/
    public void openScene(String scene)
    {
        SceneManager.LoadScene(scene);
        
    }
}
