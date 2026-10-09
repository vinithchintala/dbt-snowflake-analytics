{#--
  Use the configured schema name verbatim instead of dbt's default
  <target_schema>_<custom_schema> prefixing, so models land in clean
  `staging` / `intermediate` / `marts` schemas.
--#}
{% macro generate_schema_name(custom_schema_name, node) -%}
    {{ custom_schema_name if custom_schema_name else target.schema }}
{%- endmacro %}
