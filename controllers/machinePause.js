const path = require('path');

module.exports = function(app) {
	const baseUrl = app.get('BASE_URL');
	
    app.post(baseUrl + 'machinepause', function(req, res) {
        var bodyData = req.body;

        //cria asserts para validação
        req.assert('mc_cd', 'Uma máquina deve ser selecionada.').notEmpty();
        req.assert('pause_ini', 'Informe uma data inicial.').notEmpty();
        req.assert('pause_fin', 'Informe uma data final.').notEmpty();

        var errors = req.validationErrors();
        if(errors)
            return res.status(400).send(errors);

        var connection = app.database.connection();
        var machinePause = new app.database.repository.machinePause(connection);
        
        delete bodyData.token;
        machinePause.save(bodyData, function(exception, result) {
            if(exception) {
                return res.status(400).send(exception);
            }
            return res.send(bodyData);
        });          
              
    });

    app.post(baseUrl + 'machinepause/update', function(req, res) {
        var bodyData = req.body;

        //cria asserts para validação
        req.assert('mc_cd', 'Uma máquina deve ser selecionada.').notEmpty();
        req.assert('pause_ini', 'Informe uma data inicial.').notEmpty();
        req.assert('pause_fin', 'Informe uma data final.').notEmpty();


        var errors = req.validationErrors();
        if(errors)
            return res.status(400).send(errors);       

        var connection = app.database.connection();
        var machinePause = new app.database.repository.machinePause(connection);

        //null na data
        bodyData.next_maintenance = bodyData.next_maintenance || null;                       
        bodyData.last_maintenance = bodyData.last_maintenance || null;                       
        
        delete bodyData.token;
        machinePause.update(bodyData, function(exception, results, fields) {
            if(exception) {
                return res.status(500).send(exception);
            }    
            return res.send(bodyData);           
        });            
        
    });

    app.post(baseUrl + 'machinepause/delete', function(req, res) {
        var bodyData = req.body;

        //cria asserts para validação
        req.assert('id', 'Selecione ao menos um registro para deletar.').notEmpty();

        var errors = req.validationErrors();
        if(errors)
            return res.status(400).send(errors);         

        var connection = app.database.connection();
        var machinePause = new app.database.repository.machinePause(connection);
                        
        delete bodyData.token;
        machinePause.delete(bodyData, function(exception, results, fields) {
            if(exception) {
                return res.status(400).send(exception);
            }
            return res.send(bodyData);
        });            
    });    

    app.get(baseUrl + 'machinepause/list', function(req, res) {        
        var connection = app.database.connection();
        var machinePause = new app.database.repository.machinePause(connection);   
        
        machinePause.list(function(exception, result) {
            if(exception) {
                return res.status(500).send(exception);
            }
            res.send(result);
            connection.end();
        });                    
    });      

    app.get(baseUrl + 'machinepause', function(req, res) { 
        res.sendFile(path.join(__dirname, '../public/', 'index.html'));       
    });    
}
