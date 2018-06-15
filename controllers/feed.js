module.exports = function(app) {
	const baseUrl = app.get('BASE_URL');
	
    app.get(baseUrl + 'feed/update', function(req, res) {
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
            query.ch_id = result[0].id;
            delete query.token; //para não interferir no parse do insert
            let timeShift = result[0].time_shift;           
            
            feed.save(query, function(exception, result) {
                if(exception) {
                    return res.status(400).send(exception);
                }
                res.send(timeShift.toString()); 
                connection.end();                 
            });             
        });        
    });

    app.get(baseUrl + 'feed/lastFeed', function(req, res) {
        var query = req.query;        
        var connection = app.database.connection();
        var feed = new app.database.repository.feed(connection);
		var machinePause = new app.database.repository.machinePause(connection);	
		var data = {};		
        
        feed.lastFeed(query, function(exception, result) {
            if(exception) {
                return res.status(400).send(exception);
            }
			data.lastFeeds = result;
			
			machinePause.listPauses(query, function(exception, result) {
				if(exception) {
					return res.status(400).send(exception);
				}
				data.pauses = result;
				res.send(data);            
			});
            connection.end();                 
        });                          
    });  

    app.get(baseUrl + 'feed/chart', function(req, res) {
        var query = req.query;        
        var connection = app.database.connection();
        var feed = new app.database.repository.feed(connection);  
        
        feed.chart(query, function(exception, result) {
            if(exception) {
                return res.status(400).send(exception);
            }
            res.send(result[0]); 
            connection.end();                 
        });                          
    });   
    
    app.get(baseUrl + ':user/:channel/:machine/:date/:limit/feed/mobile', function(req, res) {
        var userId = req.params.user;
        var channelId = req.params.channel;
        var machineCode = req.params.machine;
        var date = req.params.date;
        var limit = req.params.limit;

        var connection = app.database.connection();
        var feed = new app.database.repository.feed(connection);  
        
        feed.mobile(userId, channelId, machineCode, date, limit, function(exception, result) {
            if(exception) {
                return res.status(400).send(exception);
            }
            res.send(result); 
            connection.end();                 
        });                          
    });     
}
