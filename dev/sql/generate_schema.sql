CREATE OR REPLACE FUNCTION generate_schema2(schema TEXT, version TEXT)
  RETURNS VOID LANGUAGE plpythonu AS $$

  def exe(query):
    return plpy.execute(query)

  def create_object(func, query):
    return map(func, exe(query))

  def q(literal):
    return '"%s"' % literal

  def make_columns(e):
    if 'columns' in e:
      cols = map(lambda c: '%s' % c, e['columns'])
      return ",\n".join(cols)
    else:
      return ''

  def make_enums(en):
    return "CREATE TYPE %(schema)s.%(enum)s AS ENUM (%(opts)s)" % {
      "schema": schema,
      "enum": q(en['enum']),
      "opts": ','.join(map(lambda i: "'%s'" % i, en['options'])) }

  def make_datatypes(e):
    return """
      CREATE TABLE %(schema)s.%(table)s (
        %(columns)s
      ) INHERITS (%(schema)s.%(base_table)s)""" % {
      "schema": schema,
      "table": e['table_name'],
      "base_table": e['base_table'],
      "columns": make_columns(e) }

  def make_resources(e):
    return """
      CREATE TABLE %(schema)s.%(table)s (
        %(columns)s
      ) INHERITS (%(schema)s.%(base_table)s);

      ALTER TABLE %(schema)s.%(table)s
        ALTER COLUMN _type SET DEFAULT '%(table)s';
      """ % {
      "schema": schema,
      "table": e['table_name'],
      "base_table": e['base_table'],
      "columns": make_columns(e) }

  queries = [
    "DROP SCHEMA IF EXISTS %s CASCADE" % schema,
    "CREATE SCHEMA %s" % schema,
    """
    CREATE TABLE %(schema)s.resource (
      id UUID PRIMARY KEY,
      _type VARCHAR NOT NULL,
      _unknown_attributes json,
      resource_type varchar,
      language VARCHAR,
      container_id UUID REFERENCES %(schema)s.resource (id)
    );

    CREATE TABLE %(schema)s.resource_component (
     id uuid PRIMARY KEY,
     _type VARCHAR NOT NULL,
     _unknown_attributes json,
     parent_id UUID NOT NULL REFERENCES %(schema)s.resource_component (id),
     resource_id UUID NOT NULL REFERENCES %(schema)s.resource (id),
     container_id UUID REFERENCES %(schema)s.resource (id)
    );
    """ % { "schema": schema }
  ]

  queries += create_object(make_enums, "SELECT * FROM meta.enums")
  queries += create_object(make_datatypes, "SELECT * FROM meta.datatype_tables WHERE table_name NOT IN ('resource', 'backbone_element')")
  queries += create_object(make_resources, "SELECT * FROM meta.resource_tables")
  for query in queries:
    #plpy.notice(query)
    exe(query)
$$;

select generate_schema2('fhir'::text, '0.12'::text);