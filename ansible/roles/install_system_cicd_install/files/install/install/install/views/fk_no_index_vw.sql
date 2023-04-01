create or replace view install.fk_no_index_vw as
select nsp.nspname as schema,
       tbl.relname as table_name, 
       c.conname as constraint_name,
       /* list of key column names in order */
       string_agg(a.attname, ',' order by x.n) as columns
from pg_catalog.pg_constraint c
join pg_catalog.pg_class tbl on tbl.oid = c.conrelid
join pg_catalog.pg_namespace nsp on nsp.oid = c.connamespace 
/* enumerated key column numbers per foreign key */
cross join lateral unnest(c.conkey) with ordinality as x(attnum, n)
/* name for each key column */
join pg_catalog.pg_attribute a on a.attnum = x.attnum and a.attrelid = c.conrelid
where c.contype = 'f' 
  and not exists
  /* is there a matching index for the constraint? */
  (select 1 from pg_catalog.pg_index i
    where i.indrelid = c.conrelid
    /* it must not be a partial index */
      and i.indpred is null
      /* the first index columns must be the same as the key columns, but order doesn't matter */
      and (i.indkey::smallint[])[0:cardinality(c.conkey)-1] operator(pg_catalog.@>) c.conkey)
group by nsp.nspname, tbl.relname, c.conname;

