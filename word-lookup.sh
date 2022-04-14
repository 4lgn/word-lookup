#!/bin/sh

usage(){
	echo "Usage: $(basename "$0") [-h]
	Looks up the definition of currently selected word.
	-w: Use the wayland clipboard (instead of X11) "

}

USEWAYLAND=false

while getopts 'hw' c
do
	case $c in
		h) usage; exit ;;
		w) USEWAYLAND=true ;;
		*) usage; exit 1 ;;
	esac
done

shift $((OPTIND-1))

if [ $USEWAYLAND = true ]
then
	word=$(wl-paste -p)
else
	word=$(xclip -o)
fi

res=$(curl -s "https://api.dictionaryapi.dev/api/v2/entries/en_US/$word")
regex=$'"definition":"\K(.*?)(?=")'
definitions=$(echo "$res" | grep -Po "$regex")
separatedDefinition=$(sed ':a;N;$!ba;s/\n/\n\n/g' <<< "$definitions")
notify-send -a "word-lookup" "$word" "$separatedDefinition"
