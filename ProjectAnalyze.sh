#!/bin/bash

#checking remote repo for updates
git fetch && git status -uno 
echo

#Redirecting all the changes to changes.log 
git diff > changes.log
printf "All changes have been added to changes.log.\n"
echo

#Seaching for lins with tag #TODO and save them to todo.log
grep -r --exclude={'ProjectAnalyze.sh','todo.log','changes.log'} '#TODO' * > todo.log
printf "TODOs have been loaded into todo.log.\n"
echo

#Running through all the .hs files and find errors
find . -name "*.hs" -exec ghc -fno-code {} \; 2> error.log
printf "All the errors in Haskell files have been saved to error.log.\n"
echo

#Checking if the course resouces page has been updated
URL="http://www.cas.mcmaster.ca/~dalvescb/#outline-container-orgd3c9a86"
if [ ! -f old.html ]; then
	touch old.html
fi
curl $URL -L --compressed -s > new.html
DIFF_OUTPUT="$(diff new.html old.html)"
if [ "0" != "${#DIFF_OUTPUT}" ]; then
	printf "New recouces are now available on the course website.\n"
	read -p 'Would you like to download them now?(Y/N)'$'\n' ans
	echo
	case $ans in 
 	[Yy]* ) wget -r -nd -nc -A pdf -P Resources/ http://www.cas.mcmaster.ca/~dalvescb/#outline-container-orgd3c9a86;
  	echo
  	printf "New PDFs downloaded in Resources.\n";;
  	[Nn]* ) echo;;
 	esac
else
	printf "The resources page has not been updated yet.\n"
	echo
fi
mv new.html old.html 2>/dev/null
