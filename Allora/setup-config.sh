#!/bin/bash

cd allora-huggingface-walkthrough/
mkdir -p ./worker-data
chmod +x init.config

cp ./config-10.json ./config.json
./init.config

cp ./worker-data/env_file ./worker-data/env_file_1
cp ./worker-data/env_file ./worker-data/env_file_2
cp ./worker-data/env_file ./worker-data/env_file_3

cp ./config-20.json ./config.json
./init.config

cp ./worker-data/env_file ./worker-data/env_file_4
cp ./worker-data/env_file ./worker-data/env_file_5
cp ./worker-data/env_file ./worker-data/env_file_6
cp ./worker-data/env_file ./worker-data/env_file_7
cp ./worker-data/env_file ./worker-data/env_file_8
cp ./worker-data/env_file ./worker-data/env_file_9

rm -rf ./worker-data/env_file

rm -rf docker-compose.yaml

cat <<EOF > docker-compose.yaml
services:
    inference:
        container_name: inference-hf
        build:
            context: .
            dockerfile: Dockerfile
        command: python -u /app/app.py
        ports:
            - "8000:8000"

    worker101:
        container_name: worker101
        image: alloranetwork/allora-offchain-node:latest
        volumes:
            - ./worker-data:/data
        depends_on:
            - inference
        env_file:
            - ./worker-data/env_file_1

    worker102:
        container_name: worker102
        image: alloranetwork/allora-offchain-node:latest
        volumes:
            - ./worker-data:/data
        depends_on:
            - inference
        env_file:
            - ./worker-data/env_file_2
    
    worker103:
        container_name: worker103
        image: alloranetwork/allora-offchain-node:latest
        volumes:
            - ./worker-data:/data
        depends_on:
            - inference
        env_file:
            - ./worker-data/env_file_3

    worker201:
        container_name: worker201
        image: alloranetwork/allora-offchain-node:latest
        volumes:
            - ./worker-data:/data
        depends_on:
            - inference
        env_file:
            - ./worker-data/env_file_4

    worker202:
        container_name: worker202
        image: alloranetwork/allora-offchain-node:latest
        volumes:
            - ./worker-data:/data
        depends_on:
            - inference
        env_file:
            - ./worker-data/env_file_5
    
    worker203:
        container_name: worker203
        image: alloranetwork/allora-offchain-node:latest
        volumes:
            - ./worker-data:/data
        depends_on:
            - inference
        env_file:
            - ./worker-data/env_file_6

    worker204:
        container_name: worker204
        image: alloranetwork/allora-offchain-node:latest
        volumes:
            - ./worker-data:/data
        depends_on:
            - inference
        env_file:
            - ./worker-data/env_file_7

    worker205:
        container_name: worker205
        image: alloranetwork/allora-offchain-node:latest
        volumes:
            - ./worker-data:/data
        depends_on:
            - inference
        env_file:
            - ./worker-data/env_file_8
    
    worker206:
        container_name: worker206
        image: alloranetwork/allora-offchain-node:latest
        volumes:
            - ./worker-data:/data
        depends_on:
            - inference
        env_file:
            - ./worker-data/env_file_9
  
volumes:
    inference-data:
    worker-data:
EOF
