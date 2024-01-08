# scripts
Scripts for MI product execution

## set_ssh_keys.sh
This script helps create ssh keys for a linux system (only) and add them to the public (github.com) and internal AMD github account (github.amd.com) using the github API.

It requires a separate shell file to be created by the user called `ssh_config.sh` that essentially stores the user's PERSONAL ACCESS TOKENs (PATs) that will be used for the API calls. Create the personal access tokens in the respective github accounts first.

Now follow the steps below to safely store the PATs in this file on the system in a new hidden folder called `secrets` in the path `~/.secrets` and ensure the relavant permissions for the PATs.

```
mkdir -p ~/.secrets
chmod 700 ~/.secrets
touch ~/.secrets/ssh_config.sh
```
Save the PATs in the file in the format:
```
AMD_GITHUB_PUBLIC_TOKEN="<paste token here>"
AMD_GITHUB_ENTERPRISE_TOKEN="<paste token here>"
```
Set the following permissions for the `ssh_config.sh` file:
```
chmod 600 ~/.secrets/ssh_config.sh
```

The config file gets sourced once to store the PAT in environment variables to then authenticate the API calls.

Now run the script as follows:
```shell
./set_ssh_keys.sh
```

The script also installs and runs the keychain application (based on the `Funtoo Keychain Project`: https://www.funtoo.org/Funtoo:Keychain) to manage the ssh keys on the system. 

## setup_keychain.sh

This script exclusively sets up the keychain application described as part of the `set_ssh_keys.sh` script earlier. If the `set_ssh_keys.sh` scripts is run, this script is not needed. 

## get_agt_int.sh

This script is a shell wrapper around the `amd-tool-install` package (https://conductor.amd.com/docs/tools/amd_tool_install) that is used for an automated install of the latest agt_internal version on the linux system.

It checks for (and skips if already present) and installs the latest version in the path: `/home/amd/tools/agt_internal`

## install_orc3.sh

This script clones and installs the latest dev version of  orchestrator3 on the linux system.

## github_config.sh

This script helps configure the email id and name for the github accounts - needed to make commits on the linux system.

## setup_ubuntu.sh

This script does initial package installs for the ubuntu system.

## set_shell.sh

This script is a top level linux system setup script that combines all the major scripts described above and some others and calls them sequentially. Here's a list of a few scripts being invoked:
- set_ssh_keys.sh
- github_config.sh
- get_agt_int.sh
- get_powerlens.sh
- install_orc3.sh

Make sure to open the script and change/update the environment variables at the top before running the script. 