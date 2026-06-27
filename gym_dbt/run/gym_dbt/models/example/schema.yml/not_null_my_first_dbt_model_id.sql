
    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select id
from `project-e67aa17e-a684-4a34-a02`.`gym_dbt`.`my_first_dbt_model`
where id is null



  
  
      
    ) dbt_internal_test