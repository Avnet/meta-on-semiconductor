SECTION = "PETALINUX/apps"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

SRC_URI = "file://load-default-camera-config.service \
           file://load_camera_config.sh \
"

S = "${WORKDIR}"

RDEPENDS:${PN} = "gpio-utils-systemd"

inherit systemd

do_install() {
	install -d ${D}${bindir}
	install -m 0755 ${S}/load_camera_config.sh ${D}${bindir}/load_camera_config

	install -d ${D}/${systemd_system_unitdir}
	install -m 0644 ${S}/load-default-camera-config.service ${D}${systemd_system_unitdir}/load-default-camera-config.service 

}

SYSTEMD_SERVICE:${PN} = "load-default-camera-config.service"

FILES:${PN} = "${bindir}/load_camera_config \
               ${systemd_system_unitdir}/load-default-camera-config.service  \
"
