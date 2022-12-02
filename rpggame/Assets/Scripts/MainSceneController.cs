using System.Collections;
using System.Collections.Generic;
using TMPro;
using UnityEngine;

public class MainSceneController : MonoBehaviour
{
    public TextMeshPro nickname;
    
    public void Start()
    {
        nickname.text = PlayerCharacter.user.login;
    }
}
