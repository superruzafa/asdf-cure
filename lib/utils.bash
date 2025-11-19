#!/usr/bin/env bash

set -euo pipefail

# TODO: Ensure this is the correct GitHub homepage where releases can be downloaded for cure.
GH_REPO="https://github.com/am-kantox/cure-lang"
TOOL_NAME="cure"
TOOL_TEST="cure --help"

fail() {
	echo -e "asdf-$TOOL_NAME: $*"
	exit 1
}

curl_opts=(-fsSL)

# NOTE: You might want to remove this if cure is not hosted on GitHub releases.
if [ -n "${GITHUB_API_TOKEN:-}" ]; then
	curl_opts=("${curl_opts[@]}" -H "Authorization: token $GITHUB_API_TOKEN")
fi

sort_versions() {
	sed 'h; s/[+-]/./g; s/.p\([[:digit:]]\)/.z\1/; s/$/.z/; G; s/\n/ /' |
		LC_ALL=C sort -t. -k 1,1 -k 2,2n -k 3,3n -k 4,4n -k 5,5n | awk '{print $2}'
}

list_github_tags() {
	git ls-remote --tags --refs "$GH_REPO" |
		grep -o 'refs/tags/.*' | cut -d/ -f3- |
		sed 's/^v//' # NOTE: You might want to adapt this sed to remove non-version strings from tags
}

list_all_versions() {
	# TODO: Adapt this. By default we simply list the tag names from GitHub releases.
	# Change this function if cure has other means of determining installable versions.
	list_github_tags
}

download_release() {
	local version filename url
	version="$1"
	filename="$2"

	# TODO: Adapt the release URL convention for cure
	url="$GH_REPO/archive/v${version}.tar.gz"

	echo "* Downloading $TOOL_NAME release $version..."
	curl "${curl_opts[@]}" -o "$filename" -C - "$url" || fail "Could not download $url"
}

install_version() {
	local install_type="$1"
	local version="$2"
	local install_path="${3%/bin}"

	if [ "$install_type" != "version" ]; then
		fail "asdf-$TOOL_NAME supports release installs only"
	fi

	(
		mkdir -p "$install_path"

		local TMP_BIN=""
		if ! command -v rebar3 >/dev/null 2>&1; then
			echo "rebar3 not found, downloading temporary binary..."
			TMP_BIN=$(mktemp -d)
			trap 'rm -rf "$TMP_BIN"' EXIT
			curl -L -o "$TMP_BIN/rebar3" "https://s3.amazonaws.com/rebar3/rebar3"
			chmod +x "$TMP_BIN/rebar3"
			export PATH="$TMP_BIN:$PATH"
		fi

		cp -r "$ASDF_DOWNLOAD_PATH"/* "$install_path"

		echo "Compiling $TOOL_NAME $version..."
		cd "$install_path"
		make all

		if [ ! -f "$install_path/$TOOL_NAME" ]; then
			fail "Error compiling $TOOL_NAME"
		fi

		mkdir -p "$install_path/bin"
		cat <<EOF >>"$install_path/bin/$TOOL_NAME"
#!/usr/bin/env bash

exec "$install_path/$TOOL_NAME" "\$@"
EOF
		chmod a+x "$install_path/bin/$TOOL_NAME"

		# TODO: Assert cure executable exists.
		local tool_cmd
		tool_cmd="$(echo "$TOOL_TEST" | cut -d' ' -f1)"
		test -x "$install_path/bin/$tool_cmd" || fail "Expected $install_path/bin/$tool_cmd to be executable."

		echo "$TOOL_NAME $version installation was successful!"
	) || (
		rm -rf "$install_path"
		fail "An error occurred while installing $TOOL_NAME $version."
	)
}
