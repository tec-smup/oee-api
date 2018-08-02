const router = require('express').Router();

module.exports = function(api) {
    const _feedConfigController = api.controllers.feedConfig;
    const _tokenController = api.controllers.token;
 
    router.get('/:channel', _tokenController.verify, _feedConfigController.list);    
    router.post('/', _tokenController.verify, _feedConfigController.updateConfig);    
    router.post('/sql', _tokenController.verify, _feedConfigController.updateSQL);    

    return router;
};