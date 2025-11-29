.PHONY: help clean build watch analyze test check check-unused check-unused-files check-unused-l10n check-unused-code

help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

clean: ## Clean project
	@echo "Cleaning the project..."
	@flutter clean
	@flutter pub get

intl: ## Trigger intl code generation
	@echo "Generating intl code..."
	@dart run intl_utils:generate

build: ## Trigger one time code generation
	@echo "Generating code..."
	@dart run intl_utils:generate
	@dart run build_runner build --delete-conflicting-outputs

watch: ## Watch files and trigger code generation on change
	@echo "Generating code on the fly..."
	@dart run build_runner watch --delete-conflicting-outputs

analyze: ## Analyze the code
	@find lib/* -name "*.dart" ! -name "*.freezed.dart" ! -name "*.g.dart" ! -name "*.gr.dart" ! -name "*.config.dart" ! -path '*/generated/*' | xargs dart --disable-analytics format --line-length 120 $(PARAMS)
	@flutter analyze --no-pub

test: ## Run all tests with coverage
	@flutter test --no-pub --coverage --test-randomize-ordering-seed=random $(OUTPUT)
	@lcov --remove coverage/lcov.info \
	 -o coverage/lcov_filtered.info
	@genhtml coverage/lcov_filtered.info -o coverage/html
	@(cd scripts && sh coverage_check.sh)

flutterfire-prod:
	@echo "Running flutterfire prod..."
	@flutterfire configure \
	--project=spending-pal \
	--out=lib/src/config/config/firebase_options_prod.dart \
	--ios-bundle-id=com.spendingpal \
	--ios-out=ios/flavors/prod/GoogleService-Info.plist \
	--android-package-name=com.spendingpal \
	--android-out=android/app/src/prod/google-services.json

flutterfire-dev:
	@echo "Running flutterfire dev..."
	@flutterfire configure \
	--project=spending-pal-dev \
	--out=lib/src/config/config/firebase_options_dev.dart \
	--ios-bundle-id=com.spendingpal.dev \
	--ios-out=ios/flavors/dev/GoogleService-Info.plist \
	--android-package-name=com.spendingpal.dev \
	--android-out=android/app/src/dev/google-services.json

launcher_icons:
	@echo "Generating launcher icons..."
	@dart run flutter_launcher_icons