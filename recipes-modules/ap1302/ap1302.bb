SUMMARY = "Recipe for building an external ap1302 Linux kernel module"
SECTION = "PETALINUX/modules"
LICENSE = "GPLv2"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/GPL-2.0-only;md5=801f80980d171dd6425610833a22dbe6"

inherit module python3native

SRC_URI = "git://github.com/Avnet/ap1302-driver.git;protocol=https;branch=Avnet/dev/xlnx_6.1.5; \
			"

SRCREV = "597111885525e54c5fa3e8ad2bb6b6f510491adf"

DEPENDS += "virtual/kernel"

S = "${WORKDIR}/git"

MODULE_DIR = "kmod"
FIRMWARE_DIR = "fw"

MODULES_MODULE_SYMVERS_LOCATION = "${MODULE_DIR}/"

EXTRA_OEMAKE = '-C ${MODULE_DIR}/ CONFIG_VIDEO_AP1302=m \
		CONFIG_CMA_SIZE_MBYTES=1024 \
		KERNEL_SRC="${STAGING_KERNEL_DIR}" \
		O=${STAGING_KERNEL_BUILDDIR}'

do_compile:append() {
	cd ${S}/${FIRMWARE_DIR}
	for file in $(ls *.xml); do
		./xml2bin.py ${file} ${file%.*}.bin
	done
}

do_install:append() {
	install -d ${D}${base_libdir}/firmware
	install -m 0755 ${S}/${FIRMWARE_DIR}/*.bin ${D}${base_libdir}/firmware
}

FILES:${PN} = "${base_libdir}/firmware/*.bin"
