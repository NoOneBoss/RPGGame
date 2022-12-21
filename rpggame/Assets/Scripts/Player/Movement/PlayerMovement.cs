using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PlayerMovement : MonoBehaviour
{
    Transform cameraObject;
    InputHandler inputHandler;
    public Vector3 moveDirection;
    PlayerManager playerManager;
    
    [HideInInspector] public Transform myTransform;
    [HideInInspector] public AnimationHandler animationHandler;
    
    public new Rigidbody rigidbody;
    
    [Header("Ground & Air Detection Stats")]
    [SerializeField] float groundDetectionRayStartPoint = 0.5f;
    [SerializeField] float minimumDistanceNeededToBeginFall = 1f;
    [SerializeField] float groundDirectionRayDistance = 0.2f;
    LayerMask ignoreForGroundCheck;
    [SerializeField] public float inAirTimer;

    [Header("Stats")]
    [SerializeField] float moveSpeed = 5f;
    [SerializeField] float rotationSpeed = 10f;
    [SerializeField] float sprintSpeed = 7f;
    [SerializeField] float fallingSpeed = 80f;

    void Start()
    {
        playerManager = GetComponent<PlayerManager>();
        rigidbody = GetComponent<Rigidbody>();
        inputHandler = GetComponent<InputHandler>();
        
        animationHandler = GetComponentInChildren<AnimationHandler>();
        animationHandler.Inititalize();
        
        cameraObject = CameraHandler.singleton.cameraTransform;
        myTransform = transform;
        
        playerManager.isGrounded = true;
        ignoreForGroundCheck = ~(1 << 8 | 1 << 11);
        
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
        if(playerManager.isInteracting) return;
        
        moveDirection = cameraObject.forward * inputHandler.vertical;
        moveDirection += cameraObject.right * inputHandler.horizontal;
        moveDirection.Normalize();
        moveDirection.y = 0;

        float speed = moveSpeed;
        if (inputHandler.sprintFlag && inputHandler.moveAmount > 0.5)
        {
            speed = sprintSpeed;
            playerManager.isSprinting = true;
            moveDirection *= speed;
        }
        else
        {
            if (inputHandler.moveAmount < 0.5)
            {
                moveDirection *= speed;
                playerManager.isSprinting = false;
            }
            else
            {
                moveDirection *= speed;
                playerManager.isSprinting = false;
            }
        }

        Vector3 projectedVelocity = Vector3.ProjectOnPlane(moveDirection, normalVector);
        rigidbody.velocity = projectedVelocity;

        
        animationHandler.UpdateAnimatorValues(inputHandler.moveAmount, 0, playerManager.isSprinting);
        
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

    public void HandleFalling(float delta, Vector3 moveDirection)
    {
        playerManager.isGrounded = false;
        RaycastHit hit;
        Vector3 origin = myTransform.position;
        origin.y += groundDetectionRayStartPoint;
        
        if(Physics.Raycast(origin, myTransform.forward, out hit, 0.4f))
        {
            moveDirection = Vector3.zero;
        }
        
        if(playerManager.isInAir)
        {
            rigidbody.AddForce(-Vector3.up * fallingSpeed);
            rigidbody.AddForce(moveDirection * fallingSpeed / 10);
        }
        
        Vector3 dir = moveDirection;
        dir.Normalize();
        origin += dir * groundDirectionRayDistance;
        
        targetPosition = myTransform.position;
        
        if (Physics.Raycast(origin, -Vector3.up, out hit, minimumDistanceNeededToBeginFall, ignoreForGroundCheck))
        {
            normalVector = hit.normal;
            Vector3 tp = hit.point;
            playerManager.isGrounded = true;
            targetPosition.y = tp.y;

            if (playerManager.isInAir)
            {
                animationHandler.PlayTargetAnimation("Land", true);
                inAirTimer = 0;
                
                playerManager.isInAir = false;
            }
        }
        else
        {
            if (playerManager.isGrounded)
            {
                playerManager.isGrounded = false;
            }
            
            if(playerManager.isInAir == false)
            {
                if(playerManager.isInteracting == false)
                {
                    animationHandler.PlayTargetAnimation("Falling", true);
                }
                
                Vector3 vel = rigidbody.velocity;
                vel.Normalize();
                rigidbody.velocity = vel * (moveSpeed / 2);
                playerManager.isInAir = true;
            }
            
        }
        
        if(playerManager.isGrounded)
        {
            if(playerManager.isInteracting || inputHandler.moveAmount > 0)
            {
                myTransform.position = Vector3.Lerp(myTransform.position, targetPosition, Time.deltaTime);
            }
            else
            {
                myTransform.position = targetPosition;
            }
        }

    }
    
    #endregion
}
