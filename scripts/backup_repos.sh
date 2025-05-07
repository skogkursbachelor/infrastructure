#!/bin/bash
export GH_TOKEN=xxx
gh repo list skogkursbachelor | while read -r repo _; do   gh repo clone "$repo" "$repo" || (cd "$repo" && git pull); done

