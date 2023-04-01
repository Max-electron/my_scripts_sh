create table install.sys_registry_settings_tbl
(
  sys_name       varchar(50) unique,
  single_install integer
);
comment on table install.sys_registry_settings_tbl
  is 'Конфигурационная таблица с настройками для подсистем';
comment on column install.sys_registry_settings_tbl.sys_name
  is 'Имя подсистемы. Уникальное';
comment on column install.sys_registry_settings_tbl.single_install
  is '1 - одновременно только одна установка';
