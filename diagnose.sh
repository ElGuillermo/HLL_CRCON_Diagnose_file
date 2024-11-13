#!/bin/bash
clear
printf "\nGenerating the diagnose file. Please wait...\n\n"
SEPARATOR="\n-------------------------------------------------------------------------------\n"
# System
{ printf "# Operating system$SEPARATOR"; uname -a; cat /etc/os-release; } > diagnose.log
apt update > /dev/nul
apt autoclean > /dev/nul
apt autoremove > /dev/nul
{ printf "\n\n\n# Upgradable packages$SEPARATOR"; apt list --upgradable; } >> diagnose.log
{ printf "\n\n\n# Number of CPUs$SEPARATOR"; nproc; } >> diagnose.log
{ printf "\n\n\n# RAM$SEPARATOR"; free -h; } >> diagnose.log
{ printf "\n\n\n# Top 20 CPU processes (sort by live usage)$SEPARATOR"; ps aux --sort=-%cpu | head -n 20; } >> diagnose.log
{ printf "\n\n\n# Top 20 CPU processes (sort by total time)$SEPARATOR"; ps -aux --sort -time | head -n 20; } >> diagnose.log
# CRCON files
{ printf "\n\n\n# Current folder$SEPARATOR"; pwd; } >> diagnose.log
{ printf "\n\n\n# Git status$SEPARATOR"; git status; } >> diagnose.log
# Docker
{ printf "\n\n\n# Docker version$SEPARATOR"; docker version; } >> diagnose.log
{ printf "\n\n\n# Docker Compose plugin version$SEPARATOR"; docker compose version; } >> diagnose.log
{ printf "\n\n\n# Docker CRCON containers status$SEPARATOR"; docker compose ps; } >> diagnose.log
# Docker containers logs - common
{ printf "\n\n\n# CRCON maintenance$SEPARATOR"; docker compose logs maintenance --tail 200; } >> diagnose.log
{ printf "\n\n\n# CRCON postgres$SEPARATOR"; docker compose logs postgres --tail 200; } >> diagnose.log
{ printf "\n\n\n# CRCON redis$SEPARATOR"; docker compose logs redis --tail 200; } >> diagnose.log
# Docker containers logs - 1st server
if grep -q "^HLL_HOST=[^[:space:]]" .env; then
    { printf "\n\n\n# CRCON backend_1$SEPARATOR"; docker compose logs backend_1 --tail 200; } >> diagnose.log
    { printf "\n\n\n# CRCON frontend_1$SEPARATOR"; docker compose logs frontend_1 --tail 200; } >> diagnose.log
    { printf "\n\n\n# CRCON supervisor_1$SEPARATOR"; docker compose logs supervisor_1 --tail 200; } >> diagnose.log
fi
# Docker containers logs - servers 2 to 10
for servernumber in $(seq 2 10); do
    server_name="HLL_HOST_$servernumber"
    if grep -q "^$server_name=[^[:space:]]" .env; then
        { printf "\n\n\n# CRCON backend_$servernumber$SEPARATOR"; docker compose logs backend_$servernumber --tail 200; } >> diagnose.log
        { printf "\n\n\n# CRCON frontend_$servernumber$SEPARATOR"; docker compose logs frontend_$servernumber --tail 200; } >> diagnose.log
        { printf "\n\n\n# CRCON supervisor_$servernumber$SEPARATOR"; docker compose logs supervisor_$servernumber --tail 200; } >> diagnose.log
    fi
done
# Files
for supervisord_file in config/supervisord*.conf; do
    { printf "\n\n\n# File : $supervisord_file$SEPARATOR"; cat $supervisord_file; } >> diagnose.log
done
{ printf "\n\n\n# File : compose.yaml$SEPARATOR"; cat compose.yaml; } >> diagnose.log
{ printf "\n\n\n# File : .env$SEPARATOR"; cat .env; } >> diagnose.log

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
