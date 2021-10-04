# Lineage on cedric, part 4 (using microG to fix push notifications)

- **Date**: 2021-10-03
- **Topic**: Fixing push notifications on Motorola Moto G G5 "cedric" by replacing LineageOS 18.1 with [LineageOS for microG](https://lineage.microg.org/) 18.1
- **Outcome**: Success

## Versions that worked

| Item | Version | File | sha256 |
|-|-|-|-|
| **Hardware** | cedric XT1671 32GB P5 | - | - |
| **Firmware** | OPP28.85-19-4-2 | `CEDRIC_RETAIL_8.1.0_OPP28.85-19-4-2_cid50_subsidy-DEFAULT_regulatory-DEFAULT_CFC.xml.zip` | `ff11d01ede235bd49281bddd64a6032732691fa496000ae80d3fdcc86d53cac9` |
| **Recovery** | TWRP Recovery 3.5.2 for cedric† | `twrp-3.5.2_9-0-cedric.img` | `a47fb6578f68e20de287db28edb676c98e00b6121b1b492101ca2518f7323300` |
| **OS** | LineageOS for microG 18.1 nightly build 20210914 | `lineage-18.1-20210914-microG-cedric.zip` | `2178ebf3917006ffa2eb8891dce6b05dabb662816a9bbbd26ed03ab0fc42a45f` |

## Background

I need push notifications to work for multiple reasons and decided microG is the answer. I decided the best way to get microG is to do a clean install of [LineageOS for microG ](https://lineage.microg.org/) 18.1 on my cedric, replacing the standard LineageOS 18.1 install I did successfully on 2021-09-25.

## See also

- [cedric-lineage-20210925-imei-00.md](cedric-lineage-20210925-imei-00.md) - Explaining how I successfully did the standard LineageOS 18.1 install, defeating the dreaded IMEI 0/0 problem.
- [cedric-lineage-20211002-gaps.md](cedric-lineage-20211002-gaps.md) - Explaining my decision to go with LineageOS for microG because of LineageOS gaps I can't live with, specifically broken push notifications.

## Process

Same process as [cedric-lineage-20210925-imei-00.md](cedric-lineage-20210925-imei-00.md). The only difference was the version of the Lineage ZIP that I installed with TWRP recovery 3.5.2.

Although I ran into some problems with a different build of LineageOS for microG (see *Lessons learned*, below), the install worked on the first try when I used the versions listed in *Versions that worked*.

## Lessons learned

### Push notifications fixed

microG works just fine. My push notifications are fixed, and in particular both the push related issues I raised in [cedric-lineage-20211002-gaps.md](cedric-lineage-20211002-gaps.md) are now gone:

1. Signal works without the *Background connection enabled* issue.
2. My proprietary work application now works.

### More IMEI 0/0 issues

I ran into the IMEI 0/0 problem multiple times during this install process. I think there is a good chance they are caused (and fixed) by the custom ROM, *i.e.* the Lineage or Lineage for microG install ZIP. It seems likely that whatever manages the IMEI on cedric is very sensitive and that some builds of the ZIP break it or misconfigure it, while other builds of the same software work just fine.

- For example, I installed `lineage-18.1-20211002-microG-cedric.zip` (SHA256 `3221ab3805b4f0f3037dd7d1d0fc89edd54119220c68f808e6e361c51c3dbb0c`) multiple times but each time I booted into LineageOS after installing it, I had IMEI 0/0. The first time I installed the 20210914 build it worked!
- This suggests to me that the correct approach to debugging IMEI 0/0 is to keep trying build versions until one works.