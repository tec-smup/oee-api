module.exports = function(api) {
    let _machinePauseDash = api.models.machinePauseDash;
    
    this.post = function(req, res, next) {
        let bodyData = req.body;

        //cria asserts para validação
        // req.assert('channel_id', 'Canal não informado.').notEmpty();
        // req.assert('machine_code', 'Máquina não informada.').notEmpty();
        // req.assert('pause_reason_id', 'Justificativa não informada.').notEmpty();
        // req.assert('date_ref', 'Data de referência não informada.').notEmpty();

        // var errors = req.validationErrors();
        // if(errors)
        //     return res.status(400).send(errors);

        let pauseFilter = {
            channel_id: bodyData[0].channel_id,
            machine_code: bodyData[0].machine_code,            
            date_ini: bodyData[0].date_ref,
            date_fin: bodyData[1].date_ref,
            pause_reason_id: bodyData[0].pause_reason_id,
            pause: bodyData[1].date_dif   
        };

        _machinePauseDash.save(pauseFilter, function(exception, result) {
            if(exception) {
                return res.status(400).send(exception);
            }     
            return res.status(200).send(result);           
        });                         
    }; 

    return this;
};