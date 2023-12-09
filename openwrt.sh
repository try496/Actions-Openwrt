# aliyundrive-webdav
git clone https://github.com/messense/aliyundrive-webdav.git -b main package/apps/aliyundrive-webdav

# wechatpush
git clone https://github.com/tty228/luci-app-wechatpush.git package/apps/luci-app-wechatpush

# msd_lite
svn co https://github.com/kiddin9/openwrt-packages/trunk/luci-app-msd_lite package/apps/luci-app-msd_lite
svn co https://github.com/kiddin9/openwrt-packages/trunk/msd_lite package/apps/msd_lite

# cpufreq
svn co https://github.com/kiddin9/openwrt-packages/trunk/luci-app-cpufreq package/apps/luci-app-cpufreq

# zerotier
svn co https://github.com/kiddin9/openwrt-packages/trunk/luci-app-zerotier package/apps/luci-app-zerotier

# openclash
# git clone --single-branch --depth 1 -b dev https://github.com/vernesong/OpenClash.git package/apps/luci-app-openclash

# passwall
# git clone https://github.com/xiaorouji/openwrt-passwall-packages.git -b main package/passwall_package
# git clone https://github.com/xiaorouji/openwrt-passwall.git -b main package/passwall
# cp -rf package/passwall_package/* package/passwall
# rm -rf package/passwall_package

# 时间服务器
sed -i 's/0.openwrt.pool.ntp.org/ntp1.aliyun.com/g' package/base-files/files/bin/config_generate
sed -i 's/1.openwrt.pool.ntp.org/ntp2.aliyun.com/g' package/base-files/files/bin/config_generate
sed -i 's/2.openwrt.pool.ntp.org/time1.cloud.tencent.com/g' package/base-files/files/bin/config_generate
sed -i 's/3.openwrt.pool.ntp.org/time2.cloud.tencent.com/g' package/base-files/files/bin/config_generate

# 修改固件版本信息
sed -i "s/DISTRIB_DESCRIPTION=.*/DISTRIB_DESCRIPTION='$(date +"%Y-%m-%d")-Build'/g" package/base-files/files/etc/openwrt_release

# TTYD自动登录
sed -i 's|/bin/login|/bin/login -f root|g' feeds/packages/utils/ttyd/files/ttyd.config

# 修改密码
sed -i '/root/c\root:$1$3INQuMmE$eyGe2r1bt96nb2Oqm.oaQ1:19563:0:99999:7:::' package/base-files/files/etc/shadow

# 修改IP
sed -i 's/192.168.1.1/192.168.2.1/g' package/base-files/files/bin/config_generate

# 修改IPv6 端口号
sed -i 's/\[::\]:80/\[::\]:8060/g' package/network/services/uhttpd/files/uhttpd.config

# 修改时区
sed -i "s/timezone='.*'/timezone='CST-8'/g" ./package/base-files/files/bin/config_generate
sed -i "/timezone='.*'/a\\\t\t\set system.@system[-1].zonename='Asia/Shanghai'" ./package/base-files/files/bin/config_generate

#4.编译的固件文件名添加日期
sed -i 's/IMG_PREFIX:=$(VERSION_DIST_SANITIZED)/IMG_PREFIX:=$(shell TZ=CST-8 date "+%Y%m%d")-$(VERSION_DIST_SANITIZED)/g' include/image.mk

# argon
git clone https://github.com/jerrykuku/luci-theme-argon.git package/apps/luci-theme-argon
# 移除底部文字
pushd  package/apps/luci-theme-argon/luasrc/view/themes/argon
sed -i '/<a class=\"luci-link\" href=\"https:\/\/github.com\/openwrt\/luci\"/d' footer.htm
sed -i '/<a href=\"https:\/\/github.com\/jerrykuku\/luci-theme-argon\"/d' footer.htm
sed -i '/<%= ver.distversion %>/d' footer.htm
# 移除 footer_login.htm 底部文字
sed -i '/<a class=\"luci-link\" href=\"https:\/\/github.com\/openwrt\/luci\"/d' footer_login.htm
sed -i '/<a href=\"https:\/\/github.com\/jerrykuku\/luci-theme-argon\"/d' footer_login.htm
sed -i '/<%= ver.distversion %>/d' footer_login.htm
popd
# bootstrap底部文字
pushd  feeds/luci/themes/luci-theme-bootstrap/ucode/template/themes/bootstrap
sed -i -e '/<span>/,/<\/span>/d' footer.ut
popd

# 修改菜单
sed -i 's|admin/services|admin/|g' feeds/luci/applications/luci-app-nlbwmon/root/usr/share/luci/menu.d/*.json
sed -i 's|admin/services|admin/system|g' feeds/luci/applications/luci-app-ttyd/root/usr/share/luci/menu.d/luci-app-ttyd.json
sed -i 's|admin/status|admin/vpn|g' feeds/luci/protocols/luci-proto-wireguard/root/usr/share/luci/menu.d/luci-proto-wireguard.json

# 修改插件名字
sed -i 's/"阿里云盘 WebDAV"/"阿里云盘"/g' `grep "阿里云盘 WebDAV" -rl ./`
sed -i 's/"CPU 性能优化调节"/"性能优化"/g' $(grep "CPU 性能优化调节设置" -rl ./)
sed -i 's/"动态 DNS(DDNS)"/"动态 DNS"/g' $(grep "动态 DNS(DDNS)" -rl ./)
