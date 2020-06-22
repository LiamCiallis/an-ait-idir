<CsoundSynthesizer>
<CsOptions>
-odac     ;;;realtime audio out 
</CsOptions>
<CsInstruments>

sr = 48000
ksmps = 32
nchnls = 2
0dbfs = 1

;start python interpreter
pyinit
pyruni {{
bird = [0.1, 0.0, 0.1, 0.0, 0.1, 0.1, 0.6]
tractor = [0.4, 0.0, 0.0, 0.1, 0.1, 0.2, 0.2]
closeTraffic = [0.0, 0.1, 0.0, 0.9, 0.0, 0.0, 0]
distantTraffic = [0.7, 0, 0.1, 0.2, 0, 0, 0]
bees = [0.6, 0.4, 0.0, 0.0, 0.0, 0, 0]
mower = [0.1, 0.2, 0, 0.05, 0.4, 0.25, 0]
wind = [0.25, 0, 0.0, 0.25, 0.25, 0.25, 0]

markov = [bird, tractor, closeTraffic, distantTraffic, bees, mower, wind]

import threading
import random


def getDrunkValue(valueToPass, step):

    stepForRandomValue = int(round(step/2))
    
    return float(random.randint(valueToPass - stepForRandomValue, valueToPass + stepForRandomValue))


def getNextValue(instrument, previousNote, numberOfSteps):
    instrumentInt = int(instrument)

    valToConsider =  markov[instrumentInt][int(previousNote)]
    instrumentCount = len(markov[instrumentInt])

    for x in range(int(numberOfSteps)):
        valToConsider = markov[instrumentInt][int(previousNote)]
        previousNote = previousNote + 1

        if instrumentCount == int(previousNote):
           previousNote = 0

    return float(valToConsider)
}}

gisineMod ftgen 0, 0, 16384, 10, 1

instr simpleBird 
    iLastValue init 0 
    iNumberOfSteps random 1,10

    iNextValue   pycall1i "getNextValue", 0, iLastValue, iNumberOfSteps

    prints "lastValue = %f, newGen'd value= %f \n", iLastValue, iNextValue
    iLastValue = iNextValue
    iInstance =          p4 

    ;reset the duration of this iInstance 
    iDuration     rnd31      5, 3				;shorter values are more probable 
    iDuration   =          abs(iDuration) + 0.2 
    p3          =          iDuration 
    ;trigger the effect instrument of this iInstance 
            event_i    "i", "fxSimpleBird", 0, iDuration, iInstance 
    ;print the status quo 
    kTime    times 
            prints     "iInstance = %d, start = %f, duration = %f\n", iInstance, i(kTime), iDuration 
            
    ;make sound
    iRandomModulation random 6, 12 
    iAmplitude     active     1					;scale amplitudes         
    aModulation poscil 1, iRandomModulation, gisineMod
    aSignal = aModulation * 125
    iRandomFrequency random 2500, 4000
    aCarrier poscil 10, iRandomFrequency + aSignal, gisineMod  ; vibrato added to carrier frequency

    aCarrierPlusAmplitudeModulation poscil 40, aCarrier, gisineMod
    aEnvelope     transeg    0, 0.02, 0, 1/iAmplitude, p3-0.02, -6, 0	;output envelope 

    aOutPut = aCarrierPlusAmplitudeModulation*aEnvelope
    ;send signal to effect instrument 
    Sbus     sprintf    "audio_%d", iInstance		;create unique software bus 
        
    if iNextValue > 0.0 then
        chnset     aOutPut/2, Sbus			;send audio on this bus 
    endif

    kLast    release 

    schedkwhen kLast, 0, 0, "simpleBird", 0, 1, iInstance+1  
endin 

giSine    ftgen     0, 0, 2^10, 10, 1

instr heavyRoadSound 
    iInstance =          p4 
    ;reset the duration of this iInstance 
    iDuration     random      5, 15				;shorter values are more probable 
    iDuration     =          abs(iDuration) + 0.2 
    p3       =          iDuration 
    ;trigger the effect instrument of this iInstance 
            event_i    "i", "fxHeavyRoadSound", 0, iDuration, iInstance 
    ;print the status quo 
    kTime    times 
            prints     "iInstance = %d, start = %f, duration = %f\n", iInstance, i(kTime), iDuration 
            
    ;make sound 
    iFrequencyValue = 7.00
    iAmplitudeValue = -7
    iBaseFrequency  =         cpspch(iFrequencyValue)
    iBaseAmplitude  =         ampdbfs(iAmplitudeValue)
    ;create 8 inharmonic partials
    aOsc1     poscil    iBaseAmplitude, iBaseFrequency, giSine
    aOsc2     poscil    iBaseAmplitude/2, iBaseFrequency*1.02, giSine
    aOsc3     poscil    iBaseAmplitude/3, iBaseFrequency*1.1, giSine
    aOsc4     poscil    iBaseAmplitude/4, iBaseFrequency*1.23, giSine
    aOsc5     poscil    iBaseAmplitude/5, iBaseFrequency*1.26, giSine
    aOsc6     poscil    iBaseAmplitude/6, iBaseFrequency*1.31, giSine
    aOsc7     poscil    iBaseAmplitude/7, iBaseFrequency*1.39, giSine
    aOsc8     poscil    iBaseAmplitude/8, iBaseFrequency*1.41, giSine
    kenv      linen     1, p3/2, p3, p3/1.5

    iBaseFrequencyLower  =         cpspch(iFrequencyValue - 1) 
    iBaseAmplitudeLower  =         ampdbfs(iAmplitudeValue + 1) 
    ;create 8 inharmonic partials
    aOsc9     poscil    iBaseAmplitudeLower, iBaseFrequencyLower, giSine
    aOsc10     poscil    iBaseAmplitudeLower/2, iBaseFrequencyLower*1.02, giSine
    aOsc11     poscil    iBaseAmplitudeLower/3, iBaseFrequencyLower*1.1, giSine
    aOsc12     poscil    iBaseAmplitudeLower/4, iBaseFrequencyLower*1.23, giSine
    aOsc13     poscil    iBaseAmplitudeLower/5, iBaseFrequencyLower*1.26, giSine
    aOsc14     poscil    iBaseAmplitudeLower/6, iBaseFrequencyLower*1.31, giSine
    aOsc15     poscil    iBaseAmplitudeLower/7, iBaseFrequencyLower*1.39, giSine
    aOsc16     poscil    iBaseAmplitudeLower/8, iBaseFrequencyLower*1.41, giSine
    kenv      linen     1, p3/2, p3, p3/1.5

    aOut = aOsc1 + aOsc2 + aOsc3 + aOsc4 + aOsc5 + aOsc6 + aOsc7 + aOsc8 + aOsc9 + aOsc10 + aOsc11 + 
    aOsc12 + aOsc13 + aOsc14 + aOsc15 + aOsc16
    aOutPut = aOut*kenv

    iLastValue init 0 
    iNumberOfSteps random 1,10
    iNextValue   pycall1i "getNextValue", 2, iLastValue, iNumberOfSteps
    iLastValue = iNextValue

    ;send signal to effect instrument 
    SHeavyBus     sprintf    "audio_%d", iInstance		;create unique software bus 
    if iNextValue > 0.0 then
        chnset     aOutPut/2, SHeavyBus			
    endif
    kLast    release 
    schedkwhen kLast, 0, 0, "heavyRoadSound", 0, 1, iInstance+1 
endin 

instr fxSimpleBird
 ;apply feedback delay to the above instrument 
iInstance    =         p4					    ;receive iInstance number ... 
Sbus      sprintf   "audio_%d", iInstance		; ... and related software bus 
aAudio     chnget    Sbus				    ;receive audio on this bus 
irvbtim   random    0.5, 1				    ;find reverb time 
p3        =         p3+irvbtim				;adjust instrument duration 

imix      random    0, 1				    ;... mix audio 

iWhichPan random 0 ,5

if iWhichPan > 3 then
    kline  line	0, p3, 1 
    aL,aR     pan2      aAudio, kline				;create stereo 
else
    ipan      random    0, 1				    ; pan and ... 
    aL,aR     pan2      aAudio, ipan				;create stereo 
endif
    outs      aL/2, aR/2 
endin 

instr fxHeavyRoadSound 
 ;apply feedback delay to the above instrument 
iwhich    =         p4					    ;receive iInstance number ... 
SHeavyBus      sprintf   "audio_%d", iwhich	; ... and related software bus 
aAudio     chnget    SHeavyBus			    ;receive audio on this bus 
irvbtim   random    0.5, 1				    ;find reverb time 
p3        =         p3+irvbtim			    ;adjust instrument duration 
iltptmL   random    .1, .5				    ;find looptime left ... 
iltptmR   random    .1, .5				    ;...and right 
imix      random    0, 1				    ;... mix audio 

kline	line	0, p3, 1                    ; straight line

aL,aR     pan2      aAudio, kline		    ;create stereo 
awetL     comb      aL, irvbtim, iltptmL    ;comb filter 
awetR     comb      aR, irvbtim, iltptmR 
aoutL     ntrpol    aL, awetL, imix		    ;wet-dry mix 
aoutR     ntrpol    aR, awetR, imix 
          outs      aoutL/2, aoutR/2 
endin

instr tractor 
    ;metro 100
     ; Use the fourth p-field as the trigger.
  ktrigger = p4
  kmintim = 0
  kmaxnum = 2
  kinsnum = 2
  kwhen = 0
  kdur = 0.5

  ; Play Instrument #2 at the same time, if the trigger is set.
  schedkwhen ktrigger, kmintim, kmaxnum, "tractorCall", kwhen, kdur
endin

giSine    ftgen     0, 0, 2^10, 10, 1
instr tractorCall
    iValueToPass init 0
    iFrequencyValue = 7.00
    iAmplitudeValue = -7
    iBaseAmplitude  =         ampdbfs(iAmplitudeValue)

    iNextValue   pycall1i "getDrunkValue", iValueToPass, 10 ; need to add a limit

    aOsc1     poscil    iBaseAmplitude, iNextValue, giSine

    

    aOutPut aOsc1 * aSawMod


    ;create scale and invert to negative

    ;(bang to random to get a val >
    ;delay by 50 >
;drunk walk with a limit  of 128 and step of 5
    ;cycle object) multiply this by (saw 15  > (+~1) > (/~2))
endin

</CsInstruments>
<CsScore>
i "simpleBird" 0 1 1 
i "heavyRoadSound" 0 1 1
i "tractor" 0 1 1
</CsScore>
</CsoundSynthesizer>
