using System;
using System.Collections;
using System.Linq;
using Unity.VisualScripting;
using UnityEngine;
using UnityEngine.Networking;

public class RESTFriend : MonoBehaviour
{
    public Friends friends;
    
    private String addLogin;
    private string addFriend;

    private String removeLogin;
    private string removeFriend;
    
    public void Start()
    {
        StartCoroutine(GetFriends());
    }

    public void addFriendVoid()
    {
        StartCoroutine(AddFriend());
    }
    
    public void removeFriendVoid(String rLogin)
    {
        removeLogin = rLogin;
        StartCoroutine(RemoveFriend());
    }
    
    private IEnumerator GetFriends()
    {
        while (true)
        {
            StartCoroutine(GetFriendsInstantly());
            yield return new WaitForSeconds(3);
        }
    }

    public IEnumerator GetFriendsInstantly()
    {
        UnityWebRequest getRequest = UnityWebRequest.Get("http://localhost:8080/friends/" + PlayerCharacter.user.user_uuid);
        getRequest.SetRequestHeader("Authorization", "Bearer " + PlayerCharacter.token);
        getRequest.downloadHandler = new DownloadHandlerBuffer();
        
        yield return getRequest.SendWebRequest();

        if (getRequest.result != UnityWebRequest.Result.Success)
        {
            yield break;
        }
 
        friends = JsonUtility.FromJson<Friends>("{\"friends\":" + getRequest.downloadHandler.text + "}");
        friends.friends.Where(friend => friend.friend_uuid == PlayerCharacter.user.user_uuid).ToList().ForEach(f => f.swapData());
        GetComponent<MainSceneController>().UpdateFriendsOnUI();
    }

    public IEnumerator AddFriend()
    {
        yield return StartCoroutine(GetUserUUIDByLoginToAdd());
        GetComponent<MainSceneController>().friendInputField.text = "";
        
        var request = new UnityWebRequest("http://localhost:8080/friends/add", "POST");
        
        var json = "{\"user_uuid\":\"" + PlayerCharacter.user.user_uuid + "\",\"friend_uuid\":\"" + addFriend + "\"}";
        byte[] jsonToSend = new System.Text.UTF8Encoding().GetBytes(json);
        request.uploadHandler = new UploadHandlerRaw(jsonToSend);
        request.downloadHandler = new DownloadHandlerBuffer();
        request.SetRequestHeader("Content-Type", "application/json");
        request.SetRequestHeader("Authorization", "Bearer " + PlayerCharacter.token);
        
        yield return request.SendWebRequest();

        if (request.result != UnityWebRequest.Result.Success)
        {
            if (request.responseCode == 403)
            {
                GetComponent<MainSceneController>().InputFieldError(3, "Вы не можете добавить себя в друзья!");
                yield break;
            }
            if (request.responseCode == 409)
            {
                GetComponent<MainSceneController>().InputFieldError(3, "Этот пользователь уже в вашем списке друзей!");
                yield break;
            }
        }
        
        GetComponent<MainSceneController>().UpdateFriendsOnUI();
    }

    public IEnumerator RemoveFriend()
    {
        yield return StartCoroutine(GetUserUUIDByLoginToRemove());
        
        var request = new UnityWebRequest("http://localhost:8080/friends/remove", "POST");
        
        var json = "{\"user_uuid\":\"" + PlayerCharacter.user.user_uuid + "\",\"friend_uuid\":\"" + removeFriend + "\"}";
        byte[] jsonToSend = new System.Text.UTF8Encoding().GetBytes(json);
        
        request.uploadHandler = new UploadHandlerRaw(jsonToSend);
        request.downloadHandler = new DownloadHandlerBuffer();
        request.SetRequestHeader("Content-Type", "application/json");
        request.SetRequestHeader("Authorization", "Bearer " + PlayerCharacter.token);
        
        yield return request.SendWebRequest();
    }
    
    private IEnumerator GetUserUUIDByLoginToAdd()
    {
        var request = UnityWebRequest.Get("http://localhost:8080/users/login/" + addLogin);
        request.SetRequestHeader("Authorization", "Bearer " + PlayerCharacter.token);
        yield return request.SendWebRequest();

        if (request.result != UnityWebRequest.Result.Success)
        {
            yield break;
        }
        
        addFriend = request.downloadHandler.text;
    }
    private IEnumerator GetUserUUIDByLoginToRemove()
    {
        var request = UnityWebRequest.Get("http://localhost:8080/users/login/" + removeLogin);
        request.SetRequestHeader("Authorization", "Bearer " + PlayerCharacter.token);
        yield return request.SendWebRequest();
        
        if (request.result != UnityWebRequest.Result.Success)
        {
            yield break;
        }
        removeFriend = request.downloadHandler.text;
    }

    public string AddLogin
    {
        get => addLogin;
        set => addLogin = value;
    }
}

[Serializable]
public class Friends
{
    public Friend[] friends;
}

[Serializable]
public class Friend
{
    public string user_uuid;
    public string user_name;
    public string friend_uuid;
    public string friend_name;
    public string friend_date;

    public void swapData()
    {
        var temp = user_uuid;
        user_uuid = friend_uuid;
        friend_uuid = temp;
        
        temp = user_name;
        user_name = friend_name;
        friend_name = temp;
    }
}

