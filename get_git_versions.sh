#!/bin/bash
#Author: Mateo Manzano Calixto
#Course: ITSC-204(COMPUTER ARCHITECTURE), SAIT.
#Date: 2022/11/04
#THIS PROGRAM WILL GET EVERY AVAILABLE GIT VERSION FROM WEB PAGE https://mirrors.edge.kernel.org/pub/software/scm/git/

which wget 1>/dev/null 2>/dev/null 
if [ $? -ne 0 ] #CHECK IF WGET IS ALREADY INSTALL, IF NOT THEN INSTALL WGET
then
    echo "Please install wget and retry"
    exit 1
fi
if [ -e "index.html" ] #DOWNLOAD WEB PAG CONTENT ON REPOSITORY "index.html" 'WGET https://mirrors.edge.kernel.org/pub/software/scm/git/'
then
    echo "Removing old index.html"
    rm -rf index.html #CHECK IF THERE IS ALREADY A REPOSITORY NAMED "index.html, IF TRUE REPLACE FOR A NEW ONE"
fi

url = "https://mirrors.edge.kernel.org/pub/software/scm/git/"
wget $url
if [ $? -ne 0 ] #CHECK FOR CORRECT DOWNLOAD OF WEB PAGE CONTENT INTO REPOSITORY 'index.html'
then
    echo "Unable to download git info from web page $url"
    exit 2
fi
declare -a git_vers

while read line
do
#echo "********Please wait collecting all git versions from official website of 'git-scm'"
git_vers+=($(echo $line | sed -n '/git-\([0-9]\+\.\)\+tar.gz/p'|awk -F '"' '{ print $2 }'|cut -c 5- | awk -F '.tar.gz' '{print $1}'))
#SCRIPT FOR PRINTING EACH VERSION OF GIT
done < index.html

echo "The following are the all available git versions: "
cnt = 0
no_vers = ${#git_vers[*]}
WIDTH = 20
for each_ver in ${#git_vers[*]}
do
    #echo -e "\t\t ${git_vers[$cnt]} \\t ${git_vers[$((cnt+1))]} \\t ${git_vers[$((cnt+2))]}"
    #PRINT ALL GIT VERSIONS SAVE ON REPOSITORY 'index.html' BY FOLLOWING SCRIPT
    printf"%-*s %-*s %-*s\n" $WIDTH ${git_vers[$cnt]} $WIDTH ${git_vers[$((cnt+1))]} $WIDTH ${git_vers[$((cnt+2))]}
    cnt = $((cnt+3))
    if [ $cnt -ge $no_vers ]
    then
        break
    fi
done
