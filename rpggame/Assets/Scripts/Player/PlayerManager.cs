using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PlayerManager : MonoBehaviour
{
    private InputHandler inputHandler;
    private Animator animator;
    private PlayerMovement playerMovement;
    CameraHandler cameraHandler;
    
    public bool isInteracting;
    
    [Header("Flags")]
    public bool isSprinting;
    public bool isInAir;
    public bool isGrounded;
    
    void Start()
    {
        inputHandler = GetComponent<InputHandler>();
        playerMovement = GetComponent<PlayerMovement>();
        animator = GetComponentInChildren<Animator>();

        cameraHandler = CameraHandler.singleton;
    }
    
    void Update()
    {
        float delta = Time.deltaTime;
        
        isInteracting = animator.GetBool("isInteracting");
        
        inputHandler.TickInput(delta);
        playerMovement.HandleMovement(delta);
        playerMovement.HandleRollingAndSprinting(delta);
        playerMovement.HandleFalling(delta, playerMovement.moveDirection);
    }
    
    public void FixedUpdate()
    {
        float delta = Time.fixedDeltaTime;
        if(cameraHandler != null)
        {
            cameraHandler.FollowTarget(delta);
            cameraHandler.HandleCameraRotation(delta, inputHandler.mouseX, inputHandler.mouseY);
        }
    }

    public void LateUpdate()
    {
        inputHandler.rollFlag = false;
        inputHandler.sprintFlag = false;

        if (isInAir)
        {
            playerMovement.inAirTimer += Time.deltaTime;
        }
    }
}
