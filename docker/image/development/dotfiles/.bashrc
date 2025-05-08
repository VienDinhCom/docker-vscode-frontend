#!/bin/bash

# Install VSCode extensions
if [ "$(pwd)" = $PROJECT_DIR ]; then
  if [ -f ".vscode/extensions.json" ]; then
    echo "Installing VSCode extensions..."

    extensions=$(grep -o '"[^"]*"' .vscode/extensions.json | grep -v "recommendations\|unwantedRecommendations" | tr -d '"')

    for ext in $extensions; do
      code --install-extension "$ext" &>/dev/null
    done

    clear
  fi
fi