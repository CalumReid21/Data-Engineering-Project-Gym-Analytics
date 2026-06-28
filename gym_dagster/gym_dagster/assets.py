import os
import pandas as pd
import dlt
from dagster import asset, AssetExecutionContext, MaterializeResult
from dagster_dbt import DbtCliResource, dbt_assets, DbtProject

@asset(key=["gym_raw", "workouts"])
def load_workouts_to_bigquery(context: AssetExecutionContext) -> MaterializeResult:
    df = pd.read_csv(r"C:\Users\calum\gym-analytics\staged_workouts.csv")

    pipeline = dlt.pipeline(
        pipeline_name="gym",
        destination=dlt.destinations.bigquery(location="europe-west2"),
        dataset_name="gym_raw",
    )

    load_info = pipeline.run(df.to_dict(orient="records"), table_name="workouts")
    
    context.log.info(str(load_info))
    
    return MaterializeResult(
        metadata={
            "rows_loaded": len(df)
        }
    )

dbt_project = DbtProject(
    project_dir=os.path.join(os.path.dirname(__file__), "..", "..", "gym_dbt"),
)

dbt_project.prepare_if_dev()

@dbt_assets(manifest=dbt_project.manifest_path)
def gym_dbt_assets(context: AssetExecutionContext, dbt: DbtCliResource):
    yield from dbt.cli(["build"], context=context).stream()