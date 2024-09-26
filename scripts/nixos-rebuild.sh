#!/usr/bin/env bash
# sourced from https://github.com/JustCoderdev/dotfiles

# Exit alt-buff
echo -ne "\033[?1049l"

pushd "${HOME}/nixos/" > /dev/null
shopt -s globstar


# Update host
if [ -f "./flake.nix" ]; then
	HOST_FLAKE=$(awk '/_hostname = / {print $3}' ./flake.nix)
	HOST_FLAKE=$(echo "${HOST_FLAKE}" | sed 's/"\(.*\)";/\1/')
else
	HOST_FLAKE=""
fi

HOST_SHELL="${HOST:-}"
HOST_INPUT="${1:-}"

## Check for input
if [ -z "${HOST_INPUT}" ]; then
	echo -e "Hostname not passed, defaulting to \033[32m#${HOST_SHELL}\033[0m"
else
	echo -e "Requested rebuild for \033[32m\"${HOST_INPUT}\"\033[0m"
	HOST_SHELL="${HOST_INPUT}"
fi

## Update flake file
if [ "${HOST_SHELL}" != "${HOST_FLAKE}" ]; then
	echo "Updating flake... (${HOST_FLAKE:---}) -> ($HOST_SHELL)"
	sudo sed -i "s/\(_hostname = \).*/\1\"${HOST_SHELL}\";/" ./flake.nix
fi


# Check differences
echo -ne "Analysing changes..."
if git diff --quiet -- ..; then  # -- ./**/*.nix
	echo -e " \033[31mNot found\033[0m"
	had_changes=false
else
	echo " Found"
	had_changes=true

	read -p 'Open diff? (y/N): ' diff_confirm
	if [[ "${diff_confirm}" == [yY] ]] || [[ "${diff_confirm}" == [yY][eE][sS] ]]; then
		git diff --word-diff=porcelain -U0 -- ..
	fi

	sudo git add ..
fi


# Rebuild system
echo -n "Rebuilding NixOS... "
echo -ne "\033[?1049h\033[H" # enter alt-buff and clear
echo "Rebuilding NixOS..."

set +o pipefail # Disable pipafail since we check ourselves
sudo nixos-rebuild switch --show-trace --flake ".#${HOST_SHELL}" 2>&1 | tee .nixos-switch.log
exit_code="${PIPESTATUS[0]}"
set -o pipefail # Re-enable pipefail

echo  -e "\n\033[34mNixOS rebuild completed\033[0m (code: $exit_code)"
echo -ne "\rExit in 3" && sleep 1
echo -ne "\rExit in 2" && sleep 1
echo -ne "\rExit in 1" && sleep 1
echo -ne "\033[?1049l" # exit alt-buff

if [[ "${exit_code}" == 0 ]]; then
	echo -e "Done\n"

	## Commit changes
	if $had_changes; then
		generation=$(sudo nix-env -p /nix/var/nix/profiles/system --list-generations | grep current | awk '{print $1}')
		message="NixOS build ${HOST_SHELL}#${generation}"
		sudo git commit -m "${message}"
		echo -e "\n\n\033[32mCommitted as ${message}\033[0m"
	fi

	echo -e "\033[34mNixOS Rebuild Completed!\033[0m\n"

else
	echo -e "\033[31mFailed\033[0m\n"

	grep --color -F "error" .nixos-switch.log
	if $had_changes; then
		sudo git restore --staged ..
	fi

	echo -ne "\n"

	read -p 'Open log? (y/N): ' log_confirm
	if [[ "${log_confirm}" == [yY] ]] || [[ "${log_confirm}" == [yY][eE][sS] ]]; then
		vim -R .nixos-switch.log
	fi
fi

shopt -u globstar
popd > /dev/null
