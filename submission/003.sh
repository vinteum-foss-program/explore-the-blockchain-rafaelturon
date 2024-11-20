# How many new outputs were created by block 123,456?
# Step 1: Get the block hash for block 123,456
BLOCK_HASH=$(bitcoin-cli getblockhash 123456)
# Step 2: Get the block details (including transactions)
BLOCK_DETAILS=$(bitcoin-cli getblock $BLOCK_HASH 2)
# Step 3: Count the total number of outputs (vout entries) across all transactions
TOTAL_OUTPUTS=$(echo "$BLOCK_DETAILS" | jq '[.tx[].vout[]] | length')
# Response
echo $TOTAL_OUTPUTS