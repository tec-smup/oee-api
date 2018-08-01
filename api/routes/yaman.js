const router = require('express').Router();

module.exports = function(api) {
    const _yamanController = api.controllers.yaman;

    router.get('/', _yamanController.get); 

    return router;
};