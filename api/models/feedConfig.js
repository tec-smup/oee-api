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

    this.list = function(channelId, callback) {
        var query = `
            select * 
              from feed_config
             where channel_id = ?
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

    return this;
};