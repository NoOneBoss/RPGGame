using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class WeaponHolderScript : MonoBehaviour
{
    public Transform parentOverride;
    public bool isLeftHand;
    public bool isRightHand;

    public GameObject currentWeaponModel;


    public void UnloadWeaponModel()
    {
        if(currentWeaponModel != null)
        {
            currentWeaponModel.SetActive(false);
        }
    }

    public void UnloadWeaponAndDestroy()
    {
        if(currentWeaponModel != null)
        {
            Destroy(currentWeaponModel);
        }
    }

    public void LoadWeaponModel(WeaponItem weaponItem)
    {
        UnloadWeaponAndDestroy();
        
        if(weaponItem == null)
        {
            UnloadWeaponModel();
            return;
        }
        
        GameObject weaponModel = Instantiate(weaponItem.weaponPrefab, parentOverride) as GameObject;
        if(weaponModel == null)
        {
            if(parentOverride != null)
            {
                weaponModel.transform.parent = parentOverride;
            }
            else
            {
                weaponModel.transform.parent = transform;
            }
            
            weaponModel.transform.localPosition = Vector3.zero;
            weaponModel.transform.localRotation = Quaternion.identity;
            weaponModel.transform.localScale = Vector3.one;
        }
        
        currentWeaponModel = weaponModel;
    }
}
