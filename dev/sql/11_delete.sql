CREATE OR REPLACE
FUNCTION fhir.delete_resource(_logical_id uuid)
  returns void
  language sql
  as $$
  DELETE FROM fhir.resource WHERE _logical_id = delete_resource._logical_id;
$$;
