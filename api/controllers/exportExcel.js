const excel = require('node-excel-export');

// You can define styles as json object
const styles = {
  headerDark: {
    fill: {
      fgColor: {
        rgb: 'FF000000'
      }
    },
    font: {
      color: {
        rgb: 'FFFFFFFF'
      },
      sz: 14,
      bold: true,
      underline: true
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
        
        _feed.chart(params, function(exception, result) {
            if(exception) {
                return res.status(400).send(exception);
            }

            //cabeçalho do excel com parametros informados
            const heading = [
                [
                    {value: 'Data inicial', style: styles.headerDark}, 
                    {value: 'Data final', style: styles.headerDark}, 
                    {value: 'Canal', style: styles.headerDark},
                    {value: 'Máquina', style: styles.headerDark},
                ],
                [params.date_ini, params.date_fin, params.ch_id, params.mc_cd]
            ];

            //colunas
            const specification = {
                labels: { 
                    displayName: 'Hora', 
                    headerStyle: styles.headerDark,
                    width: 120 
                },
                data: {
                    displayName: 'Valor',
                    headerStyle: styles.headerDark,
                    width: '10'
                }
            };            

            const report = excel.buildExport(
            [
                {
                    name: 'Dados do gráfico',    
                    heading: heading,
                    specification: specification,
                    data: result[0] 
                }
            ]);

            res.attachment('exportChartExcel.xlsx');        
            return res.send(report); 
        });                
    };   
            
    return this;
};