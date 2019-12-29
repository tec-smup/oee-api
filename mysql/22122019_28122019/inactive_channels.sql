
CREATE TABLE feed_inactive_channels LIKE feed;
INSERT into feed_inactive_channels(ch_id, mc_cd, field1, field2, field3, field4, field5, inserted_at)
select ch_id, mc_cd, field1, field2, field3, field4, field5, inserted_at
  from feed f
 where f.ch_id not in(14, 21, 22);

select count(0) from feed_inactive_channels; 

delete from feed where ch_id not in(14, 21, 22);

select count(0) from feed;
