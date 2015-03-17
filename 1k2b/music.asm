
speed equ #c00

seq
	dw ptn0
	dw ptn0
	dw ptn1
	dw ptn2
	dw ptn1
	dw ptn3
	dw ptn4
	dw ptn5
	dw ptn4
	dw ptn6
	dw ptn7
	dw ptn7
	dw ptn8
	dw ptn13
	dw ptn9
	dw ptn10
	dw ptn11
	dw ptn13
	dw ptn9
	dw ptn10
	dw ptn11
	dw ptn12
	dw ptn14
	dw ptn14
	dw 0

ptn0
	db #5,#31
	db #5,#31
	db #11,#31
	db #14,#31
	db #31,#31
	db #31,#31
	db #f,#31
	db #f,#31
	db #5,#31
	db #5,#31
	db #11,#31
	db #14,#31
	db #31,#31
	db #31,#31
	db #f,#31
	db #f,#31
	db 0

ptn1
	db #5,#e4
	db #5,#22
	db #11,#20
	db #14,#df
	db #31,#9f
	db #31,#1f
	db #f,#b1
	db #f,#b1
	db #5,#f1
	db #5,#31
	db #11,#31
	db #14,#f1
	db #31,#b1
	db #31,#31
	db #f,#18
	db #f,#9b
	db 0

ptn2
	db #5,#dd
	db #5,#1b
	db #11,#1d
	db #14,#e0
	db #31,#a0
	db #31,#20
	db #f,#f1
	db #f,#f1
	db #5,#f1
	db #5,#31
	db #11,#31
	db #14,#f1
	db #31,#b1
	db #31,#31
	db #f,#f1
	db #f,#31
	db 0

ptn3
	db #5,#dd
	db #5,#1b
	db #11,#1d
	db #14,#dd
	db #31,#9d
	db #31,#1d
	db #f,#f1
	db #f,#f1
	db #5,#f1
	db #5,#31
	db #11,#31
	db #14,#f1
	db #31,#b1
	db #31,#31
	db #f,#f1
	db #f,#31
	db 0

ptn4
	db #a,#e2
	db #a,#20
	db #16,#22
	db #19,#e5
	db #31,#a5
	db #31,#25
	db #14,#b1
	db #14,#b1
	db #a,#f1
	db #a,#31
	db #16,#31
	db #19,#e4
	db #31,#a7
	db #31,#25
	db #14,#24
	db #14,#a2
	db 0

ptn5
	db #5,#e4
	db #5,#22
	db #11,#24
	db #14,#dd
	db #31,#9d
	db #31,#1d
	db #f,#f1
	db #f,#f1
	db #5,#f1
	db #5,#31
	db #11,#31
	db #14,#f1
	db #31,#b1
	db #31,#31
	db #f,#f1
	db #f,#31
	db 0

ptn6
	db #8c,#e4
	db #10c,#24
	db #18c,#24
	db #b1,#31
	db #b1,#31
	db #b1,#b1
	db #a,#e2
	db #a,#31
	db #8,#e0
	db #8,#31
	db #7,#df
	db #7,#31
	db 0

ptn7
	db #5,#f1
	db #5,#31
	db #11,#31
	db #14,#f1
	db #31,#b1
	db #31,#31
	db #f,#b1
	db #f,#b1
	db #5,#f1
	db #5,#31
	db #11,#31
	db #14,#f1
	db #31,#b1
	db #31,#31
	db #f,#31
	db #f,#b1
	db 0

ptn8
	db #7,#f1
	db #7,#31
	db #13,#31
	db #16,#f1
	db #31,#b1
	db #31,#31
	db #11,#b1
	db #11,#b1
	db #7,#f1
	db #7,#31
	db #13,#31
	db #16,#f1
	db #31,#b1
	db #31,#31
	db #11,#31
	db #11,#b1
	db 0

ptn9
	db #7,#e6
	db #7,#24
	db #13,#26
	db #16,#e9
	db #31,#a9
	db #31,#29
	db #11,#a9
	db #11,#a9
	db #7,#f1
	db #7,#31
	db #13,#31
	db #16,#e6
	db #31,#a9
	db #31,#26
	db #11,#29
	db #11,#a6
	db 0

ptn10
	db #7,#eb
	db #7,#2b
	db #13,#2b
	db #16,#eb
	db #31,#b1
	db #31,#31
	db #11,#f1
	db #11,#f1
	db #7,#f1
	db #7,#31
	db #13,#26
	db #16,#f1
	db #31,#a4
	db #31,#31
	db #11,#df
	db #11,#31
	db 0

ptn11
	db #7,#e6
	db #7,#27
	db #13,#26
	db #16,#df
	db #31,#9f
	db #31,#1f
	db #11,#9f
	db #11,#9f
	db #7,#f1
	db #7,#31
	db #13,#31
	db #16,#f1
	db #31,#a6
	db #31,#31
	db #11,#26
	db #11,#a7
	db 0

ptn12
	db #1a,#e6
	db #1a,#26
	db #18,#24
	db #18,#24
	db #16,#22
	db #16,#22
	db #15,#21
	db #15,#21
	db #e,#26
	db #e,#26
	db #c,#24
	db #c,#24
	db #a,#22
	db #a,#22
	db #9,#21
	db #9,#21
	db 0

ptn13
	db #7,#f1
	db #7,#31
	db #13,#31
	db #16,#f1
	db #31,#b1
	db #31,#31
	db #11,#f1
	db #11,#f1
	db #7,#f1
	db #7,#31
	db #13,#31
	db #16,#f1
	db #31,#b1
	db #31,#31
	db #11,#f1
	db #11,#31
	db 0

ptn14
	db #1a,#26
	db #18,#24
	db #16,#22
	db #15,#21
	db #e,#26
	db #c,#24
	db #a,#22
	db #9,#21
	db 0

