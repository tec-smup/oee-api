const util = require('util');
const mysql = require('mysql');

const config = {
    user: process.env.SQL_USER,
    password: process.env.SQL_PASSWORD,
    database: process.env.SQL_DATABASE,
    timezone: process.env.SQL_TIMEZONE,
    multipleStatements: process.env.SQL_MULTIPLESTATEMENTS,
    connectionLimit: process.env.SQL_CONNECTION_LIMIT
};
  
if (process.env.INSTANCE_CONNECTION_NAME && process.env.NODE_ENV === 'production')
    config.socketPath = process.env.INSTANCE_CONNECTION_NAME;
else
    config.host = process.env.SQL_HOST;

const connection = mysql.createPool(config);

// ping para verificar se há erro de conexão (isso vai aparecer nos registros da VM no GCP)
connection.getConnection((err, connection) => {
    if (err) {
        if (err.code === 'PROTOCOL_CONNECTION_LOST') {
            console.error('Database connection was closed.');
        }
        if (err.code === 'ER_CON_COUNT_ERROR') {
            console.error('Database has too many connections.');
        }
        if (err.code === 'ECONNREFUSED') {
            console.error('Database connection was refused.');
        }
    }

    if (connection) connection.release();

    return;
});

// Promisify Node.js async/await (isso permite futuramente utilizar asynx promises para obter dados do mysql)
connection.query = util.promisify(connection.query);

module.exports = connection;