const router = require('express').Router();

module.exports = function(api) {
    const _userController = api.controllers.user;
    const _tokenController = api.controllers.token;

    router.post('/authentication', _userController.authentication);
    router.get('/', _userController.list);
    router.get('/data', _tokenController.verify, _userController.getUserData);
    router.post('/', _userController.post);
    router.post('/update', _userController.update);
    router.post('/delete', _userController.delete);
    router.post('/changePass', _userController.changePass);

    return router;
};