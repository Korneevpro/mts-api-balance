#!/bin/bash

phone=$1
login=$2
passwd=$3


CLIENT_ID=$2
CLIENT_SECRET=$3

# URL для запроса токена
TOKEN_URL="https://api.mts.ru/token"

# Кодирование client_id:client_secret в Base64
AUTH_BASE64=$(echo -n "$CLIENT_ID:$CLIENT_SECRET" | base64 -w 0)

# Заголовки и данные запроса
HEADERS=(
    "Authorization: Basic $AUTH_BASE64"
    "Content-Type: application/x-www-form-urlencoded"
)

# Тело запроса 
POST_DATA="grant_type=client_credentials"

# Выполнение запроса и обработка ответа
response=$(curl -s -X POST "$TOKEN_URL" \
    -H "${HEADERS[0]}"                  \
    -H "${HEADERS[1]}"                  \
    -d "$POST_DATA"                     )


# Извлечение access_token из JSON-ответа (используем jq, если установлен)
if command -v jq &> /dev/null; then
    access_token=$(echo "$response" | jq -r '.access_token')
    if [ "$access_token" == "null" ] || [ -z "$access_token" ]; then
        error_msg=$(echo "$response" | jq -r '.error_description // .error')
        echo "Ошибка API: ${error_msg:-"Неизвестная ошибка"}"
        exit 1
    fi
else
    # Простая проверка, если jq не установлен
    if [[ "$response" != *"access_token"* ]]; then
        echo "Ошибка API: Не удалось извлечь access_token (установите jq для лучшего анализа)"
        exit 1
    fi
    access_token=$(echo "$response" | grep -oP '"access_token"\s*:\s*"\K[^"]+')
fi

# URL для запроса Json массива
API_URL="https://api.mts.ru/b2b/v1/Bills/ValidityInfo?fields=MOAF,forisCounters&customerAccount.accountNo=$1&customerAccount.productRelationship.product.productLine.name=Counters"
         
# Заголовки запроса
HEADERS="Authorization: Bearer $access_token"

# Тело запроса 
POST_DATA="Content-Type=application/json"

# Выполнение запроса и получение ответа
response=$(curl -s -X GET "$API_URL" \
    -H "$HEADERS"                    \
    -d "${POST_DATA}"                )

echo "$response"
