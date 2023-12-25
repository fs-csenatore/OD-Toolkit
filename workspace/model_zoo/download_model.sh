#!/bin/bash

extract_url() {
  awk -F"[()]" '{for (i=1; i<NF; i++) if ($i ~ /^http/) print $i; exit}'
}

# Try o extract URL from tfX_detection_zoo
tf_model_url=$(grep "$1" ./tf2_detection_zoo.md | head --lines=1 | extract_url)
if [ "$tf_model_url" ]; then
  echo "Extracted TF2 model URL: $tf_model_url"
  tf_folder="tf2"
else
  echo "No TF2 model found, trying TF1 models"
  tf_model_url=$(grep "$1" ./tf1_detection_zoo.md | head --lines=1 | extract_url)
  if [ "$tf_model_url" ]; then
    echo "Extracted TF1 model URL: $tf_model_url"
    tf_folder="tf1"
  else
    echo "No model found"
    exit 1
  fi
fi

[ -d "$tf_folder" ] || mkdir "$tf_folder"

# Download and extract Model
wget "$tf_model_url" -O tmp.tar.gz
tar -xzf tmp.tar.gz -C "$tf_folder"
rm tmp.tar.gz
