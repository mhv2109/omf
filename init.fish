set OMF_CONFIG_PATH $HOME/.config/omf

# load bash profiles
if test -d /etc/profile.d
    for file in /etc/profile.d/*.sh
        bass source $file > /dev/null 2>&1
    end
end

# load private env vars
if test -f $OMF_CONFIG_PATH/env.fish
	source $OMF_CONFIG_PATH/env.fish
end

# Local User path
if test -d $HOME/.local/bin
	fish_add_path -a $HOME/.local/bin
end

# asdf
if test -d $HOME/.asdf
    if test -f $HOME/.asdf/asdf.fish
        source $HOME/.asdf/asdf.fish
    end
end

# .NET
if test -d $HOME/.dotnet
    if test -x $HOME/.dotnet/dotnet
        fish_add_path -a $HOME/.dotnet
	set -U DOTNET_CLI_TELEMETRY_OPTOUT true
        set -U DOTNET_ROOT $HOME/.dotnet
    end
end

# Elixir & Erlang
set -Ux ERL_AFLAGS "-kernel shell_history enabled"

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
    source $OMF_CONFIG_PATH/completions/poetry.fish
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

# Go Development
if test -x go && ! set -q GOPATH
	set -Ux GOPATH $HOME/go
end

if set -q GOPATH
	fish_add_path -a $GOPATH/bin
else if test -d $HOME/go/bin
	fish_add_path -a $HOME/go/bin
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

function dl-website -a 'index' 'path'
    if test -z $index
        echo 'missing \'index\' argument'
        return 1
    end
    if ! type -f wget
        echo 'missing \'wget\'' 
        return 1
    end
    set addlargs ''
    if test -nz $path
        set addlargs -P $path
    end
    wget \
    -e robots=off \
    --page-requisites \
    --span-hosts \
    --convert-links \
    --domains (echo $index | sed -e 's|^[^/]*//||' -e 's|/.*$||') \
    --no-parent \
    $addlargs \
    -r -p $index
end

function macos-change-background-all-desktops -a 'image'
    if test -z $image
        echo 'missing \'image\' argument'
        return 1
    end
    if ! test -e $image
        echo "No image file found at $image"
        return 1
    end
    set OS (uname)
    if [ "$OS" != 'Darwin' ]
        echo 'function requires macOS'
        return 1
    end
    osascript -e "tell application \"System Events\" to tell every desktop to set picture to \"$image\""
end