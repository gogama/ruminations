
# Lineage on cedric

- **Date**: 2021-09-22
- **Topic**: Installing LineageOS 18.1 on Motorola Moto G G5 "cedric"

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
7. Install F-Droid and Aurora store. (Optional.)

## Blow-by-blow

### 1. Mise en place

- In Android settings:
    - Enable **Developer mode**. This is typically done by going in to the "About phone" part of the settings and tapping the **Build number** a whole bunch of times.
   - Enable USB debugging.
- On laptop:
   - Install `adb`/`fastboot`. They are often available as a package deal.
   - Install Motorola `adb`/`fastboot` drivers. While ADB drivers are pretty generic I wasn't able to get Fastboot to work with various "Universal" Fastboot drivers. The Motorola ones worked for me.
- Back on Android device:
   - Plug it in to USB.
   - Grant the laptop permission to USB debug the device.
- Back on  laptop:
   - Verify that ADB recognizes the device: `$ adb devices`.
   - (You'll need to wait until you're in the bootloader to validate that Fastboot is working.)
- Finally with the device:
   - Ensure the device battery is charged above **60%**, just in case. (While this shouldn't matter, if things go sideways you will may it because in some modes the device apparently can't charge its battery even when plugged in to power.)
   - Back up any data you aren't willing to see destroyed.   

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
Now it starts to get a bit weirder. You need to combine those four lines of hex numbers into one long device ID string, by merging the lines, retaining the pound signs, like so:

```
F3E5FB63B8A6C194#954182D503453E8BAE5A963D586808B131700000#C65E97A237C134834247256ADEE475F6819F00C8#4247256A000000000000000000000000
```

Now it gets even funnier. You need to go to the Motorola device unlock portal website, which last time I looked was here:

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

The firmware update step is technically optional, and you won't see it listed on most typical Lineage or custom ROM install guides, but since in my case *not* doing it led to some painful hours waiting, wondering, and searching the internet in vain, be aware that you may need to do it so the actual OS install step can succeed.

#### Indications that you may need a firmware update

Looking a head to step 6 (**Install the OS**), the first time boot into Lineage takes a bit longer than subsequent boots. On my cedric which is the subject of this document, this initial boot time was 5–6 minutes for my successful install.

However, *before* I updated my firmware, the initial boot was taking 45–46 minutes and then failing. The symptoms of the failure were that the device would present an error message along these lines:

```
Can't load Android system. Your data may be corrupt.
```

Although it would present the option to reboot and try again, subsequent tries also failed.

#### How to list your firmware version

In Fastboot mode:

```
$ fastboot getvar all
... <snip to version numbers> ...
(bootloader) ro.build.fingerprint[0]: motorola/cedric/cedric:7.0/NPP25.1
(bootloader) ro.build.fingerprint[1]: 37-15/13:user/release-keys
(bootloader) poweroffalarm: 1
(bootloader) ro.build.version.full[0]: Blur_Version.25.11.13.cedric.reta
(bootloader) ro.build.version.full[1]: il.en.US
(bootloader) ro.build.version.qcom: LA.UM.5.6.r1-01900-89xx.0
(bootloader) version-baseband[0]: M8937_8000.122.02.40R CEDRIC_LATAMDSDS
(bootloader) version-baseband[1]: _CUST
(bootloader) kernel.version[0]: Linux version 3.18.31-perf-g708ac5e (hud
(bootloader) kernel.version[1]: soncm@ilclbld35) (gcc version 4.8 (GCC)
(bootloader) kernel.version[2]: ) #1 SMP PREEMPT Fri Jan 13 08:46:35 CST
(bootloader) kernel.version[3]:  2017
...
(bootloader) ro.carrier: retla
```

In the outputs above I have elided most of the fields returned, including some that probably had useful versioning information, but the above output is just to give you the idea. You'll have to look at the output in comparison to what other firmware versions seem to be available online to decide whether your firmware is out-of-date.

#### Update steps

Salvation from my firmware-induced imbroglio [was brought by TheFixItMan](https://forum.xda-developers.com/t/solved-lineageos-stuck-at-first-boot-moto-g5-xt1676.4284709/), a user on the XDA developer forums specifically for the cedric device. Responding to a user having the same problem as me, he said:

> Looks like you are trying to flash the rom on an old stock firmware image  
>
> Make sure you are on the latest retail firmware version  
>  
> [lolinet mirrors - firmware, software, iso etc.](https://mirrors.lolinet.com/firmware/moto/cedric/official/)
> lolinet mirrors - powered by h5ai
> `mirrors.lolinet.com`

As is typical of XDA experts this user had a fairly terse writing style that assumes knowledge, without providing it, of some critical details, so let me summarize the steps that worked for me with a bit more detail:

1. Follow the lolinet link.
2. Use some judgment on the correct object to download.
	- I looked at the timestamps on the directories and took one of the more recent ones.
	- This happened to coincide with the directory `RETAIL/`, which in this case contained the ZIP archive which worked for me.
	- Don't worry about the ZIP archive file size being enormous (1.5 GB). This is expected.
3. Unzip the archive install it on the phone from Fastboot mode using the commands below, which are exactly the ones listed by my savior on the XDA developer forums.

```
fastboot oem fb_mode_set
fastboot flash partition gpt.bin
fastboot flash bootloader bootloader.img
fastboot flash logo logo.bin
fastboot flash boot boot.img
fastboot flash recovery recovery.img
fastboot flash dsp adspso.bin
fastboot flash oem oem.img
fastboot flash system system.img_sparsechunk.0
fastboot flash system system.img_sparsechunk.1
fastboot flash system system.img_sparsechunk.2
fastboot flash system system.img_sparsechunk.3
fastboot flash system system.img_sparsechunk.4
fastboot flash system system.img_sparsechunk.5
fastboot flash system system.img_sparsechunk.6
fastboot flash system system.img_sparsechunk.7
fastboot flash system system.img_sparsechunk.8
fastboot flash modem NON-HLOS.bin
fastboot erase modemst1
fastboot erase modemst2
fastboot flash fsg fsg.mbn
fastboot erase cache
fastboot erase userdata
fastboot oem fb_mode_clear
fastboot reboot
```

Note that after rebooting my device back into the bootloader, I saw no obvious change in the output from `fastboot getvar all`. Version numbers that I thought should have changed had not changed. But it worked anyway.

### 4. Boot into the recovery.

After unlocking the bootloader and completing the maybe-optional firmware update, it's time to boot into the recovery. 

The [official Lineage install instructions for cedric](https://wiki.lineageos.org/devices/cedric/install) recommend using the Lineage recovery. I successfully put various versions of TWRP recovery cedric build on the phone at various times (3.4.0, 3.5.2), before I fixed my firmware issue; the TWRP recovery seemed to work fine for me and I'm sure it would have led to success as well. On my successful installation, however, I used the Lineage recovery instead of TWRP, and I see no reason not to.

Starting from Fastboot mode, boot the device into a "temporary" version of the recovery image:

```
$ fastboot boot lineage-18.1-20210909-recovery-cedric.img
```

This will reboot the phone into the recovery without writing the recovery image into the recovery partition. (This means it is only good for one boot and after any reboot you'll need `$ fastboot boot` to get back in, unless you use the recovery to flash the image onto your recovery partition. TWRP can do this, but I'm not sure if the Lineage recovery can.)

### 5. Factory reset the device. (Wipe appropriate things.)

From the recovery app, factory reset the device. With the Lineage recovery, this was pretty straightforward:

1. Tap **Factory reset**.
2. Tap **Format data/factory reset** and respond affirmatively to any cautions about how your data will be slaughtered. They will be.

It will quickly do its thing. Afterward there is no need to reboot the device; but if you do decide to reboot and haven't permanently flashed the recovery onto your recovery partition you'll need to `$ fastboot boot` back to the recovery image.)

### 6. Install the OS.

With the device booted into the recovery, you have two options.

1. **From device**. (This is the option I used on my successful run after the firmware update.)
	- Copy the OS image, which is a ZIP archive, onto the phone using your laptop's file manager or `adb`.
	- From the recovery, install the ZIP. In Lineage recovery this is done using **Apply Update** and tapping the ZIP archive.
2. **From the laptop**. You can one-shot via ADB using `$ adb sideload lineage-18.1-20210909-nightly-cedric-signed.zip`.

The installation process takes about 5 minutes or less. The [Lineage guide for cedric](https://wiki.lineageos.org/devices/cedric/install) suggested that it would "succeed" by presenting some designated error messages, but in my case it succeeded with obvious success messages. At this point the OS is installed but you are still in recovery mode.

Take a deep breath and reboot the device.

Nearly all online resources state that the first boot into LineageOS takes 5–10 minutes. On my cedric it was between 5 and 6 minutes. If it goes longer than 10, your are likely hooped and I would suggest a hard cut-off at 15, at least on a cedric. If it goes longer than that, it is spinning without progressing.

While booting LineageOS, the device screen will show the LineageOS boot animation, which is basically a pretty "spinner" type animation intended to reassure you that things are happening, but without giving any information about what is being done or how much progress in fact been made. Because I had some failed boots before I realized I needed to update the device firmware, I can say anecdotally that during a successful boot on a cedric, the animation should occasionally slow down and render choppily as the phone processor grinds away on other useful things. When it wasn't working and was just spinning it seemed to animate smoothly pretty much the whole time.

About 5, and no more than 10, minutes after you reboot, you should be in Lineage!

### 7. Install F-Droid and Aurora Store. (Optional.)

Because I am weak, I want the convenience of the Google Play store for app installation without having to use Google. There are two steps to getting this going.

1. **Install F-Droid**. [F-Droid](https://f-droid.org/) is a free and open source Android app repository.
    - It doesn't list any apps from the Google Play store.
    - It can install the apps it does have on your phone fairly seamlessly, just like the Play store.
    - It has the ability to auto-update the apps it does have.
    - One app that it has is Aurora Store, which is a Play Store client.
    - Download the APK and install F-Droid.
2. **Install Aurora Store**. [Aurora Store](https://f-droid.org/en/packages/com.aurora.store/) is a free and open source alternative to the Google Play store application.
    - It has an anonymous mode so you can install apps without signing in to Google.
    - Many Play apps allegedly require GSF (Google Services Framework) to operate but I was able to install the ones I need without needing GSF: Brave, Opera, DuckDuckGo privacy browser, Signal, *etc.* They all seem to work.
    - Install Aurora Store via F-Droid.

At this point, everything seems to be working beautifully for me and note that I never installed GApps, GSF, etc. As far as I know my cedric is de-Googled and in perfect working order.

## Lessons Learned

1. You do not need to root your phone for any of this. Rooting is a red herring. What you need is to unlock the bootloader.
2. Main Android system is provided by the system and vendor partitions. Lineage or any custom ROM overwrites both partitions. A recovery can optionally be flashed onto the recovery partition, but you don't need to flash the recovery image if you only want to boot into it on a one-time basis.
3. Most custom ROM installation guides on the internet are hot garbage.
    - They are basically clickbait-style articles in which most of the content is long-winded and repetitive in order to insert as many advertisements into the page as possible.
    - Most appear to be auto-generated from a manifest of known devices, in order to have as many pages crawled by search engines as possible. They have little if any valid device-specific information.
    - Most will suggest sub-optimal, redundant, or unnecessary steps.
    - None will explain what anything means or why you would take any particular action.
4. Fastboot mode is a synonym for "the phone's regular bootloader mode".
    - When your phone is in Fastboot mode and tethered to a laptop with working Fastboot drivers, you can interact with the bootloader systems from the laptop using the `fastboot` command line tool.
    - Fastboot mode is distinct from recovery mode.
6. A recovery is an operating system which is more functional than the bootloader but less functional than the Android OS, and which has the ability to "flash" software onto the various partitions of the phone and potentially do other things. A recovery is also capable of limited USB debugging and in particular can execute the `$ adb sideload` command, which is a way of flashing software onto device partitions without using the recovery UI.
7. The XDA developer forums are gold mines but it can be hard to find the information you need via search engine. I recommend finding the forum topic or thread for your specific device and browsing from there.
8. On the lolinet mirrors the short-forms like RETCA, RETLA, *etc.* seem to be "retail Canada", "retail Latvia", etc.
