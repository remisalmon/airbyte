
      

  
    create table test_normalization.renamed_dedup_cdc_excluded_scd
    
  
    
    engine = MergeTree()
    
    order by (tuple())
    
  as (
    
with

input_data as (
    select *
    from _airbyte_test_normalization.renamed_dedup_cdc_excluded_ab3
    -- renamed_dedup_cdc_excluded from test_normalization._airbyte_raw_renamed_dedup_cdc_excluded
),

input_data_with_active_row_num as (
    select *,
      row_number() over (
        partition by id
        order by
            _airbyte_emitted_at is null asc,
            _airbyte_emitted_at desc,
            _airbyte_emitted_at desc
      ) as _airbyte_active_row_num
    from input_data
),
scd_data as (
    -- SQL model to build a Type 2 Slowly Changing Dimension (SCD) table for each record identified by their primary key
    select
      assumeNotNull(hex(MD5(
            
                toString(id)
            
    ))) as _airbyte_unique_key,
        id,
      _airbyte_emitted_at as _airbyte_start_at,
      anyOrNull(_airbyte_emitted_at) over (
        partition by id
        order by
            _airbyte_emitted_at is null asc,
            _airbyte_emitted_at desc,
            _airbyte_emitted_at desc
        ROWS BETWEEN 1 PRECEDING AND 1 PRECEDING
      ) as _airbyte_end_at,
      case when _airbyte_active_row_num = 1 then 1 else 0 end as _airbyte_active_row,
      _airbyte_ab_id,
      _airbyte_emitted_at,
      _airbyte_renamed_dedup_cdc_excluded_hashid
    from input_data_with_active_row_num
),
dedup_data as (
    select
        -- we need to ensure de-duplicated rows for merge/update queries
        -- additionally, we generate a unique key for the scd table
        row_number() over (
            partition by _airbyte_unique_key, _airbyte_start_at, _airbyte_emitted_at
            order by _airbyte_ab_id
        ) as _airbyte_row_num,
        assumeNotNull(hex(MD5(
            
                toString(_airbyte_unique_key) || '~' ||
            
            
                toString(_airbyte_start_at) || '~' ||
            
            
                toString(_airbyte_emitted_at)
            
    ))) as _airbyte_unique_key_scd,
        scd_data.*
    from scd_data
)
select
    _airbyte_unique_key,
    _airbyte_unique_key_scd,
        id,
    _airbyte_start_at,
    _airbyte_end_at,
    _airbyte_active_row,
    _airbyte_ab_id,
    _airbyte_emitted_at,
    now() as _airbyte_normalized_at,
    _airbyte_renamed_dedup_cdc_excluded_hashid
from dedup_data where _airbyte_row_num = 1
  )
  