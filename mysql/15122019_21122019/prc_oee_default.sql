CREATE PROCEDURE prc_oee(
	IN p_channel_id int,
	IN p_date_ini varchar(20),
	IN p_date_fin varchar(20),
	IN p_machine_code varchar(10)
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
end