module.exports = function(api) {
    let _machinePause = api.models.machinePause;

    this.post = function(req, res, next) {
        var bodyData = req.body;

        //cria asserts para validação
        req.assert('mc_cd', 'Uma máquina deve ser selecionada.').notEmpty();
        req.assert('pause', 'Pausa não informada.').notEmpty();
        req.assert('justification', 'Informe uma justificativa.').notEmpty();
        req.assert('date_ref', 'Data de referência não informada.').notEmpty();

        var errors = req.validationErrors();
        if(errors)
            return res.status(400).send(errors);
        
        delete bodyData.token;
        _machinePause.save(bodyData, function(exception, result) {
            if(exception) {
                return res.status(400).send(exception);
            }
            return res.send(bodyData);
        });                   
    }; 

    this.list = function(req, res, next) {
        var query = req.query;       
        
        _machinePause.listPauses(query, function(exception, result) {
            if(exception) {
                return res.status(400).send(exception);
            }
            let dataResult = {
                pauses: result[0],
                pause_grouped: result[1][0] || []
            }
            res.status(200).send(dataResult);            
        });                  
    };

    this.pareto = function(req, res, next) {
        var query = req.query;       
        
        _machinePause.pareto(query, function(exception, result) {
            if(exception) {
                return res.status(400).send(exception);
            }
            let dataResult = {
                pareto: result[0] || []
            }
            res.status(200).send(dataResult);            
        });                  
    };    
    
    return this;
};