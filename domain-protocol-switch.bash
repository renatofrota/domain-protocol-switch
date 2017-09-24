#!/bin/bash
# run like this:
# curl -sO https://raw.githubusercontent.com/renatofrota/domain-protocol-switch/master/domain-protocol-switch.bash && bash domain-protocol-switch.bash
echo -e "\n\tdomain-protocol-switch - v0.0.1 - https://github.com/renatofrota/domain-protocol-switch\n";
read -${BASH_VERSION+e}rp "Old domain (without www): " domain1;
read -${BASH_VERSION+e}rp "New domain (without www): " domain2;
while true; do
	read -${BASH_VERSION+e}rp "New protocol: http" protocol;
	if [[ "$protocol" == "" ]]; then
		break;
	else
		if [[ "$protocol" == "s" ]]; then
			break;
		else
			echo "Take it serious, please! Just hit enter (http) or 's' (https)..."
		fi
	fi
done;
while true; do
	read -${BASH_VERSION+e}rp "New domain has www? (y/N): " -n 1 prefix;
	if [[ "$prefix" =~ (1|y|Y|s|S) ]]; then
        prefix="www.";
		break;
	else
		if [[ "$prefix" =~ (0|n|N) ]]; then
			prefix="";
            break;
		else
			echo "Take it serious, please! Just hit y/n..."
		fi
	fi
done;
read -${BASH_VERSION+e}rp "Folder to scan (recommended, wp-content): " folder;
read -${BASH_VERSION+e}rp "CHECK all provided data. Press enter to proceed..." pause;
echo "Running!"
find $folder -type f -exec grep -l -E "https?://(www\.)?${domain1}" '{}' \; | xargs -I % sh -c "echo 'Found domain name on %, processing...' ; sed -i -e 's|https\?://\(www\.\)\?${domain1}|http${protocol}://${prefix}${domain2}|g' % " ;
echo "All done!"
killme() {
    [[ "$0" == "domain-protocol-switch.bash" ]] && echo -n "Self destroying... " && sleep 1 && rm -fv "$0" || echo "All done! Do not forget to remove this script.";
}
trap killme EXIT
