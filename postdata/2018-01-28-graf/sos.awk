#!/usr/bin/awk -f

BEGIN {
	RS = "\r\n"
	FS = ";"
}

{
	gsub(/,/, ".")
	gsub(/Kvinnor/, "F")
	gsub(/Män/, "M")
	gsub(/(\xc2\xad[0-9]{1,2}|\+)/, "")
}

NR == 1 {
	printf("year,sex,age,inc\n")
}

NR > 2 && $2!="" {
	inc = 0
	for (i=4; i<=NF; i++){
		inc += $i
	}
	printf("%s,%s,%s,%s\n", $1,$2,$3,inc)
}
