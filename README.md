# Custom Model Tainer - Tool Collecion
This Collecion helps to train pretrained Models from the Tensorflow Object_Detection API with custom datasets. The aim is to create a TFLITE model that can be executed on ARM ETHOS based NPUs or other NPUs on i.MX Platforms like i.MX8MP

The Tool-Colletion is based on this tutorial:
https://tensorflow-object-detection-api-tutorial.readthedocs.io/en/latest/training.html

## Install runtime dependencies
This secion describes the installation of python and other Tools on every `Linux` machines.

The exampels are run on a `F&S Development Machnine (Fedora 36)`

Due to the fact that at the current time the ARM VELA compiler is only compatible with Tensorflow 2.10, the following programs must also be installed:

* Pyhon3.9
* PIP for Python 3.9
* pycocotools
* protobuf-compiler
* tensorflow 2.10.1
* tf-models-official 2.10.1
* pandas

run follow commands to install requiered packages:

### Python 3.9
```
$ sudo dnf install python3.9
```
To avoid dependency problems with existing Python installations, we use a virtual Python environment that is only designed for the OD-API.

```
python3.9 -m venv ./python-env
```
Now load the virtual Python environment to install further dependencies into it.

```
source python-env/bin/activate
```

### protobuf-compiler
The protobuf-compiler is used to compile .proto files, which contain services and message definitions.
Compiled .proto files are used for the pipeline configuration to finetune OD-Models.
```
$ sudo dnf install protobuf-compiler
```
### pip packages
```
$ python -m pip install tensorflow=='2.10.1'
$ python -m pip install tf-models-official=='2.10.1'
$ python -m pip install pycocotools
$ python -m pip install pandas
```

### Initialize git submodules
This repo contains git submodules for Dataset creation and model Training.
```
$ git submodule init
$ git submodule update
```

### Install Tensorflow Object-Detection API
```
$ cd models/research
$ protoc object_detection/protos/*.proto --python_out=.
$ cp object_detection/packages/tf2/setup.py ./
$ python -m pip install .
```

Test installation:
```
$ python object_detection/builders/model_builder_tf2_test.py
```
## Tools
The Tool-Collection comes with 3 main parts:
* ./addons:
contains the src of labelImg, a label Tool to create a Pascal_VOC xml file for each Image and the ethos-u compiler.

* ./models: This contains the Tensorflow Model Garden. A Colletion of Tensorflow Implemenaton APIs, research collections and more.

* ./workspace: The Directory we work with. It contains our custom dataset, the pretrained models we start with and our trained models based on our own dataset.

## How to Train a Model with custom data
Let's assume there is a dataset with test and training data stored as a tensorflow record file.

The first step is to check the pipeline.conf file in model_zoo of your desired model architecture. You can find examples in ssd_mobilenet_v2 or efficentdet_lite.

start training with:
```
$ PIPELINE_CONFIG_PATH="model_zoo/ssd_mobilenet_v2_fpnlite_320x320_coco17_tpu-8/pipeline.config"
$ MODEL_DIR="training/<your_model_name>"
$ NUM_TRAIN_STEPS=1000
$ CHECKPOINT_EVERY_N=10
$ model_main_tf2.py --model_dir=$MODEL_DIR \
    --pipeline_config_path=$PIPELINE_CONFIG_PATH \
    --num_train_steps=$NUM_TRAIN_STEPS \
    --checkpoint_every_n=$CHECKPOINT_EVERY_N \
```