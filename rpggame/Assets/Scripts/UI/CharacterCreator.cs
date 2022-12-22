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
    public RESTCharacter restCharacter;
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

    [Header("Other")]
    public TMP_Dropdown helmet;
    public TMP_Dropdown backAttach;
    public TMP_Dropdown shoulders;
    public TMP_Dropdown elbows;
    public TMP_Dropdown hipsAttach;
    public TMP_Dropdown knees;


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
        helmet.ClearOptions();
        backAttach.ClearOptions();
        shoulders.ClearOptions();
        elbows.ClearOptions();
        hipsAttach.ClearOptions();
        knees.ClearOptions();

        switch (gender)
        {
            case Gender.Male:
                headDropdown.onValueChanged.RemoveAllListeners();
                headDropdown.onValueChanged.AddListener((int i) => ChangePart(i, randomizer.male.headAllElements));
                headDropdown.AddOptions(randomizer.male.headAllElements.Select(x => $"Голова {randomizer.male.headAllElements.IndexOf(x)}").ToList());
                
                helmet.onValueChanged.RemoveAllListeners();
                helmet.onValueChanged.AddListener((int i) => EnableHelmet(i, randomizer.male.headNoElements, randomizer.male.headAllElements, randomizer.allGender.all_Hair));
                helmet.options.Add(new TMP_Dropdown.OptionData("Без шлема"));
                helmet.AddOptions(randomizer.male.headNoElements.Select(x => $"Шлем {randomizer.male.headNoElements.IndexOf(x)}").ToList());
                
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
                
                helmet.onValueChanged.RemoveAllListeners();
                helmet.onValueChanged.AddListener((int i) => EnableHelmet(i, randomizer.female.headNoElements, randomizer.female.headAllElements, randomizer.allGender.all_Hair));
                helmet.options.Add(new TMP_Dropdown.OptionData("Без шлема"));
                helmet.AddOptions(randomizer.female.headNoElements.Select(x => $"Шлем {randomizer.female.headNoElements.IndexOf(x)}").ToList());
                
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
        
        backAttach.onValueChanged.RemoveAllListeners();
        backAttach.onValueChanged.AddListener((int i) => ChangePart(i, randomizer.allGender.back_Attachment));
        backAttach.AddOptions(randomizer.allGender.back_Attachment.Select(x => $"Спина {randomizer.allGender.back_Attachment.IndexOf(x)}").ToList());
        
        shoulders.onValueChanged.RemoveAllListeners();
        shoulders.onValueChanged.AddListener((int i) => ChangeDualPart(i, randomizer.allGender.shoulder_Attachment_Left, randomizer.allGender.shoulder_Attachment_Right));
        shoulders.AddOptions(randomizer.allGender.shoulder_Attachment_Left.Select(x => $"Доп. наплечники {randomizer.allGender.shoulder_Attachment_Left.IndexOf(x)}").ToList());
        
        elbows.onValueChanged.RemoveAllListeners();
        elbows.onValueChanged.AddListener((int i) => ChangeDualPart(i, randomizer.allGender.elbow_Attachment_Left, randomizer.allGender.elbow_Attachment_Right));
        elbows.AddOptions(randomizer.allGender.elbow_Attachment_Left.Select(x => $"Налокотники {randomizer.allGender.elbow_Attachment_Left.IndexOf(x)}").ToList());
        
        hipsAttach.onValueChanged.RemoveAllListeners();
        hipsAttach.onValueChanged.AddListener((int i) => ChangePart(i, randomizer.allGender.hips_Attachment));
        hipsAttach.AddOptions(randomizer.allGender.hips_Attachment.Select(x => $"Разное {randomizer.allGender.hips_Attachment.IndexOf(x)}").ToList());
        
        knees.onValueChanged.RemoveAllListeners();
        knees.onValueChanged.AddListener((int i) => ChangeDualPart(i, randomizer.allGender.knee_Attachement_Left, randomizer.allGender.knee_Attachement_Right));
        knees.AddOptions(randomizer.allGender.knee_Attachement_Left.Select(x => $"Наколеники {randomizer.allGender.knee_Attachement_Left.IndexOf(x)}").ToList());
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

    public void EnableHelmet(int index, List<GameObject> collection, List<GameObject> heads, List<GameObject> hair)
    {
        if (index == 0)
        {
            heads[0].SetActive(true);
            hair[0].SetActive(true);
            
            headDropdown.enabled = true;
            hairDropdown.enabled = true;
        }
        else
        {
            heads[headDropdown.value].SetActive(false);
            hair[hairDropdown.value].SetActive(false);
            
            headDropdown.value = 0;
            hairDropdown.value = 0;
            headDropdown.enabled = false;
            hairDropdown.enabled = false;
        }
        
        
        foreach (GameObject g in randomizer.enabledObjects.FindAll(x => collection.Contains(x)))
        {
            g.SetActive(false);
        }

        if (index != 0) randomizer.ActivateItem(collection[index-1]);
        else collection[index].SetActive(false);
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



    public void SaveCharacter()
    {
        CharacterSkin characterSkin = new CharacterSkin((int)gender, headDropdown.value, hairDropdown.value,
            torsoDropdown.value, upperArmDropdown.value, lowerArmDropdown.value, handDropdown.value,
            hipsDropdown.value, legsDropdown.value, helmet.value - 1, backAttach.value,
            shoulders.value, elbows.value, hipsAttach.value, knees.value);
        
        restCharacter.PostCharacter(characterSkin);
        restCharacter.GetCharacter();
    }
}

[Serializable]
public class CharacterList
{
    public List<Character> characters;
}

[Serializable]
public class Character
{
    public string character_uuid;
    public int level;
    public int money;
    public string owner;
    public CharacterSkin skin;

    public Character(string characterUuid, int level, int money, string inventory, string owner, CharacterSkin skin)
    {
        character_uuid = characterUuid;
        this.level = level;
        this.money = money;
        this.owner = owner;
        this.skin = skin;
    }
}

[Serializable]
public class CharacterSkin
{
    public int leg;
    public int hair;
    public int hand;
    public int head;
    public int hips;
    public int knee;
    public int elbow;
    public int torso;
    public int gender;
    public int helmet;
    public int armLower;
    public int armUpper;
    public int backAttachment;
    public int hipsAttachment;
    public int shoulderAttachment;

    public CharacterSkin(int gender, int head, int hair, int torso, int armUpper, int armLower, int hand, int hips, int leg, int helmet, int backAttachment, int shoulderAttachment, int elbow, int hipsAttachment, int knee)
    {
        this.gender = gender;
        this.head = head;
        this.hair = hair;
        this.torso = torso;
        this.armUpper = armUpper;
        this.armLower = armLower;
        this.hand = hand;
        this.hips = hips;
        this.leg = leg;
        this.helmet = helmet;
        this.backAttachment = backAttachment;
        this.shoulderAttachment = shoulderAttachment;
        this.elbow = elbow;
        this.hipsAttachment = hipsAttachment;
        this.knee = knee;
    }
}
