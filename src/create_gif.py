import argparse
import glob
import os

from PIL import Image


def create_gif(image_path1, image_path2, output_gif_path, duration=4):
    gt_list = load_image_name_list(image_path1)
    rend_list = load_image_name_list(image_path2)
    frames = []

    # Iterate through the lists of images and concatenate them
    for gt_img, rend_img in zip(gt_list, rend_list):
        # Concatenate the images horizontally
        gt = Image.open(gt_img)
        rend = Image.open(rend_img)
        result = Image.new("RGB", (gt.width + rend.width, gt.height))
        result.paste(gt, (0, 0))
        result.paste(rend, (gt.width, 0))

        # Resize the concatenated image to a fixed size (optional)
        result = result.resize((result.width // 2, result.height // 2))

        # Create a list of Image objects
        frames.append(result)

    # Save the frames as a GIF
    frames[0].save(
        output_gif_path,
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
            key=lambda s: int(os.path.splitext(os.path.basename(s))[0][:]),
        )
    ]

    return image_name_list


if __name__ == "__main__":
    # A parser to get the paths so that you can modify these paths as needed
    # Define the paths to the directories containing the images
    parser = argparse.ArgumentParser(
        description="Create a GIF from two sets of images."
    )
    parser.add_argument(
        "image_path1", type=str, help="Path to the first set of images (ground truth)."
    )
    parser.add_argument(
        "image_path2", type=str, help="Path to the second set of images (renders)."
    )
    parser.add_argument(
        "output_gif_path", type=str, help="Path to save the output GIF."
    )
    parser.add_argument(
        "--duration", type=int, default=4, help="Duration of each frame in the GIF."
    )

    args = parser.parse_args()

    create_gif(args.image_path1, args.image_path2, args.output_gif_path)
