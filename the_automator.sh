#~/bin/bash

git_username=""
git_password=""
git_fullname=""
git_email=""

if [[ $# < 2 ]]; then
    echo "invalid arguments"
    echo "usage: script.sh <level_number> <branch_name>"
    exit 1
fi

git_repo="github.com/dsmudhar/CS4400"
level=$1
branch=$2

load_other_pots() {
    potall=$1
    echo
    echo ">> Downloading pot branch list"
    wget -q https://${git_repo}/raw/master/pot_branches.txt -O pot_branches.txt

    #loop over branches and download all pot files
    while IFS='' read -r line || [[ -n "$line" ]]; do

        echo ">>> Downloading ${line}'s hashcat${level}.pot"
        wget -q https://${git_repo}/raw/${line}/hashcat${level}.pot -O hashcat${level}.pot.${line}
        if [ $? -eq 0 ]; then
            echo ">>>> Successful."
        else
            echo ">>>> Failed."
        fi

        echo ">>> Downloading ${line}'s john${level}.pot"
        wget -q https://${git_repo}/raw/${line}/john${level}.pot -O john${level}.pot.${line}
        if [ $? -eq 0 ]; then
            echo ">>>> Successful."
        else
            echo ">>>> Failed."
        fi

        cat hashcat${level}.pot.${line} >> $potall
        cat john${level}.pot.${line} >> $potall
        
    done < pot_branches.txt

    sort -u $potall | awk '!a[$0]++' > ${potall}.tmp
    mv ${potall}.tmp ${potall}
    echo 
    echo ">> Merged Potfile Lines: " $(wc -l < $potall)
    echo
    python2.7 shamir.py -i level${level}.json -p $potall
    echo
    #sleep infinity
    #cat $potall
}

push_new_pots () {
    cd $git_dir
    git add $1
    git commit -m "automator: add new hash(s)"
    git push -u origin $branch
    cd ..
}

check_new_hash () {
    pot=$1
    if [[ ! -f "$pot" ]]; then
        echo "$pot not found"   
    fi

    touch ${pot}
    touch ${pot}.last
    if [[ $(diff $pot ${pot}.last) ]]; then
        echo "> Changes detected for $pot"
        echo "diff lines:" $(diff $pot ${pot}.last | wc -l)
        
        cp $pot ${git_dir}/$pot
        cp $pot ${pot}.last
        push_new_pots $pot

        cat $pot >> potfile${level}.all
        load_other_pots potfile${level}.all
    else
        echo "> No changes detected for $pot"
    fi
}

git_dir="$(echo $git_repo | rev | cut -d '/' -f 1 | rev)"

if [[ ! -d "$git_dir" ]]; then
    git clone https://${git_repo}
    cd $git_dir
    cp infernocode-v1.1.py ../shamir.py
    git remote set-url origin https://${git_username}:${git_password}@$git_repo
    git config user.email $git_email
    git config user.name $git_fullname
    git fetch --all
    git pull --all
    git checkout --track origin/$branch
    #push_new_pots foo.txt
fi

while true
do 
    check_new_hash john${level}.pot
    check_new_hash hashcat${level}.pot
    sleep 1
done
