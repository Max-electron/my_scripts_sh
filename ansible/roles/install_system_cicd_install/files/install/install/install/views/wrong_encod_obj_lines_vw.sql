create or replace view install.wrong_encod_obj_lines_vw as
select schema
      ,name
      ,type
      ,source
  from (select ns.nspname as schema
              ,pr.proname as name
              ,case pr.prokind
                 when 'p' then
                  'procedure'
                 else
                  'function'
               end as type
              ,replace(translate(pr.prosrc,
                                 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789АБВГДЕЁЖЗИЙКЛМНОПРСТУФХЦЧШЩЪЫЬЭЮЯабвгдеёжзийклмнопрстуфхцчшщъыьэюя,.:;!?()[]{}<>«»/|\–=-+—№%$*#@_~“”"‘`^•¤' ||
                                 /*chr(0) ||*/
                                  chr(1) || chr(2) || chr(3) || chr(4) || chr(5) || chr(6) || chr(7) || chr(8) || chr(9) ||
                                  chr(10) || chr(11) || chr(12) || chr(13) || chr(27) || chr(38) || chr(39) || chr(160),
                                 ' '),
                       ' ',
                       '') as source
          from pg_catalog.pg_proc pr
          join pg_catalog.pg_namespace ns on pr.pronamespace = ns.oid) x
 where x.source != '' 
 order by x.schema
         ,x.name
         ,x.type;

comment on view install.wrong_encod_obj_lines_vw
  is 'Cписок хранимых процедур содержащих символы с неверной кодировкой.';
comment on column install.wrong_encod_obj_lines_vw.schema
  is 'Схема';
comment on column install.wrong_encod_obj_lines_vw.name
  is 'Название хранимой процедуры';  
comment on column install.wrong_encod_obj_lines_vw.type
  is 'Тип хранимой процедуры';
comment on column install.wrong_encod_obj_lines_vw.source
  is 'Символы в неверной кодировке найденные в коде функции'; 
