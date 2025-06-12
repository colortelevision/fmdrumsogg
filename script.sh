#!/bin/bash

# --- Configuration ---
# Set the target directory for OGG files.
# The `~` (tilde) will automatically expand to the user's home directory (e.g., /home/yourusername/music/conv_ogg).
CONVERTED_DIR="~/music/conv_ogg/"

# --- Script Logic ---
# Create the converted directory if it doesn't exist
mkdir -p "$CONVERTED_DIR"

# Loop through all specified audio file types in the current directory and subdirectories
# -print0 handles filenames with spaces or special characters safely
find . -type f \( -iname "*.mp3" -o -iname "*.wav" -o -iname "*.flac" -o -iname "*.aif" -o -iname "*.m4a" -o -iname "*.aac" \) -print0 | while IFS= read -r -d $'\0' input_file; do
    # Extract the base name without the original extension
    base_name=$(basename "${input_file%.*}")
    
    # Construct the initial output file path
    output_file_base="${CONVERTED_DIR}${base_name}.ogg"
    output_file="${output_file_base}"
    
    # Counter for unique naming in case of duplicates
    counter=1
    
    # Check if the file already exists and append a number if it does
    while [ -f "${output_file}" ]; do
        output_file="${CONVERTED_DIR}${base_name}-${counter}.ogg"
        ((counter++))
    done
    
    echo "Processing: '$input_file'"
    echo "Outputting to: '$output_file'"
    
    # Perform the conversion
    ffmpeg -i "${input_file}" "${output_file}"
    
    # Check if ffmpeg command was successful
    if [ $? -eq 0 ]; then
        echo "--> Successfully converted '$input_file'."
    else
        echo "--> Error converting '$input_file'."
    fi
    echo "--------------------------------------------------"
done

echo "Conversion process complete for all eligible files."
