package ru.nooneboss.database.users

import io.ktor.server.auth.*
import java.util.*

data class User(val user_uuid: UUID, val login: String, val password: String, val role: String) : Principal {

    override fun hashCode(): Int {
        var result = user_uuid.hashCode()
        result = 31 * result + login.hashCode()
        result = 31 * result + password.hashCode()
        result = 31 * result + role.hashCode()
        return result
    }
}
