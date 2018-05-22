function machinePause(connection) {
    this._connection = connection;
}

machinePause.prototype.autenticateToken = function(token, callback) {
    this._connection.query("select id from channel where token = ?", token, callback);
}

machinePause.prototype.save = function(data, callback) {
    this._connection.query("call prc_machine_pause(?,?,?,?,?,?)", [
        data.mc_cd,
        data.pause_ini,
        data.pause_fin,
        data.justification1,
        data.justification2,
        data.justification3
    ], callback);
}

machinePause.prototype.update = function(data, callback) {
    let query = `
        update machine_pause 
           set mc_cd = ?, 
               pause_ini = STR_TO_DATE(?, '%d/%m/%Y')
               , pause_fin = STR_TO_DATE(?, '%d/%m/%Y')
               , justification1 = ?
               , justification2 = ?
               , justification3 = ?    
         where id = ?
    `;
    this._connection.query(query, [
        data.mc_cd,
        data.pause_ini,
        data.pause_fin,
        data.justification1,
        data.justification2,
        data.justification3
    ], callback);    
}

machinePause.prototype.delete = function(data, callback) {
    this._connection.query("call prc_delete_machine_pause(?)", [data.id], callback);    
}

machinePause.prototype.list = function(data, callback) {
    var query = `
        select f.mc_cd
            , concat(f.mc_cd, ' - ', md.name) as mc_name 
            , max(f.field4 - f.field2) as pause
            , time_format(
                sec_to_time(
                    max(f.field4 - f.field2) - (select coalesce(sum(pause), 0) from machine_pause where mc_cd = f.mc_cd)
                ), '%H:%i:%s'
            ) as pause_to_time
            , date_format(max(inserted_at), '%d/%m/%Y %H:%i:%s') as date
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