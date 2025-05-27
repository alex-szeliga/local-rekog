# local-rekog
Use AWS Rekognition on images locally

## How to use:

1. use the `aws configure ssq` command and make sure your environment has the Rekognition features enabled
2. Create an `.env` file from the example and add your AWS SSO Profile Name.
3. Add the images you want to analyze into the `local_images` directory
4. Run the `tob64json.sh`, which creates a json submission with the image in base64
5. Run the `submit_rekognition.sh` script
