function channel(connection) {
    this._connection = connection;
}

channel.prototype.autenticateToken = function(token, callback) {
    this._connection.query("select id from channel where token = ?", token, callback);
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
        query += ", f.mc_cd as machine_code";
		query += ", m.name as machine_name";
        query += ", DATE_FORMAT(f.inserted_at, '%Y-%m-%d %H:%i:%s') as inserted_at";
        query += ", DATE_FORMAT(f.inserted_at, '%d/%m/%Y') as date";
        query += ", DATE_FORMAT(f.inserted_at, '%H:%i:%s') as time";
        query += params.fields.indexOf("1") >= 0 ? ", f.field1" : "";
        query += params.fields.indexOf("2") >= 0 ? ", f.field2" : "";
        query += params.fields.indexOf("3") >= 0 ? ", f.field3" : "";
        query += params.fields.indexOf("4") >= 0 ? ", f.field4" : "";
        query += params.fields.indexOf("5") >= 0 ? ", f.field5" : "";              
        query += "  from feed f";
		query += " inner join machine_data m on m.code = f.mc_cd";
        query += " where f.ch_id = ?";
        query += " order by f.inserted_at desc";
        query += params.results ? " limit " + params.results : "";
         
    this._connection.query(query, params.channel_id, callback);
}

channel.prototype.deleteFeeds = function(params, callback) {
    var and = params.initial_date && params.final_date ? 
        " and DATE_FORMAT(inserted_at, '%d/%m/%Y %H:%i') between '" + params.initial_date + "' and '" + params.final_date + "'" : "";
    
    var bkpQuery = "insert into deleted_feed(id, ch_id, mc_cd, field1, field2, field3, field4, field5, inserted_at) ";    
        bkpQuery += "select id, ch_id, mc_cd, field1, field2, field3, field4, field5, inserted_at from feed ";
        bkpQuery += "where ch_id = ?";
        bkpQuery += and;

    var query = " delete from feed";
        query += " where ch_id = ?";
        query += and;
    
    this._connection.query(bkpQuery, parseInt(params.channel_id));
    this._connection.query(query, parseInt(params.channel_id), callback);
}

channel.prototype.timeShift = function(params, callback) {
    var query = " update channel";
        query += "   set time_shift = ?";
        query += " where id = ?";
         
    this._connection.query(query, [parseInt(params.total), parseInt(params.channel_id)], callback);
}

channel.prototype.list = function(callback) {
    var query = "select c.id"; 
    query += "        , c.name";
    query += "        , c.description";
    query += "        , c.token"
    query += "        , case c.active when 1 then 'Ativo' else 'Inativo' end as active";
    query += "        , DATE_FORMAT(c.created_at, '%d/%m/%Y %H:%i:%s') as created_at";
    query += "        , DATE_FORMAT(c.updated_at, '%d/%m/%Y %H:%i:%s') as updated_at";
    query += "        , c.time_shift";
    query += "     from channel c";
    query += "    order by c.name"; 
    this._connection.query(query, [], callback);
}

channel.prototype.save = function(data, callback) {
    this._connection.query("insert into channel set ?", data, callback);
}

channel.prototype.update = function(data, callback) {
    let datetime = new Date();
    let query = "update channel set name = ?, description = ?, token = ?, active = ?, updated_at = now(), time_shift = ?";
        query += " where id = ?";
    this._connection.query(query, [data.name, data.description, data.token, parseInt(data.active), data.time_shift, data.id], callback);    
}

channel.prototype.delete = function(data, callback) {
    this._connection.query("delete from channel where id = ?", [data.id], callback);    
}

module.exports = function() {
    return channel;
};
