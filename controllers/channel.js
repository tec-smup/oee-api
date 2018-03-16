const js2xmlparser = require("js2xmlparser");

const notFound = {
    status: "404",
    error: "Not Found"
};

module.exports = function(app) {
    app.get('/api/:channel/get', function(req, res) {
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

    app.get('/api/:channel/delete', function(req, res) {
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

    app.get('/api/:channel/timeShift', function(req, res) {
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
}
