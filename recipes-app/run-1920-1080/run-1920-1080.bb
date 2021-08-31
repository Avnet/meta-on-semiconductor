FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

LICENSE = "GPLv3"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/GPL-3.0;md5=c79ff39f19dfec6d293b95dea7b07891"

DESCRIPTION = "Sends ON semi's AR0144/AR1335 video stream on mDP port"

SRC_URI = "file://run_1920_1080.sh \
           file://run_3840_2160.sh \
           file://optimize_qos_for_dp.sh \
"

RDEPENDS_${PN} = "bash"

do_install() {
    install -d ${D}${bindir}
    install -m 0755 ${WORKDIR}/run_1920_1080.sh ${D}${bindir}/run_1920_1080
    install -m 0755 ${WORKDIR}/run_3840_2160.sh ${D}${bindir}/run_3840_2160
    install -m 0755 ${WORKDIR}/optimize_qos_for_dp.sh ${D}${bindir}/optimize_qos_for_dp
}

FILES_${PN} = "${bindir}/run_1920_1080 \
               ${bindir}/run_3840_2160 \
               ${bindir}/optimize_qos_for_dp \
"
