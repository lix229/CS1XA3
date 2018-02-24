#!/bin/bash

#Checking remote repo for updates and displaying changes waiting to be commited
git remote update && git status -uno
echo

#Redirecting all the changes to changes.log 
git diff >> changes.log
printf "All changes have been appened to the file changes.log\n"
echo

#Seaching for lins with tag #TODO and save them to the file todo.log
grep -r --exclude={'ProjectAnalyze.sh','todo.log','changes.log'} '#TODO' * > todo.log
printf "TODOs have been loaded into the file todo.log\n"
echo


