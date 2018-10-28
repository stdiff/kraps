#!/bin/sh

docker run \
       -it \
       --name=myhadoop \
       --mount type=bind,source=/home/stdiff/Entwicklung/Docker,target=/opt,readonly \
       -p 22:22 \
       -p 4040:4040 \
       -p 8088:8088 \
       -p 50070:50070 \
       stdiff/hadoop sh /workspace/start-services.sh

