const path = require('path');

module.exports = function(app) {
	const baseUrl = app.get('BASE_URL');
	
    app.post(baseUrl + 'machine', function(req, res) {
        var bodyData = req.body;

        //cria asserts para validação
        req.assert('code', 'Preencha o código corretamente.').notEmpty();
        req.assert('name', 'Preencha o nome corretamente.').notEmpty();

        var errors = req.validationErrors();
        if(errors)
            return res.status(400).send(errors);

        var connection = app.database.connection();
        var machine = new app.database.repository.machine(connection);

        machine.autenticateToken(bodyData.token, function(exception, result) {
            if(exception) {
                return res.status(500).send(exception);
            }
            if(!result[0]) {
                return res.status(401).send('Token inválido');
            }

            //null na data
            bodyData.next_maintenance = bodyData.next_maintenance || null;                       
            bodyData.last_maintenance = bodyData.last_maintenance || null;                       
            
            delete bodyData.token;
            machine.save(bodyData, function(exception, result) {
                if(exception) {
                    return res.status(400).send(exception);
                }
                return res.send(bodyData);
            });          
        });        
    });

    app.post(baseUrl + 'machine/update', function(req, res) {
        var bodyData = req.body;

        //cria asserts para validação
        req.assert('code', 'Preencha o código corretamente.').notEmpty();
        req.assert('name', 'Preencha o nome corretamente.').notEmpty();

        var errors = req.validationErrors();
        if(errors)
            return res.status(400).send(errors);       

        var connection = app.database.connection();
        var machine = new app.database.repository.machine(connection);

        machine.autenticateToken(bodyData.token, function(exception, result) {
            if(exception) {
                return res.status(500).send(exception);
            }
            if(!result[0]) {
                return res.status(401).send('Token inválido');
            }

            //null na data
            bodyData.next_maintenance = bodyData.next_maintenance || null;                       
            bodyData.last_maintenance = bodyData.last_maintenance || null;                       
            
            delete bodyData.token;
            machine.update(bodyData, function(exception, results, fields) {
                if(exception) {
                    return res.status(500).send(exception);
                }    
                return res.send(bodyData);           
            });            
        });        
    });

    app.post(baseUrl + 'machine/delete', function(req, res) {
        var bodyData = req.body;

        //cria asserts para validação
        req.assert('code', 'Preencha o código corretamente.').notEmpty();

        var errors = req.validationErrors();
        if(errors)
            return res.status(400).send(errors);         

        var connection = app.database.connection();
        var machine = new app.database.repository.machine(connection);

        machine.autenticateToken(bodyData.token, function(exception, result) {
            if(exception) {
                res.status(500).send(exception);
            }
            if(!result[0]) {
                return res.status(401).send('Token inválido');
            }
                        
            delete bodyData.token;
            machine.delete(bodyData, function(exception, results, fields) {
                if(exception) {
                    return res.status(400).send(exception);
                }
                return res.send(bodyData);
            });            
        });        
    });    

    app.get(baseUrl + 'machine/list', function(req, res) {        
        var connection = app.database.connection();
        var machine = new app.database.repository.machine(connection);   
        
        machine.list(function(exception, result) {
            if(exception) {
                return res.status(500).send(exception);
            }
            res.send(result);
            connection.end();
        });                    
    });      

    app.get(baseUrl + 'machine', function(req, res) { 
        res.sendFile(path.join(__dirname, '../public/', 'machine.html'));       
    });    
}
