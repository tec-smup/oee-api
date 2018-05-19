function machine(connection) {
    this._connection = connection;
}

machine.prototype.autenticateToken = function(token, callback) {
    this._connection.query("select id from channel where token = ?", token, callback);
}

machine.prototype.save = function(data, callback) {
    this._connection.query("call prc_machine_data(?,?,?,?,?,?)", [
        data.code,
        data.name,
        data.department,
        data.product,
        data.last_maintenance,
        data.next_maintenance
    ], callback);
}

machine.prototype.update = function(data, callback) {
    let query = "update machine_data set name = ?, department = ?, product = ?, last_maintenance = STR_TO_DATE(?, '%d/%m/%Y'), next_maintenance = STR_TO_DATE(?, '%d/%m/%Y')";
        query += " where code = ?";
    this._connection.query(query, [
        data.name, 
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

machine.prototype.list = function(callback) {
    var query = `
		select code
			 , name
			 , department
			 , product
			 , DATE_FORMAT(last_maintenance, '%d/%m/%Y') as last_maintenance 
			 , DATE_FORMAT(next_maintenance, '%d/%m/%Y') as next_maintenance
			 , concat('[', code, '] ', name) as dropdown_label
		  from machine_data	
	`;
    this._connection.query(query, [], callback);
}

module.exports = function() {
    return machine;
};