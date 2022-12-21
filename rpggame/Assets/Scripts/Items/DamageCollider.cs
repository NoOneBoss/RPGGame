using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class DamageCollider : MonoBehaviour
{
    Collider damageCollider;
    public int currentWeaponDamage;
    
    private void Awake()
    {
        damageCollider = GetComponent<Collider>();
        damageCollider.gameObject.SetActive(true);
        
        damageCollider.isTrigger = true;
        damageCollider.enabled = false;
    }
    
    public void EnableDamageCollider()
    {
        damageCollider.enabled = true;
    }
    
    public void DisableDamageCollider()
    {
        damageCollider.enabled = false;
    }
    
    private void OnTriggerEnter(Collider collision)
    {
        if (collision.CompareTag("Hittable"))
        {
            PlayerStats playerStats = collision.GetComponent<PlayerStats>();
            EnemyStats enemyStats = collision.GetComponent<EnemyStats>();
            
            if(playerStats != null) playerStats.TakeDamage(currentWeaponDamage);
            if(enemyStats != null) enemyStats.TakeDamage(currentWeaponDamage);
        }
    }
}
