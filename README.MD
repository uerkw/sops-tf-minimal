# `sops-tf-minimal` - A minimal repo for getting started with Terraform and SOPS

Working with Terraform on your VPS? Here's a minimal introduction to working with the [`terraform-provider-sops`](https://github.com/carlpett/terraform-provider-sops?tab=readme-ov-file) by `carlpett`


## Introduction

This repository exposes you to the workflow of using SOPS to encrypt secrets for use inside of Terraform. 

## Note for SOPS and GPG to access your keys
This is only applicable if using GPG, which is *not* recommended compared to AGE.

For some reason, the GPG agent is sometimes unreachable, as SOPS basically gets "clueless" as to where the gnupg 2.x executable is able to run from

I recommend adding this to your .bashrc: 

```
GPG_TTY=$(tty)
export GPG_TTY
```

## Note for AGE Keys

An AGE public/private key pair is the suggested approach, and a generated keypair is required.

See [this blog post](https://technotim.live/posts/secret-encryption-sops/) for a primer on using SOPS with AGE pairs.

### Basic workflow:
Generate a pub/priv key pair

```
age-keygen -o key.txt
```
Move the file into a local config folder

```
mkdir ~/.sops
mv ./key.txt ~/.sops
```

After this, it's recommended to add these lines to `.bashrc` if you plan on using this file commonly. For this tutorial, a demo AGE pub/priv key pair has been provided. You can use this export to specify the target location of the AGE key pair.

```
# Required for SOPS to find the AGE key we generated
export SOPS_AGE_KEY_FILE=$HOME/.sops/key.txt
```

Inside of the `app-secrets` folder, you will find a `.sops.yaml`. This is a configuration file, that when found inside a current working directory that SOPS is called from, can target a specific public key to encrypt files. You can copy your public key into this file, and safely commit it. Keep your private key somewhere safe. 

### On the topic of `sudo`ing:
When adding these modifications to your `.bashrc` this has been noted to not work when running your `terraform` with `sudo`. Reason being, you need to PRESERVE YOUR ENVIRONMENT, so that these environment variable exports get picked up by the sudo shell.

Run `sudo -E terraform $COMMAND` so that you can preserve your exports. Replace `$COMMAND` with the operation you wish to use.   

If you so wish, you can use multiple pub/priv key pairs, and just re-export `SOPS_AGE_KEY_FILE`. Just remember to include that `-E` flag when sudoing. 

# Viewing Output from Terraform

Terraform by default will **block** sensitive data from being output to the terminal, it will error if you do not have a `sensitive = true` in the object for the output. To view these sensitive outputs in the terminal (as you will in this testing case), run:

```
sudo -E terraform output -json
```

You will see the unencrypted version of this text. Use `terraform output -help` to see more options for reading an output variable. These outputs are stored in your `.tfstate` files, which reinforces why you may need a proper backend for your tfstate!