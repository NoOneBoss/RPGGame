using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[CreateAssetMenu(menuName = "Items/Weapon Item")]
public class WeaponItem : Item
{
    public GameObject weaponPrefab;
    public bool isUnarmed;


    [Header("One Handed Attack")] 
    public string OneHandLightAttack;
    public string OneHandHeavyAttack;
    
    
}
