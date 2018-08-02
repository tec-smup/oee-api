const router = require('express').Router();

module.exports = function(api) {
    const _userController = api.controllers.user;
    const _tokenController = api.controllers.token;

    router.post('/authentication', _userController.authentication);
    router.get('/', _tokenController.verify, _userController.list);
    router.get('/data', _tokenController.verify, _userController.getUserData);
    router.post('/', _userController.post); //n jwt
    router.post('/update', _tokenController.verify, _userController.update);
    router.post('/delete', _tokenController.verify, _userController.delete);
    router.post('/changePass', _tokenController.verify, _userController.changePass);

    return router;
};