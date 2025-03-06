symc=80;
datad1 =[0;1;0;0;1;1;0;0;0;1;0;0;0;0;0;1;0;1;0;0;0;0;1;0;0;1;0;0;0;0;0;1;0;1;0;1;0;0;1;1;0;
1;0;0;1;1;0;0;0;1;0;0;0;0;0;1;0;1;0;0;0;0;1;0;0;1;0;0;0;0;0;1;0;1;0;1;0;0;1;1];
numcyc = 1600;
t=symc/50;
id=1;
gen=gnssCACode(id,"GPS");
CA1=repmat(gen,3200,1);
datad = zeros(1, length(CA1));
ddsk=1;
for i=1:length(datad1)
 for j = 1023:(1023*numcyc)/symc+1024
 datad(ddsk) = xor(datad1(i), CA1(j));
 ddsk=ddsk+1;
 end
end

sin = [1;1;0;0];
cos = [0;1;1;0];
sinM = [1;1;0;0;1;1;0;0;1;1;0;0];
numcyc = 22;
phi = 1;
sk=1;
for i=1:length(datad)
 for j=1:numcyc
 BPSK(sk)=sinM(phi);
 if phi == 4
 phi= 1;
 else
 phi = phi+1;
 end
 sk=sk+1;
 end
end

CHK1=BPSK(1,1:500000);
BPSK1=resample(BPSK,t*10*10^6,length(BPSK));

for i=1:length(BPSK1)
 if BPSK1(i) >= 0.5000
 BPSK1(i) = 1;
 else
 BPSK1(i) = 0;
 end
end

OUT=char(BPSK1 + '0');
fileID = fopen('C:\Users\baksy\Desktop\gpss\CAcoded2025_02_20_1402CA-1.bin', 'w');
fprintf(fileID, '%s\n', OUT);
fclose(fileID);
