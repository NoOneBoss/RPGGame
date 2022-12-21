using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using PsychoticLab;
using TMPro;
using UnityEngine;
using UnityEngine.UI;

public class CharacterCreator : MonoBehaviour
{
    public CharacterRandomizer randomizer;
    public Gender gender = Gender.Male;
    
    [Header("Head")]
    public TMP_Dropdown headDropdown;
    public TMP_Dropdown hairDropdown;
    
    [Header("Body")]
    public TMP_Dropdown torsoDropdown;
    public TMP_Dropdown upperArmDropdown;
    public TMP_Dropdown lowerArmDropdown;
    public TMP_Dropdown handDropdown;
    
    [Header("Legs")]
    public TMP_Dropdown hipsDropdown;
    public TMP_Dropdown legsDropdown;


    public void LoadDropDowns(Gender gender)
    {
        headDropdown.ClearOptions();
        hairDropdown.ClearOptions();
        torsoDropdown.ClearOptions();
        upperArmDropdown.ClearOptions();
        lowerArmDropdown.ClearOptions();
        handDropdown.ClearOptions();
        hipsDropdown.ClearOptions();
        legsDropdown.ClearOptions();
        
        switch (gender)
        {
            case Gender.Male:
                headDropdown.onValueChanged.RemoveAllListeners();
                headDropdown.onValueChanged.AddListener((int i) => ChangePart(i, randomizer.male.headAllElements));
                headDropdown.AddOptions(randomizer.male.headAllElements.Select(x => $"Голова {randomizer.male.headAllElements.IndexOf(x)}").ToList());
                
                torsoDropdown.onValueChanged.RemoveAllListeners();
                torsoDropdown.onValueChanged.AddListener((int i) => ChangePart(i, randomizer.male.torso));
                torsoDropdown.AddOptions(randomizer.male.torso.Select(x => $"Тело {randomizer.male.torso.IndexOf(x)}").ToList());
                
                upperArmDropdown.onValueChanged.RemoveAllListeners();
                upperArmDropdown.onValueChanged.AddListener((int i) => ChangeDualPart(i, randomizer.male.arm_Upper_Left, randomizer.male.arm_Upper_Right));
                upperArmDropdown.AddOptions(randomizer.male.arm_Upper_Left.Select(x => $"Наплечник {randomizer.male.arm_Upper_Left.IndexOf(x)}").ToList());
                
                lowerArmDropdown.onValueChanged.RemoveAllListeners();
                lowerArmDropdown.onValueChanged.AddListener((int i) => ChangeDualPart(i, randomizer.male.arm_Lower_Left, randomizer.male.arm_Lower_Right));
                lowerArmDropdown.AddOptions(randomizer.male.arm_Lower_Left.Select(x => $"Наручь {randomizer.male.arm_Lower_Left.IndexOf(x)}").ToList());
                
                handDropdown.onValueChanged.RemoveAllListeners();
                handDropdown.onValueChanged.AddListener((int i) => ChangeDualPart(i, randomizer.male.hand_Left, randomizer.male.hand_Right));
                handDropdown.AddOptions(randomizer.male.hand_Left.Select(x => $"Перчатки {randomizer.male.hand_Left.IndexOf(x)}").ToList());
                
                hipsDropdown.onValueChanged.RemoveAllListeners();
                hipsDropdown.onValueChanged.AddListener((int i) => ChangePart(i, randomizer.male.hips));
                hipsDropdown.AddOptions(randomizer.male.hips.Select(x => $"Штаны {randomizer.male.hips.IndexOf(x)}").ToList());
                
                legsDropdown.onValueChanged.RemoveAllListeners();
                legsDropdown.onValueChanged.AddListener((int i) => ChangeDualPart(i, randomizer.male.leg_Left, randomizer.male.leg_Right));
                legsDropdown.AddOptions(randomizer.male.leg_Left.Select(x => $"Ботинки {randomizer.male.leg_Left.IndexOf(x)}").ToList());
                break;
            case Gender.Female:
                headDropdown.onValueChanged.RemoveAllListeners();
                headDropdown.onValueChanged.AddListener((int i) => ChangePart(i, randomizer.female.headAllElements));
                headDropdown.AddOptions(randomizer.female.headAllElements.Select(x => $"Голова {randomizer.female.headAllElements.IndexOf(x)}").ToList());
                
                torsoDropdown.onValueChanged.RemoveAllListeners();
                torsoDropdown.onValueChanged.AddListener((int i) => ChangePart(i, randomizer.female.torso));
                torsoDropdown.AddOptions(randomizer.female.torso.Select(x => $"Тело {randomizer.female.torso.IndexOf(x)}").ToList());
                
                upperArmDropdown.onValueChanged.RemoveAllListeners();
                upperArmDropdown.onValueChanged.AddListener((int i) => ChangeDualPart(i, randomizer.female.arm_Upper_Left, randomizer.female.arm_Upper_Right));
                upperArmDropdown.AddOptions(randomizer.female.arm_Upper_Left.Select(x => $"Наплечник {randomizer.female.arm_Upper_Left.IndexOf(x)}").ToList());
                
                lowerArmDropdown.onValueChanged.RemoveAllListeners();
                lowerArmDropdown.onValueChanged.AddListener((int i) => ChangeDualPart(i, randomizer.female.arm_Lower_Left, randomizer.female.arm_Lower_Right));
                lowerArmDropdown.AddOptions(randomizer.female.arm_Lower_Left.Select(x => $"Наручь {randomizer.female.arm_Lower_Left.IndexOf(x)}").ToList());
                
                handDropdown.onValueChanged.RemoveAllListeners();
                handDropdown.onValueChanged.AddListener((int i) => ChangeDualPart(i, randomizer.female.hand_Left, randomizer.female.hand_Right));
                handDropdown.AddOptions(randomizer.female.hand_Left.Select(x => $"Перчатки {randomizer.female.hand_Left.IndexOf(x)}").ToList());
                
                hipsDropdown.onValueChanged.RemoveAllListeners();
                hipsDropdown.onValueChanged.AddListener((int i) => ChangePart(i, randomizer.female.hips));
                hipsDropdown.AddOptions(randomizer.female.hips.Select(x => $"Штаны {randomizer.female.hips.IndexOf(x)}").ToList());
                
                legsDropdown.onValueChanged.RemoveAllListeners();
                legsDropdown.onValueChanged.AddListener((int i) => ChangeDualPart(i, randomizer.female.leg_Left, randomizer.female.leg_Right));
                legsDropdown.AddOptions(randomizer.female.leg_Left.Select(x => $"Ботинки {randomizer.female.leg_Left.IndexOf(x)}").ToList());
                break;
        }
        
        hairDropdown.onValueChanged.RemoveAllListeners();
        hairDropdown.onValueChanged.AddListener((int i) => ChangePart(i, randomizer.allGender.all_Hair));
        hairDropdown.AddOptions(randomizer.allGender.all_Hair.Select(x => $"Причёска {randomizer.allGender.all_Hair.IndexOf(x)}").ToList());
    }

    public void UpdateCharacter(Gender gender)
    {
        LoadDropDowns(gender);
        if (randomizer.enabledObjects.Count != 0)
        {
            foreach (GameObject g in randomizer.enabledObjects)
            {
                g.SetActive(false);
            }
        }
        
        randomizer.enabledObjects.Clear();
        switch (gender)
        {
            case Gender.Male:
                randomizer.ActivateItem(randomizer.male.headAllElements[0]);
                randomizer.ActivateItem(randomizer.male.eyebrow[0]);
                randomizer.ActivateItem(randomizer.male.torso[0]);
                randomizer.ActivateItem(randomizer.male.arm_Upper_Right[0]);
                randomizer.ActivateItem(randomizer.male.arm_Upper_Left[0]);
                randomizer.ActivateItem(randomizer.male.arm_Lower_Right[0]);
                randomizer.ActivateItem(randomizer.male.arm_Lower_Left[0]);
                randomizer.ActivateItem(randomizer.male.hand_Right[0]);
                randomizer.ActivateItem(randomizer.male.hand_Left[0]);
                randomizer.ActivateItem(randomizer.male.hips[0]);
                randomizer.ActivateItem(randomizer.male.leg_Right[0]);
                randomizer.ActivateItem(randomizer.male.leg_Left[0]);
                break;
            case Gender.Female:
                randomizer.ActivateItem(randomizer.female.headAllElements[0]);
                randomizer.ActivateItem(randomizer.female.eyebrow[0]);
                randomizer.ActivateItem(randomizer.female.torso[0]);
                randomizer.ActivateItem(randomizer.female.arm_Upper_Right[0]);
                randomizer.ActivateItem(randomizer.female.arm_Upper_Left[0]);
                randomizer.ActivateItem(randomizer.female.arm_Lower_Right[0]);
                randomizer.ActivateItem(randomizer.female.arm_Lower_Left[0]);
                randomizer.ActivateItem(randomizer.female.hand_Right[0]);
                randomizer.ActivateItem(randomizer.female.hand_Left[0]);
                randomizer.ActivateItem(randomizer.female.hips[0]);
                randomizer.ActivateItem(randomizer.female.leg_Right[0]);
                randomizer.ActivateItem(randomizer.female.leg_Left[0]);
                break;
        }
    }

    public void ChangePart(int index, List<GameObject> collection)
    {
        foreach (GameObject g in randomizer.enabledObjects.FindAll(x => collection.Contains(x)))
        {
            g.SetActive(false);
        }
        
        randomizer.ActivateItem(collection[index]);
    }
    public void ChangeDualPart(int index, List<GameObject> collection, List<GameObject> collection2)
    {
        foreach (GameObject g in randomizer.enabledObjects.FindAll(x => collection.Contains(x) || collection2.Contains(x)))
        {
            g.SetActive(false);
        }
        
        randomizer.ActivateItem(collection[index]);
        randomizer.ActivateItem(collection2[index]);
    }

    public void ChangeGender(string gender)
    {
        switch (gender)
        {
            case "male":
                this.gender = Gender.Male;
                LoadDropDowns(this.gender);
                UpdateCharacter(this.gender);
                break;
            case "female":
                this.gender = Gender.Female;
                LoadDropDowns(this.gender);
                UpdateCharacter(this.gender);
                break;
        }
    }
}
