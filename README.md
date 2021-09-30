# bw-password
update a group of passwords in bitwarden 

## Synopsis

I have a self-hosted BitWarden instance, but I don't save any of my work-related passwords using LDAP credentials so that I don't have to remember to change all howevermany every time I have to set a new password.

With this I can set all the passwords at once and keep them in bitwarden and out of my poor mind.

## Usage

`./bwpass.sh` - will prompt you for a password. Note, there's no minimum password requirements, so just be honest with yourself.

`./bwpass.sh 'someTH!ngH@rd'` - set a password to someTH!ngH@rd, just know that it's in your shell history if you're on a shared system.

## Requirements

bitwarden-cli - required

bitwarden account - this doesn't have to be self-hosted, though personally I think that's the best option ;-)

## Notes

There's a "test" function of sorts. Uncomment the first line in the for loop which will show you in a pretty output your new password.
