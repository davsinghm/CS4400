# usage: pot_remove_duplicates.sh potfile
sort -u $1 | awk '!a[$0]++' > ${1}.tmp
mv ${1}.tmp $1
