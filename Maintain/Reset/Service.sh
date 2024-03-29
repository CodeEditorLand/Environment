#!/bin/bash

Current=$(\cd -- "$(\dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && \pwd)

# shellcheck disable=SC1091
\source "$Current"/../Fn/Argument.sh

Fn "$@"

for Organization in "${Organization[@]}"; do
	for Service in "${Service[@]}"; do
		# shellcheck disable=SC2154
		\cd "$Folder"/"${Service/"${Organization}/"/}" || \exit

		Upstream=$(\gh repo view --json parent | \jq -c -r '.parent.owner.login, .parent.name' | \tr -s '\r\n' '/')

		if [[ "$Upstream" != "null/null" ]]; then
			Upstream=$(\echo "$Upstream" | \sed 's/\/$//')

			\git fetch upstream --depth 1 --no-tags

			Main=$(\gh repo view --json parent | \jq -c -r '.parent.owner.login, .parent.name' | \tr -s '\r\n' '/')
			Main=$(\echo "$Main" | \sed 's/\/$//')
			Main=$(\gh repo view "$Main" --json defaultBranchRef | \jq -r -c '.defaultBranchRef.name')

			\git reset --hard upstream/"$Main"
			\git clean -dfx

			"$Current"/../Fn/Save/Service.sh

			\git push --force
		fi

		\cd - || \exit
	done
done
