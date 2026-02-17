#!/usr/bin/env bash
set -e

# -----------------------------
# DEFAULT CONFIGURATION
# -----------------------------
PROJECT_DIR="$(pwd)"
EMULATOR_NAME="Medium_Phone_API_36.1"
JAVA_VERSION="17.0.12-tem"
TMUX_SESSION="tauri-dev"
GRADLE_VERSION="8.14.3"

# -----------------------------
# USAGE FUNCTION
# -----------------------------
usage() {
    echo "Usage: $0 [-e emulator_name] [-j java_version] [-t tmux_session] [-p project_dir] [-s steps]"
    echo ""
    echo "Options:"
    echo "  -e  Android emulator (AVD) name (default: $EMULATOR_NAME)"
    echo "  -j  Java version via SDKMAN (default: $JAVA_VERSION)"
    echo "  -t  Tmux session name (default: $TMUX_SESSION)"
    echo "  -p  Project directory (default: current directory)"
    echo "  -s  Comma-separated steps to run (options: tmux,java,emulator,tauri)"
    echo "      Example: -s emulator,tauri  (runs only emulator and tauri dev server)"
    exit 1
}

# -----------------------------
# PARSE ARGUMENTS
# -----------------------------
STEPS_TO_RUN=""
while getopts "e:j:t:p:s:h" opt; do
    case $opt in
        e) EMULATOR_NAME="$OPTARG" ;;
        j) JAVA_VERSION="$OPTARG" ;;
        t) TMUX_SESSION="$OPTARG" ;;
        p) PROJECT_DIR="$OPTARG" ;;
        s) STEPS_TO_RUN="$OPTARG" ;;
        h|*) usage ;;
    esac
done

# Convert steps to array for easy checking
IFS=',' read -r -a STEPS_ARRAY <<< "$STEPS_TO_RUN"

should_run() {
    local step="$1"
    [[ -z "$STEPS_TO_RUN" ]] && return 0
    for s in "${STEPS_ARRAY[@]}"; do
        [[ "$s" == "$step" ]] && return 0
    done
    return 1
}

# -----------------------------
# FUNCTIONS
# -----------------------------
cleanup_tmux() {
    if tmux has-session -t "$TMUX_SESSION" 2>/dev/null; then
        echo "Killing existing tmux session: $TMUX_SESSION"
        tmux kill-session -t "$TMUX_SESSION"
    fi
}

start_tmux_session() {
    if ! should_run "tmux"; then
        echo "Skipping tmux session"
        return
    fi

    # Kill any existing session first
    cleanup_tmux

    tmux new-session -d -s "$TMUX_SESSION" -c "$PROJECT_DIR"
    echo "Created new tmux session: $TMUX_SESSION"

    # Ensure tmux session is killed on script exit
    trap cleanup_tmux EXIT
}

setup_java() {
    if ! should_run "java"; then
        echo "Skipping Java setup"
        return
    fi

    echo "Using SDKMAN to switch to Java $JAVA_VERSION"
    export SDKMAN_DIR="$HOME/.sdkman"
    [[ -s "$SDKMAN_DIR/bin/sdkman-init.sh" ]] && source "$SDKMAN_DIR/bin/sdkman-init.sh"
    sdk use gradle "$GRADLE_VERSION"
    sdk use java "$JAVA_VERSION"
    echo "Java version:"
    java -version
}

start_emulator() {
    if ! should_run "emulator"; then
        echo "Skipping emulator start"
        return
    fi

    echo "Starting Android emulator: $EMULATOR_NAME"

    if tmux has-session -t "$TMUX_SESSION" 2>/dev/null; then
        tmux send-keys -t "$TMUX_SESSION" "emulator -avd $EMULATOR_NAME &" C-m
    else
        # Run directly in the current shell if tmux not running
        emulator -avd "$EMULATOR_NAME" &
    fi

    echo "Waiting for emulator to boot..."
    until adb devices | grep -q emulator-; do
        sleep 1
    done
    echo "Emulator is ready!"
}

start_tauri_dev() {
    if ! should_run "tauri"; then
        echo "Skipping Tauri dev server start"
        return
    fi

    echo "Starting Tauri Android dev server..."

    if tmux has-session -t "$TMUX_SESSION" 2>/dev/null; then
        tmux split-window -h -t "$TMUX_SESSION" -c "$PROJECT_DIR"
        tmux send-keys -t "$TMUX_SESSION.1" "npx tauri android dev -v" C-m
    else
        # Run directly in current shell if tmux not running
        npx tauri android dev -v
    fi
}

# -----------------------------
# MAIN SCRIPT
# -----------------------------
start_tmux_session
setup_java
start_emulator
start_tauri_dev

# Attach to tmux session if it was created/run
if should_run "tmux"; then
    tmux attach -t "$TMUX_SESSION"
fi
