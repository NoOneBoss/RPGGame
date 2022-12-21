using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class EnemyStats : MonoBehaviour
{
    public int healthLevel = 1;
    public int maxHealth;
    public int currentHealth;
    
    private AnimationHandler animationHandler;
    
    public void Start()
    {
        animationHandler = GetComponent<AnimationHandler>();
        
        SetMaxHealth();
        currentHealth = maxHealth;
    }
    
    private void SetMaxHealth()
    {
        maxHealth = healthLevel * 10;
    }

    public void TakeDamage(int damage)
    {
        currentHealth -= damage;

        if (currentHealth <= 0)
        {
            currentHealth = 0;
            animationHandler.PlayTargetAnimation("Death", true);
        }
    }
}
