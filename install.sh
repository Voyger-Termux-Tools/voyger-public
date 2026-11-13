#!/data/data/com.termux/files/usr/bin/bash

# কালার কোড সেটআপ
RED='\033[1;31m'
GREEN='\033[1;32m'
CYAN='\033[1;36m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

clear

# ১. নতুন রয়্যাল VOYGER X লোগো (লাল রঙে)
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

echo -e "${CYAN}Voyger X Repository Installer${NC}"
echo ""

# ২. ডিরেক্টরি তৈরি
echo -e ">> ${CYAN}Creating repository directory...${NC}"
mkdir -p $PREFIX/etc/apt/sources.list.d/
echo -e "${GREEN}✅ Creating repository directory completed successfully!${NC}"

# ৩. GPG Key ডাউনলোড ও অটো-প্রসেস (নতুন পাবলিক রিপো থেকে)
echo -e ">> ${CYAN}Downloading and Processing GPG key...${NC}"

# নতুন পাবলিক রিপো থেকে কি ডাউনলোড
curl -sL "https://raw.githubusercontent.com/Termux-Tools-World/voyger-public/main/keys/voyger.gpg" -o /tmp/voyger.asc

# কি-টা gpg কি-রিং-এ ইমপোর্ট করা
gpg --import /tmp/voyger.asc > /dev/null 2>&1

# সঠিক ফরম্যাটে কি-টা এক্সপোর্ট করে APT ফোল্ডারে রাখা
gpg --export termuxforandroidandios@gmail.com | gpg --dearmor > $PREFIX/etc/apt/trusted.gpg.d/voyger.gpg

# টেম্পোরারি ফাইল ডিলিট করা
rm -f /tmp/voyger.asc

if [ $? -eq 0 ]; then
    echo -e "${GREEN}✅ GPG key configured successfully!${NC}"
else
    echo -e "${RED}❌ Failed to process GPG key.${NC}"
    exit 1
fi

# ৪. সোর্স লিস্টে অ্যাড করা (নতুন পাবলিক রিপো)
echo -e ">> ${CYAN}Adding Voyger X repository...${NC}"
echo "deb [signed-by=$PREFIX/etc/apt/trusted.gpg.d/voyger.gpg] https://raw.githubusercontent.com/Termux-Tools-World/voyger-public/main ./" > $PREFIX/etc/apt/sources.list.d/voyger.list
echo -e "${GREEN}✅ Adding Voyger X repository completed successfully!${NC}"

# ৫. আপডেট
echo -e ">> ${CYAN}Updating package repositories...${NC}"
pkg update -y > /dev/null 2>&1
if [ $? -eq 0 ]; then
    echo -e "${GREEN}✅ Updating package repositories completed successfully!${NC}"
else
    echo -e "${RED}❌ Error: Failed to update package repositories${NC}"
fi

echo ""
echo -e "${GREEN}✅ Setup Complete! Use: pkg install <tool-name>${NC}"
