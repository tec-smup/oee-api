const excel = require('node-excel-export');

// You can define styles as json object
const styles = {
    headerBlue: {
    fill: {
      fgColor: {
        rgb: '314289'
      }
    },
    font: {
      color: {
        rgb: 'FFFFFFFF'
      },
      sz: 14,
      bold: true,
    }
  },
};

module.exports = function(api) {
    let _feed = api.models.feed;
    let _machinePause = api.models.machinePause;

    this.exportChart = function(req, res, next) {
        var params = req.query;

        //cria asserts para validação
        req.assert('date_ini', 'Preencha a data inicial corretamente.').notEmpty();
        req.assert('date_fin', 'Preencha a data final corretamente.').notEmpty();
        req.assert('ch_id', 'Canal não informado.').notEmpty();
        req.assert('mc_cd', 'Máquina não informada.').notEmpty();

        var errors = req.validationErrors();
        if(errors)
            return res.status(400).send(errors);
        
        _feed.exportChartExcel(params, function(exception, result) {
            if(exception) {
                return res.status(400).send(exception);
            }

            if(result.length <= 0) {
                return res.send(null);
            } 

            //pega primeira e ultima linha para utilizar as descrições dos campos
            let first = result[0];
            let last = result[result.length-1];

            //cabeçalho do excel com parametros informados
            const heading = [
                [
                    { value: 'Data inicial', style: styles.headerBlue }, 
                    { value: 'Data final', style: styles.headerBlue }, 
                    { value: 'Canal', style: styles.headerBlue },
                    { value: 'Máquina', style: styles.headerBlue },
                ],
                [
                    first.inserted_at, 
                    last.inserted_at, 
                    first.channel_name, 
                    first.machine_name
                ]
            ];

            //colunas
            const specification = {
                field1: { 
                    displayName: first.field1_desc, 
                    headerStyle: styles.headerBlue,
                    width: 200 
                },
                field2: { 
                    displayName: first.field2_desc, 
                    headerStyle: styles.headerBlue,
                    width: 200 
                },
                field3: { 
                    displayName: first.field3_desc, 
                    headerStyle: styles.headerBlue,
                    width: 200 
                },
                field4: { 
                    displayName: first.field4_desc, 
                    headerStyle: styles.headerBlue,
                    width: 200 
                },
                field5: { 
                    displayName: first.field5_desc, 
                    headerStyle: styles.headerBlue,
                    width: 200 
                },
                inserted_at: { 
                    displayName: 'Inserido em', 
                    headerStyle: styles.headerBlue,
                    width: 200 
                },                                                                
            };            

            const exportChart = excel.buildExport(
            [
                {
                    name: 'Dados do gráfico',    
                    heading: heading,
                    specification: specification,
                    data: result 
                }
            ]);

            res.attachment('exportChartExcel.xlsx');        
            return res.send(exportChart); 
        });                
    };   

    this.exportProduction = function(req, res, next) {
        var params = req.query;

        //cria asserts para validação
        req.assert('dateIni', 'Preencha a data inicial corretamente.').notEmpty();
        req.assert('dateFin', 'Preencha a data final corretamente.').notEmpty();
        req.assert('ch_id', 'Canal não informado.').notEmpty();
        
        var errors = req.validationErrors();
        if(errors)
            return res.status(400).send(errors);

        _feed.allProductionV2(params, function(exception, result) {
            if(exception) {
                return res.status(400).send(exception);
            }

            //rejeito result set "ok" do mysql
            let validResultSet = [];
            for(let i = 0; i < result.length; i++) {
                if(result[i].length > 0 && !result[i][0].shift_hour) {
                    validResultSet.push(result[i]);
                }
            }

            if(validResultSet.length <= 0) {
                return res.send(null);
            } 

            let exportObj = [];

            validResultSet.forEach(dataset => {
                //pega primeira linha para montar dados de colunas
                let first = dataset[0];

                //colunas do excel
                let specification = {
                    hora: { 
                        displayName: "Hora", 
                        headerStyle: styles.headerBlue,
                        width: 100 
                    },                                                            
                };      
                
                //monta nome das colunas das maquinas
                for(let col in first) {
                    if(col.indexOf("COL_") > -1) {
                        specification[col] = {
                            displayName: col.replace("COL_",""), 
                            headerStyle: styles.headerBlue,
                            width: 70
                        };
                    }
                };                

                //colunas de totalização e taxa
                specification.total = {
                    displayName: first.tipo, 
                    headerStyle: styles.headerBlue,
                    width: 70                
                };
                specification.taxa = {
                    displayName: "Taxa/Min", 
                    headerStyle: styles.headerBlue,
                    width: 70                
                };  
                
                exportObj.push({
                    name: 'Produção ' + first.tipo,   
                    specification: specification,
                    data: dataset 
                });          

            }); 
        
            const exportExcel = excel.buildExport(exportObj);

            res.attachment('exportChartExcel.xlsx');        
            return res.send(exportExcel); 
        });                
    };  
    
    this.exportPause = function(req, res, next) {
        var query = req.query;        
		
        _machinePause.listPauses(query, function(exception, result) {
            if(exception) {
                return res.status(400).send(exception);
            }

            if(result[0].length <= 0) {
                return res.send(null);
            } 

            //colunas do excel
            let specification = {
                machine_name: { 
                    displayName: "Máquina", 
                    headerStyle: styles.headerBlue,
                    width: 200 
                }, 
                date_ref_format: { 
                    displayName: "Data", 
                    headerStyle: styles.headerBlue,
                    width: 80 
                },  
                pause_time: { 
                    displayName: "Pausa", 
                    headerStyle: styles.headerBlue,
                    width: 50 
                },   
                pause_reason: { 
                    displayName: "Justificativa", 
                    headerStyle: styles.headerBlue,
                    width: 300 
                },
                incidents: {
                    displayName: "Ocorrências", 
                    headerStyle: styles.headerBlue,
                    width: 100                    
                }                                                                                                        
            };      
        
            const exportExcel = excel.buildExport([
                {
                    name: 'Pausas',   
                    specification: specification,
                    data: result[0] 
                }
            ]);

            res.attachment('exportChartExcel.xlsx');        
            return res.send(exportExcel);             

        });                  
    };    
            
    return this;
};