DESCRIPTION = "Image definition for ultra96v2 dual cameras boards"
LICENSE = "MIT"

IMAGE_INSTALL_append_u96v2-sbc += "\
		ap1302 \
		ap1302-firmware \
		device-tree \
		camera-setup \
		run-1920-1080 \
		libdrm \
		libdrm-tests \
		libdrm-kms \
"
