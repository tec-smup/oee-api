const path = require('path');

module.exports = function(app) {
    app.post('/oee/api/machine', function(req, res) {
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
                return res.status(400).send(exception);
            }
            if(!result[0]) {
                return res.send('0'); //seguindo modelo do thingspeak
            }

            //null na data
            bodyData.next_maintenance = bodyData.next_maintenance || null;                       
            bodyData.last_maintenance = bodyData.last_maintenance || null;                       
            
            delete bodyData.token;
            machine.save(bodyData, function(exception, result) {
                if(exception) {
                    return res.status(400).send(exception);
                }
                res.send('OK. ' + bodyData.code + ' habilitada para medição.');                 
            });            
        });        
    });

    app.get('/oee/api/machine', function(req, res) { 
        res.sendFile(path.join(__dirname, '../public/', 'machine.html'));       
    });    
}
