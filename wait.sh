#!/bin/sh

spinner() {
    pid=$1
    message=$2
    delay=0.1
    spin_chars="⠋ ⠙ ⠹ ⠸ ⠼ ⠴ ⠦ ⠧ ⠇ ⠏"

    while kill -0 "$pid" 2>/dev/null; do
        for char in $spin_chars; do
            printf "\r%s %s" "$char" "$message"
            sleep "$delay"
        done
    done
    printf "\r✔️  %s\n" "$message"
}

# Exemple d'utilisation
long_running_task() {
    sleep 5  # Simule une tâche longue
}

long_running_task &  # Lance la tâche en arrière-plan
spinner $! "Traitement en cours..."



exit;

#!/bin/bash

spinner() {
    local pid=$1
    local message=$2
    local delay=0.1
    local spin_chars=('⠋' '⠙' '⠹' '⠸' '⠼' '⠴' '⠦' '⠧' '⠇' '⠏')

    while kill -0 "$pid" 2>/dev/null; do
        for char in "${spin_chars[@]}"; do
            printf "\r%s %s" "$char" "$message"
            sleep "$delay"
        done
    done
    printf "\r✔️  %s\n" "$message"
}

# Exemple d'utilisation
long_running_task() {
    sleep 5  # Simule une tâche longue
}

long_running_task &  # Lance la tâche en arrière-plan
spinner $! "Traitement en cours..."
