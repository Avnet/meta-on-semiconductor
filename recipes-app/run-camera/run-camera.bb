FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

LICENSE = "GPLv3"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/GPL-3.0-only;md5=c79ff39f19dfec6d293b95dea7b07891"

DESCRIPTION = "Sends ON semi's AR0144/AR1335/AR0830 video stream on mDP port / X11 forwarding"

SRC_URI = "file://run_camera.sh \
           file://optimize_qos_for_dp.sh \
"

RDEPENDS:${PN} = "bash"

do_install() {
    install -d ${D}${bindir}
    install -m 0755 ${WORKDIR}/run_camera.sh ${D}${bindir}/run_camera
    install -m 0755 ${WORKDIR}/optimize_qos_for_dp.sh ${D}${bindir}/optimize_qos_for_dp
}

FILES:${PN} = "${bindir}/run_camera \
               ${bindir}/optimize_qos_for_dp \
"