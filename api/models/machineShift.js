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

    return this;
};