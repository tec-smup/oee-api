const bcrypt = require('bcrypt-nodejs');
const jwt = require('jsonwebtoken');

module.exports = function(api) {
    let _user = api.models.user;

    this.post = function(req, res, next) {
        var bodyData = req.body;
        if(!bodyData.username || !bodyData.password) {
            let error = new Error('Preencha os campos e-mail e senha para se conectar');
            error.status = 200;
            return next(error);
        }
        
        _user.authentication(bodyData.username, function(exception, result) {
            if(exception) {
                let error = new Error(exception);
                return next(error);
            }
            if(!result[0]) {
                let error = new Error('E-mail informado é inválido');
                error.status = 200;
                return next(error);
            }
            if(!bcrypt.compareSync(bodyData.password, result[0].password)) {
                let error = new Error('E-mail/senha inválidos');
                error.status = 200;
                return next(error);
            }

            let expireIn = bodyData.device == "mobile" ? "365d" : "8h";

            jwt.sign(
                { userId: result[0].id }, process.env.JWT_SECRET, { expiresIn: expireIn }, 
                function(err, token) {
                    if(err) {
                        res.status(200).send({
                            success: false,
                            message: 'Erro na geração do token de autenticação',
                            token: '',
                        });
                    }
                    else {
                        res.status(200).send({
                            success: true,
                            message: '',
                            token: token,
                        });
                    }
                });
        });                   
    }; 
    
    return this;
};