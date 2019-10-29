if ! command -v pod > /dev/null; then
	printf 'CocoaPods is not installed.\n'
	printf 'See https://github.com/CocoaPods/CocoaPods for install instructions.\n'
	exit 1
fi
pod repo update;
pod install;
cd ..;