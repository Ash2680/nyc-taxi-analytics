with source as (
    select * from {{ source('raw_taxi', 'yellow_trips') }}
),

renamed as (
    select
        vendor_id,
        pickup_datetime,
        dropoff_datetime,
        passenger_count,
        trip_distance,
        rate_code,
        store_and_fwd_flag,
        payment_type,
        cast(pickup_location_id as int64) as pickup_location_id,
        cast(dropoff_location_id as int64) as dropoff_location_id,
        fare_amount,
        extra,
        mta_tax,
        tip_amount,
        tolls_amount,
        imp_surcharge as improvement_surcharge,
        airport_fee,
        total_amount
    from source

)

select * from renamed