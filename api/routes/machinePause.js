const router = require('express').Router();

module.exports = function(api) {
    const _machinePauseController = api.controllers.machinePause;

    router.post('/', _machinePauseController.post);
    router.get('/list', _machinePauseController.list);

    return router;
};