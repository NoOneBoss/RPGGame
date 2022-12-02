using System;
using System.Collections;
using System.Collections.Generic;

using UnityEngine;

public class PlayerCharacter
{
    public static string token;
    public static User user;
}

[Serializable]
public class User
{
    public string user_uuid;
    public string login;
    public string password;
    public string role;

    public User(string userUuid, string login, string password, string role)
    {
        this.user_uuid = userUuid;
        this.login = login;
        this.password = password;
        this.role = role;
    }
}