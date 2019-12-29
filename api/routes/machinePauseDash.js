const router = require('express').Router();

module.exports = function(api) {
    const _machinePauseDashController = api.controllers.machinePauseDash;
    const _tokenController = api.controllers.token;

    // router.post('/', _tokenController.verify, _machinePauseDashController.hasAlert, _machinePauseDashController.post);
    router.post('/', _tokenController.verify, _machinePauseDashController.post); 

    return router;
};