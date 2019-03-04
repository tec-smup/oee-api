module.exports = function(api) {
    let _pool = api.database.connection; 
        
    this.dropdown = function(callback) {
        var query = `
            select s.id
                 , s.hour
              from shift s
             order by s.hour
        `;
        _pool.getConnection(function(err, connection) {
            connection.query(query, 
            [
            ], 
            function(error, result) {
                connection.release();
                callback(error, result);
            });
        });
    };  

    return this;
};