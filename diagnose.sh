#!/bin/bash
echo " \nGenerating the diagnose file. Please wait...\n "
SEPARATOR="-------------------------------------------------------------------------------"
SPACER=" \n \n \n"
{ echo "# Operating system"; echo $SEPARATOR; uname -a; cat /etc/os-release; } > diagnose.log
{ echo $SPACER; echo "# Current folder"; echo $SEPARATOR; pwd; } >> diagnose.log
{ echo $SPACER; echo "# Number of CPUs"; echo $SEPARATOR; nproc; } >> diagnose.log
{ echo $SPACER; echo "# RAM"; echo $SEPARATOR; free -h; } >> diagnose.log
{ echo $SPACER; echo "# Top 20 CPU processes"; echo $SEPARATOR; ps aux --sort=-%cpu | head -n 20; } >> diagnose.log
{ echo $SPACER; echo "# Docker version"; echo $SEPARATOR; docker version; } >> diagnose.log
{ echo $SPACER; echo "# Docker Compose plugin version"; echo $SEPARATOR; docker compose version; } >> diagnose.log
{ echo $SPACER; echo "# Docker CRCON containers status"; echo $SEPARATOR; docker compose ps; } >> diagnose.log
{ echo $SPACER; echo "# CRCON backend"; echo $SEPARATOR; docker compose logs backend_1 --tail 200; } >> diagnose.log
{ echo $SPACER; echo "# CRCON frontend"; echo $SEPARATOR; docker compose logs frontend_1 --tail 200; } >> diagnose.log
{ echo $SPACER; echo "# CRCON maintenance"; echo $SEPARATOR; docker compose logs maintenance --tail 200; } >> diagnose.log
{ echo $SPACER; echo "# CRCON postgres"; echo $SEPARATOR; docker compose logs postgres --tail 200; } >> diagnose.log
{ echo $SPACER; echo "# CRCON redis"; echo $SEPARATOR; docker compose logs redis --tail 200; } >> diagnose.log
{ echo $SPACER; echo "# CRCON supervisor"; echo $SEPARATOR; docker compose logs supervisor_1 --tail 200; } >> diagnose.log
{ echo $SPACER; echo "# CRCON compose.yaml"; echo $SEPARATOR; cat compose.yaml; } >> diagnose.log
{ echo $SPACER; echo "# CRCON .env"; echo $SEPARATOR; cat .env; } >> diagnose.log

sed -i 's/\(HLL_DB_PASSWORD=\).*/\1(redacted)/; s/\(HLL_DB_PASSWORD_[0-100]*=\).*/\1(redacted)/' diagnose.log
sed -i 's/\(HLL_DB_URL=postgresql:\/\/.*:\)\(.*\)@\([a-zA-Z0-9._-]*:[0-9]*\/.*\)/\1(redacted)@\3/' diagnose.log
sed -i 's/\(RCONWEB_API_SECRET=\).*/\1(redacted)/; s/\(RCONWEB_API_SECRET_[0-100]*=\).*/\1(redacted)/' diagnose.log
sed -i 's/\(HLL_HOST=\).*/\1(redacted)/; s/\(HLL_HOST_[0-100]*=\).*/\1(redacted)/' diagnose.log
sed -i 's/\(HLL_PASSWORD=\).*/\1(redacted)/; s/\(HLL_PASSWORD_[0-100]*=\).*/\1(redacted)/' diagnose.log
sed -i 's/\(GTX_SERVER_NAME_CHANGE_USERNAME=\).*/\1(redacted)/; s/\(GTX_SERVER_NAME_CHANGE_USERNAME_[0-100]*=\).*/\1(redacted)/' diagnose.log
sed -i 's/\(GTX_SERVER_NAME_CHANGE_PASSWORD=\).*/\1(redacted)/; s/\(GTX_SERVER_NAME_CHANGE_PASSWORD_[0-100]*=\).*/\1(redacted)/' diagnose.log

echo "The diagnose file has been created."
echo "You'll find it in the actual folder under the name 'diagnose.log'"
echo " "
echo "--------------------------------------------------------"
echo "DO NOT share this file on a public forum/Discord channel"
echo "--------------------------------------------------------"
echo "as it could contain some of the passwords you have set"
echo "(RCON password, CRCON database password, CRCON users passwords scrambler)."
echo "They should have been (redacted), but... Just check, OK ?"
echo " "
echo "You can open the diagnose.log file in any text editor"
echo "to delete any sensitive data before sharing."
echo " "
