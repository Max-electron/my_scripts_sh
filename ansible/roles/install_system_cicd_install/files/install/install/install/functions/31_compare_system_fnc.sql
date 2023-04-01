create or replace function install.compare_system_fnc(p_system_name  varchar
                                                     ,p_prev_version varchar
                                                     ,p_new_version  varchar
                                                     ,p_check_vers   integer
                                                     ,p_is_dc        boolean default false) returns install.compare_system_return_row as
$body$
declare  
  v_result          install.compare_system_return_row;
  v_cur_ver         varchar(50);
  v_current_version install.system_version_row; -- текущая версия
  v_prev_version    install.system_version_row; -- с какой версии обновляем
  v_new_version     install.system_version_row; -- на какую
  v_check_result    integer;
  v_message_ru      text := '';
  v_message_en      text := '';
  v_check_params    text;
begin

  if p_is_dc
  then
    v_result.log_message := install.write_log_inf('SYS REGISTRY', 'p_is_dc = true');
  else
    v_result.log_message := install.write_log_inf('SYS REGISTRY', 'p_is_dc = false');
  end if;

  v_result.log_message := v_result.log_message || chr(10) ||
                          install.write_log_inf('SYS REGISTRY', 'Check subsystem version');
  v_result.log_message := v_result.log_message || chr(10) ||
                          install.write_log_inf('SYS REGISTRY', '    Previous (p_prev_version) = ' || p_prev_version);
  v_result.log_message := v_result.log_message || chr(10) ||
                          install.write_log_inf('SYS REGISTRY', '    New (p_new_version) = '|| p_new_version);
                          

  v_prev_version := install.init_version_fnc(p_prev_version);
  v_new_version  := install.init_version_fnc(p_new_version);

  --проверяем входные параметры на null
  v_check_params := install.check_params_fnc(p_system_name, v_prev_version);
  if v_check_params != '' then
    v_result.log_message := v_result.log_message || chr(10) || v_check_params;
  end if;
  v_check_params := install.check_params_fnc(p_system_name, v_new_version);
  if v_check_params != '' then
    v_result.log_message := v_result.log_message || chr(10) || v_check_params;
  end if;

  -- определяем action
  v_result.action := case install.compare_version_fnc(v_new_version, v_prev_version)
                       when 1 then
                        'install'
                       when -1 then
                        'uninstall'
                       when 0 then
                        'equally'
                     end;

  -- находим текущую версию
  begin
    --get_version выбросит no_data_found если подсистема не найдена
    v_cur_ver := install.get_version(p_system_name, clock_timestamp() ::timestamp);
  exception
    --Если подсистема не установлена, то проверку на равенство подсистем считаем успешной
    when no_data_found then
      v_check_result := 0;
      v_result.log_message := v_result.log_message || chr(10) ||
                              install.write_log_inf('SYS REGISTRY', '    Current version in database: not found');      
      return v_result;
  end;

  -- Инициализируем текущую версию
  v_current_version    := install.init_version_fnc(v_cur_ver);
  v_result.log_message := v_result.log_message || chr(10) ||
                          install.write_log_inf('SYS REGISTRY', '    Current version in database: ' || v_cur_ver);

  -- для РЦ другая логика проверки версий
  if not p_is_dc
  then
    -- сравниваем с текущей версией из параметров
    v_check_result := install.compare_version_fnc(v_prev_version, v_current_version);
  
    -- если не равна сравниваем с новой версией в случае даунгрейда
    if v_result.action = 'uninstall' and
       v_check_result <> 0
    then
      v_check_result := install.compare_version_fnc(v_new_version, v_current_version);
    end if;
  
    --если после проверок <> 0
    if p_check_vers = 1
    then
      if v_result.action = 'equally'
      then
        v_message_ru         := 'Новая (p_new_version=' || p_new_version || ') и предыдущая (p_prev_version=' ||
                                p_prev_version || ') версии подсистемы совпадают';
        v_message_en         := 'New (p_new_version=' || p_new_version || ') and previous (p_prev_version=' ||
                                p_prev_version || ') versions of the subsystem match';
        v_result.log_message := v_result.log_message || chr(10) || install.write_log_sep('red');
        v_result.log_message := v_result.log_message || chr(10) || install.write_log_err('SYS REG CHK', v_message_ru);
        v_result.log_message := v_result.log_message || chr(10) || install.write_log_err('SYS REG CHK', v_message_en);
        v_result.log_message := v_result.log_message || chr(10) || install.write_log_sep('red');
        raise sqlstate 'ERR01'
          using message = v_message_ru || chr(10) || v_message_en;
      end if;
      if v_check_result <> 0
      then
        v_message_ru         := 'Текущая версия подсистемы в БД (' || v_cur_ver ||
                                ') не соответствует ожидаемой (p_prev_version=' || p_prev_version || ')';
        v_message_en         := 'Current subsystem version in DB (' || v_cur_ver ||
                                ') does not match expected (p_prev_version=' || p_prev_version || ')';
        v_result.log_message := v_result.log_message || chr(10) || install.write_log_sep('red');
        v_result.log_message := v_result.log_message || chr(10) || install.write_log_err('SYS REG CHK', v_message_ru);
        v_result.log_message := v_result.log_message || chr(10) || install.write_log_err('SYS REG CHK', v_message_en);
        v_result.log_message := v_result.log_message || chr(10) || install.write_log_sep('red');
        raise sqlstate 'ERR01'
          using message = v_message_ru || chr(10) || v_message_en;
      end if;
    end if;
    -- Для РЦ
  else
    if p_check_vers = 1
    then
      -- Если ставим патч (Pa != 0), то сравниваем полностью текущую(C) и предыдущую(Pr) версию(без тест части)
      if v_new_version.patch_version != 0
      then
        if install.compare_version_fnc(v_prev_version, v_current_version) != 0
        then
          v_message_ru         := '1 Текущая версия подсистемы в БД (' || v_cur_ver ||
                                  ') не соответствует ожидаемой (p_prev_version=' || p_prev_version || ')';
          v_message_en         := '1 Current subsystem version in DB (' || v_cur_ver ||
                                  ') does not match expected (p_prev_version=' || p_prev_version || ')';
          v_result.log_message := v_result.log_message || chr(10) || install.write_log_sep('red');
          v_result.log_message := v_result.log_message || chr(10) || install.write_log_err('SYS REG CHK', v_message_ru);
          v_result.log_message := v_result.log_message || chr(10) || install.write_log_err('SYS REG CHK', v_message_en);
          v_result.log_message := v_result.log_message || chr(10) || install.write_log_sep('red');
          raise sqlstate 'ERR01'
            using message = v_message_ru || chr(10) || v_message_en;
        end if;
        -- Если ставим релиз(Pa = 0), то сравниваем только мажорную(Ma) и минорную(Mi) часть
      else
        if v_prev_version.major_version != v_current_version.major_version or
           v_prev_version.minor_version != v_current_version.minor_version
        then
          v_message_ru         := '2 Текущая версия подсистемы в БД (' || v_cur_ver ||
                                  ') не соответствует ожидаемой (p_prev_version=' || p_prev_version || ')';
          v_message_en         := '2 Current subsystem version in DB (' || v_cur_ver ||
                                  ') does not match expected (p_prev_version=' || p_prev_version || ')';
          v_result.log_message := v_result.log_message || chr(10) || install.write_log_sep('red');
          v_result.log_message := v_result.log_message || chr(10) || install.write_log_err('SYS REG CHK', v_message_ru);
          v_result.log_message := v_result.log_message || chr(10) || install.write_log_err('SYS REG CHK', v_message_en);
          v_result.log_message := v_result.log_message || chr(10) || install.write_log_sep('red');
          raise sqlstate 'ERR01'
            using message = v_message_ru || chr(10) || v_message_en;
        end if;
      end if;
    end if;
  end if;
  return v_result;
end;
$body$
language plpgsql;
