# CS4400
## Scripts Cheat sheet
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
format="hash-format"
hashes="hash-file"
declare -a masks=( \
?1?1?1?2?d ?1?1?2?1?d ?1?2?1?1?d ?2?1?1?1?d \
?1?1?2?2?d ?1?2?2?1?d ?2?2?1?1?d ?2?1?2?1?d ?1?2?1?2?d ?2?1?1?2?d \
?1?2?2?2?d ?2?1?2?2?d ?2?2?1?2?d ?2?2?2?1?d \
?2?2?2?2?d \
?1?1?1?d?2 ?1?1?2?d?1 ?1?2?1?d?1 ?2?1?1?d?1 \
?1?1?2?d?2 ?1?2?2?d?1 ?2?2?1?d?1 ?2?1?2?d?1 ?1?2?1?d?2 ?2?1?1?d?2 \
?1?2?2?d?2 ?2?1?2?d?2 ?2?2?1?d?2 ?2?2?2?d?1 \
?2?2?2?d?2 \
?1?1?d?1?2 ?1?1?d?2?1 ?1?2?d?1?1 ?2?1?d?1?1 \
?1?1?d?2?2 ?1?2?d?2?1 ?2?2?d?1?1 ?2?1?d?2?1 ?1?2?d?1?2 ?2?1?d?1?2 \
?1?2?d?2?2 ?2?1?d?2?2 ?2?2?d?1?2 ?2?2?d?2?1 \
?2?2?d?2?2 \
)
for i in ${masks[@]}
do
    ./john/run/john --format=$format -1=[bcdfghjklmnpqrstvwxyz] -2=[aeiou] --mask=$i -min-len=5 -max-len=5 $hashes
done
```

### Download files from Google Drive
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

### Install JTR Bleeding Jumbo
-Davinder
```
# install NVIDIA - Tesla P100 drivers
# wget http://us.download.nvidia.com/tesla/410.72/NVIDIA-Linux-x86_64-410.72.run
# sudo ./NVIDIA-Linux-x86_64-410.72.run
sudo apt-get install build-essential libssl-dev git zlib1g-dev \
yasm libgmp-dev libpcap-dev pkg-config libbz2-dev \
nvidia-opencl-dev \
libopenmpi-dev openmpi-bin
cd ~
git clone git://github.com/magnumripper/JohnTheRipper -b bleeding-jumbo john
cd john/src
./configure --enable-mpi && make -s clean && make -sj4
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
