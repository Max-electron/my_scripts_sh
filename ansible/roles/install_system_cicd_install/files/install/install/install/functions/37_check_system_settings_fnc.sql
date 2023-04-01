create or replace function install.check_system_settings_fnc(p_sys_settings install.sys_registry_settings_row) returns text as
$body$
declare  
  v_result     text;
  v_cnt        integer;
  v_message_ru text := '';
  v_message_en text := '';
begin
  v_result := install.write_log_inf('SYS REGISTRY', 'Check subsystem settings');
  -- Одновременная установка нескольких ревизий для подсистемы
  if p_sys_settings.single_install = 1
  then
    v_result := v_result || chr(10) || install.write_log_inf('SYS REGISTRY', 'Parameter single_install = 1');
    begin
      select count(1)
        into v_cnt
        from pg_stat_activity
       where usename = 'install'
         and state = 'active';
      if v_cnt > 1
      then
        v_message_ru := 'Одновременная установка нескольких ревизий запрещена настройками подсистемы';
        v_message_en := 'Simultaneous installation of several revisions is prohibited by the subsystem settings';
        v_result     := v_result || chr(10) || install.write_log_sep('red');
        v_result     := v_result || chr(10) || install.write_log_err('SYS REG CHK', v_message_ru);
        v_result     := v_result || chr(10) || install.write_log_err('SYS REG CHK', v_message_en);
        v_result     := v_result || chr(10) || install.write_log_sep('red');
        raise sqlstate 'ERR01'
          using message = v_message_ru || chr(10) || v_message_en, detail = 'Количество активных сессий под пользователем install больше одной.', hint = 'Дождитесь окончания активности других сессий под пользователем install и повторите установку.';
      end if;
    end;
  elsif p_sys_settings.single_install = 0
  then
    v_result := v_result || chr(10) || install.write_log_inf('SYS REGISTRY', 'Parameter single_install = 0');
  end if;
  return v_result;
end;
$body$
language plpgsql;
