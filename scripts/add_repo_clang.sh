sudo add-apt-repository "deb http://apt.llvm.org/$1/ llvm-toolchain-$1 main"
#that should output to /etc/apt/sources.list
wget https://apt.llvm.org/llvm-snapshot.gpg.key
sudo apt-key add llvm-snapshot.gpg.key
rm llvm-snapshot.gpg.key
sudo apt update
echo "To get rid of the warning, go to this link: https://askubuntu.com/questions/1403556/key-is-stored-in-legacy-trusted-gpg-keyring-after-ubuntu-22-04-update"
