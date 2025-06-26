def add_newline_after_characters(input_file, output_file):
    try:
        with open(input_file, 'r') as file:
            content = file.read()
        
        # Add a newline after every character
        modified_content = '\n'.join(content)
        
        with open(output_file, 'w') as file:
            file.write(modified_content)
        
        print(f"Processed file saved as: {output_file}")
    except Exception as e:
        print(f"An error occurred: {e}")

# Specify the input and output file paths
input_file = 'CAcoded-NODATA-56.txt'  # Replace with your input file name
output_file = 'data-NODATA-56.hex'  # Replace with your desired output file name

# Call the function
add_newline_after_characters(input_file, output_file)
