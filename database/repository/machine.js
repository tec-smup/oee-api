function machine(connection) {
    this._connection = connection;
}

machine.prototype.autenticateToken = function(token, callback) {
    this._connection.query("select id from channel where token = ?", token, callback);
}

machine.prototype.save = function(data, callback) {
    this._connection.query("insert into feed set ?", data, callback);
}

machine.prototype.update = function(data, callback) {
    this._connection.query("update feed set field1 = ?, field2 = ?, field3 = ?, field4 = ?, field5 = ? where id = ?"
        , [data.field1, data.field2, data.field3, data.field4, data.field5, data.id], callback);
}

module.exports = function() {
    return machine;
};