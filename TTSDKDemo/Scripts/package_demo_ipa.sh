#!/bin/bash

set -e

SCRIPTS_DIR=$(cd $(dirname ${BASH_SOURCE[0]}); pwd)

PACKAGE_INFO_DIR=$SCRIPTS_DIR/package_info

Project_Name='TTSDKDemo'
demoProjPath=${SCRIPTS_DIR}/..
productPath=${demoProjPath}/../TTSDKDemoBuild
demoArchivePath="${productPath}/TTSDKDemo.xcarchive"
ExportOptionsPlist="${PACKAGE_INFO_DIR}/ExportOptionsPlist/ExportOptions.plist"
ProvisionPath="${PACKAGE_INFO_DIR}/provision/TTSDKDemoInHousedist.mobileprovision"
p12Dir="${PACKAGE_INFO_DIR}/provision/NetWorkInHousePriv.p12"
loginKeychainPath='~/Library/Keychains/login.keychain'
tempIpaName="Pandora.ipa"

#打包前注入 provision及证书
injectP12File() {

    echo "start inject mobileprovision"
        UUID__=`grep UUID -A1 -a "${ProvisionPath}" | grep -io '[-A-F0-9]\{36\}'`
        echo UUID__ is ${UUID__}
        eval cp "${ProvisionPath}" "~/Library/MobileDevice/Provisioning\ Profiles/${UUID__}.mobileprovision"
    echo "stop inject mobileprovision"

    echo "start inject p12"
    #寻找打包环境的登陆钥匙串路径， 有两种情况可能带后缀-db 这里做一个兜底兼容
    if [ ! -d "#{loginKeychainPath}" ]
    then
    loginKeychainPath="~/Library/Keychains/login.keychain-db"
    fi

    echo loginKeychainPath is ${loginKeychainPath}
    #解锁编译环境 登录keychain
    eval security unlock-keychain -p "bytedance1234" ${loginKeychainPath}
    #注入p12文件
    eval security import ${p12Dir}  -k ${loginKeychainPath} -P bytedance
    echo "stop inject p12"
}

# 打包 导出ipa
packageIPA() {
    cd ${demoProjPath}
    echo "demo pod install start"
    echo "bundle install start"

    bundle config set --local path `pwd`
    bundle install

    echo "bundle install stop"

    bundle exec pod install --repo-update

    echo "demo pod install stop"

    if [ -d "${productPath}" ]
    then
        rm -r ${productPath}
    fi

    echo "demo archive start"
    xcodebuild archive  -archivePath ${demoArchivePath}  -workspace ${demoProjPath}/${Project_Name}.xcworkspace -scheme ${Project_Name} -configuration Release 
    echo "demo archive stop"

    echo "demo ipa export start"
    xcodebuild -exportArchive -archivePath ${demoArchivePath}  -exportOptionsPlist $ExportOptionsPlist -exportPath "${productPath}"
    echo "demo ipa export stop"

    sed -i '' -E "s@(iOSPackageBackUp\/).*@\1${TASK_ID}\/TTSDKDemo.ipa</string>@" ${PACKAGE_INFO_DIR}/TTSDK.plist

    mv ${demoArchivePath}/dSYMs/Pandora.app.dSYM ${productPath}/Pandora.app.dSYM

    cd ${productPath}
    zip -r Pandora.app.dSYM.zip Pandora.app.dSYM 

    # 修正ipa 名称
    if [ ! -f "TTSDKDemo.ipa" ]
    then
        if [ -f "Pandora.ipa" ]
        then
            mv Pandora.ipa TTSDKDemo.ipa
        else
            echo "ipa product not founded"
        fi
    fi
    echo "end package demo ipa"
    cd -
}

if [ ! -d "${PACKAGE_INFO_DIR}" ]; then
    echo "packaging interrupted with package related info does not exist..."
    exit 1
fi

echo "start exec package_demo_ipa.sh"
injectP12File
packageIPA
echo "package demo did finish..."