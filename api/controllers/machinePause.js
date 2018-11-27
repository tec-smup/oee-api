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

    // this.list = function(req, res, next) {
    //     var query = req.query;       
    //     var data = {};
        
    //     _machinePause.list(query, function(exception, result) {
    //         if(exception) {
    //             return res.status(500).send(exception);
    //         }
    //         data.list = result;
            
    //         _machinePause.listPauses(query, function(exception, result) {
    //             if(exception) {
    //                 return res.status(500).send(exception);
    //             }
    //             data.pauses = result;
    //             res.send(data);                
    //         });            
    //     });                 
    // };
    
    return this;
};