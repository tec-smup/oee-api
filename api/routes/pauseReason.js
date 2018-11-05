const router = require('express').Router();

module.exports = function(api) {
    const _pauseReasonController = api.controllers.pauseReason;
    const _tokenController = api.controllers.token;

    router.get('/dropdown/:channel', _tokenController.verify, _pauseReasonController.dropdown);

    return router;
};