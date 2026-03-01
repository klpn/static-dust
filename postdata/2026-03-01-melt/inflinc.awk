BEGIN {
    FS = "\t"
    print("week\tage\tsex\tinc")
}

NR > 1 && $1!~/53/ {
    gsub(/^v /, "", $1)
    gsub(/-.*/, "", $5)
    gsub(/Kvinnor/, 2, $6)
    gsub(/Män/, 1, $6)
    printf("%d\t%d\t%d\t%s\n", $1, $5, $6, $7)
}

