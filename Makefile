.PHONY: help clean build watch analyze test check check-unused check-unused-files check-unused-l10n check-unused-code

help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

clean: ## Clean project
	@echo "Cleaning the project..."
	@flutter clean
	@flutter pub get

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
	@dart run dart_code_metrics:metrics analyze lib $(OUTPUT)

test: ## Run all tests with coverage
	@flutter test --no-pub --coverage --test-randomize-ordering-seed=random $(OUTPUT)
	@lcov --remove coverage/lcov.info \
		'lib/main_*.dart' \
		'lib/l10n/**' \
		'lib/**/*.freezed.dart' \
		'lib/**/*.g.dart' \
		'lib/**/*.gr.dart' \
		'lib/**/*.config.dart' \
    	'lib/core/service_locator/**' \
    	'lib/core/debug/logger/**' \
    	'lib/core/config/**' \
		'lib/core/global_blocs.dart' \
	 -o coverage/lcov_filtered.info
	@(cd scripts && sh coverage_check.sh)

check: analyze test ## Run analyze and test

check-unused: check-unused-files check-unused-l10n check-unused-code ## Check unused files, l10n, code

check-unused-files: ## Check unused files
	@echo "Checking unused files..."
	@flutter pub run dart_code_metrics:metrics check-unused-files lib $(OUTPUT)

check-unused-l10n: ## Check unused l10n
	@echo "Checking unused l10n..."
	@flutter pub run dart_code_metrics:metrics check-unused-l10n lib $(OUTPUT)

check-unused-code: ## Check unused code
	@echo "Checking unused code..."
	@flutter pub run dart_code_metrics:metrics check-unused-code lib $(OUTPUT)
