
using System;
using System.Linq;
using UnityEngine;

public class SpriteContainer : MonoBehaviour
{
    public static Sprite[] weapons;
    public static Sprite[] armors;

    void SetupSprites()
    {
        weapons = Resources.LoadAll("Icons/weapons", typeof(Sprite)).Cast<Sprite>().ToArray();
        armors = Resources.LoadAll("Icons/armor", typeof(Sprite)).Cast<Sprite>().ToArray();
    }

    private void Start()
    {
        if(weapons == null || armors == null)
        {
            SetupSprites();
        }
        
        Debug.Log(weapons.Length);
        Debug.Log(armors.Length);
    }
}