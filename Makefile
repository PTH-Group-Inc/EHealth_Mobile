.PHONY: help dev build deploy clean get test generate

# Hiển thị help mặc định
help:
	@echo "Available commands:"
	@echo "  make dev           - Run app in debug mode"
	@echo "  make build         - Build release APK"
	@echo "  make clean         - Clean project"
	@echo "  make get           - Get dependencies"
	@echo "  make test          - Run tests"
	@echo "  make generate      - Run build_runner"

# Development
dev:
	@echo "Starting app dev..."
	flutter run --flavor dev -t lib/main_dev.dart

uat:
	@echo "Starting app uat..."
	flutter run --flavor uat -t lib/main_uat.dart

# Build
build:
	@echo "Building APK..."
	flutter build apk --release
	@echo "✓ APK built: build/app/outputs/flutter-apk/app-release.apk"

# Clean
clean:
	@echo "Cleaning project..."
	flutter clean
	@echo "✓ Project cleaned"

# Get dependencies
get:
	@echo "Getting dependencies..."
	flutter pub get
	@echo "✓ Dependencies updated"


# Generate code (json_serializable, freezed, etc.)
generate:
	@echo "Running code generation..."
	dart run build_runner build --delete-conflicting-outputs
	@echo "✓ Code generated"


# Analyze code
analyze:
	@echo "Analyzing code..."
	flutter analyze
	@echo "✓ Analysis complete"

# Setup project (for new team members)
setup: get
	@echo "Setting up project..."
	@echo "✓ Project ready! Run 'make dev' to start"