const router = require('express').Router();

module.exports = function(api) {
    const _machineController = api.controllers.machine;

    //migrado para index route por enquanto
    //router.get('/:machine/getMax', _machineController.getMax);
    //router.get('/:user/:channel/machine/list', _machineController.list);

    router.post('/', _machineController.post);
    router.post('/update', _machineController.update);
    router.post('/delete', _machineController.delete);    
    router.get('/channel/:channel', _machineController.listByChannel);    
    router.get('/list', _machineController.listAll);    

    return router;
};