#!/bin/bash
# ┌───────────────────────────────────────────────────────────────────────────┐
# │ Configuration                                                             │
# └───────────────────────────────────────────────────────────────────────────┘
#
# The complete path of the CRCON folder
# - If not set (ie : CRCON_folder_path=""), it will try to find and use
#   any "hll_rcon_tool" folder on disk.
# - If your CRCON folder name isn't 'hll_rcon_tool', you must set it here.
# - Some Ubuntu distros disable 'root' user,
#   you may have installed CRCON in "/home/ubuntu/hll_rcon_tool" then.
# default : "/root/hll_rcon_tool"
CRCON_folder_path=""

#
# └───────────────────────────────────────────────────────────────────────────┘

clear
printf "┌─────────────────────────────────────────────────────────────────────────────┐\n"
printf "│ Generate a CRCON diagnose file                                              │\n"
printf "└─────────────────────────────────────────────────────────────────────────────┘\n\n"

# User must have root permissions
this_script_name=${0##*/}
if [ "$(id -u)" -ne 0 ]; then
  printf "\033[31mX\033[0m This \033[37m%s\033[0m script must be run with full permissions\n\n" "$this_script_name"
  printf "\033[32mWhat to do\033[0m : you must elevate your permissions using 'sudo' :\n"
  printf "\033[36msudo sh ./%s\033[0m\n\n" "$this_script_name"
  exit
# Root
else
  printf "\033[32mV\033[0m You have 'root' permissions.\n"
fi

# Check CRCON folder path
if [ -n "$CRCON_folder_path" ]; then
  crcon_dir=$CRCON_folder_path
  printf "\033[32mV\033[0m CRCON folder path has been set in config : \033[33m%s\033[0m\n" "$CRCON_folder_path"
else
  printf "\033[34m?\033[0m You didn't set any CRCON folder path in config\n"
  printf "  Trying to detect a \033[33mhll_rcon_tool\033[0m folder...\n"
  crcon_dir=$(find / -name "hll_rcon_tool" 2>/dev/null)
  if [ -n "$crcon_dir" ]; then
    printf "\033[32mV\033[0m CRCON folder detected in \033[33m%s\033[0m\n" "$crcon_dir"
  else
    printf "\033[31mX\033[0m No \033[33mhll_rcon_tool\033[0m folder could be found\n\n"
    printf "  - Maybe you renamed the \033[33mhll_rcon_tool\033[0m folder ?\n"
    printf "    (it will work the same, but you'll have to adapt every maintenance script)\n\n"
    printf "  If you followed the official install procedure,\n"
    printf "  your \033[33mhll_rcon_tool\033[0m folder should be found here :\n"
    printf "    - \033[33m/root/hll_rcon_tool\033[0m        (most Linux installs)\n"
    printf "    - \033[33m/home/ubuntu/hll_rcon_tool\033[0m (some Ubuntu installs)\n\n"
    printf "\033[32mWhat to do\033[0m : Find your CRCON folder, copy this script in it and relaunch it from there.\n\n"
    exit
  fi
fi

# This script has to be in the CRCON folder
this_script_dir=$(dirname -- "$( readlink -f -- "$0"; )";)
if [ ! "$this_script_dir" = "$crcon_dir" ]; then
  printf "\033[31mX\033[0m This script is not located in the CRCON folder\n"
  printf "  Script location : \033[33m%s\033[0m\n" "$this_script_dir"
  printf "  Should be here : \033[33m%s\033[0m\n" "$crcon_dir"
  printf "\033[32mFixing...\033[0m\n"
  cp "$this_script_dir/$this_script_name" "$crcon_dir"
  if [ -f "$crcon_dir/$this_script_name" ]; then
    printf "\033[32mV\033[0m \033[37m%s\033[0m has been copied in \033[33m%s\033[0m\n\n" "$this_script_name" "$crcon_dir"
    printf "\033[32mWhat to do\033[0m : enter the CRCON folder and relaunch the script using this command :\n"
    printf "\033[36mrm %s && cd %s && sudo sh ./%s\033[0m\n\n" "$this_script_dir/$this_script_name" "$crcon_dir" "$this_script_name"
    exit
  else
    printf "\033[31mX\033[0m \033[37m%s\033[0m couldn't be copied in \033[33m%s\033[0m\n\n" "$this_script_name" "$crcon_dir"
    printf "\033[32mWhat to do\033[0m : Find your CRCON folder, copy this script in it and relaunch it from there.\n\n"
    exit
  fi
else
  printf "\033[32mV\033[0m This script is located in the CRCON folder\n"
fi

# Script has to be launched from CRCON folder
current_dir=$(pwd | tr -d '\n')
if [ ! "$current_dir" = "$crcon_dir" ]; then
  printf "\033[31mX\033[0m This \033[37m%s\033[0m script should be run from the CRCON folder\n\n" "$this_script_name"
  printf "\033[32mWhat to do\033[0m : enter the CRCON folder and relaunch the script using this command :\n"
  printf "\033[36mcd %s && sudo sh ./%s\033[0m\n\n" "$crcon_dir" "$this_script_name"
  exit
else
  printf "\033[32mV\033[0m This script has been run from the CRCON folder\n"
fi

# CRCON config check
if [ ! -f "$crcon_dir/compose.yaml" ] || [ ! -f "$crcon_dir/.env" ]; then
  printf "\033[31mX\033[0m CRCON doesn't seem to be configured\n"
  if [ ! -f "$crcon_dir/compose.yaml" ]; then
    printf "  \033[31mX\033[0m There is no '\033[37mcompose.yaml\033[0m' file in \033[33m%s\033[0m\n" "$crcon_dir"
  fi
  if [ ! -f "$crcon_dir/.env" ]; then
    printf "  \033[31mX\033[0m There is no '\033[37m.env\033[0m' file in \033[33m%s\033[0m\n" "$crcon_dir"
  fi
  printf "\n\033[32mWhat to do\033[0m : check your CRCON install in \033[33m%s\033[0m\n\n" "$crcon_dir"
  exit
else
  printf "\033[32mV\033[0m CRCON seems to be configured\n"
fi

printf "\033[32mV Everything's fine\033[0m Let's create this diagnose file !\n\n"

SEPARATOR="\n----------------------------------------\n"

printf "┌──────────────────────────────────────┐\n" > diagnose.log
printf "│ System resources                     │\n" >> diagnose.log
printf "└──────────────────────────────────────┘\n\n" >> diagnose.log
{ printf "# Number of CPU threads :$SEPARATOR"; nproc; } >> diagnose.log
{ printf "\n\n\n# Top 20 CPU processes (sort by live usage)$SEPARATOR"; ps aux --sort=-%cpu | head -n 20; } >> diagnose.log
{ printf "\n\n\n# Top 20 CPU processes (sort by total time)$SEPARATOR"; ps -aux --sort -time | head -n 20; } >> diagnose.log
{ printf "\n\n# RAM :$SEPARATOR"; free -h; } >> diagnose.log
{ printf "\n\n# Disk :$SEPARATOR"; df -h; } >> diagnose.log

printf "\n\n┌──────────────────────────────────────┐\n" >> diagnose.log
printf "│ Operating system                     │\n" >> diagnose.log
printf "└──────────────────────────────────────┘\n\n" >> diagnose.log
{ uname -a; cat /etc/os-release; } >> diagnose.log
apt update > /dev/nul
apt autoclean > /dev/nul
yes | apt autoremove > /dev/nul
{ printf "\n\n# Upgradable packages$SEPARATOR"; apt list --upgradable; } >> diagnose.log

printf "\n\n┌──────────────────────────────────────┐\n" >> diagnose.log
printf "│ Docker versions                      │\n" >> diagnose.log
printf "└──────────────────────────────────────┘\n\n" >> diagnose.log
{ printf "# Docker version$SEPARATOR"; docker version; } >> diagnose.log
{ printf "\n\n# Docker Compose plugin version$SEPARATOR"; docker compose version; } >> diagnose.log

printf "\n\n┌──────────────────────────────────────┐\n" >> diagnose.log
printf "│ CRCON install                        │\n" >> diagnose.log
printf "└──────────────────────────────────────┘\n\n" >> diagnose.log
{ printf "# Current folder$SEPARATOR"; pwd; } >> diagnose.log
{ printf "\n\n# Git status$SEPARATOR"; git status; } >> diagnose.log

printf "\n\n┌──────────────────────────────────────┐\n" >> diagnose.log
printf "│ Docker containers status             │\n" >> diagnose.log
printf "└──────────────────────────────────────┘\n\n" >> diagnose.log
{ printf "# Docker CRCON containers status$SEPARATOR"; docker compose ps; } >> diagnose.log

printf "\n\n┌──────────────────────────────────────┐\n" >> diagnose.log
printf "│ Docker containers logs (common)      │\n" >> diagnose.log
printf "└──────────────────────────────────────┘\n\n" >> diagnose.log
{ printf "# CRCON maintenance$SEPARATOR"; docker compose logs maintenance --tail 200; } >> diagnose.log
{ printf "\n\n# CRCON postgres$SEPARATOR"; docker compose logs postgres --tail 200; } >> diagnose.log
{ printf "\n\n# CRCON redis$SEPARATOR"; docker compose logs redis --tail 200; } >> diagnose.log

printf "\n\n┌──────────────────────────────────────┐\n" >> diagnose.log
printf "│ Docker containers logs (server 1)    │\n" >> diagnose.log
printf "└──────────────────────────────────────┘\n\n" >> diagnose.log
if grep -q "^HLL_HOST=[^[:space:]]" .env; then
    { printf "# CRCON backend_1$SEPARATOR"; docker compose logs backend_1 --tail 200; } >> diagnose.log
    { printf "\n\n# CRCON frontend_1$SEPARATOR"; docker compose logs frontend_1 --tail 200; } >> diagnose.log
    { printf "\n\n# CRCON supervisor_1$SEPARATOR"; docker compose logs supervisor_1 --tail 200; } >> diagnose.log
fi

# Docker containers logs - servers 2 to 10
for servernumber in $(seq 2 10); do
  server_name="HLL_HOST_$servernumber"
  if grep -q "^$server_name=[^[:space:]]" .env; then
    printf "\n\n┌──────────────────────────────────────┐\n" >> diagnose.log
    printf "│ Docker containers logs (server %s)    │\n" "$servernumber" >> diagnose.log
    printf "└──────────────────────────────────────┘\n\n" >> diagnose.log
    { printf "# CRCON backend_$servernumber$SEPARATOR"; docker compose logs backend_$servernumber --tail 200; } >> diagnose.log
    { printf "\n\n# CRCON frontend_$servernumber$SEPARATOR"; docker compose logs frontend_$servernumber --tail 200; } >> diagnose.log
    { printf "\n\n# CRCON supervisor_$servernumber$SEPARATOR"; docker compose logs supervisor_$servernumber --tail 200; } >> diagnose.log
  fi
done

printf "\n\n┌──────────────────────────────────────┐\n" >> diagnose.log
printf "│ config/supervisord.conf file(s)      │\n" >> diagnose.log
printf "└──────────────────────────────────────┘\n\n" >> diagnose.log
for supervisord_file in config/supervisord*.conf; do
    { printf "# File : $supervisord_file$SEPARATOR"; cat $supervisord_file; } >> diagnose.log
done

printf "\n\n┌──────────────────────────────────────┐\n" >> diagnose.log
printf "│ config files                         │\n" >> diagnose.log
printf "└──────────────────────────────────────┘\n\n" >> diagnose.log
{ printf "# File : compose.yaml$SEPARATOR"; cat compose.yaml; } >> diagnose.log
{ printf "\n\n# File : .env$SEPARATOR"; cat .env; } >> diagnose.log

# Delete usernames and passwords
sed -i 's/\(HLL_DB_PASSWORD=\).*/\1(redacted)/; s/\(HLL_DB_PASSWORD_[0-9]*=\).*/\1(redacted)/' diagnose.log
sed -i 's/\(HLL_DB_URL=postgresql:\/\/.*:\)\(.*\)@\([a-zA-Z0-9._-]*:[0-9]*\/.*\)/\1(redacted)@\3/' diagnose.log
sed -i 's/\(RCONWEB_API_SECRET=\).*/\1(redacted)/; s/\(RCONWEB_API_SECRET_[0-9]*=\).*/\1(redacted)/' diagnose.log
sed -i 's/\(HLL_HOST=\).*/\1(redacted)/; s/\(HLL_HOST_[0-9]*=\).*/\1(redacted)/' diagnose.log
sed -i 's/\(HLL_PASSWORD=\).*/\1(redacted)/; s/\(HLL_PASSWORD_[0-9]*=\).*/\1(redacted)/' diagnose.log
sed -i 's/\(GTX_SERVER_NAME_CHANGE_USERNAME=\).*/\1(redacted)/; s/\(GTX_SERVER_NAME_CHANGE_USERNAME_[0-9]*=\).*/\1(redacted)/' diagnose.log
sed -i 's/\(GTX_SERVER_NAME_CHANGE_PASSWORD=\).*/\1(redacted)/; s/\(GTX_SERVER_NAME_CHANGE_PASSWORD_[0-9]*=\).*/\1(redacted)/' diagnose.log
sed -i "s/\([backend|supervisor]_[0-9]*-[0-9]*  | + '\[' \)\(.*\)\( == '' '\]'\)/\1(redacted)\3/" diagnose.log

clear
echo "The diagnose file has been created."
echo "You'll find it in the actual folder under the name 'diagnose.log'"
echo " "
echo "--------------------------------------------------------"
echo "DO NOT share this file on a public forum/Discord channel"
echo "--------------------------------------------------------"
echo "as it could contain some of the passwords you have set"
echo "(RCON password, CRCON database password, CRCON users passwords scrambler)."
echo "They should have been automatically (redacted), but... Just check, OK ?"
echo " "
echo "You can open the diagnose.log file in any text editor"
echo "to review and delete any sensitive data before sharing."
echo " "
