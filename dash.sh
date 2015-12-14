#!/usr/local/bin/bash

# default keys we care about
DEF_VALID_KEYS=(
    "PATH" 
    "SHELL"
    "LSCOLORS"
    "USER"
    "CLICOLOR"
    "PS1"
    "LOGNAME"
    "HOME"
    "PWD")
# the keys we actually care about (may be overridden with config file)
VALID_KEYS=()
LOCAL_ENV=()
DASH_DIR="$HOME/.dash"
KEYS_FILE_NAME="profile"
KEYS_FILE="$DASH_DIR/$KEYS_FILE_NAME"
ARG_HELP="h"
ARG_VIEW="ls"
ARG_LOAD="l"
ARG_SAVE="s"
ARG_DELETE="rm"

function usage() { 
    echo "usage: "
    echo "    dash [$ARG_HELP help | $ARG_VIEW list | $ARG_LOAD load | $ARG_SAVE save | $ARG_DELETE delete] [name]"
}

function init() {
    initProfile
    setValidKeys
    setCurrentEnvironment
}

function initProfile() {
    # create home directory for all files
    if [ ! -d $DASH_DIR ]; then 
        mkdir $DASH_DIR
    fi

    # create profile file
    if [ ! -f $KEYS_FILE ]; then 
        for i in "${DEF_VALID_KEYS[@]}"
        do
            echo $i >> $KEYS_FILE
        done
    fi
}

function setValidKeys() {
    while IFS= read -r line ; do
        VALID_KEYS+=($line)
    done < <(cat $KEYS_FILE)
}

function setCurrentEnvironment() {
    while IFS= read -r line ; do
        # each line can be broken by the `=` char
        IFS='=' 
        read -r key val <<< "$line"
        IFS=

        # if the key is valid then append to the list
        if [[ " ${VALID_KEYS[@]} " =~ " ${key} " ]]; 
            then LOCAL_ENV+=($line)
        fi
    done < <(printenv)
} 

function save() {
    file="$DASH_DIR/$1"

    for i in "${LOCAL_ENV[@]}"
    do
        IFS='=' 
        read -r key val <<< "$i"
        IFS=
        echo "$key=$val" >> $file
    done

    echo "dash saved as '$1'"
}

function runScripts() {
    if [ -d ".git" ]; then
        if [[ $(git branch -r) != "" ]]; then eval "git pull"
        fi
    fi
}

function load() {
    file="$DASH_DIR/$1"
    if [ -f $file ]; then 
        while IFS= read -r line ; do
            IFS='=' 
            read -r key val <<< "$line"
            IFS=

            # check the key is valid
            if [[ " ${VALID_KEYS[@]} " =~ " ${key} " ]]; then 
                export $line
            fi

            if [[ $key == "PWD" ]]; then
                eval "cd '$val'"
            fi
        done < <(cat $file)

        runScripts
        echo "'$1' dash loaded"
        else echo "'$1' dash not found"
    fi
}

function delete() {
    file="$DASH_DIR/$1"
    if [ -f $file ]; then 
        rm $file
        echo "'$1' dash deleted"
    else echo "'$1' dash not found"
    fi
}

function getPwdForEnv() {
    while IFS= read -r line ; do
        # each line can be broken by the `=` char
        IFS='=' 
        read -r key val <<< "$line"
        IFS=
        if [[ $key == "PWD" ]]; 
            then echo $val; return;
        fi
    done < <(cat $DASH_DIR/$1)
}

function list() {
    FOUND=0

    while IFS= read -r line ; do
        # if the key is valid then append to the list
        if [[ $line != "$KEYS_FILE_NAME" ]]; 
            then filePwd=$(getPwdForEnv $line)
                 folder=$(echo $filePwd | sed 's#.*/##')

                 printf "%-10s | %-0s/\n" $line $folder 
                 FOUND=1
        fi
    done < <(ls $DASH_DIR)

    if [[ $FOUND == 0 ]];
        then echo "No dash profiles have been saved"
    fi
}

function main() {

    if [[ $# == 0 ]];
        then usage
             return
    fi

    init
    case $1 in
        $ARG_SAVE)
            if [[ ($# != 2) ]]; then usage; return; fi
            save $2
            ;;    
        $ARG_LOAD)
            if [[ ($# != 2) ]]; then usage; return; fi
            load $2
            ;;
        $ARG_DELETE)
            if [[ ($# != 2) ]]; then usage; return; fi
            delete $2
            ;;
        $ARG_VIEW)
            list
            ;;
        $ARG_HELP)
            usage
            return
            ;;
        *)
            load $1
            return
    esac
}

main $@
unset DEF_VALID_KEYS
unset VALID_KEYS
unset LOCAL_ENV
unset DASH_DIR
unset KEYS_FILE_NAME
unset KEYS_FILE
unset ARG_DELETE
unset ARG_SAVE
unset ARG_LOAD
unset ARG_VIEW
unset ARG_HELP

