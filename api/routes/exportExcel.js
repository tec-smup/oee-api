const router = require('express').Router();

module.exports = function(api) {
    const _exportExcelController = api.controllers.exportExcel;
    const _tokenController = api.controllers.token;

    router.get('/chart', _tokenController.verify, _exportExcelController.exportChart);

    return router;
};