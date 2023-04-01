create type install.upgrade_log_row as
(
  id_ul               integer,
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
  update_vers         integer
);
