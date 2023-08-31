cat /etc/os-release | grep "UBUNTU_CODENAME" | awk -F= '{ print $2 }'
