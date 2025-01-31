const express = require('express');
const sqlite3 = require('sqlite3').verbose();
const bodyParser = require('body-parser');
const cors = require('cors'); // Importar CORS

const app = express();
const port = 4000;

// Middleware
app.use(bodyParser.json());
app.use(cors()); // Habilitar CORS

// Configuración de la base de datos SQLite
const db = new sqlite3.Database('/Users/rociomartos/Desktop/NomadNest/api-login/api_list.db', (err) => {
  if (err) {
    console.error('Error al conectar a la base de datos SQLite:', err.message);
  } else {
    console.log('Conectado a la base de datos SQLite');
  }
});

// Ruta para verificar las tablas existentes
app.get('/check-tables', (req, res) => {
  const query = `SELECT name FROM sqlite_master WHERE type='table'`;

  db.all(query, [], (err, rows) => {
    if (err) {
      return res.status(500).json({ message: 'Error al obtener tablas', error: err.message });
    }
    // Imprimir las tablas para verificar que se están cargando correctamente
    console.log('Tablas en la base de datos:', rows);
    res.json({ tables: rows });
  });
});

// Ruta de login
app.post('/login', (req, res) => {
    const { email, password } = req.body;
  
    // Consulta para validar el login con email y password
    const query = `SELECT * FROM users WHERE email = ? AND password = ?`;
  
    db.get(query, [email, password], (err, row) => {
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

// Ruta de registro
app.post('/register', (req, res) => {
    console.log('Datos recibidos:', req.body);  // Esto imprimirá los datos que el servidor recibe
    
    const { nombre, apellidos, email, password } = req.body;
  
    // Verificar si todos los campos están presentes
    if (!nombre || !apellidos || !email || !password) {
      return res.status(400).json({ message: 'Todos los campos son obligatorios' });
    }
  
    // Verificar si el email ya está registrado
    const checkQuery = `SELECT * FROM users WHERE email = ?`;
    db.get(checkQuery, [email], (err, row) => {
      if (err) {
        return res.status(500).json({ message: 'Error al verificar el email', error: err.message });
      }
      if (row) {
        return res.status(400).json({ message: 'El email ya está registrado' });
      }
  
      // Insertar el nuevo usuario en la base de datos
      const insertQuery = `INSERT INTO users (nombre, apellidos, email, password) VALUES (?, ?, ?, ?)`;
      db.run(insertQuery, [nombre, apellidos, email, password], function (err) {
        if (err) {
          return res.status(500).json({ message: 'Error al registrar el usuario', error: err.message });
        }
        return res.status(201).json({ message: 'Usuario registrado exitosamente', id: this.lastID });
      });
    });
  });
  // Ruta para obtener destinos
  app.get('/destinations', (req, res) => {
    const query = `SELECT * FROM destinations`;
  
    db.all(query, [], (err, rows) => {
      if (err) {
        console.error('Error al obtener destinos:', err.message); // Depuración
        return res.status(500).json({ message: 'Error al obtener destinos', error: err.message });
      }
      console.log('Destinos recuperados:', rows); // Depuración
      res.json({ destinations: rows });
    });
  });
// Iniciar el servidor
app.listen(port, () => {
  console.log(`Servidor escuchando en http://localhost:${port}`);
});