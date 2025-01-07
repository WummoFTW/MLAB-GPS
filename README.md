# MLAB-GPS

## TODO List

### Filter Fixes
- [x] Fix **NCO** (`NCO_PRN.sv`)
- [x] Fix **DLL filter** (`dll_filter.sv`)
- [x] Fix **Costas filter** (`costas_filter.sv`)

### Modifications
- [x] Add clocking to sign function (`sign_funtion.sv`)
- [x] Add precalers to (`costas_top.sv`) and (`dll_top.sv`)

### Additions
- [x] Add **Sine generation** (`NCO_sin.sv`)
- [x] Add a clock **Prescaler** (From 10MHz to 1KHz)

### Testbench
- [x] Testbench the costas loop
- [x] Testbench the Delay-Locked Loop
- [ ] Run testbench and verify outputs 

## Visuals
### Logic diagram
![image](https://github.com/user-attachments/assets/bc541fcf-d2a8-4e02-89ea-63d1a9f47da1)
### Fix example
![image](https://github.com/user-attachments/assets/2aaa760b-f014-4fa4-a20a-25d27227d1e1)
### Elaborated design (Prototype V1)
![image](https://github.com/user-attachments/assets/1ceb7407-5271-480c-b277-bd86cc517eee)

