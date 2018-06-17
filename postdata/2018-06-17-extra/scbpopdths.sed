#!/bin/sed -f
s/ år//g
s/kön/sex/g
s/män/1/g
s/kvinnor/2/g
s/ålder/age/g
s/Risktid [0-9]*/pop/g
s/Antal döda [0-9]*/dths/g
s/"//g
