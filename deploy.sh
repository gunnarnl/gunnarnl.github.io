#!/usr/bin/env bash

now=$(date)

# Temporarily store uncommited changes
git stash

# Verify correct branch
git checkout develop

# Build new files
stack build
stack exec site rebuild

git add .
git commit -m "Update dev on $now."

# Get previous files
git fetch --all
git push origin develop #push development branch

git checkout master

# Overwrite existing files with new files
cp -a _site/. .

# Commit
git add -A
git commit -m "Publish updates on $now."

# Push
git push origin master:master

# Restoration
git checkout develop
git stash pop
