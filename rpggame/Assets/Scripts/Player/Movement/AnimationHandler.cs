using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class AnimationHandler : MonoBehaviour
{
    public Animator animator;
    public InputHandler inputHandler;
    public PlayerMovement playerController;
    public PlayerManager playerManager;
    private int vertical;
    private int horizontal;
    public bool canRotate;
    
    public void Inititalize()
    {
        animator = GetComponent<Animator>();
        inputHandler = GetComponentInParent<InputHandler>();
        playerController = GetComponentInParent<PlayerMovement>();
        playerManager = GetComponentInParent<PlayerManager>();
        
        vertical = Animator.StringToHash("Vertical");
        horizontal = Animator.StringToHash("Horizontal");
    }

    public void UpdateAnimatorValues(float verticalMovement, float horizontalMovement, bool isSprinting)
    {
        #region Vertical
        float v = 0;
        
        if(verticalMovement > 0 && verticalMovement < 0.55f)
        {
            v = 0.5f;
        }
        else if(verticalMovement > 0.55f)
        {
            v = 1;
        }
        else if(verticalMovement < 0 && verticalMovement > -0.55f)
        {
            v = -0.5f;
        }
        else if(verticalMovement < -0.55f)
        {
            v = -1;
        }
        #endregion
        #region Horizontal
        float h = 0;
        
        if(horizontalMovement > 0 && horizontalMovement < 0.55f)
        {
            h = 0.5f;
        }
        else if(horizontalMovement > 0.55f)
        {
            h = 1;
        }
        else if(horizontalMovement < 0 && horizontalMovement > -0.55f)
        {
            h = -0.5f;
        }
        else if(horizontalMovement < -0.55f)
        {
            h = -1;
        }
        

        #endregion

        if (isSprinting)
        {
            v = 2;
            h = horizontalMovement;
        }
        
        animator.SetFloat(vertical, v, 0.1f, Time.deltaTime);
        animator.SetFloat(horizontal, h, 0.1f, Time.deltaTime);
    }
    
    public void PlayTargetAnimation(string targetAnimation, bool isInteracting)
    {
        animator.applyRootMotion = isInteracting;
        animator.SetBool("isInteracting", isInteracting);
        animator.CrossFade(targetAnimation, 0.2f);
    }
    
    public void CanRotate()
    {
        canRotate = true;
    }
    
    public void StopRotation()
    {
        canRotate = false;
    }

    private void OnAnimatorMove()
    {
        if(playerManager.isInteracting == false) return;
        
        float delta = Time.deltaTime;
        playerController.rigidbody.drag = 0;
        Vector3 deltaPosition = animator.deltaPosition;
        deltaPosition.y = 0;
        Vector3 velocity = deltaPosition / delta;
        playerController.rigidbody.velocity = velocity;
    }
}