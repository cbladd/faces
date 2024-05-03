import cv2
import numpy as np
from PIL import Image
import os
import sys

def detect_faces(image_path, output_dir):
    # Load the classifier for frontal face
    face_cascade = cv2.CascadeClassifier(cv2.data.haarcascades + 'haarcascade_frontalface_default.xml')

    # Read the image
    img = cv2.imread(image_path)
    gray = cv2.cvtColor(img, cv2.COLOR_BGR2GRAY)

    # Detect faces in the image
    faces = face_cascade.detectMultiScale(gray, scaleFactor=1.1, minNeighbors=5, minSize=(30, 30), flags=cv2.CASCADE_SCALE_IMAGE)

    # Create output directory if it doesn't exist
    if not os.path.exists(output_dir):
        os.makedirs(output_dir)

    # Process each face found
    for count, (x, y, w, h) in enumerate(faces, start=1):
        face_img = img[y:y+h, x:x+w]
        pil_image = Image.fromarray(face_img)
        pil_image.save(f"{output_dir}/face_{count}.jpg")

    # Return the number of faces detected
    return len(faces)

if __name__ == '__main__':
    if len(sys.argv) != 3:
        print("Usage: python script.py <image_path> <output_directory>")
        sys.exit(1)

    image_path = sys.argv[1]
    output_dir = sys.argv[2]
    face_count = detect_faces(image_path, output_dir)
    print(f"Number of faces detected: {face_count}")

