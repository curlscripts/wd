#!/bin/bash

# Check if the script is run as root
if [ "$EUID" -ne 0 ]; then
  echo "Please run this script as root."
  exit 1
fi
 
# Configuration
backup_root="/root/Rhel_upgrade_backup"
timestamp="backups_$(date +'%Y%m%d_%H')"
backup_directory="$backup_root/$timestamp"

# Configuration Backups
fstab_backup="$backup_directory/fstab_backup"
df_output_backup="$backup_directory/df_output.txt"
os_version_backup="$backup_directory/os_version.txt"
cmdline_booting_backup="$backup_directory/cmdline-booting-`hostname`.txt"
yum_repolist_backup="$backup_directory/repolist.txt"
installed_softwares_backup="$backup_directory/installed_softwares.txt"
sysctl_backup="$backup_directory/sysctl-`hostname`.txt"
repos_backup="$backup_directory/"
Pvs_Vgs_Lvs_backup="$backup_directory/pvs_vgs_lvs.txt"
kernel_backup="$backup_directory/kernel_backup.txt"
hosts_backup="$backup_directory/hosts_backup.txt"
issue_backup="$backup_directory/issue_backup.txt"
profile_backup="$backup_directory/profile_backup.txt"
root_crontab_backup="$backup_directory/root_crontab_backup.txt"
running_process="$backup_directory/running_process.txt"
services_output="$backup_directory/services_output.txt"
 
# Log file
log_file="/var/log/backup.log"
 
# Function to log messages
log() {
    echo "$(date +'%Y-%m-%d %H:%M:%S') $1" >> "$log_file"
}
 
# Check if the backup root directory exists
if [ ! -d "$backup_root" ]; then
    log "Backup root directory does not exist. Creating $backup_root."
    mkdir -p "$backup_root"
fi
 
# Create timestamped backup directory
mkdir -p "$backup_directory"


# Backup /etc/fstab
cp /etc/fstab "$fstab_backup"
if [ $? -eq 0 ]; then
    log "fstab backup successfully created: $fstab_backup"
    echo "fstab backup successfully created: $fstab_backup"
else
    log "fstab backup creation failed. Check the error message."
    echo "fstab backup creation failed. Check the error message."
fi
 
# Backup df output
df -h > "$df_output_backup"
if [ $? -eq 0 ]; then
    log "df output backup successfully created: $df_output_backup"
    echo "df output backup successfully created: $df_output_backup"    
else
    log "df output backup creation failed. Check the error message."
    echo "df output backup creation failed. Check the error message."
fi


# Backup OS Version
cp /etc/redhat-release "$os_version_backup"
if [ $? -eq 0 ]; then
    log "OS Version output backup successfully created: $os_version_backup"
    echo "OS Version output backup successfully created: $os_version_backup"
else
    log "OS Version backup creation failed. Check the error message."
    echo "OS Version backup creation failed. Check the error message."
fi


# Backup cmdline booting
cat /proc/cmdline > "$cmdline_booting_backup"
if [ $? -eq 0 ]; then
    log "Cmdline booting backup successfully created: $cmdline_booting_backup"
    echo "Cmdline booting backup successfully created: $cmdline_booting_backup"
else
    log "Cmdline booting backup creation failed. Check the error message."
    echo "Cmdline booting backup creation failed. Check the error message."
fi

# Backup Repo List
yum repolist > "$yum_repolist_backup"
if [ $? -eq 0 ]; then
    log "Repo List backup successfully created: $yum_repolist_backup"
    echo "Repo List backup successfully created: $yum_repolist_backup"
else
    log "Repos List backup creation failed. Check the error message."
    echo "Repos List backup creation failed. Check the error message."
fi

# Backup Installed Softwares
rpm -qa --queryformat '%{NAME}\n' > "$installed_softwares_backup"
if [ $? -eq 0 ]; then
    log "Installed Softwares backup successfully created: $installed_softwares_backup"
    echo "Installed Softwares backup successfully created: $installed_softwares_backup"
else
    log "Installed Softwares backup creation failed. Check the error message."
    echo "Installed Softwares backup creation failed. Check the error message."
fi

# Backup Sysctl
sysctl -a >> "$sysctl_backup" 2>&1
if [ $? -eq 0 ]; then
    log "Sysctl backup successfully created: $sysctl_backup"
    echo "Sysctl backup successfully created: $sysctl_backup"
else
    log "Sysctl backup creation failed. Check the error message."
    echo "Sysctl backup creation failed. Check the error message."
fi

# Backup Repos
cp /etc/yum.repos.d/* "$repos_backup"
if [ $? -eq 0 ]; then
    log "Repos backup successfully created in: $repos_backup"
    echo "Repos backup successfully created in: $repos_backup"
else
    log "Repos backup creation failed. Check the error message."
    echo "Repos backup creation failed. Check the error message."
fi

# Backup Pv's Vg's Lv's 
{ pvs ; vgs ; lvs ;} > "$Pvs_Vgs_Lvs_backup"
if [ $? -eq 0 ]; then
    log "Pvs_Vgs_Lvs backup successfully created: $Pvs_Vgs_Lvs_backup"
    echo "Pvs_Vgs_Lvs backup successfully created: $Pvs_Vgs_Lvs_backup"
else
    log "Pvs_Vgs_Lvs backup creation failed. Check the error message."
    echo "Pvs_Vgs_Lvs backup creation failed. Check the error message."
fi

# Backup Kernel
uname -r > "$kernel_backup"
if [ $? -eq 0 ]; then
    log "Kernel backup successfully created: $kernel_backup"
    echo "Kernel backup successfully created: $kernel_backup"
else
    log "kernel backup creation failed. Check the error message."
    echo "kernel backup creation failed. Check the error message."
fi

# Backup Hosts
cp /etc/hosts "$hosts_backup"
if [ $? -eq 0 ]; then
    log "Hosts backup successfully created: $hosts_backup"
    echo "Hosts backup successfully created: $hosts_backup"
else
    log "Hosts backup creation failed. Check the error message."
    echo "Hosts backup creation failed. Check the error message."
fi

# Backup Issues
cp /etc/issue "$issue_backup"
if [ $? -eq 0 ]; then
    log "Issues backup successfully created: $issue_backup"
    echo "Issues backup successfully created: $issue_backup"
else
    log "Issues backup creation failed. Check the error message."
    echo "Issues backup creation failed. Check the error message."
fi

# Backup Profile
cp /etc/profile "$profile_backup"
if [ $? -eq 0 ]; then
    log "Profile backup successfully created: $profile_backup"
    echo "Profile backup successfully created: $profile_backup"
else
    log "Profile backup creation failed. Check the error message."
    echo "Profile backup creation failed. Check the error message."
fi


# Backup root Crontab
Cron_file="/var/spool/cron/root"
# Check if cron root file exists
if [ -f "$Cron_file" ]; then
    cp -p /var/spool/cron/root "$root_crontab_backup"
    log "Root Crontab backup successfully created: $root_crontab_backup"
    echo "Root Crontab backup successfully created: $root_crontab_backup"
else
    log "Root Crontab backup creation failed. Check the error message."
    echo "Root Crontab backup creation failed. No Cron jobs for root."
fi

# Backup Running Process
ps -ef > "$running_process"
if [ $? -eq 0 ]; then
    log "Running Process backup successfully created: $running_process"
    echo "Running Process backup successfully created: $running_process"
else
    log "Running Process backup creation failed. Check the error message."
    echo "Running Process backup creation failed. Check the error message."
fi

# Backup Services
service --status-all > "$services_output" 2>&1
if [ $? -eq 0 ]; then
    log "Services backup successfully created: $services_output"
    echo "Services backup successfully created: $services_output"
else
    log "Services backup creation failed. Check the error message."
    echo "Services backup creation failed. Check the error message."
fi


sleep 8s


# Directory containing YUM repository configuration files
repo_dir="/etc/yum.repos.d/"

# Comment out lines starting with 'baseurl' and 'mirrorlist' in all repo files
for repo_file in "$repo_dir"*.repo; do
  sed -i -e '/^baseurl/ s/^/#/' -e '/^mirrorlist/ s/^/#/' "$repo_file"
done

echo "All repositories disabled successfully."

# Repository details
repo_name="rhel_6.10"
repo_ID="rhel_610"
repo_baseurl="http://millrsid01.sandisk.com/pxehome/rhel6.10-x86-64/"


# Create the repository configuration file
cat <<EOL > /etc/yum.repos.d/$repo_name.repo
[$repo_ID]
name=$repo_name Repository
baseurl="$repo_baseurl"
gpgcheck=0
enabled=1
EOL

echo "RHEL 6.10 Repository configuration completed successfully."
exit 0
