const express = require('express');
const sqlite3 = require('sqlite3').verbose();
const bodyParser = require('body-parser');

const app = express();
const port = 4000;

// Middleware
app.use(bodyParser.json());

// Configuración de la base de datos SQLite
const db = new sqlite3.Database('./api_login.db', (err) => {
  if (err) {
    console.error('Error al conectar a la base de datos SQLite:', err.message);
  } else {
    console.log('Conectado a la base de datos SQLite');
  }
});

// Crear la tabla si no existe
db.run(`
  CREATE TABLE IF NOT EXISTS users (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    username TEXT NOT NULL UNIQUE,
    password TEXT NOT NULL
  )
`);

// Rutas

// Ruta de login
app.post('/login', (req, res) => {
  const { username, password } = req.body;

  // Consulta para validar las credenciales
  const query = `SELECT * FROM users WHERE username = ? AND password = ?`;

  db.get(query, [username, password], (err, row) => {
    if (err) {
      return res.status(500).json({ message: 'Error en el servidor', error: err.message });
    }
    if (row) {
      return res.json({ message: 'Login exitoso', user: row });
    } else {
      return res.status(401).json({ message: 'Credenciales incorrectas' });
    }
  });
});

// Ruta para registrar un usuario
app.post('/register', (req, res) => {
  const { username, password } = req.body;

  // Verificar si el usuario ya existe
  const checkQuery = `SELECT * FROM users WHERE username = ?`;
  db.get(checkQuery, [username], (err, row) => {
    if (err) {
      return res.status(500).json({ message: 'Error en el servidor', error: err.message });
    }

    if (row) {
      return res.status(400).json({ message: 'El usuario ya existe' });
    }

    // Crear un nuevo usuario
    const insertQuery = `INSERT INTO users (username, password) VALUES (?, ?)`;
    db.run(insertQuery, [username, password], function (err) {
      if (err) {
        return res.status(500).json({ message: 'Error al registrar el usuario', error: err.message });
      }
      return res.status(201).json({ message: 'Usuario registrado', user: { id: this.lastID, username, password } });
    });
  });
});

// Iniciar el servidor
app.listen(port, () => {
  console.log(`Servidor escuchando en http://localhost:${port}`);
});