using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PlayerAttacker : MonoBehaviour
{
    AnimationHandler animationHandler;

    public void Awake()
    {
        animationHandler = GetComponentInChildren<AnimationHandler>();
    }

    public void HandleLightAttack(WeaponItem weapon)
    {
        animationHandler.PlayTargetAnimation(weapon.OneHandLightAttack, true);
    }
    
    public void HandleHeavyAttack(WeaponItem weapon)
    {
        animationHandler.PlayTargetAnimation(weapon.OneHandHeavyAttack, true);
    }
}
