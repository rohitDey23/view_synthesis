# NeRF-PyTorch

## Description

NeRF (Neural Radiance Fields) is a novel method for synthesizing novel views of complex 3D scenes. It represents a scene as a continuous volumetric scene function, parameterized by an MLP (Multi-Layer Perceptron) that maps from spatial coordinates (x, y, z) and viewing direction (θ, φ) to an emitted color and volume density. NeRF can generate high-quality novel views of a scene given a sparse set of input images. This is a light weight NeRF implementation trained on following dataset.

[LegoSet: Download the training and testing datasets](https://drive.google.com/drive/folders/18bwm-RiHETRCS5yD9G00seFIcrJHIvD-?usp=sharing)

### Setup

To set up the NeRF-PyTorch repository, follow these steps:

1. **Clone the repository:**
    ```sh
    git clone https://github.com/rohitDey23/view_synthesis.git
    cd view_synthesis
    git checkout nerf
    ```

2. **Initialize UV workspace**
    Assuming you have uv or else please follow the documnetation to [Install UV](https://docs.astral.sh/uv/getting-started/installation/). Move to the directory with pyproject.toml and execute the following command.
    ```bash
    uv sync
    ```
    This will install all the necessary dependencies

### Running

To run the NeRF model, follow these steps:

1. **Prepare your dataset:**
    Ensure you have a dataset of images and corresponding camera poses. The dataset should be organized in a specific format. You can download a sample dataset from [here](#Description).

2. **Train the model:**
    ```sh
    python src/nerf_model.py --train_pkl </path/to/training/data> --test_pkl </path/to/test/data> --output_path <path/to/outputm/model>
    ```

3. **Render novel views:**
    After training, you can render novel views using:
    ```sh
    python src/generate_gif.py --images_folder <path/to/generated/images>  --output_gif <path/to/output/gif>
    ```

### Results
The training loop is designed to save 200 images rendered by the model at the end of each epoch. The loop defaults to 16 epoch for best results. However each loop takes about ~30-45 mins on RTX 4070 thus if you want to change the Epoch numbers, you can do so in the  [src/nerf_mode.py](https://github.com/rohitDey23/view_synthesis/blob/nerf/src/nerf_model.py?plain=1#L243)

Here are the results of training the netwrok for 12 Epochs (12 hrs 😫)

![Output-GIF](https://github.com/rohitDey23/view_synthesis/blob/nerf/result/output.gif)
 
### Additional Information
If the code failed to run, there can be a problem with the setup of the environment. To verify everything is setup correctly run the following scripts to check is all the required libaries are installed working properly.

```sh
python src/test_run.py
```


## References
- [LegoSet: Download the training and testing datasets](https://drive.google.com/drive/folders/18bwm-RiHETRCS5yD9G00seFIcrJHIvD-?usp=sharing)
