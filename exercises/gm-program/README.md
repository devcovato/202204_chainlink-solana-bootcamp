# Chainlink - Solana Developer Bootcamp 

## Day 1

Exercises <https://docs.google.com/document/d/e/2PACX-1vSOgwdz9-vpBDwh3Epr3fdjzGyMWB1GHNT4H7YysNRyBFRJ0_qpcafgGcZUgNJLoyTH9IBVBaaInHsc/pub>

https://github.com/pappas999/gm-program

The output after deploying Solana:

```shell
============================================================================
Recover the intermediate account's ephemeral keypair file with
`solana-keygen recover` and the following 12-word seed phrase:
============================================================================
answer story grow initial cute output bid muffin resist leopard cause across
============================================================================
To resume a deploy, pass the recovered keypair as the
[BUFFER_SIGNER] to `solana program deploy` or `solana write-buffer'.
Or to recover the account's lamports, pass it as the
[BUFFER_ACCOUNT_ADDRESS] argument to `solana program close`.
============================================================================
Error: Account allocation failed: unable to confirm transaction. This can happen in situations such as transaction expiration and insufficient fee-payer funds
```

On the second try:

```shell
=======================================================================
Recover the intermediate account's ephemeral keypair file with
`solana-keygen recover` and the following 12-word seed phrase:
=======================================================================
palm winner spare food heavy window kit anchor area light obtain degree
=======================================================================
To resume a deploy, pass the recovered keypair as the
[BUFFER_SIGNER] to `solana program deploy` or `solana write-buffer'.
Or to recover the account's lamports, pass it as the
[BUFFER_ACCOUNT_ADDRESS] argument to `solana program close`.
=======================================================================
```

Generating a new keypair

For added security, enter a BIP39 passphrase

NOTE! This passphrase improves security of the recovery seed phrase NOT the
keypair file itself, which is stored as insecure plain text

BIP39 Passphrase (empty for none): 

Wrote new keypair to /home/vagrant/.config/solana/id.json
==================================================================
pubkey: BpDD5wxYqHVxfczXCGDkKXHQNgAzrHMYHcKVetTxiAAx
==================================================================
Save this seed phrase and your BIP39 passphrase to recover your new keypair:
choice hill edge code mobile leaf avoid artwork win race rug rigid
==================================================================

https://lightcycle.xyz/zero-to-solana-first-deploy/
