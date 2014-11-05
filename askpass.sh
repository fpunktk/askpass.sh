#!/bin/bash

# askpass.sh by Felix Kästner, GPL3


# in $* there could be the prompt-message (from an invoking program like sudo)
# delete any trailing space or colon and write it to stderr
promptmsg="enter password:"
[ "$*" != "" ] && promptmsg="${*% }"
echo -en "$0: ${promptmsg%:}: " >&2

pw=""
stars=0
cx='abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789' # chars that can be echoed as feedback for a keypress, there have been problems when using special chars

while :
do
    # set IFS to newline and read a character
    # -s silent, -r \ is taken literal, not as escape character, -n 1 only one char is read
    IFS=$'\n' read -s -r -n 1 char
    case "$char" in
        "")
            # backspace was pressed
            # deletes the last character from $pw and moves the cursor one char back, deleting this char, but don't delete more chars than available
            pw="${pw%?}"
            [ $stars -gt 0 ] && { ((stars--)); echo -en "\b \b" >&2; }
        ;;
        "")
            # ctrl + d was pressed, this means abort/cancel
            # delete all echoed characters, unset variables and exit
            while [ $((stars--)) -gt 0 ]
            do
                echo -en "\b \b" >&2
            done
            
            unset pw char stars rnd cx
            echo "cancelled " >&2
            exit 1
        ;;
        ?)
            # add the char to pw and echo some chars as visual feedback
            pw="$pw$char"
            ((rnd = RANDOM % 3 + 1)) # bash specific
            ((stars += rnd))
            # echos $rnd much of the characters from $cx
            while [ $((rnd--)) -gt 0 ]
            do
                echo -n "${cx:$(($RANDOM % ${#cx})):1}" >&2
            done
        ;;
        "")
            # no new character, so pw is completed
            # delete the echoed characters
            remain=$(($RANDOM % 4 + 6))
            while [ $((stars--)) -gt $remain ]
            do
                echo -en "\b \b" >&2
            done
            break
        ;;
    esac
done

# write a newline to stderr and the password to stdout
echo "" >&2
echo "$pw"
unset pw char stars rnd cx remain

