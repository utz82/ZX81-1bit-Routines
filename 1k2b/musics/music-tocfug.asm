speed   equ #980    ; 152 BPM (even)



        dw toc_flourish
        dw toc_flourish
        dw toc_seq1
        dw toc_seq2
        dw toc_diminished
        dw pedal_d
        dw pedal_modulation
        dw recitativo
        dw fugue_subject
        dw fugue_answer
        dw fugue_counter
        dw fugue_episode
        dw fugue_stretto1
        dw fugue_stretto2
        dw final_build
        dw final_cadence
        dw 0



pedal_d:

db 14,14+#C0
db 14,38
db 14,41
db 14,45
db 14,41+#80
db 14,38
db 14,36
db 14,34

db 14,14+#C0
db 14,49
db 14,49
db 14,49
db 14,14+#80
db 49,49
db 49,49
db 49,49

db 0




recitativo:

db 26+#80,26+#C0
db 49,38
db 24,49
db 49,36
db 22,22+#80
db 49,34
db 21,49
db 49,33

db 19,19+#C0
db 49,31
db 17,49
db 49,29
db 14,14+#80
db 49,26
db 49,49
db 49,49

db 0




fugue_subject:

db 26,26+#C0
db 29,49
db 33,49
db 26,49
db 29,29+#80
db 33,49
db 38,49
db 33,49

db 36,36+#C0
db 33,49
db 29,49
db 26,49
db 24,24+#80
db 26,49
db 29,49
db 33,49

db 0




fugue_answer:

db 49,31+#C0
db 49,34
db 49,38
db 49,31
db 31,34+#80
db 34,38
db 38,43
db 34,38

db 49,36+#C0
db 49,33
db 49,29
db 49,26
db 24,24+#80
db 26,29
db 29,33
db 33,36

db 0




fugue_counter:

db 26,38+#C0
db 29,41
db 33,45
db 38,49
db 29,41+#80
db 33,45
db 38,49
db 41,49

db 24,36+#C0
db 28,40
db 31,43
db 36,49
db 28,40+#80
db 31,43
db 36,49
db 38,49

db 0




fugue_stretto1:

db 26,26+#C0
db 29,29
db 33,33
db 26,38
db 29,29+#80
db 33,33
db 38,41
db 33,38

db 36,36+#C0
db 33,29
db 29,26
db 26,33
db 24,24+#80
db 26,29
db 29,33
db 33,36

db 0




final_cadence:

db 26,26+#C0
db 29,41
db 33,45
db 38,49
db 41,41+#80
db 45,49
db 41,49
db 38,49

db 36,36+#C0
db 33,41
db 29,45
db 26,49
db 24,24+#80
db 22,49
db 21,49
db 14,49

db 14,14+#C0
db 14,49
db 14,49
db 14,49
db 14,14+#80
db 49,49
db 49,49
db 49,49

db 0




toc_flourish:

db 38,38+#C0
db 36,49
db 34,49
db 33,49
db 31,31+#80
db 29,49
db 28,49
db 26,49

db 38,38+#C0
db 36,49
db 34,49
db 33,49
db 31,31+#80
db 29,49
db 28,49
db 26,49

db 0



toc_seq1:

db 26,26+#C0
db 29,41
db 33,45
db 38,49
db 41,41+#80
db 45,49
db 41,49
db 38,49

db 36,36+#C0
db 33,43
db 29,41
db 26,49
db 24,24+#80
db 22,49
db 21,49
db 19,49

db 0



toc_seq2:

db 26,26+#C0
db 28,49
db 29,49
db 31,49
db 33,33+#80
db 34,49
db 36,49
db 38,49

db 41,41+#C0
db 40,49
db 38,49
db 36,49
db 34,34+#80
db 33,49
db 31,49
db 29,49

db 0






toc_diminished:

db 26,26+#C0
db 28,49
db 29,49
db 31,49
db 33,33+#80
db 34,49
db 36,49
db 38,49

db 40,40+#C0
db 41,49
db 43,49
db 45,49
db 46,46+#80
db 45,49
db 43,49
db 41,49

db 38,38+#C0
db 36,49
db 34,49
db 33,49
db 31,31+#80
db 29,49
db 28,49
db 26,49

db 0



pedal_modulation:

db 14,14+#C0
db 14,36
db 14,40
db 14,43
db 14,40+#80
db 14,36
db 14,33
db 14,31

db 17,17+#C0
db 17,38
db 17,41
db 17,45
db 17,41+#80
db 17,38
db 17,34
db 17,31

db 14,14+#C0
db 14,49
db 14,49
db 14,49
db 14,14+#80
db 49,49
db 49,49
db 49,49

db 0



fugue_episode:

db 26,38+#C0
db 29,41
db 33,45
db 38,49
db 29,41+#80
db 33,45
db 38,49
db 41,49

db 28,40+#C0
db 31,43
db 36,45
db 40,49
db 31,43+#80
db 36,45
db 40,49
db 43,49

db 29,41+#C0
db 33,45
db 38,46
db 41,49
db 33,45+#80
db 38,46
db 41,49
db 45,49

db 0



fugue_stretto2:

db 26,31+#C0
db 29,34
db 33,38
db 26,31
db 29,34+#80
db 33,38
db 38,43
db 33,38

db 36,36+#C0
db 33,29
db 29,26
db 26,33
db 24,24+#80
db 26,29
db 29,33
db 33,36

db 0



final_build:

db 26,26+#C0
db 29,38
db 33,41
db 38,45
db 41,41+#80
db 45,49
db 41,49
db 38,49

db 29,29+#C0
db 33,41
db 36,45
db 41,46
db 45,45+#80
db 46,49
db 45,49
db 41,49

db 26,26+#C0
db 33,45
db 38,46
db 41,49
db 45,45+#80
db 41,49
db 38,49
db 33,49

db 0



