SECTION = "PETALINUX/apps"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

SRC_URI = "file://load_default_camera_config.sh \
           file://load_camera_config.sh \
"

S = "${WORKDIR}"

inherit update-rc.d

INITSCRIPT_NAME = "load_default_camera_config"
# Run the script at the very beginning of run level 5.
# Right before the networking is initialized
INITSCRIPT_PARAMS = "start 00 5 ."


do_install() {
	install -d ${D}${bindir}
	install -m 0755 ${S}/load_camera_config.sh ${D}${bindir}/load_camera_config

	install -d ${D}${sysconfdir}/init.d
	install -m 0755 ${S}/load_default_camera_config.sh ${D}${sysconfdir}/init.d/load_default_camera_config
}

FILES:${PN} = "${bindir}/load_camera_config \
               ${sysconfdir}/init.d/load_default_camera_config \
"
