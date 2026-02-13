const fs = require('fs');
const jwt = require('jsonwebtoken');

// Read the private key from the backend keys folder
const privateKey = fs.readFileSync('./keys/jwt_private_key.pem', 'utf8');

const token = jwt.sign(
  {
    name: 'Test User',
    email: 'testuser@example.com',
    sub: 'user123',
  },
  privateKey,
  {
    algorithm: 'RS256',
    expiresIn: '365d',
  }
);

console.log('\n=== Generated JWT Token ===\n');
console.log(token);
console.log('\n=== Use it by visiting ===\n');
console.log(`http://localhost:5173/?token=${token}`);
console.log();
