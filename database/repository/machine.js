function machine(connection) {
    this._connection = connection;
}

machine.prototype.autenticateToken = function(token, callback) {
    this._connection.query("select id from channel where token = ?", token, callback);
}

machine.prototype.save = function(data, callback) {
    this._connection.query("call prc_machine_data(?,?,?,?,?,?,?,?)", [
        data.code,
        data.name,
        data.mobile_name,
        data.department,
        data.product,
        data.last_maintenance,
        data.next_maintenance,
        data.userId
    ], callback);
}

machine.prototype.update = function(data, callback) {
    let query = `update machine_data 
                    set name = ?, 
                        mobile_name = ?,
                        department = ?, 
                        product = ?, 
                        last_maintenance = STR_TO_DATE(?, '%d/%m/%Y'), 
                        next_maintenance = STR_TO_DATE(?, '%d/%m/%Y')
                  where code = ?`;
    this._connection.query(query, [
        data.name, 
        data.mobile_name,
        data.department, 
        data.product, 
        data.last_maintenance, 
        data.next_maintenance, 
        data.code
    ], callback);    
}

machine.prototype.delete = function(data, callback) {
    this._connection.query("call prc_delete_machine_data(?)", [data.code], callback);    
}

machine.prototype.list = function(userId, channelId, callback) {
    var query = `
		select code
             , name
             , mobile_name
			 , department
			 , product
			 , DATE_FORMAT(last_maintenance, '%d/%m/%Y') as last_maintenance 
			 , DATE_FORMAT(next_maintenance, '%d/%m/%Y') as next_maintenance
			 , concat('[', code, '] ', name) as dropdown_label
		  from machine_data	
         inner join channel_machine cm on cm.machine_code = code
         inner join user_channel uc on uc.channel_id = cm.channel_id
         where uc.user_id = ?
           and ((uc.channel_id = ?) or ? = 0)
	`;
    this._connection.query(query, [parseInt(userId), parseInt(channelId), parseInt(channelId)], callback);
}

machine.prototype.getMax = function(params, callback) {
    var query = `
        select f.field1
             , f.field2
             , f.field3
             , f.field4
             , f.field5
          from feed f
         where id = (select max(id) 
                       from feed 
                      where mc_cd = ? 
                        and ch_id = ?)
	`;
    this._connection.query(query, [params.mc_cd, parseInt(params.ch_id)], callback);
}

module.exports = function() {
    return machine;
};