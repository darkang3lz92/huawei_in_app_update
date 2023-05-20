package com.domago.huawei_in_app_update

import kotlin.reflect.KProperty1

data class ErrorDetails (
    val code: Int,
    val reason: String?,
)

fun ErrorDetails.asMap():Map<String, Any?> {
    return this::class.members.filterIsInstance<KProperty1<ErrorDetails, *>>().associate { it.name to it.get(this) }
}