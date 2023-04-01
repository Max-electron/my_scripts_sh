create or replace function install.init_version_fnc(p_version varchar) returns install.system_version_row as
$body$
declare  
  v_result install.system_version_row;
begin
  begin
    v_result.major_version := split_part(p_version, '.', 1)::integer;
  exception
    when others then
        v_result.major_version := null;
  end;  
  begin
    v_result.minor_version := split_part(p_version, '.', 2)::integer;
  exception
    when others then
        v_result.minor_version := null;
  end;  
  begin
    v_result.patch_version := split_part(p_version, '.', 3)::integer;
  exception
    when others then
        v_result.patch_version := null;
  end;  
  return v_result;
end;
$body$
language plpgsql;
