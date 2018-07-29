module.exports = function(api) {
    let _machineConfig = api.models.machineConfig;
    
    this.list = function(req, res, next) {
        var machineCode = req.params.machine;
        
        _machineConfig.list(machineCode, function(exception, result) {
            if(exception) {
                return res.status(500).send(exception);
            }
            res.status(200).send(result[0] || {});
        });                
    }; 

    this.updateConfig = function(req, res, next) {
        var bodyData = req.body;

        //cria asserts para validação
        req.assert('machine_code', 'Máquina não informada.').notEmpty();
        req.assert('chart_tooltip_desc', 'Tooltip do gráfico não informado.').notEmpty();

        var errors = req.validationErrors();
        if(errors)
            return res.status(400).send(errors);
        
        _machineConfig.updateConfig(bodyData, function(exception, result) {
            if(exception) {
                return res.status(400).send(exception);
            }
            return res.status(200).send(bodyData);
        });
    };     

    this.updateSQL = function(req, res, next) {
        var bodyData = req.body;

        //cria asserts para validação
        req.assert('machine_code', 'Máquina não informada.').notEmpty();

        var errors = req.validationErrors();
        if(errors)
            return res.status(400).send(errors);
        
        _machineConfig.updateSQL(bodyData, function(exception, result) {
            if(exception) {
                return res.status(400).send(exception);
            }
            return res.status(200).send(bodyData);
        });
    };      
    
    return this;
};