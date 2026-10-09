{#
  Staging: customers.
  Light cleaning only — renames, type casts, and a derived full name.
  Grain: one row per customer.
 #}
select
    cast(customer_id as integer) as customer_id,
    first_name,
    last_name,
    first_name || ' ' || last_name as full_name,
    lower(email) as email,
    country,
    cast(signup_date as date) as signup_date
from {{ source('ecommerce', 'raw_customers') }}
