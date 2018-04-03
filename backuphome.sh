#!/usr/bin/zsh

if [ $# -ne 1 ]; then
	echo "The first argument must be the backup archive destination location"
	exit 1
fi


if [ ! -d "$1" ]; then
	echo "Folder doesn't exist: $1"
	exit 1
fi

perm=$(ls -ld /mnt/key/bkp | cut -d' ' -f1)

if [[ $perm =~ ^drw[.]{7} ]]; then
	echo "Can't write in the folder $1"
	exit 1
fi

echo -n Password: 
read -s password
echo

echo -n Check password: 
read -s password2
echo

if [ "$password" != "$password2" ]; then
	echo "Passwords don't match"
	exit 1
fi

archive="$1/$(date).7z"

7z a -mx0 -mhe=on -p"$password" "$archive" "$HOME"

7z t "$archive" * -p"$password" -r

sync

echo "Finished"
exit 0
