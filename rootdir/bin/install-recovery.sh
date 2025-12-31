#!/vendor/bin/sh
if ! applypatch --check EMMC:/dev/block/by-name/recovery$(getprop ro.boot.slot_suffix):80740352:b8a3e740a109c05a0c8b2de4c8bd13f2aac35708; then
  applypatch \
          --patch /vendor/recovery-from-boot.p \
          --source EMMC:/dev/block/by-name/boot$(getprop ro.boot.slot_suffix):33554432:873c805a0d551f21eec2e5f8cf592ff4556fa229 \
          --target EMMC:/dev/block/by-name/recovery$(getprop ro.boot.slot_suffix):80740352:b8a3e740a109c05a0c8b2de4c8bd13f2aac35708 && \
      (log -t install_recovery "Installing new recovery image: succeeded" && setprop vendor.ota.recovery.status 200) || \
      (log -t install_recovery "Installing new recovery image: failed" && setprop vendor.ota.recovery.status 454)
else
  log -t install_recovery "Recovery image already installed" && setprop vendor.ota.recovery.status 200
fi

