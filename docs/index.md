This is my config setup which works best for me.

# Installation

Checkout the config

```sh
git clone https://github.com/jvzantvoort/jvzantvoort-bash-config.git .bashrc.d
```

Or overwrite/extend the the bashrc with:

```bash
# User specific aliases and functions
if [ -d ~/.bashrc.d ]; then
	for rc in ~/.bashrc.d/*; do
		if [ -f "$rc" ]; then
			. "$rc"
		fi
	done
fi
```

# Commands

* **aureport_yesterday**, get yesterdays aureport output
* **difftree**, diff two trees
* **git2cl**, git changelog
* **git-fix**, random commit messages for git
* **ip2hex**, get the hex string for an ip address
* **resume**, resume a tmux session
* **today**, abreviated timestamp
* **uudecode**, old style uudecode in perl
* **winapg**, wrapper for apg to generate some windows compatible * passwords
* **wpylint**, wrapper for pylint
