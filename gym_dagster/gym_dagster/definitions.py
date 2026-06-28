from dagster import Definitions, define_asset_job, ScheduleDefinition
from dagster_dbt import DbtCliResource
from .assets import gym_dbt_assets, dbt_project, load_workouts_to_bigquery

gym_pipeline_job = define_asset_job(
    name="gym_pipeline_job",
    selection=[load_workouts_to_bigquery, gym_dbt_assets],
)

gym_pipeline_schedule = ScheduleDefinition(
    job=gym_pipeline_job,
    cron_schedule="0 6 * * *", # daily 6am
)

defs = Definitions(
    assets=[load_workouts_to_bigquery, gym_dbt_assets],
    schedules=[gym_pipeline_schedule],
    resources={
        "dbt": DbtCliResource(project_dir=dbt_project.project_dir),
    },
)
