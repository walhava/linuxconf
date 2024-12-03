#!/bin/bash

# Get current remote URL
remote_url=$(git remote get-url origin)

# Parse username and repository from remote URL
regex="github.com/(.+)/(.+)\.git"
if [[ $remote_url =~ $regex ]]; then
    username=${BASH_REMATCH[1]}
    repository=${BASH_REMATCH[2]}
else
    echo "Failed to parse remote URL: $remote_url"
    exit 1
fi

# Remove existing remote URL
git remote remove origin

# Add new remote URL
ssh_url="git@github.com:${username}/${repository}.git"
git remote add origin "$ssh_url"

# Verify updated remote URL
git remote -v
