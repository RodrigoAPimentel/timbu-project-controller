#!/bin/bash

# Usage:
# ./execution.sh {up|down} [--all] [--prune]
# 
# Examples:
# ./execution.sh up                # Start Docker containers interactively.
# ./execution.sh down              # Stop Docker containers interactively.
# ./execution.sh up --all          # Start all Docker containers.
# ./execution.sh down --all        # Stop all Docker containers.
# ./execution.sh down --all --prune # Stop all Docker containers and prune the system.

# This script is a project controller for managing Docker containers.
# It provides commands to start and stop Docker containers, with options to apply actions to all containers and prune the system.
# It sources the project name from the .env file and determines the project root directory.
# It also initializes several variables for handling actions, temporary files, and Docker options.

# Variables:
PROJECT_NAME="$(. ./.env && echo ${PROJECT_NAME})" # The name of the project, sourced from the .env file.
PROJECT_ROOT=$(git rev-parse --show-toplevel 2>/dev/null || echo "$(pwd)") # The root directory of the project, determined using git or the current working directory.
TEMPORARY_FILE=/tmp/selected_services.txt # Path to a temporary file used for storing selected services.

ACTION="" # Placeholder for the action to be executed.
ACTION_COMMAND="" # Placeholder for the command associated with the action.
ACTION_DESCRIPTION="" # Placeholder for the description of the action.
ACTION_DESCRIPTION_ALL="" # Placeholder for the description of the action when applied to all containers.
ALL_CONTAINERS=false # Boolean flag indicating whether the action should be applied to all containers.
DOCKER_PRUNE=false # Boolean flag indicating whether Docker prune should be executed.

# Prints the banner with project information.
banner () {
    printf "**************************************************************************\n"
    printf "*************************** PROJECT CONTROLLER ***************************\n"
    printf "**************************************************************************\n"
    printf "*** 📜 Developed By: Rodrigo Pimentel ************************************\n\n"
}

# Displays project information such as project name and root directory.
informations () {
    echo -e "📜  Information:"
    echo -e "   📦  Project Name: ${PROJECT_NAME}"
    echo -e "   📁  Project Root: ${PROJECT_ROOT}"
    echo ""
}

# Shows the help message with usage instructions and examples.
show_help() {
    echo "Usage: $0 {up|down} [--all] [--prune]"
    echo ""
    echo "Commands:"
    echo "  up           Start Docker containers."
    echo "  down         Stop Docker containers."
    echo ""
    echo "Options:"
    echo "  --all        Apply the action to all containers."
    echo "  --prune      Remove all unused containers, networks, images (both dangling and unreferenced), and optionally, volumes. Can only be used with 'down --all'."
    echo ""
    echo "Examples:"
    echo "  $0 up                Start Docker containers interactively."
    echo "  $0 down              Stop Docker containers interactively."
    echo "  $0 up --all          Start all Docker containers."
    echo "  $0 down --all        Stop all Docker containers."
    echo "  $0 down --all --prune Stop all Docker containers and prune the system."
    exit 0
}

# Configures parameters based on the provided command and options.
params_configurations () {
    case "$1" in
        up)
            ACTION="up";
            ACTION_COMMAND="up -d"
            ACTION_DESCRIPTION_ALL="Starting"
            ACTION_DESCRIPTION="Do you want to start"
            
            echo -e '>>>>> 🟢 🆙 Starting Docker containers ... \n'
            ;;
        down)
            ACTION="down"
            ACTION_COMMAND="down"
            ACTION_DESCRIPTION_ALL="Stopping"
            ACTION_DESCRIPTION="Do you want to stop"
            echo -e ">>>>> 🔴 ⬇️  Stopping Docker containers ...\n"
            ;;
        *)
            echo -e "⚠️    Invalid command. Use 'up' to start Docker containers or 'down' to stop them.   ⚠️"
            exit 1
            ;;
    esac
    
    if [[ "$2" == "--all" ]]; then
        ALL_CONTAINERS=true
        if [[ "$1" == "down" && "$3" == "--prune" ]]; then
            DOCKER_PRUNE=true
        elif [[ "$3" == "--prune" ]]; then
            echo -e "⚠️    Invalid command. '--prune' can only be used with 'down --all --prune'.   ⚠️"
            exit 1
        fi
    elif [[ "$2" == "--prune" ]]; then
        echo -e "⚠️    Invalid command. '--prune' can only be used with 'down --all --prune'.   ⚠️"
        exit 1
    fi
}

# Checks if a Docker container is running.
# Arguments:
#   $1 - Container name
#   $2 - Action (up or down)
check_container_running() {
    echo -e "   🔍 Checking if ${1} is running ..."
    if [[ $(docker ps --filter "name=${1}" --filter "status=running" -q) ]]; then
        if [[ "$2" == "up" ]]; then
            echo "      ❌  ${1} is already running"
            return 0
        fi
        return 1
    else
        if [[ "$2" == "down" ]]; then
            echo "      ❌  ${1} is not running"
            return 0
        fi
        return 1
    fi
}

# Prompts the user to confirm an action on a container.
# Arguments:
#   $1 - Service directory
prompt_user() {
    local attempts=0
    local srv=$(basename $1)

    while [[ $attempts -lt 3 ]]; do
        read -p "📌 $ACTION_DESCRIPTION all containers of ${srv^^}? [y/n]: " -n 1 -r response
        echo

        if [[ ${response,,} =~ ^[y]$ ]]; then
            if check_container_running $srv $ACTION; then
                break
            else
                echo ""$1"docker-compose.yml|$ACTION_DESCRIPTION_ALL|$1" >> $TEMPORARY_FILE
                break
            fi
        elif [[ ${response,,} =~ ^[n]$ ]]; then
            break
        else
            echo -e "    ⚠️  Incorrect choice. Please respond with 'y' or 'n'."
            ((attempts++))
        fi

    done
}

# Executes the specified action on a Docker container.
# Arguments:
#   $1 - Docker Compose file path
#   $2 - Action description
#   $3 - Service directory
execute_action() {
    SRV_DOCKER_NAME="$(basename $3)"
    echo -e "\n🎯 $2 ${SRV_DOCKER_NAME^^} ..."
     
    if [[ -f $1 ]]; then
        export SERVICE_FOLDER_PATH=$3
        export DOCKER_CONTAINER_PREFIX_NAME=$SRV_DOCKER_NAME

        echo -e "   📜 Service Foder Path: $SERVICE_FOLDER_PATH"
        echo -e "   📜 Docker Container Prefix Name: $DOCKER_CONTAINER_PREFIX_NAME"
        
        check_container_running $SRV_DOCKER_NAME $ACTION || docker-compose -f $1 --project-name $PROJECT_NAME --project-directory $PROJECT_ROOT $ACTION_COMMAND
    else
        echo "    ❌  File $1 not found."
    fi
}

# Main function to run the script.
# Arguments:
#   $1 - Command (up or down)
#   $2 - Option (--all or --prune)
#   $3 - Additional option (--prune)
run () {
    if [[ "$1" == "--help" ]]; then
        show_help
    else
        banner
        informations

        params_configurations $1 $2 $3

        if [[ $ALL_CONTAINERS == true ]]; then
            # Ensure proxy service is executed first
            if [[ -d "$PROJECT_ROOT/bin/proxy/" ]]; then
                execute_action "$PROJECT_ROOT/bin/proxy/docker-compose.yml" "$ACTION_DESCRIPTION_ALL" "$PROJECT_ROOT/bin/proxy/"
            fi

            for dir in $PROJECT_ROOT/bin/*/; do
                [[ "$dir" == "$PROJECT_ROOT/bin/proxy/" ]] && continue
                execute_action ""$dir"docker-compose.yml" "$ACTION_DESCRIPTION_ALL" "$dir"
            done

            if [[ $ACTION == "down" && $DOCKER_PRUNE == true ]]; then
                echo -e "\n>>>>> 🧹  Cleaning up Docker system ..."

                echo -e "\nDeleted Volumes:"
                docker volume rm $(docker volume ls -q)
                
                docker system prune -a --volumes -f 
            fi
        else
            > $TEMPORARY_FILE
            for dir in $PROJECT_ROOT/bin/*/; do
                prompt_user $dir
            done

            [[ -s $TEMPORARY_FILE ]] && echo -e "\n🚀🚀🚀 Starting actions ..."

            while IFS='|' read -r compose_file action_desc container_name; do
                execute_action "$compose_file" "$action_desc" "$container_name"
            done < $TEMPORARY_FILE
            rm $TEMPORARY_FILE
        fi
        
        echo -e "\n👋👋👋 Exiting ...";
    fi    
}

########################################
########################################

run $1 $2 $3