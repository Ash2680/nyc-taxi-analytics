with trips as (

    select * from {{ ref('int_trips_enriched') }}

),

final as (

    select
        {{ dbt_utils.generate_surrogate_key(['vendor_id', 'pickup_datetime', 'dropoff_datetime', 'pickup_location_id', 'dropoff_location_id', 'trip_distance', 'fare_amount', 'payment_type']) }} as trip_id,
        vendor_id,
        pickup_datetime,
        dropoff_datetime,
        cast(pickup_datetime as date) as pickup_date,
        pickup_location_id,
        dropoff_location_id,
        payment_type,
        payment_type_desc,
        rate_code,
        store_and_fwd_flag,

        passenger_count,
        trip_distance,
        trip_duration_minutes,
        pickup_hour,
        pickup_day_of_week,

        fare_amount,
        extra,
        mta_tax,
        tip_amount,
        tolls_amount,
        improvement_surcharge,
        airport_fee,
        total_amount
    from trips
    qualify row_number() over (
        partition by vendor_id, pickup_datetime, dropoff_datetime, pickup_location_id, dropoff_location_id, trip_distance, fare_amount, payment_type
        order by pickup_datetime
    ) = 1
)

select * from final