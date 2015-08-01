```
bootmail: A Linux Bash script made for sending a mail about system boot.
```

## Table of contents

 - [Requirements](#requirements)
 - [Installation](#installation)
 - [Usage](#usage)
 - [License](#license)

## Requirements

 - [mailx](http://heirloom.sourceforge.net/) or [mutt](http://www.mutt.org/)
 - [bootlogd](https://wiki.debian.org/bootlogd) *(optional)*  - Record boot messages.
 - [SMTP Server](http://www.fclose.com/1411/sending-email-from-mailx-command-in-linux-using-gmails-smtp/#comment-487) *(optional)* - Required when you sending out from `localhost`

## Installation

#### Run [AutoInstaller](https://raw.githubusercontent.com/kdzlvaids/bootmail/master/install.sh)

```bash
wget https://raw.githubusercontent.com/kdzlvaids/bootmail/master/install.sh
chmod 755 install.sh
sudo ./install.sh
```

#### or more hard way

```bash
# Download script
git clone git@github.com:kdzlvaids/bootmail.git
# or
git clone https://github.com/kdzlvaids/bootmail.git

# Install script
chmod 755 bootmail/bin/bootmail
sudo cp bootmail/bin/bootmail /etc/init.d/
sudo update-rc.d bootmail start 99 2 . stop 99 0 1 6 .

# optional: Install mutt mail client
sudo apt-get install mutt

# optional: Install bootlogd (Debian boot logger)
sudo apt-get install bootlogd
sudo echo "BOOTLOGD_ENABLE=yes" >>/etc/default/bootlogd
sudo echo "ENABLE_BOOTLOG=yes" >>/etc/default/bootmail
```
```bash
# optional: Make /etc/default/bootmail
MAILTO="root"                         # "To:" mail address (Default is 'root' in your local machine)
MAILFROM="$(id -n -u)@$(hostname -f)" # "From:" mail address
MAILCLIENT="mailx"                    # Mail client: mutt/mail/mailx
LOGDIR="/var/log"                     # Log directory
LOGFILE="$LOGDIR/bootmail.log"        # Log file location
ENABLE_BOOTLOG="no"                   # Attach a boot record into the boot up mail
BOOTLOGFILE="/var/log/boot"           # Bootlog attachment location
```

## Usage

```bash
# Method 1: Run as InitScript
sudo service bootmail {start|stop}

# Method 2: Run manually
# bootmail will send an email automatically, so do not run manually.
/etc/init.d/bootmail [-h] {start|stop} [email address]

Arguments:
    start      system boot up alert.
    stop       system halt/reboot alert.
    bootlogd   print colorful boot record. *bootlogd required
Options:
-h, --help     print this help.
```


## License

```
    Copyright (C) 2015  Jongmin Kim / kdzlvaids@gmail.com

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.
```
