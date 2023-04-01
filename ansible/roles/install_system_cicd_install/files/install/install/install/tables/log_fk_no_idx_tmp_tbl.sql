create table install.log_fk_no_idx_tmp_tbl
(
  id_ul             integer
  ,before_after     varchar(6)
  ,schema           varchar(128)
  ,table_name       varchar(128)
  ,constraint_name  varchar(128)
);
comment on table install.log_fk_no_idx_tmp_tbl
  is 'Временная таблица для логгирования списка FK без индексов до поставки и после поставки.';
-- add comments to the columns 
comment on column install.log_fk_no_idx_tmp_tbl.id_ul
  is 'id FK references install.upgrade_log_tbl';
comment on column install.log_fk_no_idx_tmp_tbl.before_after
  is 'До/после поставки';  
comment on column install.log_fk_no_idx_tmp_tbl.schema
  is 'Схема';
comment on column install.log_fk_no_idx_tmp_tbl.table_name
  is 'Название таблицы';  
comment on column install.log_fk_no_idx_tmp_tbl.constraint_name
  is 'Название FK';
-- create/recreate indexes 
create index log_fk_no_idx_tmp_id_ul_idx on install.log_fk_no_idx_tmp_tbl (id_ul);
-- create/recreate primary, unique and foreign key constraints 
alter table install.log_fk_no_idx_tmp_tbl
  add constraint log_fk_no_idx_tmp_id_ul_fk foreign key (id_ul)
  references install.upgrade_log_tbl (id_ul) on delete cascade;

