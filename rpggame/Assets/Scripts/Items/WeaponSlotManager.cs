using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class WeaponSlotManager : MonoBehaviour
{
    WeaponHolderScript leftHandSlot;
    WeaponHolderScript rightHandSlot;
    
    DamageCollider leftHandDamageCollider;
    DamageCollider rightHandDamageCollider;


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
            LoadLeftWeaponDamageCollider();
        }
        else
        {
            rightHandSlot.LoadWeaponModel(weaponItem);
            LoadRightWeaponDamageCollider();
        }
    }

    #region Handle Weapon Damage Collider
    private void LoadLeftWeaponDamageCollider()
    {
        leftHandDamageCollider = leftHandSlot.currentWeaponModel.GetComponentInChildren<DamageCollider>();
    }
    
    private void LoadRightWeaponDamageCollider()
    {
        rightHandDamageCollider = rightHandSlot.currentWeaponModel.GetComponentInChildren<DamageCollider>();
    }

    public void OpenLeftDamageCollider()
    {
        leftHandDamageCollider.EnableDamageCollider();
    }
    public void OpenRightDamageCollider()
    {
        rightHandDamageCollider.EnableDamageCollider();
    }
    
    public void CloseLeftDamageCollider()
    {
        leftHandDamageCollider.DisableDamageCollider();
    }
    public void CloseRightDamageCollider()
    {
        rightHandDamageCollider.DisableDamageCollider();
    }
    #endregion
}
