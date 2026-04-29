#sync rom
repo init --depth=1 --no-repo-verify -u https://github.com/AslenoLineageStuff/android.git -b lineage-17.1 --git-lfs -g default,-mips,-darwin,-notdefault
git clone https://github.com/aslenofarid/local_manifest --depth 1 -b lineage-17.1 .repo/local_manifests
repo sync -c --no-clone-bundle --no-tags --optimized-fetch --prune --force-sync -j8

# build roms
source $CIRRUS_WORKING_DIR/script/config
timeStart

source build/envsetup.sh
export TZ=Asia/Jakarta
export KBUILD_BUILD_USER=aslenofarid
export KBUILD_BUILD_HOST=android-build
export BUILD_USERNAME=aslenofarid
export BUILD_HOSTNAME=android-build
lunch lineage_X00TD-user
mkfifo reading
tee "${BUILDLOG}" < reading &
build_message "Building Started"
progress &
mka bacon -j8  > reading

retVal=$?
timeEnd
statusBuild
