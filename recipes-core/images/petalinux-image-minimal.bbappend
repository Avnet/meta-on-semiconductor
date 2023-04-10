DESCRIPTION = "Image definition for ultra96v2 dual cameras boards"
LICENSE = "MIT"

DUALCAM_PACKAGES += "\
		ap1302 \
		device-tree \
		camera-setup \
		run-camera \
		libdrm \
		libdrm-tests \
		libdrm-kms \
		dualcam-python-examples \
"

IMAGE_INSTALL:append:u96v2-sbc-dualcam += "\
		${DUALCAM_PACKAGES} \
"

IMAGE_INSTALL:append:zub1cg-sbc-dualcam += "\
		${DUALCAM_PACKAGES} \
"
