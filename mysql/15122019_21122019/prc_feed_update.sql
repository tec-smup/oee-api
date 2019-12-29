USE `oee`;
DROP procedure IF EXISTS `prc_feed_update`;

DELIMITER $$
USE `oee`$$
CREATE PROCEDURE `prc_feed_update`(
	in p_token varchar(50),
    in p_mc_cd varchar(10),
    in p_field1 varchar(100),
    in p_field2 float(15,2),
    in p_field3 float(15,2),
    in p_field4 float(15,2),
    in p_field5 varchar(100),
    out p_time_shift int(11)
)
BEGIN
	declare v_count int(11);
    declare v_ch_id int(11);
    declare v_time_shift int(11);
    declare v_can_transmit bit;
    declare v_last_feed float(15,2);
    declare v_hour_ini char(5);
    declare v_hour_fin char(5);
    
    select count(*) into v_count 
      from channel 
	 where token = p_token;
    
    /*canal não existe ou token está duplicado*/
	if (v_count = 0 or v_count > 1) then 
		signal sqlstate '99999'
		set message_text = 'Token inválido';
    end if;    
	
    /*pego turno da maquina para ver se ela pode transmitir*/
    select (select hour_ini from machine_shift where machine_code = p_mc_cd order by hour_ini limit 1),
		   (select hour_fin from machine_shift where machine_code = p_mc_cd order by hour_fin desc limit 1)
	  into v_hour_ini
		 , v_hour_fin;
    
	select id
         , time_shift 
		 , case when DATE_FORMAT(now(), '%H:%i') between v_hour_ini and v_hour_fin
			then 1
			else 0
		   end as can_transmit         
      into v_ch_id
         , v_time_shift
         , v_can_transmit
      from channel 
	 where token = p_token;
     
	select sum(ifnull(field2,0) + ifnull(field3,0)) as last
      into v_last_feed
	  from feed f
	 inner join (select max(id) as id
				   from feed
				  where ch_id = v_ch_id
					and mc_cd = p_mc_cd
					and date(inserted_at) = DATE_FORMAT(now(), "%Y-%m-%d")
				  group by mc_cd) ids on ids.id = f.id
	 inner join machine_data m on m.code = f.mc_cd;     
     
	/*maquina pertence ao canal?*/
	if not exists (select 1 from channel_machine where channel_id = v_ch_id and machine_code = p_mc_cd) then 
		signal sqlstate '99999'
		set message_text = 'Máquina informada não pertence ao canal';
    end if;   
			
    set p_time_shift = v_time_shift;
    
    /*transmite somente dentro do horario de turno do canal*/
    -- if(v_can_transmit = 1 and ((p_field2 + p_field3) >= v_last_feed)) then
    if(v_can_transmit = 1) then
		insert into feed(ch_id, mc_cd, field1, field2, field3, field4, field5)
		values(v_ch_id, p_mc_cd, p_field1, p_field2, p_field3, p_field4, p_field5);
    end if;
    
END$$

DELIMITER ;

