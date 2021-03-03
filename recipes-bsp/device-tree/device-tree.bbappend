FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI += "file://system-user.dtsi \
            file://ar0144_dual.dts \
            file://ar0144_single.dts \
"

do_compile_prepend() {
    import shutil
    workdir = d.getVar("WORKDIR")
    dt_file_path = d.getVar("DT_FILES_PATH")

    shutil.copyfile(workdir + "/ar0144_dual.dts", dt_file_path + "/ar0144_dual.dts")
    shutil.copyfile(workdir + "/ar0144_single.dts", dt_file_path + "/ar0144_single.dts")
}

do_install_append() {
	install -d ${D}/boot/overlays

	install -m 0755 ${B}/ar0144_dual.dtbo ${D}/boot/overlays
	install -m 0755 ${B}/ar0144_single.dtbo ${D}/boot/overlays
}

FILES_${PN} += " /boot/overlays/ar0144_dual.dtbo \
                 /boot/overlays/ar0144_single.dtbo \
"
