# View-Synthesis 3D Gaussian Splatting (3DGS)
This repository provides an implementation of various view synthesis techniques including NeRF, 3D Gaussian Splatting (3DGS), and MipNeRF. The goal is to make it as easy as possible to get the code running. To achieve this, a Dockerfiles are provided to build a Docker image, which simplifies the setup process. Follow the steps below to successfully run 3DGS and other view synthesis techniques.

![Comparison](result/gt_rend_comparison.gif)

### Git Clone the repo
```sh
git clone https://github.com/rohitDey23/view_synthesis.git
cd view_synthesis
git checkout gaussian_splatting
```

### Build Docker Image for Gaussian Splatting (3DGS)
```sh
docker build -t view_synthesis .
```
> This might take around ~10 mins as all the dependencies are already downloaded

### Run Docker Image for Gaussian Splatting

```sh
cd model

docker run --rm -it --name view_synth --gpus all -e DISPLAY=host.docker.internal:0 -e LIBGL_ALWAYS_INDIRECT=0 --mount type=bind,src=.,dst=/home/user_dev/code_ws/model/ --runtime=nvidia view_synthesis bash
```

### Steps to Train 3DGS

### Activate the conda environment 
```sh
conda activate view_synthesis
```

### Data download: 
If data is not downloaded, download the data into the data folder (Should follow a COLMAP format)

```sh
cd data
wget https://repo-sam.inria.fr/fungraph/3d-gaussian-splatting/datasets/input/tandt_db.zip
unzip tandt_db.zip
rm tandt_db.zip
```
### Install the submodules:

```sh
pip3 install src/submodules/diff-gaussian-rasterization
pip3 install src/submodules/simple-knn
```

### Train 3DGS
```sh
cd /home/user_dev/code_ws/
python3 src/train.py -s ./data/train_data -m ./model/
```
>[!NOTE] 
>Make sure the model folder is empty. Otherwise data might be overwritten or misaarranged

### Post Trainig
The output of  the training is stored in model folder with the following files:
```sh
model/
    |_point_cloud  (consist of final .ply file)
    |_cameras.json (consists of camera locations)
    |_cfg_args (configuration files used by renderer)
    |_exposure.json (exposure settings)
    |_input.ply (input point cloud constructed)
```
Now to render the files you have to run the following code

```sh
cd /home/user_dev/code_ws/
python3 src/render.py -m ./model/
```
>[!NOTE]
> If you receive "AssertionError: Could not recognize scene type" open the cfg_args and make sure the source path is directed to the data in COLMAP format Or run the render.py with -s <path/to/data/> flag 

``` sh
python3 src/render.py -s ./data -m ./model/

```
This will create two new folders in the model dir \test and \train. The '\Ours_niter\gt' folder inside train is the ground truth data while '\Ours_niter\renders' are from the trained model.

### Visualization
I divided this part into two separate section

#### Creatingn gif from images to make it lightweigh
Run the following commands
```sh
cd /home/user_dev/code_ws/
python3 src/create_gif.py <ground/truth/path/> <renders/path/> <output/path/filename.gif> --duration 4
```
The duration signifies the frames per second. More meaanis faster and vice versa.


## Now the Results from Traning Approx ~30min (1000 iter/min)

### Results

#### Ground Truth vs Rendered
![Comparison](result/gt_rend_comparison.gif)

### Playing around with SIBR Viewers
Link for installation: [SIBR Viewers Installation](https://sibr.gitlabpages.inria.fr/?page=index.html&version=0.9.6)

You can extract the model data pointcloud and use SIBR viewer to run around the scene. Takes a little time to get used to the controls 😊

[Watch the video!!](https://github.com/rohitDey23/view_synthesis/blob/gaussian_splatting/result/real_time_rendering.mp4)

### References
This repo refers to the following github repository [3D guassian-splatting](https://github.com/graphdeco-inria/gaussian-splatting) by Bernhard Kerbl et al. Check it out for latest issues and updates.



