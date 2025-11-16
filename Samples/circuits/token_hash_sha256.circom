pragma circom 2.1.4;
include "sha256.circom";

template TokenHashCheckSHA256() {
    signal input token[32];
    signal input salt[32];
    signal input pubHash[256];

    signal output isValid;

    component hasher = Sha256(512);

    signal inputData[512];
    for (var i = 0; i < 32; i++) {
        inputData[i] <== token[i];
        inputData[32 + i] <== salt[i];
    }
    for (var i = 64; i < 512; i++) {
        inputData[i] <== 0;
    }

    for (var i = 0; i < 512; i++) {
        hasher.in[i] <== inputData[i];
    }

    signal comparisons[256];
    signal acc[257];

    acc[0] <== 0;
    for (var i = 0; i < 256; i++) {
        comparisons[i] <== hasher.out[i] - pubHash[i];
        acc[i + 1] <== acc[i] + comparisons[i] * comparisons[i];
    }

    signal isZero;
    isZero <== 1;
    isZero * acc[256] === 0;

    isValid <== isZero;
}

component main = TokenHashCheckSHA256();