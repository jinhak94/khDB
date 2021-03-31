desc employee;
--1.
select emp_name, salary*12, 
       salary + (salary * nvl(bonus,0)) as total_salary,
        salary + (salary * nvl(bonus,0))-(salary * 0.03) as real_salary 
from employee;

--2. 
select emp_name, hire_date, round(sysdate-hire_date)
from employee;

commit;




