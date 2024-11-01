# HLL_CRCON_Diagnose_file
If you encounter issues using CRCON, you'll have to give technical informations about your installation if you want to receive some help or advice. This bash script will collect them in a single file.

### :warning: Sensitive data
- Please be careful about sharing this file, as it contains your personal passwords (RCON, CRCON database, etc) :
- **NEVER share it on a public forum / Discord channel** ;
- If you do not fully trust the person asking these informations, you can open the file with any text editor and delete the sensitive data before sharing.

### Installation and use 
- download and copy the `diagnose.sh` file in your CRCON root folder (usually `/root/hll_rcon_tool`) ;
- get into a terminal session using SSH and launch the script using these commands :
  ```shell
  cd /root/hll_rcon_tool
  sh ./diagnose.sh
  ```
- download the `diagnose.log` file that has been created to your local computer, review its content for sensitive data, then share it.
