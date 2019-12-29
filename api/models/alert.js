module.exports = function(api) {
    let _pool = api.database.connection; 

    this.save = function(data, callback) {
        let query = 'call prc_alert(?,?,?,?);';
        
        _pool.getConnection(function(err, connection) {
            connection.query(query, 
            [
                data.channel_id,
                data.sponsor_id,
                data.pause_reason_id,
                data.pause_time,
            ], 
            function(error, result) {
                connection.release();
                callback(error, result);
            });
        });
    };
    
    this.update = function(data, callback) {
        let query = `update alert 
                        set sponsor_id = ?, 
                            pause_reason_id = ?,
                            pause_time = ?
                      where id = ?`;
        
        _pool.getConnection(function(err, connection) {
            connection.query(query, 
            [
                data.sponsor_id, 
                data.pause_reason_id,
                data.pause_time,
                parseInt(data.id)
            ], 
            function(error, result) {
                connection.release();
                callback(error, result);
            });
        });
    };
    
    this.delete = function(data, callback) {    
        _pool.getConnection(function(err, connection) {
            connection.query("call prc_delete_alert(?)", 
            [
                parseInt(data.id)
            ], 
            function(error, result) {
                connection.release();
                callback(error, result);
            });
        });    
    };
    
    this.list = function(channelId, callback) {
        var query = `
            select a.id
            , a.channel_id
            , c.name as channel_name
            , a.sponsor_id
            , s.name as sponsor_name
            , a.pause_reason_id
            , pr.name as pause_reason_name
            , case a.pause_time
			    when 0 then 'Imediato'
                when 5 then '5 minutos'
                when 10 then '10 minutos'
                when 30 then '30 minutos'
		      end as pause_time
        from alert a
        inner join channel c on c.id = a.channel_id
        inner join sponsor s on s.id = a.sponsor_id
        inner join pause_reason pr on pr.id = a.pause_reason_id
        where a.channel_id = ?`;
        
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

    this.hasAlertToSend = function(filters, callback) {
        var query = `
            select s.name as sponsor_name 
                , s.email as sponsor_email
                , pr.name as pause_reason_name
                , case a.pause_time
                    when 0 then 'Imediato'
                    when 5 then '5 minutos'
                    when 10 then '10 minutos'
                    when 30 then '30 minutos'
                end as pause_time
            from alert a
            inner join sponsor s on s.id = a.sponsor_id
            inner join pause_reason pr on pr.id = a.pause_reason_id
            where a.channel_id = ?
            and a.pause_reason_id = ?
            and a.pause_time <= ?`;
                    
        _pool.getConnection(function(err, connection) {
            connection.query(query, 
            [ 
                parseInt(filters.channel_id),
                parseInt(filters.pause_reason_id),
                parseInt(filters.pause),
            ], 
            function(error, result) {
                connection.release();
                callback(error, result);
            });
        });
    };    

    this.hasImmediateAlertToSend = function(filters, callback) {
        var query = `
            select s.name as sponsor_name 
                , s.email as sponsor_email
                , pr.name as pause_reason_name
                , case a.pause_time
                    when 0 then 'Imediato'
                    when 5 then '5 minutos'
                    when 10 then '10 minutos'
                    when 30 then '30 minutos'
                end as pause_time                
            from alert a
            inner join sponsor s on s.id = a.sponsor_id
            inner join pause_reason pr on pr.id = a.pause_reason_id
            where a.channel_id = ?
            and a.pause_time = 0`;
                    
        _pool.getConnection(function(err, connection) {
            connection.query(query, 
            [ 
                parseInt(filters.channel_id)
            ], 
            function(error, result) {
                connection.release();
                callback(error, result);
            });
        });
    };      

    return this;
};