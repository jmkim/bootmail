bootmail
========
### Requirements
* **mailx**
* **mutt** *(optional)*  - Nice text-based email client. [Learn more](en.wikipedia.org/wiki/Mutt_(email_client))
* **bootlogd** *(optional)*

### Usage
**Recommended way:**
```bash
service bootmail {start|stop}
```
Or you can execute directly:
```bash
bootmail {start|stop} [email address]

Arguments:
    start      system boot up alert.
    stop       system halt/reboot alert.

Options:
-h, --help     print this help.
-n, --dry-run  perform a trial run with no changes made.
```

### Installation
1. [Download](https://github.com/kdzlvaids/bootmail/archive/master.zip).
    ```
    wget --no-check-certificate https://github.com/kdzlvaids/bootmail/archive/master.zip
    ```
2. Unzip
`unzip master.zip`
3. Move to `/etc/init.d/`
4. `update-rc.d bootmail defaults`

```bash

mv bootmail /etc/init.d/
update-rc.d bootmail defaults
```
