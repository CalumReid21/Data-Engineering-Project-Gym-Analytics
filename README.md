# Gym Analytics Pipeline

An end-to-end data engineering pipeline built with my own personal gym workout data. Data collected over 6 years with 13,000+ logged sets. The goal from this work was to demonstrate my ability to use a modern ELT stack.

## Architecture/Stack

1. Raw CSV (exported from RepCount - a workout iOS app)
2. dlt to BigQuery (gym_raw.workouts)
3. dbt (staging, tested)
4. marts: fct_workout_sessions (transforming granular by-set data into exercise level aggregates - for easier analysis)
5. Dagster (orchestrates dlt + dbt, scheduled to run at 6am daily

## Key Decisions

**Duplicate rows kept deliberately.**3 sets of 100kg (for example) would be represented as 3 separate rows.

**Rows with missing reps or weight dropped.** Investigated, but determined as insignificant input to overall dataset.

**Three surrogate keys added:** set_id, workout_id, workout_exercise id.

**Region consistency across tools.** dlt, dbt, and Dagster's BigQuery clients all require 'europe-west2' region. Not specifying this caused issues at several stages of building the pipeline.

## Sample insight

**Max Bench Press Weight by set number:**

Set 1: 120kg, Set 2: 120kg, Set 3: 110kg

**Longest streak of consecutive workouts (days).**

8 day streak