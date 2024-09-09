#!/bin/bash

# Check if waybackurls, waymore, and gf are installed
if ! command -v waybackurls &> /dev/null || ! command -v gf &> /dev/null || ! command -v waymore &> /dev/null
then
    echo "Error: 'waybackurls', 'waymore', or 'gf' tool is not installed. Please install them first."
    exit 1
fi

# Function to process URLs with waybackurls or waymore and gf
process_urls() {
    local domain_list="$1"
    local output_urls="$2"
    local tool_choice="$3"

    if [ "$tool_choice" == "waymore" ]; then
        echo "Fetching URLs using waymore..."
        # Fetch URLs using waymore
        waymore -i "$domain_list" -mode U > "$output_urls"
    else
        echo "Fetching URLs using waybackurls..."
        # Fetch URLs using waybackurls
        cat "$domain_list" | waybackurls | tee "$output_urls"
    fi

    echo "Scanning for vulnerabilities using gf patterns..."
    # gf patterns
    patterns=("debug_logic" "idor" "img-traversal" "interestingEXT" "interestingparams" "interestingsubs" "jsvar" \
              "lfi" "potential" "rce" "redirect" "sqli" "ssrf" "ssti" "xss")

    # Create directory to store gf results
    output_dir="gf_results"
    mkdir -p "$output_dir"

    # Loop over patterns and store results
    for pattern in "${patterns[@]}"; do
        gf "$pattern" "$output_urls" > "$output_dir/$pattern.txt"
        echo "Results for '$pattern' saved to $output_dir/$pattern.txt"
    done

    echo "URL processing and vulnerability scanning completed!"
}

# Input validation
if [ -z "$1" ]; then
    echo "Usage: $0 <domain-file or single-domain> [tool: waybackurls/waymore]"
    exit 1
fi

# Choose the tool for fetching URLs: waybackurls or waymore (default to waybackurls)
tool_choice="waybackurls"
if [ ! -z "$2" ]; then
    if [[ "$2" == "waymore" || "$2" == "waybackurls" ]]; then
        tool_choice="$2"
    else
        echo "Invalid tool choice! Use 'waybackurls' or 'waymore'."
        exit 1
    fi
fi

# Check if input is a file or a single domain
if [ -f "$1" ]; then
    # If it's a file (domains.txt), process each domain
    echo "Using domain list from file: $1 with tool: $tool_choice"
    process_urls "$1" "urls.txt" "$tool_choice"
else
    # If it's a single domain, create a temporary file and process it
    echo "Using single domain: $1 with tool: $tool_choice"
    echo "$1" > single_domain.txt
    process_urls "single_domain.txt" "single_domain_urls.txt" "$tool_choice"
    rm single_domain.txt
fi
