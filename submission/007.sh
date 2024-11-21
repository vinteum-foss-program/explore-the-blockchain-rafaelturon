# Only one single output remains unspent from block 123,321. What address was it sent to?
# Step 1: Get the blockhash of block 123,321
BLOCKHASH=$(bitcoin-cli getblockhash 123321)
# Step 2: Fetch all transaction IDs in the block
TXIDS=$(bitcoin-cli getblock "$BLOCKHASH" | jq -r '.tx[]')
# Step 3: Loop through each transaction to find unspent outputs
UNSPENT_OUTPUT=""
ADDRESS=""
for TXID in $TXIDS; do
    # Fetch transaction details
    TX_DETAILS=$(bitcoin-cli getrawtransaction "$TXID" true)
    # Check each output (vout) in the transaction
    echo "$TX_DETAILS" | jq -c '.vout[]' | while read -r VOUT; do
        # Extract output index (vout)
        INDEX=$(echo "$VOUT" | jq -r '.n')
        # Check if the output is unspent using gettxout
        UTXO=$(bitcoin-cli gettxout "$TXID" $INDEX)
        # Check if UTXO exists and is valid
        if [ -n "$UTXO" ] && [ "$UTXO" != "null" ]; then
            UNSPENT_OUTPUT="$VOUT"
            ADDRESS=$(echo "$VOUT" | jq -r '.scriptPubKey.address')
            # Response
            echo $ADDRESS
            break 2
        fi
    done
done