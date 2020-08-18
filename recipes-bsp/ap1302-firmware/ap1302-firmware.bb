FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

LICENSE = "CLOSED"
DESCRIPTION = "Firmware files for use with ON semi AP1302"

SRC_URI = "file://ar0144_dual_fw.bin"

do_install() {
    install -d ${D}${base_libdir}/firmware
    install -m 0755 ${WORKDIR}/ar0144_dual_fw.bin ${D}${base_libdir}/firmware
}

FILES_${PN} = "${base_libdir}/firmware/ar0144_dual_fw.bin"
