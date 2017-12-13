const mysql = require('mysql');

function connection() {
    return mysql.createConnection({
        host: 'localhost',
        user: 'root',
        password: 'root',
        database: 'oee'
    });
}

module.exports = function() {
    return connection;
}
