USE `oee`;
DROP procedure IF EXISTS `prc_chart_pause_pareto`;

DELIMITER $$
USE `oee`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `prc_chart_pause_pareto`(
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
			select mpd.pause
			  from machine_pause_dash mpd
			 inner join pause_reason pr on pr.id = mpd.pause_reason_id
			 where mpd.channel_id = __channel_id
			   __machine_filter
			   and pr.type = \'NP\'	   
			   and mpd.date_ref_year = year(now())
			   __filter
			 group by mpd.insert_index
		) p;';
    
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
					select mpd.date_ref
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
					   and mpd.date_ref_year = year(now())
					   __filter                       
					 group by mpd.insert_index
				) p
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
			set @queryPauses = replace(@queryPauses, '__filter', 'and mpd.date_ref_month = month(now())');
            set @queryPausesCount = replace(@queryPausesCount, '__filter', 'and mpd.date_ref_month = month(now())'); 
        -- filtro por mes/semana
        elseif(p_time_filter = 2) then
			set @queryPauses = replace(@queryPauses, '__filter', 'and mpd.date_ref between date_sub(now(), interval 7 day) and now()');
            set @queryPausesCount = replace(@queryPausesCount, '__filter', 'and mpd.date_ref between date_sub(now(), interval 7 day) and now()');        
		-- filtro por mes/dia
        elseif(p_time_filter = 3) then
			set @queryPauses = replace(@queryPauses, '__filter', 'and mpd.date_ref_day = day(now()) and mpd.date_ref_month = month(now())');
			set @queryPausesCount = replace(@queryPausesCount, '__filter', 'and mpd.date_ref_day = day(now()) and mpd.date_ref_month = month(now())');
		-- filtro por mes/dia anterior
        else
			set @queryPauses = replace(@queryPauses, '__filter', 'and mpd.date_ref_day = (day(now())-1) and mpd.date_ref_month = month(now())');
			set @queryPausesCount = replace(@queryPausesCount, '__filter', 'and mpd.date_ref_day = (day(now())-1) and mpd.date_ref_month = month(now())');        
        end if;    
        
    prepare stmt from @queryPausesCount;
	execute stmt;
	deallocate prepare stmt;  
    
    prepare stmt from @queryPauses; 
	execute stmt;
	deallocate prepare stmt;      
        
END$$

DELIMITER ;

