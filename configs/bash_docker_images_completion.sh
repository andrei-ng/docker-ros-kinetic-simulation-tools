# Andrei Gherghescu 23012018
# Bash completion for custom run.sh script used to launch a docker image

_docker_autocomplete_image_and_tags () {
  local cur="${COMP_WORDS[COMP_CWORD]}"
  local prev=${COMP_WORDS[COMP_CWORD-1]}

  case "${cur}" in
    :)
      # handle special case of image - tag separation
      local image_name=${COMP_WORDS[1]}
      local imageTags="$(docker images $image_name | awk 'NR>1 && $1 != "<none>" { print $2}')"
      COMPREPLY=( $(compgen -W "$imageTags" -- ""))
      ;;
    *)
      # handle cases when autocomplete is either image name or tag name
      if [ $COMP_CWORD -eq 1 ]; then
        # image name
        local reposAndTags="$(docker images | awk 'NR>1 && $1 != "<none>" { if ($2 == "latest") print $1; else print $1":"$2 }')"
        COMPREPLY=( $(compgen -W "${reposAndTags}" -- ${cur}) ); #compopt -o nospace; return 0;;
      elif [ $COMP_CWORD -eq 3 ]; then
        # tag name
        local image_name=${COMP_WORDS[1]}
        local imageTags="$(docker images $image_name | awk 'NR>1 && $1 != "<none>" { print $2}')"
        COMPREPLY=( $(compgen -W "${imageTags}" -- ${cur}))
      fi
  esac
}

complete -F _docker_autocomplete_image_and_tags ./run_docker.sh