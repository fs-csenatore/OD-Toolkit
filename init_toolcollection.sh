#!/bin/bash

#change path to script location
cd $(dirname $0)
cwd=$PWD

#init git submodules
git submodule init
git submodule update

#apply patches
cd ./models
git apply ../addons/patches/models/*.patch

#init python environment
python3.9 -m venv ../python-env
source ../python-env/bin/activate

cd $cwd/addons
cd ./labelImg
python -m pip install .

cd ../ethos-u-vela
python -m pip install .

python -m pip install tensorflow=='2.10.1'
python -m pip install tf-models-official=='2.10.1'
python -m pip install tflite-support
python -m pip install pycocotools
python -m pip install pandas

cd $cwd/models/research
protoc object_detection/protos/*.proto --python_out=.
cp object_detection/packages/tf2/setup.py ./
python -m pip install .

#Test installation
python object_detection/builders/model_builder_tf2_test.py
