const router = require('express').Router();

module.exports = function(api) {
    const _machineConfigController = api.controllers.machineConfig;
    const _tokenController = api.controllers.token;
 
    router.get('/:machine', _tokenController.verify, _machineConfigController.list);    
    router.post('/', _tokenController.verify, _machineConfigController.updateConfig);    
    router.post('/sql', _tokenController.verify, _machineConfigController.updateSQL);    

    return router;
};