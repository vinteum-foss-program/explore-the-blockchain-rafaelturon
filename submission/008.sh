# Which public key signed input 0 in this tx:
#   `e5969add849689854ac7f28e45628b89f7454b83e9699e551ce14b6f90c86163`
TXID="e5969add849689854ac7f28e45628b89f7454b83e9699e551ce14b6f90c86163"
# Retrieve and decode transaction details
RAW_TX=$(bitcoin-cli getrawtransaction "$TXID")
TX_DETAILS=$(bitcoin-cli decoderawtransaction "$RAW_TX")
# Extract input 0 details
INPUT_DETAILS=$(echo "$TX_DETAILS" | jq '.vin[0]')
# Determine public key source
if echo "$INPUT_DETAILS" | jq -e '.txinwitness' > /dev/null; then
    # SegWit: Extract public key from txinwitness
    PUBKEY=$(echo "$INPUT_DETAILS" | jq -r '.txinwitness[2]' | sed -n 's/^.*6321\([0-9a-f]\{66\}\).*$/\1/p')
else
    # Legacy: Extract public key from scriptSig
    PUBKEY=$(echo "$INPUT_DETAILS" | jq -r '.scriptSig.asm' | awk '{print $2}')
fi
# Response
echo  $PUBKEY