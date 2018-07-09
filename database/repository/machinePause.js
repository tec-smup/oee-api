function machinePause(pool) {
    this.pool = pool;
}

machinePause.prototype.autenticateToken = function(token, callback) {
    this.pool.getConnection(function(err, connection) {
        connection.query("select id from channel where token = ?", token, function(error, result) {
            connection.release();
            callback(error, result);
        });
    });     
}

machinePause.prototype.save = function(data, callback) {    
    this.pool.getConnection(function(err, connection) {
        connection.query("call prc_machine_pause(?,?,?,?)", 
        [
            data.mc_cd,
            data.pause,
            data.date_ref,
            data.justification
        ], 
        function(error, result) {
            connection.release();
            callback(error, result);
        });
    });     
}

machinePause.prototype.list = function(data, callback) {
    var query = `
        select f.mc_cd
            , concat(f.mc_cd, ' - ', md.name) as mc_name 
            , (max(f.field4 - f.field2) - (select coalesce(sum(pause), 0) 
                                            from machine_pause 
                                            where mc_cd = f.mc_cd
                                            and date_ref = date(max(f.inserted_at)))) as pause
            , time_format(
                sec_to_time(
                    (max(f.field4 - f.field2)*60) - (select coalesce(sum(pause)*60, 0) 
                                                        from machine_pause 
                                                    where mc_cd = f.mc_cd
                                                        and date_ref = date(max(f.inserted_at)))
                ), '%H:%i:%s'
            ) as pause_to_time
            , date_format(max(inserted_at), '%d/%m/%Y %H:%i:%s') as date
            , date_format(max(inserted_at), '%d/%m/%Y') as date_ref
            , null as justification
        from feed	f
        inner join machine_data md on md.code = f.mc_cd
        inner join channel_machine cm on cm.machine_code = md.code
        inner join user_channel uc on uc.channel_id = cm.channel_id
        where date_format(f.inserted_at, '%d/%m/%Y') = ?
          and uc.user_id = 1 
        group by f.mc_cd
    `;  
    this.pool.getConnection(function(err, connection) {
        connection.query(query, 
        [
            data.date, 
            parseInt(data.userId)
        ], 
        function(error, result) {
            connection.release();
            callback(error, result);
        });
    });
}

machinePause.prototype.listPauses = function(data, callback) {
    var query = `
		select mp.id
			 , mp.mc_cd 
			 , md.name
			 , date_format(mp.date_ref, '%d/%m/%Y') as date_ref
			 , mp.justification
             , date_format(mp.inserted_at, '%d/%m/%Y %H:%i:%s') as inserted_at
             , time_format(sec_to_time(mp.pause*60), '%H:%i:%s') as pause
		  from machine_pause mp
         inner join machine_data md on md.code = mp.mc_cd
         inner join channel_machine cm on cm.machine_code = md.code
         inner join user_channel uc on uc.channel_id = cm.channel_id
         where date_format(mp.date_ref, '%d/%m/%Y') = ?
           and uc.user_id = ?
		 order by mp.mc_cd, mp.inserted_at desc 
    `; 
    this.pool.getConnection(function(err, connection) {
        connection.query(query, 
        [
            data.date, 
            parseInt(data.userId)
        ], 
        function(error, result) {
            connection.release();
            callback(error, result);
        });
    });
}

module.exports = function() {
    return machinePause;
};