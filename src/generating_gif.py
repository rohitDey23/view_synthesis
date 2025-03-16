import glob
import os

from PIL import Image
import argparse


def generate_gif(input_folder, output_file, duration=30):
    images = load_image_name_list(input_folder)  # Sort the images by name

    # Create a list of Image objects
    frames = [Image.open(img) for img in images]

    # Save the frames as a GIF
    frames[0].save(
        output_file,
        format="GIF",
        append_images=frames[1:],
        save_all=True,
        duration=duration,
        loop=0,
    )


def load_image_name_list(file_path):
    image_path = file_path + "*png"
    image_name_list = [
        file
        for file in sorted(
            glob.glob(image_path),
            key=lambda s: int(os.path.splitext(os.path.basename(s))[0][4:]),
        )
    ]

    print(f"Total number of images: {len(image_name_list)}")
    return image_name_list


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Train a NeRF model.")
    parser.add_argument("--images_folder", type=str, required=True, help="Path to the images folder.")
    parser.add_argument("--output_gif", type=str, required=True, help="Path to save the output gif.")
    args = parser.parse_args()
    
    images_folder = args.images_folder
    output_gif = args.output_gif
    
    generate_gif(images_folder, output_gif)
