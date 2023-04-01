\o install_log_1.0.2.lst

\t on
\set ON_ERROR_STOP on
SET client_encoding TO 'UTF8';

--Set Variables--
SET context.COLORED = 1;

\set version_desc          '\'' install_assembly_1.0.2 '\''
\set system_name           '\'' INSTALL '\''
\set previous_version      '\'' 0.0.0 '\''
\set new_version           '\'' 1.0.2 '\''
\set new_revision          '\''  '\''
\set new_git_revision      '\'' fdc8c7626151ddae26bcc2e2990acc8f386570da '\''
\set url_tbz               '\''  '\'' 
\set sppr_delivery_number  '\'' CCRDB-49 '\''

\set date_created          '\'' 16.08.2022 07:27:15 UTC '\''
\set user_created          '\'' root '\''
\set monopol               '\'' 0 '\''
\set check_vers            '\'' 1 '\''
\set update_vers           '\'' 1 '\''
\set update_revision       '\'' 1 '\''
\set list_debug_pack       '\'' 0 '\''
\set list_changed_pack     '\'' 0 '\''

\set schema_list           '\'' INSTALL '\''
\set stop_job_list         '\''  '\''
\set sleep_job_timeout     '\'' 5 '\''
\set separator             '\'' *************************************************************************************************************** '\''
\set separator_list        '\'' --------------------------------------------------------------------------------------------------------------- '\''
\set total_blocks          '\'' 43 '\''
\set total_blocks_install  '\'' 0 '\''
select to_char(clock_timestamp(), 'dd.mm.yyyy hh24:mi:ss') as start_script_time \gset
\set start_script_time_str '\'' :start_script_time '\''
------------------------------------------------------------------------------------------------------------------

--Get OS user name--
\set osuser_windows `echo %USERNAME%`
\set osuser_windows_str '\'' :osuser_windows '\''
select :osuser_windows_str = '%USERNAME%' as is_linux \gset
\set osuser_linux   `echo "$USER"`
\set osuser_linux_str '\'' :osuser_linux '\''
select :osuser_linux_str = '"$USER"' as is_windows \gset
\if :is_windows
    SET context.OSUSER = :osuser_windows;
\elif :is_linux    
    SET context.OSUSER = :osuser_linux;
\endif
------------------------------------------------------------------------------------------------------------------

--Start info--
--show on screen--
\echo
\echo
\echo '+-------------------------------------------Start installation sql update---------------------------------------+'
\echo '[':start_script_time' : POSTGRES : INSTALL INFO    : INF] Subsystem INSTALL for PostgreSQL version 1.0.0'
\echo '[':start_script_time' : POSTGRES : INSTALL PARAM   : INF] system_name = ':system_name
\echo '[':start_script_time' : POSTGRES : INSTALL PARAM   : INF] previous_version = ':previous_version
\echo '[':start_script_time' : POSTGRES : INSTALL PARAM   : INF] new_version = ':new_version
\echo '[':start_script_time' : POSTGRES : INSTALL PARAM   : INF] new_revision = ':new_revision
\echo '[':start_script_time' : POSTGRES : INSTALL PARAM   : INF] new_git_revision = ':new_git_revision
\echo '[':start_script_time' : POSTGRES : INSTALL PARAM   : INF] url_tbz = ':url_tbz
\echo '[':start_script_time' : POSTGRES : INSTALL PARAM   : INF] sppr_delivery_number = ':sppr_delivery_number
\echo '[':start_script_time' : POSTGRES : INSTALL PARAM   : INF] check_vers = ':check_vers 
\echo '[':start_script_time' : POSTGRES : INSTALL PARAM   : INF] update_vers = ':update_vers
\echo '[---------------------------------------------------------------------------------------------------------------]'
------------------------------------------------------------------------------------------------------------------

--Start info--
--write to log--
select '+-------------------------------------------Start installation sql update---------------------------------------+';
select '[' || to_char(clock_timestamp(), 'dd.mm.yyyy hh24:mi:ss') || ' : ' || 'POSTGRES' || ' : ' || rpad('INSTALL INFO', 15) || ' : ' || 'INF] Subsystem INSTALL for PostgreSQL version 1.0.0';
select '[' || to_char(clock_timestamp(), 'dd.mm.yyyy hh24:mi:ss') || ' : ' || 'POSTGRES' || ' : ' || rpad('INSTALL PARAM', 15) || ' : ' || 'INF] system_name = '||:system_name;
select '[' || to_char(clock_timestamp(), 'dd.mm.yyyy hh24:mi:ss') || ' : ' || 'POSTGRES' || ' : ' || rpad('INSTALL PARAM', 15) || ' : ' || 'INF] previous_version = '||:previous_version;
select '[' || to_char(clock_timestamp(), 'dd.mm.yyyy hh24:mi:ss') || ' : ' || 'POSTGRES' || ' : ' || rpad('INSTALL PARAM', 15) || ' : ' || 'INF] new_version = '||:new_version;
select '[' || to_char(clock_timestamp(), 'dd.mm.yyyy hh24:mi:ss') || ' : ' || 'POSTGRES' || ' : ' || rpad('INSTALL PARAM', 15) || ' : ' || 'INF] new_revision = '||:new_revision;
select '[' || to_char(clock_timestamp(), 'dd.mm.yyyy hh24:mi:ss') || ' : ' || 'POSTGRES' || ' : ' || rpad('INSTALL PARAM', 15) || ' : ' || 'INF] new_git_revision = '||:new_git_revision;
select '[' || to_char(clock_timestamp(), 'dd.mm.yyyy hh24:mi:ss') || ' : ' || 'POSTGRES' || ' : ' || rpad('INSTALL PARAM', 15) || ' : ' || 'INF] url_tbz = '||:url_tbz;
select '[' || to_char(clock_timestamp(), 'dd.mm.yyyy hh24:mi:ss') || ' : ' || 'POSTGRES' || ' : ' || rpad('INSTALL PARAM', 15) || ' : ' || 'INF] sppr_delivery_number = '||:sppr_delivery_number;
select '[' || to_char(clock_timestamp(), 'dd.mm.yyyy hh24:mi:ss') || ' : ' || 'POSTGRES' || ' : ' || rpad('INSTALL PARAM', 15) || ' : ' || 'INF] check_vers = '||:check_vers;
select '[' || to_char(clock_timestamp(), 'dd.mm.yyyy hh24:mi:ss') || ' : ' || 'POSTGRES' || ' : ' || rpad('INSTALL PARAM', 15) || ' : ' || 'INF] update_vers = '||:update_vers;
select '[---------------------------------------------------------------------------------------------------------------]';
------------------------------------------------------------------------------------------------------------------


--Check current user is "install"--
--write error to log--
select 'Check current database user is "install"';
select '[---------------------------------------------------------------------------------------------------------------]';
select (current_user != 'install') as user_is_not_install \gset
\if :user_is_not_install
  select '['|| to_char(clock_timestamp(), 'dd.mm.yyyy hh24:mi:ss') || ' : POSTGRES : ' 
            || rpad('INSTALL CHECK', 15) || ' : ERR] The update must be installed under the "install" user, but the current user is "'|| current_user||'"';
\endif
------------------------------------------------------------------------------------------------------------------

--Check current user is "install"--
--show error on screen--
\echo 'Check current database user is "install"'
\echo '[---------------------------------------------------------------------------------------------------------------]'
do 
$body$
begin
    if (current_user != 'install') then
        raise sqlstate 'ERR01'
              using message = '[1;31m'||'The update must be installed under the "install" user, but the current user is "'|| current_user||'"'||'[1;m[1;m';
    end if;  
end; 
$body$ language plpgsql;
------------------------------------------------------------------------------------------------------------------

--Check if the INSTALL subsystem already installed in the current database--
--write error to log--
select 'Check if the INSTALL subsystem already installed in the current database '|| current_database();
select '[---------------------------------------------------------------------------------------------------------------]';
SELECT (count(1) = 1) as srdt_table_exists FROM pg_catalog.pg_tables pt where pt.schemaname = 'install' and pt.tablename = 'sys_registry_data_tbl' \gset
\if :srdt_table_exists
  select '['|| to_char(clock_timestamp(), 'dd.mm.yyyy hh24:mi:ss') || ' : POSTGRES : ' 
            || rpad('INSTALL CHECK', 15) || ' : ERR] The INSTALL subsystem already installed in the current database '|| current_database() ||'!';
\endif
------------------------------------------------------------------------------------------------------------------

--Check if the INSTALL subsystem already installed in the current database--
--show error on screen--
\echo 'Check if the INSTALL subsystem already installed in the current database'
\echo '[---------------------------------------------------------------------------------------------------------------]'
do 
$body$
declare
  v_cnt integer;
begin
	SELECT count(1) into v_cnt FROM pg_catalog.pg_tables pt where pt.schemaname = 'install' and pt.tablename = 'sys_registry_data_tbl';
    if v_cnt = 1 then
        raise sqlstate 'ERR01'
              using message = '[1;31m'||'The INSTALL subsystem already installed in the current database "'|| current_database() ||'"'||'[1;m[1;m';
    end if;  
end; 
$body$ language plpgsql;
------------------------------------------------------------------------------------------------------------------

\unset ON_ERROR_STOP

------------------------------------------------------------------------------------------------------------------
------------------------------------------------FILE--------------------------------------------------------------
 --{TMPL.INSTALL.COUNTBLOCK}--
 select round((:total_blocks_install * 100) / :total_blocks) as total_prc \gset
 \echo '[':start_script_time' : POSTGRES : INSTALL         : INF] Completed: ':total_prc'%' 
 select '[' || to_char(clock_timestamp(), 'dd.mm.yyyy hh24:mi:ss') || ' : ' || 'POSTGRES' || ' : ' || rpad('INSTALL', 15) || ' : ' || 'INF] Completed: '||:total_prc||'%'; 
 -- Revision: 7517e234e594dd73c14f13c2b61bf579535cba00 Task:  Date: 31.05.2022 15:18:41 UTC Author: makaenko_aa
 \echo '[---------------------------------------------------------------------------------------------------------------]'
 select '[---------------------------------------------------------------------------------------------------------------]';
 \echo ' install/install/commands/before/default_privileges.sql'
 select ' install/install/commands/before/default_privileges.sql';
 select '   [REVISION]   7517e234e594dd73c14f13c2b61bf579535cba00';
 select '   [TASK]         ';
 select '   [DATE]         31.05.2022 15:18:41 UTC';
 select '   [AUTHOR]       makaenko_aa';
 select '   [START]        ' || to_char(clock_timestamp(), 'dd.mm.yyyy hh24:mi:ss');

--if error then color red
\echo '[1;31m'

\i install/install/commands/before/default_privileges.sql

\echo '[1;m[1;m'
 
 select '   [FINISH]       '|| to_char(clock_timestamp(), 'dd.mm.yyyy hh24:mi:ss');
 \echo '[---------------------------------------------------------------------------------------------------------------]'
 select '[---------------------------------------------------------------------------------------------------------------]';
 select :total_blocks_install + 1 as total_blocks_install \gset
-----------------------------------------------/FILE/-------------------------------------------------------------
--
------------------------------------------------FILE--------------------------------------------------------------
 --{TMPL.INSTALL.COUNTBLOCK}--
 select round((:total_blocks_install * 100) / :total_blocks) as total_prc \gset
 \echo '[':start_script_time' : POSTGRES : INSTALL         : INF] Completed: ':total_prc'%' 
 select '[' || to_char(clock_timestamp(), 'dd.mm.yyyy hh24:mi:ss') || ' : ' || 'POSTGRES' || ' : ' || rpad('INSTALL', 15) || ' : ' || 'INF] Completed: '||:total_prc||'%'; 
 -- Revision: 0112239933de6e32375719c96ff6098b00b12598 Task:  Date: 20.05.2022 12:38:28 UTC Author: makaenko_aa
 \echo '[---------------------------------------------------------------------------------------------------------------]'
 select '[---------------------------------------------------------------------------------------------------------------]';
 \echo ' install/install/types/compare_system_return_row.sql'
 select ' install/install/types/compare_system_return_row.sql';
 select '   [REVISION]   0112239933de6e32375719c96ff6098b00b12598';
 select '   [TASK]         ';
 select '   [DATE]         20.05.2022 12:38:28 UTC';
 select '   [AUTHOR]       makaenko_aa';
 select '   [START]        ' || to_char(clock_timestamp(), 'dd.mm.yyyy hh24:mi:ss');

--if error then color red
\echo '[1;31m'

\i install/install/types/compare_system_return_row.sql

\echo '[1;m[1;m'
 
 select '   [FINISH]       '|| to_char(clock_timestamp(), 'dd.mm.yyyy hh24:mi:ss');
 \echo '[---------------------------------------------------------------------------------------------------------------]'
 select '[---------------------------------------------------------------------------------------------------------------]';
 select :total_blocks_install + 1 as total_blocks_install \gset
-----------------------------------------------/FILE/-------------------------------------------------------------
--
------------------------------------------------FILE--------------------------------------------------------------
 --{TMPL.INSTALL.COUNTBLOCK}--
 select round((:total_blocks_install * 100) / :total_blocks) as total_prc \gset
 \echo '[':start_script_time' : POSTGRES : INSTALL         : INF] Completed: ':total_prc'%' 
 select '[' || to_char(clock_timestamp(), 'dd.mm.yyyy hh24:mi:ss') || ' : ' || 'POSTGRES' || ' : ' || rpad('INSTALL', 15) || ' : ' || 'INF] Completed: '||:total_prc||'%'; 
 -- Revision: 0112239933de6e32375719c96ff6098b00b12598 Task:  Date: 20.05.2022 12:38:28 UTC Author: makaenko_aa
 \echo '[---------------------------------------------------------------------------------------------------------------]'
 select '[---------------------------------------------------------------------------------------------------------------]';
 \echo ' install/install/types/sys_registry_settings_row.sql'
 select ' install/install/types/sys_registry_settings_row.sql';
 select '   [REVISION]   0112239933de6e32375719c96ff6098b00b12598';
 select '   [TASK]         ';
 select '   [DATE]         20.05.2022 12:38:28 UTC';
 select '   [AUTHOR]       makaenko_aa';
 select '   [START]        ' || to_char(clock_timestamp(), 'dd.mm.yyyy hh24:mi:ss');

--if error then color red
\echo '[1;31m'

\i install/install/types/sys_registry_settings_row.sql

\echo '[1;m[1;m'
 
 select '   [FINISH]       '|| to_char(clock_timestamp(), 'dd.mm.yyyy hh24:mi:ss');
 \echo '[---------------------------------------------------------------------------------------------------------------]'
 select '[---------------------------------------------------------------------------------------------------------------]';
 select :total_blocks_install + 1 as total_blocks_install \gset
-----------------------------------------------/FILE/-------------------------------------------------------------
--
------------------------------------------------FILE--------------------------------------------------------------
 --{TMPL.INSTALL.COUNTBLOCK}--
 select round((:total_blocks_install * 100) / :total_blocks) as total_prc \gset
 \echo '[':start_script_time' : POSTGRES : INSTALL         : INF] Completed: ':total_prc'%' 
 select '[' || to_char(clock_timestamp(), 'dd.mm.yyyy hh24:mi:ss') || ' : ' || 'POSTGRES' || ' : ' || rpad('INSTALL', 15) || ' : ' || 'INF] Completed: '||:total_prc||'%'; 
 -- Revision: 0112239933de6e32375719c96ff6098b00b12598 Task:  Date: 20.05.2022 12:38:28 UTC Author: makaenko_aa
 \echo '[---------------------------------------------------------------------------------------------------------------]'
 select '[---------------------------------------------------------------------------------------------------------------]';
 \echo ' install/install/types/system_version_row.sql'
 select ' install/install/types/system_version_row.sql';
 select '   [REVISION]   0112239933de6e32375719c96ff6098b00b12598';
 select '   [TASK]         ';
 select '   [DATE]         20.05.2022 12:38:28 UTC';
 select '   [AUTHOR]       makaenko_aa';
 select '   [START]        ' || to_char(clock_timestamp(), 'dd.mm.yyyy hh24:mi:ss');

--if error then color red
\echo '[1;31m'

\i install/install/types/system_version_row.sql

\echo '[1;m[1;m'
 
 select '   [FINISH]       '|| to_char(clock_timestamp(), 'dd.mm.yyyy hh24:mi:ss');
 \echo '[---------------------------------------------------------------------------------------------------------------]'
 select '[---------------------------------------------------------------------------------------------------------------]';
 select :total_blocks_install + 1 as total_blocks_install \gset
-----------------------------------------------/FILE/-------------------------------------------------------------
--
------------------------------------------------FILE--------------------------------------------------------------
 --{TMPL.INSTALL.COUNTBLOCK}--
 select round((:total_blocks_install * 100) / :total_blocks) as total_prc \gset
 \echo '[':start_script_time' : POSTGRES : INSTALL         : INF] Completed: ':total_prc'%' 
 select '[' || to_char(clock_timestamp(), 'dd.mm.yyyy hh24:mi:ss') || ' : ' || 'POSTGRES' || ' : ' || rpad('INSTALL', 15) || ' : ' || 'INF] Completed: '||:total_prc||'%'; 
 -- Revision: 0112239933de6e32375719c96ff6098b00b12598 Task:  Date: 20.05.2022 12:38:28 UTC Author: makaenko_aa
 \echo '[---------------------------------------------------------------------------------------------------------------]'
 select '[---------------------------------------------------------------------------------------------------------------]';
 \echo ' install/install/types/upgrade_log_row.sql'
 select ' install/install/types/upgrade_log_row.sql';
 select '   [REVISION]   0112239933de6e32375719c96ff6098b00b12598';
 select '   [TASK]         ';
 select '   [DATE]         20.05.2022 12:38:28 UTC';
 select '   [AUTHOR]       makaenko_aa';
 select '   [START]        ' || to_char(clock_timestamp(), 'dd.mm.yyyy hh24:mi:ss');

--if error then color red
\echo '[1;31m'

\i install/install/types/upgrade_log_row.sql

\echo '[1;m[1;m'
 
 select '   [FINISH]       '|| to_char(clock_timestamp(), 'dd.mm.yyyy hh24:mi:ss');
 \echo '[---------------------------------------------------------------------------------------------------------------]'
 select '[---------------------------------------------------------------------------------------------------------------]';
 select :total_blocks_install + 1 as total_blocks_install \gset
-----------------------------------------------/FILE/-------------------------------------------------------------
--
------------------------------------------------FILE--------------------------------------------------------------
 --{TMPL.INSTALL.COUNTBLOCK}--
 select round((:total_blocks_install * 100) / :total_blocks) as total_prc \gset
 \echo '[':start_script_time' : POSTGRES : INSTALL         : INF] Completed: ':total_prc'%' 
 select '[' || to_char(clock_timestamp(), 'dd.mm.yyyy hh24:mi:ss') || ' : ' || 'POSTGRES' || ' : ' || rpad('INSTALL', 15) || ' : ' || 'INF] Completed: '||:total_prc||'%'; 
 -- Revision: 0d2daf378c396f2abfc8a79ef25bebba7e37eeeb Task:  Date: 14.06.2022 06:42:19 UTC Author: makaenko_aa
 \echo '[---------------------------------------------------------------------------------------------------------------]'
 select '[---------------------------------------------------------------------------------------------------------------]';
 \echo ' install/install/tables/1_upgrade_log_tbl.sql'
 select ' install/install/tables/1_upgrade_log_tbl.sql';
 select '   [REVISION]   0d2daf378c396f2abfc8a79ef25bebba7e37eeeb';
 select '   [TASK]         ';
 select '   [DATE]         14.06.2022 06:42:19 UTC';
 select '   [AUTHOR]       makaenko_aa';
 select '   [START]        ' || to_char(clock_timestamp(), 'dd.mm.yyyy hh24:mi:ss');

--if error then color red
\echo '[1;31m'

\i install/install/tables/1_upgrade_log_tbl.sql

\echo '[1;m[1;m'
 
 select '   [FINISH]       '|| to_char(clock_timestamp(), 'dd.mm.yyyy hh24:mi:ss');
 \echo '[---------------------------------------------------------------------------------------------------------------]'
 select '[---------------------------------------------------------------------------------------------------------------]';
 select :total_blocks_install + 1 as total_blocks_install \gset
-----------------------------------------------/FILE/-------------------------------------------------------------
--
------------------------------------------------FILE--------------------------------------------------------------
 --{TMPL.INSTALL.COUNTBLOCK}--
 select round((:total_blocks_install * 100) / :total_blocks) as total_prc \gset
 \echo '[':start_script_time' : POSTGRES : INSTALL         : INF] Completed: ':total_prc'%' 
 select '[' || to_char(clock_timestamp(), 'dd.mm.yyyy hh24:mi:ss') || ' : ' || 'POSTGRES' || ' : ' || rpad('INSTALL', 15) || ' : ' || 'INF] Completed: '||:total_prc||'%'; 
 -- Revision: 0d2daf378c396f2abfc8a79ef25bebba7e37eeeb Task:  Date: 14.06.2022 06:42:19 UTC Author: makaenko_aa
 \echo '[---------------------------------------------------------------------------------------------------------------]'
 select '[---------------------------------------------------------------------------------------------------------------]';
 \echo ' install/install/tables/log_fk_no_idx_delta_tbl.sql'
 select ' install/install/tables/log_fk_no_idx_delta_tbl.sql';
 select '   [REVISION]   0d2daf378c396f2abfc8a79ef25bebba7e37eeeb';
 select '   [TASK]         ';
 select '   [DATE]         14.06.2022 06:42:19 UTC';
 select '   [AUTHOR]       makaenko_aa';
 select '   [START]        ' || to_char(clock_timestamp(), 'dd.mm.yyyy hh24:mi:ss');

--if error then color red
\echo '[1;31m'

\i install/install/tables/log_fk_no_idx_delta_tbl.sql

\echo '[1;m[1;m'
 
 select '   [FINISH]       '|| to_char(clock_timestamp(), 'dd.mm.yyyy hh24:mi:ss');
 \echo '[---------------------------------------------------------------------------------------------------------------]'
 select '[---------------------------------------------------------------------------------------------------------------]';
 select :total_blocks_install + 1 as total_blocks_install \gset
-----------------------------------------------/FILE/-------------------------------------------------------------
--
------------------------------------------------FILE--------------------------------------------------------------
 --{TMPL.INSTALL.COUNTBLOCK}--
 select round((:total_blocks_install * 100) / :total_blocks) as total_prc \gset
 \echo '[':start_script_time' : POSTGRES : INSTALL         : INF] Completed: ':total_prc'%' 
 select '[' || to_char(clock_timestamp(), 'dd.mm.yyyy hh24:mi:ss') || ' : ' || 'POSTGRES' || ' : ' || rpad('INSTALL', 15) || ' : ' || 'INF] Completed: '||:total_prc||'%'; 
 -- Revision: 0d2daf378c396f2abfc8a79ef25bebba7e37eeeb Task:  Date: 14.06.2022 06:42:19 UTC Author: makaenko_aa
 \echo '[---------------------------------------------------------------------------------------------------------------]'
 select '[---------------------------------------------------------------------------------------------------------------]';
 \echo ' install/install/tables/log_fk_no_idx_tmp_tbl.sql'
 select ' install/install/tables/log_fk_no_idx_tmp_tbl.sql';
 select '   [REVISION]   0d2daf378c396f2abfc8a79ef25bebba7e37eeeb';
 select '   [TASK]         ';
 select '   [DATE]         14.06.2022 06:42:19 UTC';
 select '   [AUTHOR]       makaenko_aa';
 select '   [START]        ' || to_char(clock_timestamp(), 'dd.mm.yyyy hh24:mi:ss');

--if error then color red
\echo '[1;31m'

\i install/install/tables/log_fk_no_idx_tmp_tbl.sql

\echo '[1;m[1;m'
 
 select '   [FINISH]       '|| to_char(clock_timestamp(), 'dd.mm.yyyy hh24:mi:ss');
 \echo '[---------------------------------------------------------------------------------------------------------------]'
 select '[---------------------------------------------------------------------------------------------------------------]';
 select :total_blocks_install + 1 as total_blocks_install \gset
-----------------------------------------------/FILE/-------------------------------------------------------------
--
------------------------------------------------FILE--------------------------------------------------------------
 --{TMPL.INSTALL.COUNTBLOCK}--
 select round((:total_blocks_install * 100) / :total_blocks) as total_prc \gset
 \echo '[':start_script_time' : POSTGRES : INSTALL         : INF] Completed: ':total_prc'%' 
 select '[' || to_char(clock_timestamp(), 'dd.mm.yyyy hh24:mi:ss') || ' : ' || 'POSTGRES' || ' : ' || rpad('INSTALL', 15) || ' : ' || 'INF] Completed: '||:total_prc||'%'; 
 -- Revision: 0d2daf378c396f2abfc8a79ef25bebba7e37eeeb Task:  Date: 14.06.2022 06:42:19 UTC Author: makaenko_aa
 \echo '[---------------------------------------------------------------------------------------------------------------]'
 select '[---------------------------------------------------------------------------------------------------------------]';
 \echo ' install/install/tables/log_wrong_encod_obj_delta_tbl.sql'
 select ' install/install/tables/log_wrong_encod_obj_delta_tbl.sql';
 select '   [REVISION]   0d2daf378c396f2abfc8a79ef25bebba7e37eeeb';
 select '   [TASK]         ';
 select '   [DATE]         14.06.2022 06:42:19 UTC';
 select '   [AUTHOR]       makaenko_aa';
 select '   [START]        ' || to_char(clock_timestamp(), 'dd.mm.yyyy hh24:mi:ss');

--if error then color red
\echo '[1;31m'

\i install/install/tables/log_wrong_encod_obj_delta_tbl.sql

\echo '[1;m[1;m'
 
 select '   [FINISH]       '|| to_char(clock_timestamp(), 'dd.mm.yyyy hh24:mi:ss');
 \echo '[---------------------------------------------------------------------------------------------------------------]'
 select '[---------------------------------------------------------------------------------------------------------------]';
 select :total_blocks_install + 1 as total_blocks_install \gset
-----------------------------------------------/FILE/-------------------------------------------------------------
--
------------------------------------------------FILE--------------------------------------------------------------
 --{TMPL.INSTALL.COUNTBLOCK}--
 select round((:total_blocks_install * 100) / :total_blocks) as total_prc \gset
 \echo '[':start_script_time' : POSTGRES : INSTALL         : INF] Completed: ':total_prc'%' 
 select '[' || to_char(clock_timestamp(), 'dd.mm.yyyy hh24:mi:ss') || ' : ' || 'POSTGRES' || ' : ' || rpad('INSTALL', 15) || ' : ' || 'INF] Completed: '||:total_prc||'%'; 
 -- Revision: 0d2daf378c396f2abfc8a79ef25bebba7e37eeeb Task:  Date: 14.06.2022 06:42:19 UTC Author: makaenko_aa
 \echo '[---------------------------------------------------------------------------------------------------------------]'
 select '[---------------------------------------------------------------------------------------------------------------]';
 \echo ' install/install/tables/log_wrong_encod_obj_tmp_tbl.sql'
 select ' install/install/tables/log_wrong_encod_obj_tmp_tbl.sql';
 select '   [REVISION]   0d2daf378c396f2abfc8a79ef25bebba7e37eeeb';
 select '   [TASK]         ';
 select '   [DATE]         14.06.2022 06:42:19 UTC';
 select '   [AUTHOR]       makaenko_aa';
 select '   [START]        ' || to_char(clock_timestamp(), 'dd.mm.yyyy hh24:mi:ss');

--if error then color red
\echo '[1;31m'

\i install/install/tables/log_wrong_encod_obj_tmp_tbl.sql

\echo '[1;m[1;m'
 
 select '   [FINISH]       '|| to_char(clock_timestamp(), 'dd.mm.yyyy hh24:mi:ss');
 \echo '[---------------------------------------------------------------------------------------------------------------]'
 select '[---------------------------------------------------------------------------------------------------------------]';
 select :total_blocks_install + 1 as total_blocks_install \gset
-----------------------------------------------/FILE/-------------------------------------------------------------
--
------------------------------------------------FILE--------------------------------------------------------------
 --{TMPL.INSTALL.COUNTBLOCK}--
 select round((:total_blocks_install * 100) / :total_blocks) as total_prc \gset
 \echo '[':start_script_time' : POSTGRES : INSTALL         : INF] Completed: ':total_prc'%' 
 select '[' || to_char(clock_timestamp(), 'dd.mm.yyyy hh24:mi:ss') || ' : ' || 'POSTGRES' || ' : ' || rpad('INSTALL', 15) || ' : ' || 'INF] Completed: '||:total_prc||'%'; 
 -- Revision: 0d2daf378c396f2abfc8a79ef25bebba7e37eeeb Task:  Date: 14.06.2022 06:42:19 UTC Author: makaenko_aa
 \echo '[---------------------------------------------------------------------------------------------------------------]'
 select '[---------------------------------------------------------------------------------------------------------------]';
 \echo ' install/install/tables/sys_registry_data_tbl.sql'
 select ' install/install/tables/sys_registry_data_tbl.sql';
 select '   [REVISION]   0d2daf378c396f2abfc8a79ef25bebba7e37eeeb';
 select '   [TASK]         ';
 select '   [DATE]         14.06.2022 06:42:19 UTC';
 select '   [AUTHOR]       makaenko_aa';
 select '   [START]        ' || to_char(clock_timestamp(), 'dd.mm.yyyy hh24:mi:ss');

--if error then color red
\echo '[1;31m'

\i install/install/tables/sys_registry_data_tbl.sql

\echo '[1;m[1;m'
 
 select '   [FINISH]       '|| to_char(clock_timestamp(), 'dd.mm.yyyy hh24:mi:ss');
 \echo '[---------------------------------------------------------------------------------------------------------------]'
 select '[---------------------------------------------------------------------------------------------------------------]';
 select :total_blocks_install + 1 as total_blocks_install \gset
-----------------------------------------------/FILE/-------------------------------------------------------------
--
------------------------------------------------FILE--------------------------------------------------------------
 --{TMPL.INSTALL.COUNTBLOCK}--
 select round((:total_blocks_install * 100) / :total_blocks) as total_prc \gset
 \echo '[':start_script_time' : POSTGRES : INSTALL         : INF] Completed: ':total_prc'%' 
 select '[' || to_char(clock_timestamp(), 'dd.mm.yyyy hh24:mi:ss') || ' : ' || 'POSTGRES' || ' : ' || rpad('INSTALL', 15) || ' : ' || 'INF] Completed: '||:total_prc||'%'; 
 -- Revision: 0d2daf378c396f2abfc8a79ef25bebba7e37eeeb Task:  Date: 14.06.2022 06:42:19 UTC Author: makaenko_aa
 \echo '[---------------------------------------------------------------------------------------------------------------]'
 select '[---------------------------------------------------------------------------------------------------------------]';
 \echo ' install/install/tables/sys_registry_settings_tbl.sql'
 select ' install/install/tables/sys_registry_settings_tbl.sql';
 select '   [REVISION]   0d2daf378c396f2abfc8a79ef25bebba7e37eeeb';
 select '   [TASK]         ';
 select '   [DATE]         14.06.2022 06:42:19 UTC';
 select '   [AUTHOR]       makaenko_aa';
 select '   [START]        ' || to_char(clock_timestamp(), 'dd.mm.yyyy hh24:mi:ss');

--if error then color red
\echo '[1;31m'

\i install/install/tables/sys_registry_settings_tbl.sql

\echo '[1;m[1;m'
 
 select '   [FINISH]       '|| to_char(clock_timestamp(), 'dd.mm.yyyy hh24:mi:ss');
 \echo '[---------------------------------------------------------------------------------------------------------------]'
 select '[---------------------------------------------------------------------------------------------------------------]';
 select :total_blocks_install + 1 as total_blocks_install \gset
-----------------------------------------------/FILE/-------------------------------------------------------------
--
------------------------------------------------FILE--------------------------------------------------------------
 --{TMPL.INSTALL.COUNTBLOCK}--
 select round((:total_blocks_install * 100) / :total_blocks) as total_prc \gset
 \echo '[':start_script_time' : POSTGRES : INSTALL         : INF] Completed: ':total_prc'%' 
 select '[' || to_char(clock_timestamp(), 'dd.mm.yyyy hh24:mi:ss') || ' : ' || 'POSTGRES' || ' : ' || rpad('INSTALL', 15) || ' : ' || 'INF] Completed: '||:total_prc||'%'; 
 -- Revision: d8a2ee5db9c9c37b254cf3acac08e019e69156c7 Task:  Date: 02.06.2022 12:55:41 UTC Author: makaenko_aa
 \echo '[---------------------------------------------------------------------------------------------------------------]'
 select '[---------------------------------------------------------------------------------------------------------------]';
 \echo ' install/install/views/fk_no_index_vw.sql'
 select ' install/install/views/fk_no_index_vw.sql';
 select '   [REVISION]   d8a2ee5db9c9c37b254cf3acac08e019e69156c7';
 select '   [TASK]         ';
 select '   [DATE]         02.06.2022 12:55:41 UTC';
 select '   [AUTHOR]       makaenko_aa';
 select '   [START]        ' || to_char(clock_timestamp(), 'dd.mm.yyyy hh24:mi:ss');

--if error then color red
\echo '[1;31m'

\i install/install/views/fk_no_index_vw.sql

\echo '[1;m[1;m'
 
 select '   [FINISH]       '|| to_char(clock_timestamp(), 'dd.mm.yyyy hh24:mi:ss');
 \echo '[---------------------------------------------------------------------------------------------------------------]'
 select '[---------------------------------------------------------------------------------------------------------------]';
 select :total_blocks_install + 1 as total_blocks_install \gset
-----------------------------------------------/FILE/-------------------------------------------------------------
--
------------------------------------------------FILE--------------------------------------------------------------
 --{TMPL.INSTALL.COUNTBLOCK}--
 select round((:total_blocks_install * 100) / :total_blocks) as total_prc \gset
 \echo '[':start_script_time' : POSTGRES : INSTALL         : INF] Completed: ':total_prc'%' 
 select '[' || to_char(clock_timestamp(), 'dd.mm.yyyy hh24:mi:ss') || ' : ' || 'POSTGRES' || ' : ' || rpad('INSTALL', 15) || ' : ' || 'INF] Completed: '||:total_prc||'%'; 
 -- Revision: 0112239933de6e32375719c96ff6098b00b12598 Task:  Date: 20.05.2022 12:38:28 UTC Author: makaenko_aa
 \echo '[---------------------------------------------------------------------------------------------------------------]'
 select '[---------------------------------------------------------------------------------------------------------------]';
 \echo ' install/install/views/sys_registry_data.sql'
 select ' install/install/views/sys_registry_data.sql';
 select '   [REVISION]   0112239933de6e32375719c96ff6098b00b12598';
 select '   [TASK]         ';
 select '   [DATE]         20.05.2022 12:38:28 UTC';
 select '   [AUTHOR]       makaenko_aa';
 select '   [START]        ' || to_char(clock_timestamp(), 'dd.mm.yyyy hh24:mi:ss');

--if error then color red
\echo '[1;31m'

\i install/install/views/sys_registry_data.sql

\echo '[1;m[1;m'
 
 select '   [FINISH]       '|| to_char(clock_timestamp(), 'dd.mm.yyyy hh24:mi:ss');
 \echo '[---------------------------------------------------------------------------------------------------------------]'
 select '[---------------------------------------------------------------------------------------------------------------]';
 select :total_blocks_install + 1 as total_blocks_install \gset
-----------------------------------------------/FILE/-------------------------------------------------------------
--
------------------------------------------------FILE--------------------------------------------------------------
 --{TMPL.INSTALL.COUNTBLOCK}--
 select round((:total_blocks_install * 100) / :total_blocks) as total_prc \gset
 \echo '[':start_script_time' : POSTGRES : INSTALL         : INF] Completed: ':total_prc'%' 
 select '[' || to_char(clock_timestamp(), 'dd.mm.yyyy hh24:mi:ss') || ' : ' || 'POSTGRES' || ' : ' || rpad('INSTALL', 15) || ' : ' || 'INF] Completed: '||:total_prc||'%'; 
 -- Revision: 0d2daf378c396f2abfc8a79ef25bebba7e37eeeb Task:  Date: 14.06.2022 06:42:19 UTC Author: makaenko_aa
 \echo '[---------------------------------------------------------------------------------------------------------------]'
 select '[---------------------------------------------------------------------------------------------------------------]';
 \echo ' install/install/views/wrong_encod_obj_lines_vw.sql'
 select ' install/install/views/wrong_encod_obj_lines_vw.sql';
 select '   [REVISION]   0d2daf378c396f2abfc8a79ef25bebba7e37eeeb';
 select '   [TASK]         ';
 select '   [DATE]         14.06.2022 06:42:19 UTC';
 select '   [AUTHOR]       makaenko_aa';
 select '   [START]        ' || to_char(clock_timestamp(), 'dd.mm.yyyy hh24:mi:ss');

--if error then color red
\echo '[1;31m'

\i install/install/views/wrong_encod_obj_lines_vw.sql

\echo '[1;m[1;m'
 
 select '   [FINISH]       '|| to_char(clock_timestamp(), 'dd.mm.yyyy hh24:mi:ss');
 \echo '[---------------------------------------------------------------------------------------------------------------]'
 select '[---------------------------------------------------------------------------------------------------------------]';
 select :total_blocks_install + 1 as total_blocks_install \gset
-----------------------------------------------/FILE/-------------------------------------------------------------
--
------------------------------------------------FILE--------------------------------------------------------------
 --{TMPL.INSTALL.COUNTBLOCK}--
 select round((:total_blocks_install * 100) / :total_blocks) as total_prc \gset
 \echo '[':start_script_time' : POSTGRES : INSTALL         : INF] Completed: ':total_prc'%' 
 select '[' || to_char(clock_timestamp(), 'dd.mm.yyyy hh24:mi:ss') || ' : ' || 'POSTGRES' || ' : ' || rpad('INSTALL', 15) || ' : ' || 'INF] Completed: '||:total_prc||'%'; 
 -- Revision: 0d2daf378c396f2abfc8a79ef25bebba7e37eeeb Task:  Date: 14.06.2022 06:42:19 UTC Author: makaenko_aa
 \echo '[---------------------------------------------------------------------------------------------------------------]'
 select '[---------------------------------------------------------------------------------------------------------------]';
 \echo ' install/install/views/wrong_encod_obj_vw.sql'
 select ' install/install/views/wrong_encod_obj_vw.sql';
 select '   [REVISION]   0d2daf378c396f2abfc8a79ef25bebba7e37eeeb';
 select '   [TASK]         ';
 select '   [DATE]         14.06.2022 06:42:19 UTC';
 select '   [AUTHOR]       makaenko_aa';
 select '   [START]        ' || to_char(clock_timestamp(), 'dd.mm.yyyy hh24:mi:ss');

--if error then color red
\echo '[1;31m'

\i install/install/views/wrong_encod_obj_vw.sql

\echo '[1;m[1;m'
 
 select '   [FINISH]       '|| to_char(clock_timestamp(), 'dd.mm.yyyy hh24:mi:ss');
 \echo '[---------------------------------------------------------------------------------------------------------------]'
 select '[---------------------------------------------------------------------------------------------------------------]';
 select :total_blocks_install + 1 as total_blocks_install \gset
-----------------------------------------------/FILE/-------------------------------------------------------------
--
------------------------------------------------FILE--------------------------------------------------------------
 --{TMPL.INSTALL.COUNTBLOCK}--
 select round((:total_blocks_install * 100) / :total_blocks) as total_prc \gset
 \echo '[':start_script_time' : POSTGRES : INSTALL         : INF] Completed: ':total_prc'%' 
 select '[' || to_char(clock_timestamp(), 'dd.mm.yyyy hh24:mi:ss') || ' : ' || 'POSTGRES' || ' : ' || rpad('INSTALL', 15) || ' : ' || 'INF] Completed: '||:total_prc||'%'; 
 -- Revision: 0112239933de6e32375719c96ff6098b00b12598 Task:  Date: 20.05.2022 12:38:28 UTC Author: makaenko_aa
 \echo '[---------------------------------------------------------------------------------------------------------------]'
 select '[---------------------------------------------------------------------------------------------------------------]';
 \echo ' install/install/functions/01_get_color_start.sql'
 select ' install/install/functions/01_get_color_start.sql';
 select '   [REVISION]   0112239933de6e32375719c96ff6098b00b12598';
 select '   [TASK]         ';
 select '   [DATE]         20.05.2022 12:38:28 UTC';
 select '   [AUTHOR]       makaenko_aa';
 select '   [START]        ' || to_char(clock_timestamp(), 'dd.mm.yyyy hh24:mi:ss');

--if error then color red
\echo '[1;31m'

\i install/install/functions/01_get_color_start.sql

\echo '[1;m[1;m'
 
 select '   [FINISH]       '|| to_char(clock_timestamp(), 'dd.mm.yyyy hh24:mi:ss');
 \echo '[---------------------------------------------------------------------------------------------------------------]'
 select '[---------------------------------------------------------------------------------------------------------------]';
 select :total_blocks_install + 1 as total_blocks_install \gset
-----------------------------------------------/FILE/-------------------------------------------------------------
--
------------------------------------------------FILE--------------------------------------------------------------
 --{TMPL.INSTALL.COUNTBLOCK}--
 select round((:total_blocks_install * 100) / :total_blocks) as total_prc \gset
 \echo '[':start_script_time' : POSTGRES : INSTALL         : INF] Completed: ':total_prc'%' 
 select '[' || to_char(clock_timestamp(), 'dd.mm.yyyy hh24:mi:ss') || ' : ' || 'POSTGRES' || ' : ' || rpad('INSTALL', 15) || ' : ' || 'INF] Completed: '||:total_prc||'%'; 
 -- Revision: 1dfd7c5f14ec2d8df3a22ce35d5a1978a496ef32 Task:  Date: 29.07.2022 05:59:49 UTC Author: makaenko_aa
 \echo '[---------------------------------------------------------------------------------------------------------------]'
 select '[---------------------------------------------------------------------------------------------------------------]';
 \echo ' install/install/functions/03_get_color_end.sql'
 select ' install/install/functions/03_get_color_end.sql';
 select '   [REVISION]   1dfd7c5f14ec2d8df3a22ce35d5a1978a496ef32';
 select '   [TASK]         ';
 select '   [DATE]         29.07.2022 05:59:49 UTC';
 select '   [AUTHOR]       makaenko_aa';
 select '   [START]        ' || to_char(clock_timestamp(), 'dd.mm.yyyy hh24:mi:ss');

--if error then color red
\echo '[1;31m'

\i install/install/functions/03_get_color_end.sql

\echo '[1;m[1;m'
 
 select '   [FINISH]       '|| to_char(clock_timestamp(), 'dd.mm.yyyy hh24:mi:ss');
 \echo '[---------------------------------------------------------------------------------------------------------------]'
 select '[---------------------------------------------------------------------------------------------------------------]';
 select :total_blocks_install + 1 as total_blocks_install \gset
-----------------------------------------------/FILE/-------------------------------------------------------------
--
------------------------------------------------FILE--------------------------------------------------------------
 --{TMPL.INSTALL.COUNTBLOCK}--
 select round((:total_blocks_install * 100) / :total_blocks) as total_prc \gset
 \echo '[':start_script_time' : POSTGRES : INSTALL         : INF] Completed: ':total_prc'%' 
 select '[' || to_char(clock_timestamp(), 'dd.mm.yyyy hh24:mi:ss') || ' : ' || 'POSTGRES' || ' : ' || rpad('INSTALL', 15) || ' : ' || 'INF] Completed: '||:total_prc||'%'; 
 -- Revision: 0d2daf378c396f2abfc8a79ef25bebba7e37eeeb Task:  Date: 14.06.2022 06:42:19 UTC Author: makaenko_aa
 \echo '[---------------------------------------------------------------------------------------------------------------]'
 select '[---------------------------------------------------------------------------------------------------------------]';
 \echo ' install/install/functions/05_set_color_text.sql'
 select ' install/install/functions/05_set_color_text.sql';
 select '   [REVISION]   0d2daf378c396f2abfc8a79ef25bebba7e37eeeb';
 select '   [TASK]         ';
 select '   [DATE]         14.06.2022 06:42:19 UTC';
 select '   [AUTHOR]       makaenko_aa';
 select '   [START]        ' || to_char(clock_timestamp(), 'dd.mm.yyyy hh24:mi:ss');

--if error then color red
\echo '[1;31m'

\i install/install/functions/05_set_color_text.sql

\echo '[1;m[1;m'
 
 select '   [FINISH]       '|| to_char(clock_timestamp(), 'dd.mm.yyyy hh24:mi:ss');
 \echo '[---------------------------------------------------------------------------------------------------------------]'
 select '[---------------------------------------------------------------------------------------------------------------]';
 select :total_blocks_install + 1 as total_blocks_install \gset
-----------------------------------------------/FILE/-------------------------------------------------------------
--
------------------------------------------------FILE--------------------------------------------------------------
 --{TMPL.INSTALL.COUNTBLOCK}--
 select round((:total_blocks_install * 100) / :total_blocks) as total_prc \gset
 \echo '[':start_script_time' : POSTGRES : INSTALL         : INF] Completed: ':total_prc'%' 
 select '[' || to_char(clock_timestamp(), 'dd.mm.yyyy hh24:mi:ss') || ' : ' || 'POSTGRES' || ' : ' || rpad('INSTALL', 15) || ' : ' || 'INF] Completed: '||:total_prc||'%'; 
 -- Revision: 0112239933de6e32375719c96ff6098b00b12598 Task:  Date: 20.05.2022 12:38:28 UTC Author: makaenko_aa
 \echo '[---------------------------------------------------------------------------------------------------------------]'
 select '[---------------------------------------------------------------------------------------------------------------]';
 \echo ' install/install/functions/07_write_log.sql'
 select ' install/install/functions/07_write_log.sql';
 select '   [REVISION]   0112239933de6e32375719c96ff6098b00b12598';
 select '   [TASK]         ';
 select '   [DATE]         20.05.2022 12:38:28 UTC';
 select '   [AUTHOR]       makaenko_aa';
 select '   [START]        ' || to_char(clock_timestamp(), 'dd.mm.yyyy hh24:mi:ss');

--if error then color red
\echo '[1;31m'

\i install/install/functions/07_write_log.sql

\echo '[1;m[1;m'
 
 select '   [FINISH]       '|| to_char(clock_timestamp(), 'dd.mm.yyyy hh24:mi:ss');
 \echo '[---------------------------------------------------------------------------------------------------------------]'
 select '[---------------------------------------------------------------------------------------------------------------]';
 select :total_blocks_install + 1 as total_blocks_install \gset
-----------------------------------------------/FILE/-------------------------------------------------------------
--
------------------------------------------------FILE--------------------------------------------------------------
 --{TMPL.INSTALL.COUNTBLOCK}--
 select round((:total_blocks_install * 100) / :total_blocks) as total_prc \gset
 \echo '[':start_script_time' : POSTGRES : INSTALL         : INF] Completed: ':total_prc'%' 
 select '[' || to_char(clock_timestamp(), 'dd.mm.yyyy hh24:mi:ss') || ' : ' || 'POSTGRES' || ' : ' || rpad('INSTALL', 15) || ' : ' || 'INF] Completed: '||:total_prc||'%'; 
 -- Revision: 0d2daf378c396f2abfc8a79ef25bebba7e37eeeb Task:  Date: 14.06.2022 06:42:19 UTC Author: makaenko_aa
 \echo '[---------------------------------------------------------------------------------------------------------------]'
 select '[---------------------------------------------------------------------------------------------------------------]';
 \echo ' install/install/functions/09_write_log_color.sql'
 select ' install/install/functions/09_write_log_color.sql';
 select '   [REVISION]   0d2daf378c396f2abfc8a79ef25bebba7e37eeeb';
 select '   [TASK]         ';
 select '   [DATE]         14.06.2022 06:42:19 UTC';
 select '   [AUTHOR]       makaenko_aa';
 select '   [START]        ' || to_char(clock_timestamp(), 'dd.mm.yyyy hh24:mi:ss');

--if error then color red
\echo '[1;31m'

\i install/install/functions/09_write_log_color.sql

\echo '[1;m[1;m'
 
 select '   [FINISH]       '|| to_char(clock_timestamp(), 'dd.mm.yyyy hh24:mi:ss');
 \echo '[---------------------------------------------------------------------------------------------------------------]'
 select '[---------------------------------------------------------------------------------------------------------------]';
 select :total_blocks_install + 1 as total_blocks_install \gset
-----------------------------------------------/FILE/-------------------------------------------------------------
--
------------------------------------------------FILE--------------------------------------------------------------
 --{TMPL.INSTALL.COUNTBLOCK}--
 select round((:total_blocks_install * 100) / :total_blocks) as total_prc \gset
 \echo '[':start_script_time' : POSTGRES : INSTALL         : INF] Completed: ':total_prc'%' 
 select '[' || to_char(clock_timestamp(), 'dd.mm.yyyy hh24:mi:ss') || ' : ' || 'POSTGRES' || ' : ' || rpad('INSTALL', 15) || ' : ' || 'INF] Completed: '||:total_prc||'%'; 
 -- Revision: 0112239933de6e32375719c96ff6098b00b12598 Task:  Date: 20.05.2022 12:38:28 UTC Author: makaenko_aa
 \echo '[---------------------------------------------------------------------------------------------------------------]'
 select '[---------------------------------------------------------------------------------------------------------------]';
 \echo ' install/install/functions/11_write_log_txt.sql'
 select ' install/install/functions/11_write_log_txt.sql';
 select '   [REVISION]   0112239933de6e32375719c96ff6098b00b12598';
 select '   [TASK]         ';
 select '   [DATE]         20.05.2022 12:38:28 UTC';
 select '   [AUTHOR]       makaenko_aa';
 select '   [START]        ' || to_char(clock_timestamp(), 'dd.mm.yyyy hh24:mi:ss');

--if error then color red
\echo '[1;31m'

\i install/install/functions/11_write_log_txt.sql

\echo '[1;m[1;m'
 
 select '   [FINISH]       '|| to_char(clock_timestamp(), 'dd.mm.yyyy hh24:mi:ss');
 \echo '[---------------------------------------------------------------------------------------------------------------]'
 select '[---------------------------------------------------------------------------------------------------------------]';
 select :total_blocks_install + 1 as total_blocks_install \gset
-----------------------------------------------/FILE/-------------------------------------------------------------
--
------------------------------------------------FILE--------------------------------------------------------------
 --{TMPL.INSTALL.COUNTBLOCK}--
 select round((:total_blocks_install * 100) / :total_blocks) as total_prc \gset
 \echo '[':start_script_time' : POSTGRES : INSTALL         : INF] Completed: ':total_prc'%' 
 select '[' || to_char(clock_timestamp(), 'dd.mm.yyyy hh24:mi:ss') || ' : ' || 'POSTGRES' || ' : ' || rpad('INSTALL', 15) || ' : ' || 'INF] Completed: '||:total_prc||'%'; 
 -- Revision: 0112239933de6e32375719c96ff6098b00b12598 Task:  Date: 20.05.2022 12:38:28 UTC Author: makaenko_aa
 \echo '[---------------------------------------------------------------------------------------------------------------]'
 select '[---------------------------------------------------------------------------------------------------------------]';
 \echo ' install/install/functions/13_write_log_sep.sql'
 select ' install/install/functions/13_write_log_sep.sql';
 select '   [REVISION]   0112239933de6e32375719c96ff6098b00b12598';
 select '   [TASK]         ';
 select '   [DATE]         20.05.2022 12:38:28 UTC';
 select '   [AUTHOR]       makaenko_aa';
 select '   [START]        ' || to_char(clock_timestamp(), 'dd.mm.yyyy hh24:mi:ss');

--if error then color red
\echo '[1;31m'

\i install/install/functions/13_write_log_sep.sql

\echo '[1;m[1;m'
 
 select '   [FINISH]       '|| to_char(clock_timestamp(), 'dd.mm.yyyy hh24:mi:ss');
 \echo '[---------------------------------------------------------------------------------------------------------------]'
 select '[---------------------------------------------------------------------------------------------------------------]';
 select :total_blocks_install + 1 as total_blocks_install \gset
-----------------------------------------------/FILE/-------------------------------------------------------------
--
------------------------------------------------FILE--------------------------------------------------------------
 --{TMPL.INSTALL.COUNTBLOCK}--
 select round((:total_blocks_install * 100) / :total_blocks) as total_prc \gset
 \echo '[':start_script_time' : POSTGRES : INSTALL         : INF] Completed: ':total_prc'%' 
 select '[' || to_char(clock_timestamp(), 'dd.mm.yyyy hh24:mi:ss') || ' : ' || 'POSTGRES' || ' : ' || rpad('INSTALL', 15) || ' : ' || 'INF] Completed: '||:total_prc||'%'; 
 -- Revision: 0112239933de6e32375719c96ff6098b00b12598 Task:  Date: 20.05.2022 12:38:28 UTC Author: makaenko_aa
 \echo '[---------------------------------------------------------------------------------------------------------------]'
 select '[---------------------------------------------------------------------------------------------------------------]';
 \echo ' install/install/functions/15_write_log_inf.sql'
 select ' install/install/functions/15_write_log_inf.sql';
 select '   [REVISION]   0112239933de6e32375719c96ff6098b00b12598';
 select '   [TASK]         ';
 select '   [DATE]         20.05.2022 12:38:28 UTC';
 select '   [AUTHOR]       makaenko_aa';
 select '   [START]        ' || to_char(clock_timestamp(), 'dd.mm.yyyy hh24:mi:ss');

--if error then color red
\echo '[1;31m'

\i install/install/functions/15_write_log_inf.sql

\echo '[1;m[1;m'
 
 select '   [FINISH]       '|| to_char(clock_timestamp(), 'dd.mm.yyyy hh24:mi:ss');
 \echo '[---------------------------------------------------------------------------------------------------------------]'
 select '[---------------------------------------------------------------------------------------------------------------]';
 select :total_blocks_install + 1 as total_blocks_install \gset
-----------------------------------------------/FILE/-------------------------------------------------------------
--
------------------------------------------------FILE--------------------------------------------------------------
 --{TMPL.INSTALL.COUNTBLOCK}--
 select round((:total_blocks_install * 100) / :total_blocks) as total_prc \gset
 \echo '[':start_script_time' : POSTGRES : INSTALL         : INF] Completed: ':total_prc'%' 
 select '[' || to_char(clock_timestamp(), 'dd.mm.yyyy hh24:mi:ss') || ' : ' || 'POSTGRES' || ' : ' || rpad('INSTALL', 15) || ' : ' || 'INF] Completed: '||:total_prc||'%'; 
 -- Revision: 0112239933de6e32375719c96ff6098b00b12598 Task:  Date: 20.05.2022 12:38:28 UTC Author: makaenko_aa
 \echo '[---------------------------------------------------------------------------------------------------------------]'
 select '[---------------------------------------------------------------------------------------------------------------]';
 \echo ' install/install/functions/17_write_log_wrn.sql'
 select ' install/install/functions/17_write_log_wrn.sql';
 select '   [REVISION]   0112239933de6e32375719c96ff6098b00b12598';
 select '   [TASK]         ';
 select '   [DATE]         20.05.2022 12:38:28 UTC';
 select '   [AUTHOR]       makaenko_aa';
 select '   [START]        ' || to_char(clock_timestamp(), 'dd.mm.yyyy hh24:mi:ss');

--if error then color red
\echo '[1;31m'

\i install/install/functions/17_write_log_wrn.sql

\echo '[1;m[1;m'
 
 select '   [FINISH]       '|| to_char(clock_timestamp(), 'dd.mm.yyyy hh24:mi:ss');
 \echo '[---------------------------------------------------------------------------------------------------------------]'
 select '[---------------------------------------------------------------------------------------------------------------]';
 select :total_blocks_install + 1 as total_blocks_install \gset
-----------------------------------------------/FILE/-------------------------------------------------------------
--
------------------------------------------------FILE--------------------------------------------------------------
 --{TMPL.INSTALL.COUNTBLOCK}--
 select round((:total_blocks_install * 100) / :total_blocks) as total_prc \gset
 \echo '[':start_script_time' : POSTGRES : INSTALL         : INF] Completed: ':total_prc'%' 
 select '[' || to_char(clock_timestamp(), 'dd.mm.yyyy hh24:mi:ss') || ' : ' || 'POSTGRES' || ' : ' || rpad('INSTALL', 15) || ' : ' || 'INF] Completed: '||:total_prc||'%'; 
 -- Revision: 0112239933de6e32375719c96ff6098b00b12598 Task:  Date: 20.05.2022 12:38:28 UTC Author: makaenko_aa
 \echo '[---------------------------------------------------------------------------------------------------------------]'
 select '[---------------------------------------------------------------------------------------------------------------]';
 \echo ' install/install/functions/19_write_log_err.sql'
 select ' install/install/functions/19_write_log_err.sql';
 select '   [REVISION]   0112239933de6e32375719c96ff6098b00b12598';
 select '   [TASK]         ';
 select '   [DATE]         20.05.2022 12:38:28 UTC';
 select '   [AUTHOR]       makaenko_aa';
 select '   [START]        ' || to_char(clock_timestamp(), 'dd.mm.yyyy hh24:mi:ss');

--if error then color red
\echo '[1;31m'

\i install/install/functions/19_write_log_err.sql

\echo '[1;m[1;m'
 
 select '   [FINISH]       '|| to_char(clock_timestamp(), 'dd.mm.yyyy hh24:mi:ss');
 \echo '[---------------------------------------------------------------------------------------------------------------]'
 select '[---------------------------------------------------------------------------------------------------------------]';
 select :total_blocks_install + 1 as total_blocks_install \gset
-----------------------------------------------/FILE/-------------------------------------------------------------
--
------------------------------------------------FILE--------------------------------------------------------------
 --{TMPL.INSTALL.COUNTBLOCK}--
 select round((:total_blocks_install * 100) / :total_blocks) as total_prc \gset
 \echo '[':start_script_time' : POSTGRES : INSTALL         : INF] Completed: ':total_prc'%' 
 select '[' || to_char(clock_timestamp(), 'dd.mm.yyyy hh24:mi:ss') || ' : ' || 'POSTGRES' || ' : ' || rpad('INSTALL', 15) || ' : ' || 'INF] Completed: '||:total_prc||'%'; 
 -- Revision: 0112239933de6e32375719c96ff6098b00b12598 Task:  Date: 20.05.2022 12:38:28 UTC Author: makaenko_aa
 \echo '[---------------------------------------------------------------------------------------------------------------]'
 select '[---------------------------------------------------------------------------------------------------------------]';
 \echo ' install/install/functions/21_write_log_trc.sql'
 select ' install/install/functions/21_write_log_trc.sql';
 select '   [REVISION]   0112239933de6e32375719c96ff6098b00b12598';
 select '   [TASK]         ';
 select '   [DATE]         20.05.2022 12:38:28 UTC';
 select '   [AUTHOR]       makaenko_aa';
 select '   [START]        ' || to_char(clock_timestamp(), 'dd.mm.yyyy hh24:mi:ss');

--if error then color red
\echo '[1;31m'

\i install/install/functions/21_write_log_trc.sql

\echo '[1;m[1;m'
 
 select '   [FINISH]       '|| to_char(clock_timestamp(), 'dd.mm.yyyy hh24:mi:ss');
 \echo '[---------------------------------------------------------------------------------------------------------------]'
 select '[---------------------------------------------------------------------------------------------------------------]';
 select :total_blocks_install + 1 as total_blocks_install \gset
-----------------------------------------------/FILE/-------------------------------------------------------------
--
------------------------------------------------FILE--------------------------------------------------------------
 --{TMPL.INSTALL.COUNTBLOCK}--
 select round((:total_blocks_install * 100) / :total_blocks) as total_prc \gset
 \echo '[':start_script_time' : POSTGRES : INSTALL         : INF] Completed: ':total_prc'%' 
 select '[' || to_char(clock_timestamp(), 'dd.mm.yyyy hh24:mi:ss') || ' : ' || 'POSTGRES' || ' : ' || rpad('INSTALL', 15) || ' : ' || 'INF] Completed: '||:total_prc||'%'; 
 -- Revision: 0112239933de6e32375719c96ff6098b00b12598 Task:  Date: 20.05.2022 12:38:28 UTC Author: makaenko_aa
 \echo '[---------------------------------------------------------------------------------------------------------------]'
 select '[---------------------------------------------------------------------------------------------------------------]';
 \echo ' install/install/functions/23_get_version.sql'
 select ' install/install/functions/23_get_version.sql';
 select '   [REVISION]   0112239933de6e32375719c96ff6098b00b12598';
 select '   [TASK]         ';
 select '   [DATE]         20.05.2022 12:38:28 UTC';
 select '   [AUTHOR]       makaenko_aa';
 select '   [START]        ' || to_char(clock_timestamp(), 'dd.mm.yyyy hh24:mi:ss');

--if error then color red
\echo '[1;31m'

\i install/install/functions/23_get_version.sql

\echo '[1;m[1;m'
 
 select '   [FINISH]       '|| to_char(clock_timestamp(), 'dd.mm.yyyy hh24:mi:ss');
 \echo '[---------------------------------------------------------------------------------------------------------------]'
 select '[---------------------------------------------------------------------------------------------------------------]';
 select :total_blocks_install + 1 as total_blocks_install \gset
-----------------------------------------------/FILE/-------------------------------------------------------------
--
------------------------------------------------FILE--------------------------------------------------------------
 --{TMPL.INSTALL.COUNTBLOCK}--
 select round((:total_blocks_install * 100) / :total_blocks) as total_prc \gset
 \echo '[':start_script_time' : POSTGRES : INSTALL         : INF] Completed: ':total_prc'%' 
 select '[' || to_char(clock_timestamp(), 'dd.mm.yyyy hh24:mi:ss') || ' : ' || 'POSTGRES' || ' : ' || rpad('INSTALL', 15) || ' : ' || 'INF] Completed: '||:total_prc||'%'; 
 -- Revision: 0112239933de6e32375719c96ff6098b00b12598 Task:  Date: 20.05.2022 12:38:28 UTC Author: makaenko_aa
 \echo '[---------------------------------------------------------------------------------------------------------------]'
 select '[---------------------------------------------------------------------------------------------------------------]';
 \echo ' install/install/functions/25_init_version_fnc.sql'
 select ' install/install/functions/25_init_version_fnc.sql';
 select '   [REVISION]   0112239933de6e32375719c96ff6098b00b12598';
 select '   [TASK]         ';
 select '   [DATE]         20.05.2022 12:38:28 UTC';
 select '   [AUTHOR]       makaenko_aa';
 select '   [START]        ' || to_char(clock_timestamp(), 'dd.mm.yyyy hh24:mi:ss');

--if error then color red
\echo '[1;31m'

\i install/install/functions/25_init_version_fnc.sql

\echo '[1;m[1;m'
 
 select '   [FINISH]       '|| to_char(clock_timestamp(), 'dd.mm.yyyy hh24:mi:ss');
 \echo '[---------------------------------------------------------------------------------------------------------------]'
 select '[---------------------------------------------------------------------------------------------------------------]';
 select :total_blocks_install + 1 as total_blocks_install \gset
-----------------------------------------------/FILE/-------------------------------------------------------------
--
------------------------------------------------FILE--------------------------------------------------------------
 --{TMPL.INSTALL.COUNTBLOCK}--
 select round((:total_blocks_install * 100) / :total_blocks) as total_prc \gset
 \echo '[':start_script_time' : POSTGRES : INSTALL         : INF] Completed: ':total_prc'%' 
 select '[' || to_char(clock_timestamp(), 'dd.mm.yyyy hh24:mi:ss') || ' : ' || 'POSTGRES' || ' : ' || rpad('INSTALL', 15) || ' : ' || 'INF] Completed: '||:total_prc||'%'; 
 -- Revision: 0d2daf378c396f2abfc8a79ef25bebba7e37eeeb Task:  Date: 14.06.2022 06:42:19 UTC Author: makaenko_aa
 \echo '[---------------------------------------------------------------------------------------------------------------]'
 select '[---------------------------------------------------------------------------------------------------------------]';
 \echo ' install/install/functions/27_check_params_fnc.sql'
 select ' install/install/functions/27_check_params_fnc.sql';
 select '   [REVISION]   0d2daf378c396f2abfc8a79ef25bebba7e37eeeb';
 select '   [TASK]         ';
 select '   [DATE]         14.06.2022 06:42:19 UTC';
 select '   [AUTHOR]       makaenko_aa';
 select '   [START]        ' || to_char(clock_timestamp(), 'dd.mm.yyyy hh24:mi:ss');

--if error then color red
\echo '[1;31m'

\i install/install/functions/27_check_params_fnc.sql

\echo '[1;m[1;m'
 
 select '   [FINISH]       '|| to_char(clock_timestamp(), 'dd.mm.yyyy hh24:mi:ss');
 \echo '[---------------------------------------------------------------------------------------------------------------]'
 select '[---------------------------------------------------------------------------------------------------------------]';
 select :total_blocks_install + 1 as total_blocks_install \gset
-----------------------------------------------/FILE/-------------------------------------------------------------
--
------------------------------------------------FILE--------------------------------------------------------------
 --{TMPL.INSTALL.COUNTBLOCK}--
 select round((:total_blocks_install * 100) / :total_blocks) as total_prc \gset
 \echo '[':start_script_time' : POSTGRES : INSTALL         : INF] Completed: ':total_prc'%' 
 select '[' || to_char(clock_timestamp(), 'dd.mm.yyyy hh24:mi:ss') || ' : ' || 'POSTGRES' || ' : ' || rpad('INSTALL', 15) || ' : ' || 'INF] Completed: '||:total_prc||'%'; 
 -- Revision: 0d2daf378c396f2abfc8a79ef25bebba7e37eeeb Task:  Date: 14.06.2022 06:42:19 UTC Author: makaenko_aa
 \echo '[---------------------------------------------------------------------------------------------------------------]'
 select '[---------------------------------------------------------------------------------------------------------------]';
 \echo ' install/install/functions/29_compare_version_fnc.sql'
 select ' install/install/functions/29_compare_version_fnc.sql';
 select '   [REVISION]   0d2daf378c396f2abfc8a79ef25bebba7e37eeeb';
 select '   [TASK]         ';
 select '   [DATE]         14.06.2022 06:42:19 UTC';
 select '   [AUTHOR]       makaenko_aa';
 select '   [START]        ' || to_char(clock_timestamp(), 'dd.mm.yyyy hh24:mi:ss');

--if error then color red
\echo '[1;31m'

\i install/install/functions/29_compare_version_fnc.sql

\echo '[1;m[1;m'
 
 select '   [FINISH]       '|| to_char(clock_timestamp(), 'dd.mm.yyyy hh24:mi:ss');
 \echo '[---------------------------------------------------------------------------------------------------------------]'
 select '[---------------------------------------------------------------------------------------------------------------]';
 select :total_blocks_install + 1 as total_blocks_install \gset
-----------------------------------------------/FILE/-------------------------------------------------------------
--
------------------------------------------------FILE--------------------------------------------------------------
 --{TMPL.INSTALL.COUNTBLOCK}--
 select round((:total_blocks_install * 100) / :total_blocks) as total_prc \gset
 \echo '[':start_script_time' : POSTGRES : INSTALL         : INF] Completed: ':total_prc'%' 
 select '[' || to_char(clock_timestamp(), 'dd.mm.yyyy hh24:mi:ss') || ' : ' || 'POSTGRES' || ' : ' || rpad('INSTALL', 15) || ' : ' || 'INF] Completed: '||:total_prc||'%'; 
 -- Revision: 0d2daf378c396f2abfc8a79ef25bebba7e37eeeb Task:  Date: 14.06.2022 06:42:19 UTC Author: makaenko_aa
 \echo '[---------------------------------------------------------------------------------------------------------------]'
 select '[---------------------------------------------------------------------------------------------------------------]';
 \echo ' install/install/functions/31_compare_system_fnc.sql'
 select ' install/install/functions/31_compare_system_fnc.sql';
 select '   [REVISION]   0d2daf378c396f2abfc8a79ef25bebba7e37eeeb';
 select '   [TASK]         ';
 select '   [DATE]         14.06.2022 06:42:19 UTC';
 select '   [AUTHOR]       makaenko_aa';
 select '   [START]        ' || to_char(clock_timestamp(), 'dd.mm.yyyy hh24:mi:ss');

--if error then color red
\echo '[1;31m'

\i install/install/functions/31_compare_system_fnc.sql

\echo '[1;m[1;m'
 
 select '   [FINISH]       '|| to_char(clock_timestamp(), 'dd.mm.yyyy hh24:mi:ss');
 \echo '[---------------------------------------------------------------------------------------------------------------]'
 select '[---------------------------------------------------------------------------------------------------------------]';
 select :total_blocks_install + 1 as total_blocks_install \gset
-----------------------------------------------/FILE/-------------------------------------------------------------
--
------------------------------------------------FILE--------------------------------------------------------------
 --{TMPL.INSTALL.COUNTBLOCK}--
 select round((:total_blocks_install * 100) / :total_blocks) as total_prc \gset
 \echo '[':start_script_time' : POSTGRES : INSTALL         : INF] Completed: ':total_prc'%' 
 select '[' || to_char(clock_timestamp(), 'dd.mm.yyyy hh24:mi:ss') || ' : ' || 'POSTGRES' || ' : ' || rpad('INSTALL', 15) || ' : ' || 'INF] Completed: '||:total_prc||'%'; 
 -- Revision: 0d2daf378c396f2abfc8a79ef25bebba7e37eeeb Task:  Date: 14.06.2022 06:42:19 UTC Author: makaenko_aa
 \echo '[---------------------------------------------------------------------------------------------------------------]'
 select '[---------------------------------------------------------------------------------------------------------------]';
 \echo ' install/install/functions/33_logit_fnc.sql'
 select ' install/install/functions/33_logit_fnc.sql';
 select '   [REVISION]   0d2daf378c396f2abfc8a79ef25bebba7e37eeeb';
 select '   [TASK]         ';
 select '   [DATE]         14.06.2022 06:42:19 UTC';
 select '   [AUTHOR]       makaenko_aa';
 select '   [START]        ' || to_char(clock_timestamp(), 'dd.mm.yyyy hh24:mi:ss');

--if error then color red
\echo '[1;31m'

\i install/install/functions/33_logit_fnc.sql

\echo '[1;m[1;m'
 
 select '   [FINISH]       '|| to_char(clock_timestamp(), 'dd.mm.yyyy hh24:mi:ss');
 \echo '[---------------------------------------------------------------------------------------------------------------]'
 select '[---------------------------------------------------------------------------------------------------------------]';
 select :total_blocks_install + 1 as total_blocks_install \gset
-----------------------------------------------/FILE/-------------------------------------------------------------
--
------------------------------------------------FILE--------------------------------------------------------------
 --{TMPL.INSTALL.COUNTBLOCK}--
 select round((:total_blocks_install * 100) / :total_blocks) as total_prc \gset
 \echo '[':start_script_time' : POSTGRES : INSTALL         : INF] Completed: ':total_prc'%' 
 select '[' || to_char(clock_timestamp(), 'dd.mm.yyyy hh24:mi:ss') || ' : ' || 'POSTGRES' || ' : ' || rpad('INSTALL', 15) || ' : ' || 'INF] Completed: '||:total_prc||'%'; 
 -- Revision: 0112239933de6e32375719c96ff6098b00b12598 Task:  Date: 20.05.2022 12:38:28 UTC Author: makaenko_aa
 \echo '[---------------------------------------------------------------------------------------------------------------]'
 select '[---------------------------------------------------------------------------------------------------------------]';
 \echo ' install/install/functions/35_get_system_settings_fnc.sql'
 select ' install/install/functions/35_get_system_settings_fnc.sql';
 select '   [REVISION]   0112239933de6e32375719c96ff6098b00b12598';
 select '   [TASK]         ';
 select '   [DATE]         20.05.2022 12:38:28 UTC';
 select '   [AUTHOR]       makaenko_aa';
 select '   [START]        ' || to_char(clock_timestamp(), 'dd.mm.yyyy hh24:mi:ss');

--if error then color red
\echo '[1;31m'

\i install/install/functions/35_get_system_settings_fnc.sql

\echo '[1;m[1;m'
 
 select '   [FINISH]       '|| to_char(clock_timestamp(), 'dd.mm.yyyy hh24:mi:ss');
 \echo '[---------------------------------------------------------------------------------------------------------------]'
 select '[---------------------------------------------------------------------------------------------------------------]';
 select :total_blocks_install + 1 as total_blocks_install \gset
-----------------------------------------------/FILE/-------------------------------------------------------------
--
------------------------------------------------FILE--------------------------------------------------------------
 --{TMPL.INSTALL.COUNTBLOCK}--
 select round((:total_blocks_install * 100) / :total_blocks) as total_prc \gset
 \echo '[':start_script_time' : POSTGRES : INSTALL         : INF] Completed: ':total_prc'%' 
 select '[' || to_char(clock_timestamp(), 'dd.mm.yyyy hh24:mi:ss') || ' : ' || 'POSTGRES' || ' : ' || rpad('INSTALL', 15) || ' : ' || 'INF] Completed: '||:total_prc||'%'; 
 -- Revision: 0d2daf378c396f2abfc8a79ef25bebba7e37eeeb Task:  Date: 14.06.2022 06:42:19 UTC Author: makaenko_aa
 \echo '[---------------------------------------------------------------------------------------------------------------]'
 select '[---------------------------------------------------------------------------------------------------------------]';
 \echo ' install/install/functions/37_check_system_settings_fnc.sql'
 select ' install/install/functions/37_check_system_settings_fnc.sql';
 select '   [REVISION]   0d2daf378c396f2abfc8a79ef25bebba7e37eeeb';
 select '   [TASK]         ';
 select '   [DATE]         14.06.2022 06:42:19 UTC';
 select '   [AUTHOR]       makaenko_aa';
 select '   [START]        ' || to_char(clock_timestamp(), 'dd.mm.yyyy hh24:mi:ss');

--if error then color red
\echo '[1;31m'

\i install/install/functions/37_check_system_settings_fnc.sql

\echo '[1;m[1;m'
 
 select '   [FINISH]       '|| to_char(clock_timestamp(), 'dd.mm.yyyy hh24:mi:ss');
 \echo '[---------------------------------------------------------------------------------------------------------------]'
 select '[---------------------------------------------------------------------------------------------------------------]';
 select :total_blocks_install + 1 as total_blocks_install \gset
-----------------------------------------------/FILE/-------------------------------------------------------------
--
------------------------------------------------FILE--------------------------------------------------------------
 --{TMPL.INSTALL.COUNTBLOCK}--
 select round((:total_blocks_install * 100) / :total_blocks) as total_prc \gset
 \echo '[':start_script_time' : POSTGRES : INSTALL         : INF] Completed: ':total_prc'%' 
 select '[' || to_char(clock_timestamp(), 'dd.mm.yyyy hh24:mi:ss') || ' : ' || 'POSTGRES' || ' : ' || rpad('INSTALL', 15) || ' : ' || 'INF] Completed: '||:total_prc||'%'; 
 -- Revision: fdc8c7626151ddae26bcc2e2990acc8f386570da Task:  Date: 16.08.2022 07:21:13 UTC Author: makaenko_aa
 \echo '[---------------------------------------------------------------------------------------------------------------]'
 select '[---------------------------------------------------------------------------------------------------------------]';
 \echo ' install/install/functions/39_start_upgrade_system.sql'
 select ' install/install/functions/39_start_upgrade_system.sql';
 select '   [REVISION]   fdc8c7626151ddae26bcc2e2990acc8f386570da';
 select '   [TASK]         ';
 select '   [DATE]         16.08.2022 07:21:13 UTC';
 select '   [AUTHOR]       makaenko_aa';
 select '   [START]        ' || to_char(clock_timestamp(), 'dd.mm.yyyy hh24:mi:ss');

--if error then color red
\echo '[1;31m'

\i install/install/functions/39_start_upgrade_system.sql

\echo '[1;m[1;m'
 
 select '   [FINISH]       '|| to_char(clock_timestamp(), 'dd.mm.yyyy hh24:mi:ss');
 \echo '[---------------------------------------------------------------------------------------------------------------]'
 select '[---------------------------------------------------------------------------------------------------------------]';
 select :total_blocks_install + 1 as total_blocks_install \gset
-----------------------------------------------/FILE/-------------------------------------------------------------
--
------------------------------------------------FILE--------------------------------------------------------------
 --{TMPL.INSTALL.COUNTBLOCK}--
 select round((:total_blocks_install * 100) / :total_blocks) as total_prc \gset
 \echo '[':start_script_time' : POSTGRES : INSTALL         : INF] Completed: ':total_prc'%' 
 select '[' || to_char(clock_timestamp(), 'dd.mm.yyyy hh24:mi:ss') || ' : ' || 'POSTGRES' || ' : ' || rpad('INSTALL', 15) || ' : ' || 'INF] Completed: '||:total_prc||'%'; 
 -- Revision: 0d2daf378c396f2abfc8a79ef25bebba7e37eeeb Task:  Date: 14.06.2022 06:42:19 UTC Author: makaenko_aa
 \echo '[---------------------------------------------------------------------------------------------------------------]'
 select '[---------------------------------------------------------------------------------------------------------------]';
 \echo ' install/install/functions/41_finish_upgrade_system.sql'
 select ' install/install/functions/41_finish_upgrade_system.sql';
 select '   [REVISION]   0d2daf378c396f2abfc8a79ef25bebba7e37eeeb';
 select '   [TASK]         ';
 select '   [DATE]         14.06.2022 06:42:19 UTC';
 select '   [AUTHOR]       makaenko_aa';
 select '   [START]        ' || to_char(clock_timestamp(), 'dd.mm.yyyy hh24:mi:ss');

--if error then color red
\echo '[1;31m'

\i install/install/functions/41_finish_upgrade_system.sql

\echo '[1;m[1;m'
 
 select '   [FINISH]       '|| to_char(clock_timestamp(), 'dd.mm.yyyy hh24:mi:ss');
 \echo '[---------------------------------------------------------------------------------------------------------------]'
 select '[---------------------------------------------------------------------------------------------------------------]';
 select :total_blocks_install + 1 as total_blocks_install \gset
-----------------------------------------------/FILE/-------------------------------------------------------------
--
------------------------------------------------FILE--------------------------------------------------------------
 --{TMPL.INSTALL.COUNTBLOCK}--
 select round((:total_blocks_install * 100) / :total_blocks) as total_prc \gset
 \echo '[':start_script_time' : POSTGRES : INSTALL         : INF] Completed: ':total_prc'%' 
 select '[' || to_char(clock_timestamp(), 'dd.mm.yyyy hh24:mi:ss') || ' : ' || 'POSTGRES' || ' : ' || rpad('INSTALL', 15) || ' : ' || 'INF] Completed: '||:total_prc||'%'; 
 -- Revision: 52f4e9c65c8222a5678eec8606f8ad2d936db0c2 Task:  Date: 26.05.2022 08:12:04 UTC Author: makaenko_aa
 \echo '[---------------------------------------------------------------------------------------------------------------]'
 select '[---------------------------------------------------------------------------------------------------------------]';
 \echo ' install/install/functions/43_show_active_session_fnc.sql'
 select ' install/install/functions/43_show_active_session_fnc.sql';
 select '   [REVISION]   52f4e9c65c8222a5678eec8606f8ad2d936db0c2';
 select '   [TASK]         ';
 select '   [DATE]         26.05.2022 08:12:04 UTC';
 select '   [AUTHOR]       makaenko_aa';
 select '   [START]        ' || to_char(clock_timestamp(), 'dd.mm.yyyy hh24:mi:ss');

--if error then color red
\echo '[1;31m'

\i install/install/functions/43_show_active_session_fnc.sql

\echo '[1;m[1;m'
 
 select '   [FINISH]       '|| to_char(clock_timestamp(), 'dd.mm.yyyy hh24:mi:ss');
 \echo '[---------------------------------------------------------------------------------------------------------------]'
 select '[---------------------------------------------------------------------------------------------------------------]';
 select :total_blocks_install + 1 as total_blocks_install \gset
-----------------------------------------------/FILE/-------------------------------------------------------------
--
------------------------------------------------FILE--------------------------------------------------------------
 --{TMPL.INSTALL.COUNTBLOCK}--
 select round((:total_blocks_install * 100) / :total_blocks) as total_prc \gset
 \echo '[':start_script_time' : POSTGRES : INSTALL         : INF] Completed: ':total_prc'%' 
 select '[' || to_char(clock_timestamp(), 'dd.mm.yyyy hh24:mi:ss') || ' : ' || 'POSTGRES' || ' : ' || rpad('INSTALL', 15) || ' : ' || 'INF] Completed: '||:total_prc||'%'; 
 -- Revision: 6c5347fc0a6767accc2546ae1adfb5c912f03d30 Task:  Date: 07.06.2022 15:30:35 UTC Author: makaenko_aa
 \echo '[---------------------------------------------------------------------------------------------------------------]'
 select '[---------------------------------------------------------------------------------------------------------------]';
 \echo ' install/install/functions/45_check_wrong_encod_obj_fnc.sql'
 select ' install/install/functions/45_check_wrong_encod_obj_fnc.sql';
 select '   [REVISION]   6c5347fc0a6767accc2546ae1adfb5c912f03d30';
 select '   [TASK]         ';
 select '   [DATE]         07.06.2022 15:30:35 UTC';
 select '   [AUTHOR]       makaenko_aa';
 select '   [START]        ' || to_char(clock_timestamp(), 'dd.mm.yyyy hh24:mi:ss');

--if error then color red
\echo '[1;31m'

\i install/install/functions/45_check_wrong_encod_obj_fnc.sql

\echo '[1;m[1;m'
 
 select '   [FINISH]       '|| to_char(clock_timestamp(), 'dd.mm.yyyy hh24:mi:ss');
 \echo '[---------------------------------------------------------------------------------------------------------------]'
 select '[---------------------------------------------------------------------------------------------------------------]';
 select :total_blocks_install + 1 as total_blocks_install \gset
-----------------------------------------------/FILE/-------------------------------------------------------------
--
------------------------------------------------FILE--------------------------------------------------------------
 --{TMPL.INSTALL.COUNTBLOCK}--
 select round((:total_blocks_install * 100) / :total_blocks) as total_prc \gset
 \echo '[':start_script_time' : POSTGRES : INSTALL         : INF] Completed: ':total_prc'%' 
 select '[' || to_char(clock_timestamp(), 'dd.mm.yyyy hh24:mi:ss') || ' : ' || 'POSTGRES' || ' : ' || rpad('INSTALL', 15) || ' : ' || 'INF] Completed: '||:total_prc||'%'; 
 -- Revision: 0d2daf378c396f2abfc8a79ef25bebba7e37eeeb Task:  Date: 14.06.2022 06:42:19 UTC Author: makaenko_aa
 \echo '[---------------------------------------------------------------------------------------------------------------]'
 select '[---------------------------------------------------------------------------------------------------------------]';
 \echo ' install/install/functions/47_log_wrong_encod_obj_fnc.sql'
 select ' install/install/functions/47_log_wrong_encod_obj_fnc.sql';
 select '   [REVISION]   0d2daf378c396f2abfc8a79ef25bebba7e37eeeb';
 select '   [TASK]         ';
 select '   [DATE]         14.06.2022 06:42:19 UTC';
 select '   [AUTHOR]       makaenko_aa';
 select '   [START]        ' || to_char(clock_timestamp(), 'dd.mm.yyyy hh24:mi:ss');

--if error then color red
\echo '[1;31m'

\i install/install/functions/47_log_wrong_encod_obj_fnc.sql

\echo '[1;m[1;m'
 
 select '   [FINISH]       '|| to_char(clock_timestamp(), 'dd.mm.yyyy hh24:mi:ss');
 \echo '[---------------------------------------------------------------------------------------------------------------]'
 select '[---------------------------------------------------------------------------------------------------------------]';
 select :total_blocks_install + 1 as total_blocks_install \gset
-----------------------------------------------/FILE/-------------------------------------------------------------
--
------------------------------------------------FILE--------------------------------------------------------------
 --{TMPL.INSTALL.COUNTBLOCK}--
 select round((:total_blocks_install * 100) / :total_blocks) as total_prc \gset
 \echo '[':start_script_time' : POSTGRES : INSTALL         : INF] Completed: ':total_prc'%' 
 select '[' || to_char(clock_timestamp(), 'dd.mm.yyyy hh24:mi:ss') || ' : ' || 'POSTGRES' || ' : ' || rpad('INSTALL', 15) || ' : ' || 'INF] Completed: '||:total_prc||'%'; 
 -- Revision: 0d2daf378c396f2abfc8a79ef25bebba7e37eeeb Task:  Date: 14.06.2022 06:42:19 UTC Author: makaenko_aa
 \echo '[---------------------------------------------------------------------------------------------------------------]'
 select '[---------------------------------------------------------------------------------------------------------------]';
 \echo ' install/install/functions/49_log_fk_no_indx_fnc.sql'
 select ' install/install/functions/49_log_fk_no_indx_fnc.sql';
 select '   [REVISION]   0d2daf378c396f2abfc8a79ef25bebba7e37eeeb';
 select '   [TASK]         ';
 select '   [DATE]         14.06.2022 06:42:19 UTC';
 select '   [AUTHOR]       makaenko_aa';
 select '   [START]        ' || to_char(clock_timestamp(), 'dd.mm.yyyy hh24:mi:ss');

--if error then color red
\echo '[1;31m'

\i install/install/functions/49_log_fk_no_indx_fnc.sql

\echo '[1;m[1;m'
 
 select '   [FINISH]       '|| to_char(clock_timestamp(), 'dd.mm.yyyy hh24:mi:ss');
 \echo '[---------------------------------------------------------------------------------------------------------------]'
 select '[---------------------------------------------------------------------------------------------------------------]';
 select :total_blocks_install + 1 as total_blocks_install \gset
-----------------------------------------------/FILE/-------------------------------------------------------------
--
------------------------------------------------FILE--------------------------------------------------------------
 --{TMPL.INSTALL.COUNTBLOCK}--
 select round((:total_blocks_install * 100) / :total_blocks) as total_prc \gset
 \echo '[':start_script_time' : POSTGRES : INSTALL         : INF] Completed: ':total_prc'%' 
 select '[' || to_char(clock_timestamp(), 'dd.mm.yyyy hh24:mi:ss') || ' : ' || 'POSTGRES' || ' : ' || rpad('INSTALL', 15) || ' : ' || 'INF] Completed: '||:total_prc||'%'; 
 -- Revision: 5190e71477fa90db3c77e76e1c089bfb333d385f Task:  Date: 09.06.2022 15:24:32 UTC Author: makaenko_aa
 \echo '[---------------------------------------------------------------------------------------------------------------]'
 select '[---------------------------------------------------------------------------------------------------------------]';
 \echo ' install/install/functions/51_change_owner_for_schema_objects_fnc.sql'
 select ' install/install/functions/51_change_owner_for_schema_objects_fnc.sql';
 select '   [REVISION]   5190e71477fa90db3c77e76e1c089bfb333d385f';
 select '   [TASK]         ';
 select '   [DATE]         09.06.2022 15:24:32 UTC';
 select '   [AUTHOR]       makaenko_aa';
 select '   [START]        ' || to_char(clock_timestamp(), 'dd.mm.yyyy hh24:mi:ss');

--if error then color red
\echo '[1;31m'

\i install/install/functions/51_change_owner_for_schema_objects_fnc.sql

\echo '[1;m[1;m'
 
 select '   [FINISH]       '|| to_char(clock_timestamp(), 'dd.mm.yyyy hh24:mi:ss');
 \echo '[---------------------------------------------------------------------------------------------------------------]'
 select '[---------------------------------------------------------------------------------------------------------------]';
 select :total_blocks_install + 1 as total_blocks_install \gset
-----------------------------------------------/FILE/-------------------------------------------------------------
--

------------------------------------------------------------------------------------------------------------------

--------------------------------------------------------------------------------
------------------------------------------------FILE--------------------------------------------------------------
 --{TMPL.INSTALL.COUNTBLOCK}--
 select round((:total_blocks_install * 100) / :total_blocks) as total_prc \gset
 \echo '[':start_script_time' : POSTGRES : INSTALL         : INF] Completed: ':total_prc'%' 
 select '[' || to_char(clock_timestamp(), 'dd.mm.yyyy hh24:mi:ss') || ' : ' || 'POSTGRES' || ' : ' || rpad('INSTALL', 15) || ' : ' || 'INF] Completed: '||:total_prc||'%'; 
 -- Revision: 1ab8b09fe2205451e7f6caeea17e0a46ecd076bb Task:  Date: 30.05.2022 09:05:10 UTC Author: makaenko_aa
 \echo '[---------------------------------------------------------------------------------------------------------------]'
 select '[---------------------------------------------------------------------------------------------------------------]';
 \echo ' install/install/commands/after/grants.sql'
 select ' install/install/commands/after/grants.sql';
 select '   [REVISION]   1ab8b09fe2205451e7f6caeea17e0a46ecd076bb';
 select '   [TASK]         ';
 select '   [DATE]         30.05.2022 09:05:10 UTC';
 select '   [AUTHOR]       makaenko_aa';
 select '   [START]        ' || to_char(clock_timestamp(), 'dd.mm.yyyy hh24:mi:ss');

--if error then color red
\echo '[1;31m'

\i install/install/commands/after/grants.sql

\echo '[1;m[1;m'
 
 select '   [FINISH]       '|| to_char(clock_timestamp(), 'dd.mm.yyyy hh24:mi:ss');
 \echo '[---------------------------------------------------------------------------------------------------------------]'
 select '[---------------------------------------------------------------------------------------------------------------]';
 select :total_blocks_install + 1 as total_blocks_install \gset
-----------------------------------------------/FILE/-------------------------------------------------------------
--

--------------------------------------------------------------------------------

select install.write_log_txt('[----------------------------------------------Begin upgrade version--------------------------------------------]','yellow');

\set ON_ERROR_STOP on
--Start update subsystem version--
select install.start_upgrade_system(p_system_name  => :system_name,
                                    p_prev_version => :previous_version,
                                    p_new_version  => :new_version,
                                    p_revision     => :new_revision,
                                    p_git_revision => :new_git_revision,
                                    p_url_tbz      => :url_tbz,
                                    p_delivery     => :sppr_delivery_number,
                                    p_check_vers   => :check_vers,
                                    p_update_vers  => :update_vers,
                                    p_is_dc        => 'false');
set role installsys;
------------------------------------------------------------------------------------------------------------------

--Branches information --
select install.write_log_sep('yellow');
select install.write_log_inf('STAT', 'Statistics of the planned changes');
\echo BranchCurrent: release/1.0.2_clear -revision: fdc8c7626151ddae26bcc2e2990acc8f386570da
\echo BranchPrevios: master -revision: 0aed56b09f4397d6a33de3c7dc4e0f9f4743b906
select install.write_log_sep('yellow');
------------------------------------------------------------------------------------------------------------------


--Finish update subsystem version--
select install.finish_upgrade_system(p_system_name  => :system_name,
                                    p_prev_version => :previous_version,
                                    p_new_version  => :new_version,
                                    p_is_dc        => 'false');
reset role;
------------------------------------------------------------------------------------------------------------------
select install.write_log_txt('[----------------------------------------------Finish upgrade version-------------------------------------------]','yellow');

--End installation--
--write to log--
select '[---------------------------------------------------------------------------------------------------------------]';
select '[' || to_char(clock_timestamp(), 'dd.mm.yyyy hh24:mi:ss') ||' : POSTGRES' ||' : '|| rpad('INSTALL', 15) ||' : '||'INF] Start time : ' 
           || :start_script_time_str;
select '[' || to_char(clock_timestamp(), 'dd.mm.yyyy hh24:mi:ss') ||' : POSTGRES' ||' : '|| rpad('INSTALL', 15) ||' : '||'INF] Finish time: ' 
           || to_char(clock_timestamp(), 'dd.mm.yyyy hh24:mi:ss');
select '[' || to_char(clock_timestamp(), 'dd.mm.yyyy hh24:mi:ss') ||' : POSTGRES' ||' : '|| rpad('INSTALL', 15) ||' : '||'INF] Duration (hh:mm:ss.ms): ' 
           || clock_timestamp()::timestamp - to_timestamp(:start_script_time_str, 'dd.mm.yyyy hh24:mi:ss');
select '[' || to_char(clock_timestamp(), 'dd.mm.yyyy hh24:mi:ss') ||' : POSTGRES' ||' : '|| rpad('INSTALL', 15) ||' : '||'INF] Installation is completed';
select '[+-------------------------------------------End installation sql update-----------------------------------------+]';
select '.';
select '.';
------------------------------------------------------------------------------------------------------------------

--End installation--
--show on screen--
select to_char(clock_timestamp(), 'dd.mm.yyyy hh24:mi:ss') as end_script_time \gset
\set end_script_time_str  '\'' :end_script_time '\''
select clock_timestamp()::timestamp - to_timestamp(:start_script_time_str, 'dd.mm.yyyy hh24:mi:ss') as run_duration \gset
\echo '[---------------------------------------------------------------------------------------------------------------]'
\echo '[':end_script_time' : POSTGRES : INSTALL         : INF] Start time : ':start_script_time 
\echo '[':end_script_time' : POSTGRES : INSTALL         : INF] Finish time: ':end_script_time 
\echo '[':end_script_time' : POSTGRES : INSTALL         : INF] Duration (hh:mm:ss.ms): ':run_duration
\echo '[':end_script_time' : POSTGRES : INSTALL         : INF] Installation is completed'
\echo '+-------------------------------------------End installation sql update-----------------------------------------+'
\echo '.'
\echo '.'
------------------------------------------------------------------------------------------------------------------
                                   
\t off
\o
