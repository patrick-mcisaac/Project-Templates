echo "What is your project name?"
read Project_Name

echo "What is your repo's SSH?"
read Repo_Name

cd ~/workspace

if [  -d "${Project_Name}-unity" ]
then
    echo "${Project_Name}-unity already exists"
    exit 1
fi

mkdir "${Project_Name}-unity"
cd "${Project_Name}-unity"

git init
curl -o .gitignore https://raw.githubusercontent.com/github/gitignore/main/Unity.gitignore

sed -i '/\*\.sln/a\*.slnx' .gitignore
sed -i '/\.vs\//a\.vscode/' .gitignore

git remote add origin $Repo_Name

git branch -M main
git add .
git commit -m "initial commit"
git push -u origin main

echo "${Project_Name}-unity is ready."

