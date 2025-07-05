.PHONY: build

build:
	flutter pub run build_runner build --delete-conflicting-outputs

pod-re:
	cd ios && pod install --clean-install && cd ..