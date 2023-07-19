#!/bin/bash

#check if sw is installed
is_installed() {
  dpkg -s "$1">/dev/null 2>&1
}

#installer function
sw_installer() {
  if ! is_installed "$1"; then
    echo "Installing $1..."
    sudo apt-get install $1
  else
    echo "$1 already installed"
  fi
}

#software installer
sw_installer virtualbox
sw_installer packer
sw_installer vagrant

vagrant_plugin_name = "vagrant-reload"
vagrant_plugin_ver = "0.0.1"

#plugin installer
if ! vagrant plugin list | grep -q "$vagrant_plugin_name"; then
  echo "Installing $vagrant_plugin_name $vagrant_plugin_ver"
  vagrant plugin install "$vagrant_plugin_name" --plugin-version "$vagrant_plugin_ver"

else 
  echo "$vagrant_plugin_name $vagrant_plugin_ver already installed"
fi

cd /home/$(whoami)

sw_installer git

git clone https://github.com/rapid7/metasploitable3.git

cd /metasploitable3/scripts/installs && echo "powershell -Command "[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.SecurityProtocolType]::Tls12; (New-Object System.Net.WebClient).DownloadFile('https://bitbucket.org/alexkasko/openjdk-unofficial-builds/downloads/openjdk-1.7.0-u80-unofficial-windows-amd64-installer.zip', 'C:\Windows\Temp\openjdk-1.7.0-u80-unofficial-windows-amd64-installer.zip')" <NUL
cmd /c ""C:\Program Files\7-Zip\7z.exe" x "C:\Windows\Temp\openjdk-1.7.0-u80-unofficial-windows-amd64-installer.zip" -oC:\openjdk7"" > install_openjdk6.bat

cd /home/$(whoami)/metasploitable3

echo "Per iniziare l'installazione di metasploitable3 usare questo comando:" 
echo "OS Windows2008: packer build --only=virtualbox-iso ./packer/templates/windows_2008_r2.json"
echo "OS Ubuntu14.04: packer build --only=virtualbox-iso ./packer/templates/ubuntu_1404.json"