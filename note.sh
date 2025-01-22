#!/bin/bash

#First I make files that we can store our notes in 
NOTES_FILE="notes.txt"
LOG_FILE="note.log"

# Next create a function to log or debus
log_debug() {
    echo "$(date +'%Y-%m-%d %H:%M:%S') - DEBUG - $1" >> "$LOG_FILE"
}

#Next create a funtion that we can store our notes in the files
add_note() {
    local note="$1"
    if [[ -z "$note" ]]; then
        echo "Error: Note text cannot be empty."
        exit 1
    fi

    local timestamp=$(date +"%Y-%m-%d %H:%M:%S")
    echo "$timestamp - $note" >> "$NOTES_FILE"
    log_debug "Added note: $note"
    echo "Note added successfully."
}

#Next is the funtion to list our notes
list_notes() {
    if [[ ! -f "$NOTES_FILE" || ! -s "$NOTES_FILE" ]]; then
        echo "No notes found."
        exit 0
    fi

    cat "$NOTES_FILE"
    log_debug "Listed all notes."
}

#And then a function to search throught the note files
search_notes() {
    local keyword="$1"
    if [[ -z "$keyword" ]]; then
        echo "Error: Search keyword cannot be empty."
        exit 1
    fi

    grep --color=always -i "$keyword" "$NOTES_FILE" 2>/dev/null || echo "No matching notes found."
    log_debug "Searched for keyword: $keyword"
}

#Then we make guidence for our user so they know what to do once they run the script
if [[ $# -lt 1 ]]; then
    echo "Usage: $0 {add|list|search} [arguments...]"
    exit 1
fi

COMMAND="$1"
shift

case "$COMMAND" in
    add)
        add_note "$@"
        ;;
    list)
        list_notes
        ;;
    search)
        search_notes "$@"
        ;;
    *)
        echo "Error: Unknown command '$COMMAND'."
        echo "Usage: $0 {add|list|search} [arguments...]"
        exit 1
        ;;
esac

