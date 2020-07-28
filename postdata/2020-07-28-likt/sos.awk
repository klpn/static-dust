#!/usr/bin/awk -f

BEGIN {
	RS = "\r\n"
	FS = ";"
}

{
	gsub(/,/, ".")
}

NR == 1 {
	printf("År,Region,Kön,Incidens\n")
}

NR > 2 && $2!="" {
	inc = 0
	for (i=4; i<=NF; i++){
		inc += $i
	}
    printf("%s,%s,%s,%s\n", $1,$2,$3,inc)
}
