module.exports = function(app) {
    app.get('/oee/upd', function(req, res) {
        var query = req.query;        
        var connection = app.database.connection();
        var feed = new app.database.repository.feed(connection);  
        
        feed.autenticateToken(query.token, function(exception, result) {
            if(exception) {
                return res.status(400).send(exception);
            }
            if(!result[0]) {
                return res.send('0'); //seguindo modelo do thingspeak
            }
            query.channel_id = result[0].id;
            delete query.token; //para não interferir no parse do insert

            feed.save(query, function(exception, result) {
                if(exception) {
                    return res.status(400).send(exception);
                }
                res.send(result.insertId.toString());   //seguindo modelo do thingspeak                   
            });             
        });        
    });
}
