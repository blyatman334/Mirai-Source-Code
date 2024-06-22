#!/bin/bash

if [ "$(id -u)" != "0" ]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi

echo -n "Install mysql-server and mysql-client (y/n)? "
old_stty_cfg=$(stty -g)
stty raw -echo
answer=$( while ! head -c 1 | grep -i '[ny]' ;do true ;done )
stty $old_stty_cfg
if echo "$answer" | grep -iq "^y" ;then
    echo "Installing mysql..."
    apt-get install -y mysql-server mysql-client
fi

echo -n "Installing gcc, golang, electric-fence..."
apt-get install -y gcc golang electric-fence

echo "Creating folder /etc/xcompile"
mkdir /etc/xcompile > /dev/null 2>&1

cd /etc/xcompile

# Download and extract each cross compiler
cross_compilers=(
    "https://www.landley.net/aboriginal/downloads/binaries/cross-compiler-armv4l.tar.gz"
    "https://www.landley.net/aboriginal/downloads/binaries/cross-compiler-armv5l.tar.gz"
    "https://www.landley.net/aboriginal/downloads/binaries/cross-compiler-armv6l.tar.gz"
    "https://www.landley.net/aboriginal/downloads/binaries/cross-compiler-i586.tar.gz"
    "https://www.landley.net/aboriginal/downloads/binaries/cross-compiler-m68k.tar.gz"
    "https://www.landley.net/aboriginal/downloads/binaries/cross-compiler-mips.tar.gz"
    "https://www.landley.net/aboriginal/downloads/binaries/cross-compiler-mipsel.tar.gz"
    "https://www.landley.net/aboriginal/downloads/binaries/cross-compiler-powerpc.tar.gz"
    "https://www.landley.net/aboriginal/downloads/binaries/cross-compiler-sh4.tar.gz"
    "https://www.landley.net/aboriginal/downloads/binaries/cross-compiler-sparc.tar.gz"
)

for url in "${cross_compilers[@]}"; do
    echo "Downloading $url ..."
    wget -q --show-progress "$url"
    tar -zxf "$(basename "$url")"
    rm "$(basename "$url")"
done

# Set up PATH for each architecture
export PATH=$PATH:/etc/xcompile/armv4l/bin
export PATH=$PATH:/etc/xcompile/armv5l/bin
export PATH=$PATH:/etc/xcompile/armv6l/bin
export PATH=$PATH:/etc/xcompile/i586/bin
export PATH=$PATH:/etc/xcompile/m68k/bin
export PATH=$PATH:/etc/xcompile/mips/bin
export PATH=$PATH:/etc/xcompile/mipsel/bin
export PATH=$PATH:/etc/xcompile/powerpc/bin
export PATH=$PATH:/etc/xcompile/sh4/bin
export PATH=$PATH:/etc/xcompile/sparc/bin
