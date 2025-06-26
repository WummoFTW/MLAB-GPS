import numpy as np
import matplotlib.pyplot as plt
import data_archive 

# Step 1: Your full data as one string

# Step 2: Parse data
data_values = np.fromstring(data_archive.data_16meg_1ksum_Phase8_doppler_compensated, sep=' ')
if data_values.size % 128 != 0:
    raise ValueError("Data length must be a multiple of 128.")

# Step 3: Reshape into 2D (rows = time, cols = sample number)
num_rows = data_values.size // 128
# waterfall = np.abs(data_values.reshape((num_rows, 128)))
waterfall = data_values.reshape((num_rows, 128))

# Step 4: Plot
plt.figure(figsize=(10, 6))
plt.imshow(waterfall, cmap='viridis', aspect='auto', origin='lower')
plt.colorbar(label='Amplitude')
plt.xlabel('Correlator ID')
plt.ylabel('Time Step')
plt.title('Waterfall Spectrogram (128 Correlators, accumulator of 1000, Fs = 16MHz, simulated 1.023MHz clock, Doppler compensated)')
plt.tight_layout()
plt.show()

