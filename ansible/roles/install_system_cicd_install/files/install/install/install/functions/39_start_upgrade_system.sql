create or replace function install.start_upgrade_system(p_system_name  in varchar
                                                       ,p_prev_version in varchar
                                                       ,p_new_version  in varchar
                                                       ,p_revision     in varchar default null
                                                       ,p_delivery     in varchar default null
                                                       ,p_check_vers   in integer default 1
                                                       ,p_update_vers  in integer default 1
                                                       ,p_git_revision in varchar default null
                                                       ,p_url_tbz      in varchar default null
                                                       ,p_is_dc        boolean default false) returns text as
$body$
declare  
  v_result         text;
  v_compare_return install.compare_system_return_row;
  v_ul_row         install.upgrade_log_row;
  v_sys_settings   install.sys_registry_settings_row;
  v_err_sqlstate   text;
  v_err_message    text;
  v_err_context    text;
  --v_cnt          integer;
begin

  v_result := install.write_log_inf('SYS REGISTRY', '*** Start upgrade subsystem ***');

  -- собираем параметры сесии
  v_ul_row.system_name         := upper(p_system_name);
  v_ul_row.system_version      := p_new_version;
  v_ul_row.prev_system_version := p_prev_version;
  v_ul_row.cvs_revision        := p_revision;
  v_ul_row.git_revision        := p_git_revision;
  v_ul_row.cvs_url             := p_url_tbz;
  v_ul_row.sppr_delivery       := p_delivery;
  v_ul_row.update_vers         := p_update_vers;
  v_ul_row.start_time          := clock_timestamp();
  v_ul_row.result              := 'started';
  v_ul_row.osuser              := coalesce(current_setting('context.OSUSER', true),'');
  v_ul_row.host                := inet_client_addr() ::varchar || ':' || inet_client_port() ::varchar;
  v_ul_row.program             := current_setting('application_name');

  -- Получим настройки подсистемы
  v_sys_settings := install.get_system_settings_fnc(p_system_name);

  -- Проверим настройки подсистемы
  v_result := v_result || chr(10) || install.check_system_settings_fnc(v_sys_settings);

  -- проверяем можно ли апгрейдить
  v_compare_return := install.compare_system_fnc(p_system_name  => p_system_name,
                                                 p_prev_version => p_prev_version,
                                                 p_new_version  => p_new_version,
                                                 p_check_vers   => coalesce(p_check_vers, 1),
                                                 p_is_dc        => p_is_dc);

  v_result := v_result || chr(10) || v_compare_return.log_message;
  v_ul_row.action = v_compare_return.action;

  -- делаем подготовительные действия по правам
  v_result := v_result || chr(10) || installsys.install_realese('start');

  -- пишем лог
  v_result := v_result || chr(10) || install.logit_fnc(v_ul_row);
 
  -- читаем из лога строку с новым id_ul. Берем крайний лог со статусом 'started'
  select *
    into v_ul_row
    from install.upgrade_log_tbl
   where upper(system_name) = upper(p_system_name)
     and prev_system_version = p_prev_version
     and system_version = p_new_version
     and finish_time is null
     and result = 'started'
   order by start_time desc
   fetch first 1 row only;
 
  -- пишем FK без индексов до поставки
   v_result := v_result || chr(10) || install.log_fk_no_indx_fnc('before', v_ul_row);
  
  -- пишем объекты c неверной кодировкой до поставки    
  v_result := v_result || chr(10) || install.log_wrong_encod_obj_fnc('before', v_ul_row);

  return v_result;
exception
  when others then
    v_ul_row.start_time := clock_timestamp();
    v_ul_row.result     := 'Error';
    get stacked diagnostics v_err_sqlstate = returned_sqlstate, v_err_message = message_text, v_err_context = pg_exception_context;
    v_ul_row.logs := 'ERROR ' || v_err_sqlstate || ': ' || v_err_message || chr(10) || 'CONTEXT: ' || v_err_context;
    v_result      := v_result || chr(10) || install.logit_fnc(v_ul_row);
    v_result      := v_result || chr(10) || install.write_log_err('SYS REGISTRY', v_ul_row.logs);
    return v_result;
    --RAISE NOTICE '%', v_ul_row.logs;
  --raise;
end;
$body$
language plpgsql;
