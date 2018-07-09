const bcrypt = require('bcrypt-nodejs');
const jwt = require('jsonwebtoken');

module.exports = function(app) {
	const baseUrl = app.get('BASE_URL');
	
    app.post(baseUrl + 'user/authentication', function(req, res) {
        var bodyData = req.body;
        if(!bodyData.username || !bodyData.password) {
            return res.send({
                success: false, 
                message: 'Preencha os campos email e senha para se conectar'
            });
        }
        
        var pool = app.database.connection.getPool();
        var user = new app.database.repository.user(pool);

        user.autentication(bodyData.username, function(exception, result) {
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
                app.get('JWT_SECRET'), 
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
    });

    app.get(baseUrl + 'user', function(req, res) {
        var pool = app.database.connection.getPool();
        var user = new app.database.repository.user(pool);        
        
        user.list(function(exception, result) {
            if(exception) {
                return res.status(500).send(exception);
            }
            res.send(result);
        });
    });     

    app.post(baseUrl + 'user', function(req, res) {
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

        var pool = app.database.connection.getPool();
        var user = new app.database.repository.user(pool);

        user.save(bodyData, function(exception, result) {
            if(exception) {
                return res.status(400).send(exception);
            }                 
            return res.send(bodyData);
        });
    });
    
    app.post(baseUrl + 'user/update', function(req, res) {
        var bodyData = req.body;

        //cria asserts para validação
        req.assert('id', 'Erro na edição do registro.').notEmpty();

        var errors = req.validationErrors();
        if(errors)
            return res.status(400).send(errors);       

        var pool = app.database.connection.getPool();
        var user = new app.database.repository.user(pool);        

        user.update(bodyData, function(exception, results, fields) {
            if(exception) {
                return res.status(500).send(exception);
            }    
            return res.send(bodyData);           
        });
    });

    app.post(baseUrl + 'user/delete', function(req, res) {
        var bodyData = req.body;

        //cria asserts para validação
        req.assert('id', 'Erro na edição do registro.').notEmpty();

        var errors = req.validationErrors();
        if(errors)
            return res.status(400).send(errors);         

        var pool = app.database.connection.getPool();
        var user = new app.database.repository.user(pool);          
                        
        user.delete(bodyData, function(exception, results, fields) {
            if(exception) {
                return res.status(400).send(exception);
            }
            return res.send(bodyData);
        });   
    });     
}
