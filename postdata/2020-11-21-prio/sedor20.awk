#!/usr/bin/awk -f
BEGIN { 
    RS = "\n"
    FS = ","
}

{
    gsub(/\x22|,\s|\s|\xc2\xa0/, "")
    gsub(/\xe2\x80\x93/, "-")
}

NR == 1 { 
    printf("icd10,sex,age,n\n") 
}

NR > 5 && $5 != "" { 
    if ($1=="") {$1=previcd}
    previcd = $1
    for (i=0; i<=21; i++) {
        c=i+4
        printf("%s,%s,%d,%d\n",$1,$3,i,$c)
    }
}
