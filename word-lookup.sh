#!/bin/bash

usage(){
	echo "Usage: $(basename "$0") [-h]
        Looks up the definition of currently selected word."
}

while getopts 'h' c
do
	case $c in
		h) usage; exit ;;
		*) usage; exit 1 ;;
	esac
done

word=$(xclip -o)
res=$(curl -s "https://api.dictionaryapi.dev/api/v2/entries/en_US/$word")
regex=$'"definition":"\K(.*?)(?=")'
definitions=$(echo $res | grep -Po "$regex")
separatedDefinition=$(sed ':a;N;$!ba;s/\n/\n\n/g' <<< "$definitions")
notify-send -u low -a "word-lookup" -t 10000 "$word" "$separatedDefinition"
