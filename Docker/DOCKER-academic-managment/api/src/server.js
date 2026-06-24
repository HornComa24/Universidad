const express = require("express");
const { Pool } = require("pg");
const app = express();

const PORT = process.env.PORT || 8000;

const pool = new Pool({
    host: process.env.DB_HOST || "data-base",
    user: process.env.DB_USER || "postgres",
    password: process.env.DB_PASSWORD || "instituto_secreto_2026",
    database: process.env.DB_NAME || "gestion_academica",
    port: 5432
});

// Middleware CORS
app.use((req, res, next) => {
    res.header("Access-Control-Allow-Origin", "*");
    res.header("Access-Control-Allow-Headers", "Origin, X-Requested-With, Content-Type, Accept");
    res.header("Access-Control-Allow-Methods", "GET, POST, OPTIONS");
    next();
});

app.use(express.json());

// Probar la conexión sin tumbar el servidor si falla al inicio
async function conectarBaseDatos() {
    try {
        await pool.query("SELECT NOW()");
        console.log("[SYS_INIT] Conexión exitosa con PostgreSQL");
    } catch (err) {
        console.error("[SYS_WARN] La base de datos aún no está lista. Reintentando en la próxima petición...", err.message);
    }
}
conectarBaseDatos();

// Endpoint de alumnos
app.get("/api/v1/alumnos", async (req, res) => {
    try {
        const resultado = await pool.query("SELECT id, rut, nombre, condicion FROM alumnos ORDER BY id ASC;");
        res.json({
            status: "success",
            ambiente: process.env.NODE_ENV || "development",
            datos: resultado.rows
        });
    } catch (err) {
        console.error("[ERROR DB]:", err.message);
        res.status(500).json({
            status: "error",
            message: "Error de comunicación con la base de datos interna."
        });
    }
});

app.listen(PORT, () => {
    console.log(`[SYS_INIT] API-REST activa en puerto ${PORT}`);
});
