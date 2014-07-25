#!/bin/bash

CONFIGDIR="/etc/default"
CONFIGFILE="$CONFIGDIR/bootmail"

if test ! -w "/etc/init.d/" || test ! -w "$CONFIGDIR"; then
	echo "E: Unable to run script, are you root? (Try 'sudo $0')" >&2
	exit 3
fi

do_install(){
	install_bootmail
	if test -e "$CONFIGFILE"; then
		echo "-----"
		read -p "'$CONFIGFILE' file already exists. Overwrite? (y/N): " PROMPT
		case "$PROMPT" in
			[Yy]*) install_configfile;;
			*) echo "Skipping...";;
		esac
	fi
}

install_bootmail(){
	local FILE=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1)
	local DIR=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1)
	echo -n "Downloading the script..."
	wget -q --no-check-certificate "https://github.com/kdzlvaids/bootmail/archive/master.zip" -O "$FILE"
	if [ $? -gt 0 ]; then
		echo "FAILED"
		return 1
	else
		echo "OK"
	fi
	echo -n "Extracting the script..."
	unzip -q $FILE -d $DIR
	if [ $? -gt 0 ]; then
		echo "FAILED"
		return 1
	else
		echo "OK"
	fi
	chmod 755 $DIR/bootmail*/bin/bootmail
	mv -f $DIR/bootmail*/bin/bootmail /etc/init.d/
	update-rc.d bootmail defaults
	rm -r $DIR $FILE
	return
}

install_configfile(){
	rm "$CONFIGFILE"
	echo "-----"
	echo "You are about to be asked to enter information that will be used into your installation"
	echo "request."
	echo "What you are about to enter is writing the '/etc/default/bootmail'."
	echo "There are quite a few fields but you can leave some blank for some fields there will be"
	echo "a default value."
	echo "-----"
	
	read -p "Receive email address (eg, admin@example.com) [root]: " PROMPT1
	if [ ! -z"$PROMPT1" ]; then
		printf "MAILTO=\"$PROMPT1\"\n" >>"$CONFIGFILE"
	else
		printf "MAILTO=\"root\"\n" >>"$CONFIGFILE"
	fi
	
	read -p "Mail client (one of mail, mailx, mutt) [mailx]: " PROMPT2
	if [ "$PROMPT2" == "mutt" ] || [ "$PROMPT2" == "mailx" ] || [ "$PROMPT2" == "mail" ]; then
		printf "MAILCLIENT=\"$PROMPT2\"\n" >>"$CONFIGFILE"
	else
		printf "MAILCLIENT=\"mailx\"\n" >>"$CONFIGFILE"
	fi
	
	read -p "Log file location [/var/log]: " PROMPT3
	if [ ! -z "$PROMPT3" ]; then
		printf "LOGDIR=\"$PROMPT3\"\n" >>"$CONFIGFILE"
	else
		printf "LOGDIR=\"/var/log\"\n" >>"$CONFIGFILE"
	fi
	
	read -p "Log file name [bootmail.log]: " PROMPT3
	if [ ! -z "$PROMPT4" ]; then
		printf "LOGFILE=\"\$LOGDIR/$PROMPT4\"\n" >>"$CONFIGFILE"
	else
		printf "LOGFILE=\"\$LOGDIR/bootmail.log\"\n" >>"$CONFIGFILE"
	fi
	
	read -p "Do you want attach boot record into mail? (y/N): " PROMPT4
	case "$PROMPT4" in
		[Yy]*) install_bootlogd;;
	esac
	return
}

install_bootlogd(){
	echo "-----"
	apt-get install bootlogd
	echo "-----"
	if [ $? -eq 0 ]; then
		printf "\n BOOTLOGD_ENABLE=yes\n" >>/etc/default/bootlogd
		printf "ENABLE_BOOTLOG=\"yes\"\n" >>"$CONFIGFILE"
	else
		printf "E: $0: Install 'bootlogd' seems failed. Error code is: $?" >&2
	fi
	return
}

# WGET Progress Bar Filter By Dennis Williamson.
# http://stackoverflow.com/questions/4686464/howto-show-wget-progress-bar-only
progressfilt(){
    local flag=false c count cr=$'\r' nl=$'\n'
    while IFS='' read -d '' -rn 1 c
    do
        if $flag
        then
            printf '%c' "$c"
        else
            if [[ $c != $cr && $c != $nl ]]
            then
                count=0
            else
                ((count++))
                if ((count > 1))
                then
                    flag=true
                fi
            fi
        fi
    done
}

do_install

if [ $? -gt 0 ]; then
	echo "Some of the installation were unsuccessful."
	exit 1
else
	echo "Installation completed."
fi

exit
