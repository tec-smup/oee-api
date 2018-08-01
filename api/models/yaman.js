module.exports = function(api) {
    let _pool = api.database.connection; 

    this.autenticateToken = function(token, callback) {
        _pool.getConnection(function(err, connection) {
            connection.query(`
            select 1 
              from channel 
             where token = ?
               and (now() <= '2018-08-10 23:59:59')`, token, function(error, result) {
                connection.release();
                callback(error, result);
            });
        });    
    };
        
    this.get = function(callback) {
        let sql = `
            select c.name as channel_name
                , md.code as machine_code
                , concat('[', md.code, '] ', md.name) as machine_name
                , f.field1
                , f.field2
                , f.field3
                , f.field4
                , f.field5	   
                , fc.field1 as field1_desc
                , fc.field2 as field2_desc
                , fc.field3 as field3_desc
                , fc.field4 as field4_desc
                , fc.field5 as field5_desc
                , date_format(f.inserted_at, '%d/%m/%Y %H:%i:%s') as inserted_at
                , f.inserted_at
            from feed f
            inner join channel c on c.id = f.ch_id
            inner join machine_data md on md.code = f.mc_cd
            inner join feed_config fc on fc.channel_id = c.id
            where f.ch_id in(1,8)
            and f.inserted_at <= '2018-07-31 23:59:59'
            order by f.inserted_at desc
        `;
        _pool.getConnection(function(err, connection) {
            connection.query(sql,     
            [], 
            function(error, result) {
                connection.release();
                callback(error, result);
            });
        });    
    };

    return this;
};