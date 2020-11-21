#!/usr/bin/awk -f
BEGIN { 
    RS = "\r\n" 
    FS = "\t"
    fpop = 0
    mpop = 0
}

NR == 1 {
    printf("sex,age1,n\n")
}

NR > 1 {
    gsub(/\sår|\+/, "")
    gsub(/kvinnor/, "Kv")
    gsub(/män/, "M")
    if ($2 == "M")
        mpop += $4
    else
        fpop += $4
    printf("%s,%d,%s\n",$2,$1+1,$4)
}

END {
    printf("%s,%d,%f\n%s,%d,%f","Kv",0,fpop,"M",0,mpop)
}
