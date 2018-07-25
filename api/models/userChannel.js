module.exports = function(api) {
    let _pool = api.database.connection; 
    
    this.save = function(data, callback) {
        _pool.getConnection(function(err, connection) {
            connection.query("call prc_user_channel(?,?)", 
            [
                data.userId,
                data.channelId,
            ], 
            function(error, result) {
                connection.release();
                callback(error, result);
            });
        });
    };
    
    this.delete = function(data, callback) {
        _pool.getConnection(function(err, connection) {
            connection.query("delete from user_channel where user_id = ? and channel_id = ?", 
            [
                data.userId,
                data.channelId
            ], 
            function(error, result) {
                connection.release();
                callback(error, result);
            });
        });    
    };   

    return this;
};