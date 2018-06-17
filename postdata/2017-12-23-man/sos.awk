#!/usr/bin/awk -f

BEGIN {
	RS = "\r\n"
	FS = ";"
}

{
	gsub(/,/, ".")
	gsub(/(\xc2\xad[0-9]{1,2}|\+)/, "")
}

NR == 1 {
	printf("År,Kön,Ålder,Incidens\n")
}

NR > 2 && $2!="" {
	printf("%s,%s,%s,%s\n", $1,$2,$3,$4)
}
