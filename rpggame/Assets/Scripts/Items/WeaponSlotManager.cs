using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class WeaponSlotManager : MonoBehaviour
{
    WeaponHolderScript leftHandSlot;
    WeaponHolderScript rightHandSlot;


    private void Awake()
    {
        WeaponHolderScript[] weaponHolderScripts = GetComponentsInChildren<WeaponHolderScript>();
        foreach (WeaponHolderScript weaponHolderScript in weaponHolderScripts)
        {
            if(weaponHolderScript.isLeftHand)
            {
                leftHandSlot = weaponHolderScript;
            }
            else if(weaponHolderScript.isRightHand)
            {
                rightHandSlot = weaponHolderScript;
            }
        }
    }
    
    public void LoadWeaponOnSlot(WeaponItem weaponItem, bool isLeft)
    {
        if(isLeft)
        {
            leftHandSlot.LoadWeaponModel(weaponItem);
        }
        else
        {
            rightHandSlot.LoadWeaponModel(weaponItem);
        }
    }
}
