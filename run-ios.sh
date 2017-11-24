#!/bin/sh

[ `uname -s` != "Darwin" ] && return

function tab () {
    local cmd=""
    local cdto="$PWD"
    local args="$@"

    if [ -d "$1" ]; then
        cdto=`cd "$1"; pwd`
        args="${@:2}"
    fi

    if [ -n "$args" ]; then
        cmd="; $args"
    fi

    iterm_exists=`osascript -e "id of application \"iterm2\""`
    if [ ! -z iterm_exists ]; then
    osascript &>/dev/null <<EOF
        tell application "iTerm2"
            tell current window
                set newTab to (create tab with default profile)
                tell newTab
                    tell current session
                        write text "cd \"$cdto\"$cmd"
                    end tell
                end tell
            end tell
        end tell
EOF
    else
    osascript &>/dev/null <<END
tell app "Terminal" to do script "cd \"$cdto\"$cmd"
END
    fi
}


# Install deps, prepare for genymotion and figwheel
cd ios && pod install && cd ..
lein deps && npm install && ./re-natal use-ios-device real && ./re-natal use-figwheel && lein re-frisk use-re-natal && ./re-natal enable-source-maps
mvn -f modules/react-native-status/ios/RCTStatus dependency:unpack

# open figwheel in new tab
tab "BUILD_IDS=ios lein repl"

# open react-native package in new tab
tab "react-native start"

if [ ! -z $1 ]
then
 device_type="$1"
fi

udid="77B60FF6-C966-44E8-BF1F-3BF0914D3280"
echo =========================
echo DEVICE_TYPE=$device_type
echo =========================
# open ios/StatusIm.xcworkspace
if [ "$device_type" = "simulator" ]
then
  xcrun instruments -w "${udid}"
  xcodebuild -workspace ios/StatusIm.xcworkspace -scheme StatusIm -configuration Debug -destination "platform=iOS Simulator,id=${udid}" -derivedDataPath 'build'
  xcrun simctl install booted build/Build/Products/Debug-iphonesimulator/StatusIm.app
  sleep 70
  xcrun simctl launch booted im.status.ethereum
  tab "tail -f '/Users/vkjr/Library/Logs/CoreSimulator/${udid}/system.log'"
fi

real_device_udid="your real device udid"
if [ "$device_type" = "real" ]
then
  xcodebuild -workspace ios/StatusIm.xcworkspace -scheme StatusIm -configuration Debug -destination "platform=iOS,id=${real_device_udid}" -derivedDataPath 'build'
  sleep 60
  ios-deploy -i "${real_device_udid}" --justlaunch  --bundle build/Build/Products/Debug-iphoneos/StatusIm.app
fi

if [ ! -z $1 ]
then
    xcrun instruments -w "${udid}"
fi
