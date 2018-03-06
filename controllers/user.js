const bcrypt = require('bcrypt-nodejs');
const jwt = require('jsonwebtoken');

module.exports = function(app) {
    app.post('/oee/api/user/authentication', function(req, res) {
        var bodyData = req.body;
        console.log(bodyData);
        if(!bodyData.username || !bodyData.password) {
            return res.send({
                success: false, 
                message: 'Usuário ou senha não informado'
            });
        }
        
        var connection = app.database.connection();
        var user = new app.database.repository.user(connection);

        user.autentication(bodyData.username, function(exception, result) {
            if(exception) {
                return res.status(400).send(exception);
            }
            if(!result[0]) {
                return res.send({
                    success: false, 
                    message: 'Usuário não existe'
                });
            }
            if(!bcrypt.compareSync(bodyData.password, result[0].password)) {
                return res.send({
                    success: false, 
                    message: 'Usuário/senha incorreto'
                });
            }

            jwt.sign(
                { username: result[0].username, admin: result[0].admin }, 
                app.get('jwtSecret'), 
                { expiresIn: '8h' }, 
                function(err, token) {
                    if(err) {
                        res.send({
                            success: false,
                            message: 'Erro na geração do token de autenticação',
                            token: ''
                        });
                    }
                    else {
                        res.send({
                            success: true,
                            message: '',
                            token: token
                        });
                    }              
                });
        });        
    });
}
