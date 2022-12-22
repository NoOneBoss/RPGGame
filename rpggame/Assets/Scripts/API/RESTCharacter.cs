using System;
using System.Collections;
using System.Linq;
using Unity.VisualScripting;
using UnityEngine;
using UnityEngine.Networking;

public class RESTCharacter : MonoBehaviour
{
    public void GetCharacter()
    {
        StartCoroutine(GetCharacters());
    }
    
    public void PostCharacter(CharacterSkin characterSkin)
    {
        StartCoroutine(AddCharacter(characterSkin));
    }

    public IEnumerator GetCharacters()
    {
        yield return new WaitForSeconds(2);
        UnityWebRequest getRequest = UnityWebRequest.Get("http://localhost:8080/characters/" + PlayerCharacter.user.user_uuid);
        getRequest.SetRequestHeader("Authorization", "Bearer " + PlayerCharacter.token);
        getRequest.downloadHandler = new DownloadHandlerBuffer();
        
        yield return getRequest.SendWebRequest();

        if (getRequest.result != UnityWebRequest.Result.Success)
        {
            yield break;
        }
 
        CharacterList characterList = JsonUtility.FromJson<CharacterList>("{\"characters\":" + getRequest.downloadHandler.text + "}");
        PlayerCharacter.characterList = characterList;
        
        if(GetComponent<SceneNavigator>() != null) GetComponent<SceneNavigator>().openScene("Main");
    }

    public IEnumerator AddCharacter(CharacterSkin characterSkin)
    {
        var request = new UnityWebRequest("http://localhost:8080/characters/create", "POST");
        
        var json = JsonUtility.ToJson(characterSkin);
        byte[] jsonToSend = new System.Text.UTF8Encoding().GetBytes(json);
        
        request.uploadHandler = new UploadHandlerRaw(jsonToSend);
        request.downloadHandler = new DownloadHandlerBuffer();
        request.SetRequestHeader("Content-Type", "application/json");
        request.SetRequestHeader("Authorization", "Bearer " + PlayerCharacter.token);
        
        yield return request.SendWebRequest();
    }

}


