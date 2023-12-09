# 删除软件包
rm -rf feeds/luci/themes/luci-theme-argon
rm -rf feeds/luci/applications/luci-app-passwall
rm -rf feeds/luci/applications/luci-app-msd_lite
rm -rf feeds/luci/applications/luci-app-wechatpush
rm -rf feeds/luci/applications/luci-app-openclash


# wechatpush
git clone https://github.com/tty228/luci-app-wechatpush.git package/apps/luci-app-wechatpush

# aliyundrive-webdav
git clone https://github.com/messense/aliyundrive-webdav.git -b main package/aliyundrive-webdav

# msd_lite
git clone --depth=1 https://github.com/ximiTech/luci-app-msd_lite package/luci-app-msd_lite
git clone --depth=1 https://github.com/ximiTech/msd_lite package/msd_lite

# openclash
# git clone --single-branch --depth 1 -b dev https://github.com/vernesong/OpenClash.git package/apps/luci-app-openclash

# passwall
# git clone https://github.com/xiaorouji/openwrt-passwall.git -b packages package/passwall_package
# git clone https://github.com/xiaorouji/openwrt-passwall.git -b luci package/passwall
# cp -rf package/passwall_package/* package/passwall
# rm -rf package/passwall_package

# TTYD自动登录
sed -i 's|/bin/login|/bin/login -f root|g' feeds/packages/utils/ttyd/files/ttyd.config

# 修改密码
sed -i '/root/c\root:$1$3INQuMmE$eyGe2r1bt96nb2Oqm.oaQ1:19563:0:99999:7:::' package/base-files/files/etc/shadow

# 修改IP
sed -i 's/192.168.1.1/192.168.2.1/g' package/base-files/files/bin/config_generate

# 修改版本为编译日期
date_version=$(date +"%Y年%m月%d"日)
orig_version=$(cat "package/extra/default-settings/files/99-default-settings" | grep DISTRIB_REVISION= | awk -F "'" '{print $2}')
sed -i "s/${orig_version}/-SNAPSHOT/g" package/extra/default-settings/files/99-default-settings

org_version=$(cat "package/extra/default-settings/files/99-default-settings" | grep DISTRIB_DESCRIPTION= | awk -F "'" '{print $2}')
sed -i "s/${org_version}/${date_version}/g" package/extra/default-settings/files/99-default-settings 

# 修改本地时间格式
sed -i 's/os.date()/os.date("%Y-%m-%d %H:%M:%S")/g' package/extra/autocore/files/*/index.htm

# 设置 argon 为默认主题
sed -i 's/luci-theme-bootstrap/luci-theme-argon/g' feeds/luci/collections/luci/Makefile

# Argon 主题
git clone -b 18.06 https://github.com/jerrykuku/luci-theme-argon.git package/new/luci-theme-argon
# 移除Argon底部文字
pushd package/new/luci-theme-argon/luasrc/view/themes/argon
sed -i '/<a class=\"luci-link\" href=\"https:\/\/github.com\/openwrt\/luci\"/d' footer.htm
sed -i '/<a href=\"https:\/\/github.com\/jerrykuku\/luci-theme-argon\"/d' footer.htm
sed -i '/<%= ver.distversion %>/d' footer.htm  
sed -i '/<%= ver.luciversion %>/d' footer.htm
popd
