import os
import json

IMAGE_DIR_NAME = "local_images"
REKOGNITION_JSON_DIR_NAME = "rekognition_response_json"
TEXTRACT_JSON_DIR_NAME = "textract_response_json"
MANIFEST_FILENAME = "file_manifest.json"

def create_manifest():
    manifest_data = []

    base_dir = os.path.dirname(os.path.abspath(__file__))
    image_dir_path = os.path.join(base_dir, IMAGE_DIR_NAME)
    rekognition_json_dir_path = os.path.join(base_dir, REKOGNITION_JSON_DIR_NAME)
    textract_json_dir_path = os.path.join(base_dir, TEXTRACT_JSON_DIR_NAME)
    
    print(f"Scanning for images in: {image_dir_path}")
    print(f"Scanning for Rekognition JSON in: {rekognition_json_dir_path}")
    print(f"Scanning for Textract JSON in: {textract_json_dir_path}")

    if not os.path.isdir(image_dir_path):
        print(f"Error: Image directory '{image_dir_path}' not found.")
        return
    
    image_files = {}
    for f in os.listdir(image_dir_path):
        if f.lower().endswith(('.jpg', '.jpeg')):
            base_name = os.path.splitext(f)[0]
            image_files[base_name] = os.path.join(IMAGE_DIR_NAME, f).replace(os.sep, '/')
    
    rekognition_json_files_map = {}
    for f in os.listdir(rekognition_json_dir_path):
        if f.lower().endswith('.json'):
            base_name = os.path.splitext(f)[0]
            rekognition_json_files_map[base_name] = os.path.join(REKOGNITION_JSON_DIR_NAME, f).replace(os.sep, '/')
    
    textract_json_files_map = {}
    for f in os.listdir(textract_json_dir_path):
        if f.lower().endswith('.json'):
            base_name = os.path.splitext(f)[0]
            textract_json_files_map[base_name] = os.path.join(TEXTRACT_JSON_DIR_NAME, f).replace(os.sep, '/')

    if not image_files:
        print(f"No image files found in '{IMAGE_DIR_NAME}'")
    
    for base_name, img_path, in image_files.items():
        rekognition_json_path = rekognition_json_files_map.get(base_name)
        textract_json_path = textract_json_files_map.get(base_name)
        if rekognition_json_path or textract_json_path:
            manifest_data.append({
                "name": base_name,
                "imagePath": img_path,
                "rekognitionJsonPath": rekognition_json_path,
                "textractJsonPath": textract_json_path
            })
        else:
            print(f"Warning, no matching JSON file found for '{img_path}'")
    
    manifest_data.sort(key=lambda x: x["name"])

    manifest_file_path = os.path.join(base_dir, MANIFEST_FILENAME)
    with open(manifest_file_path, 'w') as f:
        json.dump(manifest_data, f, indent=4)
    
    print(f"'{MANIFEST_FILENAME}' created/updated with {len(manifest_data)} entries at '{manifest_file_path}'.")

if __name__ == '__main__':
    create_manifest()
