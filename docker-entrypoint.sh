#!/bin/sh
set -e

echo "Generating /env-config.js from environment variables..."

# Create env-config.js file in nginx root
cat <<EOF > /usr/share/nginx/html/env-config.js
window._env_ = {
EOF

# Loop over environment variables and append to JS object
env | grep '^VITE_' | while IFS='=' read -r name value; do
  # Escape double quotes and backslashes
  escaped_value=$(echo "$value" | sed -e 's/\\/\\\\/g' -e 's/"/\\"/g')
  echo "  \"$name\": \"$escaped_value\"," >> /usr/share/nginx/html/env-config.js
done

echo "};" >> /usr/share/nginx/html/env-config.js

echo "Configuration applied. Starting Nginx..."
exec "$@"
