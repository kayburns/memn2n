#!/bin/bash

GPU_IDS=( 0 1 2 )
NUM_SIMS=10

ENCODING_TYPE_OPTS="position_encoding"
SHARE_TYPE_OPTS="layerwise"
NONLIN_OPTS="relu"
DIM_MEMORY_OPTS="10 20 50"
DIM_EMB_OPTS="10 20 50"
NUM_CACHES_OPTS="1 3"
INIT_STDDEV_OPTS=0.1
LEARNING_RATE_OPTS="0.01"
MAX_GRAD_NORM_OPTS=40
NUM_HOPS_OPTS="1 2 3"
WORLD_SIZE_OPTS="large small"
#SEARCH_PROB_OPTS="0.00 0.50 1.00"
SEARCH_PROB_OPTS="1.00"
EXIT_PROB_OPTS="0.00 0.50 1.00"
INFORM_PROB_OPTS="0.00"

SHA=$(git log --pretty=format:'%h' -n 1)
DATE=`date +%Y-%m-%d`

#'export CUDA_VISIBLE_DEVICES=$(({%} - 1)) &&

parallel -j ${#GPU_IDS[@]} \
'export CUDA_VISIBLE_DEVICES=$(({%} - 1)) && \
python main.py -te -ne 100 \
-t 21 -t 22 -t 23 -t 24 -t 25 \
-nl {1} \
-et {2} \
-st {3} \
-de {4} \
-dm {5} \
-nc {6} \
-is {7} \
-lr {8} \
-gn {9} \
-nh {10} \
-d data/sally_anne/world_{11}_nex_1000_exitp_{12}_searchp_{13}_informp_{14} \
-o results/{15}' \
::: $NONLIN_OPTS   `# 1` \
::: $ENCODING_TYPE_OPTS  `# 2` \
::: $SHARE_TYPE_OPTS  `# 3` \
::: $DIM_EMB_OPTS  `# 4` \
::: $DIM_MEMORY_OPTS  `# 5` \
::: $NUM_CACHES_OPTS  `# 6` \
::: $INIT_STDDEV_OPTS  `# 7` \
::: $LEARNING_RATE_OPTS  `# 8` \
::: $MAX_GRAD_NORM_OPTS  `# 9` \
::: $NUM_HOPS_OPTS  `# 10` \
::: $WORLD_SIZE_OPTS  `# 11` \
::: $EXIT_PROB_OPTS  `# 12` \
::: $SEARCH_PROB_OPTS  `# 13` \
::: $INFORM_PROB_OPTS  `# 14` \
::: ${SHA}  `# 15` \
::: {1..$NUM_SIMS}  `# 16`
