from datetime import datetime, timedelta
from airflow import DAG
from airflow_dbt_cloud.operators.dbt import DbtCloudRunJobOperator

default_args = {
    "owner": "ash",
    "retries": 1,
    "retry_delay": timedelta(minutes=5),
}

with DAG(
    dag_id="dbt_taxi_pipeline",
    description="Triggers the dbt Cloud job for the NYC taxi analytics project",
    default_args=default_args,
    schedule="@daily",
    start_date=datetime(2026, 1, 1),
    catchup=False,
    tags=["dbt", "taxi-analytics"],
) as dag:

    trigger_dbt_cloud_job = DbtCloudRunJobOperator(
        task_id="trigger_dbt_cloud_job",
        dbt_cloud_conn_id="dbt_cloud_default",
        job_id=70506183140079,  # replace with your actual dbt Cloud Job ID
        wait_for_termination=True,
        timeout=600,
    )