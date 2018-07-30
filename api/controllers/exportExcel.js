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

            //pega primeira linha para utilizar as descrições dos campos
            let first = result[0];

            //cabeçalho do excel com parametros informados
            const heading = [
                [
                    { value: 'Data inicial', style: styles.headerBlue }, 
                    { value: 'Data final', style: styles.headerBlue }, 
                    { value: 'Canal', style: styles.headerBlue },
                    { value: 'Máquina', style: styles.headerBlue },
                ],
                [
                    params.date_ini, 
                    params.date_fin, 
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
            
    return this;
};