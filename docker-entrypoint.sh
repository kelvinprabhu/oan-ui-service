#!/bin/sh
set -e

echo "Substituting environment variables in static files..."

# Find all JS and HTML files in the html serving directory
find /usr/share/nginx/html -type f \( -name "*.js" -o -name "*.html" \) | while read -r file; do
  # Loop over every environment variable starting with VITE_
  env | grep '^VITE_' | while IFS='=' read -r name value; do
    # Escape pipe characters and ampersands since we use | as sed delimiter
    escaped_value=$(echo "$value" | sed -e 's/|/\\|/g' -e 's/&/\\&/g')
    # Replace the placeholder (e.g., VITE_API_URL_PLACEHOLDER) with the actual runtime value
    sed -i "s|${name}_PLACEHOLDER|${escaped_value}|g" "$file"
  done
done

echo "Starting Nginx..."
exec "$@"
