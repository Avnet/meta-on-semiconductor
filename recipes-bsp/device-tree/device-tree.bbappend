FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI += "file://system-user.dtsi \
            file://ar0144_dual.dts \
            file://ar0144_single.dts \
            file://ar1335_single.dts \
"

do_compile_prepend() {
    import shutil
    workdir = d.getVar("WORKDIR")
    dt_file_path = d.getVar("DT_FILES_PATH")

    shutil.copyfile(workdir + "/ar0144_dual.dts", dt_file_path + "/ar0144_dual.dts")
    shutil.copyfile(workdir + "/ar0144_single.dts", dt_file_path + "/ar0144_single.dts")
    shutil.copyfile(workdir + "/ar1335_single.dts", dt_file_path + "/ar1335_single.dts")
}
