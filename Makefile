.PHONY: help install clean verify redeploy list-themes package publish

# Configuration
CURSOR_EXT_DIR := $(HOME)/.cursor/extensions
THEMES_DIR := $(shell pwd)

# Find all theme directories (directories containing package.json)
THEMES := $(shell find . -maxdepth 2 -name "package.json" -not -path "./node_modules/*" -not -path "./.git/*" | sed 's|/package.json||' | sed 's|^\./||' | grep -v "^$$")

help:
	@echo "VS Code Themes - Makefile Commands"
	@echo ""
	@echo "make list-themes  - List all available themes"
	@echo "make install      - Install all themes to Cursor extensions"
	@echo "make clean        - Remove all themes from Cursor extensions"
	@echo "make verify       - Verify all theme installations"
	@echo "make package      - Package all themes as .vsix files"
	@echo "make help         - Show this help message"
	@echo ""
	@echo "Theme-specific commands:"
	@echo "make install THEME=<theme-name>  - Install specific theme"
	@echo "make clean THEME=<theme-name>    - Clean specific theme"
	@echo "make verify THEME=<theme-name>   - Verify specific theme"
	@echo "make package THEME=<theme-name>  - Package specific theme"
	@echo ""

list-themes:
	@echo "Available themes:"
	@for theme in $(THEMES); do \
		echo "  - $$theme"; \
	done

install: $(if $(THEME),install-theme,install-all)

install-all:
	@echo "Installing all themes to Cursor..."
	@for theme in $(THEMES); do \
		echo ""; \
		echo "Installing $$theme..."; \
		$(MAKE) -C "$$theme" install || echo "⚠️  Failed to install $$theme"; \
	done
	@echo ""
	@echo "✅ Installation complete for all themes"
	@echo ""
	@echo "NEXT STEPS:"
	@echo "1. Quit Cursor completely (Cmd+Q)"
	@echo "2. Wait 5 seconds"
	@echo "3. Reopen Cursor"
	@echo "4. Check Extensions: Cmd+Shift+X, search '@installed'"

install-theme:
	@if [ -z "$(THEME)" ]; then \
		echo "❌ Error: THEME not specified"; \
		echo "Usage: make install THEME=<theme-name>"; \
		echo "Available themes: $(THEMES)"; \
		exit 1; \
	fi
	@if [ ! -d "$(THEME)" ]; then \
		echo "❌ Error: Theme '$(THEME)' not found"; \
		echo "Available themes: $(THEMES)"; \
		exit 1; \
	fi
	@echo "Installing $(THEME) to Cursor..."
	@$(MAKE) -C "$(THEME)" install

clean: $(if $(THEME),clean-theme,clean-all)

clean-all:
	@echo "Cleaning all themes from Cursor..."
	@for theme in $(THEMES); do \
		echo "Cleaning $$theme..."; \
		$(MAKE) -C "$$theme" clean 2>/dev/null || true; \
	done
	@echo "✅ Clean complete"

clean-theme:
	@if [ -z "$(THEME)" ]; then \
		echo "❌ Error: THEME not specified"; \
		echo "Usage: make clean THEME=<theme-name>"; \
		echo "Available themes: $(THEMES)"; \
		exit 1; \
	fi
	@if [ ! -d "$(THEME)" ]; then \
		echo "❌ Error: Theme '$(THEME)' not found"; \
		echo "Available themes: $(THEMES)"; \
		exit 1; \
	fi
	@echo "Cleaning $(THEME)..."
	@$(MAKE) -C "$(THEME)" clean

verify: $(if $(THEME),verify-theme,verify-all)

verify-all:
	@echo "Verifying all theme installations..."
	@for theme in $(THEMES); do \
		echo ""; \
		echo "Verifying $$theme..."; \
		$(MAKE) -C "$$theme" verify 2>/dev/null || echo "⚠️  $$theme verification failed"; \
	done

verify-theme:
	@if [ -z "$(THEME)" ]; then \
		echo "❌ Error: THEME not specified"; \
		echo "Usage: make verify THEME=<theme-name>"; \
		echo "Available themes: $(THEMES)"; \
		exit 1; \
	fi
	@if [ ! -d "$(THEME)" ]; then \
		echo "❌ Error: Theme '$(THEME)' not found"; \
		echo "Available themes: $(THEMES)"; \
		exit 1; \
	fi
	@$(MAKE) -C "$(THEME)" verify

package: $(if $(THEME),package-theme,package-all)

package-all:
	@echo "Packaging all themes..."
	@for theme in $(THEMES); do \
		echo ""; \
		echo "Packaging $$theme..."; \
		cd "$$theme" && vsce package && cd .. || echo "⚠️  Failed to package $$theme"; \
	done
	@echo ""
	@echo "✅ Packaging complete"

package-theme:
	@if [ -z "$(THEME)" ]; then \
		echo "❌ Error: THEME not specified"; \
		echo "Usage: make package THEME=<theme-name>"; \
		echo "Available themes: $(THEMES)"; \
		exit 1; \
	fi
	@if [ ! -d "$(THEME)" ]; then \
		echo "❌ Error: Theme '$(THEME)' not found"; \
		echo "Available themes: $(THEMES)"; \
		exit 1; \
	fi
	@echo "Packaging $(THEME)..."
	@cd "$(THEME)" && vsce package

redeploy: clean install
	@echo ""
	@echo "✅ All themes redeployed successfully!"

