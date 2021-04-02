#!/bin/bash

minera_dados(){
	curl "https://api.github.com/repos/$1/$2/pulls?state=closed&page=1&per_page=100" | grep -A 2 .title.:  | sed -n '/login/p' | sed '/"/{/ /{s/".* //;t};:a;/ /!{N;s/\n//;ta;};s/".* /\n/;}' > $2_dados.txt
	curl "https://api.github.com/repos/$1/$2/pulls?state=closed&page=2&per_page=100" | grep -A 2 .title.:  | sed -n '/login/p' | sed '/"/{/ /{s/".* //;t};:a;/ /!{N;s/\n//;ta;};s/".* /\n/;}' >> $2_dados.txt
	sort -u $2_dados.txt -o $2_logins.txt
	cont=1
	for i in $( cat $2_logins.txt );do
		qtd=`grep -c "$i" $2_dados.txt`
		sed -i ''$cont's/$/'$qtd'/' $2_logins.txt
		cont=$(($cont+1))
	sort --field-separator=',' -n -k 2,2 -r $2_logins.txt -o $3_$2.csv
	sed -i 's/"//g' $3_$2.csv
done
rm $2_dados.txt $2_logins.txt
}
minera_dados $1 $2 $3