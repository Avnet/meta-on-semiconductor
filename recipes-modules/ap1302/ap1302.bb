SUMMARY = "Recipe for building an external ap1302 Linux kernel module"
SECTION = "PETALINUX/modules"
LICENSE = "GPLv2"
LIC_FILES_CHKSUM = "file://${COREBASE}/meta/files/common-licenses/GPL-2.0;md5=801f80980d171dd6425610833a22dbe6"

inherit module

SRC_URI = "git://github.com/Avnet/ap1302-driver.git;protocol=https;branch=master"

SRCREV = "${AUTOREV}"

DEPENDS += "virtual/kernel"

S = "${WORKDIR}/git"

EXTRA_OEMAKE = 'CONFIG_VIDEO_AP1302=m \
		CONFIG_CMA_SIZE_MBYTES=1024 \
		KERNEL_SRC="${STAGING_KERNEL_DIR}" \
		O=${STAGING_KERNEL_BUILDDIR}'

