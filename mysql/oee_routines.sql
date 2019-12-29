-- MySQL dump 10.13  Distrib 5.7.17, for Win64 (x86_64)
--
-- Host: 35.243.135.57    Database: oee
-- ------------------------------------------------------
-- Server version	5.7.14-google-log

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;
SET @MYSQLDUMP_TEMP_LOG_BIN = @@SESSION.SQL_LOG_BIN;
SET @@SESSION.SQL_LOG_BIN= 0;

--
-- GTID state at the beginning of the backup 
--
--
-- Dumping routines for database 'oee'
--
/*!50003 DROP FUNCTION IF EXISTS `fnc_machine_pause` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,STRICT_ALL_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,TRADITIONAL,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE FUNCTION `fnc_machine_pause`(
	p_channel_id int,
    p_machine_code varchar(10),
    p_date_ini varchar(20),
    p_date_fin varchar(20),
    p_pause_type char(2)
) RETURNS int(11)
    DETERMINISTIC
begin
	declare v_pause int;
    set v_pause = 0;
    select sum(a.pause) as pause
      into v_pause
	  from (
		select mpd.pause 
		  from channel c
		 inner join channel_machine cm on cm.channel_id = c.id
		  left join machine_pause_dash mpd on mpd.channel_id = c.id and mpd.machine_code = cm.machine_code
		  left join pause_reason pr on pr.id = mpd.pause_reason_id
		 where c.id = p_channel_id
		   and cm.machine_code = p_machine_code
		   and mpd.date_ref between 
				   (str_to_date(p_date_ini, '%Y-%m-%d %H:%i:%s')) 
			   and (str_to_date(p_date_fin, '%Y-%m-%d %H:%i:%s'))
		   and pr.type = p_pause_type    
		 group by mpd.insert_index
	) a;
	return coalesce(v_pause, 0);
end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `prc_channel` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE PROCEDURE `prc_channel`(
	in p_name varchar(100),
    in p_description varchar(500),
    in p_token varchar(50),
    in p_active bit,
    in p_time_shift int(11),
	in p_initial_turn char(5),
	in p_final_turn char(5),
    in p_user_id int,
    in p_reset_time_shift bit,
    out p_channel_id int(11)
)
BEGIN
	if exists (select 1 from channel where token = p_token) then 
		signal sqlstate '99999'
		set message_text = 'Token informado já existe';
    end if;
    insert into channel(name, description, token, active, created_at, updated_at, time_shift, initial_turn, final_turn, reset_time_shift)
    values(p_name, p_description, p_token, p_active, now(), now(), p_time_shift, p_initial_turn, p_final_turn, p_reset_time_shift);
    set p_channel_id = LAST_INSERT_ID();
    call prc_user_channel(p_user_id, p_channel_id);
    
    insert into feed_config(channel_id, field1, field2, field3, field4, field5, refresh_time, chart_tooltip_desc) 
    values(p_channel_id, 'Descrição campo 1', 'Descrição campo 2', 'Descrição campo 3', 'Descrição campo 4', 'Descrição campo 5', 300, 'OEE: __value%');   
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `prc_channel_machine` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE PROCEDURE `prc_channel_machine`(
	in p_channel_id int(11),
    in p_machine_code varchar(10)
)
BEGIN
	insert into channel_machine(channel_id, machine_code)
    values(p_channel_id, p_machine_code);
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `prc_chart` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE PROCEDURE `prc_chart`(
	in p_date_ini varchar(20),
    in p_date_fin varchar(20),
    in p_ch_id int(11),
    in p_mc_cd varchar(10)
)
BEGIN
	SET @chart_sql = coalesce(
		(select chart_sql 
           from machine_config 
		  where machine_code = p_mc_cd),
		(select chart_sql 
		   from feed_config 
		  where channel_id = p_ch_id)
	);
	
    SET @chart_sql = REPLACE(@chart_sql, '__date_ini', p_date_ini);
    SET @chart_sql = REPLACE(@chart_sql, '__date_fin', p_date_fin);
    SET @chart_sql = REPLACE(@chart_sql, '__ch_id', p_ch_id);
    SET @chart_sql = REPLACE(@chart_sql, '__mc_cd', p_mc_cd);
    
    PREPARE stmt FROM @chart_sql;
	EXECUTE stmt;
	DEALLOCATE PREPARE stmt;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `prc_chart_pause_pareto` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,STRICT_ALL_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,TRADITIONAL,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE PROCEDURE `prc_chart_pause_pareto`(
	in p_channel_id int,
    in p_machine_code varchar(10),
    in p_time_filter int
)
BEGIN
	set @totalPauses := 0;
	set @queryPausesCount = '
		select sum(p.pause)
		  into @totalPauses
		  from (
			select year(mpd.date_ref) as year
				 , month(mpd.date_ref) as month
				 , day(mpd.date_ref) as day
				 , mpd.date_ref
				 , mpd.pause
			  from machine_pause_dash mpd
			 inner join pause_reason pr on pr.id = mpd.pause_reason_id
			 where mpd.channel_id = __channel_id
			   and pr.type = \'NP\'
			   __machine_filter
			 group by mpd.insert_index
		) p
		where p.year = year(now())
		  __filter';
    
	set @queryPauses = '       
		select d.*
			 , sec_to_time(d.pause*60) as pause_in_time
			 , round(@frequencyCount := @frequencyCount + d.percentage, 2) as sum_percentage
		  from (
			select concat(\'(\', c.count, \') \', c.pause_name) as pause_name_count
				 , c.* 
			  from (
				select p.pause_name 
					 , case when length(p.pause_name) > 10 then concat(left(p.pause_name, 10), \'...\') else p.pause_name end as pause_name_short
					 , p.pause_type
					 , sum(p.pause) as pause             
					 , round(((sum(p.pause) * 100) / @totalPauses),2) as percentage  
                     , count(0) as count
				  from (
					select year(mpd.date_ref) as year
						 , month(mpd.date_ref) as month
						 , day(mpd.date_ref) as day
						 , mpd.date_ref
						 , mpd.pause_reason_id
						 , mpd.pause
						 , pr.name as pause_name
						 , case pr.type when \'PP\' then \'Pausa programada\' else \'Pausa não programada\' end as pause_type
						 , mpd.channel_id
					  from machine_pause_dash mpd
					 inner join pause_reason pr on pr.id = mpd.pause_reason_id
					 where mpd.channel_id = __channel_id
                       and pr.type = \'NP\'
					   __machine_filter
					 group by mpd.insert_index
				) p
				where p.year = year(now())
				  __filter
				group by p.pause_reason_id
			) c
			order by c.pause desc
		) d,
		(select @frequencyCount := 0) SQLVars;';
        
        -- canal
		set @queryPauses = replace(@queryPauses, '__channel_id', p_channel_id);
		set @queryPausesCount = replace(@queryPausesCount, '__channel_id', p_channel_id);
        
        -- filtro por maquina
        if(p_machine_code is not null) then
			set @queryPauses = replace(@queryPauses, '__machine_filter', concat('and mpd.machine_code = ', '''', p_machine_code, ''''));
            set @queryPausesCount = replace(@queryPausesCount, '__machine_filter', concat('and mpd.machine_code = ', '''', p_machine_code, '''')); 
        else    
			set @queryPauses = replace(@queryPauses, '__machine_filter', '');
            set @queryPausesCount = replace(@queryPausesCount, '__machine_filter', '');        
        end if;
        
        -- filtro somente por ano
        if(p_time_filter = 0) then
			set @queryPauses = replace(@queryPauses, '__filter', '');
            set @queryPausesCount = replace(@queryPausesCount, '__filter', '');
        -- filtro somente por mes
        elseif (p_time_filter = 1) then
			set @queryPauses = replace(@queryPauses, '__filter', 'and p.month = month(now())');
            set @queryPausesCount = replace(@queryPausesCount, '__filter', 'and p.month = month(now())'); 
        -- filtro por mes/semana
        elseif(p_time_filter = 2) then
			set @queryPauses = replace(@queryPauses, '__filter', 'and p.date_ref between date_sub(now(), interval 7 day) and now()');
            set @queryPausesCount = replace(@queryPausesCount, '__filter', 'and p.date_ref between date_sub(now(), interval 7 day) and now()');        
		-- filtro por mes/dia
        elseif(p_time_filter = 3) then
			set @queryPauses = replace(@queryPauses, '__filter', 'and p.day = day(now()) and p.month = month(now())');
			set @queryPausesCount = replace(@queryPausesCount, '__filter', 'and p.day = day(now()) and p.month = month(now())');
		-- filtro por mes/dia anterior
        else
			set @queryPauses = replace(@queryPauses, '__filter', 'and p.day = (day(now())-1) and p.month = month(now())');
			set @queryPausesCount = replace(@queryPausesCount, '__filter', 'and p.day = (day(now())-1) and p.month = month(now())');        
        end if;    
        
    prepare stmt from @queryPausesCount;
	execute stmt;
	deallocate prepare stmt;  
    
    prepare stmt from @queryPauses; 
	execute stmt;
	deallocate prepare stmt;      
        
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `prc_commands_executer` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,STRICT_ALL_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,TRADITIONAL,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE PROCEDURE `prc_commands_executer`(
	in p_channel_id int(11),
    in p_machine_code varchar(10),
    in p_date_ini varchar(20),
    in p_date_fin varchar(20),
    in p_type varchar(50) 
)
BEGIN
	declare v_done int default false;
    declare v_query text;
    
	declare c cursor for select query
						   from commands q 
						  where q.channel_id = p_channel_id
							and ((q.machine_code = p_machine_code) or q.machine_code is null)
                            and q.type = p_type;

	declare continue handler for not found set v_done = true;    
	declare exit handler for sqlexception, sqlwarning
	begin
		rollback;
		resignal;
	end;  
	
	open c;
 
	read_loop: loop
		fetch c into v_query;	
        
		if v_done then
			leave read_loop;
		end if;			
	    
        SET @v_query = v_query;
		SET @v_query = REPLACE(@v_query, '__date_ini', p_date_ini);
		SET @v_query = REPLACE(@v_query, '__date_fin', p_date_fin);
		SET @v_query = REPLACE(@v_query, '__ch_id', p_channel_id);
        SET @v_query = REPLACE(@v_query, '__mc_cd', p_machine_code);
			
		PREPARE stmt FROM @v_query;
		EXECUTE stmt;
		DEALLOCATE PREPARE stmt; 
		
	end loop;

	close c;    
    
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `prc_delete_channel` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE PROCEDURE `prc_delete_channel`(in p_channel_id int)
BEGIN
	set @name = (select name from channel where id = p_channel_id);
    
    set @msg = concat('Não é possível excluir o canal ', @name, '. Existem dados de medição vinculados a ele.');
    
	if exists (select 1 from feed where ch_id = p_channel_id) then 
		signal sqlstate '99999'
		set message_text = @msg;
    end if;
    delete from channel_machine where channel_id = p_channel_id;
    delete from user_channel where channel_id = p_channel_id;
    delete from feed_config where channel_id = p_channel_id;
    delete from channel where id = p_channel_id; 
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `prc_delete_machine_data` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE PROCEDURE `prc_delete_machine_data`(in p_code varchar(10))
BEGIN
	declare msg varchar(100);
    set msg = concat('Não é possível excluir a máquina ', p_code, ' pois existem medições vinculadas a ela');
	if exists (select 1 from feed where mc_cd = p_code) then 
		signal sqlstate '99999'
		set message_text = msg;
    end if;
    delete from channel_machine where machine_code = p_code;
    delete from machine_config where machine_code = p_code;
    delete from machine_data where code = p_code;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `prc_delete_user` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE PROCEDURE `prc_delete_user`(in p_user_id int)
BEGIN
	/*set @name = (select name from channel where id = p_channel_id);
    
    set @msg = concat('Não é possível excluir o canal ', @name, '. Existem dados de medição vinculados a ele.');
    
	if exists (select 1 from feed where ch_id = p_channel_id) then 
		signal sqlstate '99999'
		set message_text = @msg;
    end if;*/
    delete from user where id = p_user_id; 
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `prc_feed_update` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,STRICT_ALL_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,TRADITIONAL,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
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
    
    select count(*) into v_count 
      from channel 
	 where token = p_token;
    
    /*canal não existe ou token está duplicado*/
	if (v_count = 0 or v_count > 1) then 
		signal sqlstate '99999'
		set message_text = 'Token inválido';
    end if;        
    
	select id
         , time_shift 
		 , case when DATE_FORMAT(now(), '%H:%i') between initial_turn and final_turn
			then 1
			else 0
		   end as transmissao_liberada         
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
    
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `prc_machine_data` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,STRICT_ALL_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,TRADITIONAL,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE PROCEDURE `prc_machine_data`(
	in p_code varchar(10),
    in p_name varchar(20),
    in p_mobile_name varchar(5),
    in p_department varchar(100),
    in p_product varchar(100),
    in p_last_maintenance date,
    in p_next_maintenance date,
    in p_user_id int,
    in p_nominal_output double
)
begin   
	if exists (select 1 from machine_data where code = p_code) then 
		signal sqlstate '99999'
		set message_text = 'Código informado já existe';
    end if;
    insert into machine_data(code, name, mobile_name, department, product, last_maintenance, next_maintenance, nominal_output)
    values(p_code, p_name, p_mobile_name, p_department, p_product, p_last_maintenance, p_next_maintenance, p_nominal_output);
    
    insert into machine_config(machine_code) values(p_code);
end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `prc_machine_pause` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE PROCEDURE `prc_machine_pause`(
	in p_mc_cd varchar(10),
	in p_pause int,
	in p_date_ref varchar(10),
	in p_justification varchar(5000)
)
BEGIN
    insert into machine_pause(mc_cd, pause, date_ref, justification)
    values(p_mc_cd, p_pause, STR_TO_DATE(p_date_ref, '%d/%m/%Y'), p_justification);
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `prc_machine_pause_dash` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,STRICT_ALL_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,TRADITIONAL,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE PROCEDURE `prc_machine_pause_dash`(
	in p_channel_id int,
    in p_machine_code varchar(10),
    in p_date_ini varchar(50),
    in p_date_fin varchar(50),
    in p_pause_reason_id int,
    in p_pause int
)
BEGIN
    set @insert_index = (select ifnull(max(insert_index),0)+1 from machine_pause_dash);
    
	insert into machine_pause_dash(channel_id, machine_code, date_ref, pause_reason_id, pause, insert_index)
	select f.ch_id
		 , f.mc_cd
		 , DATE_FORMAT(f.inserted_at, '%Y-%m-%d %H:%i:%s') as date_ref
		 , p_pause_reason_id
         , p_pause
         , @insert_index
	  from feed f
	 where f.ch_id = p_channel_id
	   and f.mc_cd = p_machine_code
	   and f.inserted_at between p_date_ini and p_date_fin
	   and not exists(select 1 
						from machine_pause_dash mpd 
					   where mpd.channel_id = f.ch_id 
						 and mpd.machine_code = f.mc_cd 
						 and mpd.date_ref = f.inserted_at);
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `prc_machine_shift` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,STRICT_ALL_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,TRADITIONAL,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE PROCEDURE `prc_machine_shift`(
	in p_machine_code varchar(10),
    in p_hour_ini char(5),
    in p_hour_fin char(5)
)
BEGIN    
    set @msg = 'Horário inválido ou já cadastrado';
    
	if (exists (select 1 from machine_shift 
				where machine_code = p_machine_code
                  and hour_ini = p_hour_ini
                  and hour_fin = p_hour_fin) or p_hour_ini = p_hour_fin) then 
		signal sqlstate '99999'
		set message_text = @msg;
    end if;
    insert into machine_shift(machine_code, hour_ini, hour_fin) 
	values(p_machine_code, p_hour_ini, p_hour_fin);
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `prc_mobile` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE PROCEDURE `prc_mobile`(
	in p_user_id int(11),
	in p_date varchar(8),
    in p_ch_id int(11),
    in p_mc_cd varchar(10),
    in p_limit int(11)
)
BEGIN
	SET @mobile_sql = coalesce(
		nullif((select mobile_sql 
           from machine_config 
		  where machine_code = p_mc_cd), ''),
		nullif((select mobile_sql 
		   from feed_config 
		  where channel_id = p_ch_id), '')
	);
	
    SET @mobile_sql = REPLACE(@mobile_sql, '__user_id', p_user_id);
    SET @mobile_sql = REPLACE(@mobile_sql, '__date', p_date);
    SET @mobile_sql = REPLACE(@mobile_sql, '__ch_id', p_ch_id);
    SET @mobile_sql = REPLACE(@mobile_sql, '__mc_cd', p_mc_cd);
    SET @mobile_sql = REPLACE(@mobile_sql, '__limit', p_limit);
    
    PREPARE stmt FROM @mobile_sql;
	EXECUTE stmt;
	DEALLOCATE PREPARE stmt;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `prc_oee` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,STRICT_ALL_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,TRADITIONAL,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE PROCEDURE `prc_oee`(
	IN `p_channel_id` int,
	IN `p_date_ini` varchar(20),
	IN `p_date_fin` varchar(20),
	IN `p_machine_code` varchar(10)



)
begin
	declare v_done int default false;
    declare v_machine_code varchar(10);
    declare v_machine_name varchar(20);
    declare v_quality int;
    	
	/*curso de maquinas do canal*/
	declare c cursor for select cm.machine_code, m.name
						   from channel_machine cm
						  inner join machine_data m on m.code = cm.machine_code
						  where cm.channel_id = p_channel_id
                            and ((cm.machine_code = p_machine_code) or ifnull(p_machine_code, '') = '');
	
	declare continue handler for not found set v_done = true;    
	declare exit handler for sqlexception, sqlwarning
	begin
		rollback;
		resignal;
	end;    

	drop temporary table if exists tmp_oee;
	create temporary table if not exists tmp_oee(
		channel_id int,
		machine_code varchar(10),
        machine_name varchar(100),
		availability float(15,2),
		performance float(15,2),
		quality float(15,2),
		oee float(15,2)
	);
    
	drop temporary table if exists tmp_performance;
	create temporary table if not exists tmp_performance(
		machine_code varchar(10),
		field5 float(15,2),
		performance float(15,2)
	);
    
	drop temporary table if exists tmp_availability;
	create temporary table if not exists tmp_availability(
		machine_code varchar(10),
		pp float(15,2),
		pnp float(15,2)
	);    

	/*desempenho*/
	insert into tmp_performance
	select f.mc_cd
		 , cast(coalesce(f.field5,0) as decimal(15,2)) as field5
         /*, coalesce(case f.mc_cd 
			when 'EF3' then round((((f.field2 / (f.field5 - fnc_machine_pause(f.ch_id, f.mc_cd, p_date_ini, p_date_fin, 'PP'))) / m.nominal_output)),2) 
			when 'EF4' then round((((f.field2 / (f.field5 - fnc_machine_pause(f.ch_id, f.mc_cd, p_date_ini, p_date_fin, 'PP'))) / m.nominal_output)),2) 
			when 'EF5' then round((((f.field3 / (f.field5 - fnc_machine_pause(f.ch_id, f.mc_cd, p_date_ini, p_date_fin, 'PP'))) / m.nominal_output)),2) 
			when 'EF6' then round((((f.field3 / (f.field5 - fnc_machine_pause(f.ch_id, f.mc_cd, p_date_ini, p_date_fin, 'PP'))) / m.nominal_output)),2) 
			when 'EF7' then round((((f.field3 / (f.field5 - fnc_machine_pause(f.ch_id, f.mc_cd, p_date_ini, p_date_fin, 'PP'))) / m.nominal_output)),2)
            when 'RB1' then round((((f.field2 / (f.field5 - fnc_machine_pause(f.ch_id, f.mc_cd, p_date_ini, p_date_fin, 'PP'))) / m.nominal_output)),2)
            when 'RB2' then round((((f.field2 / (f.field5 - fnc_machine_pause(f.ch_id, f.mc_cd, p_date_ini, p_date_fin, 'PP'))) / m.nominal_output)),2)
			when 'AB1' then round((((f.field3 / (f.field5 - fnc_machine_pause(f.ch_id, f.mc_cd, p_date_ini, p_date_fin, 'PP'))) / m.nominal_output)),2)
            when 'AB2' then round((((f.field3 / (f.field5 - fnc_machine_pause(f.ch_id, f.mc_cd, p_date_ini, p_date_fin, 'PP'))) / m.nominal_output)),2)
            when 'MAQ1' then round((((f.field2 / (f.field5 - fnc_machine_pause(f.ch_id, f.mc_cd, p_date_ini, p_date_fin, 'PP'))) / m.nominal_output)),2)
			when 'MAQ2' then round((((f.field2 / (f.field5 - fnc_machine_pause(f.ch_id, f.mc_cd, p_date_ini, p_date_fin, 'PP'))) / m.nominal_output)),2)
			when 'MAQ3' then round((((f.field2 / (f.field5 - fnc_machine_pause(f.ch_id, f.mc_cd, p_date_ini, p_date_fin, 'PP'))) / m.nominal_output)),2)
			when 'MAQ4' then round((((f.field2 / (f.field5 - fnc_machine_pause(f.ch_id, f.mc_cd, p_date_ini, p_date_fin, 'PP'))) / m.nominal_output)),2)
			when 'MAQ5' then round((((f.field2 / (f.field5 - fnc_machine_pause(f.ch_id, f.mc_cd, p_date_ini, p_date_fin, 'PP'))) / m.nominal_output)),2)
            when 'LLC6' then round((((f.field2 / (f.field5 - fnc_machine_pause(f.ch_id, f.mc_cd, p_date_ini, p_date_fin, 'PP'))) / m.nominal_output)),2)
			when 'LLC7' then round((((f.field2 / (f.field5 - fnc_machine_pause(f.ch_id, f.mc_cd, p_date_ini, p_date_fin, 'PP'))) / m.nominal_output)),2)
			when 'LLC8' then round((((f.field2 / (f.field5 - fnc_machine_pause(f.ch_id, f.mc_cd, p_date_ini, p_date_fin, 'PP'))) / m.nominal_output)),2)
			when 'LLC9' then round((((f.field2 / (f.field5 - fnc_machine_pause(f.ch_id, f.mc_cd, p_date_ini, p_date_fin, 'PP'))) / m.nominal_output)),2)
			when 'LLC10' then round((((f.field2 / (f.field5 - fnc_machine_pause(f.ch_id, f.mc_cd, p_date_ini, p_date_fin, 'PP'))) / m.nominal_output)),2)
			when 'LLC11' then round((((f.field2 / (f.field5 - fnc_machine_pause(f.ch_id, f.mc_cd, p_date_ini, p_date_fin, 'PP'))) / m.nominal_output)),2)
			when 'LLC12' then round((((f.field2 / (f.field5 - fnc_machine_pause(f.ch_id, f.mc_cd, p_date_ini, p_date_fin, 'PP'))) / m.nominal_output)),2)
			when 'LLC13' then round((((f.field2 / (f.field5 - fnc_machine_pause(f.ch_id, f.mc_cd, p_date_ini, p_date_fin, 'PP'))) / m.nominal_output)),2)
            when 'SEL1' then round((((f.field2 / (f.field5 - fnc_machine_pause(f.ch_id, f.mc_cd, p_date_ini, p_date_fin, 'PP'))) / m.nominal_output)),2) 
            else 0
		   end, 0) as performance */
		 , coalesce(round((((f.field3 / (f.field5 - fnc_machine_pause(f.ch_id, f.mc_cd, p_date_ini, p_date_fin, 'PP'))) / m.nominal_output)),2), 0) as performance 
	  from feed f 
	 inner join (select max(f.id) as id
				   from feed f
				  where f.ch_id = p_channel_id
                    and ((f.mc_cd = p_machine_code) or ifnull(p_machine_code, '') = '')
					and f.inserted_at between 
						(STR_TO_DATE(p_date_ini, '%Y-%m-%d %H:%i:%s'))  
					and (STR_TO_DATE(p_date_fin, '%Y-%m-%d %H:%i:%s'))			
				  group by f.mc_cd) tmp on f.id = tmp.id
	 inner join machine_data m on m.code = f.mc_cd;    

	/*disponibilidade*/
	insert into tmp_availability
	select b.machine_code
		 , sum(pp) as pp
		 , sum(pnp) as pnp
	  from (
	select a.machine_code 
		 , case a.type
			when 'PP' then sum(a.pause)
			else 0 end as pp
		 , case a.type
			when 'NP' then sum(a.pause)
			else 0 end as pnp        
	  from (       
		select mpd.machine_code
			 , pr.type
			 , mpd.pause 
		  from machine_pause_dash mpd
		  left join pause_reason pr on pr.id = mpd.pause_reason_id
		 where mpd.channel_id = p_channel_id
           and ((mpd.machine_code = p_machine_code) or ifnull(p_machine_code, '') = '')
		   and mpd.date_ref between 
				   (STR_TO_DATE(p_date_ini, '%Y-%m-%d %H:%i:%s')) 
			   and (STR_TO_DATE(p_date_fin, '%Y-%m-%d %H:%i:%s'))
		 group by mpd.insert_index) a
	 group by a.machine_code, a.type) b
	 group by b.machine_code;

	-- if not exists(select 1 from tmp_performance) then
	-- 	signal sqlstate '45000' set message_text = 'sem dados';
	-- end if;
    
    set v_quality = (select quality from channel where id = p_channel_id);

	open c;
 
	read_loop: loop
		fetch c into v_machine_code, v_machine_name;	
        
		if v_done then
			leave read_loop;
		end if;			
	
		  set @v_pp = 0;
        set @v_pnp = 0;
        set @v_performance = 0;
        set @v_availability = 0.01; /*somente para não dar divisao por zero*/
        set @v_real_availability = 0;        
        
		select pp
			 , pnp
		  from tmp_availability 
		 where machine_code = v_machine_code
          into @v_pp, @v_pnp;
		        
		select performance
			 , if((field5 - coalesce(@v_pp,0)) = 0, 0.01, (field5 - coalesce(@v_pp,0)))
		  from tmp_performance 
		 where machine_code = v_machine_code
		  into @v_performance, @v_availability;
          
        set @v_real_availability = (@v_availability - coalesce(@v_pnp,0));  
		
		insert into tmp_oee(channel_id, machine_code, machine_name, availability, performance, quality, oee) 
		values (p_channel_id
			  , v_machine_code
              , v_machine_name
			  , round(((@v_real_availability / @v_availability)*100),2)
			  , round((@v_performance * 100),2)
			  , v_quality
			  , ((@v_performance * (@v_real_availability / @v_availability) * v_quality)) 
		);
        -- para evitar casos onde não tem dados nos selects dentro do loop
		set v_done = false;
	end loop;

	close c;
	select * from tmp_oee; 
end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `prc_production_count` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,STRICT_ALL_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,TRADITIONAL,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE PROCEDURE `prc_production_count`(
	in p_ch_id int(11),
    in p_date_ini varchar(20),
    in p_date_fin varchar(20),
    in p_position int
)
BEGIN
	SET @prod_sql = coalesce(
		(select sql_query 
           from feed_config_prod_query 
		  where channel_id = p_ch_id
            and position = p_position), null);
	
    if(@prod_sql is not null) then
		SET @prod_sql = REPLACE(@prod_sql, '__date_ini', p_date_ini);
		SET @prod_sql = REPLACE(@prod_sql, '__date_fin', p_date_fin);
		SET @prod_sql = REPLACE(@prod_sql, '__ch_id', p_ch_id);
        
		PREPARE stmt FROM @prod_sql;
		EXECUTE stmt;
		DEALLOCATE PREPARE stmt;          
    end if;  
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `prc_shift_oee` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,STRICT_ALL_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,TRADITIONAL,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE PROCEDURE `prc_shift_oee`(
	in p_channel_id int(11),
    in p_machine_code varchar(10),
    in p_date_ini varchar(20),
    in p_date_fin varchar(20)
)
BEGIN
	declare v_done int default false;
    declare v_hour_ini char(5);
    declare v_hour_fin char(5);
    
	declare c cursor for select hour_ini, hour_fin
						   from machine_shift ms 
						  where ms.machine_code = p_machine_code;

	declare continue handler for not found set v_done = true;    
	declare exit handler for sqlexception, sqlwarning
	begin
		rollback;
		resignal;
	end;  
	
	open c;
 
	read_loop: loop
		fetch c into v_hour_ini, v_hour_fin;	
        
		if v_done then
			leave read_loop;
		end if;			
        
        set @v_date_ini = concat(convert(date_format(str_to_date(p_date_ini, '%Y-%m-%d %H:%i:%s'), '%Y-%m-%d'), char(10)), ' ', v_hour_ini, ':00');
        set @v_date_fin = concat(convert(date_format(str_to_date(p_date_fin, '%Y-%m-%d %H:%i:%s'), '%Y-%m-%d'), char(10)), ' ', v_hour_fin, ':00');
        
		select p_machine_code as machine_code, concat('OEE turno: ', v_hour_ini, ' - ', v_hour_fin) as oee_msg;
        call prc_oee(p_channel_id, @v_date_ini, @v_date_fin, p_machine_code);
		
	end loop;

	close c;    
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `prc_user` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE PROCEDURE `prc_user`(
	in p_username varchar(100),
	in p_password varchar(500),
	in p_active bit,
	in p_admin bit,
    in p_company_name varchar(200),
    in p_phone varchar(11),
    out p_user_id int(11)
)
BEGIN
	if exists (select 1 from user where username = p_username) then 
		signal sqlstate '99999'
		set message_text = 'Usuário informado já existe';
    end if;
    insert into user(username, password, active, admin, company_name, phone)
    values(p_username, p_password, p_active, p_admin, p_company_name, p_phone);
    set p_user_id = LAST_INSERT_ID();
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `prc_user_channel` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE PROCEDURE `prc_user_channel`(
	in p_user_id int(11),
	in p_channel_id int(11)
)
BEGIN
	if not exists (select 1 from user_channel where user_id = p_user_id and channel_id = p_channel_id) then 
		insert into user_channel(user_id, channel_id) values(p_user_id, p_channel_id);
    end if;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `prc_user_mobile` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE PROCEDURE `prc_user_mobile`(
	in p_company_name varchar(200),
	in p_username varchar(100),
	in p_password varchar(500),
    in p_active bit,
	in p_admin bit,
    in p_phone varchar(11)
)
BEGIN
    set @v_maq1_test = 'MAQ1*';
    set @v_maq2_test = 'MAQ2*';
    set @v_maq3_test = 'MAQ3*';

	if exists (select 1 from user where username = p_username) then 
		signal sqlstate '99999'
		set message_text = 'Usuário informado já existe';
    end if;
    
    /*testa se maquinas de teste já existem*/
	if not exists (select 1 from machine_data where code = @v_maq1_test) then 
		CALL prc_machine_data(@v_maq1_test, 'Máquina 1', null, null, null, null);
    end if;   
	if not exists (select 1 from machine_data where code = @v_maq2_test) then 
		CALL prc_machine_data(@v_maq2_test, 'Máquina 2', null, null, null, null);
    end if; 
	if not exists (select 1 from machine_data where code = @v_maq3_test) then 
		CALL prc_machine_data(@v_maq3_test, 'Máquina 3', null, null, null, null);
    end if;     
    
    /*cria usuário*/	
    CALL prc_user(p_username, p_password, p_active, p_admin, p_company_name, p_phone, @v_user_id);
    
    /*cria canal do usuário*/
    CALL prc_channel(p_company_name, p_company_name, date_format(now(), '%d%m%Y%H%i%s'), p_active, null, null, null, @v_user_id, @v_channel_id);

    /*vincula canal ao usuário*/
    CALL prc_user_channel(@v_user_id, @v_channel_id);
    
    /*vincula maquinas ao canal*/
    CALL prc_channel_machine(@v_channel_id, @v_maq1_test);
    CALL prc_channel_machine(@v_channel_id, @v_maq2_test);
    CALL prc_channel_machine(@v_channel_id, @v_maq3_test);
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
SET @@SESSION.SQL_LOG_BIN = @MYSQLDUMP_TEMP_LOG_BIN;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2019-08-07 21:51:47
