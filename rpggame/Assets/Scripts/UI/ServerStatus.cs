using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Networking;
using UnityEngine.UI;

public class ServerStatus : MonoBehaviour
{
    public bool isServerUp = false;
    public Image OK;
    public Image NotOK;
    
    void Start()
    {
        StartCoroutine(checkServer());
    }
    
    void Update()
    {
        OK.enabled = isServerUp;
        NotOK.enabled = !isServerUp;
    }
    
    IEnumerator checkServer()
    {
        while (true)
        {
            var request = new UnityWebRequest("http://localhost:8080/serverstatus", "GET");
            yield return request.SendWebRequest();

            isServerUp = request.result == UnityWebRequest.Result.Success;

            yield return new WaitForSeconds(5);
        }
    }
}
