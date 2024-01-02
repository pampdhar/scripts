# scripts
Scripts for MI product execution

## set_ssh_keys.sh
This script helps create ssh keys a linux system (only) and add them to the public (github.com) and internal AMD github account (github.amd.com) using the github API.

It requires a separate shell file called `ssh_config.sh` that essentially stores the user's PERSONAL ACCESS TOKEN (PAT) that will be used for the API calls. This file needs to be in the format:

```
AMD_GITHUB_PUBLIC_TOKEN="<paste token here>"
AMD_GITHUB_ENTERPRISE_TOKEN="<paste token here>"
```
The config file gets sourced once to store the PAT in environment variables to authenticate the API calls.