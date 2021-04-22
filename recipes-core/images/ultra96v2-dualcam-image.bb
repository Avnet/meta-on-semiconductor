DESCRIPTION = "Image definition for ultra96v2 dual cameras boards"
LICENSE = "MIT"

require recipes-core/images/avnet-image-full.inc

IMAGE_INSTALL_u96v2-sbc += "\
		ap1302 \
		ap1302-firmware \
		run-1920-1080 \
		libdrm \
		libdrm-tests \
		libdrm-kms \
"

IMAGE_INSTALL_remove_u96v2-sbc = "\
		packagegroup-petalinux-x11 \
		packagegroup-petalinux-matchbox \
"
