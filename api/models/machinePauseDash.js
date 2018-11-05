module.exports = function(api) {
    let _pool = api.database.connection; 
    
    this.save = function(data, callback) {    
        _pool.getConnection(function(err, connection) {
            connection.query("call prc_machine_pause_dash(?,?,?,?,?)", 
            [
                parseInt(data.channel_id),
                data.machine_code,
                data.date_ref,
                data.value,
                parseInt(data.pause_reason_id)
            ], 
            function(error, result) {
                connection.release();
                callback(error, result);
            });
        });     
    };

    return this;
};