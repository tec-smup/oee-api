module.exports = (api) => {
    let _pool = api.database.connection; 
    
    this.save = function(data, callback) {
        _pool.getConnection(function(err, connection) {
            connection.query(`
            call prc_feed_update(?,?,?,?,?,?,?,@timeShift);
            select @timeShift as timeShift;`,     
            [
                data.token,
                data.mc_cd,
                data.field1,
                data.field2,
                data.field3,
                data.field4,
                data.field5,
            ], 
            function(error, result) {
                connection.release();
                callback(error, result);
            });
        });       
    };
    
    this.update = function(data, callback) {
        _pool.getConnection(function(err, connection) {
            connection.query(`
            update feed 
               set field1 = ?
                 , field2 = ?
                 , field3 = ?
                 , field4 = ?
                 , field5 = ? 
             where id = ?`,     
            [
                data.field1, 
                data.field2, 
                data.field3, 
                data.field4, 
                data.field5, 
                data.id
            ], 
            function(error, result) {
                connection.release();
                callback(error, result);
            });
        });     
    };
    
    this.lastFeed = function(data, callback) {
        let sql = `
            select c.name as channel_name
                , md.code as machine_code
                , concat('[', md.code, '] ', md.name) as machine_name
                , f.field1
                , f.field2
                , f.field3
                , f.field4
                , f.field5 
                , date_format(f.inserted_at, '%d/%m/%Y %H:%i:%s') as inserted_at   
                , fc.field1 as field1_desc
                , fc.field2 as field2_desc
                , fc.field3 as field3_desc
                , fc.field4 as field4_desc
                , fc.field5 as field5_desc
                , fc.refresh_time
            from feed f
            inner join channel c on c.id = f.ch_id
            inner join machine_data md on md.code = f.mc_cd
            inner join feed_config fc on fc.channel_id = c.id
            where f.inserted_at between ? and ?
              and f.ch_id = ?
              and f.mc_cd = ?
            order by f.inserted_at desc
            limit 100
        `;
        _pool.getConnection(function(err, connection) {
            connection.query(sql,     
            [
                data.dateIni, 
                data.dateFin, 
                parseInt(data.ch_id), 
                data.mc_cd
            ], 
            function(error, result) {
                connection.release();
                callback(error, result);
            });
        });    
    };
    
    this.exportChartExcel = function(data, callback) {
        let sql = `
            select c.name as channel_name
                , md.code as machine_code
                , concat('[', md.code, '] ', md.name) as machine_name
                , f.field1
                , f.field2
                , f.field3
                , f.field4
                , f.field5 
                , date_format(f.inserted_at, '%d/%m/%Y %H:%i:%s') as inserted_at   
                , fc.field1 as field1_desc
                , fc.field2 as field2_desc
                , fc.field3 as field3_desc
                , fc.field4 as field4_desc
                , fc.field5 as field5_desc
            from feed f
            inner join channel c on c.id = f.ch_id
            inner join machine_data md on md.code = f.mc_cd
            inner join feed_config fc on fc.channel_id = c.id
            where f.inserted_at between ? and ?
              and f.ch_id = ?
              and f.mc_cd = ?
            order by f.inserted_at
        `;
        _pool.getConnection(function(err, connection) {
            connection.query(sql,     
            [
                data.date_ini, 
                data.date_fin, 
                parseInt(data.ch_id), 
                data.mc_cd
            ], 
            function(error, result) {
                connection.release();
                callback(error, result);
            });
        });    
    };

    this.chart = (data, callback) => {
        let sql = 'call prc_chart(?,?,?,?)';
    
        _pool.getConnection(async(err, connection) => {
            connection.query(sql,     
            [
                data.date_ini, 
                data.date_fin, 
                parseInt(data.ch_id), 
                data.mc_cd
            ], 
            (error, result) => {
                connection.release();
                callback(error, result);
            });
        });
    };
    
    this.mobile = function(user, channelId, machineCode, date, limit, callback) {
        let sql = 'call prc_mobile(?,?,?,?,?)';
        _pool.getConnection(function(err, connection) {
            connection.query(sql,     
            [
                parseInt(user), 
                date, 
                parseInt(channelId),
                machineCode,
                parseInt(limit),
            ], 
            function(error, result) {
                connection.release();
                callback(error, result);
            });
        });
    };

    //vou manter enquanto não atualizar o app ios
    this.allProduction = function(data, callback) {
        let sql = `CALL prc_production_count(?,?,?,?);`;
        _pool.getConnection(function(err, connection) {
            connection.query(sql, [
                parseInt(data.ch_id),
                data.dateIni, 
                data.dateFin,
                parseInt(data.position)                  
            ], 
            function(error, result) {
                connection.release();
                callback(error, result);
            });
        });
    };

    this.allProductionV2 = function(data, callback) {
        let sql = `call prc_commands_executer(?,?,?,?,?);`;
        _pool.getConnection(function(err, connection) {
            connection.query(sql, [
                parseInt(data.ch_id),
                '',
                data.dateIni, 
                data.dateFin, 
                "production"                           
            ], 
            function(error, result) {
                connection.release();
                callback(error, result);
            });
        });
    };

    this.OEE = (data, callback) => {
        let sql = `call prc_oee(?,?,?,?);`;
        _pool.getConnection((err, connection) => {
            connection.query(sql, [
                parseInt(data.ch_id),
                data.dateIni, 
                data.dateFin,
                data.machineCode ? data.machineCode : ''
            ], 
            (error, result) => {
                connection.release();
               callback(error, result);
            });
        });
    };    

    return this;
};