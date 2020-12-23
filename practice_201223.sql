
-- 실습문제 chun - group by | having

--1. 학과테이블에서 계열별 정원의 평균을 조회(정원 내림차순 정렬)
select category 계열, trunc(avg(capacity)) "정원의 평균"
from tb_department
group by category
order by "정원의 평균" desc;


--2. 휴학생을 제외하고, 학과별로 학생수를 조회(학과별 인원수 내림차순)
select department_no 학과번호, count(*) 학생수
from tb_student
where absence_yn != 'Y'
group by department_no
order by 학생수 desc;

--3. 과목별 지정된 교수가 2명 이상인 과목번호와 교수인원수를 조회
select class_no 과목번호, count(professor_no) 교수인원수
from tb_class_professor
group by class_no
having count(professor_no)>=2;


--4. 학과별로 과목을 구분했을 때, 과목구분이 "전공선택"에 한하여 과목수가
--10개 이상인 행의 학과번호, 과목구분(class_type), 과목수를 조회(전공선택만 조회)

select * from tb_class;
select department_no 학과번호, class_type, count(*) 과목수
from tb_class
where class_type = '전공선택'
group by department_no, class_type
having count(*)>=10;


--실습문제 : join @chun

--1. 학번, 학생명, 학과명 조회
select S.student_no 학번 , S.student_name 학생명, D.department_name 학과명
from tb_student S
    join tb_department D
    on S.department_no = D.department_no;

--2. 학번, 학생명, 담당교수명 조회(담당 교수가 없는 학생도 포함해서 조회할 것.)
select S.student_no 학번 , S.student_name 학생명 , P.professor_name 담당교수명
from tb_student S
    left outer join tb_professor P
    on S.coach_professor_no = P.professor_no;


--3. 수업번호, 수업명, 교수번호, 교수명 조회
select C.class_no 수업번호, C.class_name 수업명, 
        CP.professor_no 교수번호, P.professor_name 교수명
from tb_class C
    join tb_class_professor CP
    on C.class_no = CP.class_no
    join tb_professor P
    on CP.professor_no = P.professor_no;

--4. 송박성 학생의 모든 학기 과목별 점수를 조회(학기, 학번, 학생명, 수업명, 점수)
select G.term_no, S.student_no, S.student_name, c.class_name, G.point
from tb_student S
    join tb_grade G
    on S.student_no = G.student_no
    join tb_class C
    on G.class_no = C.class_no;

--5. 학생별 과목별 전체 평점(소수점 이하 첫째자리 버림) 조회 (학번, 학생명, 평점)
-- 과목별 출력 안하는 경우...? 아래와 결과 다름.
select distinct A.학번, A.학생명, A.평점
from tb_student S
    cross join(select S.student_no 학번, S.student_name 학생명, G.class_no, trunc(avg(point),1) 평점
               from tb_student S
               join tb_grade G
               on S.student_no = G.student_no
               group by S.student_no, S.student_name, G.class_no, G.class_no) A
order by 1;

-- 과목별 출력하는 경우..
select S.student_no 학번, S.student_name 학생명, G.class_no 과목, trunc(avg(G.point),1) 평점
from tb_student S
    join tb_grade G
    on S.student_no = G.student_no
    group by S.student_no, S.student_name, G.class_no
order by 2;
