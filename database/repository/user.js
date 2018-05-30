const bcrypt = require('bcrypt-nodejs');
const saltRounds = 10;

function user(connection) {
    this._connection = connection;
}

user.prototype.autentication = function(username, callback) {
    let query = `
        select case admin when 1 then 1 else 0 end as admin
             , username
             , password 
          from user 
         where username = ? 
           and active = true
    `;
    this._connection.query(query, username, callback);
}

user.prototype.list = function(callback) {
    var query = `
        select u.id
            , u.username
            , u.password
            , case u.active when 1 then 'Ativo' else 'Inativo' end as active
            , case u.admin when 1 then 'Sim' else 'Não' end as admin
            , DATE_FORMAT(u.created_at, '%d/%m/%Y %H:%i:%s') as created_at
         from user u	
	`; 
    this._connection.query(query, [], callback);
}

user.prototype.save = function(data, callback) {
    let salt = bcrypt.genSaltSync(saltRounds);
    this._connection.query("call prc_user(?,?,?,?)", [
        data.username,
        bcrypt.hashSync(data.password, salt),
        data.active,
        data.admin
    ], callback);
}

user.prototype.update = function(data, callback) {
    let datetime = new Date();
    let query = `
        update user set active = ?
                      , admin = ? 	
				  where id = ?
	`;
    this._connection.query(query, [
		data.active, 
		data.admin, 
		data.id
	], callback);    
}

user.prototype.delete = function(data, callback) {
    this._connection.query("call prc_delete_user(?)", [data.id], callback);    
}

module.exports = function() {
    return user;
};