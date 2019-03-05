module.exports = function(api) {
    let _machineShift = api.models.machineShift;
    
    this.list = function(req, res, next) {
        var params = req.params;
        _machineShift.list(params, function(exception, result) {
            if(exception) {
                return res.status(500).send(exception);
            }
            res.status(200).send(result);
        });                
    }; 

    this.add = function(req, res, next) {
        var bodyData = req.body;

        //cria asserts para validação
        req.assert('machineCode', 'Máquina não informada.').notEmpty();
        req.assert('hourIni', 'Horário inicial não informado.').notEmpty();
        req.assert('hourFin', 'Horário final não informado.').notEmpty();

        var errors = req.validationErrors();
        if(errors)
            return res.status(400).send(errors);
        
        _machineShift.add(bodyData, function(exception, result) {
            if(exception) {
                return res.status(400).send(exception);
            }                 
            return res.send(bodyData);
        });                 
    };     

    this.delete = function(req, res, next) {
        var bodyData = req.body;

        //cria asserts para validação
        req.assert('id', 'Id não informado.').notEmpty();
       
        var errors = req.validationErrors();
        if(errors)
            return res.status(400).send(errors);         

        _machineShift.delete(bodyData, function(exception, results, fields) {
            if(exception) {
                return res.status(400).send(exception);
            }
            return res.status(200).send(bodyData);
        });
    }; 

    return this;
};