module.exports = function(api) {
    let _machinePause = api.models.machinePause;
    const _alert = api.models.alert;
    const _mailer = api.services.mailer;
    
    this.alert = function(req, res, next) {
        var query = req.query;

        _machinePause.getMachinePause(query, function(exception, result) {
            if(exception) {
                return res.status(400).send(exception);
            }
            
            const pauseFilter = {...result[0] };
        
            //verifica se tem alerta de pausa para enviar email
            _alert.hasImmediateAlertToSend(pauseFilter, async function(exception, alerts) {
                //se houve erro aqui, segue o processo e só faz um console
                if(exception) console.error(exception);
                
                //envia email (sem formatação e detalhes por enquanto)    
                if(alerts && alerts.length > 0) {
                    const mailsToAlert = alerts.map(m => m.sponsor_email).join(',');
                    const html = `
                        Identificamos que uma máquina está parada. Abaixo mais informações:
                        <br>Máquina: ${pauseFilter.machine_code}
                        <br>Início da pausa: ${pauseFilter.start_date}
                        <br>Fim da pausa: ${pauseFilter.end_date || '-'}
                        <br>Pausa estimada até o momento: ${pauseFilter.pause_in_time || '-'}
                    `;
                    await _mailer.send(mailsToAlert, 'Alerta de pausa', html);
                }   
                res.status(200).send(alerts); 

            });               
          
        });                                              
    };    

    this.save = function(req, res, next) {
        const query = req.query; 
                      
        _machinePause.save(query, function(exception, result) {
            if(exception) {
                return res.status(400).send(exception.sqlMessage);
            }
            const id = result[1][0] ? result[1][0].id.toString() : 0;
            res.status(200).send(id);                
        });                 
    }; 

    this.list = function(req, res, next) {
        var query = req.query;       
        
        _machinePause.listPauses(query, function(exception, result) {
            if(exception) {
                return res.status(400).send(exception);
            }
            let dataResult = {
                pauses: result[0],
                pause_grouped: result[1][0] || []
            }
            res.status(200).send(dataResult);            
        });                  
    };

    this.pareto = function(req, res, next) {
        var query = req.query;       
        
        _machinePause.pareto(query, function(exception, result) {
            if(exception) {
                return res.status(400).send(exception);
            }
            let dataResult = {
                pareto: result[0] || []
            }
            res.status(200).send(dataResult);            
        });                  
    };    
    
    return this;
};