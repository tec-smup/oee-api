const router = require('express').Router();

module.exports = function(api) {
    const _shiftController = api.controllers.shift;
    const _tokenController = api.controllers.token;

    router.get('/dropdown', _tokenController.verify, _shiftController.dropdown);

    return router;
};