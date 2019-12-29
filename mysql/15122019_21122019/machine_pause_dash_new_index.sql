alter table machine_pause_dash drop foreign key fk_machine_pause_dash_channel;
drop index idx_channel_machine_date_ref_insert_index_pause on machine_pause_dash;

alter table machine_pause_dash add constraint fk_machine_pause_dash_channel foreign key(channel_id) references channel(id);
alter table machine_pause_dash add index idx_channel_machine_date_ref_insert_index_pause(channel_id, machine_code, date_ref, insert_index, pause);