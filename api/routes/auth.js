const router = require('express').Router();

module.exports = function(api) {
    const _authController = api.controllers.auth;

    router.post('/', _authController.post);

    return router;
};