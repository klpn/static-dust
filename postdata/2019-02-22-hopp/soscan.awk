#!/usr/bin/awk -f

BEGIN {
	RS = "\r\n"
	FS = ";"
}

{
	gsub(/,/, ".")
	gsub(/(\xc2\xad[0-9]{1,2}|\+)/, "")
}

NF > 1 {
	print $0
}
