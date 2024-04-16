#!/usr/bin/env bash

# Replace with your script's directory
SCRIPT_DIR="$HOME/Documents/projects/timetracking"

# Function to start a task with optional start_time
start_task() {
    local name="$1"
    # check for valid task name
    if [ -z "$name" ]; then
        echo "Error: Task name not provided."
        return
    fi

    # remaining parameters are optional
    local type="$2"
    local description="$3"
    local start_time="$4"

    python "$SCRIPT_DIR/time_tracking.py" --start --name "$name" --type "$type" --description "$description" --start-time "$start_time"
}

# Function to stop a task with fuzzy matching
stop_task() {
    local match_key="$1"
    local end_time="$2"
    python "$SCRIPT_DIR/time_tracking.py" --stop "$match_key" --end-time "$end_time"
}

# list currently open tasks
list_tasks() {
    python "$SCRIPT_DIR/time_tracking.py" --list
}

# list today's finished tasks
list_todays_tasks() {
    python "$SCRIPT_DIR/time_tracking.py" --list-today
}

alias bt="start_task"
alias st="stop_task"
alias lt="list_tasks"
alias ltt="list_todays_tasks"

