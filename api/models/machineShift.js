module.exports = function(api) {
    let _pool = api.database.connection; 
        
    this.list = function(params, callback) {
        var query = `
            select id
                , machine_code as machineCode
                , hour_ini as hourIni
                , hour_fin as hourFin
            from machine_shift
            where machine_code = ?
        `;
        _pool.getConnection(function(err, connection) {
            connection.query(query, 
            [
                params.machineCode
            ], 
            function(error, result) {
                connection.release();
                callback(error, result);
            });
        });
    };  

    this.add = function(data, callback) {
        _pool.getConnection(function(err, connection) {
            connection.query("call prc_machine_shift(?,?,?);", 
            [
                data.machineCode,
                data.hourIni,
                data.hourFin
            ], 
            function(error, result) {
                connection.release();
                callback(error, result);
            });
        });    
    };

    this.delete = function(params, callback) {
        _pool.getConnection(function(err, connection) {
            connection.query("delete from machine_shift where id = ?", 
            [
                parseInt(params.id)
            ], 
            function(error, result) {
                connection.release();
                callback(error, result);
            });
        });    
    };    

    this.OEE = function(params, callback) {
        _pool.getConnection(function(err, connection) {
            connection.query("call prc_shift_oee(?,?,?,?);", 
            [
                parseInt(params.channelId),
                params.machineCode,
                params.dateIni,
                params.dateFin
            ], 
            function(error, result) {
                connection.release();
                callback(error, result);
            });
        });    
    };     

    return this;
};