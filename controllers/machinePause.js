const path = require('path');

module.exports = function(app) {
	const baseUrl = app.get('BASE_URL');
	
    app.post(baseUrl + 'machinepause', function(req, res) {
        var bodyData = req.body;

        //cria asserts para validação
        req.assert('mc_cd', 'Uma máquina deve ser selecionada.').notEmpty();
        req.assert('pause', 'Pausa não informada.').notEmpty();
        req.assert('justification', 'Informe uma justificativa.').notEmpty();
        req.assert('date_ref', 'Data de referência não informada.').notEmpty();

        var errors = req.validationErrors();
        if(errors)
            return res.status(400).send(errors);

        var pool = app.database.connection.getPool();
        var machinePause = new app.database.repository.machinePause(pool);
        
        delete bodyData.token;
        machinePause.save(bodyData, function(exception, result) {
            if(exception) {
                return res.status(400).send(exception);
            }
            return res.send(bodyData);
        });          
              
    });  

    app.get(baseUrl + 'machinepause/list', function(req, res) {  
        var query = req.query;      
        var pool = app.database.connection.getPool();
        var machinePause = new app.database.repository.machinePause(pool);   
        var data = {};
        
        machinePause.list(query, function(exception, result) {
            if(exception) {
                return res.status(500).send(exception);
            }
            data.list = result;
            
            machinePause.listPauses(query, function(exception, result) {
                if(exception) {
                    return res.status(500).send(exception);
                }
                data.pauses = result;
                res.send(data);                
            });            
        });
    });      

    app.get(baseUrl + 'machinepause', function(req, res) { 
        res.sendFile(path.join(__dirname, '../public/', 'index.html'));       
    });    
}
