using System.Linq;
using TMPro;
using UnityEngine;
using UnityEngine.UI;

public class InvItem : MonoBehaviour
{
    public Image itemImage;
    private Sprite sprite;

    
    public TMP_Text itemNameText;
    public TMP_Text itemDescriptionText;
    public TMP_Text itemCategoryText;

    public void LoadItem(DBItem item)
    {
        itemNameText.text = item.item_name;
        itemDescriptionText.text = item.item_description;
        itemCategoryText.text = item.item_category;
        switch (item.item_category)
        {
            case "weapons":
                itemImage.sprite = SpriteContainer.weapons.First(x => x.name == item.sprite_name);
                break;
            case "armor":
                itemImage.sprite = SpriteContainer.armors.First(x => x.name == item.sprite_name);
                break;
        }
    }
}
