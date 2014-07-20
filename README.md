# [bootmail](https://github.com/kdzlvaids/bootmail)

## Table of contents

 - [Requirements](#requirements)
 - [Installation](#installation)
 - [Usage](#usage)
 - [Examples](#examples)
 - [License](#license)

## Requirements

 - **mailx**
 - **mutt** *(optional)*  - Nice text-based email client. [Learn more](https://wiki.debian.org/Mutt)
 - **bootlogd** *(optional)*  - Record boot messages. [Learn more](https://wiki.debian.org/bootlogd)

## Installation
1. Download the script.
Two download options are available:
 - [Download the script as zipped archive](https://github.com/kdzlvaids/bootmail/archive/master.zip).
 - Clone the repo: `git clone https://github.com/kdzlvaids/bootmail.git`.

2. Install the script.
 - `chmod 755 bin/bootmail` - *Script as executable.*
 - `sudo mv bin/bootmail /etc/init.d/`
 - `sudo update-rc.d bootmail defaults` - *Install script to InitScript daemon.*

3. *(Optional)* Make `/etc/default/bootmail`.
 - See **[Example: /etc/default/bootmail](#/etc/default/bootmail)**.
 - You can customize these defined values for yourself.

4. *(Optional)* Install `bootlogd` and `mutt`.
 - `sudo apt-get install bootlogd mutt`
 - `sudo echo "BOOTLOGD_ENABLE=yes" >>/etc/default/bootlogd`
 - `sudo echo "USEBOOTLOGD=yes" >>/etc/default/bootmail`

## Usage

### Run as InitScript

*Do not run manually. bootmail will send an email automatically when Debian boot up, halt, and reboot.*
```bash
service bootmail {start|stop}
```
### Execute directly

*Do not run manually. bootmail will send an email automatically when Debian boot up, halt, and reboot.*
```bash
bootmail {start|stop} [email address]

Arguments:
    start      system boot up alert.
    stop       system halt/reboot alert.

Options:
-h, --help     print this help.
-n, --dry-run  perform a trial run with no changes made.
```

## Examples

### /etc/default/bootmail

```bash
MAILTO="root"                       # Receive mail address. Default is: 'root' in your local machine.
SENDER="$(id -n -u)@$(hostname -f)" # Sender mail address.
LOGDIR="/var/log"                   # Log directory.
LOGFILE="$LOGDIR/bootmail.log"      # Log file location.
USEBOOTLOG="no"                     # Bootlogd attachment in Bootup mail. You must install bootlogd using 'apt-get install bootlogd'.
BOOTLOGFILE="/var/log/boot"         # Bootlog attachment location.
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
