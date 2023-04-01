create table install.log_fk_no_idx_delta_tbl
(
  id_ul             integer
  ,schema           varchar(128)
  ,table_name       varchar(128)
  ,constraint_name  varchar(128)
);
comment on table install.log_fk_no_idx_delta_tbl
  is 'Логгирование дельты (список_дельта = список_после_поставки - список_до_поставки) списка FK без индексов.';
-- add comments to the columns 
comment on column install.log_fk_no_idx_delta_tbl.id_ul
  is 'ID references install.upgrade_log_tbl.id_ul';
comment on column install.log_fk_no_idx_delta_tbl.schema
  is 'Схема';
comment on column install.log_fk_no_idx_delta_tbl.table_name
  is 'Название таблицы';  
comment on column install.log_fk_no_idx_delta_tbl.constraint_name
  is 'Название FK';
-- create/recreate indexes 
create index log_fk_no_idx_delta_id_ul_idx on install.log_fk_no_idx_delta_tbl (id_ul);
-- create/recreate primary, unique and foreign key constraints 
alter table install.log_fk_no_idx_delta_tbl
  add constraint log_fk_no_idx_delta_id_ul_fk foreign key (id_ul)
  references install.upgrade_log_tbl (id_ul) on delete cascade;

