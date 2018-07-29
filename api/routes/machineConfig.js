const router = require('express').Router();

module.exports = function(api) {
    const _machineConfigController = api.controllers.machineConfig;
 
    router.get('/:machine', _machineConfigController.list);    
    router.post('/', _machineConfigController.updateConfig);    
    router.post('/sql', _machineConfigController.updateSQL);    

    return router;
};