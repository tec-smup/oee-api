function feed(connection) {
    this._connection = connection;
}

feed.prototype.autenticateToken = function(token, callback) {
    this._connection.query("select id, time_shift from channel where token = ?", token, callback);
}

feed.prototype.save = function(data, callback) {
    this._connection.query("insert into feed set ?", data, callback);
}

feed.prototype.update = function(data, callback) {
    this._connection.query("update feed set field1 = ?, field2 = ?, field3 = ?, field4 = ?, field5 = ? where id = ?"
        , [data.field1, data.field2, data.field3, data.field4, data.field5, data.id], callback);
}

module.exports = function() {
    return feed;
};