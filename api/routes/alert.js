const router = require('express').Router();

module.exports = function(api) {
    const _alertController = api.controllers.alert;
    const _tokenController = api.controllers.token;

    router.post('/', _tokenController.verify, _alertController.post);
    router.post('/update', _tokenController.verify, _alertController.update);
    router.post('/delete', _tokenController.verify, _alertController.delete);    
    router.get('/channel/:channel', _tokenController.verify, _alertController.list);    
    
    return router;
};