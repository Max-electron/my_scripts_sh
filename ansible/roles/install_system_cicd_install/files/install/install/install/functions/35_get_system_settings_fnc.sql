create or replace function install.get_system_settings_fnc(p_sys_name varchar) returns install.sys_registry_settings_row as
$body$
declare  
  v_sys_settings install.sys_registry_settings_row;
begin
  select sys_name
        ,single_install
    into strict v_sys_settings.sys_name
        ,v_sys_settings.single_install
    from install.sys_registry_settings_tbl
   where sys_name = p_sys_name;
  return v_sys_settings;
exception
  when no_data_found then
    v_sys_settings.sys_name       := p_sys_name;
    v_sys_settings.single_install := 1;
    return v_sys_settings;
end;
$body$
language plpgsql;
