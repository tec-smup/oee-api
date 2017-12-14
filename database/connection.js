const mysql = require('mysql');

function connection() {
    return mysql.createConnection({
        host: 'localhost',
        user: 'uoee',
        password: '!2o0e1e7#',
        database: 'oee',
        timezone: 'utc'
    });
}

module.exports = function() {
    return connection;
}
