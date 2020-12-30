-- 1. 영어영문학과(학과코드 002) 학생들의 학번과 이름, 입학년도를
-- 입학년도가 빠른 순으로 표시하는 SQL 문장을 작성하시오.
-- 단, 헤더는 '학번','이름','입학년도'가 표시되도록 한다.

--rank
select E.학번, E.이름, E.입학년도
from 
        (select student_no 학번, student_name 이름, 
        to_char(entrance_date,'yyyy-mm-dd') 입학년도,
        rank() over(order by extract(year from entrance_date)) rank
        from tb_student
        where department_no = '002'
        ) E
order by rank;
        
select student_no 학번, student_name 이름, 
        to_char(entrance_date,'yyyy-mm-dd') 입학년도
from tb_student
where department_no = '002'
order by extract(year from entrance_date) asc;

--2. 춘 기술대학교의 교수 중 이름이 세 글자가 아닌 교수가 한 명 있다고 한다.
-- 그 교수의 이름과 주민번호를 화면에 출력하는 SQL 문장을 작성해보자
-- 이 때 올바르게 작성한 SQL 문장의 결과 값이 예상과 다르게 나올 수 있다.
--원인이 무엇일지 생각해 볼 것.

select professor_name 교수명, professor_ssn 주민번호
from tb_professor
where length(professor_name) <> 3;

--3. 춘 기술대학교의 남자 교수들의 이름과 나이를 출력하는 SQL 문장을
-- 완성하시오. 단 이 때, 나이가 적은 사람에서 많은 사람 순서로 화면에
-- 출력되도록 만드시오. (단, 교수 중 2000년 이후 출생자는 없으며,
-- 출력 헤더는 "교수이름", "나이"로 한다. 나이는 '만'으로 계산한다.)

select professor_name 교수이름, 
       extract(year from sysdate)
        - (decode(substr(professor_ssn,8,1),'1',1900,'2',1900,2000)
        + substr(professor_ssn,1,2))
       -(case
            when (extract(month from sysdate) 
            - substr(professor_ssn,3,2)=0) 
            and (extract(day from sysdate) 
            - substr(professor_ssn,5,2)<0) then 1
            
            when (extract(month from sysdate) 
            - substr(professor_ssn,3,2)<0) then 1
        else 0
    end)
    나이
from tb_professor
where decode(substr(professor_ssn,8,1),'1','남','3','남','여') = '남'
order by 2 asc;

--4. 교수들의 이름 중 성을 제외한 이름만 출력하는 SQL 문장을 작성하시오.
-- 출력 헤더는 "이름"이 찍히도록 한다.

select substr(professor_name, 2) 이름
from tb_professor;

--5. 춘 기술대학교의 재수생 입학자를 구하려고 한다. 어떻게 찾아낼 것인가?
-- 이 때, 19살에 입학하면 재수를 하지 않은 것으로 간주한다.

select student_no 학번, student_name 성명
from tb_student
where  extract(year from entrance_date)
        - (decode(substr(student_ssn,8,1),'1',1900,'2',1900,2000)
        + substr(student_ssn,1,2)) > 19;

--6. 2020년 크리스마스는 무슨 요일인가?
select to_char(to_date('20201225'),'day') 요일
from dual;

--7. to_date('99/10/11', 'YY/MM/DD'), 
--   to_date('49/10/11', 'YY/MM/DD')은 
--   각각 몇 년 몇 월 몇 일을 의미할까? 
--   또 to_date('99/10/11', 'RR/MM/DD'),
--   to_date('49/10/11', 'RR/MM/DD')은 
--   각각 몇 년 몇 월 몇일을 의미할까?

select to_char(TO_DATE('99/10/11'),'YYYY"년"MM"월"DD"일"') "99/10/11,YY/MM/DD",
       to_char(TO_DATE('49/10/11'),'RRRR"년"MM"월"DD"일"') "49/10/11,YY/MM/DD",
       to_char(TO_DATE('99/10/11'),'YYYY"년"MM"월"DD"일"') "99/10/11,RR/MM/DD",
       to_char(TO_DATE('49/10/11'),'RRRR"년"MM"월"DD"일"') "49/10/11,RR/MM/DD"
from dual; -- 1999


select extract(year from to_date('99/10/11', 'YY/MM/DD'))||'년' ||
       extract(month from to_date('99/10/11', 'YY/MM/DD'))||'월'||
       extract(day from to_date('99/10/11', 'YY/MM/DD'))||'일' "99/10/11,YY/MM/DD",
       
       extract(year from to_date('49/10/11', 'YY/MM/DD'))||'년' ||
       extract(month from to_date('49/10/11', 'YY/MM/DD'))||'월'||
       extract(day from to_date('49/10/11', 'YY/MM/DD'))||'일' "49/10/11,YY/MM/DD",

       extract(year from to_date('99/10/11', 'RR/MM/DD'))||'년' ||
       extract(month from to_date('99/10/11', 'RR/MM/DD'))||'월'||
       extract(day from to_date('99/10/11', 'RR/MM/DD'))||'일' "99/10/11,RR/MM/DD",

       extract(year from to_date('49/10/11', 'RR/MM/DD'))||'년' ||
       extract(month from to_date('49/10/11', 'RR/MM/DD'))||'월'||
       extract(day from to_date('49/10/11', 'RR/MM/DD'))||'일' "49/10/11,RR/MM/DD"
from dual;

--8. 춘 기술대학교의 2000년도 이후 입학자들은 학번이 A로 시작하게 되어있다.
-- 2000년도 이전 학번을 받은 학생들의 학번과 이름을 보여주는 SQL 문장을 작성하시오.

select student_no, student_name 
from tb_student
where substr(student_no,1,1)<>'A';

--9. 학번이 A517178인 한아름 학생의 학점 총 평점을 구하는 SQL문을 작성하시오.
-- 단, 이 때 출력 화면의 헤더는 "평점"이라고 찍히게 하고, 점수는 반올림하여
-- 소수점 이하 한 자리까지만 표시한다.

select round(avg(G.point),1) 평점
from tb_student S
    join tb_grade G
    on S.student_no = G.student_no
where S.student_no = 'A517178';

--10. 학과별 학생수를 구하여 "학과번호", "학생수(명)"의 형태로
--    헤더를 만들어 결과값이 출력되도록 하시오.

select department_no 학과번호 , count(*) "학생수(명)"
from tb_student
group by department_no
order by 1;

--11. 지도 교수를 배정받지 못한 학생의 수는 몇 명 정도 되는지 알아내는
--    SQL 문을 작성하시오.

select count(*)
from tb_student
where coach_professor_no is null;

--12. 학번이 A112113인 김고운 학생의 년도 별 평점을 구하는
--    SQL문을 작성하시오. 단, 이 때 출력 화면의 헤더는
--    "년도", "년도 별 평점" 이라고 찍히게 하고, 점수는 반올림하여
--    소수점 이하 한 자리까지만 표시한다.

select substr(G.term_no,1,4) 년도, round(avg(G.point),1) "년도 별 평점"
from tb_student S
join tb_grade G
    on S.student_no = G.student_no
where S.student_no = 'A112113'
group by substr(G.term_no,1,4)
order by 1;

--13. 학과 별 휴학생 수를 파악하고자 한다. 
--    학과 번호와 휴학생 수를 표시하는 SQL 문장을 작성하시오.
select * from tb_student;

select D.department_no "학과코드명", 
       count(decode(S.absence_yn,'Y',1)) "휴학생 수"
from tb_department D
    join tb_student S
    on D.department_no = S.department_no
--where S.absence_yn = 'Y'
group by D.department_no
order by 1;

--14. 춘 대학교에 다니는 동명이인 학생들의 이름을 찾고자 한다.
--    어떤 SQL 문장을 사용하면 가능하겠는가?

select distinct student_name 동일이름, count(*) "동명인 수"
from tb_student S
where student_name in (select student_name
                      from tb_student
                      where student_name = S.student_name
                      and student_no <> S.student_no)
group by student_name
order by 1;

--15. 학번이 A112113인 김고운 학생의 년도, 학기 별 평점과
--    년도 별 누적 평점, 총 평점을 구하는 SQL 문을 작성하시오.
--    (단, 평점은 소수점 1자리까지만 반올림하여 표시한다.)

select decode(grouping(substr(term_no, 1,4)), 0, substr(term_no, 1,4)) 년도, 
       decode(grouping(substr(term_no, 5,2)), 0, substr(term_no, 5,2), ' ') 학기,
       round(avg(point),1) 평점
from tb_grade
where student_no = 'A112113'
group by rollup(substr(term_no, 1,4), substr(term_no, 5,2))
order by 1;







select entrance_date from tb_student;

SELECT STUDENT_NO, STUDENT_NAME
FROM (SELECT S.*, (DECODE(SUBSTR(ENTRANCE_DATE,1,1),'0',20,'9',19) 
    || SUBSTR(ENTRANCE_DATE,1,2)) 입학년도,
      (decode(SUBSTR(STUDENT_SSN,8,1),'1',19,'2',19,20) || 
      SUBSTR(STUDENT_SSN,1,2)) 생년월일 FROM TB_STUDENT S) S
where S.입학년도 - S.생년월일 = 19;

select student_no, student_name
from tb_student
where extract(year from entrance_date)
              -(decode(substr(student_ssn,8,1),1,'1900',2,'1900','2000')
              +substr(student_ssn,1,2)) > 19;
              
              
              
              