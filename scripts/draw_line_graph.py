import numpy as np
import matplotlib.pyplot as plt
import data_archive 

# Step 1: Your full data as one string

# Step 2: Parse data
x1 = np.fromstring(data_archive.loopfilter, sep=' ')
x2 = x1[1::2]
x1 = x1[::2]
# Step 4: Plot
plt.plot(x1, label="filtered")
plt.plot(x2, label="unfiltered")
plt.xlabel('Data index')
plt.ylabel('Power difference')
plt.legend()
plt.tight_layout()
plt.show()

