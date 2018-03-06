const bcrypt = require('bcrypt-nodejs');

module.exports = function(app) {
    app.post('/oee/api/user/authentication', function(req, res) {
        var bodyData = req.body;

        var connection = app.database.connection();
        var user = new app.database.repository.user(connection);

        user.autentication(bodyData.username, function(exception, result) {
            if(exception) {
                return res.status(400).send(exception);
            }
            if(!result[0]) {
                return res.send({success: false, message: 'Usuário não existe'});
            }
            if(!bcrypt.compareSync(bodyData.password, result[0].password)) {
                return res.send({success: false, message: 'Usuário/senha incorreto'});
            }
            res.send(result[0]);            
        });        
    });
}
