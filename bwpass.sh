#! /bin/bash
##find a folder named change, find all the items in the folder, and set login.password="newpass" for each item:

setnewpass () {
	echo "You didn't supply a new password, for shame..."
	echo -e "\nLet's set one now...\n\nPassword:"
	read -s newpass1
	echo -e "\nConfirm Password:"
	read -s newpass2
	if [[ "${newpass1}" == "${newpass2}" ]]; then
		newpass="${newpass2}"
	else
		echo "Passwords do not match, please try again"
		exit 1
	fi
}

newpass="$1"
[ -z "$1" ] && setnewpass
#newpass='yourNewP@ss'
search=change
folderid=$(bw list folders --search "$search" | jq '.[].id' | tr -d '"')
listofitems=$(bw list items --folderid "$folderid" | jq '.[].id' | tr -d '"')
for i in ${listofitems};
	#do bw get item $i --pretty | jq '.login.password="'"$newpass"'"'; ### comment this out and uncomment the line below to actually change passwords
	do bw get item $i --pretty | jq '.login.password="'"$newpass"'"' | bw encode | bw edit item $i; ### comment this out and uncomment the line above to test everything
done
exit
