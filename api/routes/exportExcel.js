const router = require('express').Router();

module.exports = function(api) {
    const _exportExcelController = api.controllers.exportExcel;
    const _tokenController = api.controllers.token;

    router.get('/chart', _tokenController.verify, _exportExcelController.exportChart);
    router.get('/production', _tokenController.verify, _exportExcelController.exportProduction);
    router.get('/pause', _tokenController.verify, _exportExcelController.exportPause);

    return router;
};