# MLAB-GPS

## TODO List

### Filter Fixes
- [ ] Fix **NCO** (`nco.sv`)
- [ ] Fix **DLL filter** (`dll_filter.sv`)
- [ ] Fix **Costas filter** (`costas_filter.sv`)

### Modifications
- [ ] Add clocking to sign function (`sign_funtion.sv`)
- [ ] Change **PRN** to 3x3 bit output (`CACODE.sv`)
- [x] Add precalers to (`costas_top.sv`) and (`dll_top.sv`)

### Additions
- [x] Add **Sine generation** (`NCO_sin.sv`)
- [x] Add a clock **Prescaler** (From 10MHz to 1KHz)

### Testbench
- [ ] Testbench the costas loop
- [ ] Testbench the Delay-Locked Loop
- [ ] Run testbench and verify outputs (FUCKING HOPE SOME SHIT SHOWS UP)

## Visuals
![image](https://github.com/user-attachments/assets/bc541fcf-d2a8-4e02-89ea-63d1a9f47da1)

![image](https://github.com/user-attachments/assets/2aaa760b-f014-4fa4-a20a-25d27227d1e1)

![Turima dalis](https://github.com/user-attachments/assets/29193e39-e2ef-4c08-a20c-f5f95e18afff)
