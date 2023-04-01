create table install.upgrade_log_tbl
(
  id_ul               integer generated always as identity,
  system_name         varchar(100),
  action              varchar(20),
  prev_system_version varchar(50),
  system_version      varchar(100),
  start_time          timestamp,
  finish_time         timestamp,
  result              varchar(10),
  osuser              varchar(30),
  host                varchar(250),
  program             varchar(30),
  logs                varchar(1000),
  sppr_delivery       varchar(100),
  cvs_revision        varchar(100),
  git_revision        varchar(40),
  cvs_url             varchar(1000),
  update_vers         integer,
  constraint id_ul_pk primary key (id_ul)
);

comment on table install.upgrade_log_tbl
  is 'Лог установки подсистем';
comment on column install.upgrade_log_tbl.id_ul
  is 'PK';
comment on column install.upgrade_log_tbl.system_name
  is 'Наименование подсистемы';
comment on column install.upgrade_log_tbl.prev_system_version
  is 'Ожидаемая версия подсистемы, с которой нужно обновиться';
  comment on column install.upgrade_log_tbl.system_version
  is 'Версия подсистемы';
comment on column install.upgrade_log_tbl.start_time
  is 'Время начала установки';
comment on column install.upgrade_log_tbl.finish_time
  is 'Время завершения установки';
comment on column install.upgrade_log_tbl.cvs_revision
  is 'Ревизия SVN';
comment on column install.upgrade_log_tbl.cvs_url
  is 'URL для скачивания tbz-файла с обновлением подсистемы';
comment on column install.upgrade_log_tbl.action
  is 'Действие';
comment on column install.upgrade_log_tbl.osuser
  is 'Пользователь ОС';
comment on column install.upgrade_log_tbl.host
  is 'Хост';
comment on column install.upgrade_log_tbl.program
  is 'Приложение';
comment on column install.upgrade_log_tbl.result
  is 'Результат';
comment on column install.upgrade_log_tbl.logs
  is 'Детали результата';
comment on column install.upgrade_log_tbl.sppr_delivery
  is 'Номер задачи из СППР или Jira';
comment on column install.upgrade_log_tbl.update_vers
  is 'Нужно ли обновлять версию после установки. 1-да.';
comment on column install.upgrade_log_tbl.git_revision
  is 'Ревизия GIT';
