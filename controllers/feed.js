const path = require('path');

module.exports = function(app) {
    app.post('/oee/api/feed/update', function(req, res) {
        var query = res.query;
        var lastId = null;
        
        var connection = app.database.connection();
        var feed = new app.database.repository.feed(connection);        

        feed.save(query, function(exception, result) {
            if(exception) {
                return res.status(400).send(exception);
            }
            lastId = result.insertId;    
            res.send(lastId);                      
        });         
    });

    app.get('/oee/api/feed/test', function(req, res) {
        res.sendFile(path.join(__dirname, '../', 'test.html'));
    });  
}