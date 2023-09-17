
John van Zantvoort's bash config.

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
