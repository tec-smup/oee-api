const notFound = {
    status: "404",
    error: "Not Found"
};

module.exports = function(app) {
    app.get('/oee/api/:channel/get', function(req, res) {
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
                res.send(data);
            });            
        });         
    });  
}
