show user;

--kh계정의 테이블 확인
--kh소유의 테이블 목록
select * 
from tab;

select * from employee;
select * from department;
select * from job;
select * from location;
select * from nation;
select * from sal_grade;

--표 table entity relation
-- data를 보관하는 객체
-- data를 생성 create/조회 read/수정 update/삭제 delete CRUD 처리 가능

--열 column field attribute
-- data가 보관되는 자료형 크기 지정

--행 row record tuple
-- vo객체 하나에 대한 정보를 표현

--도메인 domain
-- 하나의 column(attribute)가 가질수 값의 집합
-- gender : 남|여

--테이블 상세내역
--null여부 : null(기본값) 선택입력컬럼 | not null 필수입력컬럼
--유형(자료형) : 문자형, 날짜형, 숫자형, LOB
desc employee;

--========================================
-- Data Type
--========================================
--1. 문자형
--char 고정형(최대 2000byte) 
--  name char(10) : James 5byte를 입력해도 10byte로 저장, Gosling 7byte를 입력해도 10byte로 저장
--varchar2 가변형(최대 4000byte)
--  name varchar2(10) : James 5byte를 입력하면 5byte로 저장, Gosling 7byte를 입력하면 7byte로 저장

--long 가변형(최대 2gb)
--clob 최대4gb

--table 생성
create table tb_datatype (
    a char(10),
    b varchar2(10)
);

--데이터 추가
insert into tb_datatype 
values ('James', 'Gosling');
--insert into tb_datatype 
--values ('JamesJamesJames', 'Gosling');
--ORA-12899: value too large for column "KH"."TB_DATATYPE"."A" (actual: 15, maximum: 10)

--한글 한글자당 2byte, 11g XE에서는 3byte로 처리
insert into tb_datatype 
values ('홍길동', '세종');
--insert into tb_datatype 
--values ('홍길동길동', '세종');
--ORA-12899: value too large for column "KH"."TB_DATATYPE"."A" (actual: 15, maximum: 10)

--lengthb : oracle의 내장함수. 해당컬럼의 크기(byte수)를 리턴
select a, lengthb(a), b, lengthb(b)
from tb_datatype;

--2. 숫자형
--number[(p, s)]
--p : 전체 자릿수
--s : 소수점이하 자릿수

--1234.567
--number -> 1234.567
--number(7,1) -> 1234.6(반올림처리)
--number(7) -> 1235(반올림처리)

create table tb_datatype_number(
    a number,
    b number(7,1),
    c number(7)
);

insert into tb_datatype_number
values(1234.567, 1234.567, 1234.567);

select *
from tb_datatype_number;

--정수/실수 구분하지 않는다.
select 10 / 3
from dual; -- dual 가상테이블(1행짜리)

--3. 날짜형
--date 날짜/시간
--timestamp 날짜/시간/밀리초 지역대
select sysdate, 
       to_char(sysdate, 'yyyy/mm/dd hh:mi:ss'), --날짜를 문자열로 변환하는 내장함수
       systimestamp
from dual;

--날짜형은 숫자(1:하루)와 연산이 가능하다.
--sysdate - 1 -> 어제 이시각
--sysdate + 1 -> 내일 이시각
--sysdate + 10 -> 10일후 이시각
select to_char(sysdate - 1, 'yyyy/mm/dd hh:mi:ss')
from dual;

--날자끼리 빼기연산도 가능 : 두 날자 차이를 알수 있다.
select sysdate - (sysdate - 1)
from dual;

--@실습문제
--today회사의 회원테이블생성
--id : 6 ~ 15자리
--password : 8 ~ 20자리
--name 
--phone : -없이 11자리
--ssn : -없이 13자리
--mileage 크기 제한없음
--reg_date : 회원가입일

--고정형(char) - 값이 자주 변경되는 경우
--가변형(varchar2) 
create table tb_today(
    id varchar2(15),
    password char(20),
    name varchar2(50),
    phone char(11),
    ssn char(13),
    mileage number,
    reg_date date
);

desc employee;

--=====================================
-- SQL
--=====================================
--1. DDL Data Definition Language 데이터 정의어 -> 데이터베이스 객체에 대해서 create, alter, drop
--2. DML Data Manipulation Language 데이터 조작어 -> table객체의 행에 대해서 insert, select, update, delete
    -- DQL Data Query Language select문
--3. DCL Data Control Language 데이터 제어어 -> user, role에 대해서 권한부여/회수 grant, revoke
    -- TCL Transaction Control Language -> transaction에 대해 commit, rollback, savepoint
    

--=====================================
-- DQL1
--=====================================
--테이블의 데이터를 검색하기 위한 명령어
--명령어릐 조회결과를 ResultSet(결과집합)이라고함.
--ResultSet은 0개의 이상의 행으로 구성됨.
--특정컬럼/특정행을 조회가능, 정렬 지원

/*

select (5)컬럼 나열
from (1)조회대상 테이블
where (2)특정행 선택할 기준 조건절 (true 결과집합 포함, false 결과집합 미포함)
group by (3) 
having (4)
order by (6)정렬기준

*/
select emp_name, phone
from employee;

select *
from employee;

select *
from employee
where dept_code = 'D9';

select *
from employee
where salary >= 3000000;

select *
from employee
order by emp_name desc;
--asc 오름차순
--desc 내림차순

--@실습문제 : D9부서원 급여내림차순 조회
--sql문은 data를 제외하고 대소문자 구분하지 않는다.
select *
from employee
where dept_code = 'D9'
order by salary desc;

SELECT *
FROM EMPLOYEE
WHERE DEPT_CODE = 'D9'
ORDER BY SALARY DESC;

---------------------------------------------
-- SELECT
---------------------------------------------
--존재하는 컬럼 뿐 아니라, 산술연산처리, literal 또한 가능
select emp_name, salary, salary * 12, '원'
from employee;

--null과 산술연산을 하면 처리결과는 무조건 null이다.
--null처리함수 : nvl(col, null일때value)
select emp_name, salary, bonus, 
       nvl(bonus, 0), salary + (salary * nvl(bonus, 0))
from employee;

--@실습문제
--1. EMPLOYEE 테이블에서 이름, 연봉(월급*12), 총수령액(보너스포함연봉), 실수령액(총 수령액-(월급*세금 3%))가 출력되도록 하시오

select emp_name as 이름 , 
        salary*12 as 연봉,
        (salary+(salary*nvl(bonus,0)))*12 as "총 수령액",
        ((salary+(salary*nvl(bonus,0)))*12)-(salary*0.03*12) as "실 수령액"
from employee;

--2. EMPLOYEE 테이블에서 이름, 입사일, 근무 일수(입사한지 몇일인가)를 출력해보시오.
-- sysdate - hire_date 
select emp_name as 이름, hire_date as 입사일, trunc(sysdate - hire_date) as "근무 일수" 
from employee;

--alias 별칭
-- 컬럼 as "별칭"
-- 컬럼 별칭 : as "" 생략가능
-- 숫자, 공백이 있는 경우는 ""생략할 수 없다.
select emp_name 사원, emp_no "주민번호"
from employee;


--distinct
--컬럼에 중복된 값을 한번만 표시할 경우.
--select절에 한번만 사용 가능. 여러컬럼에 대해서 중복값을 정의
select distinct dept_code, job_code
from employee;

--문자열 더하기 연산 ||
--홍길동(200)
select emp_name || '(' || emp_no || ')' as "사원명(사번)"
from employee;

------------------------------------------
-- WHERE
------------------------------------------
--테이블 행중에 결과집합에 포함여부를 결정하는 조건절
/*
= 
> < >= <=
!= <> ^=  같지 않다
between 값1 and 값2  값1과 값2사이에 속하는 가
like | not like 문자패턴비교
is null | is not null null여부 비교
in | not in 값목록에 포함여부

논리연산
and 
or
not 
*/

--부서코드가 D6이면서, 급여가 2,000,000원보다 많이 받는 사원명, 부서코드, 급여 조회.
select emp_name, dept_code, salary
from employee
where dept_code = 'D6' 
    and salary > 2000000;
    
--부서코드가 D9가 아닌 사원명, 부서코드 조회
select emp_name, dept_code
from employee
where dept_code ^= 'D9';


--직급코드가 J1이 아닌 사원의 월급등급 sal_level을 중복없이 출력
select distinct sal_level
from employee
where job_code != 'J1';

--between .. and ..
--급여가 3,500,000원이상 6,000,000원 이하인 사원의 사원명, 급여 조회
select emp_name, salary
from employee
where salary between 3500000 and 6000000;
--where salary >= 3500000 and salary <= 6000000;

--날짜형
--입사일이 1990년1월1일부터 2001년 1월 1일 사이인 사원 조회
--날짜형식의 문자열을 제공시, 자동으로 날짜형 변환 처리
--yyyy/mm/dd, yyyymmdd, yyyy-mm-dd, yy/mm/dd
select emp_name, hire_date
from employee
where hire_date between '90/01/01' and '01/01/01';

--like 문자열 패턴 비교
--지정한 특정패턴에 만족하면 true 반환
--wildcard (% _)를 사용가능
--% : 글자가 0개이상 김%
--_ : 한글자 a___z

--전씨성을 가진 사원조회
select emp_name
from employee
where emp_name like '전%'; 
--전 전진 전진가라사대 (O) 
--파전 (X)

--이름이 '이'글자가 들어가는 사원 조회
select emp_name
from employee
where emp_name like '%이%';
-- 이무기 아이유 천천이

--이름이 3글자인 사원 조회
select emp_name
from employee
where emp_name like '__';

--email컬럼값에서 _앞의 글자가 딱 3글자인 이메일 조회
select emp_name, email
from employee
where email like '___#_%' escape '#';   -- 4글자이상이면 true 

--전화번호가 첫 3자리가 010이 아닌 사원 조회(사원명, 전화번호)
select emp_name, phone
from employee
where phone not like '010%';

--메일주소 _앞의 글자가 2글자이면서 
--부서가 D9 또는 D6이면서 
--고용일이 2001년 12월 31일 이전인 사원 조회
select emp_name, email, dept_code, hire_date
from employee
where email like '__\_%' escape '\' 
    and (dept_code = 'D9' or dept_code = 'D6')
    and hire_date < '2001/12/31';

-- in 값목록
-- 값목록에 포함되어 있으면 true
-- D6, D8인 사원 조회
select emp_name, dept_code
from employee
where dept_code in ('D6', 'D8');
--where dept_code = 'D6' or dept_code = 'D8';

--is null | is not null
--컬럼값이 null이면, 비교대상에 포함되지 않는다.

--인턴사원 조회
select emp_name, dept_code
from employee
where dept_code is not null;

---------------------------------------------
-- ORDER BY
---------------------------------------------
--정렬기준컬럼을 제시하는 구문
--asc 오름차순
--desc 내림차순
select emp_name, dept_code, salary, hire_date
from employee
order by dept_code asc, salary desc;

--==========================================
-- FUNCTION
--==========================================
--오라클 내장 함수
--호출시 값을 전달하고, 반드시 하나의 리턴값을 가진다.

/*
1. 단일행 함수 : 행마다 반복 실행
    a.문자처리함수
    b.숫자처리함수
    c.날짜처리함수
    d.형변환함수
    e.기타함수
2. 그룹함수 : 여러행(한그룹)마다 실행
*/

-------------------------------------------
-- 단일행 함수
-------------------------------------------
--a. 문자처리 함수
--length 길이반환

select emp_name, length(emp_name), lengthb(emp_name)
from employee;

select emp_name, email
from employee
where length(email) < 15;

--instr
--검색한 문자열의 인덱스를 반환
--instr(string, search, position, occurrence)
--position 검색 시작위치
--occurrence 출현 횟수
--oracle의 index는 1부터 시작한다.
select instr('kh정보교육원 국가정보원 정보문화사', '정보'),
       instr('kh정보교육원 국가정보원 정보문화사', '정보', 5),
       instr('kh정보교육원 국가정보원 정보문화사', '정보', 1, 2),
       instr('kh정보교육원 국가정보원 정보문화사', '정보', -1)
from dual;

--email컬럼 @위치를 조회
select email, instr(email, '@')
from employee;

--substr(string, position[, length])
--position : 시작위치
--length : 잘라낼 문자열 길이, 생략시 끝까지.

select substr('showmethemoney', 5, 2),
       substr('showmethemoney', 1, 6),
       substr('showmethemoney', 10)
from dual;

--email에서 id부분만 조회

select email, 
       instr(email, '@') - 1,
       substr(email, 1, instr(email, '@') - 1) id
from employee;

--lpad | rpad
--지정한 길이에서 해당문자열을 위치시키고 남은 공간은 패딩문자 채워 넣는다.
--lpad(string, len[, padding])
select lpad(email, 20, '#'),
       rpad(email, 20, '#'),
       lpad(email, 20)
from employee;

--사번, 주민번호(뒤 6자리는 ******) 조회
select emp_id 사번, 
       rpad(substr(emp_no, 1, 8), 14, '*') ssn,
       substr(emp_no, 1, 8) || '******'
from employee;

--b. 숫자처리함수
--mod
--나머지함수 
select mod(10, 3),
       mod(10, 2)
from dual;

--여자사원만 조회
select emp_name,
       substr(emp_no, 8, 1)
from employee
--where substr(emp_no, 8, 1) in (2, 4);
where mod(substr(emp_no, 8, 1), 2) = 0;

-- ceil | floor
-- 올림 버림함수
select ceil(123.456 * 100) / 100, floor(345.678)
from dual;

-- round(number[, position])
--반올림
select round(234.567),
       round(234.567, 2),
       round(234.567, -1) -- 소수점 이상 자리수 계산  234천원
from dual;

-- trunc(number[, position])
-- 버림
select trunc(123.456),
       trunc(123.456, 1)
from dual;

--c. 날짜처리 함수
--add_months(date, number):date
--date에서 number개월수를 더하거나 뺀 날짜형을 반환
select add_months(sysdate, 1),
       add_months(sysdate, -1)
from dual;

--정식사원이 된 날짜 조회
select emp_name,
       hire_date,
       add_months(hire_date, 3)
from employee;

--months_between(date1, date2) : number
--개월수 차이를 리턴 (1:한달)
--date1 : 미래날짜
--date2 : 과거날짜

select round(months_between(sysdate, '2020/10/28'), 1)
from dual;

--사원별 근무개월수 조회(소수점제거)

select emp_name, 
       hire_date,
       trunc(months_between(sysdate, hire_date)) "근무 개월수",
       trunc(months_between(sysdate, hire_date) / 12) || '년 ' ||
       trunc(mod(months_between(sysdate, hire_date), 12)) || '개월' "근무 개월수"
from employee;

--extract( 단위 from date | timestamp ) : number
-- year | month | day | hour | minute | second
select extract(year from sysdate) year,
       extract(month from sysdate) month,
       extract(day from sysdate) day,
       extract(hour from cast(systimestamp as timestamp)) hour,
       extract(minute from cast(systimestamp as timestamp)) minute,
       extract(second from cast(systimestamp as timestamp)) second
from dual;

--2001년도 입사자 조회 (사원명, 입사일)
select emp_name, hire_date
from employee
where extract(year from hire_date) = 2001;

--d.형변환함수
--to_char
--to_date
--to_number
/*
         to_char        to_date
        -------->       -------->
    number      character       date
        <--------       <--------
         to_number      to_char
*/

--to_char(date | number, format)
--fm : 형식문자에서 생긴 공백 제거
select to_char(sysdate, 'yyyy-mm-dd(day)hh24:mi:ss'),
       to_char(sysdate, 'yyyy"년" mm"월" dd"일"'),
       to_char(1234567, 'FML999,999,999'),
       to_char(1234567, 'FML000,000,000'),
       to_char(1234567, '9,999')
from dual;

--사원명, 급여(원화, 세자리마다 콤마)조회
select emp_name, to_char(salary, 'fml999,999,999') salary
from employee;


--@실습문제
create table tbl_escape_watch(
    watchname   varchar2(40)
    ,description    varchar2(200)
);
--drop table tbl_escape_watch;
insert into tbl_escape_watch values('금시계', '순금 99.99% 함유 고급시계');
insert into tbl_escape_watch values('은시계', '고객 만족도 99.99점를 획득한 고급시계');
commit; -- TCL memory상 작업내역을 실제 db file에 적용

select * from tbl_escape_watch;

--tbl_escape_watch 테이블에서 description 컬럼에 99.99% 라는 글자가 들어있는 행만 추출하세요.


--@실습문제
--파일경로를 제외하고 파일명만 아래와 같이 출력하세요.
create table tbl_files
(fileno number(3)
,filepath varchar2(500)
);
insert into tbl_files values(1, 'c:\abc\deft\salesinfo.xls');
insert into tbl_files values(2, 'c:\music.mp3');
insert into tbl_files values(3, 'c:\documents\resume.hwp');
commit;
select * 
from tbl_files;


--to_number()
select to_number('￦1,234,567', 'L9,999,999') + 123
from dual;

-- +연산은 산술연산만 가능
select '100' + '10', -- 100 + 10
       '100' || '10'
from dual;

--to_date(character[, format]) : date
select to_date('1999-03-03', 'yyyy-mm-dd'),
       to_date('1999-03-03'),
       '1999-03-03'
from dual;

--@실습문제 : 2018년 2월 8일 12시 23분 50초에서 3시간후의 시간정보를 동일형식으로 출력하세요.
--날짜형 +- 숫자(하루:1) -> 날짜형
--to_char(날짜형, 형식문자)
select to_char(to_date('2018년 2월 8일 12시 23분 50초', 'yyyy"년" mm"월" dd"일" hh24"시" mi"분" ss"초"') + 3/24, 'yyyy"년" mm"월" dd"일" hh24"시" mi"분" ss"초"') result
from dual;

--현재시각으로부터 1일 2시간 3분 4초뒤를 시각을 출력하세요.
select to_char(sysdate + 1 + (2 / 24) + (3 / (24 * 60) + (4 / (24 * 60 * 60))), 'yyyy-mm-dd hh24:mi:ss') result
from dual;

--null처리함수
--1. nvl(col, value)
select emp_name, bonus, nvl(bonus, 0)
from employee;

--2. nvl2(col, value1, value2)
--col이 null이 아니면 value1
--col이 null이면 value2
select emp_name, nvl2(bonus, '유', '무') "보너스 여부"
from employee;

--e. 기타함수
--decode(표현식, 값1, 결과1, 값2, 결과2, 값3, 결과3....[, 기본값] )

select emp_name, 
       emp_no,
       decode(substr(emp_no, 8, 1), '1', '남', '2', '여', '3', '남', '4', '여') 성별,
       decode(substr(emp_no, 8, 1), '1', '남', '3', '남', '여') 성별
from employee;

--case
/*
1. decode와 동일한 방식
case 표현식
    when 값1 then 결과1
    when 값2 then 결과2
    ...
    [else 기본값]
    end 
*/
select emp_name,
       case substr(emp_no, 8, 1)
            when '1' then '남'
            when '2' then '여'
            when '3' then '남'
            when '4' then '여'
            else '?'
        end 성별
from employee;

/*
2. 조건절 여러개
    case 
        when 조건절1 then 결과1
        when 조건절2 then 결과2
        ...
        [else 기본값]
    end
*/
select emp_name,
       case
            when substr(emp_no, 8, 1) = '1' then '남'
            when substr(emp_no, 8, 1) = '3' then '남'
            else '여'
        end 성별,
        case
            when substr(emp_no, 8, 1) in ('1', '3') then '남'
            else '여'
        end 성별
from employee;

--@실습문제 : 
-- 사번, 사원명, 주민번호, 나이 조회
-- 나이 = 현재년도 - 출생년도 + 1
--yy 현재년도 기준으로 판단 : 20yy
--rr 반세기에 걸쳐 현재년도 기준으로 판단 
--  1. 00~49  2000 ~ 2049
--  2. 50~99  1950 ~ 1999

select emp_id,
       emp_name,
       emp_no,
--       extract(year from to_date(substr(emp_no, 1, 2), 'yy')) yyyy,
--       extract(year from to_date(substr(emp_no, 1, 2), 'rr')) rrrr
       case 
            when substr(emp_no, 8, 1) in ('1', '2') then 1900
            else 2000
        end + substr(emp_no, 1, 2) 출생년도, 
        extract(year from sysdate) 
        - (case when substr(emp_no, 8, 1) in ('1', '2') then 1900 else 2000 end + substr(emp_no, 1, 2)) + 1 나이,
       extract(year from sysdate) 
        - (decode(substr(emp_no, 8, 1),'1',1900,'2',1900,2000) + substr(emp_no, 1, 2))  + 1 나이
from employee;

-------------------------------------------
-- 그룹 함수
-------------------------------------------
-- 하나 이상의 행을 그룹으로 묶어서 총합, 평균등의 처리를 지원
-- group by절이 없다면, 전체행이 하나의 그룹이다.

-- sum
select sum(salary), emp_no
from employee;
--ORA-00937: not a single-group group function
--그룹함수와 일반컬럼에 동시에 사용할 수 없다.

--남자사원의 급여합계 조회
select sum(salary)
from employee
where substr(emp_no, 8, 1) in ('1', '3');

--부서코드가 D5인 사원들의 급여 총합 조회
select sum(salary)
from employee
where dept_code = 'D5';

--부서코드가 D5인 사원들의 보너스 총합 조회

select sum(salary * bonus)
from employee
where dept_code = 'D5';

select sum(salary * bonus)
from employee
where dept_code = 'D5' and bonus is not null;

--avg
select trunc(avg(salary),2)
from employee;

--count
--행의 수를 리턴
-- * 행이 존재한다면 1로 카운트
select count(*)
from employee;

--bonus컬럼이 null이면, 카운팅에 제외된다.
select count(bonus)
from employee;

select count(*)
from employee
where bonus is not null;

--bonus를 받지 않는 사원의 명수는?
select count(*)
from employee
where bonus is null;

select count(nvl2(bonus, null, 1))
from employee;

--max / min
--숫자, 날짜형, 문자형(가나다순)
select max(salary), min(salary), 
       max(hire_date), min(hire_date), 
       max(emp_name), min(emp_name)
from employee;

--@실습문제 : 
--1.부서에 속한 사원수 조회
select count(dept_code)
from employee;

--2.인턴사원수 조회
select count(*)
from employee
where dept_code is null;

--3.남자사원수, 여자사원수 조회 (where절 사용하지 말것)

select count(decode(substr(emp_no, 8, 1),'1',1000,'3',100,null)) "남자 사원수",
       count(decode(substr(emp_no, 8, 1),'2',1000,'4',100,null)) "여자 사원수",
       sum(decode(substr(emp_no, 8, 1),'1',1,'3',1,0)) "남자 사원수",
       sum(decode(substr(emp_no, 8, 1),'2',1,'4',1,0)) "여자 사원수"
from employee;

select count(case
                when substr(emp_no,8,1) in ('1','3') then 1
                end) 남자사원수, 
        count(case
                when substr(emp_no,8,1) in ('2','4') then 1
                end) 여자사원수
from employee;

--========================================
-- DQL2
--========================================
-----------------------------------------
--group by 
-----------------------------------------
--세부 그룹핑을 지정, 컬럼, 가공된 값을 기준으로 그룹핑 가능

--부서별 급여의 평균
--null도 하나의 그룹으로 처리
select *
from employee;

select dept_code, trunc(avg(salary)), sum(salary)
from employee
group by dept_code;

--group by절에 기술한 컬럼이 아니면, select절에 사용할 수 없다.
--ORA-00979: not a GROUP BY expression

--J1직급을 제외하고, 직급별 사원수, 평균 급여를 조회

select job_code 직급코드, 
       count(*) 사원수,
       trunc(avg(salary)) 평균급여
from employee
where job_code <> 'J1' -- ^= != <>
group by job_code
order by 2; -- 컬럼순서, 별칭

--입사년도별 사원수를 조회
select extract(year from hire_date) 입사년,
       count(*) 사원수
from employee
group by extract(year from hire_date)
order by 입사년;

--성별 인원수 조회
--group by
select decode(substr(emp_no, 8, 1), '1', '남', '3', '남', '여') 성별,
       count(*) 인원수
from employee
group by decode(substr(emp_no, 8, 1), '1', '남', '3', '남', '여');

--두개이상의 컬럼으로 grouping 가능
select dept_code,
       job_code,
       count(*),
       sum(salary)
from employee
group by job_code, dept_code
order by 1, 2 desc;

select *
from employee;

--부서별 성별 인원수를 조회

select nvl(dept_code, '인턴') 부서,
       decode(substr(emp_no, 8, 1), '1', '남', '3', '남', '여') 성별,
       count(*) 인원수
from employee
group by dept_code, decode(substr(emp_no, 8, 1), '1', '남', '3', '남', '여')
order by 1,2;

-----------------------------------------
-- having
-----------------------------------------
-- 그룹핑한 결과에 대해서 조건절을 제시

-- 부서별 급여평균이 3,000,000원 이상인 부서를 조회
-- where절에는 group함수를 쓸수 없다.

select dept_code,
       avg(salary)
from employee
group by dept_code
having avg(salary) >= 3000000
order by 1;

--부서별 인원수가 3명 이상인 부서를 조회(부서명, 인원수)
select D.dept_title 부서명, count(*) 인원수
from employee E
join department D
    on E.dept_code = D.dept_id
group by D.dept_title
having count(*) >= 3;

select dept_code, count(*)
from employee
group by dept_code
having count(*) >= 3
order by 1;

--관리하는 사원이 2명이상인 매니져의 사원아이디와 관리하는 사원수 조회

select manager_id, count(*)
from employee
group by manager_id
having count(manager_id) >= 2
order by 1;

-- rollup | cube
-- rollup 단방향 소계
-- cube 양방향 소계
-- grouping을 이용해서 null값 처리 가능 : 실제데이터 0을 리턴, 집계데이터면 1을 리턴
select decode(grouping(dept_code), 0, nvl(dept_code, '인턴'), '총계'),
--       grouping(dept_code),
       count(*)
from employee
group by rollup(dept_code)
order by 1;

select decode(grouping(dept_code), 0, nvl(dept_code, '인턴'), '총계') 부서, 
       decode(grouping(job_code), 0, job_code, '소계') 직급, 
       count(*)
from employee
group by rollup(dept_code, job_code)
order by 1,2;


--table(entity relation)
-- 두개 이상의 테이블의 레코드를 연결해서 가상테이블(relation) 생성
--1. join : 특정컬럼 기준으로 행과 행을 연결한다. (가로)
--2. union : 컬럼과 컬럼을 연결한다.(세로)

--========================================
-- JOIN
--========================================
-- 송종기 사원의 부서는?

select dept_code -- D9
from employee 
where emp_name = '송종기';

select dept_title
from department
where dept_id = 'D9';

select D.dept_title
from employee E join department D
    on E.dept_code = D.dept_id
where E.emp_name = '송종기';

-- 조인조건에 따른 구분
--1. Equi Join : 동등비교(=)에 의해 join
--2. Non-Equi Join : 동등비교가 아닌 join - between and, is null, is not null, in, not in등 
    
-- 문법에 따른 구분
--1. ANSI 표준문법 : DBMS에 상관없이 사용할수 있는 표준 sql문법. join 키워드 사용
--2. Vendor사 문법 : oracle문법 join키워드 없이 ,(콤마) 사용

-- 기준컬럼명이 다른 경우
select * from employee;
select * from department;

--컬럼명이 다르기 때문에 별칭이 없어도 구분할 수 있다.
--되도록 별칭을 명시해서 가독성을 높힐것.
select *
from employee E join department D
    on D.dept_id = E.dept_code
order by 1;


-- 기준컬럼명이 같은 경우
select * from job;
select * from employee;

--테이블 별칭을 반드시 사용해야 한다.
select *
from employee E join job J
    on E.job_code = J.job_code; -- ORA-00918: column ambiguously defined

--location nation 테이블을 조인해서 출력하세요.
select local_code,
       L.national_code,
       local_name,
       national_name
from location L join nation N
    on L.national_code = N.national_code
order by 1;

--기준컬럼명이 같다면 using(컬럼명)을 통해 조인할수 있다.
--using에 사용한 컬럼은 별칭으로 접근할 수 없다. ORA-25154: column part of USING clause cannot have qualifier
select national_code, 
       n.national_name
from location L join nation N
    using(national_code);
    
-- 1. inner join 내부조인 : 교집합
-- 2. outer join 외부조인 : 합집합 left, right, full 
-- 3. cross join : 모든 경우의 수를 고려한 조인
-- 4. self join : 같은 테이블을 조인
-- 5. multiple join 

--------------------------------------
-- INNER JOIN
--------------------------------------
-- (inner) join : inner키워드는 생략이 가능.
-- 교집합. 
--기준컬럼의 값이 상대테이블에서 없는 경우, 기준컬럼의 값이 null인 경우는 result set에서 제외됨.
select * from department;

select *
from employee E inner join department D
    on E.dept_code = D.dept_id -- 22행
order by 1; 
--인턴 제외 : 기준컬럼의 값이 null인 경우
--D3, D4, D7 제외 : 기준컬럼의 값이 상대테이블에서 없는 경우

--(oracle)
--,(컴마)를 사용해서, 조인할 테이블 나열. 조인조건은 where절에 작성
select *
from employee E, department D
where E.dept_code = D.dept_id;

-----------------------------------------
-- OUTER JOIN
-----------------------------------------
--1. left (outer) join
--좌측테이블의 모든 행을 리턴
--우측테이블에 기준컬럼이 동일한 행을 리턴
--기준컬럼이 null이라면, 우측테이블의 모든 컬럼을 null처리
select *
from employee E left outer join department D
    on E.dept_code = D.dept_id
order by 1;

select *
from  department D right outer join employee E
    on E.dept_code = D.dept_id
order by 1;

--(oracle)
--기준컬럼(좌측) 반대편에 (+)기호를 붙여줌.
select *
from department D, employee E
where E.dept_code = D.dept_id(+);


--22 + 2

--2. right outer join 

select *
from employee E right outer join department D
    on E.dept_code = D.dept_id
order by 1;

--(oracle)
select *
from employee E, department D
where E.dept_code(+) = D.dept_id;

--22 + 3 = 25

--3. full outer join
--좌측테이블, 우측테이블 모든 행 사용
select *
from 
    employee E full outer join department D
    on E.dept_code = D.dept_id
order by 1;

--(oracle) 전용문법에서는 full outer join을 지원하지 않는다.

-- 22 + 2 + 3 = 27

-------------------------------------
-- CROSS JOIN
-------------------------------------
-- 상호조인. Cartesian Product 모든 경우의 수
-- 24 * 9 = 216
select *
from employee E cross join department D;

-- 사원명, 월급, 평균월급 조회

select E.emp_name, 
       E.salary, 
       A.avg, 
       E.salary - A.avg diff
from employee E 
    cross join (select trunc(avg(salary)) avg
                from employee) A;

select *
from employee E 
    cross join (select trunc(avg(salary)) avg
                from employee) A;

select trunc(avg(salary)) avg
from employee;

--(oracle) where 조건절을 명시하지 않으면 자동으로 cross join
-- 216 = 24 * 9
select *
from employee E, department D;


------------------------------------------
-- SELF JOIN
------------------------------------------
-- 같은 테이블을 조인. 
-- 사원별 관리자의 이름을 조회

select A.emp_id,
       A.emp_name,
       A.manager_id,
       B.emp_id,
       B.emp_name
from employee A inner join employee B 
    on A.manager_id = B.emp_id;
    

--(oracle)
select A.emp_id,
       A.emp_name,
       A.manager_id,
       B.emp_name
from employee A, employee B
where A.manager_id = B.emp_id;


---------------------------------------------
-- MULTIPLE JOIN
---------------------------------------------
--3개 이상의 테이블 순서대로 조인
--ANSI문법에서는 테이블 작성 순서 중요!

--employee - department - location - nation
select * from employee; --dept_code
select * from department; --dept_id, location_id
select * from location; -- local_code, national_code
select * from nation; --national_code

--기준컬럼이 null이거나 -> E.dept_code 가 null인 행
--상대테이블에서 동일한 값을 갖는 기준컬럼이 존재하지 않는 경우 -> D3, D4, D7는 E.dept_code에 존재하지 않는다.
select *
from employee E
    left join department D 
        on E.dept_code = D.dept_id
    left join location L
        on D.location_id = L.local_code
    left join nation N
        on L.national_code = N.national_code;

select E.*,
       D.dept_title,
       L.local_name,
       N.national_name
from employee E
    left join department D 
        on E.dept_code = D.dept_id
    left join location L
        on D.location_id = L.local_code
    left join nation N
        on L.national_code = N.national_code
where L.local_name = 'ASIA2';

select *
from employee E, department D, location L, nation N
where E.dept_code = D.dept_id(+)
    and D.location_id = L.local_code(+)
    and L.national_code = N.national_code(+);

-- 직급이 대리이면서, ASIA지역에 근무하는 사원조회
-- 사번, 이름, 직급명, 부서명, 지역명(local_name), 급여
select E.emp_id, E.emp_name, J.job_name, D.dept_title,
        L.local_name, E.salary
from employee E
    left join job J on E.job_code = J.job_code
    left join department D on E.dept_code = D.dept_id
    left join location L on D.location_id = L.local_code
where J.job_name = '대리' and L.local_name like 'ASIA%';

--select E.emp_id,
--       E.emp_name,
--       J.job_name,
--       D.dept_title,
--       L.local_name
--from employee E 
--    left join department D
--        on E.dept_code = D.dept_id
--    left join location L
--        on D.location_id = L.local_code
--    left join job J
--        using(job_code)
--where L.local_name like 'ASIA%'
--    and J.job_name = '대리';

select E.emp_id,
       E.emp_name,
       J.job_name,
       D.dept_title,
       L.local_name
from employee E, department D, location L, job J
where E.dept_code = D.dept_id(+)
    and D.location_id = L.local_code(+)
    and E.job_code = J.job_code
    and L.local_name like 'ASIA%'
    and J.job_name = '대리';

--non-equi join
--동등비교조건(=)외의 조건으로 조인하는 경우
select *
from sal_grade;

--급여등급 조회 employee.salary between sal_grade.min_sal 
--            and sal_grade.max_sal

select emp_name, salary, SG.sal_level
from employee E
    join sal_grade SG
        on E.salary between SG.min_sal and SG.max_sal
order by 3 desc,2;



--===============================
-- SET OPERATOR
--===============================
--집합연산자
--여러 개의 질의 결과(결과집합 result set)를 세로로 연결해서 하나의 가상테이블을 리턴함.

--조건
-- 1. 컬럼수가 동일해야한다.
-- 2. 동일위치의 컬럼은 자료형이 상호호환 가능(char, varchar2 상호호환 가능)
-- 3. 컬럼명이 다른 경우 첫번째 컬럼명을 사용
-- 4. order by절은 맨 마지막에 한번만 사용가능

-- union 합집합
-- union all 합집합
-- intersect 교집합
-- minus 차집합

/*
A = {1, 5, 3}
B = {2, 3, 4}

union -> {1, 2, 3, 4, 5} 중복제거, 첫번째 컬럼 기준 오름차순 정렬
union all -> {1, 5, 3, 2, 3, 4} 
intersect -> {3} 모든 컬럼이 일치하는 행만 리턴
minus -> A-B = {1, 5}, B-A = {2, 4}  

*/
--A : 부서코드 D5인 사원조회 결과집합
select emp_id, emp_name, dept_code, salary
from employee
where dept_code = 'D5';--6

--B : 급여가 300만원이상이 사원조회 결과집합
select emp_id, emp_name, dept_code, salary
from employee
where salary >= 3000000;--9

select emp_id, emp_name, dept_code, salary
from employee
where dept_code = 'D5'
union
select emp_id, emp_name, dept_code, salary
from employee
where salary >= 3000000
order by 4;


select emp_id 사원, emp_name 사원명, dept_code 부서코드, salary 급여
from employee
where dept_code = 'D5'
union all
select emp_id, emp_name, dept_code, salary
from employee
where salary >= 3000000;

--intersect 
select emp_id 사원, emp_name 사원명, dept_code 부서코드, salary 급여
from employee
where dept_code = 'D5'
intersect
select emp_id, emp_name, dept_code, salary
from employee
where salary >= 3000000;


--minus
select emp_id 사원, emp_name 사원명, dept_code 부서코드, salary 급여
from employee
where dept_code = 'D5'
minus
select emp_id, emp_name, dept_code, salary
from employee
where salary >= 3000000;


--=========================================
-- SUB-QUERY
--=========================================
--sql문 안의 또 다른 sql문을 가리킨다.
--main-query에 종속적인 관계를 가지고 있다.

--1. 반드시 소괄호로 묶어 사용할 것.
--2. 연산자 우항에 작성할 것.
--3. order by문법이 지원 안됨.

--노옹철 직원의 관리자 이름을 조회
select E2.emp_name
from employee E1 join employee E2
    on E1.manager_id = E2.emp_id
where E1.emp_name = '노옹철';
 
--서브쿼리 
--노옹철 -> manager_id -> emp_id -> emp_name

select emp_name
from employee
where emp_id = (select manager_id
                from employee
                where emp_name = '노옹철');

select manager_id
from employee
where emp_name = '노옹철';

--평균급여보다 많은 급여를 받는 사원 조회

select avg(salary)
from employee;

select *
from employee
where salary > (select avg(salary)
                from employee);

-- 유형
--1. 단일행 단일컬럼
--2. 다중행 단일컬럼 
--3. 다중열 (단일행/다중행)
--4. 상(호연)관
--5. scala(단일값)
--6. inline-view

-----------------------------------
-- 단일행 단일컬럼 subquery
-----------------------------------
--조회결과가 1행1열인 경우

--윤은해 사원과 동일한 급여를 받는 사원 조회(사번, 사원명, 급여)
--1.윤은해 사원급여 a -> sub
--2.급여가 a와 동일한 사원 조회 -> main

select emp_id, emp_name, salary
from employee
where salary = (select salary
                from employee
                where emp_name = '윤은해')
    and  emp_name != '윤은해';

select salary
from employee
where emp_name = '윤은해';

--직급이 대리인 사원 조회(사번, 사원명)

select * from job;
--join : employee * job
select E.emp_id,
       E.emp_name
from employee E join job J
    using(job_code)
where J.job_name = '대리';

--sub-query : employee.job_code = (직급코드)
select emp_id, 
       emp_name
from employee
where job_code = (select job_code
                  from job
                  where job_name = '대리');

-------------------------------------------------
-- 다중행 단일컬럼 sub-query
-------------------------------------------------
-- in | not in, any(some), all, exists

--송종기, 하이유과 같은 부서원을 조회하세요.
select dept_code
from employee
where emp_name in ('송종기', '하이유');

select emp_name, dept_code
from employee
where dept_code in (select dept_code
                    from employee
                    where emp_name in ('송종기', '하이유'));
--where dept_code in ('D9', 'D5')

-- 차태연, 박나라, 이오리사원과 같은 직급의 사원조회(사원명, 직급명)

select E.emp_name, 
       J.job_name
from employee E 
    join job J using(job_code)
where job_code in (select job_code
                      from employee
                      where emp_name in ('차태연', '박나라', '이오리'))
    and emp_name not in('차태연', '박나라', '이오리')
order by 2;
    
select job_code
from employee
where emp_name in ('차태연', '박나라', '이오리');

--not in
select emp_name, dept_code
from employee
where dept_code not in (select dept_code
                    from employee
                    where emp_name in ('송종기', '하이유'));


-- 직급이 대표, 부사장이 아닌 사원의 사원 조회(사원명, 직급코드)
-- job.job_name

select emp_name, job_code
from employee
where job_code not in (select job_code
                        from job
                        where job_name in ('대표','부사장'))
order by 2;

-- ASIA1지역에 근무하는 사원 조회 (사번, 사원명)
-- location.local_name
-- join하지 말것.
-- employee(dept_code) - (dept_id)department(location_id) - (local_code)location

select emp_id, emp_name
from employee
where dept_code in (select dept_id
                    from department
                    where location_id = (select local_code
                                        from location
                                        where local_name = 'ASIA1'));

-------------------------------------------------
-- 다중열 sub-query
-------------------------------------------------
--단일행,다중행 동일한 문법으로 사용가능

--퇴사한 직원이 한명 있는데, 
--그 직원과 같은 부서, 같은 직급의 사번, 사원명으로 조회

select dept_code, job_code
from employee
where quit_yn = 'Y';

select emp_id, emp_name, dept_code, job_code
from employee
where (dept_code, job_code) in (select dept_code, job_code
                                from employee
                                where quit_yn = 'Y');
                                
--직급별 최소급여를 받는 사원 조회(사원명, 직급코드, 급여)

select job_code, min(salary)
from employee
group by job_code;

select emp_name, job_code, salary

from employee
where (job_code, salary) in (select job_code, min(salary)
                            from employee
                            group by job_code)
order by 2;

--부서별로 최대급여, 최소급여를 받는 사원 조회(사원명, 부서명, 급여)

select dept_code, max(salary)
from employee 
group by dept_code;

-- 인턴사원중 최대/최소 급여 사원 포함시키기
select emp_name, nvl(D.dept_title, '인턴') dept_title, salary
from employee E 
    left join department D
        on E.dept_code = D.dept_id
where (nvl(dept_code, '인턴'), salary) 
                                in (select nvl(dept_code, '인턴'), max(salary)
                                from employee
                                group by dept_code)
    or (nvl(dept_code, '인턴'), salary)
        in (select nvl(dept_code, '인턴'), min(salary)
                                from employee
                                group by dept_code);

-------------------------------------------------
-- 상관 sub-query
-------------------------------------------------
-- 상호연관 서브쿼리
-- main-query의 값을 sub-query전달하고, 그결과를 다시 main-query에 리턴해서 처리하는 방식
-- 각행마다 비교값이 다른 경우(각행의 컬럼값이 sub-query에 필요한 경우) 유용하다.
-- main-query의 table별칭이 반드시 필요하다.

-- 일반 sub-query : 단독으로 사용.
-- 상관 sub-query : main-query로부터 값을 전달받아 사용.

--직급별 평균급여보다 많은 급여를 받는 사원 조회

select emp_name, job_code, salary
from employee E
where salary > (select avg(salary)
                from employee
                where job_code = E.job_code)
order by 2;

--sub-query
select avg(salary)
from employee
where job_code = 'J2';

select job_code, trunc(avg(salary))
from employee
group by job_code;

--부서코드별 평균급여보다 많은 급여를 받는 사원 조회
--(인턴포함)
select emp_name, nvl(dept_code,'인턴'), salary
from employee E
where salary > (select avg(salary)
                from employee
                where nvl(dept_code, 1) = nvl(E.dept_code, 1));

--exists
--sub-query의 결과집합에 행이 존재하면 true를 리턴, 
--0행을 리턴(sub-query)하면 false를 리턴(main-query)

select *
from employee
where 1 = 1; -- 무조건 true

select *
from employee
where 1 = 2; -- 무조건 false

select *
from employee
where exists (select * from employee where dept_code = 'D100');

--관리자인 사원 조회
--누군가의 manager_id 컬럼에 본인의 emp_id가 사용되는 경우
select *
from employee E
where exists (select * 
              from employee 
              where manager_id = E.emp_id);

select * 
from employee 
where manager_id = '202';

-- 부서테이블에서 부서원이 존재하는 부서 조회(부서코드, 부서명)

select dept_id, d.dept_title
from department D
where exists (select 1 from employee where dept_code = D.dept_id)
order by 1;

-------------------------------------------------
-- scala sub-query
-------------------------------------------------
-- select절에 사용된 결과값 하나(1행1열)인 상관 서브쿼리.

-- 사번, 사원명, 관리자사번, 관리자명을 조회

select emp_id, 
       emp_name, 
       manager_id,
       (select emp_name from employee 
       where emp_id = E.manager_id) manager_name
from employee E;


-- @실습문제 : 사원, 부서코드, 급여, 부서별 평균급여를 조회
-- join없이 부서별 평균급여는 scala sub-query 사용할 것

select emp_name,
       dept_code,
       salary,
       (select trunc(avg(salary))
        from employee
        where dept_code = E.dept_code) avg_by_dept_code
from employee E;


--사원별로 전체평균급여와 차이를 조회
-- 전체평균급여를 함께 조회

select emp_name,
       salary,
       (select trunc(avg(salary)) from employee) avg_sal,
       salary - (select trunc(avg(salary)) from employee) diff
from employee;

-------------------------------------------------
-- inline-view
-------------------------------------------------
--from절에 사용한 sub-query를 inline-view라고 함.

-- view란?
-- 실제테이블에 근거해서 만들어진 가상테이블. 복잡한 쿼리를 계층적으로 단순화 시킬수 있다.
-- 1. inline-view : 1회성으로 사용
-- 2. stored-view : 데이터베이스객체로 저장해서 재사용 가능.

-- 여자 사원 조회

select E.*,
       decode(substr(emp_no, 8, 1), '1', '남', '3', '남', '여') gender
from employee E
where decode(substr(emp_no, 8, 1), '1', '남', '3', '남', '여') = '여';

select emp_name, dept_code, gender
from (
      select E.*,
             decode(substr(emp_no, 8, 1), '1', '남', '3', '남', '여') gender
      from employee E
      )
where gender = '여';

-- 30,40대 여자사원 조회(사번, 사원명, 성별, 나이)
-- 나이, 성별 컬럼이 포함된 inline-view 활용
select emp_id, emp_name, gender, age
from (select E.*, decode(substr(emp_no,8,1),'1','남','3','남','여') gender,
      extract(year from sysdate) - 
      (decode(substr(emp_no,8,1),'1',1900,'2',1900,2000) +
      substr(emp_no,1,2)) + 1 age
      from employee E)
where (age between 30 and 49) and gender = '여';

--============================================
-- 고급 쿼리
--============================================

----------------------------------------------
-- TOP-N 분석
----------------------------------------------
--상위n개, 하위n개의 행을 조회

--rownum | rowid
--테이블 구조에 제공되는 가상컬럼
--rowid : 특정 레코드(행)에 접근하기 위한 논리적 주소값. 데이터 추가시 자동으로 부여
--rownum : 각행에 대한 일련번호. 데이터추가지 1씩 증가하며 자동으로 부여. 
--         테이블행에 대한 rownum은 변경불가. 
--         where절, inline-view를 통해 테이블형태가 바뀌는 경우는 새로부여됨.
select rownum, rowid, E.*
from employee E
--order by emp_name;
order by rownum;
--급여 상위 TOP-5 조회

select rownum, 
       emp_name,
       salary
from (
    select rownum old, emp_name, salary
    from employee E
    order by salary desc
    ) E
where rownum < 6;

--직급이 대리인 사원중에서 급여 상위 3명을 조회

select emp_name, job_name, salary
from (
    select *
    from employee E 
        join job J using(job_code)
    where job_name = '대리'
    order by salary desc
    )
where rownum <= 3;

--부서별 급여평균 TOP-3 조회(부서명, 평균급여)

select rownum 순위,
       (select dept_title from department where dept_id = E.dept_code) 부서명,
       avg 평균급여
from (
    select dept_code, trunc(avg(salary)) avg
    from employee
    group by dept_code
    order by avg desc
    ) E
where rownum <= 3;


--급여 상위 6위 ~ 10위 조회
select *
from(
    select emp_name, salary
    from employee
    order by salary desc
)
where rownum between 6 and 10;
--> 1부터 접근하는 것이 아니고 offset이 생기면 나오지 않음.
--rownum의 완벽한 결과는 where절이 끝난 이후에 얻을 수 있음.
--1부터 순차적으로 처리하지 않는다면, 
--inline-view레벨을 하나 더 사용하게 된다.
-->
select * --level3
from (  
    select rownum rnum, E.* --level2
    from(   
        select emp_name, salary --level1
        from employee
        order by salary desc
        ) E
    ) E
where rnum between 6 and 10;

-- 부서별 평균급여랭킹에 4~6위 조회 (부서명, 평균급여)
select *
from (
    select rownum rnum, E.*
    from 
        (select nvl(
            (select dept_title 
            from department 
            where E.dept_code = dept_id),'인턴') 부서명,
            trunc(avg(salary)) "부서별 평균급여"
        from employee E
        group by dept_code
        order by 2 desc) E
    ) E
where rnum between 4 and 6;

----------------------------------------------------------
-- WINDOW FUNCTION
----------------------------------------------------------
--행과 행간의 관계를 쉽게 정의하기 위한 표준함수
--select절에만 사용 가능
-- 1. 순위함수
-- 2. 집계함수
-- 3. 분석함수
--window function(argument) 
--      over([partition by절][order by절][window절])
-- args : 0 ~ n개의 인자를 전달(비워두는 경우 많음)
-- partition by : grouping에 대한 설정
-- order by : 정렬기준 설정
-- windowing : 대상 행을 설정

--순위함수
--rank() over ()

select emp_name,
       salary,
       rank() over(order by salary desc) 순위,
       dense_rank() over(order by salary desc) dense_rank
from employee;

--급여 순위
select *
from (
        select emp_name,
               salary,
               rank() over(order by salary asc) rank,
               dense_rank() over(order by salary desc) dense_rank
        from employee
    ) E
where rank between 6 and 10;

-- 입사일이 빠른 10위 10명의 사원 조회

select *
from(
    select emp_name,
           hire_date,
           rank() over(order by hire_date asc) rank
    from employee
    ) E
where rank <= 10;

-- 부서별로 급여랭킹 3위까지 조회
select *
from
    (select nvl(dept_code,'인턴') 부서,
           emp_name 사원명,
           salary 봉급,
           rank () over(partition by dept_code 
                        order by salary desc) rank
    from employee) E
where rank <= 3;

-- 직급별로 급여 상위 3명 조회
select *
from 
    (select job_code,
           emp_name,
           salary,
           rank() over(partition by job_code
                       order by salary desc) rank
     from employee) E
where rank <= 3;

-- 집계함수
-- sum() over()
-- 사원명, 급여, 전체급여합계
select emp_name,
       dept_code,
       salary,
       (select sum(salary) from employee) sum,
        sum(salary) over() 전체급여합계,
        -- 윈도우함수는 일반 컬럼하고 함께 사용할 수 있다.
        sum(salary) over(order by salary) 전체급여누계,
        sum(salary) over(partition by dept_code) 부서별급여합계
from employee
-- 전체급여누계에서 order by에 의해 정렬이 되지만,
-- 아래의 order by절이 select절보다 후에 실행이 되므로
-- 새로 정렬을 지정해줄 수 있다.
order by 2;

--avg() over()

select emp_name,
       dept_code,
       trunc(avg(salary) over(partition by dept_code)) dept_avg,
       trunc(avg(salary) over()) avg
from employee;

--=======================================================
-- DML
--=======================================================
-- Data Manipulation Language 데이터 조작어
-- 테이블의 데이터를 삽입 create, 조회 read, 
-- 수정 update, 삭제 delete하기 위한 명령어 : CRUD
-- insert
-- select
-- update
-- delete

-------------------------------------------------------
-- INSERT
-------------------------------------------------------
-- 새로운 행을 추가하는 명령어
-- insert into 테이블 values(데이터1, 데이터2, ...);
-- 테이블에 존재하는 컬럼 순서대로 데이터를 추가, 생략할 수 없다.
-- insert into 테이블(컬럼1, 컬럼2, ...) values (데이터1, 데이터2, ...);
-- 테이블 컬럼 중 일부를 선택적으로 추가할 수 있다.
-- 단 not null 컬럼은 생략할 수 없다.
-- 단 not null이어도 기본값이 지정되면 생략할 수 있다.

-- emp_copy 테이블 생성
create table emp_copy
as
select *
from employee;

select * from emp_copy;

desc emp_copy;

--서브쿼리를 이용한 테이블생성에서는 not null을 제외한
--제약조건, 기본값 등이 누락된다.
alter table emp_copy
add constraint pk_emp_copy primary key(emp_id)
modify quit_yn default 'N'
modify hire_date default sysdate;

--1. 컬럼명 없이 데이터 추가하기
insert into emp_copy
values(
    '301','함지민','780808-2123456',
    'ham@kh.or.kr','01012341234', 'D1',
    'J4','S3',4300000,
    0.2,'200',sysdate,
    null,'N'
);

--2. 컬럼명과 함께 insert하기
insert into emp_copy
(emp_id, emp_name, emp_no, job_code, sal_level)
values ('302','구술기','900909-2345678','J5','S4');

--실제 db서버에 적용
commit;
--dml 명령어는 commit명령을 처리했을 때만,
--메모리에 현재 작업 내용이 저장이 된다.
--DML구문은 실행후 반드시 TCL commit 처리해야 한다.
--DDL 구문은 TCL 명령 없이 자동으로 서버에 적용된다.
--commit은 마지막 commit 시점 이후 변경내역을 db서버에 적용
--rollback은 마지막 commit 시점 이후 변경내역을 실행취소
-- TCL

--emp_copy에 사원 2명을 추가
select * from emp_copy;
desc emp_copy;
insert into emp_copy
values ('305','김진진','909011-1122334','jian4@kh.or.kr',
        '01022334455','D3','J4','S5',3350000,0.2,'200',
        to_date('20201012'),null,'N');
insert into emp_copy
(emp_id, emp_name, emp_no, email, phone,
 job_code, sal_level, salary, bonus, quit_date, quit_yn)
values ('306','홍길순','809038-1153153','jita@kh.or.kr',
        '01011030313','J3','S5',3504030,0.2,null,'N');

rollback;
select * from emp_copy;

--sub-query를 이용한 insert
--모든 행을 삭제
delete from emp_copy;
rollback;

insert into emp_copy(
    select *
    from employee
);

-- insert all
-- 한 테이블의 데이터르르 복수개의 테이블에 추가하는 경우
create table emp_dept_2
as
select * 
from emp_copy
where 1 = 0; 
--> false 테이블의 구조만 복사하고, 데이터는 복사하지 않는다.

select * from emp_dept_2;

--emp_copy -> emp_dept_2 | emp_dept_9
insert all
when dept_code = 'D2' then 
         into emp_dept_2 values (emp_id, emp_name, emp_no, 
                        email, phone, dept_code, job_code, 
                        sal_level, salary, bonus, manager_id, 
                        hire_date, quit_date, quit_yn)
when dept_code = 'D9' then
         into emp_dept_9 values (emp_id, emp_name, emp_no, 
                        email, phone, dept_code, job_code, 
                        sal_level, salary, bonus, manager_id, 
                        hire_date, quit_date, quit_yn)
select *
from employee;
rollback;
select * from employee where dept_code in ('D9','D2');

----------------------------------------------------------
-- UPDATE
----------------------------------------------------------
--기존레코드의 컬럼 일부를 수정하는 명령
--where 조건절을 정확히 지정할 것.

select * from emp_copy;

update emp_copy
set emp_name = '고둘밋', phone = '01033334444'
where emp_id = '223';

--마찬가지로 commit을 해야 실제 db 서버에 올라간다.
commit;

update emp_copy
set salary = salary + 500000
where dept_code = 'D9';

update emp_copy
set emp_name = '홍길동';
--> 위와 같이 하면 모든 행의 이름이 홍길동으로 바뀐다.
-- 따라서 rollback 해준다.
rollback;

-- emp_copy의 데이터를 employee로부터 채우고,
-- 임시환 사원의 직급을 과장, 부서를 해외영업 3부로 변경
-- 방명수 사원을 삭제하세요
insert into emp_copy(
    select * from employee
);
update emp_copy
set job_code = (select job_code from job where job_name = '과장'),
    dept_code = (select dept_id from department where dept_title = '해외영업3부')
where emp_name = '임시환';
delete from emp_copy where emp_name = '방명수';
commit;

----------------------------------------------------------
-- DELETE
----------------------------------------------------------
-- 테이블의 행(레코드)를 삭제

delete from emp_copy
where emp_id = '223';

delete from emp_copy; -- 모든행을 삭제
rollback; -- 마지막 커밋시행 기준으로 복구가 가능.
          -- before image로 되돌림.
          
-- truncate 테이블 전체 행을 삭제하는 명령
-- DDL 명령어이므로, 자동 commit된다.
truncate table emp_copy;

--===========================================================
-- DDL
--===========================================================
--Data Definition Language 데이터 정의어
-- 데이터베이스 객체에 대해서 생성 create, 수정 alter, 삭제 drop하는 명령어
-- 데이터베이스 객체
-- table | view | sequance | index | package |
-- procedure | function | trigger | synonym | user
-- 자동 commit되므로 주의해서 실행할 것.

------------------------------------------------
-- create
------------------------------------------------
-- 객체 생성
-- 컬럼명 자료형 기본값 제약조건
create table member(
    id varchar2(20) not null,
    password varchar2(25) not null,
    name varchar2(50),
    reg_date date default sysdate
);
--------------------------------------------------------
-- NOT NULL | UNIQUE
--------------------------------------------------------
--drop은 항상 주석해놓는 습관
--drop table member;
create table member(
    id varchar2(20) not null,
    password varchar2(20) not null,
    name varchar2(50) not null,
--    email varchar2(100) constraint uq_member_email unique, --컬럼레벨
    email varchar2(100) not null, --not null은 컬럼레벨에서 추가
    phone char(11) not null
    --테이블 레벨(보통은 이렇게 씀)
    constraint uq_member_email unique (email)
);

--제약조건
--1. 컬럼레벨 : 컬럼명 기술한 같은 줄에 작성
--2. 테이블레벨 : 별도의 줄에 작성
-- 되도록 테이블레벨로 작성할 것.
-- 제약조건명은 반드시 작성할 것. (not null 제외) 
insert into member
values ('hongd', '1234', null, null, '01012341234');
--ORA-01400: cannot insert NULL into ("KH"."MEMBER"."NAME")

--email컬럼에 동일한 값이 존재하면 중복할 수 없다.
insert into member
values ('hongd', '1234', '홍길동', 'honggd@naver.com', '01012341234');
--ORA-00001: unique constraint (KH.UQ_MEMBER_EMAIL) violated

-- unique 제약조건이 걸려있어도 null값은 여러 번 입력 가능하다.
-- dbms마다 처리방식이 다르다.
insert into member
values ('sinsa', '1234', '신사임당', null, '01012341234');


--주석
--table
--column

--주석 확인
--Data Dictionary에서 확인
select *
from user_tab_comments
where table_name = 'EMPLOYEE';

-- 수정, 삭제 함수는 없음.
comment on table member is '';  -- 빈문자열 ''은 null을 의미
-- comment on table member is null; -- 문자열로 작성(이렇게는 못 씀)

-- 컬럼주석 확인
select*
from user_col_comments
where table_name = 'MEMBER';

comment on column member.id is '회원아이디';
comment on column member.password is '비밀번호';
comment on column member.name is '회원이름';
comment on column member.reg_date is '회원';

--=======================================================
-- 제약조건 constraint
--=======================================================
-- 테이블 작성시에 각 컬럼에 대해서 데이터 무결성을 위해 설정

--1. not null(C) : 데이터에 null을 허용하지 않음 -> 필수
--2. unique(U) : 중복된 값을 허용하지 않음. -> 주민번호, 이메일
--3. primary key(P) : 기본키. 행(레코드)의 식별자 컬럼을 지정. 
--                 not null + unique, 테이블 당 하나만 사용 가능
--                 -> 아이디, 고유코드
--4. foreign key(R) : 외래키. 두 테이블간의 부모 자식 참조관계를 설정.
--                 부모테이블에 존재하는 값만 자식테이블에서 사용 가능
--5. check : domain 안에서만 값을 설정하도록함. -> 성별, 퇴사여부

-- 제약조건 확인(C) - Data Dictionary
-- 어느 컬럼에 걸린 제약조건인지는 확인이 안됨.
select *
from user_constraints
where table_name = 'EMPLOYEE'; --대문자로 작성

-- 컬럼명 확인
select *
from user_cons_columns
where table_name = 'EMPLOYEE';

--> 위의 두 테이블을 조인해서 사용하기
select UC.table_name, UCC.column_name, UC.constraint_name, UC.constraint_type, UC.search_condition
from user_constraints UC join user_cons_columns uCC
    on UC.constraint_name = UCC.constraint_Name
where UC.table_name = 'MEMBER';


--------------------------------------------------------
-- PRIMARY KEY
--------------------------------------------------------
-- 테이블 행에 대한 고유 식별자 역할을 하는 제약조건
-- 다른 행(레코드) 구분하기 위한 용도. 중복 또는 null을 허용하지 않는다.
-- 테이블 당 한 개만 가능

--drop table member;
create table member(
    id varchar2(20),
    password varchar2(20) not null,
    name varchar2(50) not null,
--    email varchar2(100) constraint uq_member_email unique, --컬럼레벨
    email varchar2(100) not null, --not null은 컬럼레벨에서 추가
    phone char(11) not null,
    --테이블 레벨(보통은 이렇게 씀)
    constraint pk_member_id primary key(id),
    constraint uq_member_email unique (email)
);

insert into member
values ('honggd', '1234', '홍길동', 'honggd@naver.com', '01012341234');
--ORA-00001: unique constraint (KH.PK_MEMBER_ID) violated


--------------------------------------------------------------
-- FOREIGN KEY
--------------------------------------------------------------
-- 외래키. 참조무결성을 보장
-- 참조하고 있는 부모테이블에서 제공하는 값만 사용하도록 제한함.
-- 자식테이블에서 설정하는 것.
-- 자식테이블에서는 부모테이블의 값 또는 null 값을 사용 가능.
-- 부모테이블의 참조컬럼은 반드시 pk, uq 제약조건이 걸려있어야 함.

create table shop_member (
    id varchar2(20),
    name varchar2(50) not null,
    constraint pk_shop_member_id primary key(id)
);

insert into shop_member values('honggd', '홍길동');
insert into shop_member values('sinsa', '신사임당');
insert into shop_member values('sejong', '세종');

select * from shop_member;
commit;

--상품구매테이블
--drop table shop_buy;
create table shop_buy(
    no number,
    member_id varchar2(20),
    product_name varchar2(100) not null,
    constraint pk_shop_buy_no primary key(no),
    constraint fk_shop_buy_member_id foreign key(member_id)
                                     references shop_member(id)
                                     --on delete set null 
                                    -- 부모행 삭제되면 자식행 null
                                     on delete cascade
                                    -- 부모행 삭제되면 자식행 삭제
);

insert into shop_buy values(1, 'honggd', '축구화');
insert into shop_buy values(2, 'aaaabbbdd', '축구화');
--ORA-02291: integrity constraint (KH.FK_SHOP_BUY_MEMBER_ID) violated - parent key not found
insert into shop_buy values(2, 'sinsa', '족구화');
insert into shop_buy values(3, 'sinsa', '농구화');
insert into shop_buy values(4, 'sejong', '배구화');

insert into shop_buy values(5, null, '배구화'); --fk는 null값은 허용.

select * from shop_buy;

--shop_member 참조되고 있는 회원을 삭제
delete from shop_buy
where member_id = 'honggd';
delete from shop_member
where id = 'honggd';
--ORA-02292: integrity constraint (KH.FK_SHOP_BUY_MEMBER_ID) violated - child record found

-- fk의 삭제옵션
-- 부모 테이블의 행을 삭제할 때, 참조하고 있는 자식 테이블 행에 대한 처리
-- 1. on delete restricted (기본값) - 자식테이블 참조행이 있는 경우,
--                                   부모행 삭제 금지
--                                   ->자식행 삭제 후에 부모행 삭제

-- 2. on delete set null - 부모행 삭제시, 자식테이블 컬럼값을 null로 변환
delete from shop_member
where id = 'sinsa';
select * from shop_member;
select * from shop_buy;

-- 3. on delete cascade - 
delete from shop_member
where id = 'sinsa';

-- 외래키 -> 식별관계 | 비식별관계
-- 1. 식별관계 : 참조하는 컬럼값(pk, uq)을 
--              자식 테이블에서 pk로 사용하는 경우
-- 2. 비식별관계 : 참조하는 컬럼값(pk, uq)을 
--               자식 테이블에서 pk로 사용하지 않는경우

create table shop_nickname(
    member_id varchar2(20),
    nickname varchar2(100),
    constraint pk_shop_nickname_member_id primary key(member_id),
    constraint fk_shop_nickname_member_id foreign key(member_id)
                                      references shop_member(id)
);

insert into shop_nickname
values('honggd', '홍드래곤');

select * from shop_nickname;


--------------------------------------------------------------
-- CHECK
--------------------------------------------------------------

-- 도메인(컬럼이 취할 수 있는 값의 집합)을 제한
-- yes/no, t/f, 1/0, G/S/V, 0~100
-- null 허용

--drop table member;
create table member(
    id varchar2(20) not null,
    password varchar2(50) not null,
    name varchar2(50) not null,
    email varchar2(100) not null,
    phone char(11) not null,
    gender char(1),
    point number,
    constraint pk_member_id primary key(id),
    constraint uq_member_email unique (email),
    constraint ck_member_gender check(gender in ('M', 'F')),
    constraint ck_member_point check(point between 0 and 100)
);

insert into member values('honggd','1234','홍길동',
                          'hdg@naver.com','01012341234','M',90);
insert into member values('sinsa','1234','신사임당',
                          'sinsa@naver.com','01012341234','m',90);
--ORA-02290: check constraint (KH.CK_MEMBER_GENDER) violated
insert into member values('sinsa','1234','신사임당',
                          'sinsa@naver.com','01012341234','M',190);
--ORA-02290: check constraint (KH.CK_MEMBER_POINT) violated


--------------------------------------------------------------
-- alter
--------------------------------------------------------------
-- 데이터베이스 객체에 대해서 수정 명령어

-- sub명령어
-- table의 컬럼/제약조건에 대해서 다음 명령 실행
-- 1. add 컬럼/제약조건
-- 2. modify 컬럼(제약조건 수정 안됨)
-- 3. rename 컬럼/제약조건
-- 4. drop 컬럼/제약조건

create table tb_product(
    no number,
    name varchar2(50)
);

-- add 컬럼
alter table tb_product add price number default 0;
desc tb_product;

-- add 제약조건
-- not null 제약조건 add가 아니라 modify sub 명령어를 사용해야 한다.
alter table tb_product add constraint pk_tb_product_number primary key(no);

-- 제약조건 조회
select UC.table_name, UCC.column_name, UC.constraint_name, UC.constraint_type, UC.search_condition
from user_constraints UC join user_cons_columns uCC
    on UC.constraint_name = UCC.constraint_Name
where UC.table_name = 'TB_PRODUCT';

-- 제약조건 이름 변경
alter table tb_product 
rename constraint SYS_C007188 to nn_product_name;
-- modify 컬럼
-- 자료형, 컬럼의 default값 변경 가능
-- 데이터가 있는 경우 자료형변경 제한적으로 가능.
-- 실제 저장된 데이터보다 큰 사이즈로만 가능하다.
desc tb_product;
alter table tb_product modify name varchar2(1000);

--not null 제약조건 추가
alter table tb_product
modify product_name not null;

--rename 컬럼
alter table tb_product
rename column no to product_no;

alter table tb_product
rename column name to product_name;
desc tb_product;

--rename 제약조건
--제약조건은 이름 외에는 변경할 수 없다.

--drop 컬럼
alter table tb_product
drop column price;

-- drop 제약조건
alter table tb_product
drop constraint PK_PRODUCT_NO;

--not null 제약조건도 drop으로 삭제
alter table tb_product
drop constraint NN_PRODUCT_NAME;

--alter
-- add : column , constraint (not null은 add가 아니라 modify로 추가)
-- modify : column. (constraint는 불가능)
-- rename : column, constraint
-- drop : column, constraint

-- rename 테이블
alter table tb_product
rename to tbl_product;
--bin으로 시작하는 것은 삭제된 테이블을 의미
--소유한 테이블 조회
select * from tab;




--===================================================================
-- DCL
--===================================================================

--Data Contrl Language 데이터제어어
--보안, 무결성관련, 권한, 복구 등 DBMS 제어용 명령어
--grant, revoke
--commit, rollback

--------------------------------------------------------------
-- GRANT
--------------------------------------------------------------
--권한, 롤(권한묶음)을 사용자에게 부여
-- grant [권한|롤] to [사용자|롤|PUBLIC] [with admin option]
-- 롤은 권한 묶음임. 권한묶음을 만들기 위해서 권한을 롤에게 부여할 수 있다.
-- grant 권한 to 롤

-- public : db 관리자가 사용하는 것으로, 
-- 해당 권한을 별도의 권환 획득 없이 사용할 수 있도록 함.
-- with admin option : 
   --> 권한을 부여받은 사용자가 다시 다른 사용자에게 권한을 부여할 수 있도록 함.

--kh 계정의 테이블 관련 권한 qwerty에게 부여하기
create table tb_coffee(
    name varchar2(50),
    price number not null,
    brand varchar2(50) not null,
    constraint pk_tb_coffee_name primary key(name)
);

insert into tb_coffee values('맥심', 3000, '동서식품');
insert into tb_coffee values('카누', 4000, '동서식품');
insert into tb_coffee values('네스카페', 3500, '네슬레');

--oracle에서는 사용자 단위로 객체를 소유함.
--사용자가 곧 스키마 schema 이다.
select * from kh.tb_coffee;
select * from tb_coffee; -- 접속 사용자의 tb_coffee를 조회

commit;

--qwerty 계정에서 tb_coffee 조회권한 부여
grant select on tb_coffee to qwerty;
grant insert, update, delete on kh.tb_coffee to qwerty;

----------------------------------------------------------------------
--REVOKE
----------------------------------------------------------------------
--권한 회수

revoke insert, update, delete on kh.tb_coffee from qwerty;

--=====================================================================
-- Database Object 1
--=====================================================================
--Data Dictionary에서 객체 종류 조회
select distinct object_type from all_objects;

----------------------------------------------------------------
-- Data Ditcionary
----------------------------------------------------------------
-- 자원을 효율적으로 관리하기 위해 객체별 메타정보를 저장하는 관리자 테이블
-- 사용자가 객체를 삽입, 수정, 삭제 한다면, 그 즉시 DD에 반영되는 구조
-- 사용자는 읽기전용으로 DD를 사용가능하다.
select * from dict order by 1;

-- DD의 종류 : ???_복수형객체명 user_tables, all_tables
-- 1. user_xxx : 사용자 소유의 객체
-- 2. all_xxx : 사용자 소유의 객체 포함, 사용권한을 부여받은 객체
-- 3. dba_xxx : 관리자 소유의 객체. 일반 사용자는 조회 불가
-- DD는 사용자가 직접 수정하는 것이 아닌, Oracle이 직접 관리한다.
select * from user_tables;
select * from user_constraints;
select * from user_indexes;

select * from all_tables;
-- 일반 사용자는 dba로 시작하는 db를 접근할 수 없다.
select * from dba_tables;

-----------------------------------------------------------------
-- STORED VIEW
-----------------------------------------------------------------
-- 하나 이상의 테이블에서 원하는 데이터를 선택해서 새로운 가상 테이블을 생성함
-- 조회의 목적을 가지며, 실제 데이터를 가지고 있는 것은 아니다.

-- create view 권한은 resource 롤에 포함되지 않으므로, 
-- 관리자로부터 권한 부여가 필요하다.
-- create view view_emp
-- view drop하지 않고 변경하고 싶을 때 or replace
-- table 제외하고 많은 객체에 지원함
create or replace view view_emp
as
select emp_id,
       emp_name,
       substr(emp_no, 1, 8) || '******' emp_no,
       decode(substr(emp_no,8,1), '1','남','3','남','여') gender,
       phone
from employee;

select *
from view_emp;

-- DD에서 조회
select *
from user_views
where view_name = 'VIEW_EMP';
--> 'TEXT' COLUMN에서 보면, 실제로 inline view처럼 작동한다.

-- 타사용자에게 view 권한 부여
grant select on view_emp to qwerty;
-- 직접 테이블에 접근하게 하기 보다는, 
-- view를 생성하고 view에 접근하게 함. 
-- 따라서 실제 사용자는 employee 테이블이 있는지도 모를 수 있음.

-- 사번 사원명 직급명 부서명(null 인턴처리)을 view_emp_read로 생성한 후에
-- qwerty에게 조회할 수 있도록 하세요.
create or replace view view_emp_read
as 
select emp_id 사번, emp_name 사원명, 
       (select job_name from job where job_code = E.job_code) 직급명,
       nvl((select dept_title from department where dept_id = E.dept_code),'인턴') 부서명
from employee E
order by 1;

grant select on view_emp_read to qwerty;

---------------------------------------------------------------------
-- SEQUENCE
---------------------------------------------------------------------
-- 정수값을 순차적으로 발행하는 객체, 채번기
/*
create sequence 시퀀스명
[start with 시작값]
[increment by 증감값]
[maxvalue 숫자 | nomaxvalue]
[cycle | nocycle] 
 순환여부, 최대/최소값에 도달하면 순환, nocycle 선택시는 max/min value 도달시 오류 발생
[cache 숫자 | nocache] 
 메모리상에서 시퀀스값 관리. 기본값은 cache 20

번호가 무조건 순차적이어야하면(번호 유실이 문제된다면), nocache로 지정.
대신, 매번 메모리에 접근해야 하므로 속도가 느린 단점이 있다.
대부분의 경우에는 문제가 되지 않음.
*/
create table tb_user(
    no number,                 --회원고유번호
    user_id varchar2(50),      --회원아이디
    constraint pk_tb_user_no primary key(no)
);

--시퀀스 생성
create sequence seq_tb_user_no
start with 1
increment by 1
nominvalue
nomaxvalue
nocycle
cache 20;

insert into tb_user
values(seq_tb_user_no.nextval, 'honggd');

insert into tb_user
values(seq_tb_user_no.nextval, 'sinsa');

insert into tb_user
values(seq_tb_user_no.nextval, 'sejong');

select * from tb_user;

--DD에서 확인
select * from user_sequences;
--Last Number는 다음에 가져갈 sequence number이다.

--시퀀스객체의 value 확인
select seq_tb_user_no.currval,   -- 시퀀스 객체의 현재 번호
       seq_tb_user_no.nextval    -- 1씩 증가됨
from dual;

-- 위의 nextval을 통해서 sequence 넘기고 행을 넣으면
-- 시퀀스 유실이 일어난다. 하지만, 고유한 값이므로 문제가 되지 않는다.
-- 또한, 20개를 모두 채우면, 다음 번호인 21에서 다시 캐시 20개를 끊어온다.

--주문 전표 생성
--kh-210104-1234번째 주문
create table tb_order(
    order_no varchar2(100),
    user_id varchar2(50) not null,
    product_id varchar2(100) not null,
    cnt number default 1 not null,
    order_date date default sysdate,
    constraint pk_tb_order_no primary key(order_no)
);

create sequence seq_tb_order_no
nocache;

insert into tb_order
values (
    'kh-'|| to_char(sysdate,'yymmdd') 
    || '-' || to_char(seq_tb_order_no.nextval, 'fm0000'),
    'honggd',
    '아이폰12',
    2,
    default
);

select * from tb_order;

-- pl/sql -> procedure | function | trigger

---------------------------------------------------------------------
-- INDEX
---------------------------------------------------------------------
-- 색인

--sql 조회구문등에 처리속도 향상을 위해서 테이블 컬럼에 대해 생성하는 객체.
--key-value 형식으로 생성. 
--key에는 컬럼값, value에는 행이 접근할 수 있는 주소값이 저장

--검색속도가 빨라지고, 시스템 부하를 줄여준다.
--table-full-scan하지 않고, index에서 먼저 검색 후에 찾아낸다.

--인덱스 저장공간 필요, 인덱스를 생성, 갱신하는데도 부가적인 시간이 필요.
--변경작업(insert / update / delete)이 많다면, 
--(실제데이터 처리 + 인덱스 갱신) 시간이 소요되서, 성능저하 유발할 수 있음.

--인덱스 생성시, 어떤 컬럼을 선택해야 하는가?
--선택도가 좋은 컬럼으로 생성해야 함.
--(선택도가 좋다는 것은 중복값이 적다는 의미)
--1. 선택도 좋다 : 
    --> emp_id, emp_no, ,email,emp_name(중복 이 정도는 있어도 됨.)
--2. 선택도 나쁘다 : 
    --> 성별, dept_code, .... 혹은 null값이 많은 컬럼
    
--SS에서 조회
--pk, uq 제약조건이 걸린 컬럼은 자동으로 인덱스를 생성해준다.ㄴ
select *
from user_indexes
where table_name = 'EMPLOYEE';

--실행계획(f10)을 통한 query 비용 비교
--1. 인덱스를 통하지 않은 조회
select * from employee where job_code = 'J5';
--OPTIONS는 FULL TABLE SCAN을 의미함.
select * from employee where emp_name = '송종기';
--아래에서 index 만들어준 다음 다시 조회하면
--RANGE SCAN으로 나온다.

--2. 인덱스를 사용한 조회
--UNIQUE SCAN은 한 행만 찾음을 의미.
select * from employee where emp_id = '201';

--emp_name 컬럼에 인덱스 추가
create index idx_employee_emp_name
on employee(emp_name);

--인덱스 적용하기
--1. where조건절에 자주 사용되는 컬럼은 인덱스 생성
--2. join 기준컬럼은 인덱스 생성
--3. 한 번 입력후에 데이터 변경이 많지 않은 경우
--4. 데이터가 20만~50만건 이상인 경우

--인덱스 사용시 주의사항
-- optimizer가 index 사용여부를 결정, 다음 경우는 인덱스를 사용하지 않음.
--1. 인덱스 컬럼에 변형이 가해진 경
  --> emp_no에 substr 잘라서 사용하는 경우
--2. null 비교
  --> is null, is not null
--3. not 비교 검색
--4. 인덱스컬럼 자료형과 비교하고자 하는 값의 타입이 다른 경우
select * from employee where emp_id = '200'; -- UNIQUE SCAN
select * from employee where emp_id = 200;
  --> 분명히 인덱스가 지정되어 있지만, 숫자로 찾아버리는 경우는 
  --  FULL SCAN으로 찾는다.
select * from employee where emp_no = '621225-1985634'; --UNIQUE SCAN
select * from employee where substr(emp_no,8,1) = '1';
  --> 컬럼에 변형이 가해진 경우 FULL SCAN으로 찾는다.
select * from employee where emp_no like '______-1_____';
  --> like도 FULL로 찾는다.













