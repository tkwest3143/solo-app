.PHONY: build help

build:
	flutter pub run build_runner build --delete-conflicting-outputs

pod-re:
	cd ios && rm Podfile.lock && rm -rf Pods && pod repo remove trunk && pod setup && pod install --repo-update && cd ..

gradle-re:
	flutter pub get
	cd android && ./gradlew clean && cd ..

dg-build:
	flutter build appbundle --debug && flutter build ipa --debug

# DeployGate Upload Commands
dg-upload-android:
	@echo "Building Android APP Bundle for DeployGate..."
	flutter build appbundle --debug
	@echo "Uploading to DeployGate..."
	dg deploy build/app/outputs/bundle/debug/app-debug.aab

dg-upload-ios:
	@echo "Building iOS IPA for DeployGate..."
	flutter build ipa --debug
	@echo "Uploading to DeployGate..."
	dg deploy build/ios/ipa/*.ipa

# Upload both platforms
dg-upload-all: dg-upload-android dg-upload-ios

# Build and upload with message
dg-upload-android-msg:
	@echo "Building Android APP Bundle for DeployGate..."
	flutter build appbundle --debug
	@echo "Enter deployment message:"
	@read message; \
	dg deploy build/app/outputs/bundle/debug/app-debug.aab -m "$$message"

dg-upload-ios-msg:
	@echo "Building iOS IPA for DeployGate..."
	flutter build ipa --debug --export-options-plist=ios/ExportOptions.plist
	@echo "Enter deployment message:"
	@read message; \
	dg deploy build/ios/ipa/*.ipa -m "$$message"

# Help command
help:
	@echo "Available commands:"
	@echo "  build              - Run build_runner build"
	@echo "  pod-re             - Reset and reinstall iOS pods"
	@echo "  gradle-re          - Clean and reset Android gradle"
	@echo "  dg-build           - Build debug versions for both platforms"
	@echo "  dg-upload-android  - Build and upload Android App Bundle to DeployGate"
	@echo "  dg-upload-ios      - Build and upload iOS IPA to DeployGate"
	@echo "  dg-upload-all      - Upload both Android and iOS to DeployGate"
	@echo "  dg-upload-android-msg - Upload Android App Bundle with custom message"
	@echo "  dg-upload-ios-msg  - Upload iOS with custom message"
	@echo "  help               - Show this help message"

release-build:
	flutter build appbundle --release && flutter build ipa --release