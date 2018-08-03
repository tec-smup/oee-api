module.exports = function(api) {
    let _pool = api.database.connection; 

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

    this.updateConfig = function(data, callback) {        
        let query = `
            update feed_config 
                           set field1 = ?
                             , field2 = ?
                             , field3 = ?
                             , field4 = ?
                             , field5 = ?
                             , refresh_time = ?
                             , chart_tooltip_desc = ?
                         where channel_id = ?
        `;
        _pool.getConnection(function(err, connection) {
            connection.query(query, 
            [
                data.field1, 
                data.field2, 
                data.field3, 
                data.field4, 
                data.field5, 
                data.refresh_time, 
                data.chart_tooltip_desc,
                data.channel_id
            ], 
            function(error, result) {
                connection.release();
                callback(error, result);
            });
        });
    };    

    this.updateSQL = function(data, callback) {        
        let query = `
            update feed_config 
                           set chart_sql = ?
                             , mobile_sql = ?
                         where channel_id = ?
        `;
        _pool.getConnection(function(err, connection) {
            connection.query(query, 
            [
                data.chart_sql, 
                data.mobile_sql,
                data.channel_id,
            ], 
            function(error, result) {
                connection.release();
                callback(error, result);
            });
        });
    };    

    return this;
};