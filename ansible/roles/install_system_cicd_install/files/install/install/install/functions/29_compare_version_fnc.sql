create or replace function install.compare_version_fnc(left_version  install.system_version_row
                                                      ,right_version install.system_version_row) returns integer as
$body$
--Сравнивает 2 версии подсистем. Вывод: 0 => "=", -1 => "<", 1 => ">"
declare  
  v_result integer;
begin
  if (left_version.major_version = right_version.major_version and
     left_version.minor_version = right_version.minor_version and
     left_version.patch_version = right_version.patch_version)
  then
    v_result := 0;
  elsif (left_version.major_version > right_version.major_version or
        left_version.major_version = right_version.major_version and
        left_version.minor_version > right_version.minor_version or
        left_version.major_version = right_version.major_version and
        left_version.minor_version = right_version.minor_version and
        left_version.patch_version > right_version.patch_version)
  then
    v_result := 1;
  else
    v_result := -1;
  end if;
  return v_result;
end;
$body$
language plpgsql;
