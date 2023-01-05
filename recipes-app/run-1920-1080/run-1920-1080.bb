FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

LICENSE = "GPLv3"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/GPL-3.0-only;md5=c79ff39f19dfec6d293b95dea7b07891"

DESCRIPTION = "Sends ON semi's AR0144/AR1335 video stream on mDP port / X11 forwarding"

SRC_URI:u96v2-sbc = "file://run_1920_1080.sh \
                     file://run_3840_2160.sh \
                     file://optimize_qos_for_dp.sh \
"

SRC_URI:zub1cg-sbc = "file://run_640_480_rgb.sh \
                      file://run_640_480_yuv422.sh \
                      file://run_1280_480_rgb.sh \
                      file://run_1280_480_yuv422.sh \
                      file://run_1920_1080_rgb.sh \
                      file://run_1920_1080_yuv422.sh \
                      file://run_2560_800_rgb.sh \
                      file://run_2560_800_yuv422.sh \
                      file://auto_detect_mipi.sh \
"

RDEPENDS:${PN} = "bash"

do_install:u96v2-sbc() {
    install -d ${D}${bindir}
    install -m 0755 ${WORKDIR}/run_1920_1080.sh ${D}${bindir}/run_1920_1080
    install -m 0755 ${WORKDIR}/run_3840_2160.sh ${D}${bindir}/run_3840_2160
    install -m 0755 ${WORKDIR}/optimize_qos_for_dp.sh ${D}${bindir}/optimize_qos_for_dp
}

do_install:append:zub1cg-sbc() {
    install -d ${D}${bindir}
    install -m 0755 ${WORKDIR}/run_640_480_rgb.sh ${D}${bindir}/run_640_480_rgb
    install -m 0755 ${WORKDIR}/run_640_480_yuv422.sh ${D}${bindir}/run_640_480_yuv422
    install -m 0755 ${WORKDIR}/run_1280_480_rgb.sh ${D}${bindir}/run_1280_480_rgb
    install -m 0755 ${WORKDIR}/run_1280_480_yuv422.sh ${D}${bindir}/run_1280_480_yuv422
    install -m 0755 ${WORKDIR}/run_1920_1080_rgb.sh ${D}${bindir}/run_1920_1080_rgb
    install -m 0755 ${WORKDIR}/run_1920_1080_yuv422.sh ${D}${bindir}/run_1920_1080_yuv422
    install -m 0755 ${WORKDIR}/run_2560_800_rgb.sh ${D}${bindir}/run_2560_800_rgb
    install -m 0755 ${WORKDIR}/run_2560_800_yuv422.sh ${D}${bindir}/run_2560_800_yuv422
}

FILES:${PN}:u96v2-sbc = "${bindir}/run_1920_1080 \
                         ${bindir}/run_3840_2160 \
                         ${bindir}/optimize_qos_for_dp \
"

FILES:${PN}:zub1cg-sbc = "${bindir}/run_640_480_rgb \
                          ${bindir}/run_640_480_yuv422 \
                          ${bindir}/run_1280_480_rgb \
                          ${bindir}/run_1280_480_yuv422 \
                          ${bindir}/run_1920_1080_rgb \
                          ${bindir}/run_1920_1080_yuv422 \
                          ${bindir}/run_2560_800_rgb \
                          ${bindir}/run_2560_800_yuv422 \
                          ${bindir}/auto_detect_mipi.sh \
"
