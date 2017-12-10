insert into channel(name, description, token, active) 
values('Start Me UP - OEE Máquina 8', 'Serviço de Monitoramento de OEE de máquinas', '67RRJQRANOMPQ30Q', 1);

select id into @channel_id from channel limit 1;

insert into feed_config(channel_id, field1, field2, field3, field4, field5) 
values(@channel_id, 'Oee%', 'Valores Pressão', 'Total Hourimetro (Minutos)', 'Tempo Total Produção (Minutos)', 'Tempo Real (Minutos)');