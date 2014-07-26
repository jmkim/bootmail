#!/bin/bash
# bash is the best way to run this script.

CONFIGDIR="/etc/default"
CONFIGFILE="$CONFIGDIR/bootmail"

echo "bootmail AutoInstaller"
echo "-----"

# We needs superuser privilege.
if test ! -w "/etc/init.d/" || test ! -w "$CONFIGDIR"; then
	echo "E: Unable to run script, are you root? (Try 'sudo $0')" >&2
	exit 3
fi

do_install(){
	install_bootmail
	if [ $? -eq 0 ] && test -e "$CONFIGFILE"; then
		# Oops, this line will be run when $CONFIGFILE is already exists.
		echo "-----"
		read -p "'$CONFIGFILE' file already exists. Overwrite? (y/N): " PROMPT
		case "$PROMPT" in
			[Yy]*) install_configfile;;
			*) echo "Skipping...";;
		esac
	fi
	return
}

install_bootmail(){
	# shell/bash generate random alphanumeric string by earthgecko.
	# https://gist.github.com/earthgecko/3089509
	local FILE=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1)
	local DIR=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1)
	# Download bootmail master branch.
	echo -n "Downloading the script..."
	wget -q --no-check-certificate "https://github.com/kdzlvaids/bootmail/archive/master.zip" -O "$FILE"
	if [ $? -gt 0 ]; then
		echo "FAILED"
		return 1
	else
		echo "OK"
	fi
	# Extract downloaded file.
	echo -n "Extracting the script..."
	unzip -q $FILE -d $DIR
	if [ $? -gt 0 ]; then
		echo "FAILED"
		return 1
	else
		echo "OK"
	fi
	echo -n "Installing bootmail script..."
	# Make bootmail script executable.
	chmod 755 $DIR/bootmail*/bin/bootmail
	# Move to /etc/init.d/
	mv -f $DIR/bootmail*/bin/bootmail /etc/init.d/
	# Install bootmail script.
	# bootmail will 'start' at runlevel 2, and will 'stop' at runlevel 016.
	update-rc.d bootmail remove &>/dev/null
	ln -s /etc/init.d/bootmail /etc/rc2.d/S99bootmail
	ln -s /etc/init.d/bootmail /etc/rc0.d/K99bootmail
	ln -s /etc/init.d/bootmail /etc/rc1.d/K99bootmail
	ln -s /etc/init.d/bootmail /etc/rc6.d/K99bootmail
	if [ $? -gt 0 ]; then
		echo "FAILED"
		return 1
	else
		echo "OK"
	fi
	# Remove used files.
	rm -r $DIR $FILE
	return
}

install_configfile(){
	# OVERWRITE (with your agreements).
	rm "$CONFIGFILE"
	echo "-----"
	echo "You are about to be asked to enter information that will be used into your installation request. What you are about to enter is writing the '/etc/default/bootmail'. There are quite a few fields but you can leave some blank for some fields there will be a default value."
	echo "-----"
	
	# Set "TO:" Email address. Default value is: 'root'.
	read -p "Receive email address (eg, admin@example.com) [root]: " PROMPT1
	if [ ! -z"$PROMPT1" ]; then
		printf "MAILTO=\"$PROMPT1\"\n" >>"$CONFIGFILE"
	else
		printf "MAILTO=\"root\"\n" >>"$CONFIGFILE"
	fi
	
	# Set mail client. Default value is: 'mailx'.
	read -p "Mail client (one of mail, mailx, mutt) [mailx]: " PROMPT2
	if [ "$PROMPT2" == "mutt" ] || [ "$PROMPT2" == "mailx" ] || [ "$PROMPT2" == "mail" ]; then
		printf "MAILCLIENT=\"$PROMPT2\"\n" >>"$CONFIGFILE"
	else
		printf "MAILCLIENT=\"mailx\"\n" >>"$CONFIGFILE"
	fi
	
	# Set log directory. Default value is: '/var/log'.
	read -p "Log directory [/var/log]: " PROMPT3
	if [ ! -z "$PROMPT3" ]; then
		printf "LOGDIR=\"$PROMPT3\"\n" >>"$CONFIGFILE"
	else
		printf "LOGDIR=\"/var/log\"\n" >>"$CONFIGFILE"
	fi
	
	# Set log file name. Default value is: 'bootmail.log'.
	read -p "Log file name [bootmail.log]: " PROMPT3
	if [ ! -z "$PROMPT4" ]; then
		printf "LOGFILE=\"\$LOGDIR/$PROMPT4\"\n" >>"$CONFIGFILE"
	else
		printf "LOGFILE=\"\$LOGDIR/bootmail.log\"\n" >>"$CONFIGFILE"
	fi
	
	# Prompt to install 'bootlogd'.
	read -p "Do you want attach boot record into mail? (y/N): " PROMPT4
	case "$PROMPT4" in
		[Yy]*) install_bootlogd;;
	esac
	return
}

install_bootlogd(){
	# Install 'bootlogd' (for Debian GNU/Linux).
	echo "Installing bootlogd..."
	apt-get install bootlogd
	# Enable 'bootlogd'.
	if [ $? -eq 0 ]; then
		printf "\n BOOTLOGD_ENABLE=yes\n" >>/etc/default/bootlogd
		printf "ENABLE_BOOTLOG=\"yes\"\n" >>"$CONFIGFILE"
		echo "bootlogd was installed."
		echo "Try 'bootmail bootlogd' after next system boot."
	else
		echo "E: $0: Install 'bootlogd' seems failed. Error code is: $?" >&2
		return 1
	fi
	return
}

do_install

# Is there any error?
if [ $? -gt 0 ]; then
	# Oops, there are some errors.
	echo "-----"
	echo "Some of the installation were unsuccessful."
	exit 1
else
	# Nope!
	echo "-----"
	echo "Installation completed."
fi

exit
