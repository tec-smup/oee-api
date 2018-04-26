insert into channel(name, description, token, active) 
values('Start Me UP - OEE Máquina 8', 'Serviço de Monitoramento de OEE de máquinas', '67RRJQRANOMPQ30Q', 1);

select id into @channel_id from channel limit 1;

insert into feed_config(channel_id, field1, field2, field3, field4, field5) 
values(@channel_id, 'Oee%', 'Valores Pressão', 'Total Hourimetro (Minutos)', 'Tempo Total Produção (Minutos)', 'Tempo Real (Minutos)');


insert into user(username, password, admin) values('paul8liveira@gmail.com', '$2a$10$SWLfel2IqmhVnw1/4bGKs.023uqOOWViV4k3p/69Lwanr1QdbprbC', true);
insert into user(username, password, admin) values('diogo.maccord@startmeupsolutions.com.br', '$2a$10$SWLfel2IqmhVnw1/4bGKs.023uqOOWViV4k3p/69Lwanr1QdbprbC', true);
insert into user(username, password, admin) values('washington.peroni@startmeupsolutions.com.br', '$2a$10$SWLfel2IqmhVnw1/4bGKs.023uqOOWViV4k3p/69Lwanr1QdbprbC', true);
insert into user(username, password, admin) values('ale@startmeupsolutions.com.br', '$2a$10$SWLfel2IqmhVnw1/4bGKs.023uqOOWViV4k3p/69Lwanr1QdbprbC', true);