# =============================================================================
# STAGE 1: BUILDER
# Full CUDA devel image with cuDNN9 headers for compiling OpenCV and onnx.
# =============================================================================
FROM nvidia/cuda:12.2.2-devel-ubuntu22.04 AS builder

ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=Etc/UTC

RUN apt-get update && apt-get install -y \
        libcudnn9-cuda-12 \
        libcudnn9-dev-cuda-12 \
        python3.10 python3.10-dev python3-pip python3-distutils \
        build-essential cmake git pkg-config \
        libjpeg-dev libpng-dev libtiff-dev \
        libavcodec-dev libavformat-dev libswscale-dev \
        libv4l-dev libxvidcore-dev libx264-dev \
        libgtk-3-dev libatlas-base-dev gfortran \
        protobuf-compiler libprotobuf-dev \
    && rm -rf /var/lib/apt/lists/*

RUN update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.10 1 && \
    python3 -m pip install --upgrade pip

# Build onnx==1.18.0 in the builder (needs protobuf + cmake)
RUN pip install --no-cache-dir numpy "onnx==1.18.0"

# Build OpenCV from source with CUDA + cuDNN support
WORKDIR /opt
RUN git clone --depth 1 https://github.com/opencv/opencv.git && \
    git clone --depth 1 https://github.com/opencv/opencv_contrib.git

WORKDIR /opt/opencv/build
RUN cmake -D CMAKE_BUILD_TYPE=RELEASE \
          -D CMAKE_INSTALL_PREFIX=/usr/local \
          -D WITH_CUDA=ON \
          -D WITH_CUDNN=ON \
          -D WITH_CUBLAS=ON \
          -D OPENCV_DNN_CUDA=ON \
          -D OPENCV_EXTRA_MODULES_PATH=/opt/opencv_contrib/modules \
          -D BUILD_opencv_python3=ON \
          -D PYTHON_EXECUTABLE=/usr/bin/python3 \
          -D CUDA_ARCH_BIN=8.6,8.9 \
          -D CUDA_CUDA_LIBRARY=/usr/local/cuda/lib64/stubs/libcuda.so \
          .. && \
    make -j"$(nproc)" && \
    make install

# =============================================================================
# STAGE 2: RUNTIME
# cuDNN9 installed via apt, artifacts copied from builder.
# =============================================================================
FROM nvidia/cuda:12.2.2-runtime-ubuntu22.04

ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=Etc/UTC
ENV PYTHONUNBUFFERED=1
ENV BASICSR_EXT=False

RUN apt-get update && apt-get install -y \
        libcudnn9-cuda-12 \
        python3.10 python3-pip python3-distutils \
        libgl1-mesa-glx libglib2.0-0 \
        libgtk-3-0 \
        libavcodec-dev libavformat-dev libswscale-dev \
        ffmpeg \
    && rm -rf /var/lib/apt/lists/*

RUN update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.10 1 && \
    python3 -m pip install --upgrade pip

# Copy compiled OpenCV + pip packages (including onnx) from builder
COPY --from=builder /usr/local /usr/local

RUN ldconfig

WORKDIR /app
COPY ./requirements.txt /app/requirements.txt
RUN sed -i '/opencv-python/d; /^onnx==/d' /app/requirements.txt && \
    pip install --no-cache-dir -r /app/requirements.txt

RUN apt-get update && apt-get install -y \
    python3.10-tk

COPY docker/docker_cli.sh ./cli_mode.sh
COPY docker/docker_ui.sh ./ui_mode.sh

ENTRYPOINT ["/bin/bash", "cli_mode.sh"]
