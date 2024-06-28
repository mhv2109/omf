# load bash profiles
if test -d /etc/profile.d
    for file in /etc/profile.d/*.sh
    	if test $file != "/etc/profile.d/which2.sh"
	   # There's an issue with command substitution in which2.sh, having trouble handling gracefully
	   bass source $file > /dev/null 2>&1
	end
    end
end

# load private env vars
if test -f $OMF_CONFIG/env.fish
	source $OMF_CONFIG/env.fish
end

# Local User path
if test -d $HOME/.local/bin
    if not contains $HOME/.local/bin $PATH
	    fish_add_path -a $HOME/.local/bin
    end
end

# pyenv and pyenv-virtualenv init (if installed)
set pyenv_path (command -v pyenv)
if test -x "$pyenv_path"
    status is-interactive; and pyenv init --path | source
    pyenv init - | source
    if test -d (pyenv root)/plugins/pyenv-virtualenv
        status --is-interactive; and source (pyenv virtualenv-init -|psub)
    end
end

# poetry autocomplete
set poetry_path (command -v poetry)
if test -x "$poetry_path"
    source $OMF_CONFIG/completions/poetry.fish
end

# ESP32 Development
if test -d $HOME/.espressif
    set -Ux IDF_TOOLS_PATH $HOME/.espressif
end
if test -d $HOME/esp/esp-idf
    set -Ux IDF_PATH $HOME/esp/esp-idf
    function source-esp-idf
        bass source $IDF_PATH/export.sh
    end
end

# Go Development
if test -x go && ! set -q GOPATH
	set -Ux GOPATH $HOME/go
end

if set -q GOPATH
	fish_add_path -a $GOPATH/bin
else if test -d $HOME/go/bin
	fish_add_path -a $HOME/go/bin
end
