function git-ssh-keygen
    set repository_name $argv[1]
    set repository_dir (string join '' ~/.ssh/github/ $repository_name)
    set ssh_filename id_ed25519
    set private_key_path (string join '' $repository_dir / $ssh_filename)
    set public_key_path (string join '' $private_key_path .pub)

    if test -f $private_key_path
        echo The repository is already registered.
        return 1
    end

    read -l -P 'Do you want to continue? [yes/no] ' confirmation
    if not test $confirmation = yes
        return 1
    end

    mkdir -p $repository_dir
    ssh-keygen -t ed25519 -f $private_key_path -N ''

    set config_host (string join '' "Host github-" $repository_name)
    set config_host_name "HostName github.com"
    set config_user "User git"
    set config_identity_file (string join '' "IdentityFile " $private_key_path)

    set configs (string join '' $config_host "\n" "\t" $config_host_name "\n" "\t" $config_user "\n" "\t" $config_identity_file "\n" "\n")

    echo -e $configs >>~/.ssh/config

    echo -e '\npublic key:'
    eval (which cat) $public_key_path
end