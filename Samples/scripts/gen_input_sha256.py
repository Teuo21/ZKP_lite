import hashlib, json, random

def to_bits(byte_arr):
    bits = []
    for b in byte_arr:
        for i in range(8):
            bits.append((b >> (7 - i)) & 1)
    return bits

token_bytes = random.randbytes(32)
salt_bytes = random.randbytes(32)

combined = token_bytes + salt_bytes
hash_bytes = hashlib.sha256(combined).digest()

input_json = {
    "token": list(token_bytes),
    "salt": list(salt_bytes),
    "pubHash": to_bits(hash_bytes)
}

with open("../inputs/input.json", "w") as f:
    json.dump(input_json, f, indent=2)

with open("../inputs/token.json", "w") as f:
    json.dump({
        "token": list(token_bytes),
        "salt": list(salt_bytes),
        "hash": hash_bytes.hex()
    }, f, indent=2)

print("input.json generated.")