Для работы скрипта требуется пакет jq

sudo apt update
sudo apt install jq

Cкрипт используется как внешняя проверка в zabbix для получения информации о состоянии счета и оставшихся минут на номере МТС.

файл get_data_mts.sh кладем в /usr/lib/zabbix/externalscripts/

далее делаем его исполняемым

sudo chmod +x /usr/lib/zabbix/externalscripts/get_data_mts.sh

и меняем владельца

sudo chown zabbix:zabbix /usr/lib/zabbix/externalscripts/get_data_mts.sh

после чего в zabbix создается новый узел, применяется к нему шаблон MTS balance.

В макросах шаблока указываете номер телефона и логин и пароль для получения динамического токена

https://developers.mts.ru/mts-business-api/documentation/22-access-token  тут описан этот процесс и все необходимые данные для правки и изменения скрипта.
