insert into channel(name, description, token, active) 
values('Start Me UP - OEE Máquina 8', 'Serviço de Monitoramento de OEE de máquinas', '67RRJQRANOMPQ30Q', 1);

select id into @channel_id from channel limit 1;

insert into feed_config(channel_id, field1, field2, field3, field4, field5) 
values(@channel_id, 'Oee%', 'Valores Pressão', 'Total Hourimetro (Minutos)', 'Tempo Total Produção (Minutos)', 'Tempo Real (Minutos)');


insert into user(username, password, admin) values('paul8liveira@gmail.com', '$2a$10$SWLfel2IqmhVnw1/4bGKs.023uqOOWViV4k3p/69Lwanr1QdbprbC', true);
insert into user(username, password, admin) values('diogo.maccord@startmeupsolutions.com.br', '$2a$10$SWLfel2IqmhVnw1/4bGKs.023uqOOWViV4k3p/69Lwanr1QdbprbC', true);
insert into user(username, password, admin) values('washington.peroni@startmeupsolutions.com.br', '$2a$10$SWLfel2IqmhVnw1/4bGKs.023uqOOWViV4k3p/69Lwanr1QdbprbC', true);
insert into user(username, password, admin) values('contato@startmeupsolutions.com.br', '$2a$10$SWLfel2IqmhVnw1/4bGKs.023uqOOWViV4k3p/69Lwanr1QdbprbC', true);

update feed_config set production_sql = '
select u.hora
	 , sum(u.valor) as total
     , u.tipo   
  from (
	select max(t.id) as id
		 , t.mc_cd
		 , t.hora 
         , t.ordem
		 , (select 
				case f.mc_cd 
					when \'EF3\' then round(f.field2,0)
					when \'EF4\' then round(f.field2,0)
					when \'EF5\' then round(f.field3,0)
					when \'EF6\' then round(f.field3,0)
					when \'EF7\' then round(f.field3,0)
				end 
			   from feed f where f.id = max(t.id)
			) as valor 
		 , (case t.mc_cd 
				when \'EF3\' then \'Unidades\'
                when \'EF4\' then \'Unidades\'
				when \'EF5\' then \'Fardos\'
                when \'EF6\' then \'Fardos\'
                when \'EF7\' then \'Fardos\'
			end) as tipo            
	  from (
		select id
			 , mc_cd
			 , concat(hour(inserted_at), \':00 - \', hour(inserted_at)+1, \':00\') as hora
			 , hour(inserted_at) ordem
		  from feed
		 where ch_id = __ch_id
		   and mc_cd in(\'EF3\', \'EF4\', \'EF5\', \'EF6\', \'EF7\')
		   and inserted_at between 
               (STR_TO_DATE(CONCAT(\'__date_ini\', \' 06:00:00\'), \'%Y-%m-%d %H:%i:%s\')) 
           and (STR_TO_DATE(CONCAT(\'__date_fin\', \' 23:59:59\'), \'%Y-%m-%d %H:%i:%s\'))
	) t
	group by t.mc_cd, t.hora, t.ordem	
) u
group by u.hora, u.ordem, u.tipo
order by u.tipo, u.ordem;'
where channel_id=2 