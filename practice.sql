
--1. 학번, 학생명, 학과명 조회
select S.student_no 학번, S.student_name 학생이름,
        C.class_name 학과명
from tb_student S
join tb_class C
    on S.department_no = C.department_no;

--2. 학번, 학생명, 담당교수명 조회(담당교수 없는 학생도 조회)
select S.student_no 학번, S.student_name 학생명
        , P.professor_name 담당교수명
from tb_student S
join tb_professor P
    on S.coach_professor_no = P.professor_no;

--3. 수업번호, 수업명, 교수번호, 교수명 조회
select C.class_no 수업번호, C.class_name 수업명,
       CP.professor_no 교수번호, P.professor_name 교수이름
from tb_class C
    join tb_class_professor CP
    on C.class_no = CP.class_no
    join tb_professor P
    on CP.professor_no = P.professor_no;

--4. 송박선 학생의 모든 학기 과목별 점수를 조회
--(학기, 학번, 학생명, 수업명, 점수)

select G.term_no 학기, G.student_no 학번,
       S.student_name 학생명, C.class_name 수업명,
       G.point 점수
from tb_student S
    join tb_class C
    on S.department_no = C.department_no
    join tb_grade G
    on C.class_no = G.class_no
where S.student_name = '송박선';

--5. 학생별 과목별 전체 평점(소수점 이하 첫째자리 버림) 조회
--(학번, 학생명, 평점)

select S.student_no 학번, S.student_name 학생명, G.class_no 과목, trunc(avg(G.point),1) 평점
from tb_student S
    join tb_class C
    on S.department_no = C.department_no
    join tb_grade G
    on C.class_no = G.class_no
group by S.student_no, S.student_name, G.class_no
order by 1 desc;







