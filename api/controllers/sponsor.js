module.exports = function(api) {
    let _sponsor = api.models.sponsor;

    this.post = function(req, res, next) {
        const body = req.body;

        //cria asserts para validação
        req.assert('channel_id', 'Preencha o canal corretamente.').notEmpty();
        req.assert('email', 'Preencha o email corretamente.').notEmpty();
        req.assert('sponsor_name', 'Preencha o nome corretamente.').notEmpty();

        var errors = req.validationErrors();
        if(errors)
            return res.status(400).send(errors);
        
        _sponsor.save(body, function(exception, result) {
            if(exception) {
                return res.status(400).send(exception);
            }
            const sponsor = result[0][0] || {};
            return res.status(200).send(sponsor || body);
        });          
                          
    }; 

    this.update = function(req, res, next) {
        const body = req.body;

        //cria asserts para validação
        req.assert('channel_id', 'Preencha o canal corretamente.').notEmpty();
        req.assert('email', 'Preencha o email corretamente.').notEmpty();
        req.assert('sponsor_name', 'Preencha o nome corretamente.').notEmpty();

        var errors = req.validationErrors();
        if(errors)
            return res.status(400).send(errors);                         
        
        _sponsor.update(body, function(exception, results) {
            if(exception) {
                return res.status(500).send(exception);
            }    
            return res.send(body);           
        });            
                         
    };

    this.delete = function(req, res, next) {
        const body = req.body;

        //cria asserts para validação
        req.assert('sponsor_id', 'Preencha o código corretamente.').notEmpty();

        var errors = req.validationErrors();
        if(errors)
            return res.status(400).send(errors);         
                        
        _sponsor.delete(body, function(exception, results) {
            if(exception) {
                return res.status(400).send(exception);
            }
            return res.send(body);
        });            
                    
    };
    
    this.list = function(req, res, next) {
        const channelId = req.params.channel;
        
        _sponsor.list(channelId, function(exception, result) {
            if(exception) {
                return res.status(500).send(exception);
            }
            res.send(result);
        });                
    }; 

    return this;
};