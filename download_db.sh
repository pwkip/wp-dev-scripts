# Depends on WP-CLI for safe search-replace in the Database http://wp-cli.org/
# Your SSH server needs to be trusted. https://www.clearos.com/resources/documentation/clearos/content:en_us:kb_o_setting_up_ssh_trust_between_two_servers

# Local site
local_wp_dir='/c/xampp/htdocs/mysite' # WP dir
local_db_host='localhost'
local_db_name='mysite'
local_db_user='root'
local_db_pwd=''

# Live site
ssh_user='my_ssh_username'
ssh_host='my_ssh_hostname'
live_db_host='localhost'
live_db_name='my_live_db_name'
live_db_user='my_live_db_username'
live_db_pwd='my_live_db_password'

# Find-replace
find='mylivesite.com'
replace='localhost/mysite'

# Output variable checks

echo "local_wp_dir  : "${local_wp_dir}
echo "local_db_host : "${local_db_host}
echo "local_db_name : "${local_db_name}
echo "local_db_user : "${local_db_user}
echo "local_db_pwd  : "${local_db_pwd}
echo "ssh_user      : "${ssh_user}
echo "ssh_host      : "${ssh_host}
echo "live_db_host  : "${live_db_host}
echo "live_db_name  : "${live_db_name}
echo "live_db_user  : "${live_db_user}
echo "live_db_pwd   : "${live_db_pwd}
echo "find          : "${find}
echo "replace       : "${replace}

read -rsp $'Looking good? Press enter to start...'
echo ''

# Change directory to wordpress install folder
cd ${local_wp_dir}

# download a mysqldump of the live database and overwrite local database with it
mysql -h ${local_db_host} -u ${local_db_user} --password=${local_db_pwd} ${local_db_name} < <(ssh ${ssh_user}@${ssh_host} "mysqldump -h "${live_db_host}" -u "${live_db_user}" -p"${live_db_pwd}" "${live_db_name}"")

# Perform safe find and replace in the local database
wp search-replace $find $replace

read -rsp $'All done. Press enter to continue...'
