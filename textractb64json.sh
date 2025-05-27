#!/bin/bash

IMAGE_INPUT_DIR="./local_images"
OUTPUT_JSON_DIR="./textract_json_payloads"


BASE64_CMD="base64 -i"

# Check if the input image directory exists
if [ ! -d "$IMAGE_INPUT_DIR" ]; then
  echo "Error: Input image directory '$IMAGE_INPUT_DIR' not found." >&2
  exit 1
fi

# Create the output JSON directory if it doesn't exist
mkdir -p "$OUTPUT_JSON_DIR"
if [ ! -d "$OUTPUT_JSON_DIR" ]; then
  echo "Error: Could not create output directory '$OUTPUT_JSON_DIR'." >&2
  exit 1
fi

echo "Starting to process images in: $IMAGE_INPUT_DIR"
echo "Output JSON files will be saved in: $OUTPUT_JSON_DIR"
echo "Using base64 command: $BASE64_CMD"
echo "-------------------------------------------------"

find "$IMAGE_INPUT_DIR" -maxdepth 1 -type f \( -iname "*.jpg" -o -iname "*.jpeg" \) -print0 | while IFS= read -r -d $'\0' image_file_path; do
  # Get just the filename without the directory path
  image_filename_with_ext=$(basename "$image_file_path")
  # Get the filename without the extension (this will be the base for the JSON filename)
  base_filename="${image_filename_with_ext%.*}"

  # Define the output JSON file name and path
  output_json_file="${OUTPUT_JSON_DIR}/${base_filename}.json"

  echo "Processing '$image_filename_with_ext'..."

  base64_string=$($BASE64_CMD "$image_file_path")

  if [ $? -ne 0 ] || [ -z "$base64_string" ]; then
    echo "ERROR: Failed to encode '$image_filename_with_ext' to base64 or output was empty." >&2
    echo "-------------------------------------------------"
    continue # Skip to the next file
  fi

  # Create the JSON payload
  printf '{"Document": {"Bytes": "%s"}}' "$base64_string" > "$output_json_file"

  if [ $? -eq 0 ]; then
    echo "SUCCESS: Created Rekognition JSON payload at '$output_json_file'"
  else
    echo "ERROR: Failed to write JSON payload for '$image_filename_with_ext' to '$output_json_file'." >&2
  fi
  echo "-------------------------------------------------"
done

echo "Batch processing complete."
echo "JSON payload files are located in: $OUTPUT_JSON_DIR"
