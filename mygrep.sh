#!/bin/bash

# Show help
show_help() {
    echo "Usage: $0 [-n] [-v] search_string filename"
    echo "Options:"
    echo "  -n    Show line numbers"
    echo "  -v    Invert match (show non-matching lines)"
    echo "  --help   Show this help message"
}

# If --help is the first argument
if [[ "$1" == "--help" ]]; then
    show_help
    exit 0
fi

# Default options
show_line_numbers=false
invert_match=false

# Parse options with getopts
while getopts ":nv" opt; do
    case $opt in
        n)
            show_line_numbers=true
            ;;
        v)
            invert_match=true
            ;;
        \?)
            echo "Error: Invalid option -$OPTARG"
            show_help
            exit 1
            ;;
    esac
done

# Remove parsed options
shift $((OPTIND -1))
