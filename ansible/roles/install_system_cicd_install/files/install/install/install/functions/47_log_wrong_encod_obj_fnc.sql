create or replace function install.log_wrong_encod_obj_fnc(p_before_after varchar
                                                          ,p_ul_row       install.upgrade_log_row) returns text as
$body$
declare  
  v_result text;
  v_cnt    integer := 0;
  v_rec    install.log_wrong_encod_obj_delta_tbl%rowtype;
begin
  -- Логгирование списка хранимых процедур с символами в неверной кодировке во временную таблицу до/после поставки.
  v_result := install.write_log_inf('SYS REGISTRY',
                                    'Logging all stored procedures with wrong encoding ' || p_before_after);
  insert into install.log_wrong_encod_obj_tmp_tbl
    (id_ul
    ,before_after
    ,schema
    ,name
    ,type)
    select p_ul_row.id_ul
          ,p_before_after
          ,schema
          ,name
          ,type
      from install.wrong_encod_obj_vw;

  if p_before_after = 'after'
  then
    -- Считаем количество хранимых процедур с символами в неверной кодировке появившихся во время поставки
    select count(1)
      into v_cnt
      from (select ta.schema
                  ,ta.name
                  ,ta.type
              from install.log_wrong_encod_obj_tmp_tbl ta
             where ta.id_ul = p_ul_row.id_ul
               and ta.before_after = 'after' 
            except  
            select tb.schema
                  ,tb.name
                  ,tb.type
              from install.log_wrong_encod_obj_tmp_tbl tb
             where tb.id_ul = p_ul_row.id_ul
               and tb.before_after = 'before'
            ) tmp;
  
    -- Логгирование дельты (список_дельта = список_после_поставки - список_до_поставки) объектов с неверной кодировкой.    
    if (v_cnt > 0)
    --Отключаем предупреждения для поставки INSTALL 1.0.0
    and not (upper(p_ul_row.system_name) = 'INSTALL' and p_ul_row.system_version = '1.0.0') 
    then
      v_result := v_result || chr(10) || install.write_log_inf('SYS REGISTRY',
                                                               'Logging new stored procedures with wrong encoding (' ||
                                                               v_cnt || ') into delta table');
      insert into install.log_wrong_encod_obj_delta_tbl
        (id_ul
        ,schema
        ,name
        ,type)
        select p_ul_row.id_ul
              ,schema
              ,name
              ,type
          from (select ta.schema
                      ,ta.name
                      ,ta.type
                  from install.log_wrong_encod_obj_tmp_tbl ta
                 where ta.id_ul = p_ul_row.id_ul
                   and ta.before_after = 'after' 
                except    
                select tb.schema
                      ,tb.name
                      ,tb.type
                  from install.log_wrong_encod_obj_tmp_tbl tb
                 where tb.id_ul = p_ul_row.id_ul
                   and tb.before_after = 'before'
                ) tmp;

        --Выдаём предупреждение cо списком
        v_result := v_result || chr(10) ||
                    install.write_log_err('CHK NEW WRG ENC',
                                          '!!! WARNING !!! Found new objects with wrong encoding (' || v_cnt || '):');
        for v_rec in (select *
                        from install.log_wrong_encod_obj_delta_tbl
                       where id_ul = p_ul_row.id_ul
                       order by schema, name, type)
        loop
          v_result := v_result || chr(10) ||
                      install.write_log_err('CHK NEW WRG ENC',
                                            '    ' || v_rec.type || ' ' || v_rec.schema || '.' || v_rec.name);
        end loop;
        v_result := v_result || chr(10) || install.write_log_err('CHK NEW WRG ENC', 'For detail use select * from install.wrong_encod_obj_lines_vw');
   
    end if;
  
    -- Удаляем даные из временной таблицы, после записи в таблицу дельты они уже не нужны.
    -- v_result := v_result || chr(10) || install.write_log_inf('SYS REGISTRY', 'Clear temp table object with wrong encoding');
    delete from install.log_wrong_encod_obj_tmp_tbl
     where id_ul = p_ul_row.id_ul;
  
  end if;
  return v_result;

end;
$body$
language plpgsql;