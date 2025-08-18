#!/bin/bash
#
####################################################
# Copyright (c) 2025 by Manfred Rosenboom          #
# https://maroph.github.io/ (maroph@pm.me)         #
#                                                  #
# This work is licensed under a CC-BY 4.0 License. #
# https://creativecommons.org/licenses/by/4.0/     #
####################################################
COPYRIGHT="Copyright (C) 2025 Manfred Rosenboom."
LICENSE="License: CC-BY 4.0 <https://creativecommons.org/licenses/by/4.0/>"
#
declare -r SCRIPT_NAME=$(basename $0)
declare -r VERSION="0.1.0"
declare -r VERSION_DATE="17-AUG-2025"
declare -r VERSION_STRING="${SCRIPT_NAME}  ${VERSION}  (${VERSION_DATE})"
#
###############################################################################
#
SCRIPT_DIR=`dirname $0`
cwd=`pwd`
if [ "${SCRIPT_DIR}" = "." ]
then
    SCRIPT_DIR=$cwd
else
    cd ${SCRIPT_DIR}
    SCRIPT_DIR=`pwd`
    cd $cwd
fi
cwd=
unset cwd
declare -r SCRIPT_DIR
#
###############################################################################
#
export LANG="en_US.UTF-8"
#
check=1
checkOnly=0
#
###############################################################################
#
print_usage() {
    cat - <<EOT

Usage: ${SCRIPT_NAME} [option(s)] [build|deploy|serve|shut|venv]
       Call pelican to build the web site related files

Options:
  -h|--help       : show this help and exit
  -V|--version    : show version information and exit
  -c|--check-only : check for the Pelican Python3 module and exit
  -n|--no-check   : no check for needed Python3 modules

  Arguments
  build         : create the site data (default)
                  Location: output
                  (pelican)
  deploy        : create the site and push all data to branch gh-pages
                  (pelican -s ./publishconf.py)
  serve         : create the site and run the Pelican builtin development web server
                  (pelican;pelican -r -l)
  shut          : shutdown Pelican builtin development web server
                  (pkill -15 pelican)
  venv          : create the Pelican related virtual environment
                  Location: venv

EOT
}
#
###############################################################################
#
while :
do
    option=$1
    case "$1" in
        -h | --help)    
            print_usage
            exit 0
            ;;
        -V | --version)
            echo ${VERSION_STRING}
            echo "${COPYRIGHT}"
            echo "${LICENSE}"
            exit 0
            ;;
        -c | --check-only)
            checkOnly=1
            ;;
        -n | --no-check)
            check=0
            checkOnly=0
            ;;
        -*)
            echo "${SCRIPT_NAME}: '$1' : unknown option"
            exit 1
            ;;
        *)  break;;
    esac
#
    shift 1
done
#
###############################################################################
#
if [ "$1" != "" ]
then
    case "$1" in
        build)  ;;
        deploy) ;;
        serve)  ;;
        shut)
            echo "${SCRIPT_NAME}: shutdown Pelican builtin development web server"
            pkill -15 pelican || exit 1
            exit 0
            ;;
        venv)   ;;
        *)
            echo "${SCRIPT_NAME}: '$1' : unknown argument"
            exit 1
            ;;
    esac
fi
#
###############################################################################
#
cd ${SCRIPT_DIR} || exit 1
#
###############################################################################
#
if [ "$1" = "venv" ]
then
    if [ "${VIRTUAL_ENV}" != "" ]
    then
        echo "${SCRIPT_NAME}: deactivate the current virtual environment"
        echo "${SCRIPT_NAME}: \$VIRTUAL_ENV : ${VIRTUAL_ENV}"
        exit 1
    fi
#
    # create the virtual environment directory venv
    rm -fr ${SCRIPT_DIR}/venv
    echo "${SCRIPT_NAME}: python3 -m venv --prompt venv venv"
    python3 -m venv --prompt venv ${SCRIPT_DIR}/venv || exit 1
#
    # activate the virtual environment
    echo "${SCRIPT_NAME}: . venv/bin/activate"
    . ${SCRIPT_DIR}/venv/bin/activate
#
    # upgrade the basic modules
    echo "${SCRIPT_NAME}: python -m pip install --upgrade pip"
    python -m pip install --upgrade pip || exit 1
    echo "${SCRIPT_NAME}: python -m pip install --upgrade setuptools"
    python -m pip install --upgrade setuptools || exit 1
    echo "${SCRIPT_NAME}: python -m pip install --upgrade wheel"
    python -m pip install --upgrade wheel || exit 1
#
###############################################################################
#
    # https://getpelican.com/
    # https://pypi.org/project/pelican/
    # https://github.com/getpelican/pelican/
    # https://docs.getpelican.com/^
    echo "${SCRIPT_NAME}: python -m pip install --upgrade pelican[markdown]"
    python -m pip install ${proxy} --upgrade "pelican[markdown]" || exit 1
    echo ""
#
    # https://pypi.org/project/ghp-import/
    # https://github.com/c-w/ghp-import
    echo "${SCRIPT_NAME}: python -m pip install --upgrade ghp-import"
    python -m pip install ${proxy} --upgrade ghp-import || exit 1
    echo ""
#
###############################################################################
#
    echo "${SCRIPT_NAME}: python -m pip freeze >requirements.txt"
    python -m pip freeze >${SCRIPT_DIR}/venv/requirements.txt || exit 1
#
    echo ""
    echo ""
    echo "----------"
    grep -E 'ghp-import|pelican' ${SCRIPT_DIR}/venv/requirements.txt | sort
    echo "----------"
    echo ""
#
    exit 0
fi
#
###############################################################################
#
if [ "${VIRTUAL_ENV}" = "" ]
then
    echo "${SCRIPT_NAME}: no virtual environment active"
    if [ ! -d ${SCRIPT_DIR}/venv ]
    then
        echo "${SCRIPT_NAME}: directory ${SCRIPT_DIR}/venv missing"
        echo "${SCRIPT_NAME}: call first 'build venv'"
        exit 1
    fi
#
    if [ ! -r ${SCRIPT_DIR}/venv/bin/activate ]
    then
        echo "${SCRIPT_NAME}: script ${SCRIPT_DIR}/venv/bin/activate missing"
        exit 1
    fi
    echo "${SCRIPT_NAME}: use local venv directory as virtual environment"
    source ${SCRIPT_DIR}/venv/bin/activate
fi
#
###############################################################################
#
if [ ${check} -eq 1 ]
then
#
    echo "${SCRIPT_NAME}: check for needed Python modules"
    echo "----------"
    data=$(python -m pip show pelican 2>/dev/null)
    if [ $? -ne 0 ]
    then
        echo "${SCRIPT_NAME}: Python module pelican not available"
        exit 1
    fi
    echo ${data} | awk '{ printf "%s %s\n%s %s\n", $1, $2, $3, $4;}'
    echo ""
#
    data=$(python -m pip show ghp-import 2>/dev/null)
    if [ $? -ne 0 ]
    then
        echo "${SCRIPT_NAME}: Python module ghp-import not available"
        exit 1
    fi
    echo ${data} | awk '{ printf "%s %s\n%s %s\n", $1, $2, $3, $4;}'
    echo "----------"
    echo ""
#
    if [ ${checkOnly} -eq 1 ]
    then
        exit 0
    fi
#
fi
#
###############################################################################
#
if [ "$1" = "deploy" ]
then
    echo "${SCRIPT_NAME}: pelican -s ./publishconf.py"
    pelican -s ./publishconf.py || exit 1
    echo ""
#
    echo "${SCRIPT_NAME}: ghp-import --no-jekyll --push --no-history ./output"
    ghp-import --no-jekyll --push --no-history ./output || exit 1
    echo ""
    exit 0
fi
#
###############################################################################
#
if [ "$1" = "serve" ]
then
    echo "${SCRIPT_NAME}: pelican "
    pelican || exit 1
    echo ""
#
    echo "${SCRIPT_NAME}: Pelican serve ..."
    pelican --autoreload --listen &
    exit 0
fi
#
###############################################################################
#
echo "${SCRIPT_NAME}: pelican"
pelican || exit 1
echo ""
#
if [ -d ${SCRIPT_DIR}/.git ]
then
    echo "${SCRIPT_NAME}: git status"
    git status
fi
#
###############################################################################
#
exit 0
