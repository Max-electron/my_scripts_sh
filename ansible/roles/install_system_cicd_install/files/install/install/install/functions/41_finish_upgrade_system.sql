create or replace function install.finish_upgrade_system(p_system_name  in varchar
                                                        ,p_prev_version in varchar
                                                        ,p_new_version  in varchar
                                                        ,p_is_dc        boolean default false) returns text as
$body$
declare  
  v_result       text;
  v_compare_return install.compare_system_return_row;      
  v_ul_row       install.upgrade_log_row;
  v_id_sys_reg   integer;
  v_sys_settings install.sys_registry_settings_row;
  v_err_sqlstate text;
  v_err_message  text;
  v_err_context  text;
  --v_cnt          integer;
  --v_sysdate      date := sysdate;
begin
  v_result := install.write_log_inf('SYS REGISTRY', '*** Finish upgrade subsystem ***');
  v_result := v_result || chr(10) || install.write_log_inf('SYS REGISTRY', 'Restore upgrade context from log');
  -- Берем крайний лог со статусом 'started'
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

  -- Получим настройки подсистемы
  v_sys_settings := install.get_system_settings_fnc(p_system_name);

  -- Проверим настройки подсистемы
  v_result := v_result || chr(10) || install.check_system_settings_fnc(v_sys_settings);

  -- Проверим снова версию, так как за время паузы могла залететь другая поставка.
  v_compare_return := install.compare_system_fnc(p_system_name  => p_system_name,
                                         p_prev_version => p_prev_version,
                                         p_new_version  => p_new_version,
                                         p_check_vers   => v_ul_row.update_vers,
                                         p_is_dc        => p_is_dc);

  v_result := v_result || chr(10) || v_compare_return.log_message;
  v_ul_row.action = v_compare_return.action;
  

  v_ul_row.result      := 'OK';
  v_ul_row.finish_time := clock_timestamp();

  -- Меняем версию
  if v_ul_row.update_vers = 1
  then
    v_result := v_result || chr(10) || install.write_log_inf('SYS REGISTRY', 'Change current subsystem version to ' || p_new_version);
  
    -- Находим текущую версию
    begin
      -- Получим ID обновляемой подсистемы
      select r.id_sys_reg
        into strict v_id_sys_reg
        from install.sys_registry_data_tbl r
       where upper(r.sys_name) = upper(p_system_name)
         and clock_timestamp() between r.install_date and coalesce(r.uninstall_date, to_timestamp('01.01.9999', 'dd.mm.yyyy'));
    exception
      --Если подсистема не установлена, то возвращаем -1
      when no_data_found then
        v_id_sys_reg := -1;
    end;
  
    --Если мы обновляем версию подсистемы - сначала закрываем текущую версию
    update install.sys_registry_data_tbl
       set uninstall_date = clock_timestamp()
     where id_sys_reg = v_id_sys_reg;
  
    --И добавляем запись о новой версии
    insert into install.sys_registry_data_tbl
      (sys_name
      ,version
      ,install_date
      ,uninstall_date
      ,dbuser
      ,osuser
      ,id_ul)
    values
      (p_system_name
      ,p_new_version
      ,clock_timestamp()
      ,null
      ,current_user
      ,v_ul_row.osuser
      ,v_ul_row.id_ul);
  end if;

  -- делаем заключительные действия по правам
  v_result := v_result || chr(10) || installsys.install_realese('stop');

  -- пишем лог
  v_result := v_result || chr(10) || install.logit_fnc(v_ul_row);
 
  -- пишем FK без индексов после поставки
  v_result := v_result || chr(10) || install.log_fk_no_indx_fnc('after', v_ul_row);
 
  -- пишем объекты c неверной кодировкой после поставки    
  v_result := v_result || chr(10) || install.log_wrong_encod_obj_fnc('after', v_ul_row);

  return v_result;
exception
  when others then
    v_ul_row.result := 'Error';
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
