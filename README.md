# CS4400
## Scripts Cheatsheet
### Extract one type of hashes from levelX.json
-Davinder
```
type="sha1"
jsonfile="levelX.json"
grep $type < $jsonfile | sed -E "s/^ *\"(.*)\",?/\1/g" > hashes-${type}.txt
```
### Brute Force Masks - 5 characters (Pattern: exactly one digit, atleast one vowel)
-Davinder
```
format=sha1format
hashes=hashfile
declare -a masks=( \
?1?1?1?2?d ?1?1?2?2?d ?1?2?2?2?d ?2?2?2?2?d \
?1?1?1?d?2 ?1?1?2?d?2 ?1?2?2?d?2 ?2?2?2?d?2 \
?1?1?d?1?2 ?1?1?d?2?2 ?1?2?d?2?2 ?2?2?d?2?2 \
?1?d?1?1?2 ?1?d?1?2?2 ?1?d?2?2?2 ?2?d?2?2?2 \
?d?1?1?1?2 ?d?1?1?2?2 ?d?1?2?2?2 ?d?2?2?2?2 \
)
for i in ${masks[@]}
do
    ./run/john --format=$format -1 [bcdfghjklmnpqrstvwxyz] -2 [aeiou] --mask=?l?l?l?l?d -min-len=5 -m ax-len=5 $hashes
done
```

## Download files from Google Drive
-Udita
```
filename="fourfour.wordlist"
file_id="1RM93c8xWyWL1rIQWRbxjT2uAKU5D70BD"
query=`curl -c ./cookie.txt -s -L "https://drive.google.com/uc?export=download&id=${file_id}" \
| perl -nE'say/uc-download-link.*? href="(.*?)\">/' \
| sed -e 's/amp;//g' | sed -n 2p`
url="https://drive.google.com$query"
curl -b ./cookie.txt -L -o ${filename} $url
```
### Level 1 
```
1) ./john --format=PBKDF2-HMAC-SHA256-opencl --wordlist=rockyou.txt <hashes> (Udita)
2) .. (Davinder) 
3) Python script to decrypt level (Joanna, Kavish)
```
| Hash | Count |
| --- | --- |
| PBKDF2 | 109/109 |
| sha1 | 77/77 |
| sha512 | 0/86 |
| argon2 | 0/71 |

### Level 2 
```
1) ./john --format=PBKDF2-HMAC-SHA256-opencl --wordlist=fourfour.wordlist <hashes> (Udita)
```
| Hash | Count |
| --- | --- |
| PBKDF2 | 34/34 |
| sha1 | 37/37 |
| sha512 | 0/34 |
| argon2 | 0/45 |
