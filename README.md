# OpenWrt Deep Night Sleep

## Introduction

* Routers are always left useless at deep night. Both The power they waste and the power they radiate to us may be harmful to us or even the world. So why don't we save power beginning from a small router?

## What does it do?

* Shut down all interfaces including wifi found on the router

* Remove many modules found in /lib/modules

* Stop all services except cron found in /etc/init.d

* Turn off all LED without the one used to blink which is defined at the start of the script

* Shut down USB power by using gpio defined at the top of the script

## How to use

* Download ZIP, extract sleep.sh in it.

* Edit sleep.sh, change `LED`, `USB1_POWER`, `USB2_POWER` to values actually correct on your device

(Don't leave it blank if the item is non-exist, just fill it with some nonsense words)

* SCP or SFTP to the router

* chmod 755 on the router

* Edit crontab (also known as `Scheduled Tasks` in LuCI), add something like this:

```

30 00 * * 1-5 /path/to/sleep.sh # Sleep at 00:30 AM on Monday to Friday

15 01 * * 0,6 /path/to/sleep.sh # Sleep at 01:15 PM on weekends

30 07 * * 1-5 reboot # Reinitialize router at 07:30 AM on Monday to Friday

00 09 * * 0,6 reboot # Reinitialize router at 07:30 AM on weekends

```

## Be careful

* Don't use extroot

* Be sure about your USB power gpio is whether `active_high` or `active_low`

* If some modules are really related to CPU, or some services are required not to stop, use grep -v to filter them out

## Test

* Tested on WDR7500. Functions work fine.

## License

* This repository is under MIT License. View `LICENSE` file for details.
