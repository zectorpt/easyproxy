#!/bin/bash
# josemedeirosdealmeida@gmail.com
# Jose Almeida
DIALOG_CANCEL=1
DIALOG_ESC=255
HEIGHT=0
WIDTH=0
URL="$(hostname --fqdn)"
display_result() {
  dialog --title "$1" \
    --no-collapse \
    --msgbox "$result" 0 0
}
while true; do
  exec 3>&1
  selection=$(dialog \
    --backtitle "Easy Proxy Hatfield 2016   -   To download your stuff http://$URL:443" \
    --title "Menu" \
    --clear \
    --cancel-label "Drop to Shell" \
    --menu "Please select:" $HEIGHT $WIDTH 5 \
    "1" "Xclock - Unix Clock" \
    "2" "Google Chrome" \
    "3" "PDF Reader - Evince" \
    "4" "File Manager Nautilus" \
    "5" "Xeyes - Just to play..." \
    2>&1 1>&3)
  exit_status=$?
  exec 3>&-
  case $exit_status in
    $DIALOG_CANCEL)
      clear
      echo "Program terminated."
      exit
      ;;
    $DIALOG_ESC)
      clear
      echo "Program aborted." >&2
      exit 1
      ;;
  esac
  case $selection in
    0 )
      clear
      echo "Program terminated."
      ;;
    1 )
      echo "Best way to test X-Window"
      result=$(xclock &> /dev/null &)
      sleep 3
      ;;
    2 )
      echo "Opening Google Chrome... Is a little bit slow... Wait!"
      result=$(google-chrome-stable &> /dev/null &)
      sleep 15      
      ;;
    3 )
      echo "Opening Evince PDF Reader..."
      result=$(evince &> /dev/null &)
      sleep 5
      ;;
    4 )
      echo "Opening File Manager Nautilus."
      result=$(nautilus &> /dev/null &)
      sleep 5
      ;;
    5 )
      echo "Opening Xeyes - useless..."
      result=$(xeyes &> /dev/null &)
      sleep 3
      ;;
  esac
done
