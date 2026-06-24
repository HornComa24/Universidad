-- Creación de la tabla de alumnos oficial para el Instituto (Caso Caruz)
CREATE TABLE IF NOT EXISTS alumnos (
    id SERIAL PRIMARY KEY,
    rut VARCHAR(12) UNIQUE NOT NULL,
    nombre VARCHAR(100) NOT NULL,
    condicion VARCHAR(20) NOT NULL
);

-- Inyección de registros de prueba (Semillas académicas de alta legibilidad)
INSERT INTO alumnos (rut, nombre, condicion) VALUES
('12.345.678-9', 'Constanza Caruz', 'Matriculado'),
('23.456.789-0', 'Gabriel Andrés', 'Regular'),
('34.567.890-1', 'Ana María Silva', 'Regular')
ON CONFLICT (rut) DO NOTHING;
