
import 'dotenv/config';
import mysql from 'mysql2';

// Tao ket noi voi MySQL
const connection = mysql.createConnection({
    host: process.env.DB_HOST,
    user: process.env.DB_USER,
    password: process.env.DB_PASSWORD,
    database: process.env.DB_NAME,
    port: Number(process.env.DB_PORT)
});

// Kiem tra ket noi
connection.connect((err) => {
    if (err) {
        console.log('Ket noi that bai:', err.message);
        return;
    }

    console.log('Ket noi MySQL thanh cong!');

    // Kiem tra danh sach bang trong database
    connection.query('SHOW TABLES', (err, results) => {
        if (err) {
            console.log('Loi truy van:', err.message);
        } else {
            console.log('Danh sach bang:');

            results.forEach((row) => {
                console.log(Object.values(row)[0]);
            });
        }

        connection.end();
    });
});
