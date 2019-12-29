module.exports = function(api) {
    let _pool = api.database.connection; 

    this.save = function(data, callback) {
        let query = 'call prc_sponsor(?,?,?);';
        
        _pool.getConnection(function(err, connection) {
            connection.query(query, 
            [
                data.channel_id,
                data.sponsor_name,
                data.email
            ], 
            function(error, result) {
                connection.release();
                callback(error, result);
            });
        });
    };
    
    this.update = function(data, callback) {
        let query = `update sponsor 
                        set name = ?, 
                            email = ?
                      where id = ?`;
        
        _pool.getConnection(function(err, connection) {
            connection.query(query, 
            [
                data.sponsor_name, 
                data.email,
                parseInt(data.sponsor_id)
            ], 
            function(error, result) {
                connection.release();
                callback(error, result);
            });
        });
    };
    
    this.delete = function(data, callback) {    
        _pool.getConnection(function(err, connection) {
            connection.query("call prc_delete_sponsor(?)", 
            [
                parseInt(data.sponsor_id)
            ], 
            function(error, result) {
                connection.release();
                callback(error, result);
            });
        });    
    };
    
    this.list = function(channelId, callback) {
        var query = `
            select s.id as sponsor_id
            , s.channel_id
            , c.name channel_name
            , s.name as sponsor_name
            , s.email
        from sponsor s
        inner join channel c on c.id = s.channel_id
        where s.channel_id = ?`;
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

    return this;
};