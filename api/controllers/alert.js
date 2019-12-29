module.exports = function(api) {
    let _alert = api.models.alert;

    this.post = function(req, res, next) {
        const body = req.body;

        //cria asserts para validação
        req.assert('channel_id', 'Preencha o canal corretamente.').notEmpty();
        req.assert('sponsor_id', 'Preencha o responsável corretamente.').notEmpty();
        req.assert('pause_reason_id', 'Preencha o motivo da pausa corretamente.').notEmpty();
        req.assert('pause_time', 'Preencha o tempo de parada corretamente.').notEmpty();

        var errors = req.validationErrors();
        if(errors)
            return res.status(400).send(errors);
        
        _alert.save(body, function(exception, result) {
            if(exception) {
                return res.status(400).send(exception);
            }
            return res.status(200).send(result[0][0] || body);
        });          
                          
    }; 

    this.update = function(req, res, next) {
        const body = req.body;

        //cria asserts para validação
        req.assert('channel_id', 'Preencha o canal corretamente.').notEmpty();
        req.assert('sponsor_id', 'Preencha o responsável corretamente.').notEmpty();
        req.assert('pause_reason_id', 'Preencha o motivo da pausa corretamente.').notEmpty();
        req.assert('pause_time', 'Preencha o tempo de parada corretamente.').notEmpty();

        var errors = req.validationErrors();
        if(errors)
            return res.status(400).send(errors);                         
        
        _alert.update(body, function(exception, results) {
            if(exception) {
                return res.status(500).send(exception);
            }    
            return res.send(body);           
        });            
                         
    };

    this.delete = function(req, res, next) {
        const body = req.body;

        //cria asserts para validação
        req.assert('id', 'Preencha o código corretamente.').notEmpty();

        var errors = req.validationErrors();
        if(errors)
            return res.status(400).send(errors);         
                        
        _alert.delete(body, function(exception, results) {
            if(exception) {
                return res.status(400).send(exception);
            }
            return res.send(body);
        });            
                    
    };
    
    this.list = function(req, res, next) {
        const channelId = req.params.channel;
        
        _alert.list(channelId, function(exception, result) {
            if(exception) {
                return res.status(500).send(exception);
            }
            res.send(result);
        });                
    }; 

    return this;
};