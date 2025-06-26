import numpy as np

# Define the G2 tap settings for each PRN (1-indexed)
G2_TAPS = [
    (2, 6), (3, 7), (4, 8), (5, 9), (1, 9), (2, 10), (1, 8), (2, 9),
    (3, 10), (2, 3), (3, 4), (5, 6), (6, 7), (7, 8), (8, 9), (9, 10),
    (1, 4), (2, 5), (3, 6), (4, 7), (5, 8), (6, 9), (1, 3), (4, 6),
    (5, 7), (6, 8), (7, 9), (8, 10), (1, 6), (2, 7), (3, 8), (4, 9)
]

def generate_ca_code(prn):
    """ Generate a 1023-bit C/A code for the given PRN number (1-32) """
    # Initialize G1 and G2 shift registers with all ones
    G1 = np.ones(10, dtype=int)
    G2 = np.ones(10, dtype=int)
    ca_code = np.zeros(1023, dtype=int)

    g2_tap1, g2_tap2 = G2_TAPS[prn - 1]  # Get PRN-specific taps (1-based)

    for i in range(1023):
        # Output C/A code bit (XOR of G1[9] and G2[taps])
        ca_code[i] = G1[9] ^ (G2[g2_tap1 - 1] ^ G2[g2_tap2 - 1])

        # Shift G1 (feedback = XOR of bits 3 and 10)
        G1_feedback = G1[2] ^ G1[9]
        G1[1:] = G1[:-1]
        G1[0] = G1_feedback

        # Shift G2 (feedback = XOR of bits 2, 3, 6, 8, 9, 10)
        G2_feedback = G2[1] ^ G2[2] ^ G2[5] ^ G2[7] ^ G2[8] ^ G2[9]
        G2[1:] = G2[:-1]
        G2[0] = G2_feedback

    return ca_code

# Generate and store all PRNs
ca_codes = np.zeros((32, 1023), dtype=int)

for prn in range(1, 33):
    ca_codes[prn - 1] = generate_ca_code(prn)

# Save as a binary file (packed bits for FPGA)
ca_codes.tofile("scripts\\outputs\\ca_codes.bin")

# Also save as a readable text file
np.savetxt("scripts\\outputs\\ca_codes.txt", ca_codes, fmt='%d', delimiter='')

print("C/A codes for all 32 PRNs generated and saved.")
