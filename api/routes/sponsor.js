const router = require('express').Router();

module.exports = function(api) {
    const _sponsorController = api.controllers.sponsor;
    const _tokenController = api.controllers.token;

    router.post('/', _tokenController.verify, _sponsorController.post);
    router.post('/update', _tokenController.verify, _sponsorController.update);
    router.post('/delete', _tokenController.verify, _sponsorController.delete);    
    router.get('/channel/:channel', _tokenController.verify, _sponsorController.list);    
    
    return router;
};