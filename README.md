bootmail
========
NOT WORKS YET.

How to enable bootmail on system boot, halt, and reboot?

```bash
mv bootmail /etc/init.d/
update-rc.d bootmail defaults
```

### Usage
In recommended way:
```bash
service bootmail {start|stop}
```
And you can run it directly:
```bash
bootmail {start|stop} [email address]

Arguments:
    start      system boot up alert.
    stop       system halt/reboot alert.

Options:
-h, --help     print this help.
-n, --dry-run  perform a trial run with no changes made.
```

