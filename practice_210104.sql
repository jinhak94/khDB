--==========================================================
-- 04. 워크북 DDL
--==========================================================


--1. 계열 정보를 저장할 카테고리 테이블을 만들려고 한다. 
--   다음과 같은 테이블을 작성하시오.

create table tb_category(
    name varchar2(10),
    use_yn char(1) default 'Y'
);


--2. 과목 구분을 저장할 테이블을 만들려고 한다. 
--   다음과 같은 테이블을 작성하시오.

create table tb_class_type(
    no varchar2(5),
    name varchar2(10),
    constraint pk_tb_class_type_no primary key(no)
);

--3. TB_CATEGORY 테이블의 NAME 컬럼에 PRIMARY KEY를 생성하시오.
-- (KEY 이름을 생성하지 않아도 무방함. 만일 KEY를 지정하고자 한다면
-- 이름은 본인이 알아서 적당한 이름을 사용한다.

alter table tb_category add constraint pk_tb_category_name primary key(name);

select * from user_constraints;

--4. TB__CLASS_TYPE 테이블의 NAME 컬럼에 NULL 값이 들어가지 않도록
--   속성을 변경하시오

alter table tb_class_type modify name not null;

--5. 두 테이블에서 컬럼 명이 NO인 것은 기존 타입을 유지하면서 크기는 10으로,
--   컬럼명이 NAME인 것은 마찬가지로 기존 타입을 유지하면서 크기 20으로 변경하시오.

alter table tb_class_type modify no varchar2(10);
alter table tb_class_type modify name varchar2(20);
alter table tb_category modify name varchar2(20);

--6. 두 테이블의 NO 컬럼과 NAME 컬럼의 이름을
--   각각 TB_를 제외한 테이블 이름이 앞에 붙은 형태로 변경한다.
 
alter table tb_class_type rename column no to class_type_no;
alter table tb_class_type rename column name to class_type_name;
alter table tb_category rename column name to category_name;

--7. TB_CATEGORY 테이블과 TB_CLASS_TYPE 테이블의 primary key 이름을
--   다음과 같이 변경하시오.

-- Primary Key의 이름은 "PK_ + 컬럼이름" 으로 지정하시오. (ex. PK_CATEGORY_NAME)
select * from user_constraints;
alter table tb_class_type rename constraint pk_tb_class_type_no to pk_class_type_no;
alter table tb_category rename constraint pk_tb_category_name to pk_category_name;

--8. 다음과 같은 INSERT 문을 수행한다.

insert into tb_category values ('공학', 'Y');
insert into tb_category values ('자연과학', 'Y');
insert into tb_category values ('의학', 'Y');
insert into tb_category values ('예체능', 'Y');
insert into tb_category values ('인문사회', 'Y');
commit;

--9. TB_DEPARTMENT의 CATEGORY 컬럼이 TB_CATEGORY 테이블의 
--   CATEGORY_NAME 컬럼을 부모값으로 참조하도록 FOREIGN KEY를 지정하시오.
--   이 때, KEY 이름은 FK_테이블이름_컬럼이름으로 지정한다
--   (ex.  FK_DEPARTMENT_CATEGORY)

desc tb_department; 
desc tb_category;

alter table tb_department add constraints fk_department_category 
    foreign key(category) references tb_category(category_name);

select * from user_constraints;

--10. 춘 기술대학교 학생들의 정보만이 포함되어 있는 학생일반정보 VIEW를
--    만들고자 한다. 아래 내용을 참고하여 적절한 SQL 문을 작성하시오.

-- 뷰이름 : VW_학생일반정보,  컬럼 : 학번, 학생이름, 주소

-- 우선 chun 계정에 view 생성 권한 부여
select * from tb_student;

create view vw_학생일반정보
as 
select student_no 학번, student_name 학생이름, student_address 주소
from tb_student;

--11. 춘 기술대학교는 1년에 두 번씩 학과별로 학생과 지도교수가 지도 면담을
--    진행한다. 이를 위해 사용할 학생이름, 학과이름, 담당교수 이름으로
--    구성되어 있는 VIEW를 만드시오.
--    이 때 지도 교수가 없는 학생이 있을 수 있음을 고려하시오. (단, 이 VIEW는 
--    단순 SELECT만을 할 경우 학과별로 정렬되어 화면에 보여지게 만드시오.

create or replace view vw_지도면담
as
select student_name 학생이름, 
       (select department_name from tb_department where E.department_no = department_no) 학과이름,
       (select professor_name from tb_professor where E.coach_professor_no = professor_no) "담당교수 이름"
from tb_student E
order by 2;

select * from vw_지도면담;

--12. 모든 학과의 학과별 학생 수를 확인할 수 있도록 적절한 VIEW를 작성해보자.

create view vw_학과별학생수
as
select (select department_name
        from tb_department
        where department_no = E.department_no) department_name
        , count(*) student_count 
from tb_student E
group by department_no;

--13. 위에서 생성한 학생일반정보 view를 통해서 학번이 A213046인 
--    학생의 이름을 본인 이름으로 변경하는 SQL문을 작성하시오.

update vw_학생일반정보
set student_name = '김진하'
where student_name = (select 학생이름
                      from vw_학생일반정보
                      where 학번 = 'A213046');

--14. 13번에서와 같이 VIEW를 통해서 데이터가 변경될 수 있는 상황을 막으려면
--    VIEW를 어떻게 생성해야 하는지 작성하시오.

grant select on vw_학생일반정보 to chun;
--관리자 계정에서
revoke insert, update on tb_student from chun;

--15. 춘 기술대학교는 매년 수강신청 기간만 되면 특정 인기 과목들에 수강 신청이
--    몰려 문제가 되고 있다. 최근 3년을 기준으로 수강인원이 가장 많았던 
--    3 과목을 찾는 구문을 작성해보시오.


-- ....



--==========================================================
-- 05. 워크북 DML
--==========================================================

--1. 과목유형 테이블(TB_CLASS_TYPE)에 아래와 같은 데이터를 입력하시오.
-- 번호, 유형이름
-- 01, 전공필수
-- 02, 전공선택
-- 03, 교양필수
-- 04, 교양선택
-- 05, 논문지도

insert into tb_class_type values('01','전공필수');
insert into tb_class_type values('02','전공선택');
insert into tb_class_type values('03','교양필수');
insert into tb_class_type values('04','교양선택');
insert into tb_class_type values('05','논문지도');

--2. 춘 기술대학교 학생들의 정보가 포함되어 있는 학생일반정보 테이블을
--   만들고자 한다. 아래 내용을 참고하여 적절한 SQL문을 작성하시오.
--   (서브쿼리를 이용하시오)

-- 테이블이름
--  TB_학생일반정보

-- 컬럼
--  학번
--  학생이름
--  주소

create table tb_학생일반정보
as
(select student_no 학번, student_name 학생이름, student_address 주소
 from tb_student);

--3. 국어국문학과 학생들의 정보만이 포함되어 있는 학과정보 테이블을 만들고자 한다.
--   아래 내용을 참고하여 적절한 SQL 문을 작성하시오.
--   (힌트 : 방법은 다양함. 소신껏 작성하시오)

-- 테이블이름
--  tb_국어국문학과
-- 컬럼
--  학번
--  학생이름
--  출생년도 <= 네자리 년도로 표기
--  교수이름

create table tb_국어국문학과
as
(select student_no 학번,
        student_name 학생이름,
        substr(student_ssn,3,4) 출생년도,
        (select professor_name
         from tb_professor
         where E.coach_professor_no = professor_no) 교수이름
 from tb_student E
);

--4. 현 학과들의 정원을 10% 증가시키게 되었다. 이에 사용할 SQL문을 작성하시오.
--   (단, 반올림을 사용하여 소수점 자릿수는 생기지 않도록 한다.)

update tb_department
set capacity = capacity + round((capacity * 0.1),0)
where capacity is not null;

--5. 학번 A413042인 박건우 학생의 주소가 "서울시 종로구 숭인동 181-21"로
--   변경되었다고 한다. 주소지를 정정하기 위해 사용할 SQL문을 작성하시오.

update tb_student
set student_address = '서울시 종로구 숭인동 181-21'
where student_no = 'A413042';

--6. 주민등록번호 보호법에 따라 학생정보 테이블에서 주민번호 뒷자리를
--   저장하지 않기로 결정하였다. 이 내용을 반영할 적절한 SQL 문장을 작성하시오.
--   (예. 830530-2124663 => 830530)

update tb_student
set student_ssn = substr(student_ssn,1,6)
where student_ssn is not null;

--7. 의학과 김명훈 학생은 2005년 1학기에 자신이 수강한 '피부생리학' 점수가
--   잘못되었다는 것을 발견하고는 정정을 요청하였다. 담당 교수의 확인을 받은
--   결과 해당 과목의 학점을 3.5로 변경키로 결정되었다. 적절한 SQL문을 작성하시오.

update tb_grade
set point = 3.5
where student_no = (select student_no
                    from tb_student S
                    join tb_department D
                    on S.department_no = D.department_no
                    where S.student_name = '김명훈' and D.department_name = '의학과')
      and term_no = '200501'
      and class_no = (select class_no
                      from tb_class
                      where class_name = '피부생리학');

--8. 성적 테이블(TB_GRADE)에서 휴학생들의 성적 항목을 제거하시오.

delete from tb_grade
where student_no in (select student_no
                    from tb_student
                    where absence_yn = 'N');







