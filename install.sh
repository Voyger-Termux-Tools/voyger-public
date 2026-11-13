#!/data/data/com.termux/files/usr/bin/bash

# কালার সেটআপ
RED='\033[1;31m'
GREEN='\033[1;32m'
CYAN='\033[1;36m'
YELLOW='\033[1;33m'
NC='\033[0m'

clear

# রয়্যাল VOYGER X লোগো
echo -e "${RED}"
cat << "EOF"
██╗   ██╗ ██████╗ ██╗   ██╗ ██████╗ ███████╗██████╗     ██╗  ██╗
██║   ██║██╔═══██╗╚██╗ ██╔╝██╔════╝ ██╔════╝██╔══██╗    ╚██╗██╔╝
██║   ██║██║   ██║ ╚████╔╝ ██║  ███╗█████╗  ██████╔╝     ╚███╔╝ 
╚██╗ ██╔╝██║   ██║  ╚██╔╝  ██║   ██║██╔══╝  ██╔══██╗     ██╔██╗ 
 ╚████╔╝ ╚██████╔╝   ██║   ╚██████╔╝███████╗██║  ██║    ██╔╝ ██╗
  ╚═══╝   ╚═════╝    ╚═╝    ╚═════╝ ╚══════╝╚═╝  ╚═╝    ╚═╝  ╚═╝
EOF
echo -e "${NC}"

echo -e "${CYAN}Voyger X Premium Repository Installer${NC}"
echo ""

# ১. ডিপেন্ডেন্সি চেক
echo -e ">> ${CYAN}Checking system dependencies...${NC}"
if ! command -v curl &> /dev/null; then
    pkg install curl -y > /dev/null 2>&1
fi
echo -e "${GREEN}✅ Dependencies satisfied!${NC}"

# ২. ডিরেক্টরি তৈরি
mkdir -p $PREFIX/etc/apt/sources.list.d/
mkdir -p $PREFIX/etc/apt/trusted.gpg.d/

# ৩. পুরনো ফাইল পরিষ্কার
rm -f $PREFIX/etc/apt/trusted.gpg.d/voyger.gpg
rm -f $PREFIX/etc/apt/sources.list.d/voyger.list
apt clean > /dev/null 2>&1

# ৪. GPG Key ডাউনলোড
echo -e ">> ${CYAN}Downloading GPG Security Key...${NC}"
curl -H "Cache-Control: no-cache" -sL "https://raw.githubusercontent.com/Voyger-Termux-Tools/voyger-public/main/keys/voyger.gpg" -o $PREFIX/etc/apt/trusted.gpg.d/voyger.gpg
echo -e "${GREEN}✅ GPG key configured successfully!${NC}"

# ৫. সোর্স লিস্টে অ্যাড
echo -e ">> ${CYAN}Adding Voyger X repository...${NC}"
echo "deb [signed-by=$PREFIX/etc/apt/trusted.gpg.d/voyger.gpg] https://raw.githubusercontent.com/Voyger-Termux-Tools/voyger-public/repo-dist ./" > $PREFIX/etc/apt/sources.list.d/voyger.list
echo -e "${GREEN}✅ Repository added successfully!${NC}"

# ৬. আপডেট
echo -e ">> ${CYAN}Updating package repositories...${NC}"
rm -rf $PREFIX/var/lib/apt/lists/*
pkg update -y > /dev/null 2>&1
if [ $? -eq 0 ]; then
    echo -e "${GREEN}✅ System updated successfully!${NC}"
else
    echo -e "${RED}❌ Error: Failed to update package repositories${NC}"
fi

echo ""
echo -e "${RED}================================================${NC}"
echo -e "${GREEN} 🎉 VOYGER X IS READY TO DOMINATE!${NC}"
echo -e "${YELLOW} Use the command below to install the store:${NC}"
echo -e "${CYAN}   pkg install voyger-store${NC}"
echo -e "${RED}================================================${NC}"
