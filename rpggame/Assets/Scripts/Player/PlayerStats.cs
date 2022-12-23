using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;

public class PlayerStats : MonoBehaviour
{
    public int healthLevel = 10;
    public int maxHealth;
    public int currentHealth;
    
    public HealthBar healthBar;
    private AnimationHandler animationHandler;
    public GameObject controller;

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
            healthBar.diedscreen.enabled = true;
            healthBar.diedscreen.gameObject.SetActive(true);
            StartCoroutine(Die());
            controller.GetComponent<ArenaSaver>().InstantSave();
        }
    }
    
    private IEnumerator Die()
    {
        yield return new WaitForSeconds(5f);
        SceneManager.LoadScene("Main");
    }
}
