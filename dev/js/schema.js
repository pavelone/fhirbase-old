// Generated by CoffeeScript 1.6.3
(function() {
  var e, log, self;

  self = this;

  log = function(mess) {
    return plv8.elog(NOTICE, JSON.stringify(mess));
  };

  e = function() {
    log(arguments[0]);
    return plv8.execute.apply(plv8, arguments);
  };

  this.sql = {
    generate_schema: function(version) {
      var schema;
      schema = "fhirr";
      e("DROP SCHEMA IF EXISTS " + schema + " CASCADE;\nCREATE SCHEMA " + schema + ";");
      e("SELECT * from meta.enums").forEach(function(en) {
        var opts;
        opts = en.options.map(function(i) {
          return "'" + i + "'";
        }).join(',');
        return e("CREATE TYPE " + schema + ".\"" + en["enum"] + "\" AS ENUM (" + opts + ")");
      });
      e("CREATE TABLE " + schema + ".resource (\n   id uuid PRIMARY KEY,\n   resource_type " + schema + ".\"ResourceType\" not null,\n   language varchar,\n   text xml,\n   text_status " + schema + ".\"NarrativeStatus\",\n   container_id uuid references " + schema + ".resource (id)\n);\n\nCREATE TABLE " + schema + ".resource_component (\n  id uuid PRIMARY KEY,\n  parent_id uuid references " + schema + ".resource_component (id),\n  resource_id uuid references " + schema + ".resource (id),\n  resource_compontent_type varchar,\n  container_id uuid references " + schema + ".resource (id)\n);\n\nCREATE TABLE " + schema + ".resource_value (\n  id uuid PRIMARY KEY,\n  parent_id uuid references " + schema + ".resource_component (id),\n  resource_id uuid references " + schema + ".resource (id),\n  resource_value_type varchar,\n  container_id uuid references " + schema + ".resource (id)\n);");
      e("select * from meta.datatype_ddl where table_name not in ('resource') ").forEach(function(tbl) {
        return e("CREATE TABLE " + schema + "." + tbl.table_name + " (\n  " + (tbl.columns && tbl.columns.join(',')) + "\n) INHERITS (" + schema + "." + tbl.base_table + ")");
      });
      return e("select * from meta.resource_tables").forEach(function(tbl) {
        return e("CREATE TABLE " + schema + "." + tbl.table_name + " (\n  " + tbl.columns + "\n) INHERITS (" + schema + "." + tbl.base_table + ")");
      });
    }
  };

}).call(this);
