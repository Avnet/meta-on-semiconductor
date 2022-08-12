DESCRIPTION = "Image definition for ultra96v2 dual cameras boards"
LICENSE = "MIT"

IMAGE_INSTALL:append:u96v2-sbc += "\
		ap1302-firmware \
		device-tree \
		camera-setup \
		run-1920-1080 \
		libdrm \
		libdrm-tests \
		libdrm-kms \
"
