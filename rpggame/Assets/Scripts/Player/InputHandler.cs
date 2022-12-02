using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class InputHandler : MonoBehaviour
{
    public float horizontal;
    public float vertical;
    public float moveAmount;
    public float mouseX;
    public float mouseY;
    
    public bool b_Input;
    public bool rollFlag;
    public float rollInputTimer;
    public bool sprintFlag;
    public bool isInteracting;
    
    PlayerControls inputActions;
    CameraHandler cameraHandler;
    
    Vector2 movementInput;
    Vector2 cameraInput;

    private void Start()
    {
        cameraHandler = CameraHandler.singleton;
    }

    public void FixedUpdate()
    {
        float delta = Time.fixedDeltaTime;
        if(cameraHandler != null)
        {
            cameraHandler.FollowTarget(delta);
            cameraHandler.HandleCameraRotation(delta, mouseX, mouseY);
        }
    }

    public void OnEnable()
    {
        if (inputActions == null)
        {
            inputActions = new PlayerControls();
            inputActions.PlayerMovement.Movement.performed += inputActions => movementInput = inputActions.ReadValue<Vector2>();
            inputActions.PlayerMovement.Camera.performed += inputActions => cameraInput = inputActions.ReadValue<Vector2>();
        }
        
        inputActions.Enable();
    }
    
    public void OnDisable()
    {
        inputActions.Disable();
    }
    
    public void TickInput(float delta)
    {
        MoveInput(delta);
        HandleRollInput(delta);
    }
    
    private void MoveInput(float delta)
    {
        horizontal = movementInput.x;
        vertical = movementInput.y;
        moveAmount = Mathf.Clamp01(Mathf.Abs(horizontal) + Mathf.Abs(vertical));
        mouseX = cameraInput.x;
        mouseY = cameraInput.y;
    }
    
    public void HandleRollInput(float delta)
    {
        b_Input = inputActions.PlayerActions.Roll.phase == UnityEngine.InputSystem.InputActionPhase.Started;
        
        if (b_Input)
        {
            //rollFlag = true;
            rollInputTimer += delta;
            sprintFlag = true;
        }
        else
        {
            if(rollInputTimer > 0 && rollInputTimer < 0.5f)
            {
                rollFlag = true;
                sprintFlag = false;
            }
            
            rollInputTimer = 0;
        }
    }
    
}