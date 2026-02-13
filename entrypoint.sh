#!/bin/sh
set -e

# Default to http://127.0.0.1:8000 if VITE_API_URL is not set
: "${VITE_API_URL:=http://127.0.0.1:8000}"

echo "Starting entrypoint.sh..."
echo "Target VITE_API_URL: $VITE_API_URL"

# Check if placeholder exists in the directory
# grep -r returns 0 if found, 1 if not found
if grep -r "__RUNTIME_VITE_API_URL__" /usr/share/nginx/html > /dev/null; then
    echo "Found placeholder '__RUNTIME_VITE_API_URL__' in files."
    echo "Replacing with '$VITE_API_URL'..."
    
    # Find all JS files and replace the placeholder
    find /usr/share/nginx/html -type f -name "*.js" -exec sed -i "s|__RUNTIME_VITE_API_URL__|$VITE_API_URL|g" {} +
    
    echo "Replacement complete."
else
    echo "WARNING: Placeholder '__RUNTIME_VITE_API_URL__' NOT found in /usr/share/nginx/html."
    echo "This means either:"
    echo "1. The build did not use the correct --build-arg VITE_API_URL=__RUNTIME_VITE_API_URL__"
    echo "2. The placeholder was already replaced in a previous run."
    echo "3. The application was built with a hardcoded URL."
fi

echo "Starting Nginx..."
# Execute the passed command (nginx)
exec "$@"
