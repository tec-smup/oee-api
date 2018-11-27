const router = require('express').Router();

module.exports = function(api) {
    const _machinePauseController = api.controllers.machinePause;
    const _tokenController = api.controllers.token;

    router.post('/', _tokenController.verify, _machinePauseController.post);
    //router.get('/list', _tokenController.verify, _machinePauseController.list);

    return router;
};