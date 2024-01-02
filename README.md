# scripts
Scripts for MI product execution

## set_ssh_keys.sh
This script helps create ssh keys for a linux system (only) and add them to the public (github.com) and internal AMD github account (github.amd.com) using the github API.

It requires a separate shell file to be created by the user called `ssh_config.sh` that essentially stores the user's PERSONAL ACCESS TOKEN (PAT) that will be used for the API calls. Create the personal access tokens in the respective github accounts first.

The `ssh_config.sh` file needs to be in the format:

```
AMD_GITHUB_PUBLIC_TOKEN="<paste token here>"
AMD_GITHUB_ENTERPRISE_TOKEN="<paste token here>"
```
The config file gets sourced once to store the PAT in environment variables to then authenticate the API calls.