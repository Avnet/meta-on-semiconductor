FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

LICENSE = "GPLv3"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/GPL-3.0;md5=c79ff39f19dfec6d293b95dea7b07891"

DESCRIPTION = "Sends ON semi's AR0144/AR1335 video stream on mDP port"

SRC_URI = "file://run_1920_1080.sh"

RDEPENDS_${PN} = "bash"

do_install() {
    install -d ${D}${bindir}
    install -m 0755 ${WORKDIR}/run_1920_1080.sh ${D}${bindir}/run_1920_1080
}

FILES_${PN} = "${bindir}/run_1920_1080"
