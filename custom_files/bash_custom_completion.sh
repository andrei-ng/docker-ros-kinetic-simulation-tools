_run_docker_images() 
{
    local cur
    COMPREPLY=()
    cur="${COMP_WORDS[COMP_CWORD]}"

    COMPREPLY=( $(compgen -W "$(docker images | awk 'FNR>1 { print $1 }')" ${cur}) )
}
complete -F _run_docker_images ./run.sh