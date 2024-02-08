#!/bin/bash

\echo "Process: Switch/Branch/Repository.sh"

# Context: CodeEditorLand/CodeEditorLand/Stream

Directory=$(\cd -- "$(\dirname -- "${BASH_SOURCE[0]}")" &> /dev/null && \pwd)

\readarray -t Repository < "$Directory"/../../Cache/Repository/CodeEditorLand.md

for Repository in "${Repository[@]}"; do
	\cd "${Repository/'CodeEditorLand/'/}" || \exit

	\pwd

	# Upstream=$(\gh repo view --json parent | \jq -c -r '.parent.owner.login, .parent.name' | \tr -s '\r\n' '/')

	# if [[ "$Upstream" != "null/null" ]]; then
	\git switch -c repository
	\git switch repository
	\git push --set-upstream origin repository
	# fi

	\cd - || \exit
done