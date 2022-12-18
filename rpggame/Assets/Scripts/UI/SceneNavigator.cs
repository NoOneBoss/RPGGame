using System;
using TMPro;
using UnityEngine;
using UnityEngine.SceneManagement;

public class SceneNavigator : MonoBehaviour
{
    public void openScene(String scene)
    {
        SceneManager.LoadScene(scene);
    }
    
    public static void openErrorPanel(GameObject errorPanel, GameObject activePanel, string errorMessage)
    {
        errorPanel.SetActive(true);
        activePanel.SetActive(false);
        errorPanel.GetComponentInChildren<TextMeshProUGUI>().text = errorMessage;
    }

}
