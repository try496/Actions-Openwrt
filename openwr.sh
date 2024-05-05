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
merge_package main https://github.com/try496/openwrt-packages luci-app-cpufreq cpufreq luci-app-zerotier luci-app-msd_lite msd_lite luci-app-ddns-go ddns-go

./scripts/feeds update -a
./scripts/feeds install -a
make menuconfig