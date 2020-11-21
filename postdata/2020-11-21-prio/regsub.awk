BEGIN {
    FS = ","
    printf("age,n\n")
}

$1~reg {
    printf("%d,%d\n", $2, $3)
}
