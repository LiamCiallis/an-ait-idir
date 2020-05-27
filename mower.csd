<CsoundSynthesizer>
<CsOptions>
-o dac
</CsOptions>
<CsInstruments>
sr = 48000
ksmps = 32
nchnls = 2
0dbfs = 1

instr 1
aModulatingFrequency poscil 10, 20 , 1
aCarrierFrequency poscil 0.3, 80+aModulatingFrequency, 1
outs aCarrierFrequency, aCarrierFrequency
endin

</CsInstruments>
<CsScore>
f 1 0 1024 10 1 		;Sine wave for table 1
i 1 0 10
</CsScore>
</CsoundSynthesizer>
