DESCRIPTION = "Image definition for ultra96v2 dual cameras boards"
LICENSE = "MIT"

require recipes-core/images/avnet-image-common.inc

IMAGE_INSTALL_ultra96v2 += "\
		libdrm \
		libdrm-tests \
		libdrm-kms \
"

IMAGE_INSTALL_remove_ultra96v2 = "\
		packagegroup-petalinux-x11 \
		packagegroup-petalinux-matchbox \
"
