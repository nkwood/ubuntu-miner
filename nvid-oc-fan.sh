#!/bin/bash
nvidia-smi -pm 1
numGPUs=nvidia-smi --query-gpu=count --format=??



c=0
while c < numGPUs; do
  echo "Target GPU is:" &
  echo ""
  echo "Allowable power range is: $min to $max."
  echo "Please enter desired power limit."



  c=$c+1
done






nvidia-smi -i 0

nvidia-smi -i 0 -pl 180

nvidia-settings -c :1 -a [gpu:0]/GPUMemoryTransferRateOffset[3]=800
nvidia-settings -c :1 -a [gpu:0]/GPUGraphicsClockOffset[3]=-200
nvidia-settings -c :1 -a [gpu:0]/GPUFanControlState=1
nvidia-settings -c :1 -a [fan:0]/GPUTargetFanSpeed=80


nvidia-smi -i 1 -pl 80
nvidia-settings -c :1 -a [gpu:1]/GPUMemoryTransferRateOffset[3]=600
nvidia-settings -c :1 -a [gpu:1]/GPUGraphicsClockOffset[3]=-100
nvidia-settings -c :1 -a [gpu:1]/GPUFanControlState=1
nvidia-settings -c :1 -a [fan:1]/GPUTargetFanSpeed=80


nvidia-smi -i 2 -pl 40

nvidia-settings -c :1 -a [gpu:2]/GPUMemoryTransferRateOffset[3]=400
nvidia-settings -c :1 -a [gpu:2]/GPUGraphicsClockOffset[3]=-200
nvidia-settings -c :1 -a [gpu:2]/GPUFanControlState=1
nvidia-settings -c :1 -a [fan:2]/GPUTargetFanSpeed=80

nvidia-smi -i 3 -pl 80

nvidia-settings -c :1 -a [gpu:3]/GPUMemoryTransferRateOffset[3]=600
nvidia-settings -c :1 -a [gpu:3]/GPUGraphicsClockOffset[3]=-200
nvidia-settings -c :1 -a [gpu:3]/GPUFanControlState=1
nvidia-settings -c :1 -a [fan:3]/GPUTargetFanSpeed=80
