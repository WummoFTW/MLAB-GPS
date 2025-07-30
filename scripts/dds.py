#!/usr/bin/env python3

def find_dds_tuning_word(f_out, f_ref, n_bits):
    """
    Compute the DDS tuning word using rounding.
    
    :param f_out: Desired output frequency in Hz
    :param f_ref: Reference clock frequency in Hz
    :param n_bits: Width of the DDS phase accumulator (e.g., 32)
    :return: Tuning word (integer) and the actual output frequency
    """
    tuning_word_float = (f_out / f_ref) * (2 ** n_bits)
    tuning_word = round(tuning_word_float)
    actual_f_out = (tuning_word / (2 ** n_bits)) * f_ref
    return tuning_word_float, tuning_word, actual_f_out

if __name__ == "__main__":
    F_out = 22579000     # Desired output frequency (Hz)
    F_ref = 100_000_000    # Reference clock (Hz)
    N = 64                # Accumulator bits

    tuning_word_float, tuning_word, actual_f_out = find_dds_tuning_word(F_out, F_ref, N)
    print(f"Desired F_out = {F_out} Hz")
    print(f"Reference F_ref = {F_ref} Hz")
    print(f"Accumulator bits = {N}")
    print(f"Optimal Tuning Word = {tuning_word}")
    print(f"Tuning Word Error = {tuning_word_float-tuning_word}")
    print(f"Resulting Actual Frequency = {actual_f_out:.5f} Hz")
    print(f"Frequency Error = {F_out - actual_f_out:.2f} Hz")
