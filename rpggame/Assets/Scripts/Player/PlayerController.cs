using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PlayerController : MonoBehaviour
{
    Transform cameraObject;
    InputHandler inputHandler;
    Vector3 moveDirection;
    
    [HideInInspector] public Transform myTransform;
    [HideInInspector] public AnimationHandler animationHandler;
    
    public new Rigidbody rigidbody;

    [Header("Stats")]
    [SerializeField] float moveSpeed = 5f;
    [SerializeField] float rotationSpeed = 10f;
    [SerializeField] float sprintSpeed = 7f;
    
    public bool isSprinting;
    
    void Start()
    {
        rigidbody = GetComponent<Rigidbody>();
        inputHandler = GetComponent<InputHandler>();
        
        animationHandler = GetComponentInChildren<AnimationHandler>();
        animationHandler.Inititalize();
        
        cameraObject = CameraHandler.singleton.cameraTransform;
        myTransform = transform;
        
    }

    public void Update()
    {
        float delta = Time.deltaTime;
        
        isSprinting = inputHandler.b_Input;
        inputHandler.TickInput(delta);
        HandleMovement(delta);
        HandleRollingAndSprinting(delta);
    }

    #region Movement
    Vector3 normalVector;
    Vector3 targetPosition;

    private void HandleRotation(float delta)
    {
        Vector3 targetDirection = Vector3.zero;

        targetDirection = cameraObject.forward * inputHandler.vertical + cameraObject.right * inputHandler.horizontal;
        
        targetDirection.Normalize();
        targetDirection.y = 0;
        
        if(targetDirection == Vector3.zero) targetDirection = myTransform.forward;

        float rs = rotationSpeed;
        Quaternion tr = Quaternion.LookRotation(targetDirection);
        Quaternion targetRotation = Quaternion.Slerp(myTransform.rotation, tr, rs * delta);
        
        myTransform.rotation = targetRotation;
    }
    
    public void HandleMovement(float delta)
    {
        if(inputHandler.rollFlag) return;
        
        moveDirection = cameraObject.forward * inputHandler.vertical;
        moveDirection += cameraObject.right * inputHandler.horizontal;
        moveDirection.Normalize();
        moveDirection.y = 0;

        float speed = moveSpeed;
        if (inputHandler.sprintFlag)
        {
            speed = sprintSpeed;
            isSprinting = true;
        }
        moveDirection *= speed;

        Vector3 projectedVelocity = Vector3.ProjectOnPlane(moveDirection, normalVector);
        rigidbody.velocity = projectedVelocity;

        
        animationHandler.UpdateAnimatorValues(inputHandler.moveAmount, 0, isSprinting);
        
        if (animationHandler.canRotate)
        {
            HandleRotation(delta);
        }
    }
    
    public void HandleRollingAndSprinting(float delta)
    {
        if(animationHandler.animator.GetBool("isInteracting")) return;

        if (inputHandler.rollFlag)
        {
            moveDirection = cameraObject.forward * inputHandler.vertical;
            moveDirection += cameraObject.right * inputHandler.horizontal;
            
            if(inputHandler.moveAmount > 0)
            {
                animationHandler.PlayTargetAnimation("Roll", true);
                moveDirection.y = 0;
                Quaternion rollRotation = Quaternion.LookRotation(moveDirection);
                myTransform.rotation = rollRotation;
            }
            else
            {
                animationHandler.PlayTargetAnimation("Backstep", true);
            }
        }
    }
    #endregion
}
