
    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select set_id
from `project-e67aa17e-a684-4a34-a02`.`gym_dbt`.`stg_workouts`
where set_id is null



  
  
      
    ) dbt_internal_test