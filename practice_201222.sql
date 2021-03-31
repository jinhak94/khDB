--@함수실습문제

--1. 직원명과 이메일, 이메일 길이를 출력하시오
select emp_name 이름, email 이메일, length(email) 이메일길이
from employee;

--2. 직원의 이름과 이메일 주소중 아이디 부분만 출력하시오
select emp_name 이름, substr(email,1,instr(email,'@')-1) 아이디
from employee;

--3. 60년대에 태어난 직원명과 년생, 보너스 값을 출력하시오
select emp_name 직원명, 19||substr(emp_no,1,2) 년생, nvl(bonus,0) 보너스
from employee
where substr(emp_no,1,1)='6';

--4. '010' 핸드폰 번호를 쓰지 않는 사람의 수를 출력하시오 
-- (뒤에 단위는 명을 붙이시오)
select count(*)||'명' 인원수
from employee
where substr(phone,1,3)<>'010';

--5. 직원명과 입사년월을 출력하시오.
-- 단, 아래와 같이 출력되도록 만들어보시오
--  직원명          입사년월
--  전형돈          2012년 12월
select emp_name 직원명, 
    extract(year from hire_date)||'년 '||
    extract(month from hire_date)||'월' 입사년월
from employee;

--6. 직원명과 주민번호를 조회하시오
-- 단, 주민번호 9번째 자리부터 끝까지는 '*'문자로 채워서 출력하시오
-- ex) 홍길동 771120-1******
select emp_name 직원명, rpad(substr(emp_no,1,8), 14, '*') 주민번호
from employee;

--7. 직원명, 직급코드, 연봉(원) 조회
--단, 연봉은 \57,000,000으로 표시되게 함
-- 연봉은 보너스 포인트가 적용된 1년치 급여임
select emp_name 직원명, job_code 직급코드, to_char((salary +(salary * nvl(bonus,1)))*12, 'l9,999,999,999') "연봉(원)"
from employee;

--8. 부서코드가 D5, D9인 직원들 중에서 
--2004년도에 입사한 직원 중에 조회함.
--사번 사원명 부서코드 입사일
select emp_id 사번, emp_name 사번명, dept_code 부서코드, hire_date 입사일
from employee
where dept_code in ('D5','D9') and substr(hire_date,1,2)='04';

--9. 직원명, 입사일, 오늘까지의 근무일수 조회
--*주말도 포함, 소수점 아래는 버림
select emp_name 직원명, hire_date 입사일, trunc(sysdate-hire_date) 근무일수
from employee;

--10. 직원명, 부서코드, 생년월일, 나이(만) 조회
--단, 생년월일은 주민번호에서 추출해서,
--0000년 00월 00일로 출력되게 함.
--나이는 주민번호에서 추출해서 날짜데이터로 변환한 다음, 계산함
select emp_no from employee;
select extract(month from sysdate) from dual;
select emp_name 직원명, dept_code 부서코드,
    case
    when substr(emp_no,8,1) in ('1','2') then 1900
    else 2000
    end + substr(emp_no,1,2)||'년' || substr(emp_no,3,2)||'월' || substr(emp_no,5,2)||'일' "생년월일",
    extract(year from sysdate) - (case
    when substr(emp_no,8,1) in ('1','2') then 1900
    else 2000
    end + substr(emp_no,1,2))
     - (case
        when (extract(month from sysdate) - substr(emp_no,3,2)=0) and (extract(day from sysdate) - substr(emp_no,5,2)<0) then 1
        when (extract(month from sysdate) - substr(emp_no,3,2)<0) then 1
        else 0
    end) "만 나이"
from employee;

--11. 직원들의 입사일로부터 년도만 가지고, 
--각 년도별 입사인원수를 구하시오.
--아래의 년도에 입사한 인원수를 조회하시오.
--마지막으로 전체직원수도 구하시오.
--> decode, sum 사용

-- 더 나은 방식 있는지 고민...
select sum(nvl(decode(substr(hire_date,1,2),'98',1),0)) "1998년",
       sum(nvl(decode(substr(hire_date,1,2),'99',1),0)) "1999년",
       sum(nvl(decode(substr(hire_date,1,2),'00',1),0)) "2000년",
       sum(nvl(decode(substr(hire_date,1,2),'01',1),0)) "2001년",
       sum(nvl(decode(substr(hire_date,1,2),'02',1),0)) "2002년",
       sum(nvl(decode(substr(hire_date,1,2),'03',1),0)) "2003년",
       sum(nvl(decode(substr(hire_date,1,2),'04',1),0)) "2004년",
       sum(nvl(decode(substr(hire_date,1,2),'전체',1,1),0)) "전체직원수"
from employee;

--12. 부서코드가 D5이면 총무부, D6이면 기획부, 
--D9이면 영업부로 처리하시오. (case 사용)
--단, 부서코드가 D5, D6, D9인 직원의 정보만 조회하고,
--부서코드 기준으로 오름차순 정렬함.
select emp_name 직원명, case
    when dept_code='D5' then '총무부'
    when dept_code='D6' then '기획부'
    when dept_code='D9' then '영업부'
    end 부서
from employee
where dept_code in ('D5','D6','D9')
order by dept_code;







