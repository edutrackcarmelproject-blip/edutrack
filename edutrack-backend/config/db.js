codex/assist-with-backend-implementation-zaxooy
const fs = require("fs");
const path = require("path");
const mysql = require("mysql2");
const mysqlPromise = require("mysql2/promise");

const dbConfig = {
  host: process.env.DB_HOST || "localhost",
  user: process.env.DB_USER || "root",
  password: process.env.DB_PASSWORD || "1234"
};

const dbName = process.env.DB_NAME || "edutrack";

const pool = mysql.createPool({
  ...dbConfig,
  database: dbName,
  waitForConnections: true,
  connectionLimit: Number(process.env.DB_CONNECTION_LIMIT || 10),
  queueLimit: 0,
  multipleStatements: true
});

async function initializeDatabase() {
  const bootstrapConn = await mysqlPromise.createConnection(dbConfig);
  await bootstrapConn.query(`CREATE DATABASE IF NOT EXISTS \`${dbName}\``);
  await bootstrapConn.end();

  const schemaPath = path.join(__dirname, "..", "schema.sql");
  if (fs.existsSync(schemaPath)) {
    const schemaSql = fs.readFileSync(schemaPath, "utf8");
    const schemaPool = mysqlPromise.createPool({
      ...dbConfig,
      database: dbName,
      waitForConnections: true,
      connectionLimit: 2,
      queueLimit: 0,
      multipleStatements: true
    });

    await schemaPool.query(schemaSql);
    await schemaPool.end();
  }

  const connection = await new Promise((resolve, reject) => {
    pool.getConnection((err, conn) => {
      if (err) return reject(err);
      resolve(conn);
    });
  });

  console.log("MySQL Connected ✅");
  connection.release();
}

module.exports = pool;
module.exports.initializeDatabase = initializeDatabase;

const mysql = require("mysql2");

const pool = mysql.createPool({
  host: process.env.DB_HOST || "localhost",
  user: process.env.DB_USER || "root",
  password: process.env.DB_PASSWORD || "1234",
  database: process.env.DB_NAME || "edutrack",
  waitForConnections: true,
  connectionLimit: Number(process.env.DB_CONNECTION_LIMIT || 10),
  queueLimit: 0
});

pool.getConnection((err, connection) => {
  if (err) {
    console.error("Database connection failed:", err.message);
    return;
  }

  console.log("MySQL Connected ✅");
  connection.release();
});

module.exports = pool;
main
