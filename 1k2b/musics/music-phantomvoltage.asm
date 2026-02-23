
speed   equ #D20    ; 210 BPM (even)



        dw intro
        dw engine_a
        dw engine_b
        dw hook
        dw engine_c
        dw breakdown
        dw tension
        dw hook
        dw finale
        dw 0


intro:

db 24,24+#C0
db 36,49
db 31,49
db 36,49
db 27,27+#80
db 39,49
db 34,49
db 39,49

db 29,29+#C0
db 41,49
db 32,49
db 41,49
db 31,31+#80
db 43,49
db 34,49
db 43,49

db 0



engine_a:

db 24,24+#C0
db 36,43
db 31,49
db 36,43
db 27,27+#80
db 39,46
db 34,49
db 39,46

db 29,29+#C0
db 41,44
db 32,49
db 41,44
db 31,31+#80
db 43,46
db 34,49
db 43,46

db 0




engine_b:

db 32,32+#C0
db 44,49
db 39,49
db 44,49
db 34,34+#80
db 46,49
db 39,49
db 46,49

db 29,29+#C0
db 41,49
db 36,49
db 41,49
db 27,27+#80
db 39,49
db 34,49
db 39,49

db 0




hook:

db 36,24+#C0
db 38,49
db 41,49
db 43,49
db 46,46+#80
db 43,49
db 41,49
db 38,49

db 39,27+#C0
db 41,49
db 44,49
db 46,49
db 43,43+#80
db 41,49
db 39,49
db 36,49

db 0




engine_c:

db 31,31+#C0
db 43,49
db 38,49
db 43,49
db 27,27+#80
db 39,49
db 34,49
db 39,49

db 29,29+#C0
db 41,49
db 36,49
db 41,49
db 24,24+#80
db 36,49
db 31,49
db 36,49

db 0




breakdown:

db 24+#80,24+#C0
db 49,49
db 36,49
db 49,49
db 27,27+#80
db 49,49
db 39,49
db 49,49

db 29,29+#C0
db 49,49
db 41,49
db 49,49
db 31,31+#80
db 49,49
db 43,49
db 49,49

db 0





tension:

db 31,31+#C0
db 38,49
db 39,49
db 41,49
db 43,43+#80
db 44,49
db 46,49
db 44,49

db 31,31+#C0
db 39,49
db 43,49
db 46,49
db 43,43+#80
db 39,49
db 36,49
db 31,49

db 0





finale:

db 24,24+#C0
db 36,43
db 31,49
db 36,43
db 27,27+#80
db 39,46
db 34,49
db 39,46

db 36,36+#C0
db 43,49
db 46,49
db 43,49
db 41,41+#80
db 38,49
db 36,49
db 31,49

db 24,24+#C0
db 49,49
db 24,49
db 49,49
db 24,24+#80
db 49,49
db 49,49
db 49,49

db 0






