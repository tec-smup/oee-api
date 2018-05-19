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

machinePause.prototype.list = function(callback) {
    var query = `
        select id
             , mc_cd
             , DATE_FORMAT(pause_ini, '%d/%m/%Y')
             , DATE_FORMAT(pause_fin, '%d/%m/%Y')
             , justification1
             , justification2
             , justification3
          from machine_pause
    `;    
    this._connection.query(query, [], callback);
}

module.exports = function() {
    return machinePause;
};