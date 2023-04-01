create or replace function install.log_fk_no_indx_fnc(p_before_after varchar
                                                     ,p_ul_row       install.upgrade_log_row) returns text as
$body$
declare  
  v_result text;
  v_cnt    integer := 0;
  v_rec    install.log_fk_no_idx_delta_tbl%rowtype;
begin
  -- Логгирование списка FK без индексов во временную таблицу до/после поставки.
  v_result := install.write_log_inf('SYS REGISTRY', 'Logging all FK without index ' || p_before_after);
  insert into install.log_fk_no_idx_tmp_tbl
    (id_ul
    ,before_after
    ,schema
    ,table_name
    ,constraint_name)
    select p_ul_row.id_ul
          ,p_before_after
          ,schema
          ,table_name
          ,constraint_name
      from install.fk_no_index_vw;

  if p_before_after = 'after'
  then
    -- Считаем количество FK без индексов появившихся во время поставки
    select count(1)
      into v_cnt
      from (select ta.schema
                  ,ta.table_name
                  ,ta.constraint_name
              from install.log_fk_no_idx_tmp_tbl ta
             where ta.id_ul = p_ul_row.id_ul
               and ta.before_after = 'after' 
            except  
            select tb.schema
                   ,tb.table_name
                   ,tb.constraint_name
               from install.log_fk_no_idx_tmp_tbl tb
              where tb.id_ul = p_ul_row.id_ul
                and tb.before_after = 'before'
            ) tmp;
  
    -- Логгирование дельты (список_дельта = список_после_поставки - список_до_поставки) списка FK без индексов.    
    if v_cnt > 0
    --Отключаем предупреждения для поставки INSTALL 1.0.0
    and not (upper(p_ul_row.system_name) = 'INSTALL' and p_ul_row.system_version = '1.0.0')
    then
      v_result := v_result || chr(10) ||
                  install.write_log_inf('SYS REGISTRY',
                                        'Logging new FK without index (' || v_cnt || ') into delta table');
      insert into install.log_fk_no_idx_delta_tbl
        (id_ul
        ,schema
        ,table_name
        ,constraint_name)
        select p_ul_row.id_ul
              ,schema
              ,table_name
              ,constraint_name
          from (select ta.schema
                      ,ta.table_name
                      ,ta.constraint_name
                  from install.log_fk_no_idx_tmp_tbl ta
                 where ta.id_ul = p_ul_row.id_ul
                   and ta.before_after = 'after' 
                except  
                select tb.schema
                      ,tb.table_name
                      ,tb.constraint_name
                  from install.log_fk_no_idx_tmp_tbl tb
                 where tb.id_ul = p_ul_row.id_ul
                   and tb.before_after = 'before'
                ) tmp;
    
      
        --Выдаём предупреждение
        v_result := v_result || chr(10) ||
                    install.write_log_wrn('CHK FK NO INDEX',
                                          '!!! WARNING !!! Found FK without indexes (' || v_cnt || '):');
        for v_rec in (select *
                        from install.log_fk_no_idx_delta_tbl
                       where id_ul = p_ul_row.id_ul
                       order by schema, table_name, constraint_name)
        loop
          v_result := v_result || chr(10) || install.write_log_wrn('CHK FK NO INDEX',
                                                                   '    ' || v_rec.schema || '.' || v_rec.table_name || ' ' ||
                                                                   v_rec.constraint_name);
        end loop;
        v_result := v_result || chr(10) || install.write_log_wrn('CHK FK NO INDEX', 'For detail use select * from install.fk_no_index_vw');
    
    end if;
  
    -- Удаляем даные из временной таблицы, после записи в таблицу дельты они уже не нужны.
    -- v_result := v_result || chr(10) || install.write_log_inf('SYS REGISTRY', 'Clear temp table FK without indexes');
    delete from install.log_fk_no_idx_tmp_tbl
     where id_ul = p_ul_row.id_ul;
  
  end if;
  return v_result;
end;
$body$
language plpgsql;
