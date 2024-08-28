# Hybrid-Approach-for-CNN-compression


## Install Requirements
`pip install -r requirements.txt`


## Generate the importance scores for each criterion by running the following
'sh criteria.sh'


## For filter pruning, run the following
'sh filter_pruning.sh'


## For layer pruning, run the following
'sh layer_pruning.sh'


#### Make sure to pass the pruned model to the next pruning technique. In case you are doing filter pruning first, then pass the pruned model to the layer pruning script and vice versa
