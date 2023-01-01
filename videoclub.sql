DROP DATABASE IF EXISTS videoclub;
CREATE DATABASE videoclub;
\c videoclub;

CREATE TABLE IF NOT EXISTS socio(
  nsocio   SERIAL PRIMARY KEY,
  nombre    VARCHAR(50) NOT NULL,
  apellidos   VARCHAR(50) NOT NULL,
  direccion   VARCHAR(50) NOT NULL,
  c_postal    NUMERIC NOT NULL,
  poblacion   VARCHAR(30) NOT NULL,
  telefono    NUMERIC(6) NOT NULL
);

INSERT INTO socio (nombre, apellidos, direccion, c_postal, poblacion, telefono) VALUES
('Jose', 'Pascual', 'Calle_Fernando_de_los_Rios', 1234, 'Granada', 123456),
('Maria', 'Perex', 'Calle_Ochoa', 1235, 'Girona', 234567);

CREATE TABLE IF NOT EXISTS pelicula(
  codigo   SERIAL PRIMARY KEY,
  titulo    VARCHAR(30) NOT NULL,
  anio   NUMERIC NOT NULL,
  genero   VARCHAR(30) NOT NULL,
  director    VARCHAR(50) NOT NULL
);

INSERT INTO pelicula(titulo, anio, genero, director) VALUES
('Ghost in the shell', 2002, 'Cyberpunk', 'Mamoru Oshii'),
('Blade Runner 2049', 2017, 'Cyberpunk', 'Denis Villeneuve');

CREATE TABLE IF NOT EXISTS alquila(
  f_alquiler   DATE,
  f_devolucionn   DATE,
  alq_n_socio SERIAL REFERENCES socio(nsocio),
  alq_codigo SERIAL REFERENCES pelicula(codigo)
);

INSERT INTO alquila(f_alquiler, f_devolucionn) VALUES
('1999-08-15', '1999-08-23'),
('1998-06-27', '1998-08-13');