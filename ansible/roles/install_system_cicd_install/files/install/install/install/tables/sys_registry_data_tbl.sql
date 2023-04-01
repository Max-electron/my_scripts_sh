create table install.sys_registry_data_tbl(
  id_sys_reg     integer generated always as identity,
  sys_name       varchar(100) not null,
  version        varchar(50) not null,
  install_date   timestamp not null,
  uninstall_date timestamp,
  dbuser         varchar(200),
  osuser         varchar(200),
  id_ul          integer,
  constraint id_sys_reg_pk primary key (id_sys_reg)
);

-- add comments to the table 
comment on table install.sys_registry_data_tbl
  is 'Версии подсистем';
-- add comments to the columns 
comment on column install.sys_registry_data_tbl.sys_name
  is 'Имя подсистемы';
comment on column install.sys_registry_data_tbl.install_date
  is 'Дата установки релиза';
comment on column install.sys_registry_data_tbl.uninstall_date
  is 'Дата удаления релиза или повышения верси системы';
comment on column install.sys_registry_data_tbl.dbuser
  is 'Имя пользователя, установившего релиз';
comment on column install.sys_registry_data_tbl.osuser
  is 'Учетная запись человека, внесшего изменения';
comment on column install.sys_registry_data_tbl.id_ul
  is 'PK таблицы install.upgrade_log_tbl';
comment on column install.sys_registry_data_tbl.version
  is 'Версия подсистемы';

--create index install.i_sys_reg_date_actdate on install.sys_registry_data_tbl(sys_name, install_date, coalesce(uninstall_date, to_timestamp('01.01.9999', 'dd.mm.yyyy')));

