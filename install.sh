# Setup CUDA path
export CUDA_INSTALL_PATH=/usr/local/cuda
export PATH=$CUDA_INSTALL_PATH/bin:$PATH

# Option to selectively execute different steps
show_help() {
    echo "Usage: $0 [options]"
    echo "Options:"
    echo "  --dep           Install dependencies"
    echo "  --nvbit         Install nvbit Tracer"
    echo "  --sass          Install SASS Frontend and Simulation Engine"
    echo "  --accel-sim     Build Accel-Sim with make"
    echo "  --all           Run all steps (default)"
    echo "  -h, --help      Show this help message"
}

INSTALL_DEP=0
INSTALL_NVBIT=0
INSTALL_SASS=0
INSTALL_ACCEL_SIM=0

if [ $# -eq 0 ]; then
    INSTALL_NVBIT=1
    INSTALL_SASS=1
    INSTALL_DEP=1
    INSTALL_ACCEL_SIM=1
else
    while [[ $# -gt 0 ]]; do
        case "$1" in
            --dep)
                INSTALL_DEP=1
                ;;
            --nvbit)
                INSTALL_NVBIT=1
                ;;
            --sass)
                INSTALL_SASS=1
                ;;
            --accel-sim)
                INSTALL_ACCEL_SIM=1
                ;;
            --all)
                INSTALL_DEP=1
                INSTALL_NVBIT=1
                INSTALL_SASS=1
                INSTALL_ACCEL_SIM=1
                ;;
            -h|--help)
                show_help
                exit 0
                ;;
            *)
                echo "Unknown option: $1"
                show_help
                exit 1
                ;;
        esac
        shift
    done
fi


# # Step 0: Install dependencies
if [ $INSTALL_DEP -eq 1 ]; then
echo "DEP=$INSTALL_DEP"
    sudo apt-get install  -y wget build-essential xutils-dev bison zlib1g-dev flex \
        libglu1-mesa-dev git g++ libssl-dev libxml2-dev libboost-all-dev git g++ \
        libxml2-dev vim python-setuptools python-dev build-essential python-pip
    pip3 install pyyaml plotly psutil
fi


# # Step 1:Install nvbit Tracer
if [ $INSTALL_NVBIT -eq 1 ]; then
echo "NVBIT=$INSTALL_NVBIT"
    ./util/tracer_nvbit/install_nvbit.sh
    make -C ./util/tracer_nvbit/
fi


# # Step 2: Install SASS Frontend and Simulation Engine
if [ $INSTALL_SASS -eq 1 ]; then
echo "SASS=$INSTALL_SASS"
    pip3 install -r requirements.txt
    source ./gpu-simulator/setup_environment.sh
fi

# Step 3: Build Accel-Sim with make
if [ $INSTALL_ACCEL_SIM -eq 1 ]; then
    echo "ACCEL_SIM=$INSTALL_ACCEL_SIM"
    make -j -C ./gpu-simulator/
fi
