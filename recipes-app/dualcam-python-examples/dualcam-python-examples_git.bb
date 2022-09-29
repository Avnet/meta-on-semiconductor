DESCRIPTION = "Python based OpenCV examples for AP1302-based cameras"
HOMEPAGE = "https://github.com/AlbertaBeef/avnet_dualcam_python_examples"

LICENSE = "GPL-2.0"
LIC_FILES_CHKSUM = "file://LICENSE;md5=86d3f3a95c324c9479bd8986968f4327"

SRC_URI = "git://github.com/AlbertaBeef/avnet_dualcam_python_examples;protocol=https;branch=2022.1"
SRCREV = "${AUTOREV}"

RDEPENDS:${PN} = "python3 \
				  python3-numpy \
				  opencv \
				  camera-setup \
"

S = "${WORKDIR}/git"

do_install() {

	HOMEPATH="${D}/home/root/avnet_dualcam_python_examples"
	install -d ${HOMEPATH}
	cp -r ${S}/avnet_dualcam ${HOMEPATH}/avnet_dualcam

	install -m 0755 ${S}/avnet_dualcam_ar0144_anaglyph.py ${HOMEPATH}/avnet_dualcam_ar0144_anaglyph.py
	install -m 0755 ${S}/avnet_dualcam_ar0144_dual_passthrough.py ${HOMEPATH}/avnet_dualcam_ar0144_dual_passthrough.py
	install -m 0755 ${S}/avnet_dualcam_ar0144_single_passthrough.py ${HOMEPATH}/avnet_dualcam_ar0144_single_passthrough.py
	install -m 0755 ${S}/avnet_dualcam_ar1335_single_passthrough.py ${HOMEPATH}/avnet_dualcam_ar1335_single_passthrough.py
}

FILES:${PN} = "/home/root/avnet_dualcam_python_examples \
			   /home/root/avnet_dualcam_python_examples/avnet_dualcam \
"
