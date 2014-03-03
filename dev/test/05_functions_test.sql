--db:testfhir
--{{{
\ir '00_spec_helper.sql'
\ir ../sql/01_extensions.sql
\ir ../sql/02_py_init.sql
\ir ../sql/03_meta.sql
\ir ../sql/04_load_meta.sql
\ir ../sql/05_functions.sql

BEGIN;
SELECT plan(7);

SELECT is(
  (SELECT fhir.array_last(ARRAY['a','b','c'])),
  'c',
  'fhir.array_last'
);

SELECT is(
  (SELECT fhir.array_pop(ARRAY['a','b','c'])),
  ARRAY['a','b']::varchar[],
  'fhir.array_pop'
);

SELECT is(
  (SELECT fhir.table_name(ARRAY['a','b','c']::varchar[])),
  'a_b_c',
  'table_name'
);

SELECT is(
  (SELECT fhir.table_name(ARRAY['abay','baran','cidr']::varchar[])),
  'abay_baran_cidr',
  'table_name'
);

SELECT is(
  (SELECT fhir.table_name(ARRAY['schedule.repeat']::varchar[])),
  'schedulerepeat',
  'table_name'
);

SELECT is(
  (SELECT fhir.table_name(ARRAY['xang','abay','baran','cidr']::varchar[])),
  'xang_abay_baran_cidr',
  'table_name'
);

SELECT is(
  fhir.merge_json('{"a": 42, "b": 12}'::json, '{"c": 55}'::json)::varchar,
  '{"a": 42, "c": 55, "b": 12}'::json::varchar,
  'fhir.merge_json'
);

SELECT * FROM finish();
ROLLBACK;
--}}}