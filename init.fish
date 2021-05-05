# load bash profiles
if test -d /etc/profile.d
    for file in /etc/profile.d/*.sh
        bass source $file
    end
end

# Elixir & Erlang
set -Ux ERL_AFLAGS "-kernel shell_history enabled"

# pyenv and pyenv-virtualenv init (if installed)
if test -x (which pyenv)
    status --is-interactive; and pyenv init - | source
    if test -d (pyenv root)/plugins/pyenv-virtualenv
        status --is-interactive; and pyenv virtualenv-init - | source
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
