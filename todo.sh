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

if [ ! -f $RAWLIST ]; then
   echo "0"> $RAWLIST 
fi
[ $# -eq 0 ] && { todolist; exit 1; }

#echo "parametro 1=[$1]"
case "$1" in

	add) 	let contatore=$(leggicontatore)+1
		echo "$contatore $2 $3">>$RAWLIST
		todolist
        ;;
	del)	#sed -i "/^$2 /d" $RAWLIST
		cancellariga $2
		todolist
	;;
	mod)	cancellariga $2
		echo "$2 $3 $4">>$RAWLIST
		sort $RAWLIST>tmp.tmp
		mv tmp.tmp $RAWLIST
		todolist
		;;
	list|l)	todolist
		;;
	h|help)	usage
	;;
	*)	echo "comando non previsto."
		usage
	;;
esac


