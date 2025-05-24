-- depends_on: {{ ref('stg_inventory_transactions') }}
{{ config(
    partition_by = {
        'field':'transaction_created_date',
        'data_type':'date'
    }
)}}

with source as(
    select
        id as inventory_id,
        transaction_type,
        date(transaction_created_date) as transaction_created_date,
        transaction_modified_date,
        product_id,
        quantity,
        purchase_order_id,
        customer_order_id,
        comments,
        current_timestamp() as insertion_timestamp
    from {{ ref('stg_inventory_transactions') }}
),
unique_source as(
    select
        *,
        row_number() over (partition by inventory_id) as rn
    from source
)
select
    *
except (rn)
from unique_source
where rn = 1