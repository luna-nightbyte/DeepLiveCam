# Repository Overview
This repository is designed as an overhead solution to run various forks of [Deep-Live-Cam](https://github.com/hacksider/Deep-Live-Cam), one at a time, using [Docker](https://www.docker.com/products/docker-hub/). It contains all the necessary configurations and scripts to streamline the setup, build, and execution processes for different forks of the [Deep-Live-Cam](https://github.com/hacksider/Deep-Live-Cam). 

Special thanks to the original creator and maintainers of [Deep-Live-Cam](https://github.com/hacksider/Deep-Live-Cam) for their incredible work and dedication to developing and maintaining this powerful tool. Your contributions have made this project possible.
And special thanks to [s0md3v](https://github.com/s0md3v) for creating [Roop](https://github.com/s0md3v/roop), which laid the foundation for these projects!



## Docker
### Dockerfile: 
A Dockerfile optimized for building Docker images with CUDA version 12.8 support. 
### Docker Compose File: 
A Docker Compose configuration that allows you to manage and switch between different forks of the application seamlessly. Each fork is defined by adding the folder as a volume, making it easy to add or switch forks by modifying the Docker Compose file.

### Environment Variables (.env)
The environment variables have been moved from the bash script to the Docker Compose and Makefile, allowing for easier configuration and customization based on your needs.
- `MANY_FACES`: Set to true or false to enable or disable processing of multiple faces.
- `FRAME_PROCESSOR`: Set the type of frame processing (e.g., `face_swapper`).
- `MAX_MEM`: Maximum memory allocation for processing.
- `THREADS`: Number of threads for processing.
- `VIDEO_ENCODER`: Video encoder to use (e.g., `libx265`).
- `EXECUTION_PROVIDER`: cuda or other execution provider. (Remember to enable by setting ÙSE_GPU=true`.
- `VIDEO_QUALITY`: Set the video quality level.

## Repository Structure
### docker-compose.yml
- Users can switch between repositories by specifying the desired repo name when adding the volume.
- The volumes section ensures that necessary scripts, models, and output directories are properly mapped to the Docker containers, allowing seamless data management across different services.
## Makefile: 
The Makefile includes commands to clean up directories, download and set up models, build the Docker image, and run the application using the specified service. Users can specify the service and image directly when executing commands, adding flexibility to the setup.

### Usage
<details>
  <summary>video example</summary>
  
https://github.com/user-attachments/assets/6975f688-08a1-4c33-9727-896e6d2c3c08

</details>

#### Getting existing submodules:
- Run `make submodule-update` to download and set up the DEFAULT repositories for the application. This command clones the repository and prepares them for use.
- Do **not** use if you intend to use other forks.
#### Setting Up Models:
- Run `make setup-models` to download and set up the necessary models for the application. This command clones the model repository and prepares the models for use.
#### Running the Application:

- To run the application using the default repo ([Deep-Live-Cam-Multi-Language](https://github.com/AVGRadmin/Deep-Live-Cam-Multi-Language)), simply use the command:
```bash
xhost + # Only needed once
```
- ##### UI Mode:
```bash
make ui
```
- ##### CLI Mode:
```bash
make cli
```
- ##### Debug Mode:
`make ui-debug` or `make cli-debug`
#### Settings
<details>
  <summary>.env</summary>

#####   Outputs
These settings should be left as they are to ensure compatibility with future docker images. Possibly for changes in my own fork if you intend to use that.
```env
# Directories
APP_DIR=./Deep-Live-Cam
STARTUP_SCRIPT=./docker_script.sh
MODELS_DIR=./models
OUTPUT_DIR=./output
```
#####   App settings
These are settings you probably wanna play around with and create the best ones for your usage. 
```env
# Processor Settings
MANY_FACES=true
FRAME_PROCESSOR=face_swapper,face_enhancer

# Performance Settings
MAX_MEM=16
THREADS=4
KEEP_AUDIO=true

# Video Settings
USE_VIDEO_ARGS=false
VIDEO_QUALITY=0
VIDEO_ENCODER=libx265
KEEP_FPS=true

# GPU
USE_GPU=true
EXECUTION_PROVIDER=cuda
GPU_COUNT=1
```

</details>

#### Building the Docker Image:

- To build the Docker image with the specified CUDA version, use the make build command. You can also specify a different image name if needed:
```bash

make build [IMAGE=<image_name>]
```
#### Cleaning Up:
- Use `make clean` to clean up the models and temporary files.
- Use `make clean-all` to purge all output files generated during the application run.
#### Resetting Models:
- If you need to reset the models, you can use the `make setup_models` command, which will clean up and re-download the models.
## Adding New Forks
To add a new fork, you only need to:
1. Clone the desired fork inside the repo folder.
2. Add the volume in the Docker Compose file.
3. Make sure to have all required models.
4. Start app
   
This setup makes it easy to experiment with various forks of the application, allowing for quick changes and minimal configuration effort.

## Dependencies

To use this repository effectively, ensure that your environment meets the following dependencies:

- Docker: You need to have Docker installed on your system. Docker is used to containerize the application and its dependencies. You can install Docker from the official Docker [website](https://docs.docker.com/engine/install/).

- Docker Compose: Docker Compose is required to manage multi-container Docker applications. It allows you to define and run multi-container Docker applications. Ensure Docker Compose is installed alongside Docker. See [this](https://docs.docker.com/compose/install/).

- NVIDIA Container Toolkit: If you plan to leverage GPU resources, you need to install the NVIDIA Container Toolkit. This toolkit allows Docker to access the GPU on your system. Installation instructions are available on NVIDIA's official website.
    - Note: It is quite possible to use other cuda versions by editing the Dockerfile, but you will probably run into other dependencies that you'll have to fix.
    - Windows users see [this](https://docs.docker.com/desktop/gpu/)

- Git: [Git](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git) is required to clone the model repository and manage version control for this project. Ensure Git is installed on your system.

- A CUDA-compatible GPU: Since the application is designed to utilize CUDA, you need a GPU that supports CUDA, along with the appropriate drivers installed on your system.

- Make sure all these dependencies are installed and properly configured before running the application.


## Stars to the Moon 🚀

<a href="https://star-history.com/#luna-nightbyte/DeepLiveCam&Date">
 <picture>
   <source media="(prefers-color-scheme: dark)" srcset="https://api.star-history.com/svg?repos=luna-nightbyte/DeepLiveCam&type=Date&theme=dark" />
   <source media="(prefers-color-scheme: light)" srcset="https://api.star-history.com/svg?repos=luna-nightbyte/DeepLiveCam&type=Date" />
   <img alt="Star History Chart" src="https://api.star-history.com/svg?repos=luna-nightbyte/DeepLiveCam&type=Date" />
 </picture>
</a>
