#!/data/data/com.termux/files/usr/bin/bash

RED='\033[1;31m'
GREEN='\033[1;32m'
CYAN='\033[1;36m'
YELLOW='\033[1;33m'
NC='\033[0m'

clear
echo -e "${RED}💀 VOYGER X UNINSTALLER 💀${NC}"
echo ""
echo -e "${YELLOW}[!] This will completely remove Voyger X from your Termux.${NC}"
echo -e "${YELLOW}[!] All installed Voyger tools will be removed.${NC}"
echo ""

read -p "Are you sure? (y/n): " confirm
if [ "$confirm" != "y" ]; then
    echo -e "${CYAN}Uninstallation cancelled.${NC}"
    exit 0
fi

echo ""
echo -e ">> ${CYAN}Removing repository source list...${NC}"
rm -f $PREFIX/etc/apt/sources.list.d/voyger.list
echo -e "${GREEN}✅ Source list removed!${NC}"

echo -e ">> ${CYAN}Removing GPG Keys...${NC}"
rm -f $PREFIX/etc/apt/trusted.gpg.d/voyger.gpg
# পুরনো devils কি যদি থাকে
rm -f $PREFIX/etc/apt/trusted.gpg.d/devils.gpg
echo -e "${GREEN}✅ GPG keys removed!${NC}"

echo -e ">> ${CYAN}Removing installed Voyger tools...${NC}"
for tool in $(ls $PREFIX/bin | grep "^voyger-"); do
    echo -e "   [-] Removing $tool..."
    rm -f $PREFIX/bin/$tool
done
echo -e "${GREEN}✅ All Voyger tools removed!${NC}"

echo -e ">> ${CYAN}Cleaning up APT cache and lists...${NC}"
apt clean
rm -rf $PREFIX/var/lib/apt/lists/*
echo -e "${GREEN}✅ Cache cleared!${NC}"

echo -e ">> ${CYAN}Removing Voyger history files...${NC}"
rm -f $HOME/.voyger_favorites
rm -f $HOME/.voyger_welcomed
echo -e "${GREEN}✅ History cleared!${NC}"

echo ""
echo -e "${RED}================================================${NC}"
echo -e "${GREEN} 💀 VOYGER X HAS BEEN COMPLETELY REMOVED! 💀${NC}"
echo -e "${YELLOW} You can now reinstall it fresh.${NC}"
echo -e "${RED}================================================${NC}"
