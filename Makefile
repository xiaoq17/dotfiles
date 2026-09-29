.DEFAULT_GOAL := help
DOTFILES := $(shell pwd)

.PHONY: help all link brew skill nvm

help: ## Show this help
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| awk 'BEGIN{FS=":.*?## "}{printf "  \033[36m%-10s\033[0m %s\n", $$1, $$2}'

all: brew nvm skill link ## Full setup on a new machine

link: ## Symlink dotfiles into $$HOME
	./link.sh

nvm: ## Install nvm (Node Version Manager)
	./install_nvm.sh

skill: ## Install agent skills from Skillsfile
	./install_skills.sh

brew: ## Install tools from Brewfile (requires Homebrew)
	@command -v brew >/dev/null 2>&1 || { echo "Homebrew not found. Install it first (see README)."; exit 1; }
	brew bundle --file="$(DOTFILES)/Brewfile"
