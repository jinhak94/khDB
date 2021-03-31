column username format a20;
column account_status format a20;
select username, account_status from dba_users;

-- 한 줄 주석
/*
    여러 줄 주석
*/

/*
    sys 슈퍼관리자
    슈퍼관리자, 데이터베이스 생성/삭제 권한.    
    
    system
    일반관리자, 데이터베이스 생성/삭제 권한 없음.
    데이터베이스 일반적인 유지보수를 담당.
*/

--일반 사용자 kh 계정 생성
--username : kh
--password : kh 대소문자 구분
--default tablespace 실제 데이터가 저장될 공간 system / users

create user kh
identified by kh
default tablespace users;

--사용자 조회
select username, account_status
from dba_users;

--+ 버튼을 통해서 사용자 이름 kh, 비밀번호 kh로 설정 및 테스트
---> ORA-01045 에러 발생(CREATE SESSION 권한이 없음.

--grant create session to kh;
--보통 위처럼은 하지 않고 아래처럼 묶어서 처리한다.
--connect : create session 권한(,,접속 권한 묶음)
--resource : create table 객체를 생성할 수 있는 권한 묶음.
grant connect, resource to kh;

--chun 계정
create user chun
identified by chun
default tablespace users;

--conect, resource 권한부여
grant connect, resource to chun;

--------------------------------------------------------
-- GRANT
--------------------------------------------------------

-- qwerty 계정 생성
create user qwerty
identified by qwerty
default tablespace users;

-- create session 권한 부여
-- connect 롤을 부여
grant create session to qwerty;
grant connect to qwerty;

-- create table 권한 부여
grant create table to qwerty;

-- tablespace 공간 사용 권한 부여(alter)
alter user qwerty quota unlimited on users;

-- resource 롤부여
grant resource to qwerty;

-- Data Dictionary에서 권한/롤 조회
select *
from dba_sys_privs
where grantee in ('CONNECT','RESOURCE')
order by 1;

-- 해당 테이블은 dba에 해당하는 관리자만 접근할 수 있다.
select * from dba_tables;

-- 일반 사용자의 테이블 조회가능
select *
from dba_tables
where owner = 'KH';

select *
from dba_tables
where owner = 'CHUN';

-- 권한 조회

select *
from dba_sys_privs
where grantee = 'QWERTY';

-- 롤 조회
select *
from dba_role_privs
where grantee = 'QWERTY';

-- 테이블 관련 권한 조회
select *
from dba_tab_privs
where owner = 'KH';

-------------------------------------------------------------
-- VIEW
-------------------------------------------------------------
-- view 권한 부여

grant create view to kh;
grant create view to chun;





