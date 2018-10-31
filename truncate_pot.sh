sort -u hashcat.potfile | awk '!a[$0]++' | sed -E 's/(^[^$]*:.{7}).$/\1/g' | sed 's/:/ /g' > dasingh.broken
