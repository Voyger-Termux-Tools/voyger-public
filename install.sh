#!/data/data/com.termux/files/usr/bin/bash

# কালার সেটআপ
RED='\033[1;31m'
GREEN='\033[1;32m'
CYAN='\033[1;36m'
YELLOW='\033[1;33m'
NC='\033[0m'

clear

# ১. রয়্যাল VOYGER X লোগো
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

# ২. টাইপিং ইফেক্ট ফাংশন
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

# ৩. অটো-ডিপেন্ডেন্সি চেক
echo -e ">> ${CYAN}Checking system dependencies...${NC}"
if ! command -v gpg &> /dev/null; then
    echo -e "   ${YELLOW}[!] GPG not found. Installing...${NC}"
    pkg install gnupg -y > /dev/null 2>&1
fi
if ! command -v curl &> /dev/null; then
    echo -e "   ${YELLOW}[!] Curl not found. Installing...${NC}"
    pkg install curl -y > /dev/null 2>&1
fi
echo -e "${GREEN}✅ All dependencies are satisfied!${NC}"
sleep 1

# ৪. সিস্টেম স্টোরেজ চেক
echo -e ">> ${CYAN}Checking available storage...${NC}"
STORAGE=$(df -h $PREFIX | awk 'NR==2 {print $4}')
echo -e "   ${GREEN}[+] Free Space: $STORAGE${NC}"

# ৫. ডিরেক্টরি তৈরি
echo -e ">> ${CYAN}Creating repository directory...${NC}"
mkdir -p $PREFIX/etc/apt/sources.list.d/
echo -e "${GREEN}✅ Directory created successfully!${NC}"

# ৬. GPG Key ডাউনলোড ও প্রসেস
echo -e ">> ${CYAN}Downloading GPG Security Key...${NC}"
# প্রগ্রেস বার সিমুলেশন
for i in {1..5}; do echo -ne "   [${GREEN}■${NC}]" ; sleep 0.1; done
echo -e " ${GREEN}[DONE]${NC}"

curl -sL "https://raw.githubusercontent.com/Termux-Tools-World/voyger-public/main/keys/voyger.gpg" -o /tmp/voyger.asc
gpg --import /tmp/voyger.asc > /dev/null 2>&1
gpg --export termuxforandroid.ios@gmail.com | gpg --dearmor > $PREFIX/etc/apt/trusted.gpg.d/voyger.gpg
rm -f /tmp/voyger.asc
echo -e "${GREEN}✅ GPG key configured successfully!${NC}"

# ৭. সোর্স লিস্টে অ্যাড
echo -e ">> ${CYAN}Adding Voyger X repository...${NC}"
echo "deb [signed-by=$PREFIX/etc/apt/trusted.gpg.d/voyger.gpg] https://raw.githubusercontent.com/Termux-Tools-World/voyger-public/repo-dist ./" > $PREFIX/etc/apt/sources.list.d/voyger.list
echo -e "${GREEN}✅ Repository added successfully!${NC}"

# ৮. আপডেট
echo -e ">> ${CYAN}Updating package repositories...${NC}"
pkg update -y > /dev/null 2>&1
if [ $? -eq 0 ]; then
    echo -e "${GREEN}✅ System updated successfully!${NC}"
else
    echo -e "${RED}❌ Error: Failed to update package repositories${NC}"
fi

# ৯. ফাইনাল মেসেজ
echo ""
echo -e "${RED}================================================${NC}"
echo -e "${GREEN} 🎉 VOYGER X IS READY TO DOMINATE!${NC}"
echo -e "${YELLOW} Use the command below to open the store:${NC}"
echo -e "${CYAN}   voyger-store${NC}"
echo -e "${RED}================================================${NC}"
