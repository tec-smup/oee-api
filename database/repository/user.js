function user(connection) {
    this._connection = connection;
}

user.prototype.autentication = function(username, callback) {
    this._connection.query("select password from user where username = ?", username, callback);
}

module.exports = function() {
    return user;
};