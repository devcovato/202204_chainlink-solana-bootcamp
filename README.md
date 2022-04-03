# Chainlink - Solana Developer Bootcamp 2022/04

## Table Of Contents

-   [Installation](#installation)
-   [Solana setup](#solana-setup)
-   [Day 1](#day-1)
-   [Day 2](#day-2)
-   [Resources](#resources)
-   [Known Issues](#known-issues)

## Installation

> It is assumed [vagrant](https://www.vagrantup.com/) and [VirtualBox](https://www.virtualbox.org/) 
> are already installed on Mac OS

Make sure `vagrant` has the following plugins (version at the time of writing):

-   [vagrant-bindfs](https://github.com/gael-ian/vagrant-bindfs): 1.1.9
-   [vagrant-hostmanager](https://github.com/devopsgroup-io/vagrant-hostmanager): 1.8.9
-   [vagrant-vagrant-notify-forwarder](https://github.com/mhallin/vagrant-notify-forwarder): 0.5.0
-   [vagrant-vbguest](https://github.com/dotless-de/vagrant-vbguest): 0.30.0

After booting up the VM, the required components such as `nodejs`, `rust`, `solana` will be available.

For completeness:

-   `nodejs` version: `16.14.2`
-   `rust` version: the latest available
-   `solana` version: `1.9.5`

### Editor

Preferred editor is Visual Studio Code (from here onward _VSCode_). Add extension `Remote Development`.

Connect to the VM using SSH from inside VSCode. If the VM is not listed on host file `$HOME/.ssh/config`,
add to it from VSCode itself, or manually and then refresh the list.

Open folder to `$HOME/project` and install `Rust` and any other helpful extension from inside the VM.

## Solana setup

From inside the VM, run Solana commands for checking and updating the configuration.

```shell
$ # solana configuration
$ solana config get
Config File: /home/vagrant/.config/solana/cli/config.yml
RPC URL: https://api.mainnet-beta.solana.com 
WebSocket URL: wss://api.mainnet-beta.solana.com/ (computed)
Keypair Path: /home/vagrant/.config/solana/id.json 
Commitment: confirmed

$ # set localhost network
$ solana config set --url localhost
Config File: /home/vagrant/.config/solana/cli/config.yml
RPC URL: http://localhost:8899 
WebSocket URL: ws://localhost:8900/ (computed)
Keypair Path: /home/vagrant/.config/solana/id.json 
Commitment: confirmed

$ # current local wallet
$ solana address
Error: No default signer found, run "solana-keygen new -o /home/vagrant/.config/solana/id.json" to create a new one
```

```shell
$ solana-keygen new
Generating a new keypair

For added security, enter a BIP39 passphrase

NOTE! This passphrase improves security of the recovery seed phrase NOT the
keypair file itself, which is stored as insecure plain text

BIP39 Passphrase (empty for none): 

Wrote new keypair to id-devnet.json
=======================================================================
pubkey: 4hFkodSHRQ5pbQ1RB6BhF4aLHb3mFj8K2oPp8EGk7iCe
=======================================================================
Save this seed phrase and your BIP39 passphrase to recover your new keypair:
actual cause spider robot evoke oven police hunt syrup social rice stem
=======================================================================
```

```shell
$ solana address
BxDS9s2YRihS61kkciUTN5B92z1oNqPEyi7J4BfgSGcc

$ # DON'T run solana-test-validator from inside `project` folder
$ solana-test-validator
```

From another terminal:

```shell
$ solana airdrop 100
Requesting airdrop of 100 SOL

Signature: 21eGD3RAJvChZhUYLm9KV7732MukqFNYe93wi3UG1bQFk61kBNZ71oVH9Ub2BMSnn5WjPivKFoaDKYVtCGpeTyd4

500000100 SOL
$ solana balance
500000100 SOL
```

### Restore pubkey from seed phrase

```shell
solana-keygen pubkey prompt://
[seed phrase]
[BIP39 passphrase]
```

## Day 1

-   [slides](https://drive.google.com/file/d/19j241YdwF1p2y6SP_S-HCdmsL7ds-kB4/view)
-   [exercises](https://docs.google.com/document/d/e/2PACX-1vSOgwdz9-vpBDwh3Epr3fdjzGyMWB1GHNT4H7YysNRyBFRJ0_qpcafgGcZUgNJLoyTH9IBVBaaInHsc/pub)

Exercises source code from the speaker repo:

-   `GM program` completed code [repository](https://github.com/pappas999/gm-program>)
-   `Token program` completed code [repository](https://github.com/pappas999/token-program)

## Day 2

-   [slides](https://drive.google.com/file/d/1q21-c6i_ATB4Qgtz8WIfS4lOvvC-YRvs/view)
-   [exercises](https://docs.google.com/document/d/e/2PACX-1vTm2gQPzKGtoZtTeXJGw6ux69gKDrAtiC8qD6GqWTQwfLaokAv9nnTgnGaniHOOLTZoKosRy0FgvGVy/pub)

Exercises source code from the speaker repo:

-   `GM anchor` completed code [repository](https://github.com/pappas999/gm-anchor>)
-   `Solana social` completed code [repository](https://github.com/pappas999/solana-social)
-   `Solana chainlink` completed code [repository](https://github.com/pappas999/solana-chainlink)

> NOTE
>
> 1.    _anchor_ makes use of _yarn_, replace `npm install` with `yarn add`
> 1.    it is preferred to keep _keypairs_ together, use folder `anchor` and generate a new keypair
>       like `solana-keygen new -o ./anchor/id.json` or `solana-keygen new -o ./anchor/id-devnet.json`.
> 1.    when requested to export the _wallet_, go into the folder _anchor_ and run `export ANCHOR_WALLET="$(pwd)/id.json"`

## Resources

-   <https://solanacookbook.com>
-   <https://soldev.app>
-   <https://solana.com/developers>
-   <https://book.anchor-lang.com>
-   <https://github.com/smartcontractkit/solana-starter-kit>
-   <https://chain.link/hackathon>

## Known Issues

-   `NFS is reporting that your exports file is invalid. Vagrant does
this check before making any changes to the file. Please correct
the issues below and execute "vagrant reload"`.  

    _Solution_  

    (Workaround) Remove entries from `/etc/exports`.
