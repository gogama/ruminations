# Lineage on cedric
**Date**: 2021-09-22
**Topic**: Installing Lineage 18.1 on Motorola Moto G G5 "cedric"

## Versions that worked

| Item | Version | File | sha256 |
|-|-|-|-|
| **Hardware** | cedric XT1671 32GB P5 | - | - |
| **Firmware** | OPP28.85-19-4-2 | `CEDRIC_RETAIL_8.1.0_OPP28.85-19-4-2_cid50_subsidy-DEFAULT_regulatory-DEFAULT_CFC.xml.zip` | `ff11d01ede235bd49281bddd64a6032732691fa496000ae80d3fdcc86d53cac9` |
| **Recovery** | LineageOS recovery nightly build 202010909 | `lineage-18.1-20210909-recovery-cedric.img` | `f3d27a7158e5bb763ac4a8bdd3d9d724eecf58fbf9bc0d5040c739df995fbff9` |
| **OS** | Lineage OS 18.1 nightly build 20210909 | `lineage-18.1-20210909-nightly-cedric-signed.zip` | `b092cc1594f4cffbcdb930b3fdd3debfbf933b95193399de2fb90314e8cf6bb7` |

## tl;dr

1. Mise en place.
2. Unlock the bootloader.
3. Ensure you have the latest retail firmware.
4. Boot into the recovery.
5. Factory reset the device. (Wipe appropriate things.)
6. Install the OS.

## Blow-by-blow

### 1. Mise en place

- In Android settings:
    - Enable **Developer mode**. This is typically done by going in to the "About phone" part of the settings and tapping the **Build number** a whole bunch of times.
   - Enable USB debugging.
- On laptop:
   - Install adb/fastboot.
   - Install Motorola adb/fastboot drivers. I wasn't able to get things to work with various "Universal" fastboot drivers. The Motorola ones worked for me.

### 2. Unlock the bootloader

Reboot the phone into the bootloader. This can be done either by pressing and holding volume DOWN and POWER or by running `adb reboot bootloader`.

Now Motorola has a bit of a quirky bootloader unlock process... First you need to get some data out of the phone which you can parley into an unlock key.

```
$ fastboot oem get_unlock_data
...
(bootloader) Unlock data:
(bootloader) F3E5FB63B8A6C194#
(bootloader) 954182D503453E8BAE5A963D586808B131700000#
(bootloader) C65E97A237C134834247256ADEE475F6819F00C8#
(bootloader) 4247256A000000000000000000000000
OKAY [  0.109s]
finished. total time: 0.109s
```
Now it starts to get a bit weirder. You need to combine those four lines of hex numbers into one long device ID string like so:

```
F3E5FB63B8A6C194#954182D503453E8BAE5A963D586808B131700000#C65E97A237C134834247256ADEE475F6819F00C8#4247256A000000000000000000000000
```

Now it gets even funnier. You are need to go to the Motorola device unlock portal, which last time I looked was here:

https://motorola-global-en-uk.custhelp.com/app/standalone/bootloader/unlock-your-device-a

Sign up or sign in, and once you're in the unlock portal, proceed past the warnings to the page where there's a box labeled **MAKE SURE YOUR DEVICE IS UNLOCKABLE**. Enter the concatenated device ID string you combined out of the unlock data and click the *Can my device be unlocked?* button.

If the device can be unlocked this will make a *Request device unlock key* button magically appear at the bottom of the page. Accept the warnings about voiding your warranty and it will give you the key.

Now you can unlock the device, as long as you're willing to run the same command a few different times.

```
$ fastboot oem unlock DKZA99UHB51MRZNOEXT1
...
(bootloader) WARNING: This command erases all user data.
(bootloader) Please re-run this command to continue.
OKAY [  0.016s]
finished. total time: 0.016s

$ fastboot oem unlock DKZA99UHB51MRZNOEXT1
...
(bootloader) Check 'Allow OEM Unlock' in Android Settings > Developer
(bootloader) Options
OKAY [  0.016s]
finished. total time: 0.016s
```

Now reboot into Android, click enable **Allow OEM Unlock** in the Android developer settings, reboot back into the bootloader (`$ adb reboot bootloader`) and a couple more `fastboot oem unlock ...` commands will finally get you there!

### 3. Ensure you have the latest retail firmware.

### 4. Boot into the recovery.

### 5. Factory reset the device. (Wipe appropriate things.)

### 6. Install the OS.