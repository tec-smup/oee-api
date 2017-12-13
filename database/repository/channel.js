function channel(connection) {
    this._connection = connection;
}

channel.prototype.getChannel = function(params, callback) {
    var query = "select c.id, c.name, c.description";
        query += params.fields.indexOf("1") >= 0 ? ", fc.field1" : "";
        query += params.fields.indexOf("2") >= 0 ? ", fc.field2" : "";
        query += params.fields.indexOf("3") >= 0 ? ", fc.field3" : "";
        query += params.fields.indexOf("4") >= 0 ? ", fc.field4" : "";
        query += params.fields.indexOf("5") >= 0 ? ", fc.field5" : "";
        query += "  from channel c";
        query += " inner join feed_config fc on(fc.channel_id = c.id) ";
        query += " where c.id = ?";
        query += "   and c.token = ?";

    this._connection.query(query, [params.channel_id, params.token], callback);
}

channel.prototype.getFeeds = function(params, callback) {
    var query = "select f.id, DATE_FORMAT(f.inserted_at, '%Y-%m-%d %H:%i:%s') as inserted_at";
        query += params.fields.indexOf("1") >= 0 ? ", f.field1" : "";
        query += params.fields.indexOf("2") >= 0 ? ", f.field2" : "";
        query += params.fields.indexOf("3") >= 0 ? ", f.field3" : "";
        query += params.fields.indexOf("4") >= 0 ? ", f.field4" : "";
        query += params.fields.indexOf("5") >= 0 ? ", f.field5" : "";    
        query += "  from feed f";
        query += " inner join channel c on (c.id = f.channel_id)";
        query += " where c.id = ?";
        query += " order by f.inserted_at desc";
        query += params.results ? " limit " + params.results : "";
         
    this._connection.query(query, params.channel_id, callback);
}

module.exports = function() {
    return channel;
};
