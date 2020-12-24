--@실습문제

--1. 2020년 12월 25일이 무슨 요일인지 조회하시오.
select to_char(to_date('2020-12-25'),'day') "2020년 12월 25일"
from dual;

--2. 주민번호가 70년대 생이면서 성별이 여자이고, 
--성이 전씨인 직원들의 
--사원명, 주민번호, 부서명, 직급명을 조회하시오.
desc employee; 
desc department;
select emp_name 사원명, emp_no 주민번호, D.dept_title 부서명, j.job_name 직급명
from employee E join department D
        on E.dept_code = D.dept_id
        join job J
        on E.job_code = J.job_code
where emp_name like '전%' and
        substr(emp_no,8,1) in ('2','4');

--3. 가장 나이가 적은 직원의 사번, 사원명, 나이, 부서명, 직급명을 조회하시오.
select emp_id 사번, emp_name 사원명, extract(year from sysdate)-('20'||substr(emp_no,1,2))+1 나이,  D.dept_title, J.job_name
from employee E1 join department D
        on E1.dept_code = D.dept_id
        join job J
        on E1.job_code = J.job_code
where decode(substr(emp_no,1,2), '1', '19'||substr(emp_no,1,2),
            '2', '19'||substr(emp_no,1,2),
            '20'||substr(emp_no,1,2))
            = (select max(decode(substr(emp_no,8,1), '1', '19'||substr(emp_no,1,2), 
        '2', '19'||substr(emp_no,1,2),
        '20'||substr(emp_no,1,2)))
        from employee);
        

--4. 이름에 '형'자가 들어가는 직원들의 사번, 사원명, 부서명을 조회하시오.
select E.emp_no 사번, E.emp_name 사원명, D.dept_title 부서명
from employee E
        join department D
        on E.dept_code = D.dept_id
where E.emp_name like '%형%';



--5. 해외영업팀에 근무하는 사원명, 직급명, 부서코드, 부서명을 조회하시오.
select E.emp_name 사원명, j.job_name 직급명, e.dept_code 부서코드, d.dept_title 부서명
from employee E
    join department D
    on E.dept_code = D.dept_id
    join job J
    on E.job_code = J.job_code
where D.dept_title like '해외영업%';

--6. 보너스포인트를 받는 직원들의 사원명, 보너스포인트, 부서명, 근무지역명을 조회하시오.
select E.emp_name 사원명, E.bonus 보너스포인트, d.dept_title 부서명, l.local_name 근무지역명
from employee E
    join department D
    on E.dept_code = D.dept_id
    join location L
    on D.location_id = l.local_code
where bonus is not null;
--7. 부서코드가 D2인 직원들의 사원명, 직급명, 부서명, 근무지역명을 조회하시오.
select E.emp_name 사원명, J.job_name 직급명, D.dept_title 부서명, L.local_name 근무지역명
from employee E
    join job J
    on E.job_code = J.job_code
    join department D
    on E.dept_code = D.dept_id
    join location L
    on D.location_id = L.local_code
where dept_code = 'D2';

--8. 급여등급테이블의 등급별 최대급여(MAX_SAL)보다 많이 받는 직원들의 사원명, 직급명, 급여, 연봉을 조회하시오.
--(사원테이블과 급여등급테이블을 SAL_LEVEL컬럼기준으로 동등 조인할 것)
select E.emp_name 사원명, J.job_name 직급명, E.salary 급여, (E.salary + (E.salary * nvl(bonus,0)))*12 연봉
from employee E
    join job J
    on E.job_code = J.job_code
    join sal_grade S
    on E.sal_level = S.sal_level
where E.salary > S.max_sal;

--9. 한국(KO)과 일본(JP)에 근무하는 직원들의 
--사원명, 부서명, 지역명, 국가명을 조회하시오.
select E.emp_name 사원명, D.dept_title 부서명, L.local_name 지역명, N.national_name 국가명
from employee E
        join department D
        on E.dept_code = D.dept_id
        join location L
        on D.location_id = L.local_code
        join nation N
        on L.national_code = N.national_code
where N.national_code in ('KO','JP');        
    
--10. 같은 부서에 근무하는 직원들의 사원명, 부서코드, 동료이름을 조회하시오.
--self join 사용
select E1.emp_name 사원명, E1.dept_code 부서코드, E2.emp_name 동료이름
from employee E1
            join employee E2 
            on E1.dept_code = E2.dept_code
            join department D
            on E1.dept_code = D.dept_id
where E1.emp_name != E2.emp_name
order by 1;
            
--11. 보너스포인트가 없는 직원들 중에서 직급이 차장과 사원인 직원들의 사원명, 직급명, 급여를 조회하시오.
select E.emp_name 사원명, J.job_name 직급명, E.salary 급여
from employee E
    join job J
    on E.job_code = J.job_code
where E.bonus is null and J.job_name in ('차장','사원');
    
    
--12. 재직중인 직원과 퇴사한 직원의 수를 조회하시오.
select decode(quit_yn, 'N', '재직중', 'Y', '퇴직') 재직여부, count(quit_yn) 인원수 
from employee
group by decode(quit_yn, 'N', '재직중', 'Y', '퇴직');

select count(decode(quit_yn, 'N', '1', null)) 재직중, count(decode(quit_yn, 'Y','1', null)) 퇴사
from employee;



