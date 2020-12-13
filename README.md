This README file contains information on the contents of the
meta-on-semiconductor layer.

Please see the corresponding sections below for details.


Dependencies
============

This layer depends on:

  URI: git://git.openembedded.org/bitbake
  branch: master

  URI: git://git.openembedded.org/openembedded-core
  layers: meta
  branch: master

  URI: https://github.com/Avnet/meta-avnet.git
  layers: meta-avnet
  branch: master


Table of Contents
=================

  I. Introduction
 II. Adding the meta-on-semiconductor layer to your build
III. Recipes
 IV. Useful links
  V. Disclosure

I. Introduction
===============

The meta-on-semiconductor aims to add support for the ON semiconductor camera mezzanine. This meta
can be added on top of meta-avnet which adds support for the Ultra96V2.

To use it:
- clone meta-onsemiconductor and meta-avnet repositories in the project-spec/ folder inside your Petalinux project
- in Petalinux config, 'Yocto Settings'/'User Layers', add two layeres '${PROOT}/project-spec/meta-avnet' and
  '${PROOT}/project-spec/meta-on-semiconductor'. Meta-avnet must have a lower priority than meta-on-semiconductor
- in Petalinux config, change the YOCTO_MACHINE_NAME to use an Avnet Machine ('ultra96v2' for example)
- then you can use 'petalinux-build -c on-semiconductor-image' to build your BSP

You can also clone AVNET's Petalinux git and run the script './scripts/make_onsemi_ap1302.sh' to build
the complete Ultra96V2_oob BSP with ON semiconduction camera mezzanine support.


II. Adding the meta-on-semiconductor layer to your build
========================================================

In order to use this layer, you need to make the build system aware of
it.

Assuming the meta-on-semiconductor layer exists at the top-level of your
yocto build tree, you can add it to the build system by adding the
location of the meta-on-semiconductor layer to bblayers.conf, along with any
other layers needed. e.g.:

  BBLAYERS ?= " \
    /path/to/yocto/meta \
    /path/to/yocto/meta-poky \
    /path/to/yocto/meta-yocto-bsp \
    /path/to/yocto/meta-meta-user \
    /path/to/yocto/meta-avnet \
    /path/to/yocto/meta-on-semiconductor \
    "


III. Recipes
============

meta-on-semiconductor contains one conf folder and multiple recipes:
.
├── conf
│   └── layer.conf
├── COPYING.MIT
├── README
├── README.md
├── recipes-app
│   └── run-1920-1080
├── recipes-bsp
│   ├── ap1302-firmware
│   └── device-tree
├── recipes-core
│   └── images
└── recipes-modules
    └── ap1302

conf/layer.conf:
----------------

Adds the meta-on-semiconductor on top of the meta-avnet.

recipes-app/run-1920-1080:
--------------------------

Installs the script 'run_1920_1080.sh' in the rootfs. This script is used to display the images captured
by the cameras on a screen with a resoltion of 1920x1080 at a framerate of 60 fps.

recipes-bsp/ap1302-firmware:
----------------------------

Installs the cameras firmware in the rootfs.

recipes-bsp/device-tree:
------------------------

Appends the device tree to support the camera mezzanine.

recipes-core/images:
--------------------

Defines the possible build images based on avnet-minimal-image provided by the meta-avnet.

recipes-modules/ap1302:
-----------------------

Fetches, builds and install the AP1302 kernel module in the rootfs.

IV. Useful links
================
[meta-avnet]:https://github.com/Avnet/meta-avnet
[Avnet Petalinux 2020.1]: https://github.com/Avnet/petalinux
[AP1302 Kernel module]:https://github.com/Avnet/ap1302-driver

V. Disclosure
=============

This meta isn't finished yet and it still fetches development branches.
