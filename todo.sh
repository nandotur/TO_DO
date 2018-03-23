#!/bin/bash
#
RAWLIST=./todolist.txt
let RISEGREP=0
let dataOK=0

todolist () {
more ./todolist.txt
}

leggicontatore () {
RIGA=$(tail -1 $RAWLIST)
contatore=$(echo $RIGA | cut -f1 -d" ")
echo $contatore
}

cancellariga () {
sed -i "/^$1 /d" $RAWLIST
}

usage () {
echo
echo "usage: ./todo.sh <add|del|mod|list> gg/mm/aaaa-HH:MM note"
echo "                  add gg/mm/aaaa-HH:MM note"
echo "                  del <num>"
echo "                  mod <num> gg/mm/aaaa-HH:MM note"
echo "                  list"
echo
}

validadata () {
#echo "dataDaValidare=[$1]"
GIORNOMDY="${1:3:1}${1:4:1}/${1:0:1}${1:1:1}/${1:6:1}${1:7:1}${1:8:1}${1:9:1}"
ORA="${1:11:5}"
#echo "ORA=$ORA"
#echo "GIORNOMDY=$GIORNOMDY"
echo $1 | egrep -q '^[0-3][0-9]/[0-1][0-9]/[0-9]{4}-[0-2][0-9]:[0-5][0-9]$' && (date -d $GIORNOMDY && date +"%H:%M" -d $ORA)>>/dev/null 2>&1

#let RISEGREP=$?
#echo "RISEGREP=[$RISEGREP]"
#if (( $RISEGREP ))  
if (( $? ))
then let dataOK=0
else let dataOK=1
fi
echo dataOK=[$dataOK]
}

errore_data () {
echo
echo "Formato data errato."
echo "inserisci la data nel formato gg/mm/aaaa-HH:MM"
echo
}

if [ ! -f $RAWLIST ]; then
   echo "0"> $RAWLIST 
fi
[ $# -eq 0 ] && { todolist; exit 1; }

#echo "parametro 1=[$1]"
case "$1" in

	add) 	validadata $2
		echo "add-Valido[$2]"
		echo "dataOK=[$dataOK]"
		if  (( $dataOK ))
		then	let contatore=$(leggicontatore)+1
			echo "$contatore $2 $3">>$RAWLIST
			todolist
		else	errore_data
			exit
		fi
        ;;
	del)	#sed -i "/^$2 /d" $RAWLIST
		cancellariga $2
		todolist
	;;
	mod)	validadata $3
	        if (( $dataOK ))
		then	cancellariga $2
			echo "$2 $3 $4">>$RAWLIST
			sort $RAWLIST>tmp.tmp
			mv tmp.tmp $RAWLIST
			todolist
		else	errore_data
		        exit

		fi
		;;
	list|l)	todolist
		;;
	h|help)	usage
	;;
	*)	echo "comando non previsto."
		usage
	;;
esac


