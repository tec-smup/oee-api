module.exports = function(api) {
    let _pool = api.database.connection; 

    this.autenticateToken = function(token, callback) {
        _pool.getConnection(function(err, connection) {
            connection.query("select id from channel where token = ?", token, function(error, result) {
                connection.release();
                callback(error, result);
            });
        });
    };
    
    this.getChannel = function(params, callback) {
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
    
        _pool.getConnection(function(err, connection) {
            connection.query(query, [params.channel_id, params.token], function(error, result) {
                connection.release();
                callback(error, result);
            });
        });
    };
    
    this.getFeeds = function(params, callback) {
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
             
        _pool.getConnection(function(err, connection) {
            connection.query(query, params.channel_id, function(error, result) {
                connection.release();
                callback(error, result);
            });
        });    
    };
    
    this.deleteFeeds = function(params, callback) {
        var and = params.initial_date && params.final_date ? 
            " and DATE_FORMAT(inserted_at, '%d/%m/%Y %H:%i') between '" + params.initial_date + "' and '" + params.final_date + "'" : "";
        
        var bkpQuery = "insert into deleted_feed(id, ch_id, mc_cd, field1, field2, field3, field4, field5, inserted_at) ";    
            bkpQuery += "select id, ch_id, mc_cd, field1, field2, field3, field4, field5, inserted_at from feed ";
            bkpQuery += "where ch_id = ?";
            bkpQuery += and;
    
        var query = " delete from feed";
            query += " where ch_id = ?";
            query += and;
    
        _pool.getConnection(function(err, connection) {
            connection.query(bkpQuery, parseInt(params.channel_id));
            connection.query(query, parseInt(params.channel_id), function(error, result) {
                connection.release();
                callback(error, result);
            });
        });
    };
    
    this.timeShift = function(params, callback) {
        var query = " update channel";
            query += "   set time_shift = ?";
            query += " where id = ?";
           
        _pool.getConnection(function(err, connection) {
            connection.query(query, [parseInt(params.total), parseInt(params.channel_id)], function(error, result) {
                connection.release();
                callback(error, result);
            });
        });
    };
    
    this.list = function(userId, callback) {
        var query = `
            select c.id
                 , c.name
                 , c.description
                 , c.token
                 , case c.active when 1 then 'Ativo' else 'Inativo' end as active
                 , DATE_FORMAT(c.created_at, '%d/%m/%Y %H:%i:%s') as created_at
                 , DATE_FORMAT(c.updated_at, '%d/%m/%Y %H:%i:%s') as updated_at
                 , c.time_shift
                 , initial_turn
                 , final_turn
                 , case c.reset_time_shift when 1 then 'Sim' else 'Não' end as reset_time_shift
              from channel c
             inner join user_channel uc on uc.channel_id = c.id
             where uc.user_id = ?
             order by c.id	
        `; 
        _pool.getConnection(function(err, connection) {
            connection.query(query, [parseInt(userId)], function(error, result) {
                connection.release();
                callback(error, result);
            });
        });
    };
    
    this.save = function(data, callback) {
        _pool.getConnection(function(err, connection) {
            connection.query("set @channelId = 0; call prc_channel(?,?,?,?,?,?,?,?,?,@channelId)", 
            [
                data.name,
                data.description,
                data.token,
                data.active,
                data.time_shift,
                data.initial_turn,
                data.final_turn,
                data.userId,
                data.reset_time_shift
            ], 
            function(error, result) {
                connection.release();
                callback(error, result);
            });
        });
    };
    
    this.update = function(data, callback) {        
        let query = `
            update channel set name = ?
                             , description = ?
                             , token = ?
                             , active = ?
                             , updated_at = now()
                             , time_shift = ?
                             , initial_turn = ?
                             , final_turn = ?	
                             , reset_time_shift = ?
                         where id = ?
        `;
        _pool.getConnection(function(err, connection) {
            connection.query(query, 
            [
                data.name, 
                data.description, 
                data.token, 
                parseInt(data.active), 
                data.time_shift, 
                data.initial_turn, 
                data.final_turn, 
                data.reset_time_shift, 
                data.id
            ], 
            function(error, result) {
                connection.release();
                callback(error, result);
            });
        });
    };
    
    this.delete = function(data, callback) {
        _pool.getConnection(function(err, connection) {
            connection.query("call prc_delete_channel(?)", 
            [
                data.id
            ], 
            function(error, result) {
                connection.release();
                callback(error, result);
            });
        });    
    };   

    return this;
};