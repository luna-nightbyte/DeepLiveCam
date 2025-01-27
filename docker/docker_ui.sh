#!/bin/bash


if [ -f .env ]; then
    source .env
else
    echo ".env file not found! Copy [ example.env -> .env ] and make sure all settings are correct."
    exit 1
fi

# Function to print detailed debug information
debug_info() {
    echo "----- DEBUG INFO -----"
    echo "Environment Variables:"
    echo "MANY_FACES: $MANY_FACES"
    echo "Frame Processor: $FRAME_PROCESSOR"
    echo "Max Memory: ${MAX_MEM} GB"
    echo "Threads: $THREADS"
    echo "Video Encoder: $VIDEO_ENCODER"
    echo "USE_GPU: $USE_GPU"
    echo "USE_VIDEO_ARGS: $USE_VIDEO_ARGS"
    echo "Video Quality: $VIDEO_QUALITY"

    echo "Output Paths:"
    echo "Root Output: $OUTPUT_DIR"
    echo "Source Directory: $SOURCE_FOLDER"
    echo "Target Directory: $TARGET_FOLDER"
    echo "Output Directory: $OUTPUT_FOLDER"
    echo "-----------------------"
}

# Use when processing in UI mode
ui() {
    local cmd="python3 run.py \
        --execution-threads ${THREADS} \
        --max-memory ${MAX_MEM}"

    if [[ "${USE_VIDEO_ARGS}" == true ]]; then
        cmd+=" --video-encoder ${VIDEO_ENCODER} --video-quality ${VIDEO_QUALITY}"
    fi

    if [[ "${MANY_FACES}" == true ]]; then
        cmd+=" --many-faces"
    fi
    if [[ "${USE_GPU}" != false ]]; then
        cmd+=" --execution-provider ${EXECUTION_PROVIDER}"
    fi
    
    if [[ "${DEBUG}" == true ]]; then
        echo "Running command: $cmd"
    fi
    
    eval $cmd
    
    if [[ $? -ne 0 ]]; then
        echo "Error: Command failed with exit code $?"
        exit 1
    fi
}

# Startup

mkdir -p "${OUTPUT_DIR}"

if [[ "${DEBUG}" == true ]]; then
    debug_info
fi

## Run app
ui
