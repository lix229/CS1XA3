# Assignment1 - Project Analyze
## I. Overall Description
The script is designed to be run every time you continue working on a project or once a while when you're working to give you a brief reminder of your current progress and to keep track of your works. It also comes with features to check the course resources and record the bugs in all Haskell files in the repository.
The Script itself is a base model that can be expended or modified easily to satisfy different needs.
## II. Features
* Check if the local repo is update, and notify the user if anything is not commited or pushed yet.
* Save all the changes in the local repo to a file `changes.log`.
* Automatically run through all the Haskell `.hs` files in the repo and record the errors to a file `error.log` if there are any.
* Display your last commit with HEAD and Comment on screen.
* Check if the [course resource page](http://www.cas.mcmaster.ca/~dalvescb/#outline-container-orgd3c9a86) is updated and download the new PDFs if the user wishes to.
## III. User Instructions
I believe a shell script should be targeting small and repeatable tasks in daily development, so this script is kept as lightweight and easy to use as possible while the possiblity to customize under different circumstances is reserved. Any unnecessory user interactions are removed.
* Basic use of this script is extremely stright forword.
`sh ./ProjectAnalyze.sh` would run the script assuming it is in your current location.
The script would display information in the following order:
  1. Repo status.
  2. Directing changes to changes.log.
  3. Loading TODOs to todo.log.
  4. Display the last commit with HEAD, Date, and Author.
  5. Checking update from a specified website. (Default: [course resource page](http://www.cas.mcmaster.ca/~dalvescb/#outline-container-orgd3c9a86))
* However, considering the lightweight and easy-to-modify characteristics of the script, there're more to play with.
  1. The website to monitor and the files to download can be customized.
        * The line `URL="http://www.cas.mcmaster.ca/~dalvescb/#outline-container-orgd3c9a86"` indicates the domain of the website, changing the value for `URL` would change the monitoring target.
        * The line `wget -r -nd -q -nc -A pdf -P Resources/ http://www.cas.mcmaster.ca/~dalvescb/#outline-container-orgd3c9a86` indicates the download target website (`http:://www.example.com`) and file extension (`-A EXTENSION`) to download, and the directory to save those files (`-P DIRECTORY`).
  2. The script can be run automatically once a given time period by adding the following lines in `.bash_profile`.
        ```
        */time_in_minutes * * * * /Path_to_script
        ```
  3. I personally add these lines in my .bash_profile to promote a choice of repos, and according to your input, the script in the selected repo would be run to indicate information about that repo.
        ```
        read -p "Enter repo:"$'\n' ans
        if [ -d ./"$ans" ]; then
            cd ./"$ans"
            if [ -f ProjectAnalyze.sh ]; then
                sh ProjectAnalyze.sh
            else
                echo "ProjectAnalyze.sh not found."
            fi
        else
            echo "Local Repo not found: $ans"
        fi
        ```
