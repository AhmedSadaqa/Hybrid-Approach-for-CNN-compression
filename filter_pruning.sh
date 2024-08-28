#!/bin/bash
nvidia-smi

latencyratio=-1
wd=1e-4
optim=sgd
lr=0.001
lrdecayeach=10
ratio=1.0 # Ratio of used dataset
dataset=CIFAR100

resnet56(){
model=resnet
depth=56
loadmodel='/CIFAR100/resnet50/one_shot_criterion30/filterpruning/models/best_model.weights'
pruningconfig='./configs/cifar_resnet50.json'
}

resnet56

export CUDA_VISIBLE_DEVICES=0

echo 'Filter pruning ...'

for method in 30    # [0,2, 6, 22, 30] Make sure to iterate over all of them manually
do
    root='LayerThenFilter'
    dir=$root'/one_shot_criterion'$method'-finetune2' # make sure to change from finetune1 to finetune2

    echo "Checkpoint directory: " $dir
    python main.py --name=$dir --dataset=$dataset \
        --lr=$lr --lr-decay-every=$lrdecayeach --momentum=0.9 --epochs=30 --batch-size=128 \
        --pruning=True --seed=0 --model=$model'50' \
        --mgpu=False --group_wd_coeff=1e-8 --wd=$wd --tensorboard=True --pruning-method=$method \
        --data=${datasetdir} --no_grad_clip=True --pruning_config=$pruningconfig \
        --only-estimate-latency=True \
        --data=${datasetdir} --ratio $ratio --prune-latency-ratio $latencyratio \
        --load_model $loadmodel
done
