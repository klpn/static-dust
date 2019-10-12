BEGIN {
	FS = ";"
}

$4~ca1 && $5~sex && $6==age {
	ca1n[$2][$3][$5] += $7
}

$4~ca2 && $5~sex && $6==age {
	ca2n[$2][$3][$5] += $7
}

END {
	for (yr in ca1n) {
		for (reg in ca1n[yr]) {
			for (sex in ca1n[yr][reg]) {
				rat = ca1n[yr][reg][sex]/ca2n[yr][reg][sex]
					printf("%d;%02d;%d;%d;%d;%.3f\n", 
						yr, reg, sex, ca1n[yr][reg][sex], ca2n[yr][reg][sex], rat)
			}
		}
	}
}