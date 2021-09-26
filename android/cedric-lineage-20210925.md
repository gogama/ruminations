
# Lineage on cedric, part 2 (fixing IMEI 0/0)

- **Date**: 2021-09-25
- **Topic**: Fixing IMEI 0/0 broken radio issue on Motorola Moto G G5 "cedric" with LineageOS 18.1
- **Outcome**: Success

## Versions that *really* worked

| Item | Version | File | sha256 |
|-|-|-|-|
| **Hardware** | cedric XT1671 32GB P5 | - | - |
| **Firmware** | OPP28.85-19-4-2 | `CEDRIC_RETAIL_8.1.0_OPP28.85-19-4-2_cid50_subsidy-DEFAULT_regulatory-DEFAULT_CFC.xml.zip` | `ff11d01ede235bd49281bddd64a6032732691fa496000ae80d3fdcc86d53cac9` |
| **Recovery** | TWRP Recovery 3.5.2 for cedric† | `twrp-3.5.2_9-0-cedric.img` | `a47fb6578f68e20de287db28edb676c98e00b6121b1b492101ca2518f7323300` |
| **OS** | Lineage OS 18.1 nightly build 20210923† | `lineage-18.1-20210923-nightly-cedric-signed.zip` | `c47fac901f7cf930e134ed3a19a1e4e4c64c33d9991396f14074b1c0c038b83a` |

†: *This is different from the earlier install in [cedric-lineage-20210923.md](cedric-lineage-20210923.md) where I caused the IMEI 0/0 problem. I don't know if it made a difference.*

## Background

After finishing the steps in [cedric-lineage-20210923.md](cedric-lineage-20210923.md), I had a working LineageOS install on my cedric and I was pretty stoked, given how tiring the process had been. WiFi was working, apps were working, it was great.

But...

When I finally got around to putting in my wireless carrier's SIM card, I didn't have a wireless signal!

On investigating, I found that if I dialed the magic sequence `*#*#4636#*#*` into the phone's dialer, I could get to a detailed page about wireless setup, and it showed that both radio 0 (first SIM slot) and radio 1 (second SIM slot) were disabled. Flipping the toggle to turn the radio on made no difference.

With more investigation, I found another magic sequence to dial, `*#06#`, which tells you what the phone thinks the IMEI is for each SIM slot. It was zero in both cases. But in Fastboot mode, `$ fastboot getvar imei` continued to report the correct IMEI number for the phone.

Investigating was a real stumper. Two quick steps that allegedly work for many people (`$ fastboot erase modemst1` and same for `modemst2`) did nothing. Other than that solution, everyone was talking about messing around with the `persist` partition, rooting the phone, backing up something called EFS. It was a nightmare.

Eventually I found [this random YouTube video this guy](https://www.youtube.com/watch?v=7friDoYXsuM). (Sorry for linking a Google product!) The guy was so confident he could fix IMEI 0/0 without doing all the steps everyone else did that I decided to give it a try, except I decided to sub in the custom ROM I want (Lineage) for the one in the video. This worked, and I was able get the radio back working following the steps below.

Ultimately I have no idea what step fixed the problem, or why it fixed it. But given that this produced a working LineageOS with a working radio on my cedric, I recommend modding the steps from [cedric-lineage-20210923.md](cedric-lineage-20210923.md) and subbing in these ones where appropriate.

## One detail

This time I was pretty careful to unplug the USB cable during phone reboots and when I didn't need it. I have no clue whether this makes a difference, but it is a little detail that is associated with successfully getting the radio back to working.

## tl;dr

With my phone in the working-but-with-IMEI-0/0 state that I got it into at the end of [cedric-lineage-20210923.md](cedric-lineage-20210923.md), I took the following steps.

1. Re-install most recent firmware.
2. Install freshest TWRP recovery (3.5.2).
3. Wipe data using TWRP.
4. Install freshest LineageOS nightly build (2021-01-23).
5. Profit.

## Blow-by-blow

### 1. Re-install most recent firmware.

I re-flashed the firmware exactly as stipulated in [cedric-lineage-20210923.md](cedric-lineage-20210923.md).

### 2. Install freshest TWRP recovery (3.5.2).

I installed the cedric version of TWRP recover 3.5.2, by flashing to the recovery partition and rebooting into it.

*i.e.:*

```
$ fastboot flash recovery twrp-3.5.2_9-0-cedric.img
$ fastboot reboot recovery
```

**Differences from [cedric-lineage-20210923.md](cedric-lineage-20210923.md)**: I didn't use the Lineage recovery; I flashed the recovery partition and booted into it; and I unplugged the USB cable after flashing the recovery partition and before booting into it. 

### 3. Wipe data using TWRP.

Two distinct wipe steps:

1. Wipe &rarr; Format Data &rarr; yes
2. Wipe &rarr; Advanced Wipe &rarr; *Select all of the below*:
   - Dalvik/ART Cache
   - System
   - Data
   - Internal Storage
    - Cache
3. Reboot back into recovery.

**Differences from [cedric-lineage-20210923.md](cedric-lineage-20210923.md)**: TWRP, not Lineage, recovery; and these detailed TWRP wiping steps which presumably work differently than the Lineage **Format data/factory reset** option...; and rebooting after the wipe.

### 4. Install freshest LineageOS nightly build (2021-01-23).

Back in the recovery after reboot and:

1. Plug in USB.
2. Copy ROM ZIP archive  from laptop to device storage.
3. Install via TWRP **Install** menu.
4. Reboot when done.

**Differences from [cedric-lineage-20210923.md](cedric-lineage-20210923.md)**: Used TWRP install instead of Lineage recovery install (in both cases did install by copying archive to device storage first); and used a slightly newer nightly build of LineageOS.

### 5. Profit.

This was it for me.

LineageOS completed the initial boot in 5–6 minutes and when it came back up, the IMEI numbers were back and the radio was working.

Note that I never had to fuss with redoing the `fastboot erase modemst<N>` steps, other than in the firmware re-flash.
