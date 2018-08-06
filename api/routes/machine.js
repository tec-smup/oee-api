const router = require('express').Router();

module.exports = function(api) {
    const _machineController = api.controllers.machine;
    const _tokenController = api.controllers.token;

    //migrado para index route por enquanto
    //router.get('/:machine/getMax', _machineController.getMax);
    //router.get('/:user/:channel/machine/list', _machineController.list);

    router.post('/', _tokenController.verify, _machineController.post);
    router.post('/update', _tokenController.verify, _machineController.update);
    router.post('/delete', _tokenController.verify, _machineController.delete);    
    router.get('/channel/:channel', _tokenController.verify, _machineController.listByChannel);    
    router.get('/list', _tokenController.verify, _machineController.listAll);    
    router.get('/state/:machine', _machineController.getState);    
    router.post('/state', _tokenController.verify, _machineController.setState);    

    return router;
};