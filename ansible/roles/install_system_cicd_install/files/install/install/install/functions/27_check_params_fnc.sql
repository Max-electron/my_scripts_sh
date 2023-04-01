create or replace function install.check_params_fnc(p_name           varchar
                                                   ,p_system_version install.system_version_row) returns text as
$body$
declare  
  v_result text := '';
begin
  /*  raise notice 'p_name = (%)', p_name;
  raise notice 'p_system_version.major_version = (%)', p_system_version.major_version;
  raise notice 'p_system_version.minor_version = (%)', p_system_version.minor_version;
  raise notice 'p_system_version.patch_version = (%)', p_system_version.patch_version;*/
  if ((nullif(trim(p_name), '') is null) or
     --Если одно из слогаемых is NULL, то и вся сумма is NULL
     ((p_system_version.major_version + p_system_version.minor_version + p_system_version.patch_version) is null))
  then
    v_result := install.write_log_sep('red');
    v_result := v_result || chr(10) ||
                install.write_log_err('SYS REG CHK',
                                      'Имя подсистемы или одна из частей версии is NULL');
    v_result := v_result || chr(10) ||
                install.write_log_err('SYS REG CHK', 'Subsystem name or one of the version parts is NULL');
    v_result := v_result || chr(10) || install.write_log_sep('red');
    --install.write_log_color('red');
    raise sqlstate 'ERR01'
      using message = 'Имя подсистемы или одна из частей версии is NULL' || chr(10) || 'Subsystem name or one of the version parts is NULL';
  end if;
  return v_result;
end;
$body$
language plpgsql;
