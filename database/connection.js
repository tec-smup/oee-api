const mysql = require('mysql');
var pool = null;

class connection {
    constructor() {
    }
    static createPool() {
        if (process.env.INSTANCE_CONNECTION_NAME && process.env.NODE_ENV === 'production') {
            pool = mysql.createPool({
                socketPath: process.env.INSTANCE_CONNECTION_NAME,
                user: process.env.SQL_USER,
                password: process.env.SQL_PASSWORD,
                database: process.env.SQL_DATABASE,
                timezone: 'utc',
                multipleStatements: true,
                connectionLimit: 100
            });
        }
        else {
            pool = mysql.createPool({
                host: 'localhost',
                user: process.env.SQL_USER,
                password: process.env.SQL_PASSWORD,
                database: process.env.SQL_DATABASE,
                timezone: 'utc',
                multipleStatements: true,
                connectionLimit: 100
            });
        }
    }
    static getPool() {
        return pool;
    }
}

module.exports = function() {
    return connection;
};
