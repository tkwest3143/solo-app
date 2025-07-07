.PHONY: build

build:
	flutter pub run build_runner build --delete-conflicting-outputs

pod-re:
	cd ios && rm Podfile.lock && rm -rf Pods && pod repo remove trunk && pod setup && pod install --repo-update && cd ..