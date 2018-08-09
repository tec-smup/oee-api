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

    this.save = function(data, callback) {
        let query = `
        call prc_machine_data(?,?,?,?,?,?,?,?);
        select code
             , name
             , mobile_name
             , department
             , product
             , DATE_FORMAT(last_maintenance, '%d/%m/%Y') as last_maintenance 
             , DATE_FORMAT(next_maintenance, '%d/%m/%Y') as next_maintenance
             , concat('[', code, '] ', name) as dropdown_label
          from machine_data
         where code = ?;
        `;
        _pool.getConnection(function(err, connection) {
            connection.query(query, 
            [
                data.code,
                data.name,
                data.mobile_name,
                data.department,
                data.product,
                data.last_maintenance,
                data.next_maintenance,
                data.userId,
                data.code,
            ], 
            function(error, result) {
                connection.release();
                callback(error, result);
            });
        });
    };
    
    this.update = function(data, callback) {
        let query = `update machine_data 
                        set name = ?, 
                            mobile_name = ?,
                            department = ?, 
                            product = ?, 
                            last_maintenance = STR_TO_DATE(?, '%d/%m/%Y'), 
                            next_maintenance = STR_TO_DATE(?, '%d/%m/%Y')
                      where code = ?`;
        
        _pool.getConnection(function(err, connection) {
            connection.query(query, 
            [
                data.name, 
                data.mobile_name,
                data.department, 
                data.product, 
                data.last_maintenance, 
                data.next_maintenance, 
                data.code
            ], 
            function(error, result) {
                connection.release();
                callback(error, result);
            });
        });
    };
    
    this.delete = function(data, callback) {    
        _pool.getConnection(function(err, connection) {
            connection.query("call prc_delete_machine_data(?)", 
            [
                data.code
            ], 
            function(error, result) {
                connection.release();
                callback(error, result);
            });
        });    
    };
    
    this.list = function(userId, channelId, callback) {
        var query = `
            select code
                 , name
                 , mobile_name
                 , department
                 , product
                 , DATE_FORMAT(last_maintenance, '%d/%m/%Y') as last_maintenance 
                 , DATE_FORMAT(next_maintenance, '%d/%m/%Y') as next_maintenance
                 , concat('[', code, '] ', name) as dropdown_label
                 , export_set(state,'1','0','',1) as state
              from machine_data	
             inner join channel_machine cm on cm.machine_code = code
             inner join user_channel uc on uc.channel_id = cm.channel_id
             where uc.user_id = ?
               and ((uc.channel_id = ?) or ? = 0)
        `;
        _pool.getConnection(function(err, connection) {
            connection.query(query, 
            [
                parseInt(userId), 
                parseInt(channelId), 
                parseInt(channelId)
            ], 
            function(error, result) {
                connection.release();
                callback(error, result);
            });
        });
    };

    this.listAll = function(callback) {
        var query = `
            select code
                 , name
                 , mobile_name
                 , department
                 , product
                 , DATE_FORMAT(last_maintenance, '%d/%m/%Y') as last_maintenance 
                 , DATE_FORMAT(next_maintenance, '%d/%m/%Y') as next_maintenance
                 , concat('[', code, '] ', name) as dropdown_label
              from machine_data
        `;
        _pool.getConnection(function(err, connection) {
            connection.query(query, 
            [], 
            function(error, result) {
                connection.release();
                callback(error, result);
            });
        });
    };

    this.listByChannel = function(channelId, callback) {
        var query = `
            select code
                 , name
              from machine_data	
             inner join channel_machine cm on cm.machine_code = code
             where cm.channel_id = ?
        `;
        _pool.getConnection(function(err, connection) {
            connection.query(query, 
            [
                parseInt(channelId)
            ], 
            function(error, result) {
                connection.release();
                callback(error, result);
            });
        });
    };

    this.getMax = function(params, callback) {
        var query = `
            select id
            ${params.fields == 1 ? ", coalesce(f.field1, '') as value" 
                : params.fields == 2 ? ", convert(coalesce(f.field2, 0), char) as value" 
                : params.fields == 3 ? ", convert(coalesce(f.field3, 0), char) as value" 
                : params.fields == 4 ? ", coalesce(f.field4, '') as value" 
                : params.fields == 5 ? ", coalesce(f.field5, '') as value": "" }
              from feed f
             where id = (select max(id) 
                           from feed 
                          where mc_cd = ? 
                            and ch_id = ?)
        `;
        _pool.getConnection(function(err, connection) {
            connection.query(query, 
            [
                params.mc_cd, 
                parseInt(params.ch_id)
            ], 
            function(error, result) {
                connection.release();
                callback(error, result);
            });
        });
    };    

    this.getState = function(code, callback) {
        var query = `
            select export_set(state,'1','0','',1) as state
              from machine_data	
             where code = ?
        `;
        _pool.getConnection(function(err, connection) {
            connection.query(query, 
            [
                code
            ], 
            function(error, result) {
                connection.release();
                callback(error, result);
            });
        });
    };

    this.setState = function(params, callback) {
        var query = `
            update machine_data
               set state = ? 	
             where code = ?
        `;
        _pool.getConnection(function(err, connection) {
            connection.query(query, 
            [
                params.code,
                parseInt(params.state)
            ], 
            function(error, result) {
                connection.release();
                callback(error, result);
            });
        });
    };    

    return this;
};