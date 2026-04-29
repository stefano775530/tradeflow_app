function parseBoolean(value, defaultValue = false) {
  if (value === undefined) return defaultValue;
  return value === "true";
}

function requireString(name) {
  const value = process.env[name];
  if (!value || !value.trim()) {
    throw new Error(`Missing required environment variable: ${name}`);
  }
  return value.trim();
}

function optionalString(name, defaultValue = "") {
  const value = process.env[name];
  return value !== undefined ? value.trim() : defaultValue;
}

function requireNodeEnv(value) {
  const allowed = ["development", "test", "production"];
  if (!allowed.includes(value)) {
    throw new Error(
      `Invalid NODE_ENV "${value}". Allowed values: ${allowed.join(", ")}`,
    );
  }
  return value;
}

const NODE_ENV = requireNodeEnv(optionalString("NODE_ENV", "development"));
const PORT = Number(optionalString("PORT", "3000"));
const JWT_KEY = requireString("JWT_KEY");
const JWT_EXPIRES_IN = optionalString("JWT_EXPIRES_IN", "1h");
const CLIENT_ORIGINS = optionalString("CLIENT_ORIGINS", "");
const TRUST_PROXY = parseBoolean(process.env.TRUST_PROXY, false);

const allowedOrigins = CLIENT_ORIGINS.split(",")
  .map((origin) => origin.trim())
  .filter(Boolean);

if (NODE_ENV === "production" && allowedOrigins.length === 0) {
  throw new Error(
    "CLIENT_ORIGINS is required in production. Example: https://app.example.com",
  );
}

const env = Object.freeze({
  NODE_ENV,
  PORT,
  JWT_KEY,
  JWT_EXPIRES_IN,
  CLIENT_ORIGINS,
  TRUST_PROXY,
  allowedOrigins,
});

module.exports = { env };
