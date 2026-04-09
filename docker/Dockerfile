FROM nvidia/cuda:12.2.2-cudnn8-devel-ubuntu22.04

# Note: Switched to 'devel' image because we need nvcc and headers to compile OpenCV
ENV DEBIAN_FRONTEND=noninteractive
ENV PYTHONUNBUFFERED=1

RUN apt-get update && apt-get install -y \
    python3.10 python3.10-dev python3-pip \
    build-essential cmake git pkg-config \
    libjpeg-dev libpng-dev libtiff-dev \
    libavcodec-dev libavformat-dev libswscale-dev \
    libv4l-dev libxvidcore-dev libx264-dev \
    libgtk-3-dev libatlas-base-dev gfortran \
    libgl1-mesa-glx ffmpeg \
    && rm -rf /var/lib/apt/lists/*

# Install Python dependencies
RUN pip install numpy

# --- Build OpenCV from Source with CUDA ---
WORKDIR /opt
RUN git clone https://github.com/opencv/opencv.git && \
    git clone https://github.com/opencv/opencv_contrib.git

RUN mkdir -p /opt/opencv/build
WORKDIR /opt/opencv/build

# Adjust CUDA_ARCH_BIN to match your specific GPU architecture (e.g., 8.9 for RTX 40-series)
RUN cmake -D CMAKE_BUILD_TYPE=RELEASE \
    -D CMAKE_INSTALL_PREFIX=/usr/local \
    -D WITH_CUDA=ON \
    -D WITH_CUDNN=ON \
    -D WITH_CUBLAS=ON \
    -D OPENCV_DNN_CUDA=ON \
    -D OPENCV_EXTRA_MODULES_PATH=/opt/opencv_contrib/modules \
    -D BUILD_opencv_python3=ON \
    -D HAVE_opencv_python3=ON \
    -D PYTHON_EXECUTABLE=/usr/bin/python3 \
    -D CUDA_ARCH_BIN=8.6,8.9 \
    -D CUDA_CUDA_LIBRARY=/usr/local/cuda/lib64/stubs/libcuda.so \
    .. && \
    make -j$(nproc) && \
    make install && \
    ldconfig

# --- Setup Application ---
WORKDIR /app
COPY ./requirements.txt /app/requirements.txt

# Remove opencv-python from requirements.txt if it's there to avoid overwriting our source build
# BASICSR_EXT=False skips CUDA extension compilation which avoids setup_requires pulling
# in a conflicting nvidia-cublas version from PyPI against the one already in the CUDA image
ENV BASICSR_EXT=False
RUN pip install --no-cache-dir --upgrade setuptools pip && \
    sed -i '/opencv-python/d' /app/requirements.txt && \
    pip install --no-cache-dir -r /app/requirements.txt

COPY Deep-Live-Cam_Dockerized/* .

ENTRYPOINT ["/bin/bash", "docker_script.sh"]