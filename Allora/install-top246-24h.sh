#!/bin/bash

BOLD="\033[1m"
UNDERLINE="\033[4m"
DARK_YELLOW="\033[0;33m"
CYAN="\033[0;36m"
RESET="\033[0;32m"

source $HOME/.bash_profile

echo -e "${BOLD}${UNDERLINE}${DARK_YELLOW}Installing worker node...${RESET}"
rm -rf allora-huggingface-walkthrough
git clone https://github.com/allora-network/allora-huggingface-walkthrough.git
cd allora-huggingface-walkthrough

# model="Y"

# wget -q https://raw.githubusercontent.com/daningyn/Nodes/main/Allora/hugging-face/app.py -O ~/basic-coin-prediction-node/app.py
# wget -q https://raw.githubusercontent.com/daningyn/Nodes/main/Allora/hugging-face/main.py -O ~/basic-coin-prediction-node/main.py
# wget -q https://raw.githubusercontent.com/daningyn/Nodes/main/Allora/hugging-face/requirement.txt -O ~/basic-coin-prediction-node/requirements.txt
# wait

echo

echo -e "${BOLD}${DARK_YELLOW}Create new Wallet:${RESET}"

echo -e "${CYAN}Backup your wallet or Create new testwallet (Y/N):${RESET}"
read -p "" backupwallet
echo

if [[ "$backupwallet" =~ ^[Yy]$ ]]; then
    allorad keys add $1 --recover --keyring-backend 321321321
    wait
else
    allorad keys add $1
    wait
fi

echo -e "${BOLD}${UNDERLINE}${DARK_YELLOW}Continuce config worker node...${RESET}"

printf 'Copy mnemonic phrase & paste here to set out config file: '
read HEX

if [ -f config.json ]; then
    rm config.json
    echo "Removed existing config.json file."
fi
cat <<EOF > config.json
    {
        "wallet": {
            "addressKeyName": "${$1}",
            "addressRestoreMnemonic": "${HEX}",
            "alloraHomeDir": "",
            "gas": "1000000",
            "gasAdjustment": 1.0,
            "nodeRpc": "https://sentries-rpc.testnet-1.testnet.allora.network/",
            "maxRetries": 1,
            "delay": 1,
            "submitTx": false
        },
        "worker": [
            {
                "topicId": 2,
                "inferenceEntrypointName": "api-worker-reputer",
                "loopSeconds": 5,
                "parameters": {
                    "InferenceEndpoint": "http://inference:8000/inference/{Token}",
                    "Token": "ETH"
                }
            },
            {
                "topicId": 4,
                "inferenceEntrypointName": "api-worker-reputer",
                "loopSeconds": 5,
                "parameters": {
                    "InferenceEndpoint": "http://inference:8000/inference/{Token}",
                    "Token": "BTC"
                }
            },
            {
                "topicId": 6,
                "inferenceEntrypointName": "api-worker-reputer",
                "loopSeconds": 5,
                "parameters": {
                    "InferenceEndpoint": "http://inference:8000/inference/{Token}",
                    "Token": "SOL"
                }
            }
        ]
    }
    EOF
