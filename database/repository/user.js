function user(connection) {
    this._connection = connection;
}

user.prototype.autentication = function(username, callback) {
    this._connection.query("select admin, username, password from user where username = ? and active = true", username, callback);
}

module.exports = function() {
    return user;
};