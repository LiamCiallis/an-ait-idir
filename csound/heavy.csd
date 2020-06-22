<CsoundSynthesizer>
<CsOptions>
-o dac
</CsOptions>
<CsInstruments>
sr = 44100
ksmps = 32
nchnls = 2
0dbfs = 1

giSine    ftgen     0, 0, 2^10, 10, 1

    instr 2 ;inharmonic additive synthesis
ibasefrq  =         cpspch(p4)
ibaseamp  =         ampdbfs(p5)
;create 8 inharmonic partials
aOsc1     poscil    ibaseamp, ibasefrq, giSine
aOsc2     poscil    ibaseamp/2, ibasefrq*1.02, giSine
aOsc3     poscil    ibaseamp/3, ibasefrq*1.1, giSine
aOsc4     poscil    ibaseamp/4, ibasefrq*1.23, giSine
aOsc5     poscil    ibaseamp/5, ibasefrq*1.26, giSine
aOsc6     poscil    ibaseamp/6, ibasefrq*1.31, giSine
aOsc7     poscil    ibaseamp/7, ibasefrq*1.39, giSine
aOsc8     poscil    ibaseamp/8, ibasefrq*1.41, giSine
kenv      linen     1, p3/2, p3, p3/1.5

ibasefrqLower  =         cpspch(p4 - 1) 
ibaseampLower  =         ampdbfs(p5 + 1) 
;create 8 inharmonic partials
aOsc9     poscil    ibaseampLower, ibasefrqLower, giSine
aOsc10     poscil    ibaseampLower/2, ibasefrqLower*1.02, giSine
aOsc11     poscil    ibaseampLower/3, ibasefrqLower*1.1, giSine
aOsc12     poscil    ibaseampLower/4, ibasefrqLower*1.23, giSine
aOsc13     poscil    ibaseampLower/5, ibasefrqLower*1.26, giSine
aOsc14     poscil    ibaseampLower/6, ibasefrqLower*1.31, giSine
aOsc15     poscil    ibaseampLower/7, ibasefrqLower*1.39, giSine
aOsc16     poscil    ibaseampLower/8, ibasefrqLower*1.41, giSine
kenv      linen     1, p3/2, p3, p3/1.5

aOut = aOsc1 + aOsc2 + aOsc3 + aOsc4 + aOsc5 + aOsc6 + aOsc7 + aOsc8 + aOsc9 + aOsc10 + aOsc11 + 
aOsc12 + aOsc13 + aOsc14 + aOsc15 + aOsc16

kline	line	0, p3, 1     ; straight line
aL,aR	pan2	aOut*kenv, kline   ; sent across image
	outs	aL, aR
    endin

</CsInstruments>
<CsScore>
;          pch       amp
s
i 2 1 12   7.00      -7
</CsScore>
</CsoundSynthesizer>