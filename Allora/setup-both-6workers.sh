#!/bin/bash

cd allora-huggingface-walkthrough/
mkdir -p ./worker-data
chmod +x init.config

cp ./config-both.json ./config.json
./init.config

cp ./worker-data/env_file ./worker-data/env_file_1
cp ./worker-data/env_file ./worker-data/env_file_2
cp ./worker-data/env_file ./worker-data/env_file_3
cp ./worker-data/env_file ./worker-data/env_file_4
cp ./worker-data/env_file ./worker-data/env_file_5
cp ./worker-data/env_file ./worker-data/env_file_6

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

    worker1:
        container_name: worker1
        image: alloranetwork/allora-offchain-node:latest
        volumes:
            - ./worker-data:/data
        depends_on:
            - inference
        env_file:
            - ./worker-data/env_file_1

    worker2:
        container_name: worker2
        image: alloranetwork/allora-offchain-node:latest
        volumes:
            - ./worker-data:/data
        depends_on:
            - inference
        env_file:
            - ./worker-data/env_file_2
    
    worker3:
        container_name: worker3
        image: alloranetwork/allora-offchain-node:latest
        volumes:
            - ./worker-data:/data
        depends_on:
            - inference
        env_file:
            - ./worker-data/env_file_3

    worker4:
        container_name: worker4
        image: alloranetwork/allora-offchain-node:latest
        volumes:
            - ./worker-data:/data
        depends_on:
            - inference
        env_file:
            - ./worker-data/env_file_4

    worker5:
        container_name: worker5
        image: alloranetwork/allora-offchain-node:latest
        volumes:
            - ./worker-data:/data
        depends_on:
            - inference
        env_file:
            - ./worker-data/env_file_5
    
    worker6:
        container_name: worker6
        image: alloranetwork/allora-offchain-node:latest
        volumes:
            - ./worker-data:/data
        depends_on:
            - inference
        env_file:
            - ./worker-data/env_file_6
  
volumes:
    inference-data:
    worker-data:
EOF
