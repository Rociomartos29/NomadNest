const express = require('express');
const sqlite3 = require('sqlite3').verbose();
const bodyParser = require('body-parser');
const cors = require('cors'); 
const jwt = require('jsonwebtoken'); // Importa el paquete jsonwebtoken

const app = express();
const port = 4000;

// Middleware
app.use(bodyParser.json());
app.use(cors()); // Habilitar CORS

// Clave secreta para firmar los tokens (debe mantenerse privada y segura)
const SECRET_KEY = '9a1bc3@#fG2hYpTt#12shf@@Fd6gq94!L';

// Configuración de la base de datos SQLite
const db = new sqlite3.Database('/Users/rociomartos/Desktop/NomadNest/api-login/api_list.db', (err) => {
  if (err) {
    console.error('Error al conectar a la base de datos SQLite:', err.message);
  } else {
    console.log('Conectado a la base de datos SQLite');
  }
});
// Función para encontrar un usuario por email y contraseña
// Función para encontrar un usuario por email y contraseña usando Promesas
function findUserByEmailAndPassword(email, password) {
  return new Promise((resolve, reject) => {
    const query = `SELECT * FROM users WHERE email = ? AND password = ?`;

    db.get(query, [email, password], (err, row) => {
      if (err) {
        reject(err); // Si hay un error, rechazamos la promesa
      } else if (row) {
        resolve(row); // Si se encuentra al usuario, lo resolvemos
      } else {
        resolve(null); // Si no se encuentra, devolvemos null
      }
    });
  });
}

// Ruta de login con generación de token
app.post('/login', async (req, res) => {
  const { email, password } = req.body;

  try {
    // Verifica si el usuario y la contraseña son correctos
    const user = await findUserByEmailAndPassword(email, password);
    
    if (user) {
      // Crear el token JWT
      const token = jwt.sign(
        { userId: user.id, email: user.email },
        SECRET_KEY, // Clave secreta para firmar el token
        { expiresIn: '1h' } // Expiración del token (por ejemplo, 1 hora)
      );

      // Responder con el token y los detalles del usuario
      return res.json({
        message: "Login exitoso",
        token: token, // Aquí es donde agregas el token generado
        user: {
          id: user.id,
          nombre: user.nombre,
          apellidos: user.apellidos,
          email: user.email
        }
      });
    } else {
      return res.status(401).json({ message: "Credenciales incorrectas" });
    }
  } catch (error) {
    return res.status(500).json({ message: 'Error al buscar usuario', error: error.message });
  }
});
// Ruta para verificar las tablas existentes
app.get('/check-tables', (req, res) => {
  const query = `SELECT name FROM sqlite_master WHERE type='table'`;

  db.all(query, [], (err, rows) => {
    if (err) {
      return res.status(500).json({ message: 'Error al obtener tablas', error: err.message });
    }
    console.log('Tablas en la base de datos:', rows);
    res.json({ tables: rows });
  });
});

// Ruta de registro
app.post('/register', (req, res) => {
    console.log('Datos recibidos:', req.body);
    
    const { nombre, apellidos, email, password } = req.body;
  
    if (!nombre || !apellidos || !email || !password) {
      return res.status(400).json({ message: 'Todos los campos son obligatorios' });
    }
  
    const checkQuery = `SELECT * FROM users WHERE email = ?`;
    db.get(checkQuery, [email], (err, row) => {
      if (err) {
        return res.status(500).json({ message: 'Error al verificar el email', error: err.message });
      }
      if (row) {
        return res.status(400).json({ message: 'El email ya está registrado' });
      }
  
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
    res.json({ destinations: rows });
  });
});
app.get('/flights', (req, res) => {
  const { origen, destino, fecha_salida, fecha_regreso } = req.query;

  if (!origen || !destino || !fecha_salida || !fecha_regreso) {
    return res.status(400).json({ message: 'Todos los parámetros son obligatorios' });
  }

  const query = `
    SELECT * FROM vuelos 
    WHERE origen = ? AND destino = ? 
    AND fecha_salida >= ? AND fecha_regreso <= ?
  `;

  db.all(query, [origen, destino, fecha_salida, fecha_regreso], (err, rows) => {
    if (err) {
      return res.status(500).json({ message: 'Error al obtener los vuelos', error: err.message });
    }
    if (rows.length === 0) {
      return res.status(404).json({ message: 'No se encontraron vuelos' });
    }
    res.json({ flights: rows });
  });
});
// Iniciar el servidor
app.listen(port, () => {
console.log(`Servidor escuchando en http://localhost:${port}`);
});