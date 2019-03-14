#/bin/bash

RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'

cd ~
echo -e "${GREEN}****************************************************************************"
echo "* Ubuntu 16.04 is the recommended opearting system for this install.       *"
echo "*                                                                          *"
echo "* This script will install and configure your GOLDY Masternodes.     *"
echo "****************************************************************************"
echo && echo && echo
echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
echo "!                                                           !"
echo "! Make sure you double check your type before hitting enter !"
echo "!                                                           !"
echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
echo && echo && echo

echo -e "${RED}Type y If this is First Masternode to setup on this VPS to install all needed dependencies  
                  (no if you did it before)? [y/n]"
read DOSETUP

if [[ $DOSETUP =~ "y" ]] ; then
  sudo apt-get update
  sudo apt-get -y upgrade
  sudo apt-get -y dist-upgrade
  sudo apt-get install -y nano htop git
  sudo apt-get install -y software-properties-common
  sudo apt-get install -y build-essential libtool autotools-dev pkg-config libssl-dev
  sudo apt-get install -y libboost-all-dev
  sudo apt-get install -y libevent-dev
  sudo apt-get install -y libminiupnpc-dev
  sudo apt-get install -y autoconf
  sudo apt-get install -y automake
  sudo apt-get install -y unzip
  sudo add-apt-repository  -y  ppa:bitcoin/bitcoin
  sudo apt-get update
  sudo apt-get install -y libdb4.8-dev libdb4.8++-dev

  cd /var
  sudo touch swap.img
  sudo chmod 600 swap.img
  sudo dd if=/dev/zero of=/var/swap.img bs=1024k count=2000
  sudo mkswap /var/swap.img
  sudo swapon /var/swap.img
  sudo free
  sudo echo "/var/swap.img none swap sw 0 0" >> /etc/fstab
  cd

  sudo apt-get install -y ufw
  sudo ufw allow ssh/tcp
  sudo ufw limit ssh/tcp
  sudo ufw logging on
  echo "y" | sudo ufw enable
  sudo ufw status

  mkdir -p ~/bin
  echo 'export PATH=~/bin:$PATH' > ~/.bash_aliases
  source ~/.bashrc
fi

echo - e "${GREEN}Now Installing GOLDY Linux Wallet"
echo -e "${NC}"
sudo wget --no-check-certificate https://github.com/jubus08/goldy/releases/download/1.0.0.0/goldy.ubuntu16.04.zip
sudo unzip goldy.ubuntu16.04.zip
rm -rf goldy.ubuntu16.04.zip
cd goldy
mv goldy-cli /usr/sbin/goldy-cli
mv goldyd /usr/sbin/goldyd
mv goldy-qt /usr/sbin/goldy-qt
mv goldy-tx /usr/sbin/goldy-tx




echo -e "${GREEN}"
echo "Configure your masternodes now!"
echo "Paste the IP of this server, followed by [ENTER]:"
read IP

echo ""
echo "Enter masternode private key generated in WINDOWS WALLET"
read PRIVKEY

CONF_DIR=~/.goldy/
CONF_FILE=goldy.conf
PORT=30002

rm -rf $CONF_DIR/$CONF_FILE
mkdir -p $CONF_DIR
echo "rpcuser=Goldy"`shuf -i 100000-10000000 -n 1` >> $CONF_DIR/$CONF_FILE
echo "rpcpassword=pass"`shuf -i 100000-10000000 -n 1` >> $CONF_DIR/$CONF_FILE
echo "rpcallowip=127.0.0.1" >> $CONF_DIR/$CONF_FILE
echo "server=1" >> $CONF_DIR/$CONF_FILE
echo "daemon=1" >> $CONF_DIR/$CONF_FILE
echo "masternode=1" >> $CONF_DIR/$CONF_FILE
echo "masternodeaddr=$IP:$PORT" >> $CONF_DIR/$CONF_FILE
echo "masternodeprivkey=$PRIVKEY" >> $CONF_DIR/$CONF_FILE
sudo ufw allow $PORT/tcp

goldyd -daemon

echo -e "${RED} Masternode Setup Complete"
echo -e "${GREEN} Check your Status using this commands:"
echo "goldy-cli getinfo   |# view blockchain infos"
echo "goldy-cli masternode status   |# view masternode status, if is running or not"
echo -e "${NC} "