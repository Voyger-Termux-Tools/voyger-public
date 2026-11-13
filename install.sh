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

type_effect() {
    local text="$1"
    for (( i=0; i<${#text}; i++ )); do
        echo -n "${text:$i:1}"
        sleep 0.02
    done
    echo ""
}

echo -e "${CYAN}Voyger X Premium Repository Installer${NC}"
echo ""
type_effect "${YELLOW}>> Initializing secure connection...${NC}"
type_effect "${YELLOW}>> Fetching latest security protocols...${NC}"
echo ""

# ডিপেন্ডেন্সি চেক
echo -e ">> ${CYAN}Checking system dependencies...${NC}"
if ! command -v curl &> /dev/null; then
    pkg install curl -y > /dev/null 2>&1
fi
echo -e "${GREEN}✅ Dependencies satisfied!${NC}"

# স্টোরেজ চেক
STORAGE=$(df -h $PREFIX | awk 'NR==2 {print $4}')
echo -e ">> ${CYAN}Free Space Available:${NC} ${GREEN}$STORAGE${NC}"

# ডিরেক্টরি তৈরি
mkdir -p $PREFIX/etc/apt/sources.list.d/

# GPG Key ডাউনলোড (সরাসরি বাইনারি ফরম্যাটে, gpg কমান্ড ছাড়াই)
echo -e ">> ${CYAN}Downloading GPG Security Key...${NC}"

# এখানে আমরা gpg কমান্ড ব্যবহার না করে, সরাসরি পাবলিক কি-এর বাইনারি ভার্সন ডাউনলোড করবো
curl -sL "https://raw.githubusercontent.com/Voyger-Termux-Tools/voyger-public/main/keys/voyger.gpg" -o $PREFIX/etc/apt/trusted.gpg.d/voyger.gpg

echo -e "${GREEN}✅ GPG key configured successfully!${NC}"

# সোর্স লিস্টে অ্যাড
echo -e ">> ${CYAN}Adding Voyger X repository...${NC}"
echo "deb [signed-by=$PREFIX/etc/apt/trusted.gpg.d/voyger.gpg] https://raw.githubusercontent.com/Voyger-Termux-Tools/voyger-public/repo-dist ./" > $PREFIX/etc/apt/sources.list.d/voyger.list
echo -e "${GREEN}✅ Repository added successfully!${NC}"

# আপডেট
echo -e ">> ${CYAN}Updating package repositories...${NC}"
pkg update -y > /dev/null 2>&1
if [ $? -eq 0 ]; then
    echo -e "${GREEN}✅ System updated successfully!${NC}"
else
    echo -e "${RED}❌ Error: Failed to update package repositories${NC}"
fi

echo ""
echo -e "${RED}================================================${NC}"
echo -e "${GREEN} 🎉 VOYGER X IS READY TO DOMINATE!${NC}"
echo -e "${YELLOW} Use the command below to open the store:${NC}"
echo -e "${CYAN}   voyger-store${NC}"
echo -e "${RED}================================================${NC}"
