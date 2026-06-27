

  create or replace view `project-e67aa17e-a684-4a34-a02`.`gym_dbt`.`stg_workouts`
  OPTIONS()
  as with source as (

	select * from `project-e67aa17e-a684-4a34-a02`.`gym_raw`.`workouts`
),

renamed as (

	select
		workout_start,
		workout_end,
		exercise,
		weight,
		reps,
		category,
		trim(workout_name) as workout_name

	from source

),

cleaned as (

	select *
	from renamed
	where reps is not null and weight is not null

),

with_ids as (

	select
		*,
		dense_rank() over (order by workout_start, workout_end) as workout_id,
		row_number () over (order by workout_start,workout_end) as set_id

	from cleaned

),

exercise_first_set as (

	select
		*,
		min(set_id) over (partition by workout_id, exercise) as exercise_first_set_id

	from with_ids

),

final as (
	
	select
		*,
		dense_rank() over (
			order by workout_id, exercise_first_set_id
		) as workout_exercise_id
	from exercise_first_set

)

select * from final;

