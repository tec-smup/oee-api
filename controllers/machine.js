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

        machine.save(bodyData, function(exception, result) {
            if(exception) {
                return res.status(400).send(exception);
            }
            bodyData.id = result.insertId; 
            res.send(bodyData);                 
        });        
    });

    app.get('/oee/api/machine', function(req, res) { 
        res.sendFile(path.join(__dirname, '../html/', 'machine.html'));       
    });    
}
