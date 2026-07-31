#!/data/data/com.termux/files/usr/bin/bash

#############################################
# Termux / Linux PHP + Cloudflared Launcher
# Version : 1.0
#############################################

############################
# Configuration
############################

############################
# Detect Environment
############################

if [ -n "$TERMUX_VERSION" ]; then

    PLATFORM="termux"
    PROJECT_ROOT="/storage/emulated/0/Termux"

else

    PLATFORM="linux"

    echo

    DEFAULT_PATH="/var/www/html"

    read -p "Project Root [$DEFAULT_PATH] : " PROJECT_ROOT

    PROJECT_ROOT=${PROJECT_ROOT:-$DEFAULT_PATH}

    while [ ! -d "$PROJECT_ROOT" ]
    do

        echo
        echo "Directory not found."

        read -p "Project Root [$DEFAULT_PATH] : " PROJECT_ROOT

        PROJECT_ROOT=${PROJECT_ROOT:-$DEFAULT_PATH}

    done

fi

############################
# Colors
############################

RED="\e[31m"
GREEN="\e[32m"
YELLOW="\e[33m"
BLUE="\e[34m"
CYAN="\e[36m"
WHITE="\e[97m"
NC="\e[0m"

############################
# Banner
############################

banner(){

clear

echo -e "${CYAN}"
echo "=================================================="
echo "           TERMUX / LINUX PHP LAUNCHER"
echo "=================================================="
echo -e "${NC}"

}

############################
# Error
############################

error(){

echo -e "${RED}$1${NC}"

}

############################
# Success
############################

success(){

echo -e "${GREEN}$1${NC}"

}

############################
# Warning
############################

warning(){

echo -e "${YELLOW}$1${NC}"

}

############################
# Install Package
############################

install_package(){

PKG=$1

pkg install -y "$PKG"

}

############################
# Storage
############################

check_storage(){

if [ "$PLATFORM" = "termux" ]; then

    if [ ! -d "/storage/emulated/0" ]; then

        warning "Granting Storage Permission..."

        termux-setup-storage

        echo
        read -p "Press ENTER after permission granted..."

    fi

fi

}

############################
# Create Project Folder
############################

create_project_dir(){

    if [ "$PLATFORM" = "termux" ]; then

        if [ ! -d "$PROJECT_ROOT" ]; then

            warning "Creating Project Directory..."

            mkdir -p "$PROJECT_ROOT"

            success "$PROJECT_ROOT"

        fi

    fi

}

############################
# PHP
############################

check_php(){

if ! command -v php >/dev/null 2>&1
then

warning "Installing PHP..."

install_package php

fi

}

############################
# Cloudflared
############################

check_cloudflared(){

if ! command -v cloudflared >/dev/null 2>&1
then

warning "Installing Cloudflared..."

install_package cloudflared

fi

}

############################
# ifconfig
############################

check_ifconfig(){

if ! command -v ifconfig >/dev/null 2>&1
then

warning "Installing net-tools..."

install_package net-tools

fi

}

############################
# Dependency
############################

dependency_check(){

check_storage

create_project_dir

check_php

check_cloudflared

check_ifconfig

}

############################
# Read Projects
############################

read_projects(){

mapfile -t PROJECTS < <(

find "$PROJECT_ROOT" \
-maxdepth 1 \
-mindepth 1 \
-printf "%f\n" \
| sort -f

)

COUNT=${#PROJECTS[@]}

if [ "$COUNT" -eq 0 ]
then

error "No project found."

echo

echo "Copy your project into"

echo "$PROJECT_ROOT"

exit

fi

}

############################
# Show Menu
############################

show_menu(){

banner

echo

echo -e "${WHITE}Projects${NC}"

echo

INDEX=1

for ITEM in "${PROJECTS[@]}"
do

echo "$INDEX) $ITEM"

INDEX=$((INDEX+1))

done

echo

}

############################
# Select Project
############################

select_project(){

while true
do

read -p "Select Project : " CHOICE

if ! [[ "$CHOICE" =~ ^[0-9]+$ ]]
then

error "Invalid choice."

continue

fi

if [ "$CHOICE" -lt 1 ] || [ "$CHOICE" -gt "$COUNT" ]
then

error "Invalid choice."

continue

fi

PROJECT="${PROJECTS[$((CHOICE-1))]}"

PROJECT_PATH="$PROJECT_ROOT/$PROJECT"

if [ ! -d "$PROJECT_PATH" ]
then

error "Selected item is not directory."

continue

fi

break

done

}

# ===== END OF PART 1 =====
############################
# Current IP
############################

get_current_ip(){

CURRENT_IP=$(ifconfig 2>/dev/null \
| awk '/inet / && $2!="127.0.0.1" {print $2; exit}')

if [ -z "$CURRENT_IP" ]
then
CURRENT_IP="127.0.0.1"
fi

}

############################
# Host Selection
############################

select_host(){

echo
echo "Host"
echo
echo "1) 127.0.0.1 (Localhost)"
echo "2) $CURRENT_IP (Current IP)"
echo

while true
do

read -p "Select Host [1-2] : " HOST_CHOICE

case "$HOST_CHOICE" in

1)
HOST="127.0.0.1"
break
;;

2)
HOST="$CURRENT_IP"
break
;;

*)
echo -e "${RED}Invalid Choice${NC}"
;;

esac

done

}

############################
# Port Input
############################

select_port(){

echo

read -p "Enter Port [8080] : " PORT

if [ -z "$PORT" ]
then
PORT=8080
fi

}

############################
# Port Check
############################

port_busy(){

if command -v ss >/dev/null 2>&1
then

ss -ltn | grep -q ":$PORT "

return $?

fi

if command -v netstat >/dev/null 2>&1
then

netstat -ltn 2>/dev/null | grep -q ":$PORT "

return $?

fi

return 1

}

############################
# Validate Port
############################

check_port(){

while true
do

port_busy

if [ $? -eq 0 ]
then

echo -e "${RED}"
echo
echo "Port $PORT already in use."
echo -e "${NC}"

select_port

else

break

fi

done

}

############################
# Start PHP
############################

start_php(){

cd "$PROJECT_PATH" || exit

echo

echo -e "${GREEN}Starting PHP Server...${NC}"

php -S "$HOST:$PORT" >/dev/null 2>&1 &

PHP_PID=$!

sleep 2

if ! kill -0 "$PHP_PID" 2>/dev/null
then

echo -e "${RED}"
echo "PHP Server failed."
echo -e "${NC}"

exit

fi

echo

echo -e "${GREEN}PHP Started${NC}"

echo

echo "Project : $PROJECT"

echo "Path    : $PROJECT_PATH"

echo "Host    : $HOST"

echo "Port    : $PORT"

echo

echo "Local URL"

echo "http://$HOST:$PORT"

echo

}

############################
# Cleanup
############################

cleanup(){

echo

echo -e "${YELLOW}Stopping Services...${NC}"

[ -n "$PHP_PID" ] && kill "$PHP_PID" 2>/dev/null

[ -n "$CF_PID" ] && kill "$CF_PID" 2>/dev/null

echo

echo -e "${GREEN}Done.${NC}"

exit

}

trap cleanup INT TERM

############################
# Start Cloudflared
############################

start_cloudflared(){

echo
echo -e "${GREEN}Starting Cloudflared Tunnel...${NC}"
echo

CF_LOG="$HOME/.cloudflared.log"

rm -f "$CF_LOG"

cloudflared tunnel --url "http://$HOST:$PORT" >"$CF_LOG" 2>&1 &

CF_PID=$!

echo -n "Generating Public URL "

for i in $(seq 1 30)
do

URL=$(grep -oE 'https://[-a-zA-Z0-9]+\.trycloudflare\.com' "$CF_LOG" | head -1)

if [ -n "$URL" ]
then
break
fi

echo -n "."

sleep 1

done

echo
echo

if [ -z "$URL" ]
then

echo -e "${RED}Unable to generate Cloudflare URL.${NC}"
echo
echo "Cloudflared Output:"
echo "------------------------------"
cat "$CF_LOG"
echo "------------------------------"

cleanup

fi

echo -e "${GREEN}Tunnel Connected${NC}"
echo

echo "==============================================="
echo
echo "Project"
echo "$PROJECT"
echo
echo "Project Path"
echo "$PROJECT_PATH"
echo
echo "Local URL"
echo "http://$HOST:$PORT"
echo
echo "Public URL"
echo "$URL"
echo
echo "==============================================="
echo
echo "Press Ctrl+C to Stop."
echo

}

############################
# Keep Alive
############################

keep_running(){

while true
do

if ! kill -0 "$PHP_PID" 2>/dev/null
then

echo
echo -e "${RED}PHP Server Stopped.${NC}"
cleanup

fi

if ! kill -0 "$CF_PID" 2>/dev/null
then

echo
echo -e "${RED}Cloudflared Stopped.${NC}"
cleanup

fi

sleep 2

done

}

############################
# Main
############################

main(){

dependency_check

read_projects

show_menu

select_project

get_current_ip

select_host

select_port

check_port

start_php

start_cloudflared

keep_running

}

############################
# Start
############################

main
