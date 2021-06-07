# load bash profiles
if test -d /etc/profile.d
    for file in /etc/profile.d/*.sh
        bass source $file
    end
end

# load private env vars
if test -f $HOME/.config/omf/env.fish
	source $HOME/.config/omf/env.fish
end

# Elixir & Erlang
set -Ux ERL_AFLAGS "-kernel shell_history enabled"

# pyenv and pyenv-virtualenv init (if installed)
if test -x (which pyenv)
    status --is-interactive; and pyenv init - | source
    if test -d (pyenv root)/plugins/pyenv-virtualenv
        status --is-interactive; and source (pyenv virtualenv-init -|psub)
    end
end

# ESP32 Development
if test -d $HOME/.espressif
    set -Ux IDF_TOOLS_PATH $HOME/.espressif
end
if test -d $HOME/esp-idf
    set -Ux IDF_PATH $HOME/esp-idf
    function source-esp-idf
        bass source $IDF_PATH/export.sh
    end
end

# useful functions

function lower
    if isatty stdin # not a pipe or redirection
        for arg in $argv
            echo $arg | lower
        end
    else
        tr '[:upper:]' '[:lower:]' $argv
    end        
end

function upper
    if isatty stdin # not a pipe or redirection
        for arg in $argv
            echo $arg | upper
        end
    else
        tr '[:lower:]' '[:upper:]' $argv
    end 
end
