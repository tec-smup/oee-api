const js2xmlparser = require("js2xmlparser");

const notFound = {
    status: "404",
    error: "Not Found"
};

module.exports = function(api) {
    let _channel = api.models.channel;

    this.get = function(req, res, next) {
        var channelId = req.params.channel;
        var params = req.query;  
            params.channel_id = channelId;
        var data = {};
        
        _channel.getChannel(params, function(exception, result) {
            if(exception) {
                return res.status(400).send(exception);
            }
            if(!result[0]) {
                return res.send(notFound); //seguindo modelo do thingspeak
            }
            data.channel = result;

            _channel.getFeeds(params, function(exception, result) {
                if(exception) {
                    return res.status(400).send(exception);
                }
                if(result[0]) {
                    data.feeds = result;
                }
                if(parseInt(params.toXml) == 1) {
                    res.set('Content-Type', 'text/xml');
                    res.send(js2xmlparser.parse("data", data));                    
                }
                else {
                    res.send(data);
                }
            });            
        });                    
    }; 

    this.deleteFeeds = function(req, res, next) {
        var channelId = req.params.channel;
        var params = req.query;  
            params.channel_id = channelId;
        
        _channel.getChannel(params, function(exception, result) {
            if(exception) {
                return res.status(400).send(exception);
            }
            if(!result[0]) {
                return res.send(notFound); //seguindo modelo do thingspeak
            }

            _channel.deleteFeeds(params, function(exception, result) {
                if(exception) {
                    return res.status(400).send(exception);
                }
                res.send('deleted rows: ' + result.affectedRows);               
            });            
        });                 
    };

    this.timeShift = function(req, res, next) {
        var channelId = req.params.channel;
        var params = req.query;  
            params.channel_id = channelId;
                
        _channel.getChannel(params, function(exception, result) {
            if(exception) {
                return res.status(400).send(exception);
            }
            if(!result[0]) {
                return res.send(notFound); //seguindo modelo do thingspeak
            }

            _channel.timeShift(params, function(exception, result) {
                if(exception) {
                    return res.status(400).send(exception);
                }
                res.send(result);
            });            
        });               
    };
    
    this.userChannel = function(req, res, next) {
        var userId = req.params.user;
        
        _channel.listByUser(userId, function(exception, result) {
            if(exception) {
                return res.status(500).send(exception);
            }
            res.send(result);
        });              
    }; 

    this.listAll = function(req, res, next) {        
        _channel.listAll(function(exception, result) {
            if(exception) {
                return res.status(500).send(exception);
            }
            res.send(result);
        });              
    };     
    
    this.post = function(req, res, next) {
        var bodyData = req.body;

        //cria asserts para validação
        req.assert('name', 'Preencha o nome corretamente.').notEmpty();
        req.assert('token', 'Preencha o token corretamente.').notEmpty();

        var errors = req.validationErrors();
        if(errors)
            return res.status(400).send(errors);
        
        _channel.save(bodyData, function(exception, result) {
            if(exception) {
                return res.status(400).send(exception);
            }                 
            return res.send(bodyData);
        });                 
    }; 

    this.update = function(req, res, next) {
        var bodyData = req.body;

        //cria asserts para validação
        req.assert('id', 'Erro na edição do registro.').notEmpty();
        req.assert('name', 'Preencha o nome corretamente.').notEmpty();
        req.assert('token', 'Preencha o token corretamente.').notEmpty();

        var errors = req.validationErrors();
        if(errors)
            return res.status(400).send(errors);       

        _channel.update(bodyData, function(exception, results, fields) {
            if(exception) {
                return res.status(500).send(exception);
            }    
            return res.send(bodyData);           
        });
    };
    
    this.delete = function(req, res, next) {
        var bodyData = req.body;

        //cria asserts para validação
        req.assert('id', 'Erro na edição do registro.').notEmpty();

        var errors = req.validationErrors();
        if(errors)
            return res.status(400).send(errors);         

        delete bodyData.token;
        _channel.delete(bodyData, function(exception, results, fields) {
            if(exception) {
                return res.status(400).send(exception);
            }
            return res.send(bodyData);
        });
    };

    return this;
};