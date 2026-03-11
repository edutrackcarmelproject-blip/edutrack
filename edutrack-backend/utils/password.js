const crypto = require("crypto");

function hashPassword(password) {
  const salt = crypto.randomBytes(16).toString("hex");
  const derived = crypto.scryptSync(password, salt, 64).toString("hex");
  return `scrypt$${salt}$${derived}`;
}

function verifyPassword(password, storedHash) {
  if (!storedHash) return false;

  if (storedHash.startsWith("scrypt$")) {
    const [, salt, hashed] = storedHash.split("$");
    if (!salt || !hashed) return false;
    const derived = crypto.scryptSync(password, salt, 64).toString("hex");
    return crypto.timingSafeEqual(Buffer.from(derived, "hex"), Buffer.from(hashed, "hex"));
  }

  const legacy = crypto.createHash("sha256").update(password).digest("hex");
  return legacy === storedHash;
}

module.exports = { hashPassword, verifyPassword };
