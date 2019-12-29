module.exports = function(api) {
    let _feed = api.models.feed;
    let _machinePause = api.models.machinePause;

    this.update = function(req, res, next) {
        var query = req.query;  
                      
        _feed.save(query, function(exception, result) {
            if(exception) {
                return res.status(400).send(exception.sqlMessage);
            }
            let timeShift = result[1][0] ? result[1][0].timeShift.toString() : 0;
            res.status(200).send(timeShift);                
        });                   
    }; 

    this.lastFeed = function(req, res, next) {
        var query = req.query;        
		var data = {};		
        
        _feed.lastFeed(query, function(exception, result) {
            if(exception) {
                return res.status(400).send(exception);
            }
			data.lastFeeds = result;
			
			_machinePause.listPauses(query, function(exception, result) {
				if(exception) {
					return res.status(400).send(exception);
				}
				data.pauses = result[0];
				res.status(200).send(data);            
			});              
        });                 
    };

    this.chart = (req, res, next) => {
        var query = req.query;        
        
        _feed.chart(query, (exception, result) => {
            if(exception) {
                return res.status(400).send(exception);
            }
            res.status(200).send(result[0]);  
        });                
    };
    
    this.mobile = function(req, res, next) {
        var userId = req.params.user;
        var channelId = req.params.channel;
        var machineCode = req.params.machine;
        var date = req.params.date;
        var limit = req.params.limit;
        
        _feed.mobile(userId, channelId, machineCode, date, limit, function(exception, result) {
            if(exception) {
                return res.status(400).send(exception);
            }
            res.status(200).send(result[0]);       
        });                 
    }; 
        
    //vou manter enquanto não atualizar o app ios
    this.allProduction = function(req, res, next) { 
        var query = req.query;

        _feed.allProduction(query, function(exception, result) {
            if(exception) {
                return res.status(400).send(exception);
            }
            res.status(200).send(result[0] || []);       
        });                 
    }; 

    this.allProductionV2 = function(req, res, next) { 
        var query = req.query;

        _feed.allProductionV2(query, function(exception, result) {
            if(exception) {
                return res.status(400).send(exception);
            }
            res.status(200).send(result);       
        });                 
    };
    
    this.OEE = (req, res, next) => { 
        var query = req.query;

        _feed.OEE(query, (exception, result) => {
            if(exception) {
                return res.status(400).send(exception);
            }
            res.status(200).send(result);       
        });                 
    };    

    return this;
};