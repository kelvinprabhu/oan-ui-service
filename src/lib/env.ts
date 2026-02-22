/**
 * Utility to securely access environment variables both at build-time (Vite Local Dev)
 * and at run-time (Docker Runtime via window._env_ injection).
 */
export const ENV = {
  get VITE_API_URL() { return (window as any)._env_?.VITE_API_URL ?? import.meta.env.VITE_API_URL; },
  get VITE_BYPASS_AUTH() { return (window as any)._env_?.VITE_BYPASS_AUTH ?? import.meta.env.VITE_BYPASS_AUTH; },
  get VITE_TELEMETRY_HOST() { return (window as any)._env_?.VITE_TELEMETRY_HOST ?? import.meta.env.VITE_TELEMETRY_HOST; },
  get VITE_TELEMETRY_KEY() { return (window as any)._env_?.VITE_TELEMETRY_KEY ?? import.meta.env.VITE_TELEMETRY_KEY; },
  get VITE_TELEMETRY_SECRET() { return (window as any)._env_?.VITE_TELEMETRY_SECRET ?? import.meta.env.VITE_TELEMETRY_SECRET; },
  get VITE_TELEMETRY_CHANNEL() { return (window as any)._env_?.VITE_TELEMETRY_CHANNEL ?? import.meta.env.VITE_TELEMETRY_CHANNEL; },
  get VITE_TELEMETRY_PRODUCT_ID() { return (window as any)._env_?.VITE_TELEMETRY_PRODUCT_ID ?? import.meta.env.VITE_TELEMETRY_PRODUCT_ID; },
  get VITE_TELEMETRY_PRODUCT_VERSION() { return (window as any)._env_?.VITE_TELEMETRY_PRODUCT_VERSION ?? import.meta.env.VITE_TELEMETRY_PRODUCT_VERSION; },
  get VITE_TELEMETRY_PRODUCT_PID() { return (window as any)._env_?.VITE_TELEMETRY_PRODUCT_PID ?? import.meta.env.VITE_TELEMETRY_PRODUCT_PID; }
};
