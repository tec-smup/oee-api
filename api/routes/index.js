const router = require('express').Router();

module.exports = function(api) {
    const _indexController = api.controllers.index;

    router.get('/', _indexController.redirect);

    return router;
};