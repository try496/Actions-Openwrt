# 拉取指定软件包
function merge_package(){
    trap 'rm -rf "$tmpdir"' EXIT
    branch="$1" curl="$2" && shift 2
    rootdir="$PWD"
    localdir=package/apps
    [ -d "$localdir" ] || mkdir -p "$localdir"
    tmpdir="$(mktemp -d)" || exit 1
    git clone -b "$branch" --depth 1 --filter=blob:none --sparse "$curl" "$tmpdir"
    cd "$tmpdir"
    git sparse-checkout init --cone
    git sparse-checkout set "$@"
    mv -f "$@" "$rootdir"/"$localdir" && cd "$rootdir"
}
merge_package main https://github.com/try496/openwrt-packages luci-app-cpufreq cpufreq luci-app-msd_lite msd_lite luci-app-ddns-go ddns-go

# 微信推送
git clone https://github.com/tty228/luci-app-wechatpush.git package/apps/luci-app-wechatpush

# 时间服务器
sed -i 's/0.openwrt.pool.ntp.org/ntp.aliyun.com/g' package/base-files/files/bin/config_generate
sed -i 's/1.openwrt.pool.ntp.org/ntp.tencent.com/g' package/base-files/files/bin/config_generate
sed -i 's/2.openwrt.pool.ntp.org/cn.ntp.org.cn/g' package/base-files/files/bin/config_generate
sed -i 's/3.openwrt.pool.ntp.org/ntp.ntsc.ac.cn/g' package/base-files/files/bin/config_generate

# 修改固件版本信息
sed -i "s/OPENWRT_RELEASE=.*/OPENWRT_RELEASE='OpenWrt-24.10 $(date +"%Y-%m-%d")-Build'/g" package/base-files/files/usr/lib/os-release

# 编译的固件文件名添加日期
sed -i 's/IMG_PREFIX:=$(VERSION_DIST_SANITIZED)/IMG_PREFIX:=$(shell TZ=CST-8 date "+%Y%m%d")-$(VERSION_DIST_SANITIZED)/g' include/image.mk

# 修改密码
sed -i '/root/c\root:$1$3INQuMmE$eyGe2r1bt96nb2Oqm.oaQ1:19563:0:99999:7:::' package/base-files/files/etc/shadow

# 修改 IP
sed -i 's/192.168.1.1/192.168.2.1/g' package/base-files/files/bin/config_generate

# 修改 IPv6 端口号
sed -i 's/\[::\]:80/\[::\]:8060/g' package/network/services/uhttpd/files/uhttpd.config

# 调整 CPU 频率
sed -i '27s/0x4/0xf/' target/linux/qualcommax/patches-6.6/0085-v6.15-arm64-dts-qcom-ipq6018-add-1.2GHz-CPU-Frequency.patch

# 修改诊断网址
rm -rf feeds/luci/modules/luci-mod-network/root/etc/uci-defaults/50_luci-mod-admin-full
sed -i "s/openwrt.org/cloud.tencent.com/g" feeds/luci/modules/luci-mod-network/htdocs/luci-static/resources/view/network/diagnostics.js

# 配置阿里软件源
# sed -i 's/downloads.openwrt.org/mirrors.aliyun.com\/openwrt/g' include/version.mk

# 修改菜单
sed -i 's|admin/services|admin/|g' feeds/luci/applications/luci-app-nlbwmon/root/usr/share/luci/menu.d/*.json
sed -i 's|admin/services|admin/system|g' feeds/luci/applications/luci-app-ttyd/root/usr/share/luci/menu.d/luci-app-ttyd.json
sed -i 's|admin/status|admin/vpn|g' feeds/luci/protocols/luci-proto-wireguard/root/usr/share/luci/menu.d/luci-proto-wireguard.json

# 修改插件名字
sed -i 's/"性能优化"/"性能优化"/g' $(grep "CPU 性能优化调节设置" -rl ./)

# bootstrap底部文字
pushd  feeds/luci/themes/luci-theme-bootstrap/ucode/template/themes/bootstrap
sed -i -e '/<span>/,/<\/span>/d' footer.ut
popd

# argon
# git clone https://github.com/jerrykuku/luci-theme-argon.git package/apps/luci-theme-argon
# 移除底部文字
# pushd  package/apps/luci-theme-argon/luasrc/view/themes/argon
# sed -i '/<a class=\"luci-link\" href=\"https:\/\/github.com\/openwrt\/luci\"/d' footer.htm
# sed -i '/<a href=\"https:\/\/github.com\/jerrykuku\/luci-theme-argon\"/d' footer.htm
# sed -i '/<%= ver.distversion %>/d' footer.htm
# 移除 footer_login.htm 底部文字
# sed -i '/<a class=\"luci-link\" href=\"https:\/\/github.com\/openwrt\/luci\"/d' footer_login.htm
# sed -i '/<a href=\"https:\/\/github.com\/jerrykuku\/luci-theme-argon\"/d' footer_login.htm
# sed -i '/<%= ver.distversion %>/d' footer_login.htm
# popd

# openclash
# git clone --single-branch --depth 1 -b dev https://github.com/vernesong/OpenClash.git package/apps/luci-app-openclash

# passwall
# git clone https://github.com/xiaorouji/openwrt-passwall-packages.git -b main package/passwall_package
# git clone https://github.com/xiaorouji/openwrt-passwall.git -b main package/passwall
# cp -rf package/passwall_package/* package/passwall
# rm -rf package/passwall_package

# 修改日志格式
# pushd feeds/packages/admin/syslog-ng/files
# sed -zi 's/destination messages {\n[[:space:]]*file("\/var\/log\/messages");\n};/destination messages {\n#       file("\/var\/log\/messages");\n        file("\/var\/log\/messages" suppress(5) template("\${R_YEAR}-\${R_MONTH}-\${R_DAY} \${R_HOUR}:\${R_MIN}:\${R_SEC} \${PRIORITY} \${PROGRAM}[\${PID}]: \${MSGONLY}\\n"));\n};/' syslog-ng.conf
# popd

# 修改 nginx ipv6 端口号
# pushd feeds/packages/net/nginx-util/files
# sed -i 's/\[::\]:80/\[::\]:8060/g' nginx.config
# popd