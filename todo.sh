#!/bin/bash
#
RAWLIST=./todolist.txt

todolist () {
more ./todolist.txt
}

leggicontatore () {
RIGA=$(tail -1 $RAWLIST)
contatore=$(echo $RIGA | cut -f1 -d" ")
echo $contatore
}

if [ ! -f $RAWLIST ]; then
   echo "0"> $RAWLIST 
fi
[ $# -eq 0 ] && { todolist; exit 1; }

echo "parametro 1=[$1]"
case "$1" in

	add) 	let contatore=$(leggicontatore)+1
		echo "$contatore $2 $3">>$RAWLIST
        ;;
	del)	sed -i "/^$2 /d" $RAWLIST
	;;
	*)	echo "comando non previsto, usage..."
	;;
esac

