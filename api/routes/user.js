const router = require('express').Router();

module.exports = function(api) {
    const _userController = api.controllers.user;

    router.post('/authentication', _userController.authentication);
    router.get('/', _userController.list);
    router.post('/', _userController.post);
    router.post('/update', _userController.update);
    router.post('/delete', _userController.delete);

    return router;
};