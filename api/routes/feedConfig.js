const router = require('express').Router();

module.exports = function(api) {
    const _feedConfigController = api.controllers.feedConfig;
 
    router.get('/:channel', _feedConfigController.list);    

    return router;
};