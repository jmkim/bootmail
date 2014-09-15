# bootmail

A Linux Bash script made for sending a mail about system boot.

## Table of contents

 - [Requirements](#requirements)
 - [Installation](#installation)
 - [Usage](#usage)
 - [Examples](#examples)
 - [License](#license)

## Requirements

*To send outside of localhost, mail server or SMTP account setup is needed. [Learn more.](https://www.debian.org/releases/stable/i386/ch08s05.html.en) [How to?](http://www.fclose.com/1411/sending-email-from-mailx-command-in-linux-using-gmails-smtp/#comment-487)*

 - [mailx](http://heirloom.sourceforge.net/) or [mutt](http://www.mutt.org/)
 - [bootlogd](https://wiki.debian.org/bootlogd) *(optional)*  - Record boot messages.

## Installation

Download and run [AutoInstaller](https://raw.githubusercontent.com/kdzlvaids/bootmail/master/install.sh) *(install.sh)*.

```bash
wget --no-check-certificate https://raw.githubusercontent.com/kdzlvaids/bootmail/master/install.sh
chmod 755 install.sh
sudo ./install.sh
```

### More hard way

1. Download the script.
Two download options are available:
 - Clone the repo: `git clone https://github.com/kdzlvaids/bootmail.git`.
 - [Download the script as zipped archive](https://github.com/kdzlvaids/bootmail/archive/master.zip).

2. Install the script.
 - `chmod 755 bin/bootmail`
 - `sudo mv bin/bootmail /etc/init.d/`
 - `sudo update-rc.d bootmail start 99 2 . stop 99 0 1 6 .`

3. *(Optional)* Make `/etc/default/bootmail`.
 - See *[Example: /etc/default/bootmail](#etcdefaultbootmail)*.
 - You can customize these defined values for yourself.

4. *(Optional)* Install [mutt](http://www.mutt.org/) and [bootlogd](https://wiki.debian.org/bootlogd).
 - `sudo apt-get install mutt`
 - `sudo apt-get install bootlogd`
 - `sudo echo "BOOTLOGD_ENABLE=yes" >>/etc/default/bootlogd`
 - `sudo echo "ENABLE_BOOTLOG=yes" >>/etc/default/bootmail`

## Usage

### Run as InitScript

```bash
service bootmail {start|stop}
```
### Run manually

*bootmail will send an email automatically, so do not run manually.*
```bash
bootmail [-h] {start|stop} [email address]

Arguments:
    start      system boot up alert.
    stop       system halt/reboot alert.
    bootlogd   print colorful boot record. *bootlogd required
Options:
-h, --help     print this help.
```

## Examples

### /etc/default/bootmail

```bash
MAILTO="root"                         # "To:" mail address (Default is 'root' in your local machine)
MAILFROM="$(id -n -u)@$(hostname -f)" # "From:" mail address
MAILCLIENT="mailx"                    # Mail client: mutt/mail/mailx
LOGDIR="/var/log"                     # Log directory
LOGFILE="$LOGDIR/bootmail.log"        # Log file location
ENABLE_BOOTLOG="no"                   # Attach a boot record into the boot up mail
BOOTLOGFILE="/var/log/boot"           # Bootlog attachment location
```

## License

```
    Copyright (C) 2014  Jongmin Kim / kdzlvaids@gmail.com

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
