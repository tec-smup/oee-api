function machinePause(connection) {
    this._connection = connection;
}

machinePause.prototype.autenticateToken = function(token, callback) {
    this._connection.query("select id from channel where token = ?", token, callback);
}

machinePause.prototype.save = function(data, callback) {
    this._connection.query("call prc_machine_pause(?,?,?,?)", [
        data.mc_cd,
        data.pause,
        data.date_ref,
        data.justification
    ], callback);
}

machinePause.prototype.list = function(data, callback) {
    var query = `
        select f.mc_cd
            , concat(f.mc_cd, ' - ', md.name) as mc_name 
            , max(f.field4 - f.field2) - (select coalesce(sum(pause), 0) 
                                            from machine_pause 
                                            where mc_cd = f.mc_cd
                                            and date_ref = date(max(f.inserted_at))) as pause
            , time_format(
                sec_to_time(
                    max(f.field4 - f.field2) - (select coalesce(sum(pause), 0) 
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
        where date_format(f.inserted_at, '%d/%m/%Y') = ? 
        group by f.mc_cd
    `;    
    this._connection.query(query, [data.date], callback);
}

module.exports = function() {
    return machinePause;
};