create or replace function install.logit_fnc(p_ul_row install.upgrade_log_row) returns text as
$body$
declare
  v_cmd text;
  v_result text;
  v_err_sqlstate text;
  v_err_message text;
  v_err_context text;
begin
  v_result := install.write_log_inf('SYS REGISTRY', 'Logging current upgrade context');
  if p_ul_row.prev_system_version = p_ul_row.system_version then
     p_ul_row.action = 'equally';
  end if;  
  if p_ul_row.id_ul is null
  then
    insert into install.upgrade_log_tbl
      (system_name
      ,action
      ,prev_system_version
      ,system_version
      ,start_time
      ,finish_time
      ,result
      ,osuser
      ,host
      ,program
      ,logs
      ,sppr_delivery
      ,cvs_revision
      ,git_revision
      ,cvs_url
      ,update_vers)
    values
      (p_ul_row.system_name
      ,p_ul_row.action
      ,p_ul_row.prev_system_version
      ,p_ul_row.system_version
      ,p_ul_row.start_time
      ,p_ul_row.finish_time
      ,p_ul_row.result
      ,p_ul_row.osuser
      ,p_ul_row.host
      ,p_ul_row.program
      ,p_ul_row.logs
      ,p_ul_row.sppr_delivery
      ,p_ul_row.cvs_revision
      ,p_ul_row.git_revision
      ,p_ul_row.cvs_url
      ,p_ul_row.update_vers);
    
  else
    update install.upgrade_log_tbl 
       set system_name         = coalesce(p_ul_row.system_name, system_name)
          ,prev_system_version = coalesce(p_ul_row.prev_system_version, prev_system_version)
          ,system_version      = coalesce(p_ul_row.system_version, system_version)
          ,start_time          = coalesce(p_ul_row.start_time, start_time)
          ,finish_time         = coalesce(p_ul_row.finish_time, finish_time)
          ,sppr_delivery       = coalesce(p_ul_row.sppr_delivery, sppr_delivery)
          ,cvs_revision        = coalesce(p_ul_row.cvs_revision, cvs_revision)
          ,git_revision        = coalesce(p_ul_row.git_revision, git_revision)
          ,cvs_url             = coalesce(p_ul_row.cvs_url, cvs_url)
          ,action              = coalesce(p_ul_row.action, action)
          ,osuser              = coalesce(p_ul_row.osuser, osuser)
          ,host                = coalesce(p_ul_row.host, host)
          ,program             = coalesce(p_ul_row.program, program)
          ,result              = coalesce(p_ul_row.result, result)
          ,logs                = coalesce(p_ul_row.logs, logs)
          ,update_vers         = coalesce(p_ul_row.update_vers, update_vers)
     where id_ul = p_ul_row.id_ul;
  end if;

  return v_result;
end;  
$body$
language plpgsql;
