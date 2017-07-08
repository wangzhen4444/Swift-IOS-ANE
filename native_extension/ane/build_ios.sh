#!/bin/sh

#Get the path to the script and trim to get the directory.
echo "Setting path to current directory to:"
pathtome=$0
pathtome="${pathtome%/*}"

echo $pathtome

PROJECTNAME=SwiftIOSANE
fwSuffix="_FW"
libSuffix="_LIB"

AIR_SDK="/Users/User/sdks/AIR/AIRSDK_26_IOS11"
#AIR_SDK="/Users/User/sdks/AIR/AIRSDK_26"
echo $AIR_SDK

#Setup the directory.
echo "Making directories."

if [ ! -d "$pathtome/platforms" ]; then
mkdir "$pathtome/platforms"
fi
if [ ! -d "$pathtome/platforms/ios" ]; then
mkdir "$pathtome/platforms/ios"
fi
if [ ! -d "$pathtome/platforms/ios/simulator" ]; then
mkdir "$pathtome/platforms/ios/simulator"
fi
if [ ! -d "$pathtome/platforms/ios/simulator/Frameworks" ]; then
mkdir "$pathtome/platforms/ios/simulator/Frameworks"
fi
if [ ! -d "$pathtome/platforms/ios/device" ]; then
mkdir "$pathtome/platforms/ios/device"
fi
if [ ! -d "$pathtome/platforms/ios/universal" ]; then
mkdir "$pathtome/platforms/ios/universal"
fi
if [ ! -d "$pathtome/platforms/ios/device/Frameworks" ]; then
mkdir "$pathtome/platforms/ios/device/Frameworks"
fi
if [ ! -d "$pathtome/platforms/ios/default" ]; then
mkdir "$pathtome/platforms/ios/default"
fi


#Copy SWC into place.
echo "Copying SWC into place."
cp "$pathtome/../bin/$PROJECTNAME.swc" "$pathtome/"

#Extract contents of SWC.
echo "Extracting files form SWC."
unzip "$pathtome/$PROJECTNAME.swc" "library.swf" -d "$pathtome"

#Copy library.swf to folders.
echo "Copying library.swf into place."
cp "$pathtome/library.swf" "$pathtome/platforms/ios/simulator"
cp "$pathtome/library.swf" "$pathtome/platforms/ios/device"
cp "$pathtome/library.swf" "$pathtome/platforms/ios/universal"
cp "$pathtome/library.swf" "$pathtome/platforms/ios/default"

#Copy native libraries into place.
echo "Copying native libraries into place."
cp -R -L "$pathtome/../../native_library/ios/$PROJECTNAME/Build/Products/Release-iphonesimulator/lib$PROJECTNAME$libSuffix.a" "$pathtome/platforms/ios/simulator/lib$PROJECTNAME.a"
cp -R -L "$pathtome/../../native_library/ios/$PROJECTNAME/Build/Products/Release-iphoneos/lib$PROJECTNAME$libSuffix.a" "$pathtome/platforms/ios/device/lib$PROJECTNAME.a"

cp -R -L "$pathtome/../../native_library/ios/$PROJECTNAME/FreSwift/FreSwift-Swift.h" "$pathtome/../../native_library/ios/$PROJECTNAME/Build/Products/Release-iphonesimulator/FreSwift.framework/Headers/FreSwift-Swift.h"
cp -R -L "$pathtome/../../native_library/ios/$PROJECTNAME/FreSwift/FreSwift-Swift.h" "$pathtome/../../native_library/ios/$PROJECTNAME/Build/Products/Release-iphoneos/FreSwift.framework/Headers/FreSwift-Swift.h"
cp -R -L "$pathtome/../../native_library/ios/$PROJECTNAME/FreSwift/FreSwift-Swift.h" "$pathtome/../../native_library/ios/$PROJECTNAME/Build/Products/Debug-iphonesimulator/FreSwift.framework/Headers/FreSwift-Swift.h"
cp -R -L "$pathtome/../../native_library/ios/$PROJECTNAME/FreSwift/FreSwift-Swift.h" "$pathtome/../../native_library/ios/$PROJECTNAME/Build/Products/Debug-iphoneos/FreSwift.framework/Headers/FreSwift-Swift.h"

cp -R -L "$pathtome/../../native_library/ios/$PROJECTNAME/Build/Products/Release-iphonesimulator/FreSwift.framework" "$pathtome/platforms/ios/simulator/Frameworks"
cp -R -L "$pathtome/../../native_library/ios/$PROJECTNAME/Build/Products/Release-iphoneos/FreSwift.framework" "$pathtome/platforms/ios/device/Frameworks"
#cp -R -L "$pathtome/../../native_library/ios/$PROJECTNAME/Build/Products/Release-iphoneos/FreSwift.framework" "$pathtome/platforms/ios/universal/Frameworks"

#universal

cp -R -L "$pathtome/../../native_library/ios/$PROJECTNAME/Build/Products/Release-iphonesimulator/$PROJECTNAME$fwSuffix.framework" "$pathtome/platforms/ios/simulator/Frameworks"
cp -R -L "$pathtome/../../native_library/ios/$PROJECTNAME/Build/Products/Release-iphoneos/$PROJECTNAME$fwSuffix.framework" "$pathtome/platforms/ios/device/Frameworks"
#cp -R -L "$pathtome/../../native_library/ios/$PROJECTNAME/Build/Products/Release-iphoneos/$PROJECTNAME$fwSuffix.framework" "$pathtome/platforms/ios/universal/Frameworks"

#lipo -create -output "$pathtome/platforms/ios/universal/lib$PROJECTNAME.a"  "$pathtome/platforms/ios/device/lib$PROJECTNAME.a" "$pathtome/platforms/ios/simulator/lib$PROJECTNAME.a"
#lipo -create -output "$pathtome/platforms/ios/universal/tmp"  "$pathtome/platforms/ios/device/Frameworks/$PROJECTNAME$fwSuffix.framework/$PROJECTNAME$fwSuffix" "$pathtome/platforms/ios/simulator/Frameworks/$PROJECTNAME$fwSuffix.framework/$PROJECTNAME$fwSuffix"


#Run the build command.
echo "Building Release."
"$AIR_SDK"/bin/adt -package \
-target ane "$pathtome/$PROJECTNAME-ios.ane" "$pathtome/extension_ios.xml" \
-swc "$pathtome/$PROJECTNAME.swc" \
-platform iPhone-ARM  -C "$pathtome/platforms/ios/device" "library.swf" "lib$PROJECTNAME.a" \
-platformoptions "$pathtome/platforms/ios/platform.xml" \
-C $pathtome/platforms/ios/device/Frameworks/ . 

rm -r "$pathtome/platforms/ios/default"
rm "$pathtome/$PROJECTNAME.swc"
rm "$pathtome/library.swf"
