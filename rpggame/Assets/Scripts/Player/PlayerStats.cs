using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PlayerStats : MonoBehaviour
{
    public int healthLevel = 10;
    public int maxHealth;
    public int currentHealth;
    
    public HealthBar healthBar;
    private AnimationHandler animationHandler;
    
    public void Start()
    {
        animationHandler = GetComponentInChildren<AnimationHandler>();
        
        SetMaxHealth();
        currentHealth = maxHealth;
        healthBar.SetMaxHealth(maxHealth);
    }
    
    private void SetMaxHealth()
    {
        maxHealth = healthLevel * 10;
    }

    public void TakeDamage(int damage)
    {
        currentHealth -= damage;
        healthBar.SetHealth(currentHealth);

        if (currentHealth <= 0)
        {
            currentHealth = 0;
            animationHandler.PlayTargetAnimation("Death", true);
        }
    }
}
