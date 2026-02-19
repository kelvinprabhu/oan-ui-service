# Docker Instructions for OAN UI Service

## 1. Build the Docker Image

You **must** pass `VITE_API_URL` and other environment variables as build arguments because Vite bundles them at build time. They cannot be changed at runtime without rebuilding (unless you implement a runtime config solution).

### Basic Build Command
```bash
docker build \
  --build-arg VITE_API_URL=http://localhost:8000 \
  --build-arg VITE_BYPASS_AUTH=true \
  -t oan-ui-service:latest .
```

### Full Build Command (Recommended for Prod)
If you have many variables, it's easier to use a script or pass them explicitly.

```bash
docker build \
  --build-arg VITE_API_URL=http://your-prod-api.com \
  --build-arg VITE_JWT_AUDIENCE=oan-ui-service \
  --build-arg VITE_JWT_ISSUER=auth-service \
  --build-arg VITE_ENABLE_TELEMETRY=true \
  -t oan-ui-service:latest .
```

## 2. Run the Container

Once built, run the container. Port 8081 is exposed by the Dockerfile.

```bash
docker run -d -p 8081:8081 --name oan-ui oan-ui-service:latest
```

Open [http://localhost:8081](http://localhost:8081) in your browser.

## 3. Troubleshooting

-   **"API URL is undefined"**: You likely forgot `--build-arg VITE_API_URL=...` during the *build* step. Rebuild the image. Passing env vars to `docker run -e ...` has **NO EFFECT** on Vite apps for `VITE_*` variables (they are baked in).
-   **"Module not found"**: Ensure `.dockerignore` is present so valid `node_modules` are installed inside the container, not copied from your host.

## 4. Helper Script (PowerShell)

You can save this as `build_docker.ps1`:

```powershell
docker build `
  --build-arg VITE_API_URL="http://127.0.0.1:8000" `
  --build-arg VITE_BYPASS_AUTH="true" `
  -t oan-ui-service:latest .
```
