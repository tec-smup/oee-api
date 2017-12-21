function channel(connection) {
    this._connection = connection;
}

channel.prototype.getChannel = function(params, callback) {
    var query = "select c.id, c.name, c.description, c.time_shift";
        query += params.fields && params.fields.indexOf("1") >= 0 ? ", fc.field1" : "";
        query += params.fields && params.fields.indexOf("2") >= 0 ? ", fc.field2" : "";
        query += params.fields && params.fields.indexOf("3") >= 0 ? ", fc.field3" : "";
        query += params.fields && params.fields.indexOf("4") >= 0 ? ", fc.field4" : "";
        query += params.fields && params.fields.indexOf("5") >= 0 ? ", fc.field5" : "";
        query += "  from channel c";
        query += " inner join feed_config fc on(fc.channel_id = c.id) ";
        query += " where c.id = ?";
        query += "   and c.token = ?";

    this._connection.query(query, [params.channel_id, params.token], callback);
}

channel.prototype.getFeeds = function(params, callback) {
    var query = "select f.id";
        query += ", f.machine_code";
        query += ", DATE_FORMAT(f.inserted_at, '%Y-%m-%d %H:%i:%s') as inserted_at";
        query += ", DATE_FORMAT(f.inserted_at, '%d/%m/%Y') as date";
        query += ", DATE_FORMAT(f.inserted_at, '%H:%i:%s') as time";
        query += params.fields.indexOf("1") >= 0 ? ", f.field1" : "";
        query += params.fields.indexOf("2") >= 0 ? ", f.field2" : "";
        query += params.fields.indexOf("3") >= 0 ? ", f.field3" : "";
        query += params.fields.indexOf("4") >= 0 ? ", f.field4" : "";
        query += params.fields.indexOf("5") >= 0 ? ", f.field5" : "";              
        query += "  from feed f";
        query += " where f.channel_id = ?";
        query += " order by f.inserted_at desc";
        query += params.results ? " limit " + params.results : "";
         
    this._connection.query(query, params.channel_id, callback);
}

channel.prototype.deleteFeeds = function(params, callback) {
    var query = " delete from feed";
        query += " where channel_id = ?";
         
    this._connection.query(query, parseInt(params.channel_id), callback);
}

channel.prototype.timeShift = function(params, callback) {
    var query = " update channel";
        query += "   set time_shift = ?";
        query += " where id = ?";
         
    this._connection.query(query, [parseInt(params.total), parseInt(params.channel_id)], callback);
}


module.exports = function() {
    return channel;
};
