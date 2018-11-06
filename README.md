# CS4400
## Scripts Cheat sheet

### The Automator
- Davinder

automatically upload pot files to this git repo from your server, and checks if level is complete.
run this in parallel to John or Hashcat.

the following files should be in current directory:
level<level_no>.json
john<level>.pot or hashcat<level>.pot

e.g. for level 5:
```
wget https://github.com/dsmudhar/CS4400/raw/master/level5.json -O level5.json
wget https://github.com/dsmudhar/CS4400/raw/master/the_automator.sh -O the_automator.sh
chmod +x ./the_automator.sh
./the_automator.sh 5 pot_dasingh
```

### Clean Hashes for Level 8
- Kavish

```
list_final = []
list_temp_apend  = []
list_temp_deleted = []
list_hash = []
with open('level7.pot','r') as temp:
    list_pot = temp.readlines()
temp.close()
list_hash = [i.split()[0] for i in list_pot]
list_pass = [i.split()[1] for i in list_pot]

for i,j in zip(list_hash,list_pass):
    if len(j) != 8 and '/' not in j and '\' not in j :
        list_hash.append(i)
        list_temp_apend.append(j)    
    else:
        
        list_temp_deleted.append(j)

for l,m in zip(list_hash,list_temp):
    list_final.append(l + ":" + m )
    
with open('des_broken_f','w') as f:
    for item in list_final:
        f.writelines(item)
```

### Extract one type of hashes from levelX.json
- Davinder
```
type="sha1"
jsonfile="levelX.json"
grep $type < $jsonfile | sed -E "s/^ *\"(.*)\",?/\1/g" > hashes-${type}.txt
```


### Download large files from Google Drive
- Udita
```
filename="fourfour.wordlist"
file_id="1RM93c8xWyWL1rIQWRbxjT2uAKU5D70BD"
query=`curl -c ./cookie.txt -s -L "https://drive.google.com/uc?export=download&id=${file_id}" \
| perl -nE'say/uc-download-link.*? href="(.*?)\">/' \
| sed -e 's/amp;//g' | sed -n 2p`
url="https://drive.google.com$query"
curl -b ./cookie.txt -L -o ${filename} $url
```

### Install JTR Bleeding Jumbo/Google Cloud set up
- Udita
```
Create new VM instance with the following specs
1) Upgrade account and choose europe-west-1b as the region
2) Click customise under "Machine Type"
   -No.of GPUs as "1" (only allows 1 for some reason under the free credits) 
   -GPU type as "NVIDIA Tesla P100"
3) Click on create and SSH into VM instance then follow the steps below
```
- Davinder
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

k threshold ~35%
```
| Hash | Count |
| --- | --- |
| PBKDF2 | 109/109 |
| sha1 | 77/77 |
| sha512 | 0/86 |
| argon2 | 0/71 |

### Level 2 

4+4 wordlist attack
```
1) ./john --format=PBKDF2-HMAC-SHA256-opencl --wordlist=fourfour.wordlist <hashes> (Udita)

k threshold ~ 40% 
```
| Hash | Count |
| --- | --- |
| PBKDF2 | 34/34 |
| sha1 | 37/37 |
| sha512 | 0/34 |
| argon2 | 0/45 |

### Level 3

Passwords length 5 with atleast 
-1 digit in one of the last 3 places
-1 vowel

```
1) ./john  --format=PBKDF2-HMAC-SHA256-opencl --mask=?l?l?l?l?d  -min-len=5 -max-len=5 --pot=level3.hashes <hashes> (Udita)
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
(Udita) for cracking sha512
```
Split wordlist generated using python code into the following lists
1) 5 letter words with exactly 2 vowels, 1 digit and the digit at the last place
2) 5 letter words with exactly 2 vowels, 1 digit and the digit at the second last place
3) 5 letter words with exactly 2 vowels, 1 digit and the digit at the third last place
```
```
k threshold 56%
```
| Hash | Count |
| --- | --- |
| PBKDF2 | 31/31 |
| sha1 | 41/41 |
| sha512 | 8/40 |
| argon2 | 0/30 |

### Level 4

Passwords list crawled from scss and tcd.ie website
```
k threshold ~46%
```
| Hash | Count |
| --- | --- |
| PBKDF2 | 42/42 |
| sha1 | 34/34|

### Level 5

Passwords list consists of submitty usernames

Cracked usernames listed on cs7ns1 git Team.md
https://github.com/sftcd/cs7ns1/blob/master/assignments/practical5/TeamSelection.md

```
k threshold ~32%
```
### Level 6

Easter egg : Another rockyou?

Dictionary attack using rockyou list split into lengths 5,6,7,8
```
k threshold ~32%
```

| Hash | Count |
| --- | --- |
| PBKDF2 | 51/51 |
| sha1 | 21/48|

