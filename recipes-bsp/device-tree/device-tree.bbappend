FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

SRC_URI += "file://system-user.dtsi \
            file://ar0144.dts \
            file://ar1335.dts \
            file://ar0830.dts \
"

do_compile:prepend() {
    import shutil
    workdir = d.getVar("WORKDIR")
    dt_file_path = d.getVar("DT_FILES_PATH")

    shutil.copyfile(workdir + "/ar0144.dts", dt_file_path + "/ar0144.dts")
    shutil.copyfile(workdir + "/ar1335.dts", dt_file_path + "/ar1335.dts")
    shutil.copyfile(workdir + "/ar0830.dts", dt_file_path + "/ar0830.dts")
}
