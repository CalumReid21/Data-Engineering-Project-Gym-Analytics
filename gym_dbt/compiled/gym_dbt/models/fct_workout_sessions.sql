with sets as (

    select *, row_number() over (partition by workout_exercise_id order by set_id) AS set_number

    from `project-e67aa17e-a684-4a34-a02`.`gym_dbt`.`stg_workouts`

),

pivoted as  (

    select
        workout_id,
        exercise,
        category,
        workout_start,
        workout_end,
        workout_exercise_id,

        max(case when set_number = 1 then weight end) as set_1_weight,
        max(case when set_number = 1 then reps end) as set_1_reps,

        max(case when set_number = 2 then weight end) as set_2_weight,
        max(case when set_number = 2 then reps end) as set_2_reps,

        max(case when set_number = 3 then weight end) as set_3_weight,
        max(case when set_number = 3 then reps end) as set_3_reps,

        max(case when set_number = 4 then weight end) as set_4_weight,
        max(case when set_number = 4 then reps end) as set_4_reps,

    from sets
    group by workout_id, exercise, category, workout_start, workout_end, workout_exercise_id

)

select * from pivoted