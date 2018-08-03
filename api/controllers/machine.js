module.exports = function(api) {
    let _machine = api.models.machine;

    this.post = function(req, res, next) {
        var bodyData = req.body;

        //cria asserts para validação
        req.assert('code', 'Preencha o código corretamente.').notEmpty();
        req.assert('name', 'Preencha o nome corretamente.').notEmpty();

        var errors = req.validationErrors();
        if(errors)
            return res.status(400).send(errors);

        //null na data
        bodyData.next_maintenance = bodyData.next_maintenance || null;                       
        bodyData.last_maintenance = bodyData.last_maintenance || null;                       
        
        _machine.save(bodyData, function(exception, result) {
            if(exception) {
                return res.status(400).send(exception);
            }
            return res.status(200).send(result[1][0] || bodyData);
        });          
                          
    }; 

    this.update = function(req, res, next) {
        var bodyData = req.body;

        //cria asserts para validação
        req.assert('code', 'Preencha o código corretamente.').notEmpty();
        req.assert('name', 'Preencha o nome corretamente.').notEmpty();

        var errors = req.validationErrors();
        if(errors)
            return res.status(400).send(errors);       

        //null na data
        bodyData.next_maintenance = bodyData.next_maintenance || null;                       
        bodyData.last_maintenance = bodyData.last_maintenance || null;                       
        
        _machine.update(bodyData, function(exception, results, fields) {
            if(exception) {
                return res.status(500).send(exception);
            }    
            return res.send(bodyData);           
        });            
                         
    };

    this.delete = function(req, res, next) {
        var bodyData = req.body;

        //cria asserts para validação
        req.assert('code', 'Preencha o código corretamente.').notEmpty();

        var errors = req.validationErrors();
        if(errors)
            return res.status(400).send(errors);         
                        
        _machine.delete(bodyData, function(exception, results, fields) {
            if(exception) {
                return res.status(400).send(exception);
            }
            return res.send(bodyData);
        });            
                    
    };
    
    this.list = function(req, res, next) {
        var userId = req.params.user;
        var channelId = req.params.channel;
        
        _machine.list(userId, channelId, function(exception, result) {
            if(exception) {
                return res.status(500).send(exception);
            }
            res.send(result);
        });                
    }; 

    this.listAll = function(req, res, next) {        
        _machine.listAll(function(exception, result) {
            if(exception) {
                return res.status(500).send(exception);
            }
            res.send(result);
        });                
    };     

    this.listByChannel = function(req, res, next) {
        var channelId = req.params.channel;
        
        _machine.listByChannel(channelId, function(exception, result) {
            if(exception) {
                return res.status(500).send(exception);
            }
            res.send(result);
        });                
    };     
    
    this.getMax = function(req, res, next) {
        var machineId = req.params.machine;
        var params = req.query;  
            params.mc_cd = machineId;
                
        _machine.autenticateToken(params.token, function(exception, result) {
            if(exception) {
                res.status(500).send(exception);
            }
            if(!result[0]) {
                return res.status(401).send('Token inválido');
            }
            
            params.ch_id = result[0].id;
            _machine.getMax(params, function(exception, results, fields) {
                if(exception) {
                    return res.status(400).send(exception);
                }
                return res.status(200).send(results[0].value);
            });            
        });                
    }; 
    
    return this;
};