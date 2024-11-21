# Using descriptors, compute the taproot address at index 100 derived from this extended public key:
#   `xpub6Cx5tvq6nACSLJdra1A6WjqTo1SgeUZRFqsX5ysEtVBMwhCCRa4kfgFqaT2o1kwL3esB1PsYr3CUdfRZYfLHJunNWUABKftK2NjHUtzDms2`
XPUB="xpub6Cx5tvq6nACSLJdra1A6WjqTo1SgeUZRFqsX5ysEtVBMwhCCRa4kfgFqaT2o1kwL3esB1PsYr3CUdfRZYfLHJunNWUABKftK2NjHUtzDms2"
FINGERPRINT="00000000"  # Replace with the actual 4-byte fingerprint for your xpub
INDEX=100
# Step 1: Construct the Taproot descriptor with correct fingerprint and derivation path
DESCRIPTOR="tr([$FINGERPRINT/86'/0'/0']$XPUB/*)"
# Step 2: Get the normalized descriptor with checksum
DESCRIPTOR_WITH_CHECKSUM=$(bitcoin-cli getdescriptorinfo "$DESCRIPTOR" | jq -r '.descriptor')
# Step 3: Derive the Taproot address within the specified range (including the desired index)
ADDRESS=$(bitcoin-cli deriveaddresses "$DESCRIPTOR_WITH_CHECKSUM" "[0,$INDEX]" | jq -r --argjson index $INDEX '.[($index)]')
echo $ADDRESS