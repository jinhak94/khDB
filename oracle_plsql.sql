--======================================================
-- PL/SQL
--======================================================
-- Procedural Language Extention to SQL
-- 오라클 내장 절차적 언어로써, SQL을 확장하여, 변수정의, 조건/반복처리 등을 지원하는 문법

-- 대표적인 유형
--1. 익명블럭 : 일회성으로 PL/SQL 실행구조를 가진 블럭
--2. 프로시져 : PL/SQL 문법을 사용하는 대표적 DB 객체. 다른 프로시져/서브프로그램 등에 의해 호출사용
--3. 함수 : 프로시져와 유사하나 반드시 하나의 리턴값을 갖는 DB객체

--------------------------------------------------------
-- 익명블럭
--------------------------------------------------------

/*
declare
    변수/상수 선언부(선택)
begin
    실행구문(필수)
exception
    예외처리구문(선택)
end;
/ 익명블럭 종료. end; /까지 (필수)
*/

--pl/sql 콘솔출력 설정 : 세션마다 최초 1회 설정할 것.
set serveroutput on;

begin
    --pl/sql출력구문 : dbms_output패키지의 put_line 프로시져 호출
    dbms_output.put_line('안녕하세요');
end;
/

-- 맛보기

declare
    id number;
begin
    select emp_id
    into id --쿼리 조회 결과를 pl/sql 변수에 담음
    from employee
   -- where emp_name = '선동일' ;
    where emp_name = '&사원명' ;

    dbms_output.put_line('id = ' || id);
    -- ||는 sql에서 문자열 연결 연산자
exception
    -- try catch절에서 하는 것과 똑같음
    when no_data_found then dbms_output.put_line('해당 사원이 존재하지 않습니다.');
end;
/

--변수
--자료형 
--1. 일반 sql 자료형(varchar2, char, number, date)을 귿로 사용가능하다.
--2. boolean(true|false|null), pls_integer, binary_integer
--3. 복합자료형 recore, cursor, collection

--타입
--1. 일반변수
--2. 참조변수 : 존재하는 테이블 컬럼 혹은 행의 타입을 가져와 사용할 수 있다.

declare
    a number;
    b varchar2(100) := '안녕'; --값대입연산자:=
    c CONSTANT date := sysdate;
    d boolean;
    emp_name employee.emp_name%type; -- VARCHAR2(20)
begin
    a := 10 * 20;
    d := true;
    dbms_output.put_line(a);
    dbms_output.put_line(b);
    dbms_output.put_line(c);
    if d then
        dbms_output.put_line('참');
        end if;
end;
/

desc employee;

declare
    v_emp_id employee.emp_id%type;
    v_emp_name employee.emp_name%type; --VARCHAR2(20)
    v_emp_no employee.emp_no%type;
    
    emp_row employee%rowtype;
begin
    v_emp_id := &사번;
    select emp_name, emp_no
    into v_emp_name, v_emp_no
    from employee
    where emp_id = v_emp_id;
    
    dbms_output.put_line(v_emp_id || ' : ' || v_emp_name || ' ' || v_emp_no);

    select *
    into emp_row
    from employee
    where emp_id = v_emp_id;
    
    dbms_output.put_line(emp_row.email);
    dbms_output.put_line(emp_row.phone);
end;
/

-- 위의 rowtype은 편하지만, join의 경우에 처리해주기 힘듦
-- 따라서 아래와 같이 record를 통해 customizing해줄 수 있음
--record
declare
    type my_record is record(name employee.emp_name%type, title department.dept_title%type);
    emp_row my_record;
begin    
    select E.emp_name, D.dept_title
    into emp_row
    from employee E
        left join department D
            on E.dept_code = D.dept_id
    where E.emp_id = '&사번';
    
    dbms_output.put_line(emp_row.name);
    dbms_output.put_line(emp_row.title);
end;
/

--@실습문제 : 사원명을 입력받고, 사번, 사원명, 직급명을 출력하는 익명블럭을 작성하세요
-- %type, %rowtype, record
desc employee;
declare
    type my_record is record (id employee.emp_id%type, name employee.emp_name%type, jname job.job_name%type);
    emp_row my_record;
begin
    select E.emp_id, E.emp_name, J.job_name
    into emp_row
    from employee E
        left join job J
            on E.job_code = J.job_code
    where E.emp_name = '&사원명';
    
    dbms_output.put_line(emp_row.id);
    dbms_output.put_line(emp_row.name);
    dbms_output.put_line(emp_row.jname);
end;
/

--pl/sql에서 dml처리도 가능
create table users(
    no number primary key,
    name varchar2(100) not null
);

create sequence seq_users_no;

begin
    insert into users (no, name)
    values(seq_users_no.nextval, '&이름');
    --pl/sql 구문 안에서 함께 transaction 처리
    commit;
end;
/

--조건문
/*
if 조건식 then
    처리구문
end if;

if 조건식 then
    참일 때, 처리구문
else
    거짓일 때, 처리구문
end if;

if 조건식1 then
    처리구문
elsif 조건식2 then
    처리구문
elsif 조건식3 then
    처리구문
end if;
*/

declare
    num number;
begin
    num := &정수;
    
    if mod(num, 2) = 0 then
        dbms_output.put_line('짝수');
    else
        dbms_output.put_line('홀수');
    end if;
    dbms_output.put_line('--- 프로그램 종료---');
end;
/

--@실습문제 : 사번을 입력받고, 직급명을 조회
-- 직급명이 '대표'인 경우, 대표님 안녕하세요 출력
-- 직급명이 '부사장'인 경우, 부사장님 안녕하세요 출력
-- 그 외의 경우, 안녕하세요 출력

declare
    v_job_name job.job_name%type;
begin
    select J.job_name
    into v_job_name
    from employee E
        left join job J
            on E.job_code = J.job_code
    where E.emp_id = '&사번';
    
    if v_job_name in ('대표', '부사장') then
        dbms_output.put_line(v_job_name || '님 안녕하세요');
    else
        dbms_output.put_line('안녕하세요.');
    end if;
end;
/

--조건식 case문
-- 정수를 입력받고, 선물뽑기 게임 익명블럭
declare
--    num number := '&정수';
    num number;
begin
    num := dbms_random.value(1, 100);
    dbms_output.put_line(num);
    num:=trunc(num);
--    case mod(num, 5)
--        when 0 then dbms_output.put_line('인형을 뽑았습니다.');
--        when 1 then dbms_output.put_line('오토바이를 뽑았습니다.');
--        else dbms_output.put_line('꽝입니다.');
--    end case;

    case 
        when mod(num, 5) = 0 then dbms_output.put_line('인형을 뽑았습니다.');
        when mod(num, 5) = 1 then dbms_output.put_line('오토바이를 뽑았습니다.');
        else dbms_output.put_line('꽝입니다.');
    end case;
end;
/

-- 반복문
--1. loop 무한반복
--2. while loop
--3. for loop

declare
    n number := 1;
begin
    loop
        dbms_output.put_line(n);
        n := n + 1;
        --반복문 탈출조건 명시
--        if n > 10 then
--            exit;
--        end if;
        exit when n > 10;
    end loop;
end;
/

--@실습문제 : 1 ~ 10 사이의 난수 10개 출력
declare
    num number;
    i number;
begin
    i := 1;
    loop
        num := dbms_random.value(1, 11);
        num := trunc(num);
        dbms_output.put_line(num);
        i := i + 1;
        exit when i > 10;
    end loop;    
end;
/

declare
    r number;
    i number := 0;
begin
    loop
        r := trunc(dbms_random.value(1, 11));
        dbms_output.put_line(i + 1 || ' : ' || r);
        i := i + 1;
        exit when i > 9;
    end loop;
end;
/

--while loop
declare
    n number := 1;
begin
    while n <= 10 loop
        dbms_output.put_line(n);
        n := n + 1;
    end loop;
end;
/

--for loop
--증감변수를 선언할 필요없다.
--reverse를 사용해 최대값에서 최소값으로 -1 처리 가능
--증감변수를 임의로 변경할 수 없다.
--증가값을 변경할 수 없다.
declare
    s number := 200;
    e number := 210;
    emp_row employee%rowtype;
begin
    for n in s..e loop
        --dbms_output.put_line(n);
        select *
        into emp_row
        from employee
        where emp_id = n;
        
        dbms_output.put_line(emp_row.emp_name);
    end loop;
end;
/

--============================================================
-- FUNCTION
--============================================================
-- 프로시져객체의 파생형. 리턴값이 반드시 하나 존재해야 한다.

/*
create or replace function 함수명(매개변수1, 매개변수2, ...)
return 자료형
is
    --변수선언부
begin
    --실행구문
    return 값;
end;
/
*/

-- 매개변수, 리턴 선언문에는 자료형의 크기를 명시하지 않는다. 쓰면 오류남
create or replace function func_dnameb(name varchar2)
return varchar2
is
    result varchar2(32767); -- pl/sql 자료형은 최대 32767byte까지 가능
begin
    result := 'd' || name || 'b';
    return result;
end;
/
-- Function FUNC_DNAMEB이(가) 컴파일되었습니다. -> 즉시 실행가능한 형태로 저장되었다.

--함수 실행
--1. 일반 sql문에서 사용
select func_dnameb(emp_name)
from employee;

--2. 다른 pl/sql 구문에서 사용
begin
    dbms_output.put_line(func_dnameb('&이름'));
end;
/

--DataDictionary에서 조회
select *
from user_procedures
where object_type = 'FUNCTION';

--성별 조회
select E.*,
        case
            when substr(emp_no, 8, 1) in ('1', '3') then '남'
            when substr(emp_no, 8, 1) in ('2', '4') then '여'
        end gender
from employee E;

select  *
from (
    select E.*,
        case
            when substr(emp_no, 8, 1) in ('1','3') then '남'
            else '여'
        end gender
    from employee E
    )
where gender = '여';

create or replace function func_gender(emp_no employee.emp_no%type)
return char
is
    gender char(3);
begin
    case
        when substr(emp_no, 8, 1) in ('1', '3') then gender := '남';
        else gender := '여';
    end case;
    return gender;
end;
/
select E.*,
    func_gender(emp_no)
from employee E;

--=========================================================
-- PROCEDURE
--=========================================================
-- 일련의 작업절차를 하나의 객체를 만들어 저장. 호출해서 재사용이 가능.
-- 함수와 달리 리턴값이 없다.
-- 전달한 매개변수의 mode(in | out | inout) out을 사용하면, 호출부로 연산결과를 전달할 수 있다.
-- db에 미리 컴파일된 채 저장하므로, 효율성이 좋다.
-- 일반 sql문에 사용불가. execute명령 또는 다른 pl/sql 구문에서 호출할 수 있다.

/*
create or replace procedure 프로시져명(매개변수1이름 mode 자료형, 매개변수2이름 mode 자료형, ...)
is

begin

end;
/

*/

--특정사원정보를 삭제하는 프로시져
create table emp_copy
as
select * from employee;
-- in 프로시져로 매개인자 전달용(기본값)
-- out 프로시져에서 호출부로 전달용
-- inout in + out 
create or replace procedure proc_del_emp(p_emp_id in emp_copy.emp_id%type)
is
    
begin
    delete from emp_copy where emp_id = p_emp_id;
    commit; -- 트랜잭션 처리도 해주어야 함.
end;
/

execute proc_del_emp('223');

select * from emp_copy;

--application procedure 호출시에는 callableStatement 객체를 사용해야한다.

-- call by reference으로 out 매개변수는 작동한다.
create or replace procedure proc_emp_info(
    p_emp_id in emp_copy.emp_id%type,
    p_emp_name out emp_copy.emp_name%type,
    p_phone out emp_copy.phone%type
)
is

begin
    select emp_name, phone
    into p_emp_name, p_phone
    from emp_copy
    where emp_id = p_emp_id;
end;
/

--익명블럭에서 프로시져 호출
set serveroutput on;
declare
    name emp_copy.emp_name%type;
    phone emp_copy.phone%type;
begin
    proc_emp_info('&사번', name, phone);
    dbms_output.put_line('name : ' || name);
    dbms_output.put_line('phone : ' || phone);
end;
/

--upsert 프로시져
--insert + update
create table job_copy
as
select * from job;

select * from job_copy;

--제약조건 추가
alter table job_copy
add constraint pk_job_copy primary key(job_code)
modify job_code varchar2(5)
modify job_name not null;

alter table job_copy
modify job_code varchar2(5);
create or replace procedure proc_upsert_job_copy(
    p_job_code in job_copy.job_code%type,
    p_job_name in job_copy.job_name%type
)
is
    cnt number := 0;
begin
    select count(*)
    into cnt
    from job_copy
    where job_code = p_job_code;
    dbms_output.put_line('cnt = ' || cnt);
    
    if cnt = 0 then
        -- insert
        insert into job_copy
        values(p_job_code, p_job_name);
    else
        -- update
        update job_copy
        set job_name = p_job_name
        where job_code = p_job_code;
    end if;
    --트랜잭션 처리
    commit;
end;
/


--테스트
execute proc_upsert_job_copy('J8', '인턴');
execute proc_upsert_job_copy('J8', '수습');
select * from job_copy;
select * from user_procedures;
commit;

--============================================================
-- CURSOR
--============================================================
--SQL문 실행결과 ResultSet을 가리키는 포인터
--한행 이상인 경우도 행단위로 순차적으로 접근할 수 있다.

-- 커서의 처리과정
-- OPEN -- FETCH -- CLOSE

--암묵적커서 : 모든 SQL문이 실행됨과 동시에 암묵적 커서가 자동으로 생성됨. OPEN-FETCH-CLOSE과정 자동처리
--명시적커서 : 사용자가 직접 쿼리결과를 제어하기 위해 명시적으로 선언한 커서.

declare
    emp_row employee%rowtype;
    --커서선언
    --1. 파라미터 없는 커서
    cursor emp_cursor is
    select * from employee;
    --2. 파라미터 있는 커서
    cursor dept_emp_cursor(p_dept_code employee.dept_code%type)
    is
    select * from employee where dept_code = p_dept_code;
begin
    open emp_cursor;
    loop
        fetch emp_cursor into emp_row;
        exit when emp_cursor%notfound; --더이상 행이 존재하지 않는 경우
        dbms_output.put_line(emp_row.emp_id || ' : ' || emp_row.emp_name);
    end loop;
    --자원반납
    close emp_cursor;
    
    dbms_output.new_line; --공백
    open dept_emp_cursor('&부서코드');
    loop
        fetch dept_emp_cursor into emp_row;
        exit when dept_emp_cursor%notfound; --더이상 행이 존재하지 않는 경우
        dbms_output.put_line(emp_row.emp_id || ' : ' || emp_row.emp_name || '(' || emp_row.dept_code || ')');    
    end loop;
    close dept_emp_cursor;
end;
/

--for..in문을 사용한 cursor 제어
--1. open..close을 자동 처리
--2. 모든행을 가져왔다면 자동으로 반복문 종료. exit구문 불필요
--3. 커서의 행(전체컬럼)에 해당하는 변수 선언. 별도의 변수 선언 불필요
declare
    --emp_row employee%rowtype;(별도 변수 선언 불필요)
    --커서선언
    --1. 파라미터 없는 커서
    cursor emp_cursor is
    select * from employee;
    --2. 파라미터 있는 커서
    cursor dept_emp_cursor(p_dept_code employee.dept_code%type)
    is
    select * from employee where dept_code = p_dept_code;
begin
    for emp_row in emp_cursor loop
        dbms_output.put_line(emp_row.emp_id || ' : ' || emp_row.emp_name);
    end loop;
    
    dbms_output.new_line;
    
    for emp_row in dept_emp_cursor('&부서코드') loop
        dbms_output.put_line(emp_row.emp_id || ' : ' || emp_row.emp_name || '(' || emp_row.dept_code || ')');    
    end loop;
end;
/

--@실습문제 : 직급명을 입력받고, 해당 직급의 모든 사원 조회(사번, 사원명, 직급명)하는 프로시져 생성
--익명블럭에서 proc_emp_job('대리') 호출.
--커서 cs_emp_job 사용할 것

declare
    
begin
    proc_emp_job('대리');
end;
/

desc job;

create or replace procedure proc_emp_job(p_job_name job.job_name%type)
is
    cursor cs_emp_job
    is
    select *
    from employee E join job J using(job_code)
    where J.job_name = p_job_name;
begin
    for emp_row in cs_emp_job loop
        dbms_output.put_line(emp_row.emp_id || ' : ' || emp_row.emp_name || '(' || emp_row.job_name || ')');    
    end loop;
end;
/
execute proc_emp_job('대리');

--=============================================================
-- TRIGGER
--=============================================================
--방아쇠. 특정이벤트, DDL, DML이 실행되었을 때, 자동으로 실행될 구문을 저장한 객체
--1. DML Trigger : 특정 테이블에 대해서 insert/update/delete 구문 실행시 자동으로 저장된 구문을 실행
--2. DDL Trigger : 
--3. Logon/Logoff Trigger :
/*
문법
create or replace trigger 트리거명
    before | after -- 원dml문 실행전/후 트리거 실행
    insert | update | delete on 테이블 -- (복수개는 or로 묶을수도 있음)
    for each row    --행 level, 문장 level(기본값)
begin
    --실행로직
end;
/
*/

desc users;

-- 의사 레코드 pseudo record(임시 레코드)
--for each row 행레벨 트리거인 경우에 한해서 사용 가능하다
/*
            :old        :new
----------------------------------------------------

insert      null        새로 추가된 행
update      변경전 행    변경후 행
delete      삭제전 행    null
*/
create or replace trigger trg_users
    before 
    insert or update or delete on users -- update of 컬럼명(특정 행에 대한 변경만 처리 가능)
    for each row
begin
    if inserting then
        --사용자가 등록될때마다 로그처리
        insert into user_log(no, log)
        values (
            user_log_no.nextval,
            :new.no || ' - ' || :new.name || '이 등록했습니다.'
        );
    elsif updating then
        --사용자이름이 변경될때마다 로그처리
        insert into user_log(no, log)
        values (
            user_log_no.nextval,
            :new.no || '번 회원의 이름이 [' || :old.name || ']에서 [' || :new.name || ']로 변경되었습니다.'
        );
    elsif deleting then
        --회원 탈퇴시 로그처리
        insert into user_log(no, log)
        values(
            user_log_no.nextval,
            :old.no || '번 회원(' || :old.name || ')님이 탈퇴하셨습니다.'
        );
        
    end if;
    
    --트리거에서는 트랜잭션 처리할 수 없다. 원 dml문과 같은 트랜잭션에 자동으로 속한다.
end;
/

create table user_log(
    no number primary key,
    log varchar2(1000),
    log_date date default sysdate
);
create sequence user_log_no;

--test
insert into users values(3, '신사임당');
insert into users values(4, '윤봉준');
insert into users values(5, '유관순');
update users set name = '고길동' where no = 5;
delete from users where no = 5;
select * from users;
select * from user_log;

-- before & after 옵션
-- trigger로 처리해야 하는 작업이 fk참조를 해야한다면, after 옵션을 고려해야 한다.(무결성 위반하지 않기 위해)
-- (before after는 부모 테이블과 자식 테이블의 관계에 대해서 작성할 때 사용)
create table parent (
    id varchar2(100) primary key
);
create table child (
    id varchar2(100) primary key,
    parent_id varchar2(100),
    constraint fk_parent_id foreign key(parent_id) references parent(id)
);
select * from parent;
select * from child;

create or replace trigger trg_parent_child
    after
    insert on parent
    for each row
begin
    insert into child
    values(:new.id || 123, :new.id);
end;
/

insert into parent values('abc');

--상품재고관리
--1. 상품테이블(재고숫자)
--2. 입출고테이블(입출고수량)
create table product(
    pid number primary key,
    pname varchar2(500) not null,
    price number,
    stock number default 0
);

create table product_io(
    ioid number primary key,
    pid number references product(pid), --foreign key 컬럼레벨 작성시 references 절만 작성
    amount number,
    status char(1) check(status in ('I', 'O')),
    io_date date default sysdate
);

create sequence seq_product_pid;
create sequence seq_product_ioid;

insert into product
values(seq_product_pid.nextval, 'Galaxy21', 1000000, default);

insert into product
values(seq_product_pid.nextval, 'iPhone12', 1100000, default);

select * from product;
select * from product_io;

-- product_io에 입출고 데이터를 쌓음. 
-- 자동으로 트리거가 product에 있는 stock 컬럼을 update

create or replace trigger trg_product_stock
    before -- 갱신 작업이 아니고 수정이므로, before, after 상관 없다.
    insert on product_io
    for each row
begin
    if :new.status = 'I' then
    --입고
    update product set stock = stock + :new.amount where pid = :new.pid;
    else
    --출고
    update product set stock = stock - :new.amount where pid = :new.pid;
    end if;
end;
/

insert into product_io values(seq_product_ioid.nextval, 1, 10, 'I', default); 
insert into product_io values(seq_product_ioid.nextval, 1, 5, 'O', default); 

-- @실습문제
-- EMPLOYEE테이블의 퇴사자관리를 별도의 테이블 TBL_EMP_QUIT에서 하려고 한다.
-- 다음과 같이 TBL_EMP_JOIN, TBL_EMP_QUIT테이블을 생성하고, TBL_EMP_JOIN에서 DELETE시 자동으로 퇴사자 데이터가 
-- TBL_EMP_QUIT에 INSERT되도록 트리거를 생성하라.

CREATE TABLE TBL_EMP_JOIN
AS
SELECT EMP_ID, EMP_NAME, EMP_NO, EMAIL, PHONE, DEPT_CODE, JOB_CODE, SAL_LEVEL, SALARY, BONUS, MANAGER_ID, HIRE_DATE
FROM EMPLOYEE
WHERE QUIT_YN = 'N';

CREATE TABLE TBL_EMP_QUIT
AS
SELECT EMP_ID, EMP_NAME, EMP_NO, EMAIL, PHONE, DEPT_CODE, JOB_CODE, SAL_LEVEL, SALARY, BONUS, MANAGER_ID, HIRE_DATE, QUIT_DATE
FROM EMPLOYEE
WHERE QUIT_YN = 'Y';

SELECT * FROM TBL_EMP_JOIN;
SELECT * FROM TBL_EMP_QUIT;

create or replace trigger trg_employee_quit
    after
    delete on tbl_emp_join
    for each row
begin
    insert into tbl_emp_quit
    values(:old.emp_id, :old.emp_name, :old.emp_no, :old.email, :old.phone, :old.dept_code, :old.job_code, :old.sal_level, :old.salary, :old.bonus, :old.manager_id, :old.hire_date, sysdate);
end;
/

delete from tbl_emp_join where emp_id = 200;