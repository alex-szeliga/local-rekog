# local-rekog
Use AWS Rekognition on images locally

## How to use:

1. use the `aws configure sso` command and make sure your environment has the Rekognition features enabled
  - The response will include your SSO profile name
2. Create an `.env` file from the example and add your AWS SSO profile name and preferred region
3. Add the images you want to analyze into the `local_images` directory
4. Run the `tob64json.sh`, which creates a json submission with the image in base64
5. Run the `submit_rekognition.sh` script
6. Using Python, run `generate_manifest.py` to generate the manifest for the viewer
7. Using Python, run `python3 -m http.server`
8. Go to `http://localhost:8000/viewer.html` in the browser to display the results
