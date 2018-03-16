const mysql = require('mysql');

function connection() {
    var connection = null;
    if (process.env.INSTANCE_CONNECTION_NAME && process.env.NODE_ENV === 'production') {
        connection = mysql.createConnection({
            socketPath: process.env.INSTANCE_CONNECTION_NAME,
            user: process.env.SQL_USER,
            password: process.env.SQL_PASSWORD,
            database: process.env.SQL_DATABASE,
            timezone: 'utc'
        });        
    }
    else {
        connection = mysql.createConnection({
            host: 'localhost',
            user: process.env.SQL_USER,
            password: process.env.SQL_PASSWORD,
            database: process.env.SQL_DATABASE,
            timezone: 'utc'
        }); 
    }
    return connection;
}

module.exports = function() {
    return connection;
}
