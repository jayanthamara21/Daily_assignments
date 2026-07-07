mkdir -p project/{src,docs,scripts,backup,archive}

touch project/src/app.py
touch project/src/config.txt
touch project/docs/readme.md
touch project/scripts/deploy.sh

cp project/src/config.txt project/backup

mv project/docs/readme/md project/archive

mv project/src/app.py project/src/main.py

find project -name "main.py"
find project -name ".txt"

chmod 755 project/scripts/deploy.sh

ls -l project/scripts/deploy.sh

tar -czvf project/backup.tar.gz project/

mkdir recovered_projecr
tar -xzvf project_backup.tar,gz -c recovered_project/

tree recovered_project

find recovered_project

