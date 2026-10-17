#!/usr/bin/env bash
# Uso: source run.sh && activate

_find_python () {
    local wanted
    wanted="$(tr -d '[:space:]' < .python-version 2>/dev/null)"
    wanted="${wanted:-3.12}"
    local minor="${wanted%.*}.${wanted#*.}"
    minor="$(echo "$wanted" | cut -d. -f1,2)"
    local candidates=("python${minor}" "python3.13" "python3.12" "/usr/local/bin/python3.13" "/opt/homebrew/bin/python3.12" "/opt/homebrew/bin/python3.13")
    local c
    for c in "${candidates[@]}"; do
        if command -v "$c" >/dev/null 2>&1; then
            if "$c" -c 'import sys; sys.exit(0 if sys.version_info >= (3, 12) else 1)'; then
                command -v "$c"
                return 0
            fi
        fi
    done
    return 1
}

activate () {
    if [ -d "venv" ] && ! venv/bin/python -c 'import sys; sys.exit(0 if sys.version_info >= (3, 12) else 1)' 2>/dev/null; then
        echo "El venv existente usa un Python < 3.12, se recreará"
        rm -rf venv
    fi

    if [ -d "venv" ]; then
        source venv/bin/activate
        echo "Python 🐍 environment was activated"
    else
        local py
        py="$(_find_python)" || { echo "No se encontró Python >= 3.12 (instala con pyenv/brew: $(cat .python-version))"; return 1; }
        echo "The folder environment doesn't exist, creating it with $py"
        "$py" -m venv venv || return 1
        source venv/bin/activate
        pip install --upgrade pip && pip install -r requirements.txt
        echo "The environment folder was created and the python 🐍 environment was activated"
    fi
}
