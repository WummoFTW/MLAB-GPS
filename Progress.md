# MLAB-GPS Progress

# Initial progress 03-19

### By Karolis Petrauskas

## Earlier version of GPS reciever uploaded to [GitHub](https://github.com/WummoFTW/MLAB-GPS)

It has some bugs that are being fixed right now

## Fixing some bugs in the original reciever design

![image](https://github.com/user-attachments/assets/bc541fcf-d2a8-4e02-89ea-63d1a9f47da1)

### Problems

- NCO_PRN.v file where I've found I have some unsynthesizable constructs
- The reciever still lacks control communication with the control system.
   - It is planned that the NCO_PRN will be the controlling entity communicating using one of the simple AXI intefaces.

## Built a softcore microblaze system 

I've managed to build a microblaze system and realize it in a KCU105 FPGA board. It is programmable using Vitis 2024.2 (Buggy but works)

![image](https://i.imgur.com/zIyRtOX.png)
### Features

- Communication using UART
- GPIO Inputs and Outputs (Buttons and LEDs) 
- The CPU is able communicate with 2GB of on-board DDR4 RAM

### Additional notes

- I've already wrote a python script that generated all 32 C/A code sequences 

### Problems

- The FFT tract is a very very deep rabbithole and I simply *don't know* where to start from...
- The current version of Vitis is buggy. It is annoying, but it is what it is. 

## Useful links

- [A. Holmes GPS Project](http://www.aholme.co.uk/GPS/Main.htm)
- [MLAB GPS GitHub page](https://github.com/WummoFTW/MLAB-GPS)
- [FFT with DMA explanation](https://adaptivesupport.amd.com/s/article/58582?language=en_US)
- [Funny video](https://www.youtube.com/watch?v=jb_ZAme3xjo)

# Continued Progress 03-31

Signal generation is done only in testbench right meow

|   |   |  |
|:-:|:-:|:-:|
|CA code|<b>XOR</b>|  Data |
| <i>(1.023MHz)</i>   ||  <i>(50Hz)</i> |

Accumulated 1024 samples at 10MHz

- The <b>add_ena</b> part works, the circuit became noisier but the correct branch has bigger peaks in both axes <i>(Positive and negative +/- 500)</i>
- The rest have value variation of only around -100 and +100
  Added half taps and quarter taps.
- IDK if they are working correctly, BUT it's something :)

 ## Progress 04-04

### ✅ Internal CA clock (INTERNAL CA clk in UUT)

<b>Key takeaways</b>

- CA_ref_generator now has asyncronous reset (I know its not too good, but nobody explained my why)
- Testing just got worse, tester.sv also got updated (P. S. Writing this after the fact, the tester could be the coulprit)
- Noise floor has risen (aka peaks just got lower because of the raised accumulation ammount, <i>now maximum is only +/- 256</i>)
- <b>Got a phase shift</b>

![image](https://i.imgur.com/v458XNF.png)

<b>Also, ran a test with 50 bit DDS to try to yield better accuracy</b>

![image](https://i.imgur.com/GyXM2QY.png)

SAME RESULTS, yay

So Ive just stayed with a smaller accumulation cycle.\
I dont even understand whats wrong...

For the record I went back and also did this without subtaps, same result, so it looks more like a feature at this point. yay?

![image](https://i.imgur.com/37klpAZ.png)

And yes these graphs look cool 😎\
But thats the only thing cool at this point

Ran the test with smaller accumulation cycles and still got about the same shift during the same runtime.
MAYBE SOMETHING IS JUST MAPPED WRONG, working on this right now

### ✅ simulate adc sampling in the D_in
Nothing interesting to note here

### ❌ Peak detection
WOKRING ON IT\
Right now binary reduction tree seems logical (especially when 7 bits = 128), but sinchronisation could be a real PITA

## Progress 04-08
Changed to 16MHz clock\
Trying to find phase skew problem, but DDS is still directly attached to the base frequency so without increasing the base frequency the magnitude of 62.5 ns is the best I can do\

![DDS Calculations](https://i.imgur.com/mhKd3NQ.png)

![Current state](https://i.imgur.com/V3e0Wzy.png)\
Might need a 1/8 subtap

<b><i>Kodel pasirinkau 16 velavima, bet tik rodo 16 o ne 48?</i></b>

## Progress 04-10

### Updates/Fixes
- Phase shift fixes written sources said its 1.023MHz acctually its 1.023018MHz
- Added same window correction mechanism, still need to add full window movement mechanism
