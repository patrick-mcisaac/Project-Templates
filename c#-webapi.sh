#!/bin/bash
set -e

echo "What is your project name?"
read Project_Name

echo "What is your repo SSH?"
read Repo_Name

cd ~/workspace

if [ -d "${Project_Name}API" ]
then
    echo "${Project_Name}API already exists"
    exit 1
fi

dotnet new webapi -o "${Project_Name}API" -minimal

cd "${Project_Name}API"


mkdir Models Models/DTOs

# GIT
dotnet new gitignore

git init

git branch -M main

git add .

git commit -m 'initial commit'

git remote add origin $Repo_Name

git push -u origin main

echo "${Project_Name} set up"
echo "cd ${Project_Name}API"


