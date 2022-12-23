using System.Collections;
using System.Collections.Generic;
using PsychoticLab;
using UnityEngine;

public class CharacterLoader : MonoBehaviour
{
    public static int characterIndex = 0;
    public CharacterRandomizer characterRandomizer;

    public void LoadCharacter()
    {
        Character character = PlayerCharacter.characterList.characters[characterIndex];
        CharacterSkin skin = character.skin;
        
        foreach (GameObject g in characterRandomizer.enabledObjects)
        {
            g.SetActive(false);
        }
        switch (skin.gender)
        {
            case 0:
                if (skin.helmet != -1)
                {
                    characterRandomizer.ActivateItem(characterRandomizer.male.headNoElements[skin.helmet]);
                }
                else
                {
                    characterRandomizer.ActivateItem(characterRandomizer.male.headAllElements[skin.head]);
                    characterRandomizer.ActivateItem(characterRandomizer.allGender.all_Hair[skin.hair]);
                }
                
                characterRandomizer.ActivateItem(characterRandomizer.male.torso[skin.torso]);
                characterRandomizer.ActivateItem(characterRandomizer.male.arm_Upper_Left[skin.armUpper]);
                characterRandomizer.ActivateItem(characterRandomizer.male.arm_Upper_Right[skin.armUpper]);
                characterRandomizer.ActivateItem(characterRandomizer.male.arm_Lower_Left[skin.armLower]);
                characterRandomizer.ActivateItem(characterRandomizer.male.arm_Lower_Right[skin.armLower]);
                characterRandomizer.ActivateItem(characterRandomizer.male.hand_Left[skin.hand]);
                characterRandomizer.ActivateItem(characterRandomizer.male.hand_Right[skin.hand]);
                characterRandomizer.ActivateItem(characterRandomizer.male.hips[skin.hips]);
                characterRandomizer.ActivateItem(characterRandomizer.male.leg_Left[skin.leg]);
                characterRandomizer.ActivateItem(characterRandomizer.male.leg_Right[skin.leg]);
                break;
            case 1:
                if (skin.helmet != -1)
                {
                    characterRandomizer.ActivateItem(characterRandomizer.female.headNoElements[skin.helmet]);
                }
                else
                {
                    characterRandomizer.ActivateItem(characterRandomizer.female.headAllElements[skin.head]);
                    characterRandomizer.ActivateItem(characterRandomizer.allGender.all_Hair[skin.hair]);
                }
                
                characterRandomizer.ActivateItem(characterRandomizer.female.torso[skin.torso]);
                characterRandomizer.ActivateItem(characterRandomizer.female.arm_Upper_Left[skin.armUpper]);
                characterRandomizer.ActivateItem(characterRandomizer.female.arm_Upper_Right[skin.armUpper]);
                characterRandomizer.ActivateItem(characterRandomizer.female.arm_Lower_Left[skin.armLower]);
                characterRandomizer.ActivateItem(characterRandomizer.female.arm_Lower_Right[skin.armLower]);
                characterRandomizer.ActivateItem(characterRandomizer.female.hand_Left[skin.hand]);
                characterRandomizer.ActivateItem(characterRandomizer.female.hand_Right[skin.hand]);
                characterRandomizer.ActivateItem(characterRandomizer.female.hips[skin.hips]);
                characterRandomizer.ActivateItem(characterRandomizer.female.leg_Left[skin.leg]);
                characterRandomizer.ActivateItem(characterRandomizer.female.leg_Right[skin.leg]);
                break;
        }
        characterRandomizer.ActivateItem(characterRandomizer.allGender.back_Attachment[skin.backAttachment]);
        characterRandomizer.ActivateItem(characterRandomizer.allGender.shoulder_Attachment_Left[skin.shoulderAttachment]);
        characterRandomizer.ActivateItem(characterRandomizer.allGender.shoulder_Attachment_Right[skin.shoulderAttachment]);
        characterRandomizer.ActivateItem(characterRandomizer.allGender.elbow_Attachment_Left[skin.elbow]);
        characterRandomizer.ActivateItem(characterRandomizer.allGender.elbow_Attachment_Right[skin.elbow]);
        characterRandomizer.ActivateItem(characterRandomizer.allGender.hips_Attachment[skin.hipsAttachment]);
        characterRandomizer.ActivateItem(characterRandomizer.allGender.knee_Attachement_Left[skin.knee]);
        characterRandomizer.ActivateItem(characterRandomizer.allGender.knee_Attachement_Right[skin.knee]);
    }
}
