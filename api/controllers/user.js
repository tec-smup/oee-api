const bcrypt = require('bcrypt-nodejs');
const jwt = require('jsonwebtoken');

module.exports = function(api) {
    let _user = api.models.user;

    this.authentication = function(req, res, next) {
        var bodyData = req.body;
        if(!bodyData.username || !bodyData.password) {
            return res.send({
                success: false, 
                message: 'Preencha os campos email e senha para se conectar'
            });
        }
        
        _user.authentication(bodyData.username, function(exception, result) {
            if(exception) {
                return res.status(400).send(exception);
            }
            if(!result[0]) {
                return res.send({
                    success: false, 
                    message: 'Ops, o e-mail informado é inválido'
                });
            }
            if(!bcrypt.compareSync(bodyData.password, result[0].password)) {
                return res.send({
                    success: false, 
                    message: 'A senha informada está incorreta'
                });
            }

            jwt.sign(
                { username: result[0].username, admin: result[0].admin, id: result[0].id }, 
                process.env.JWT_SECRET, 
                { expiresIn: '2h' }, 
                function(err, token) {
                    if(err) {
                        res.send({
                            success: false,
                            message: 'Erro na geração do token de autenticação',
                            token: '',
                            admin: false,
                            id: 0,
                            channel: '',
                            initial_turn: '08:00',
                            final_turn: '18:00'
                        });
                    }
                    else {
                        res.send({
                            success: true,
                            message: '',
                            token: token,
                            admin: result[0].admin,
                            id: result[0].id,
                            channel: result[0].name,
                            initial_turn: result[0].initial_turn,
                            final_turn: result[0].final_turn                            
                        });
                    }
                });
        });                   
    }; 

    this.list = function(req, res, next) {        
        _user.list(function(exception, result) {
            if(exception) {
                return res.status(500).send(exception);
            }
            res.status(200).send(result);
        });                 
    };

    this.getUserData = function(req, res, next) {
        _user.getUserData(req.userId, function(exception, result) {
            if(exception) {
                return res.status(500).send(exception);
            }
            res.status(200).send(result[0]);
        });
    };

    this.post = function(req, res, next) {
        var bodyData = req.body;

        //cria asserts para validação
        req.assert('username', 'Preencha o usuário corretamente.').notEmpty();
        req.assert('password', 'Preencha a senha corretamente.').notEmpty();
        if(bodyData.isMobile) {
            req.assert('company_name', 'Preencha a empresa corretamente.').notEmpty();
            req.assert('phone', 'Preencha o telefone corretamente.').notEmpty();
        }

        var errors = req.validationErrors();
        if(errors)
            return res.status(400).send(errors);

        _user.save(bodyData, function(exception, result) {
            if(exception) {
                return res.status(400).send(exception);
            }                 
            return res.send(bodyData);
        });        
    };

    this.update = function(req, res, next) {
        var bodyData = req.body;

        //cria asserts para validação
        req.assert('id', 'Erro na edição do registro.').notEmpty();

        var errors = req.validationErrors();
        if(errors)
            return res.status(400).send(errors);       

        _user.update(bodyData, function(exception, results, fields) {
            if(exception) {
                return res.status(500).send(exception);
            }    
            return res.send(bodyData);           
        });
    };

    this.delete = function(req, res, next) {
        var bodyData = req.body;

        //cria asserts para validação
        req.assert('id', 'Erro na edição do registro.').notEmpty();

        var errors = req.validationErrors();
        if(errors)
            return res.status(400).send(errors);         
                        
        _user.delete(bodyData, function(exception, results, fields) {
            if(exception) {
                return res.status(400).send(exception);
            }
            return res.send(bodyData);
        });        
    };

    this.changePass = function(req, res, next) {
        var bodyData = req.body;

        //cria asserts para validação
        req.assert('id', 'Usuário não informado.').notEmpty();
        req.assert('password', 'Senha não informada.').notEmpty();

        var errors = req.validationErrors();
        if(errors)
            return res.status(400).send(errors);       

        _user.changePass(bodyData, function(exception, results, fields) {
            if(exception) {
                return res.status(500).send(exception);
            }    
            return res.send(bodyData);           
        });
    };    
    
    return this;
};