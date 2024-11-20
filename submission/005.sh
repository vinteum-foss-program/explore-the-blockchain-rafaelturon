# Create a 1-of-4 P2SH multisig address from the public keys in the four inputs of this tx:
#   `37d966a263350fe747f1c606b159987545844a493dd38d84b070027a895c4517`
TXID="37d966a263350fe747f1c606b159987545844a493dd38d84b070027a895c4517"
# Step 1: Get the raw transaction details
RAW_TX=$(bitcoin-cli getrawtransaction "$TXID" true)
# Step 2: Extract public keys from the txinwitness field
PUBKEYS=$(echo "$RAW_TX" | jq -r '.vin[].txinwitness[]' | awk 'length($0) == 66 && ($0 ~ /^02/ || $0 ~ /^03/) { print }')
# Step 3: Format public keys into a JSON array
PUBKEYS_JSON=$(echo "$PUBKEYS" | jq -R . | jq -s .)
# Step 4: Build the multisig redeem script
MULTISIG_REDEEM_SCRIPT=$(bitcoin-cli createmultisig 1 "$PUBKEYS_JSON")
# Step 5: Get the P2SH address from the redeem script
P2SH_ADDRESS=$(echo "$MULTISIG_REDEEM_SCRIPT" | jq -r '.address')
# Response
echo $P2SH_ADDRESS