const js2xmlparser = require("js2xmlparser");

const notFound = {
    status: "404",
    error: "Not Found"
};

module.exports = function(app) {
	const baseUrl = app.get('BASE_URL');
	
    app.get(baseUrl + ':channel/get', function(req, res) {
        var channelId = req.params.channel;
        var params = req.query;  
            params.channel_id = channelId;
        var data = {};
        
        var connection = app.database.connection();
        var channel = new app.database.repository.channel(connection);   
        
        channel.getChannel(params, function(exception, result) {
            if(exception) {
                return res.status(400).send(exception);
            }
            if(!result[0]) {
                return res.send(notFound); //seguindo modelo do thingspeak
            }
            data.channel = result;

            channel.getFeeds(params, function(exception, result) {
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
                connection.end();
            });            
        });         
    });  

    app.get(baseUrl + ':channel/delete', function(req, res) {
        var channelId = req.params.channel;
        var params = req.query;  
            params.channel_id = channelId;
        
        var connection = app.database.connection();
        var channel = new app.database.repository.channel(connection);   
        
        channel.getChannel(params, function(exception, result) {
            if(exception) {
                return res.status(400).send(exception);
            }
            if(!result[0]) {
                return res.send(notFound); //seguindo modelo do thingspeak
            }

            channel.deleteFeeds(params, function(exception, result) {
                if(exception) {
                    return res.status(400).send(exception);
                }
                res.send('deleted rows: ' + result.affectedRows); 
                connection.end();               
            });            
        });         
    });    

    app.get(baseUrl + ':channel/timeShift', function(req, res) {
        var channelId = req.params.channel;
        var params = req.query;  
            params.channel_id = channelId;
        
        var connection = app.database.connection();
        var channel = new app.database.repository.channel(connection);   
        
        channel.getChannel(params, function(exception, result) {
            if(exception) {
                return res.status(400).send(exception);
            }
            if(!result[0]) {
                return res.send(notFound); //seguindo modelo do thingspeak
            }

            channel.timeShift(params, function(exception, result) {
                if(exception) {
                    return res.status(400).send(exception);
                }
                res.send(result);
                connection.end();
            });            
        });         
    });     

    app.get(baseUrl + 'channel', function(req, res) {
        var connection = app.database.connection();
        var channel = new app.database.repository.channel(connection);   
        
        channel.list(function(exception, result) {
            if(exception) {
                return res.status(500).send(exception);
            }
            res.send(result);
            connection.end();
        });
    });    

    app.post(baseUrl + 'channel', function(req, res) {
        var bodyData = req.body;

        //cria asserts para validação
        req.assert('name', 'Preencha o nome corretamente.').notEmpty();
        req.assert('token', 'Preencha o token corretamente.').notEmpty();

        var errors = req.validationErrors();
        if(errors)
            return res.status(400).send(errors);

        var connection = app.database.connection();
        var channel = new app.database.repository.channel(connection);
        
        channel.save(bodyData, function(exception, result) {
            if(exception) {
                return res.status(400).send(exception);
            }                 
            return res.send(bodyData);
        });          
              
    });

    app.post(baseUrl + 'channel/update', function(req, res) {
        var bodyData = req.body;

        //cria asserts para validação
        req.assert('id', 'Erro na edição do registro.').notEmpty();
        req.assert('name', 'Preencha o nome corretamente.').notEmpty();
        req.assert('token', 'Preencha o token corretamente.').notEmpty();

        var errors = req.validationErrors();
        if(errors)
            return res.status(400).send(errors);       

        var connection = app.database.connection();
        var channel = new app.database.repository.channel(connection);

        channel.update(bodyData, function(exception, results, fields) {
            if(exception) {
                return res.status(500).send(exception);
            }    
            return res.send(bodyData);           
        });
    });

    app.post(baseUrl + 'channel/delete', function(req, res) {
        var bodyData = req.body;

        //cria asserts para validação
        req.assert('id', 'Erro na edição do registro.').notEmpty();

        var errors = req.validationErrors();
        if(errors)
            return res.status(400).send(errors);         

        var connection = app.database.connection();
        var channel = new app.database.repository.channel(connection);
                        
        delete bodyData.token;
        channel.delete(bodyData, function(exception, results, fields) {
            if(exception) {
                return res.status(400).send(exception);
            }
            return res.send(bodyData);
        });
               
    });     
}
