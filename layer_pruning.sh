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
loadmodel='CIFAR100/resnet50/one_shot_criterion30/filterpruning/models/best_model.weights'
pruningconfig='./configs/cifar_resnet50.json'
}

resnet56

export CUDA_VISIBLE_DEVICES=0

for nr in 1 2
do
    echo 'Block pruning ... '$nr
    for method in 30  # make sure to iterate manually for all these values [0,2,6,22,30]
    do
        root='FilterThenLayer'
        crit='CIFAR100/resnet50/one_shot_criterion30/criteria_30_importance.pickle'  # change the criteria for every method
        dir=$root'/one_shot_criterion'$method'-finetune-'$nr

        echo "Checkpoint directory: " $dir
        python finetune.py --dataset $dataset --arch $model --depth $depth --save $dir --remove $nr --criterion $crit \
            --lr=$lr --lr-decay-every=$lrdecayeach --momentum=0.9 --epochs=30 --batch-size=128 \
            --load-model $loadmodel
    done
done
