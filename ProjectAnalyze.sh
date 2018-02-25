#!/bin/bash

#checking remote repo for updates
git fetch && git status -uno 
echo

#Redirecting all the changes to changes.log 
git diff > changes.log
printf "All changes have been appened to the file changes.log\n"
echo

#Seaching for lins with tag #TODO and save them to the file todo.log
grep -r --exclude={'ProjectAnalyze.sh','todo.log','changes.log'} '#TODO' * > todo.log
printf "TODOs have been loaded into the file todo.log\n"
echo

#Running through all the .hs files and find errors
find . -name "*.hs" -exec ghc -fno-code {} \; 2> error.log
printf "All the errors in Haskell files have been saved to the file error.log"
echo
