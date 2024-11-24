# HLL_CRCON_Diagnose_file
If you encounter issues using Hell Let Loose (HLL) CRCON (see : https://github.com/MarechJ/hll_rcon_tool), you'll have to give technical informations about your installation if you want to receive some help or advice.
That means you would have to enter multiple command in your VPS terminal. This can be rather long and techy.

-> This bash script will automatically collect all the debugging infos in a single file you can share with the person who is trying to help you.

### :warning: Sensitive data
- Please be careful about sharing this file, as it could contain your personal passwords (RCON, CRCON database, etc).  
The script should have (redacted) them, but... Just check OK ?
- **NEVER share it on a public forum / Discord channel** ;
- If you do not fully trust the person asking these informations, you can open the file with any text editor and delete any sensitive data before sharing (search in it for your passwords, VPS and game server IPs, etc).

> [!NOTE]
> The shell commands given below assume your CRCON is installed in `/root/hll_rcon_tool`.  
> You may have installed your CRCON in a different folder.  
>   
> Some Ubuntu Linux distributions disable the `root` user and `/root` folder by default.  
> In these, your default user is `ubuntu`, using the `/home/ubuntu` folder.  
> You should then find your CRCON in `/home/ubuntu/hll_rcon_tool`.  
>   
> If so, you'll have to adapt the commands below accordingly.

## Install
- Log into your CRCON host machine using SSH and enter these commands (one line at at time) :
  ```shell
  cd /root/hll_rcon_tool
  wget https://raw.githubusercontent.com/ElGuillermo/HLL_CRCON_Diagnose_file/refs/heads/main/diagnose.sh
  ```

## Use
- Log into your CRCON host machine using SSH and enter these commands (one line at at time) :
  ```shell
  cd /root/hll_rcon_tool
  sh ./diagnose.sh
  ```
- download the `/root/hll_rcon_tool/diagnose.log` file
- review its content for sensitive data
- share it
