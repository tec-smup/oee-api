const mysql = require('mysql');

function connection() {
    return mysql.createConnection({
        host: 'localhost',
        user: 'root',
        password: 'M2y0S1q6l#',
        database: 'oee'
    });
}

module.exports = function() {
    return connection;
}