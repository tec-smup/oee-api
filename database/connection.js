const mysql = require('mysql');

function connection() {
    return mysql.createConnection({
        host: 'localhost',
        user: process.env.SQL_USER,
        password: process.env.SQL_PASSWORD,
        database: process.env.SQL_DATABASE,
        timezone: 'utc'
    });
}

module.exports = function() {
    return connection;
}
