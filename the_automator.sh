#~/bin/bash

cd ~
git_username=""
git_password=""
git_repo="github.com/dsmudhar/CS4400"

if [[ $# < 2 ]]; then
        echo "invalid arguments"
        echo "usage: script.sh <level_number> <branch_name>"
fi

level=$1
branch=$2

push_new_pots () {
        cd ~/$git_dir
        git add $1
        git commit -m "bot: added new hash(s)"
        git push -u origin $branch
        # git push --set-upstream origin origin/$branch
}

check_new_hash () {
        pot=$1
        if [[ ! -f "$pot" ]]; then
                echo "$pot not found"   
        fi

        touch ${pot}.last
        if [[ $(diff $pot ${pot}.last) ]]; then
                echo "==== Changes detected in $pot"
                diff $pot ${pot}.last
                
                cp $pot ~/CS4400/$pot
                cp $pot ${pot}.last
                push_new_pots $pot
        else
                echo "==== No changes detected"
        fi
}

if [[ ! -d "$git_dir" ]]; then
        git clone https://${git_repo}
        cd $git_dir
        git remote set-url origin https://${git_username}:${git_password}@$git_repo
        git config user.email "hash.c@gmx.com"
        git config user.name "The Bot"
        git fetch --all
        git pull --all
        git checkout --track origin/$branch
        push_new_pots foo.txt
fi

check_new_hash john${level}.pot
check_new_hash hashcat${level}.pot
