This repo is for review of requests for signing shim. To create a request for review:

- clone this repo (preferably fork it)
- edit the template below
- add the shim.efi to be signed
- add build logs
- add any additional binaries/certificates/SHA256 hashes that may be needed
- commit all of that
- tag it with a tag of the form "myorg-shim-arch-YYYYMMDD"
- push it to GitHub
- file an issue at https://github.com/rhboot/shim-review/issues with a link to your tag
- approval is ready when the "accepted" label is added to your issue

Note that we really only have experience with using GRUB2 or systemd-boot on Linux, so
asking us to endorse anything else for signing is going to require some convincing on
your part.

Hint: check the [docs](./docs/) directory in this repo for guidance on submission and getting your shim signed.

Here's the template:

*******************************************************************************
### What organization or people are asking to have this signed?
*******************************************************************************
Organization name and website:  
Viasat UK Ltd. is a subsidiary of global communications company Viasat Inc.
https://www.viasat.com/defense

*******************************************************************************
### What's the legal data that proves the organization's genuineness?
The reviewers should be able to easily verify, that your organization is a legal entity, to prevent abuse.
Provide the information, which can prove the genuineness with certainty.
*******************************************************************************
Company/tax register entries or equivalent:  
(a link to the organization entry in your jurisdiction's register will do)  

NASDAQ: VSAT.
https://www.nasdaq.com/market-activity/stocks/vsat

The public details of both your organization and the issuer in the EV certificate used for signing .cab files at Microsoft Hardware Dev Center File Signing Services.  
(**not** the CA certificate embedded in your shim binary)

Example:

```
Issuer: O=MyIssuer, Ltd., CN=MyIssuer EV Code Signing CA
Subject: C=XX, O=MyCompany, Inc., CN=MyCompany, Inc.
```

```
Issuer: O=Sectigo Limited, CN=Sectigo Public Code Signing CA EV R.36, C=GB
Subject: C=US, S=California, O=Viasat, Inc., CN=Viasat, Inc.
```

*******************************************************************************
### What product or service is this for?
*******************************************************************************
Viasat Data-At-Rest Cryptography Solid State Drive (DARC-SSD).

*******************************************************************************
### What's the justification that this really does need to be signed for the whole world to be able to boot it?
*******************************************************************************
Viasat provides secure data protection for government and defence agencies around the world. We have used a Microsoft Secure Boot signed shim since 2016.

*******************************************************************************
### Why are you unable to reuse shim from another distro that is already signed?
*******************************************************************************
Viasat's shim does not load a GRUB2 bootloader or a Linux kernel.

*******************************************************************************
### Who is the primary contact for security updates, etc.?
The security contacts need to be verified before the shim can be accepted. For subsequent requests, contact verification is only necessary if the security contacts or their PGP keys have changed since the last successful verification.

An authorized reviewer will initiate contact verification by sending each security contact a PGP-encrypted email containing random words.
You will be asked to post the contents of these mails in your `shim-review` issue to prove ownership of the email addresses and PGP keys.
*******************************************************************************
- Name: SecAlert, Viasat
- Position: Responsible Disclosure
- Email address: secalert@viasat.uk.com
- PGP key fingerprint: 1284 0089 74E2 7365 8177  2E28 5C6D 02C9 2AFB 4B25
  - See SecAlert_Viasat.asc
  - Available on PGP Global Directory.

(Key should be signed by the other security contacts, pushed to a keyserver
like keyserver.ubuntu.com, and preferably have signatures that are reasonably
well known in the Linux community.)

*******************************************************************************
### Who is the secondary contact for security updates, etc.?
*******************************************************************************
- Name: Customer Support, Viasat
- Position: General Support
- Email address: support@viasat.uk.com
- PGP key fingerprint: 3FCF 9C5E C75E 930D EE90  525A 8BD1 A937 2266 D44A
  - See Customer_Support_Viasat.asc
  - Available on PGP Global Directory.

(Key should be signed by the other security contacts, pushed to a keyserver
like keyserver.ubuntu.com, and preferably have signatures that are reasonably
well known in the Linux community.)

*******************************************************************************
### Were these binaries created from the 15.8 shim release tar?
Please create your shim binaries starting with the 15.8 shim release tar file: https://github.com/rhboot/shim/releases/download/15.8/shim-15.8.tar.bz2

This matches https://github.com/rhboot/shim/releases/tag/15.8 and contains the appropriate gnu-efi source.

Make sure the tarball is correct by verifying your download's checksum with the following ones:

```
a9452c2e6fafe4e1b87ab2e1cac9ec00  shim-15.8.tar.bz2
cdec924ca437a4509dcb178396996ddf92c11183  shim-15.8.tar.bz2
a79f0a9b89f3681ab384865b1a46ab3f79d88b11b4ca59aa040ab03fffae80a9  shim-15.8.tar.bz2
30b3390ae935121ea6fe728d8f59d37ded7b918ad81bea06e213464298b4bdabbca881b30817965bd397facc596db1ad0b8462a84c87896ce6c1204b19371cd1  shim-15.8.tar.bz2
```

Make sure that you've verified that your build process uses that file as a source of truth (excluding external patches) and its checksum matches. Furthermore, there's [a detached signature as well](https://github.com/rhboot/shim/releases/download/15.8/shim-15.8.tar.bz2.asc) - check with the public key that has the fingerprint `8107B101A432AAC9FE8E547CA348D61BC2713E9F` that the tarball is authentic. Once you're sure, please confirm this here with a simple *yes*.

A short guide on verifying public keys and signatures should be available in the [docs](./docs/) directory.
*******************************************************************************
Yes. See `build/CMakeLists.txt`.

*******************************************************************************
### URL for a repo that contains the exact code which was built to result in your binary:
Hint: If you attach all the patches and modifications that are being used to your application, you can point to the URL of your application here (*`https://github.com/YOUR_ORGANIZATION/shim-review`*).

You can also point to your custom git servers, where the code is hosted.
*******************************************************************************
https://github.com/viasat/shim-review

*******************************************************************************
### What patches are being applied and why:
Mention all the external patches and build process modifications, which are used during your building process, that make your shim binary be the exact one that you posted as part of this application.
*******************************************************************************
`VENDOR_CERT_FILE=viasatuk.der`
- PAE is signed by Viasat UK.

`DEFAULT_LOADER=\\\\\\\\\\\\\\\\paex64.efi`
- Shim shall load PAE only.

*******************************************************************************
### Do you have the NX bit set in your shim? If so, is your entire boot stack NX-compatible and what testing have you done to ensure such compatibility?

See https://techcommunity.microsoft.com/t5/hardware-dev-center/nx-exception-for-shim-community/ba-p/3976522 for more details on the signing of shim without NX bit.
*******************************************************************************
NX bit disabled.
```
objdump -p build/data/BOOTX64.EFI | grep DllCharacteristics
DllCharacteristics      00000000
```

*******************************************************************************
### What exact implementation of Secure Boot in GRUB2 do you have? (Either Upstream GRUB2 shim_lock verifier or Downstream RHEL/Fedora/Debian/Canonical-like implementation)
Skip this, if you're not using GRUB2.
*******************************************************************************
No GRUB2 bootloader.

*******************************************************************************
### Do you have fixes for all the following GRUB2 CVEs applied?
**Skip this, if you're not using GRUB2, otherwise make sure these are present and confirm with _yes_.**

* 2020 July - BootHole
  * Details: https://lists.gnu.org/archive/html/grub-devel/2020-07/msg00034.html
  * CVE-2020-10713
  * CVE-2020-14308
  * CVE-2020-14309
  * CVE-2020-14310
  * CVE-2020-14311
  * CVE-2020-15705
  * CVE-2020-15706
  * CVE-2020-15707
* March 2021
  * Details: https://lists.gnu.org/archive/html/grub-devel/2021-03/msg00007.html
  * CVE-2020-14372
  * CVE-2020-25632
  * CVE-2020-25647
  * CVE-2020-27749
  * CVE-2020-27779
  * CVE-2021-3418 (if you are shipping the shim_lock module)
  * CVE-2021-20225
  * CVE-2021-20233
* June 2022
  * Details: https://lists.gnu.org/archive/html/grub-devel/2022-06/msg00035.html, SBAT increase to 2
  * CVE-2021-3695
  * CVE-2021-3696
  * CVE-2021-3697
  * CVE-2022-28733
  * CVE-2022-28734
  * CVE-2022-28735
  * CVE-2022-28736
  * CVE-2022-28737
* November 2022
  * Details: https://lists.gnu.org/archive/html/grub-devel/2022-11/msg00059.html, SBAT increase to 3
  * CVE-2022-2601
  * CVE-2022-3775
* October 2023 - NTFS vulnerabilities
  * Details: https://lists.gnu.org/archive/html/grub-devel/2023-10/msg00028.html, SBAT increase to 4
  * CVE-2023-4693
  * CVE-2023-4692
*******************************************************************************
No GRUB2 bootloader.

*******************************************************************************
### If shim is loading GRUB2 bootloader, and if these fixes have been applied, is the upstream global SBAT generation in your GRUB2 binary set to 4?
Skip this, if you're not using GRUB2, otherwise do you have an entry in your GRUB2 binary similar to:  
`grub,4,Free Software Foundation,grub,GRUB_UPSTREAM_VERSION,https://www.gnu.org/software/grub/`?
*******************************************************************************
No GRUB2 bootloader.

*******************************************************************************
### Were old shims hashes provided to Microsoft for verification and to be added to future DBX updates?
### Does your new chain of trust disallow booting old GRUB2 builds affected by the CVEs?
If you had no previous signed shim, say so here. Otherwise a simple _yes_ will do.
*******************************************************************************
No GRUB2 bootloader.

*******************************************************************************
### If your boot chain of trust includes a Linux kernel:
### Is upstream commit [1957a85b0032a81e6482ca4aab883643b8dae06e "efi: Restrict efivar_ssdt_load when the kernel is locked down"](https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=1957a85b0032a81e6482ca4aab883643b8dae06e) applied?
### Is upstream commit [75b0cea7bf307f362057cc778efe89af4c615354 "ACPI: configfs: Disallow loading ACPI tables when locked down"](https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=75b0cea7bf307f362057cc778efe89af4c615354) applied?
### Is upstream commit [eadb2f47a3ced5c64b23b90fd2a3463f63726066 "lockdown: also lock down previous kgdb use"](https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=eadb2f47a3ced5c64b23b90fd2a3463f63726066) applied?
Hint: upstream kernels should have all these applied, but if you ship your own heavily-modified older kernel version, that is being maintained separately from upstream, this may not be the case.  
If you are shipping an older kernel, double-check your sources; maybe you do not have all the patches, but ship a configuration, that does not expose the issue(s).
*******************************************************************************
No Linux kernel.

*******************************************************************************
### How does your signed kernel enforce lockdown when your system runs
### with Secure Boot enabled?
Hint: If it does not, we are not likely to sign your shim.
*******************************************************************************
No Linux kernel.

*******************************************************************************
### Do you build your signed kernel with additional local patches? What do they do?
*******************************************************************************
No Linux kernel.

*******************************************************************************
### Do you use an ephemeral key for signing kernel modules?
### If not, please describe how you ensure that one kernel build does not load modules built for another kernel.
*******************************************************************************
No Linux kernel.

*******************************************************************************
### If you use vendor_db functionality of providing multiple certificates and/or hashes please briefly describe your certificate setup.
### If there are allow-listed hashes please provide exact binaries for which hashes are created via file sharing service, available in public with anonymous access for verification.
*******************************************************************************
Our embedded certificate is used to verify the PAE binary.

*******************************************************************************
### If you are re-using the CA certificate from your last shim binary, you will need to add the hashes of the previous GRUB2 binaries exposed to the CVEs mentioned earlier to vendor_dbx in shim. Please describe your strategy.
This ensures that your new shim+GRUB2 can no longer chainload those older GRUB2 binaries with issues.

If this is your first application or you're using a new CA certificate, please say so here.
*******************************************************************************
No GRUB2 bootloader.

*******************************************************************************
### Is the Dockerfile in your repository the recipe for reproducing the building of your shim binary?
A reviewer should always be able to run `docker build .` to get the exact binary you attached in your application.

Hint: Prefer using *frozen* packages for your toolchain, since an update to GCC, binutils, gnu-efi may result in building a shim binary with a different checksum.

If your shim binaries can't be reproduced using the provided Dockerfile, please explain why that's the case, what the differences would be and what build environment (OS and toolchain) is being used to reproduce this build? In this case please write a detailed guide, how to setup this build environment from scratch.
*******************************************************************************

- `build/build_shim.sh` - Installs required packages, invokes `cmake`, and compares the built binary `build/output/BOOTX64.EFI` to the reference binary `build/data/BOOTX64.EFI`.
- `build/build.sh` - Invokes `build_shim.sh` and pipes output to log file `output/build_shim.log`.
- `build/CMakeLists.txt` - Builds shim twice to compare Viasat shim to Red Hat shim.

If you have Windows 10 with WSL 2 enabled and Python 3 installed, you can run the scripts under `setup/`. Otherwise, you can follow the steps manually to create a VM to perform the reproducible build and run `bash build.sh` from `build/` inside the VM.

- `setup/vm_0_setup.py` - Imports a fresh Ubuntu 24.04 LTS into a build VM in WSL 2.
  - [Ubuntu 24.04 LTS rootfs](https://cloud-images.ubuntu.com/wsl/releases/noble/20240423/ubuntu-noble-wsl-amd64-24.04lts.rootfs.tar.gz)
    - `SHA256=2a790896740b14d637dbdc583cce1ba081ac53b9e9cdb46dc09a2f73abbd9934`
  - `wsl.exe --import` requires at least Windows 10.0.18305.

- `setup/vm_1_build.py` - Imports the `build/` directory into the build VM to perform a reproducible build.
  - Installs frozen packages:
    - `bsdmainutils=12.1.8`
    - `cmake=3.28.3-1build7`
    - `dos2unix=7.5.1-1`
    - `gcc=4:13.2.0-7ubuntu1`
    - `g++=4:13.2.0-7ubuntu1`
    - `git=1:2.43.0-1ubuntu7.2`
    - `make=4.3-4.1build2`
    - `pesign=116-7`
    - `wget=1.21.4-1ubuntu4.1`

- `setup/vm_2_clean.py` - Unregisters and removes the build VM.

Example PowerShell session:

```powershell
WSL> py -3 .\setup\vm_0_setup.py
wsl.exe --list
Downloading Ubuntu image...
Date Mon, 03 Feb 2025 12:56:41 GMT
Server Apache/2.4.29 (Ubuntu)
Last-Modified Thu, 25 Apr 2024 17:10:56 GMT
ETag "15435ed9-616eeded0f590"
Accept-Ranges bytes
Content-Length 356736729
Connection close
Content-Type application/x-gzip
Verifying Ubuntu image...
Importing Ubuntu image...
wsl.exe --import Ubuntu-Viasat D:\projects\shim-review\setup\..\temp\ubuntu-viasat D:\projects\shim-review\setup\..\temp\ubuntu-viasat.rootfs.tar.gz
WSL> py -3 .\setup\vm_1_build.py
wsl.exe --list
Importing source ...
wsl.exe -d Ubuntu-Viasat -e cp -r ../build /root
Building shim ...
wsl.exe -d Ubuntu-Viasat --cd /root/build -e bash build.sh
Exporting output ...
wsl.exe -d Ubuntu-Viasat -e cp -r /root/build/output/ ../build
```

*******************************************************************************
### Which files in this repo are the logs for your build?
This should include logs for creating the buildroots, applying patches, doing the build, creating the archives, etc.
*******************************************************************************

- `logs/build_shim.log` - Reproducible build.
- `logs/viasat-shim-build.log` - Viasat shim build.

*******************************************************************************
### What changes were made in the distro's secure boot chain since your SHIM was last signed?
For example, signing new kernel's variants, UKI, systemd-boot, new certs, new CA, etc..

Skip this, if this is your first application for having shim signed.
*******************************************************************************
Update shim to address [#682](https://github.com/rhboot/shim/issues/682).

*******************************************************************************
### What is the SHA256 hash of your final shim binary?
*******************************************************************************
ac0c115c3ab7f764e05db7213f772ece8b58a06566a6e5f70d8eddbc756f342a

*******************************************************************************
### How do you manage and protect the keys used in your shim?
Describe the security strategy that is used for key protection. This can range from using hardware tokens like HSMs or Smartcards, air-gapped vaults, physical safes to other good practices.
*******************************************************************************
The private key is stored on a hardware token with restricted access.

*******************************************************************************
### Do you use EV certificates as embedded certificates in the shim?
A _yes_ or _no_ will do. There's no penalty for the latter.
*******************************************************************************
Yes.

*******************************************************************************
### Do you add a vendor-specific SBAT entry to the SBAT section in each binary that supports SBAT metadata ( GRUB2, fwupd, fwupdate, systemd-boot, systemd-stub, shim + all child shim binaries )?
### Please provide the exact SBAT entries for all binaries you are booting directly through shim.
Hint: The history of SBAT and more information on how it works can be found [here](https://github.com/rhboot/shim/blob/main/SBAT.md). That document is large, so for just some examples check out [SBAT.example.md](https://github.com/rhboot/shim/blob/main/SBAT.example.md)

If you are using a downstream implementation of GRUB2 (e.g. from Fedora or Debian), make sure you have their SBAT entries preserved and that you **append** your own (don't replace theirs) to simplify revocation.

**Remember to post the entries of all the binaries. Apart from your bootloader, you may also be shipping e.g. a firmware updater, which will also have these.**

Hint: run `objcopy --only-section .sbat -O binary YOUR_EFI_BINARY /dev/stdout` to get these entries. Paste them here. Preferably surround each listing with three backticks (\`\`\`), so they render well.
*******************************************************************************
SHIM:
```
sbat,1,SBAT Version,sbat,1,https://github.com/rhboot/shim/blob/main/SBAT.md
shim,4,UEFI shim,shim,1,https://github.com/rhboot/shim
shim.viasat,2,Viasat UK,shim,15.8,mailto:secalert@viasat.uk.com
```
PAE:
```
sbat,1,SBAT Version,sbat,1,https://github.com/rhboot/shim/blob/main/SBAT.md
viasat.pae,1,Viasat UK,pae,2.0.0,mailto:secalert@viasat.uk.com
```

*******************************************************************************
### If shim is loading GRUB2 bootloader, which modules are built into your signed GRUB2 image?
Skip this, if you're not using GRUB2.

Hint: this is about those modules that are in the binary itself, not the `.mod` files in your filesystem.
*******************************************************************************
No GRUB2 bootloader.

*******************************************************************************
### If you are using systemd-boot on arm64 or riscv, is the fix for [unverified Devicetree Blob loading](https://github.com/systemd/systemd/security/advisories/GHSA-6m6p-rjcq-334c) included?
*******************************************************************************
No systemd-boot bootloader.

*******************************************************************************
### What is the origin and full version number of your bootloader (GRUB2 or systemd-boot or other)?
*******************************************************************************
Our PAE application is proprietary.

*******************************************************************************
### If your shim launches any other components apart from your bootloader, please provide further details on what is launched.
Hint: The most common case here will be a firmware updater like fwupd.
*******************************************************************************
The SHIM launches our Pre-Authentication Environment (PAE) application which allows an authenticated user to administer and boot Viasat DARC-SSDs. It does not allow the loading and execution of further code.

*******************************************************************************
### If your GRUB2 or systemd-boot launches any other binaries that are not the Linux kernel in SecureBoot mode, please provide further details on what is launched and how it enforces Secureboot lockdown.
Skip this, if you're not using GRUB2 or systemd-boot.
*******************************************************************************
No GRUB2 or systemd-boot bootloader.

*******************************************************************************
### How do the launched components prevent execution of unauthenticated code?
Summarize in one or two sentences, how your secure bootchain works on higher level.
*******************************************************************************
The integrity of the PAE is verified with a digital signature by the SHIM.

*******************************************************************************
### Does your shim load any loaders that support loading unsigned kernels (e.g. certain GRUB2 configurations)?
*******************************************************************************
No.

*******************************************************************************
### What kernel are you using? Which patches and configuration does it include to enforce Secure Boot?
*******************************************************************************
No Linux kernel.

*******************************************************************************
### What contributions have you made to help us review the applications of other applicants?
The reviewing process is meant to be a peer-review effort and the best way to have your application reviewed faster is to help with reviewing others. We are in most cases volunteers working on this venue in our free time, rather than being employed and paid to review the applications during our business hours. 

A reasonable timeframe of waiting for a review can reach 2-3 months. Helping us is the best way to shorten this period. The more help we get, the faster and the smoother things will go.

For newcomers, the applications labeled as [*easy to review*](https://github.com/rhboot/shim-review/issues?q=is%3Aopen+is%3Aissue+label%3A%22easy+to+review%22) are recommended to start the contribution process.
*******************************************************************************
We hope the instructions provided to perform a reproducible build without a Dockerfile are acceptable.

*******************************************************************************
### Add any additional information you think we may need to validate this shim signing application.
*******************************************************************************
None.
