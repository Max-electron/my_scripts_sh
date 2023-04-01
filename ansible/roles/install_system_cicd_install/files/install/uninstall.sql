\o uninstall_log_1.0.2.lst

\t on
\set ON_ERROR_STOP on
SET client_encoding TO 'UTF8';

--Set Variables--
SET context.COLORED = 1;

\set version_desc          '\'' uninstall_assembly_1.0.2 '\''
\set system_name           '\'' INSTALL '\''
\set previous_version      '\'' 1.0.2 '\''
\set new_version           '\'' 0.0.0 '\''
\set new_revision          '\''  '\''
\set new_git_revision      '\'' 0aed56b09f4397d6a33de3c7dc4e0f9f4743b906 '\''
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
\set total_blocks          '\'' 42 '\''
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

\unset ON_ERROR_STOP

------------------------------------------------------------------------------------------------------------------
------------------------------------------------FILE--------------------------------------------------------------
 --{TMPL.INSTALL.COUNTBLOCK}--
 select round((:total_blocks_install * 100) / :total_blocks) as total_prc \gset
 \echo '[':start_script_time' : POSTGRES : INSTALL         : INF] Completed: ':total_prc'%' 
 select '[' || to_char(clock_timestamp(), 'dd.mm.yyyy hh24:mi:ss') || ' : ' || 'POSTGRES' || ' : ' || rpad('INSTALL', 15) || ' : ' || 'INF] Completed: '||:total_prc||'%'; 

 \echo '[---------------------------------------------------------------------------------------------------------------]'
 select '[---------------------------------------------------------------------------------------------------------------]';
 \echo ' uninstall/install/commands/before/grants.uninstall.sql'
 select ' uninstall/install/commands/before/grants.uninstall.sql';

 select '   [START]        ' || to_char(clock_timestamp(), 'dd.mm.yyyy hh24:mi:ss');

--if error then color red
\echo '[1;31m'

\i uninstall/install/commands/before/grants.uninstall.sql

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

 \echo '[---------------------------------------------------------------------------------------------------------------]'
 select '[---------------------------------------------------------------------------------------------------------------]';
 \echo ' uninstall/install/functions/100_change_owner_for_schema_objects_fnc.uninstall.sql'
 select ' uninstall/install/functions/100_change_owner_for_schema_objects_fnc.uninstall.sql';

 select '   [START]        ' || to_char(clock_timestamp(), 'dd.mm.yyyy hh24:mi:ss');

--if error then color red
\echo '[1;31m'

\i uninstall/install/functions/100_change_owner_for_schema_objects_fnc.uninstall.sql

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

 \echo '[---------------------------------------------------------------------------------------------------------------]'
 select '[---------------------------------------------------------------------------------------------------------------]';
 \echo ' uninstall/install/functions/100_check_wrong_encod_obj_fnc.uninstall.sql'
 select ' uninstall/install/functions/100_check_wrong_encod_obj_fnc.uninstall.sql';

 select '   [START]        ' || to_char(clock_timestamp(), 'dd.mm.yyyy hh24:mi:ss');

--if error then color red
\echo '[1;31m'

\i uninstall/install/functions/100_check_wrong_encod_obj_fnc.uninstall.sql

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

 \echo '[---------------------------------------------------------------------------------------------------------------]'
 select '[---------------------------------------------------------------------------------------------------------------]';
 \echo ' uninstall/install/functions/100_log_fk_no_indx_fnc.uninstall.sql'
 select ' uninstall/install/functions/100_log_fk_no_indx_fnc.uninstall.sql';

 select '   [START]        ' || to_char(clock_timestamp(), 'dd.mm.yyyy hh24:mi:ss');

--if error then color red
\echo '[1;31m'

\i uninstall/install/functions/100_log_fk_no_indx_fnc.uninstall.sql

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

 \echo '[---------------------------------------------------------------------------------------------------------------]'
 select '[---------------------------------------------------------------------------------------------------------------]';
 \echo ' uninstall/install/functions/100_log_wrong_encod_obj_fnc.uninstall.sql'
 select ' uninstall/install/functions/100_log_wrong_encod_obj_fnc.uninstall.sql';

 select '   [START]        ' || to_char(clock_timestamp(), 'dd.mm.yyyy hh24:mi:ss');

--if error then color red
\echo '[1;31m'

\i uninstall/install/functions/100_log_wrong_encod_obj_fnc.uninstall.sql

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

 \echo '[---------------------------------------------------------------------------------------------------------------]'
 select '[---------------------------------------------------------------------------------------------------------------]';
 \echo ' uninstall/install/functions/100_show_active_session_fnc.uninstall.sql'
 select ' uninstall/install/functions/100_show_active_session_fnc.uninstall.sql';

 select '   [START]        ' || to_char(clock_timestamp(), 'dd.mm.yyyy hh24:mi:ss');

--if error then color red
\echo '[1;31m'

\i uninstall/install/functions/100_show_active_session_fnc.uninstall.sql

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

 \echo '[---------------------------------------------------------------------------------------------------------------]'
 select '[---------------------------------------------------------------------------------------------------------------]';
 \echo ' uninstall/install/functions/101_finish_upgrade_system.uninstall.sql'
 select ' uninstall/install/functions/101_finish_upgrade_system.uninstall.sql';

 select '   [START]        ' || to_char(clock_timestamp(), 'dd.mm.yyyy hh24:mi:ss');

--if error then color red
\echo '[1;31m'

\i uninstall/install/functions/101_finish_upgrade_system.uninstall.sql

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

 \echo '[---------------------------------------------------------------------------------------------------------------]'
 select '[---------------------------------------------------------------------------------------------------------------]';
 \echo ' uninstall/install/functions/103_start_upgrade_system.uninstall.sql'
 select ' uninstall/install/functions/103_start_upgrade_system.uninstall.sql';

 select '   [START]        ' || to_char(clock_timestamp(), 'dd.mm.yyyy hh24:mi:ss');

--if error then color red
\echo '[1;31m'

\i uninstall/install/functions/103_start_upgrade_system.uninstall.sql

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

 \echo '[---------------------------------------------------------------------------------------------------------------]'
 select '[---------------------------------------------------------------------------------------------------------------]';
 \echo ' uninstall/install/functions/105_check_system_settings_fnc.uninstall.sql'
 select ' uninstall/install/functions/105_check_system_settings_fnc.uninstall.sql';

 select '   [START]        ' || to_char(clock_timestamp(), 'dd.mm.yyyy hh24:mi:ss');

--if error then color red
\echo '[1;31m'

\i uninstall/install/functions/105_check_system_settings_fnc.uninstall.sql

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

 \echo '[---------------------------------------------------------------------------------------------------------------]'
 select '[---------------------------------------------------------------------------------------------------------------]';
 \echo ' uninstall/install/functions/107_get_system_settings_fnc.uninstall.sql'
 select ' uninstall/install/functions/107_get_system_settings_fnc.uninstall.sql';

 select '   [START]        ' || to_char(clock_timestamp(), 'dd.mm.yyyy hh24:mi:ss');

--if error then color red
\echo '[1;31m'

\i uninstall/install/functions/107_get_system_settings_fnc.uninstall.sql

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

 \echo '[---------------------------------------------------------------------------------------------------------------]'
 select '[---------------------------------------------------------------------------------------------------------------]';
 \echo ' uninstall/install/functions/109_logit_fnc.uninstall.sql'
 select ' uninstall/install/functions/109_logit_fnc.uninstall.sql';

 select '   [START]        ' || to_char(clock_timestamp(), 'dd.mm.yyyy hh24:mi:ss');

--if error then color red
\echo '[1;31m'

\i uninstall/install/functions/109_logit_fnc.uninstall.sql

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

 \echo '[---------------------------------------------------------------------------------------------------------------]'
 select '[---------------------------------------------------------------------------------------------------------------]';
 \echo ' uninstall/install/functions/111_compare_system_fnc.uninstall.sql'
 select ' uninstall/install/functions/111_compare_system_fnc.uninstall.sql';

 select '   [START]        ' || to_char(clock_timestamp(), 'dd.mm.yyyy hh24:mi:ss');

--if error then color red
\echo '[1;31m'

\i uninstall/install/functions/111_compare_system_fnc.uninstall.sql

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

 \echo '[---------------------------------------------------------------------------------------------------------------]'
 select '[---------------------------------------------------------------------------------------------------------------]';
 \echo ' uninstall/install/functions/113_compare_version_fnc.uninstall.sql'
 select ' uninstall/install/functions/113_compare_version_fnc.uninstall.sql';

 select '   [START]        ' || to_char(clock_timestamp(), 'dd.mm.yyyy hh24:mi:ss');

--if error then color red
\echo '[1;31m'

\i uninstall/install/functions/113_compare_version_fnc.uninstall.sql

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

 \echo '[---------------------------------------------------------------------------------------------------------------]'
 select '[---------------------------------------------------------------------------------------------------------------]';
 \echo ' uninstall/install/functions/115_check_params_fnc.uninstall.sql'
 select ' uninstall/install/functions/115_check_params_fnc.uninstall.sql';

 select '   [START]        ' || to_char(clock_timestamp(), 'dd.mm.yyyy hh24:mi:ss');

--if error then color red
\echo '[1;31m'

\i uninstall/install/functions/115_check_params_fnc.uninstall.sql

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

 \echo '[---------------------------------------------------------------------------------------------------------------]'
 select '[---------------------------------------------------------------------------------------------------------------]';
 \echo ' uninstall/install/functions/117_init_version_fnc.uninstall.sql'
 select ' uninstall/install/functions/117_init_version_fnc.uninstall.sql';

 select '   [START]        ' || to_char(clock_timestamp(), 'dd.mm.yyyy hh24:mi:ss');

--if error then color red
\echo '[1;31m'

\i uninstall/install/functions/117_init_version_fnc.uninstall.sql

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

 \echo '[---------------------------------------------------------------------------------------------------------------]'
 select '[---------------------------------------------------------------------------------------------------------------]';
 \echo ' uninstall/install/functions/119_get_version.uninstall.sql'
 select ' uninstall/install/functions/119_get_version.uninstall.sql';

 select '   [START]        ' || to_char(clock_timestamp(), 'dd.mm.yyyy hh24:mi:ss');

--if error then color red
\echo '[1;31m'

\i uninstall/install/functions/119_get_version.uninstall.sql

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

 \echo '[---------------------------------------------------------------------------------------------------------------]'
 select '[---------------------------------------------------------------------------------------------------------------]';
 \echo ' uninstall/install/functions/121_write_log_txt.uninstall.sql'
 select ' uninstall/install/functions/121_write_log_txt.uninstall.sql';

 select '   [START]        ' || to_char(clock_timestamp(), 'dd.mm.yyyy hh24:mi:ss');

--if error then color red
\echo '[1;31m'

\i uninstall/install/functions/121_write_log_txt.uninstall.sql

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

 \echo '[---------------------------------------------------------------------------------------------------------------]'
 select '[---------------------------------------------------------------------------------------------------------------]';
 \echo ' uninstall/install/functions/123_write_log_sep.uninstall.sql'
 select ' uninstall/install/functions/123_write_log_sep.uninstall.sql';

 select '   [START]        ' || to_char(clock_timestamp(), 'dd.mm.yyyy hh24:mi:ss');

--if error then color red
\echo '[1;31m'

\i uninstall/install/functions/123_write_log_sep.uninstall.sql

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

 \echo '[---------------------------------------------------------------------------------------------------------------]'
 select '[---------------------------------------------------------------------------------------------------------------]';
 \echo ' uninstall/install/functions/125_write_log_inf.uninstall.sql'
 select ' uninstall/install/functions/125_write_log_inf.uninstall.sql';

 select '   [START]        ' || to_char(clock_timestamp(), 'dd.mm.yyyy hh24:mi:ss');

--if error then color red
\echo '[1;31m'

\i uninstall/install/functions/125_write_log_inf.uninstall.sql

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

 \echo '[---------------------------------------------------------------------------------------------------------------]'
 select '[---------------------------------------------------------------------------------------------------------------]';
 \echo ' uninstall/install/functions/127_write_log_wrn.uninstall.sql'
 select ' uninstall/install/functions/127_write_log_wrn.uninstall.sql';

 select '   [START]        ' || to_char(clock_timestamp(), 'dd.mm.yyyy hh24:mi:ss');

--if error then color red
\echo '[1;31m'

\i uninstall/install/functions/127_write_log_wrn.uninstall.sql

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

 \echo '[---------------------------------------------------------------------------------------------------------------]'
 select '[---------------------------------------------------------------------------------------------------------------]';
 \echo ' uninstall/install/functions/129_write_log_err.uninstall.sql'
 select ' uninstall/install/functions/129_write_log_err.uninstall.sql';

 select '   [START]        ' || to_char(clock_timestamp(), 'dd.mm.yyyy hh24:mi:ss');

--if error then color red
\echo '[1;31m'

\i uninstall/install/functions/129_write_log_err.uninstall.sql

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

 \echo '[---------------------------------------------------------------------------------------------------------------]'
 select '[---------------------------------------------------------------------------------------------------------------]';
 \echo ' uninstall/install/functions/131_write_log_trc.uninstall.sql'
 select ' uninstall/install/functions/131_write_log_trc.uninstall.sql';

 select '   [START]        ' || to_char(clock_timestamp(), 'dd.mm.yyyy hh24:mi:ss');

--if error then color red
\echo '[1;31m'

\i uninstall/install/functions/131_write_log_trc.uninstall.sql

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

 \echo '[---------------------------------------------------------------------------------------------------------------]'
 select '[---------------------------------------------------------------------------------------------------------------]';
 \echo ' uninstall/install/functions/133_write_log_color.uninstall.sql'
 select ' uninstall/install/functions/133_write_log_color.uninstall.sql';

 select '   [START]        ' || to_char(clock_timestamp(), 'dd.mm.yyyy hh24:mi:ss');

--if error then color red
\echo '[1;31m'

\i uninstall/install/functions/133_write_log_color.uninstall.sql

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

 \echo '[---------------------------------------------------------------------------------------------------------------]'
 select '[---------------------------------------------------------------------------------------------------------------]';
 \echo ' uninstall/install/functions/135_write_log.uninstall.sql'
 select ' uninstall/install/functions/135_write_log.uninstall.sql';

 select '   [START]        ' || to_char(clock_timestamp(), 'dd.mm.yyyy hh24:mi:ss');

--if error then color red
\echo '[1;31m'

\i uninstall/install/functions/135_write_log.uninstall.sql

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

 \echo '[---------------------------------------------------------------------------------------------------------------]'
 select '[---------------------------------------------------------------------------------------------------------------]';
 \echo ' uninstall/install/functions/137_set_color_text.uninstall.sql'
 select ' uninstall/install/functions/137_set_color_text.uninstall.sql';

 select '   [START]        ' || to_char(clock_timestamp(), 'dd.mm.yyyy hh24:mi:ss');

--if error then color red
\echo '[1;31m'

\i uninstall/install/functions/137_set_color_text.uninstall.sql

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

 \echo '[---------------------------------------------------------------------------------------------------------------]'
 select '[---------------------------------------------------------------------------------------------------------------]';
 \echo ' uninstall/install/functions/139_get_color_end.uninstall.sql'
 select ' uninstall/install/functions/139_get_color_end.uninstall.sql';

 select '   [START]        ' || to_char(clock_timestamp(), 'dd.mm.yyyy hh24:mi:ss');

--if error then color red
\echo '[1;31m'

\i uninstall/install/functions/139_get_color_end.uninstall.sql

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

 \echo '[---------------------------------------------------------------------------------------------------------------]'
 select '[---------------------------------------------------------------------------------------------------------------]';
 \echo ' uninstall/install/functions/141_get_color_start.uninstall.sql'
 select ' uninstall/install/functions/141_get_color_start.uninstall.sql';

 select '   [START]        ' || to_char(clock_timestamp(), 'dd.mm.yyyy hh24:mi:ss');

--if error then color red
\echo '[1;31m'

\i uninstall/install/functions/141_get_color_start.uninstall.sql

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

 \echo '[---------------------------------------------------------------------------------------------------------------]'
 select '[---------------------------------------------------------------------------------------------------------------]';
 \echo ' uninstall/install/views/fk_no_index_vw.uninstall.sql'
 select ' uninstall/install/views/fk_no_index_vw.uninstall.sql';

 select '   [START]        ' || to_char(clock_timestamp(), 'dd.mm.yyyy hh24:mi:ss');

--if error then color red
\echo '[1;31m'

\i uninstall/install/views/fk_no_index_vw.uninstall.sql

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

 \echo '[---------------------------------------------------------------------------------------------------------------]'
 select '[---------------------------------------------------------------------------------------------------------------]';
 \echo ' uninstall/install/views/sys_registry_data.uninstall.sql'
 select ' uninstall/install/views/sys_registry_data.uninstall.sql';

 select '   [START]        ' || to_char(clock_timestamp(), 'dd.mm.yyyy hh24:mi:ss');

--if error then color red
\echo '[1;31m'

\i uninstall/install/views/sys_registry_data.uninstall.sql

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

 \echo '[---------------------------------------------------------------------------------------------------------------]'
 select '[---------------------------------------------------------------------------------------------------------------]';
 \echo ' uninstall/install/views/wrong_encod_obj_lines_vw.uninstall.sql'
 select ' uninstall/install/views/wrong_encod_obj_lines_vw.uninstall.sql';

 select '   [START]        ' || to_char(clock_timestamp(), 'dd.mm.yyyy hh24:mi:ss');

--if error then color red
\echo '[1;31m'

\i uninstall/install/views/wrong_encod_obj_lines_vw.uninstall.sql

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

 \echo '[---------------------------------------------------------------------------------------------------------------]'
 select '[---------------------------------------------------------------------------------------------------------------]';
 \echo ' uninstall/install/views/wrong_encod_obj_vw.uninstall.sql'
 select ' uninstall/install/views/wrong_encod_obj_vw.uninstall.sql';

 select '   [START]        ' || to_char(clock_timestamp(), 'dd.mm.yyyy hh24:mi:ss');

--if error then color red
\echo '[1;31m'

\i uninstall/install/views/wrong_encod_obj_vw.uninstall.sql

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

 \echo '[---------------------------------------------------------------------------------------------------------------]'
 select '[---------------------------------------------------------------------------------------------------------------]';
 \echo ' uninstall/install/types/compare_system_return_row.uninstall.sql'
 select ' uninstall/install/types/compare_system_return_row.uninstall.sql';

 select '   [START]        ' || to_char(clock_timestamp(), 'dd.mm.yyyy hh24:mi:ss');

--if error then color red
\echo '[1;31m'

\i uninstall/install/types/compare_system_return_row.uninstall.sql

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

 \echo '[---------------------------------------------------------------------------------------------------------------]'
 select '[---------------------------------------------------------------------------------------------------------------]';
 \echo ' uninstall/install/types/sys_registry_settings_row.uninstall.sql'
 select ' uninstall/install/types/sys_registry_settings_row.uninstall.sql';

 select '   [START]        ' || to_char(clock_timestamp(), 'dd.mm.yyyy hh24:mi:ss');

--if error then color red
\echo '[1;31m'

\i uninstall/install/types/sys_registry_settings_row.uninstall.sql

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

 \echo '[---------------------------------------------------------------------------------------------------------------]'
 select '[---------------------------------------------------------------------------------------------------------------]';
 \echo ' uninstall/install/types/system_version_row.uninstall.sql'
 select ' uninstall/install/types/system_version_row.uninstall.sql';

 select '   [START]        ' || to_char(clock_timestamp(), 'dd.mm.yyyy hh24:mi:ss');

--if error then color red
\echo '[1;31m'

\i uninstall/install/types/system_version_row.uninstall.sql

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

 \echo '[---------------------------------------------------------------------------------------------------------------]'
 select '[---------------------------------------------------------------------------------------------------------------]';
 \echo ' uninstall/install/types/upgrade_log_row.uninstall.sql'
 select ' uninstall/install/types/upgrade_log_row.uninstall.sql';

 select '   [START]        ' || to_char(clock_timestamp(), 'dd.mm.yyyy hh24:mi:ss');

--if error then color red
\echo '[1;31m'

\i uninstall/install/types/upgrade_log_row.uninstall.sql

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

 \echo '[---------------------------------------------------------------------------------------------------------------]'
 select '[---------------------------------------------------------------------------------------------------------------]';
 \echo ' uninstall/install/tables/log_fk_no_idx_delta_tbl.uninstall.sql'
 select ' uninstall/install/tables/log_fk_no_idx_delta_tbl.uninstall.sql';

 select '   [START]        ' || to_char(clock_timestamp(), 'dd.mm.yyyy hh24:mi:ss');

--if error then color red
\echo '[1;31m'

\i uninstall/install/tables/log_fk_no_idx_delta_tbl.uninstall.sql

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

 \echo '[---------------------------------------------------------------------------------------------------------------]'
 select '[---------------------------------------------------------------------------------------------------------------]';
 \echo ' uninstall/install/tables/log_fk_no_idx_tmp_tbl.uninstall.sql'
 select ' uninstall/install/tables/log_fk_no_idx_tmp_tbl.uninstall.sql';

 select '   [START]        ' || to_char(clock_timestamp(), 'dd.mm.yyyy hh24:mi:ss');

--if error then color red
\echo '[1;31m'

\i uninstall/install/tables/log_fk_no_idx_tmp_tbl.uninstall.sql

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

 \echo '[---------------------------------------------------------------------------------------------------------------]'
 select '[---------------------------------------------------------------------------------------------------------------]';
 \echo ' uninstall/install/tables/log_wrong_encod_obj_delta_tbl.uninstall.sql'
 select ' uninstall/install/tables/log_wrong_encod_obj_delta_tbl.uninstall.sql';

 select '   [START]        ' || to_char(clock_timestamp(), 'dd.mm.yyyy hh24:mi:ss');

--if error then color red
\echo '[1;31m'

\i uninstall/install/tables/log_wrong_encod_obj_delta_tbl.uninstall.sql

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

 \echo '[---------------------------------------------------------------------------------------------------------------]'
 select '[---------------------------------------------------------------------------------------------------------------]';
 \echo ' uninstall/install/tables/log_wrong_encod_obj_tmp_tbl.uninstall.sql'
 select ' uninstall/install/tables/log_wrong_encod_obj_tmp_tbl.uninstall.sql';

 select '   [START]        ' || to_char(clock_timestamp(), 'dd.mm.yyyy hh24:mi:ss');

--if error then color red
\echo '[1;31m'

\i uninstall/install/tables/log_wrong_encod_obj_tmp_tbl.uninstall.sql

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

 \echo '[---------------------------------------------------------------------------------------------------------------]'
 select '[---------------------------------------------------------------------------------------------------------------]';
 \echo ' uninstall/install/tables/sys_registry_data_tbl.uninstall.sql'
 select ' uninstall/install/tables/sys_registry_data_tbl.uninstall.sql';

 select '   [START]        ' || to_char(clock_timestamp(), 'dd.mm.yyyy hh24:mi:ss');

--if error then color red
\echo '[1;31m'

\i uninstall/install/tables/sys_registry_data_tbl.uninstall.sql

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

 \echo '[---------------------------------------------------------------------------------------------------------------]'
 select '[---------------------------------------------------------------------------------------------------------------]';
 \echo ' uninstall/install/tables/sys_registry_settings_tbl.uninstall.sql'
 select ' uninstall/install/tables/sys_registry_settings_tbl.uninstall.sql';

 select '   [START]        ' || to_char(clock_timestamp(), 'dd.mm.yyyy hh24:mi:ss');

--if error then color red
\echo '[1;31m'

\i uninstall/install/tables/sys_registry_settings_tbl.uninstall.sql

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

 \echo '[---------------------------------------------------------------------------------------------------------------]'
 select '[---------------------------------------------------------------------------------------------------------------]';
 \echo ' uninstall/install/tables/upgrade_log_tbl.uninstall.sql'
 select ' uninstall/install/tables/upgrade_log_tbl.uninstall.sql';

 select '   [START]        ' || to_char(clock_timestamp(), 'dd.mm.yyyy hh24:mi:ss');

--if error then color red
\echo '[1;31m'

\i uninstall/install/tables/upgrade_log_tbl.uninstall.sql

\echo '[1;m[1;m'
 
 select '   [FINISH]       '|| to_char(clock_timestamp(), 'dd.mm.yyyy hh24:mi:ss');
 \echo '[---------------------------------------------------------------------------------------------------------------]'
 select '[---------------------------------------------------------------------------------------------------------------]';
 select :total_blocks_install + 1 as total_blocks_install \gset
-----------------------------------------------/FILE/---------------------------------------------------------------

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
