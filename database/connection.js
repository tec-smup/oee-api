const mysql = require('mysql');

function connection() {
    return mysql.createConnection({
        host: 'localhost',
        user: 'root',
        password: 'root',
        database: 'oee',
        timezone: 'utc'
    });
}

module.exports = function() {
    return connection;
}
