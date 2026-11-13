#!/data/data/com.termux/files/usr/bin/bash

# কালার সেটআপ
RED='\033[1;31m'
GREEN='\033[1;32m'
CYAN='\033[1;36m'
YELLOW='\033[1;33m'
MAGENTA='\033[1;35m'
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

# ৩. ইন্টারনেট কানেকশন চেক
type_effect "${YELLOW}>> Verifying internet connection...${NC}"
if ! ping -c 1 8.8.8.8 &> /dev/null; then
    echo -e "${RED}❌ Error: No internet connection detected.${NC}"
    exit 1
fi
echo -e "${GREEN}✅ Internet connection verified!${NC}"
sleep 1

# ৪. সিস্টেম স্পেসিফিকেশন শো
type_effect "${YELLOW}>> Fetching device specifications...${NC}"
echo -e "   ${CYAN}Device:${NC} $(getprop ro.product.model)"
echo -e "   ${CYAN}Android:${NC} $(getprop ro.build.version.release)"
echo -e "   ${CYAN}Arch:${NC} $(uname -m)"
echo -e "${GREEN}✅ Target device acquired!${NC}"
sleep 1

# ৫. অটো-ডিপেন্ডেন্সি চেক
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

# ৬. অটো-ক্লিন (আগের ভুল ফাইল থাকলে মুছে ফেলা)
echo -e ">> ${CYAN}Cleaning up previous configurations...${NC}"
rm -f $PREFIX/etc/apt/sources.list.d/voyger.list
rm -f $PREFIX/etc/apt/trusted.gpg.d/voyger.gpg
echo -e "${GREEN}✅ Environment cleaned!${NC}"

# ৭. স্টোরেজ চেক
STORAGE=$(df -h $PREFIX | awk 'NR==2 {print $4}')
echo -e ">> ${CYAN}Free Space Available:${NC} ${GREEN}$STORAGE${NC}"

# ৮. ডিরেক্টরি তৈরি
mkdir -p $PREFIX/etc/apt/sources.list.d/

# ৯. GPG Key ডাউনলোড ও প্রসেস (প্রগ্রেস বার সহ)
echo -e ">> ${CYAN}Downloading GPG Security Key...${NC}"
curl -sL "https://raw.githubusercontent.com/Termux-Tools-World/voyger-public/main/keys/voyger.gpg" -o /tmp/voyger.asc

# প্রগ্রেস বার সিমুলেশন
echo -ne "   ["
for i in {1..10}; do echo -ne "${GREEN}■${NC}"; sleep 0.05; done
echo -e "] ${GREEN}100%${NC}"

gpg --import /tmp/voyger.asc > /dev/null 2>&1
gpg --export termuxforandroid.ios@gmail.com | gpg --dearmor > $PREFIX/etc/apt/trusted.gpg.d/voyger.gpg
rm -f /tmp/voyger.asc
echo -e "${GREEN}✅ GPG key configured successfully!${NC}"

# ১০. সোর্স লিস্টে অ্যাড
echo -e ">> ${CYAN}Adding Voyger X repository...${NC}"
echo "deb [signed-by=$PREFIX/etc/apt/trusted.gpg.d/voyger.gpg] https://raw.githubusercontent.com/Termux-Tools-World/voyger-public/repo-dist ./" > $PREFIX/etc/apt/sources.list.d/voyger.list
echo -e "${GREEN}✅ Repository added successfully!${NC}"

# ১১. আপডেট
echo -e ">> ${CYAN}Updating package repositories...${NC}"
pkg update -y > /dev/null 2>&1
if [ $? -eq 0 ]; then
    echo -e "${GREEN}✅ System updated successfully!${NC}"
else
    echo -e "${RED}❌ Error: Failed to update package repositories${NC}"
fi

# ১২. ফাইনাল মেসেজ
echo ""
echo -e "${RED}================================================${NC}"
echo -e "${GREEN} 🎉 VOYGER X IS READY TO DOMINATE!${NC}"
echo -e "${YELLOW} Use the command below to open the store:${NC}"
echo -e "${CYAN}   voyger-store${NC}"
echo -e "${RED}================================================${NC}"
