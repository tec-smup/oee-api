module.exports = function(api) {
    const _machinePauseDash = api.models.machinePauseDash;
    const _alert = api.models.alert;
    const _mailer = api.services.mailer;
    
    this.hasAlert = function(req, res, next) {
        const bodyData = req.body;

        const pauseFilter = {
            channel_id: bodyData[0].channel_id, 
            machine_code: bodyData[0].machine_code,  
            date_ini: bodyData[0].date_ref,
            date_fin: bodyData[1].date_ref,
            pause_reason_id: bodyData[0].pause_reason_id,
            pause: bodyData[1].date_dif   
        };

        //verifica se tem alerta de pausa para enviar email
        _alert.hasAlertToSend(pauseFilter, async function(exception, alerts) {
            //se houve erro aqui, segue o processo e só faz um console
            if(exception) console.error(exception);
            
            //envia email (sem formatação e detalhes por enquanto)    
            if(alerts && alerts.length > 0) {
                const pauseReasonName = alerts[0].pause_reason_name;
                const mailsToAlert = alerts.map(m => m.sponsor_email).join(',');
                const html = `
                    A pausa <b>${pauseReasonName}</b> de <b>${pauseFilter.pause} minutos</b> foi lançada.
                    <br>Máquina: ${pauseFilter.machine_code}
                    <br>Data inicial da pausa: ${pauseFilter.date_ini}
                    <br>Data final da pausa: ${pauseFilter.date_fin}
                `;
                await _mailer.send(mailsToAlert, 'Alerta de pausa', html);
            }            
            next();
        });                                         
    };
    
    this.post = function (req, res, next) {
        const bodyData = req.body;

        const pauseFilter = {
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