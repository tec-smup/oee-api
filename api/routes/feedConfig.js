const router = require('express').Router();

module.exports = function(api) {
    const _feedConfigController = api.controllers.feedConfig;
 
    router.get('/:channel', _feedConfigController.list);    
    router.post('/', _feedConfigController.updateConfig);    
    router.post('/sql', _feedConfigController.updateSQL);    

    return router;
};