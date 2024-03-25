#!/bin/bash

SHELL_FOLDER=$(dirname $(readlink -f "$0"))

bash $SHELL_FOLDER/../common/kernel_6.1.sh

git_clone_path master https://github.com/coolsnowwolf/lede target/linux/x86/files

git_clone_path master https://github.com/coolsnowwolf/lede target/linux/x86/patches-6.1

curl -sfL https://raw.githubusercontent.com/coolsnowwolf/lede/master/target/linux/x86/base-files/etc/board.d/02_network -o target/linux/x86/base-files/etc/board.d/02_network

curl -sfL https://raw.githubusercontent.com/coolsnowwolf/lede/master/target/linux/x86/64/config-6.1 -o target/linux/x86/64/config-6.1

sed -i 's/DEFAULT_PACKAGES +=/DEFAULT_PACKAGES += kmod-usb-hid kmod-mmc kmod-sdhci usbutils pciutils lm-sensors-detect kmod-alx kmod-vmxnet3 kmod-igbvf kmod-iavf kmod-bnx2x kmod-pcnet32 kmod-tulip kmod-r8125 kmod-8139cp kmod-8139too kmod-i40e kmod-drm-i915 kmod-drm-amdgpu kmod-mlx4-core kmod-mlx5-core fdisk lsblk kmod-phy-broadcom/' target/linux/x86/Makefile

mv -f tmp/r81* feeds/kiddin9/
sed -i 's,kmod-r8169,kmod-r8168,g' target/linux/x86/image/64.mk
sed -i 's/256/2048/g' target/linux/x86/image/Makefile

echo '
CONFIG_ACPI=y
CONFIG_X86_ACPI_CPUFREQ=y
CONFIG_NR_CPUS=512
CONFIG_MMC=y
CONFIG_MMC_BLOCK=y
CONFIG_SDIO_UART=y
CONFIG_MMC_TEST=y
CONFIG_MMC_DEBUG=y
CONFIG_MMC_SDHCI=y
CONFIG_MMC_SDHCI_ACPI=y
CONFIG_MMC_SDHCI_PCI=y
CONFIG_DRM_I915=y
' >> ./target/linux/x86/config-6.1

sed -i "s/enabled '0'/enabled '1'/g" feeds/packages/utils/irqbalance/files/irqbalance.config
#八、设置Lan口IP为192.168.123.1

sed -i 's/192.168.1.1/192.168.123.1/g' package/base-files/files/bin/config_generate

#九、替换默认主题为 luci-theme-argon

sed -i 's/luci-theme-bootstrap/luci-theme-argon/' feeds/luci/collections/luci/Makefile

#十、修改活动连接数

sed -i 's/16384/65535/g' package/kernel/linux/files/sysctl-nf-conntrack.conf

#十一、修改x86启动等待时间

sed -i 's/default "5"/default "0"/g' config/Config-images.in

#十二、免登录进入ttyd
sed -i 's|/bin/login|/bin/login -f root|g' feeds/packages/utils/ttyd/files/ttyd.config

