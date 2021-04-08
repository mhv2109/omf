if test -d /etc/profile.d
    for file in /etc/profile.d/*.sh
        bass source $file
    end
end
