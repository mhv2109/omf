# load bash profiles
if test -d /etc/profile.d
    for file in /etc/profile.d/*.sh
        bass source $file
    end
end

# Elixir & Erlang
set -Ux ERL_AFLAGS "-kernel shell_history enabled"
