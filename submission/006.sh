# Which tx in block 257,343 spends the coinbase output of block 256,128?
# Step 1: Define blockhash for block 256,128 and 257,343 (can be replaced with actual block hashes)
BLOCKHASH_256128=$(bitcoin-cli getblockhash 256128)
BLOCKHASH_257343=$(bitcoin-cli getblockhash 257343)
# Step 2: Get the coinbase transaction ID from block 256,128 using blockhash
COINBASE_TXID=$(bitcoin-cli getblock "$BLOCKHASH_256128" | jq -r '.tx[0]')
# Step 3: Fetch all transactions in block 257,343 using blockhash
TXS_IN_BLOCK=$(bitcoin-cli getblock "$BLOCKHASH_257343" | jq -r '.tx[]')
# Step 4: Check which transaction spends the coinbase TXID
SPENDING_TX=""
for TX in $TXS_IN_BLOCK; do
    # Fetch transaction details
    TX_DETAILS=$(bitcoin-cli getrawtransaction "$TX" true)    
    # Check each input of the transaction
    SPENDS_COINBASE=$(echo "$TX_DETAILS" | jq --arg COINBASE "$COINBASE_TXID" '
        .vin[] | select(.txid == $COINBASE)
    ')   
    if [ -n "$SPENDS_COINBASE" ]; then
        SPENDING_TX="$TX"
        break
    fi
done
# Response
echo $SPENDING_TX