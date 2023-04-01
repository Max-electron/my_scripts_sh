create table install.log_wrong_encod_obj_delta_tbl
(
  id_ul             integer
  ,schema           varchar(128)
  ,name             varchar(128)
  ,type             varchar(128)
);
comment on table install.log_wrong_encod_obj_delta_tbl
  is 'Логгирование дельты (список_дельта = список_после_поставки - список_до_поставки) списка хранимых процедур с символами в неверной кодировке.';
-- add comments to the columns 
comment on column install.log_wrong_encod_obj_delta_tbl.id_ul
  is 'ID references install.upgrade_log_tbl.id_ul';
comment on column install.log_wrong_encod_obj_delta_tbl.schema
  is 'Схема';
comment on column install.log_wrong_encod_obj_delta_tbl.name
  is 'Название хранимой процедуры';  
comment on column install.log_wrong_encod_obj_delta_tbl.type
  is 'Тип хранимой процедуры';
-- create/recreate indexes 
create index log_wr_encd_obj_dlta_id_ul_idx on install.log_wrong_encod_obj_delta_tbl (id_ul);
-- create/recreate primary, unique and foreign key constraints 
alter table install.log_wrong_encod_obj_delta_tbl
  add constraint log_wr_encd_obj_dlta_id_ul_fk foreign key (id_ul)
  references install.upgrade_log_tbl (id_ul) on delete cascade;

