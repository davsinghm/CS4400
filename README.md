# CS4400
### Script for uploading large wordlist from google drive to gcp

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
| sha1 | 10/37 |
| sha512 | 0/86 |
| argon2 | 0/71 |
