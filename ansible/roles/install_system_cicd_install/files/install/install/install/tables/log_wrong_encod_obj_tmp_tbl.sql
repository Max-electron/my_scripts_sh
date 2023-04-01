create table install.log_wrong_encod_obj_tmp_tbl
(
  id_ul             integer
  ,before_after     varchar(6)
  ,schema           varchar(128)
  ,name             varchar(128)
  ,type             varchar(128)
);
comment on table install.log_wrong_encod_obj_tmp_tbl
  is 'Временная таблица для логгирования списка хранимых процедур с символами в неверной кодировке до поставки и после поставки.';
-- add comments to the columns 
comment on column install.log_wrong_encod_obj_tmp_tbl.id_ul
  is 'id FK references install.upgrade_log_tbl';
comment on column install.log_wrong_encod_obj_tmp_tbl.before_after
  is 'До/после поставки';  
comment on column install.log_wrong_encod_obj_tmp_tbl.schema
  is 'Схема';
comment on column install.log_wrong_encod_obj_tmp_tbl.name
  is 'Название хранимой процедуры';  
comment on column install.log_wrong_encod_obj_tmp_tbl.type
  is 'Тип хранимой процедуры';
-- create/recreate indexes 
create index log_wr_encod_obj_tmp_id_ul_idx on install.log_wrong_encod_obj_tmp_tbl (id_ul);
-- create/recreate primary, unique and foreign key constraints 
alter table install.log_wrong_encod_obj_tmp_tbl
  add constraint log_wr_encod_obj_tmp_id_ul_fk foreign key (id_ul)
  references install.upgrade_log_tbl (id_ul) on delete cascade;

