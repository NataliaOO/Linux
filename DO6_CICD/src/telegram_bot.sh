#!/bin/bash
TELEGRAM_BOT_TOKEN="6766077194:AAGwyfcZ2LFBRCo2V7MpJjV5N29ordNRn-Q"
TELEGRAM_USER_ID="453690832"
URL="https://api.telegram.org/bot$TELEGRAM_BOT_TOKEN/sendMessage"
TEXT="Project:+ [$CI_PROJECT_NAME]%0AJob name: $CI_JOB_NAME%0AStatus: $CI_JOB_STATUS "
ICON=$([[ $? -eq 0 ]] && echo "✅" || echo "🚫")

curl -s -d "chat_id=$TELEGRAM_USER_ID&disable_web_page_preview=1&text=$TEXT $ICON" $URL > /dev/null