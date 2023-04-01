create or replace function install.get_version(p_name    varchar
                                              ,p_sysdate timestamp default clock_timestamp()) returns varchar as
$body$
declare  
  v_result varchar(50);
begin
  select r.version
    into strict v_result
    from install.sys_registry_data_tbl r
   where upper(r.sys_name) = upper(p_name)
     and p_sysdate between r.install_date and coalesce(r.uninstall_date, to_timestamp('01.01.9999', 'dd.mm.yyyy'));

  return v_result;
end;
$body$
language plpgsql;
