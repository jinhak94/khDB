--1. 기술지원부에 속한 사람들의 사람의 이름, 부서코드, 급여를 출력하시오.
select emp_name 이름, dept_code 부서코드, salary 급여
from employee
where dept_code = (select dept_id
                   from department
                   where dept_title = '기술지원부');
             
select emp_name 이름, dept_code 부서코드, salary 급여      
from employee E
join department D
on E.dept_code = D.dept_id
where D.dept_title = '기술지원부';

--2. 기술지원부에 속한 사람들 중 가장 연봉이 높은 사람의 이름, 부서코드, 급여를 출력하시오.
select emp_name 이름, dept_code 부서코드, salary 급여
from employee
where salary = (select max(salary)
                from employee
                where dept_code = (select dept_id
                                   from department
                                   where dept_title = '기술지원부'));

--3. 매니저가 있는 사원 중에 월급이 전체 사원 평균을 넘는 사원의
-- 사번, 이름, 매니저 이름, 월급을 구하시오.
--3.1 JOIN을 이용하시오
--3.2 JOIN하지 않고, 스칼라상관쿼리(select)를 이용하기

--3.1 JOIN
select E1.emp_id 사번, E1.emp_name 이름, 
       (select emp_name from employee
       where emp_id = E1.manager_id) "매니저 이름", E1.salary 월급
from employee E1
    cross join (select avg(salary) avg 
                from employee) E2
where E1.manager_id is not null and E1.salary > E2.avg;

--3.2 스칼라상관쿼리
select E.emp_id 사번, E.emp_name 이름,
       (select emp_name from employee
       where emp_id = E.manager_id) "매니저 이름",
       E.salary 월급
from employee E
where E.manager_id is not null and E.salary > (select avg(salary) from employee);

--4. 같은 직급의 평균급여보다 같거나 많은 급여를 받는 
-- 직원의 이름, 직급코드, 급여, 급여등급 조회
select E.emp_name 이름, J.job_code 직급코드, 
       E.salary 급여, E.sal_level 급여등급
from employee E
        join job J
        on E.job_code = J.job_code
        cross join (select avg(salary) avg 
                from employee) E2
where salary > E2.avg;

--5. 부서별 평균 급여가 3000000 이상인 부서명, 평균 급여 조회
-- 단, 평균 급여는 소수점 버림, 부서명이 없는 경우 '인턴' 처리

select (select nvl(dept_title,'인턴') from department where E.dept_code = dept_id) 부서명,
        trunc(avg(salary)) "평균 급여"
from (select E.*
      from employee E) E
where (select trunc(avg(salary))
                from employee
                where E.dept_code = dept_code)>= 3000000
group by dept_code;
    
--6. 직급의 연봉 평균보다 적게 받는 여자 사원의
-- 사원명, 직급명, 부서명, 연봉을 이름 오름차순으로 조회하시오
-- 연봉 계산 = (급여 + (급여 * 보너스)) * 12

select emp_name 사원명, 
       (select job_name from job where job_code = E.job_code) 직급명,
       (select dept_title from department where dept_id = E.dept_code) 부서명,
       (salary + (salary * nvl(bonus,1))) * 12 연봉
from (select E.*, decode(substr(emp_no,8,1),'1','남','3','남','여') gender
      from employee E) E
where gender = '여' and salary < 
            (select trunc(avg(salary))
             from employee
             where E.job_code = job_code);
                           

--7. 다음 도서목록테이블을 생성하고, 공저인 도서만 출력하세요.

create table tbl_books (
book_title  varchar2(50)
,author     varchar2(50)
,loyalty     number(5)
);

insert into tbl_books values ('반지나라 해리포터', '박나라', 200);
insert into tbl_books values ('대화가 필요해', '선동일', 500);
insert into tbl_books values ('나무', '임시환', 300);
insert into tbl_books values ('별의 하루', '송종기', 200);
insert into tbl_books values ('별의 하루', '윤은해', 400);
insert into tbl_books values ('개미', '장쯔위', 100);
insert into tbl_books values ('아지랑이 피우기', '이오리', 200);
insert into tbl_books values ('아지랑이 피우기', '전지연', 100);
insert into tbl_books values ('삼국지', '노옹철', 200);

select distinct book_title
from tbl_books B1
where book_title in (select book_title
                    from tbl_books B2
                    where B1.book_title = B2.book_title
                    and B1.author <> B2.author);



