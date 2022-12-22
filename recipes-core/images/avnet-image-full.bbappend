DESCRIPTION = "Image definition for ultra96v2 dual cameras boards"
LICENSE = "MIT"

IMAGE_INSTALL:append += "\
		ap1302-firmware \
		device-tree \
		camera-setup \
		run-1920-1080 \
		libdrm \
		libdrm-tests \
		libdrm-kms \
        bridge-utils \
        cmake \
        dnf \
        gpio-utils \
        json-c \
        libpython3 \
        lmsensors-sensorsdetect \
        mesa-megadriver \
        opencl-clhpp-dev \
        opencl-headers-dev \
        openssh \
        openssh-scp \
        openssh-sftp-server \
        openssh-sshd \
        packagegroup-petalinux-display-debug \
        packagegroup-petalinux-gstreamer \
        packagegroup-petalinux-matchbox \
        packagegroup-petalinux-opencv-dev \
        packagegroup-petalinux-opencv \
        packagegroup-petalinux-python-modules \
        packagegroup-petalinux-self-hosted \
        packagegroup-petalinux-v4lutils \
        packagegroup-petalinux-x11 \
        pciutils \
        python3-pyserial \
        python3 \
        python3-pip \
        xrt \
        xrt-dev \
        zocl \
"

COMMON_FEATURES:remove = "\
        ssh-server-dropbear \
"
