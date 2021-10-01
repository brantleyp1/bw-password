#! /bin/bash

## the folder name to search for, change as needed
search=change

## leave this variable
test=FALSE

## set password complexity here, currently set at minimum of 8 characters, 1 upper, 1 lower, and 1 special character. 
minlength=8
minupper=1
minlower=1
minspecial=1
minnumber=1
passcomplexity () {
	LEN=${#newpass}

	## only checks for 8 characters, that's up to you
	if [[ "$LEN" -lt "$minlength" ]]; then
		echo "Password is smaller than $minlength characters"
		echo "Requirements are $minlength characters, $minupper Upper, $minlower Lower, $minspecial Special and $minnumber Numbers"
		exit 4
	fi
	if [[ "$(printf %s "$newpass" | tr -d "[:digit:]" | tr -d "[:punct:]" | tr -d "[:lower:]" | wc -c)" -lt "$minupper" ]]; then
		echo "Password doesn't contain enough uppercase letters"
		echo "Requirements are $minlength characters, $minupper Upper, $minlower Lower, $minspecial Special and $minnumber Numbers"
		exit 4
	fi
	if [[ "$(printf %s "$newpass" | tr -d "[:digit:]" | tr -d "[:punct:]" | tr -d "[:upper:]" | wc -c)" -lt "$minlower" ]]; then
		echo "Password doesn't contain enough lowercase letters"
		echo "Requirements are $minlength characters, $minupper Upper, $minlower Lower, $minspecial Special and $minnumber Numbers"
		exit 4
	fi
	if [[ "$(printf %s "$newpass" | tr -d "[:alnum:]" | wc -c)" -lt "$minspecial" ]]; then
		echo "Password doesn't contain enough special characters"
		echo "Requirements are $minlength characters, $minupper Upper, $minlower Lower, $minspecial Special and $minnumber Numbers"
		exit 4
	fi
	if [[ "$(printf %s "$newpass" | tr -d "[:alpha:]" | tr -d "[:punct:]" | wc -c)" -lt "$minnumber" ]]; then
		echo "Password doesn't contain enough numbers"
		echo "Requirements are $minlength characters, $minupper Upper, $minlower Lower, $minspecial Special and $minnumber Numbers"
		exit 4
	fi
}

setnewpass () {
	echo -e "\nLet's set a new password now...\n\nPassword:"
	read -rs newpass1
	echo -e "\nConfirm Password:"
	read -rs newpass2
	if [[ "${newpass1}" == "${newpass2}" ]]; then
		newpass="${newpass2}"
	else
		echo "Passwords do not match, please try again"
		exit 1
	fi
}

if [[ "$1" == "-t" ]]; then
	test=TRUE
	if [ -z "$2" ]; then
		setnewpass
	else
		newpass="${2}"
	fi
elif [[ "$1" =~ ^-+[a-z] ]]; then
	echo -e "Usage:
  $0
    -h			Show this help screen.
    -t			Test a password before setting.
    'someH@RDpassword'	Enter a password on the command line (insecure)
    [Enter]		Enter to be prompted for a password."
	exit 3
elif [ -n "$1" ]; then
	test=FALSE
	newpass="${1}"
else
	[ -z "$1" ] && setnewpass
fi
passcomplexity
folderid=$(bw list folders --search "$search" | jq '.[].id' | tr -d '"')
listofitems=$(bw list items --folderid "$folderid" | jq '.[].id' | tr -d '"')
if [[ "$test" == "TRUE" ]]; then
	for i in ${listofitems};
		do bw get item $i | jq '.login.password="'"$newpass"'"' | jq '. | {Item: .id, "Password Would Be": .login.password}' | sed 's/[]{},"[]//g';
	done
else
	for i in ${listofitems};
		do bw get item $i | jq '.login.password="'"$newpass"'"' | bw encode | bw edit item $i | jq '. | {"Item Updated": .id}' | sed 's/[]{},"[]//g';
	done
fi
exit
