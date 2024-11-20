# How many new outputs were created by block 123,456?
bitcoin-cli getblockhash 123456 | xargs bitcoin-cli getblock | jq '.tx | length'