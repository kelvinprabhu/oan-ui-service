# Stage 1: Build
FROM node:18-alpine AS build

# ==============================================================================
# Environment Variables Documentation
# These variables can now be passed at RUNTIME (e.g., docker run -e VITE_API_URL=...)
#
# VITE_API_URL: Base URL for the backend API (e.g., https://api.example.com)
# VITE_JWT_AUDIENCE: The expected audience (aud) claim for JWT validation
# VITE_JWT_ISSUER: The expected issuer (iss) claim for JWT validation
# VITE_JWT_EXPIRY_DAYS: Number of days before local session expiration
# VITE_BYPASS_AUTH: "true" to disable authentication locally (dev only)
# VITE_APP_NAME: Unique identifier for the application (e.g., oan-ui-service)
# VITE_APP_TITLE: Display title for the web application
# VITE_DEFAULT_LANGUAGE: Default language code (e.g., en, hi, te)
# VITE_ENABLE_TELEMETRY: "true" to enable tracking telemetry events
# VITE_ENABLE_GEOLOCATION: "true" to enable fetching user's location
# VITE_ENABLE_VOICE_INPUT: "true" to enable Voice-to-Text features
# VITE_ENABLE_TTS: "true" to enable Text-to-Speech playback
# VITE_MAX_RECORDING_DURATION: Maximum allowed voice recording time in ms
# VITE_AUDIO_SERVICE_TYPE: Type of audio service provider (e.g., bhashini)
# VITE_DEBUG_MODE: "true" to enable verbose logging in the browser console
# VITE_USE_MOCK_DATA: "true" to rely on mock data instead of real API calls
# VITE_TELEMETRY_HOST: Host URL to report telemetry events to
# VITE_TELEMETRY_KEY: Key used for authenticating telemetry requests
# VITE_TELEMETRY_SECRET: Secret for telemetry
# VITE_TELEMETRY_CHANNEL: Telemetry channel identifier
# VITE_TELEMETRY_PRODUCT_ID: Telemetry product identifier
# VITE_TELEMETRY_PRODUCT_VERSION: App version for telemetry tracking
# VITE_TELEMETRY_PRODUCT_PID: Telemetry PID identifier
# VITE_DEFAULT_THEME: "light" or "dark" mode baseline
# VITE_ENABLE_ANIMATIONS: "true" to enable UI animations
# VITE_SUPPORTED_LANGUAGES: Comma-separated list of supported language codes
# ==============================================================================

# Inject placeholders at build time so they are baked into the static JS files.
# The entrypoint script will replace these placeholders with actual values at container start.
ENV VITE_API_URL=VITE_API_URL_PLACEHOLDER
ENV VITE_JWT_AUDIENCE=VITE_JWT_AUDIENCE_PLACEHOLDER
ENV VITE_JWT_ISSUER=VITE_JWT_ISSUER_PLACEHOLDER
ENV VITE_JWT_EXPIRY_DAYS=VITE_JWT_EXPIRY_DAYS_PLACEHOLDER
ENV VITE_BYPASS_AUTH=VITE_BYPASS_AUTH_PLACEHOLDER
ENV VITE_APP_NAME=VITE_APP_NAME_PLACEHOLDER
ENV VITE_APP_TITLE=VITE_APP_TITLE_PLACEHOLDER
ENV VITE_DEFAULT_LANGUAGE=VITE_DEFAULT_LANGUAGE_PLACEHOLDER
ENV VITE_ENABLE_TELEMETRY=VITE_ENABLE_TELEMETRY_PLACEHOLDER
ENV VITE_ENABLE_GEOLOCATION=VITE_ENABLE_GEOLOCATION_PLACEHOLDER
ENV VITE_ENABLE_VOICE_INPUT=VITE_ENABLE_VOICE_INPUT_PLACEHOLDER
ENV VITE_ENABLE_TTS=VITE_ENABLE_TTS_PLACEHOLDER
ENV VITE_MAX_RECORDING_DURATION=VITE_MAX_RECORDING_DURATION_PLACEHOLDER
ENV VITE_AUDIO_SERVICE_TYPE=VITE_AUDIO_SERVICE_TYPE_PLACEHOLDER
ENV VITE_DEBUG_MODE=VITE_DEBUG_MODE_PLACEHOLDER
ENV VITE_USE_MOCK_DATA=VITE_USE_MOCK_DATA_PLACEHOLDER
ENV VITE_TELEMETRY_HOST=VITE_TELEMETRY_HOST_PLACEHOLDER
ENV VITE_TELEMETRY_KEY=VITE_TELEMETRY_KEY_PLACEHOLDER
ENV VITE_TELEMETRY_SECRET=VITE_TELEMETRY_SECRET_PLACEHOLDER
ENV VITE_TELEMETRY_CHANNEL=VITE_TELEMETRY_CHANNEL_PLACEHOLDER
ENV VITE_TELEMETRY_PRODUCT_ID=VITE_TELEMETRY_PRODUCT_ID_PLACEHOLDER
ENV VITE_TELEMETRY_PRODUCT_VERSION=VITE_TELEMETRY_PRODUCT_VERSION_PLACEHOLDER
ENV VITE_TELEMETRY_PRODUCT_PID=VITE_TELEMETRY_PRODUCT_PID_PLACEHOLDER
ENV VITE_DEFAULT_THEME=VITE_DEFAULT_THEME_PLACEHOLDER
ENV VITE_ENABLE_ANIMATIONS=VITE_ENABLE_ANIMATIONS_PLACEHOLDER
ENV VITE_SUPPORTED_LANGUAGES=VITE_SUPPORTED_LANGUAGES_PLACEHOLDER

WORKDIR /usr/local/app
COPY ./ /usr/local/app/
RUN npm install
RUN npm run build

# Stage 2: Serve
FROM nginx:alpine
WORKDIR /usr/share/nginx/html

# Clean default nginx html
RUN rm -rf ./*

# Copy built assets from builder
COPY --from=build /usr/local/app/dist .

# Add nginx config for SPA routing
RUN rm /etc/nginx/conf.d/default.conf
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Setup the runtime environment replacement script
COPY docker-entrypoint.sh /docker-entrypoint.sh
RUN chmod +x /docker-entrypoint.sh

EXPOSE 8081

# The entrypoint will substitute the placeholders in static files with actual ENV before starting Nginx
ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["nginx", "-g", "daemon off;"]
