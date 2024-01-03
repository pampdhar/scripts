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

The script also installs and runs the keychain application (based on the `Funtoo Keychain Project`: https://www.funtoo.org/Funtoo:Keychain) to manage the ssh keys on the system. 

## get_agt_int.sh

This script is a shell wrapper around the `amd-tool-install` package (https://conductor.amd.com/docs/tools/amd_tool_install) that is used for an automated install of the latest agt_internal version on the linux system.

It checks for (and skips if already present) and installs the latest version in the path: `/home/amd/tools/agt_internal`

## install_orc3.sh

This script clones and installs the latest dev version of  orchestrator3 on the linux system.

## set_shell.sh

This script is a linux system setup script that combines all the major scripts described above and calls them.