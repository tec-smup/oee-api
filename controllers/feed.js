module.exports = function(app) {
	const baseUrl = app.get('BASE_URL');
	
    app.get(baseUrl + 'feed/update', function(req, res) {
        var query = req.query;  
        var pool = app.database.connection.getPool();
        var feed = new app.database.repository.feed(pool);  
                      
        feed.save(query, function(exception, result) {
            if(exception) {
                return res.status(400).send(exception.sqlMessage);
            }
            res.status(200).send(result[1][0].timeShift.toString());                
        });             
              
    });

    app.get(baseUrl + 'feed/lastFeed', function(req, res) {
        var query = req.query;        
        var pool = app.database.connection.getPool();
        var feed = new app.database.repository.feed(pool);
		var machinePause = new app.database.repository.machinePause(pool);	
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
				res.status(200).send(data);            
			});              
        });                          
    });  

    app.get(baseUrl + 'feed/chart', function(req, res) {
        var query = req.query;        
        var pool = app.database.connection.getPool();
        var feed = new app.database.repository.feed(pool);  
        
        feed.chart(query, function(exception, result) {
            if(exception) {
                return res.status(400).send(exception);
            }
            res.status(200).send(result[0]);  
        });                          
    });   
    
    app.get(baseUrl + ':user/:channel/:machine/:date/:limit/feed/mobile', function(req, res) {
        var userId = req.params.user;
        var channelId = req.params.channel;
        var machineCode = req.params.machine;
        var date = req.params.date;
        var limit = req.params.limit;

        var pool = app.database.connection.getPool();
        var feed = new app.database.repository.feed(pool);  
        
        feed.mobile(userId, channelId, machineCode, date, limit, function(exception, result) {
            if(exception) {
                return res.status(400).send(exception);
            }
            res.status(200).send(result[0]);       
        });                          
    });     
}
