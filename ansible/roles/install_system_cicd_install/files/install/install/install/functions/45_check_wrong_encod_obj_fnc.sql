create or replace function install.check_wrong_encod_obj_fnc() returns text as
$body$
declare  
  v_result text;
  v_cnt    integer := 0;
  v_rec    install.wrong_encod_obj_vw%rowtype;
begin
  v_result := install.write_log_sep('yellow');
  v_result := v_result || chr(10) ||
              install.write_log_inf('CHK WRONG ENCOD', 'List of all stored procedures with wrong encoding:');
  v_result := v_result || chr(10) || install.write_log_sep('yellow');
  for v_rec in (select *
                  from install.wrong_encod_obj_vw e
                 order by e.schema
                         ,e.name)
  loop
    v_result := v_result || chr(10) ||
                install.write_log_inf('CHK WRONG ENCOD',
                                      '    ' || v_rec.type || ' ' || v_rec.schema || '.' || v_rec.name);
    v_cnt    := v_cnt + 1;
  end loop;
  v_result := v_result || chr(10) ||
              install.write_log_inf('CHK WRONG ENCOD', '!!! Number of found objects with wrong encoding is ' || v_cnt);
  if v_cnt > 0
  then
    v_result := v_result || chr(10) ||
                install.write_log_inf('CHK WRONG ENCOD',
                                      'For detail use select * from install.wrong_encod_obj_lines_vw');
  end if;
  return v_result;
end;
$body$
language plpgsql;