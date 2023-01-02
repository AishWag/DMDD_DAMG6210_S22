--------

set serveroutput on;
-- creation of tic tac toe table
DECLARE
NUM1 NUMBER;
BEGIN
SELECT count(*) INTO NUM1 FROM USER_TABLES
WHERE TABLE_NAME = 'T_T_TABLE';
IF NUM1 != 0 THEN
EXECUTE IMMEDIATE 'DROP TABLE T_T_Table purge';
END IF;
EXECUTE IMMEDIATE 'CREATE TABLE T_T_Table(
N NUMBER,
I VARCHAR2(1000),
J VARCHAR2(1000),
K VARCHAR2(1000))';



END;
/
---------------------------------------------------------------------
-- Previous play
CREATE OR REPLACE PACKAGE tic_tac_package IS
previous_play char(1) := '_';
is_reset boolean := FALSE;
END;
/
-- NUMBER TO COLUMN NAME CONVERSION
CREATE OR REPLACE FUNCTION NUM_NAME(n1 IN NUMBER)
RETURN varCHAR2
IS
BEGIN
IF n1=1 THEN
RETURN 'I';
ELSIF n1=2 THEN
RETURN 'J';
ELSIF n1=3 THEN
RETURN 'K';
ELSE
RETURN '_';
END IF;
END;
/
-----------------------------------------------------------------------------------
--PROCEDURE TO DISPLAY GAME BOARD
CREATE OR REPLACE PROCEDURE DISPLAY IS
BEGIN
DBMS_OUTPUT.ENABLE(10000);
dbms_output.put_line(' ');
FOR ll in (SELECT * FROM T_T_Table ORDER BY N) LOOP
dbms_output.put_line(' ' || ll.I || ' ' || ll.J || ' ' || ll.K);
END LOOP;
dbms_output.put_line(' ');
END;
/
-----------------------------------------------------------------------------------
--GAME RESET PROCEDURE
CREATE OR REPLACE PROCEDURE RESET1 IS
ii NUMBER;
BEGIN
EXECUTE IMMEDIATE 'TRUNCATE TABLE T_T_Table';
FOR ii in 1..3 LOOP
INSERT INTO T_T_Table VALUES (ii,'_','_','_');
END LOOP;
tic_tac_package.previous_play := '_';
dbms_output.enable(10000);
DISPLAY();
dbms_output.put_line('ARE YOU READY TO PLAY: EXECUTE PLAY("X", col, row);');
tic_tac_package.is_reset := FALSE;
END;
/
-------------------------------------------------------------------------------------
-- PROCEDURE TO PLAY
CREATE OR REPLACE PROCEDURE INVALID_PLAY(SYM IN VARCHAR2, COL IN NUMBER) IS
NOT_A_VALID_MOVE EXCEPTION;
NOT_A_VALID_COLUMN EXCEPTION;
NOT_A_VALID_ROW EXCEPTION;
PRAGMA EXCEPTION_INIT(NOT_A_VALID_MOVE,-20000);
BEGIN
IF SYM NOT IN ('X','O') THEN
RAISE_APPLICATION_ERROR(-20000,'NOT A VALID MOVE',FALSE);
END IF;
END;
/
-----------------------
--INVALID COLUMN
CREATE OR REPLACE PROCEDURE INVALID_COL(V IN NUMBER) IS
NOT_A_VALID_COLUMN EXCEPTION;
PRAGMA EXCEPTION_INIT(NOT_A_VALID_COLUMN, -20000);
BEGIN
IF V NOT IN (1,2,3) THEN
RAISE_APPLICATION_ERROR(-20000,'NOT A VALID COLUMN');
END IF;
END;
/
-----PROCEDURE FOR MAIN GAME-----
CREATE OR REPLACE PROCEDURE PLAY(sym IN VARCHAR2, colnb IN NUMBER, lig IN NUMBER) IS
val T_T_Table.i%TYPE;
colo CHAR(2);
sym2 CHAR(2);
BEGIN
SELECT NUM_NAME(colnb) INTO colo FROM DUAL;
BEGIN
if tic_tac_package.is_reset = TRUE then
RESET1();
end if;



if tic_tac_package.previous_play = '_' then
tic_tac_package.previous_play := sym;
elsif tic_tac_package.previous_play = 'X' and sym = 'X' then
RAISE_APPLICATION_ERROR(-20000,'Foul play...!');
elsif tic_tac_package.previous_play = 'O' and sym = 'O' then
RAISE_APPLICATION_ERROR(-20000,'Foul play...!');
end if;

INVALID_COL(COLNB);

EXECUTE IMMEDIATE ('SELECT ' || colo || ' FROM T_T_Table WHERE N=' || lig) INTO val;
EXCEPTION
WHEN NO_DATA_FOUND THEN
RAISE_APPLICATION_ERROR(-20000,'OUT OF RANGE VALUE');
END;
IF val='_' THEN
EXECUTE IMMEDIATE ('UPDATE T_T_Table SET ' || colo || '=''' || sym || ''' WHERE N=' || lig);
INVALID_PLAY(SYM,LIG);
--IF sym='X' THEN
--sym2:='O';
--ELSE
--sym2:='X';
--END IF;
ELSE
dbms_output.enable(10000);
dbms_output.put_line('You cannot play this square, it is already played');
END IF;
tic_tac_package.previous_play := sym;
END;
/
--------------------------------------------------------------------------------
-- PROCEDURE TO WIN - CHAMPION
CREATE OR REPLACE PROCEDURE WIN1(SYM IN VARCHAR2) IS
BEGIN
dbms_output.enable(10000);
tic_tac_package.is_reset := TRUE;
if SYM = '_' then
dbms_output.put_line('It is a draw! No one won!!');
else
dbms_output.put_line('Player ' || SYM || ' won!!');
end if;
dbms_output.put_line('--------------------------------------');
END;
/
----------------------------------------------------------------------------------
--col
CREATE OR REPLACE FUNCTION COL1(nomcol IN VARCHAR2, SYM IN VARCHAR2)
RETURN varCHAR2
IS
P number;
BEGIN
--RETURN('SELECT COUNT(*) FROM T_T_Table WHERE' || nomcol ||'= '''|| SYM ||''' AND ' || nomcol || ' != ''_''');
SELECT COUNT(*) into P FROM T_T_Table WHERE nomcol=SYM;
RETURN P;
END;
/
--------------------------------------------------------------------------------------
-- COLUMN TEST FUNCTION - columnwin
CREATE OR REPLACE FUNCTION COL3(nomcol IN VARCHAR2)
RETURN VARCHAR2
IS
tmpx1 NUMBER;
r VARCHAR2(1);
BEGIN
-- SELECT COL1(nomcol, 'X') into r FROM DUAL;
r:=COL1(nomcol, 'X');
-- EXECUTE IMMEDIATE r INTO tmpx1;
IF tmpx1=3 THEN
RETURN 'X';
ELSIF tmpx1 = 0 THEN
-- SELECT COL1(nomcol, 'O') into r FROM DUAL;
r:=COL1(nomcol, 'O');
-- EXECUTE IMMEDIATE r INTO tmpx1;
IF tmpx1=3 THEN
RETURN 'O';
END IF;
END IF;
RETURN '_';
END;
/
--select COL3('x') FROM DUAL;-----------------------------------------------------------------------------------------------------------------------------
-- diagonal test function ---- diagonal win
CREATE OR REPLACE FUNCTION COL4(t_char IN CHAR)
RETURN char
IS
char_count_l number := 0;
char_count_r number := 0;
BEGIN
EXECUTE IMMEDIATE ('SELECT count(*) FROM T_T_Table WHERE (N=1 and I=''' || t_char || ''') or (N=2 and J=''' || t_char || ''') or (N=3 and K=''' || t_char || ''')') INTO char_count_l;
EXECUTE IMMEDIATE ('SELECT count(*) FROM T_T_Table WHERE (N=3 and I=''' || t_char || ''') or (N=2 and J=''' || t_char || ''') or (N=1 and K=''' || t_char || ''')') INTO char_count_r;
if char_count_r = 3 or char_count_l = 3 then
RETURN t_char;
end if;
return '_';
END;
/
------------------------------------------------------------
-- test trigger if we win
CREATE OR REPLACE TRIGGER winn
AFTER UPDATE ON T_T_Table
DECLARE
CURSOR cr_lig IS
SELECT * FROM T_T_Table ORDER BY N;
crlv T_T_Table%rowtype;
blank_count number;
tmpvar1 CHAR;
tmpx1 CHAR;
tmpx2 CHAR;
r VARCHAR2(40);
win_num number := 0;
BEGIN
FOR crlv IN cr_lig LOOP
-- line test
IF crlv.I = crlv.J AND crlv.J = crlv.K AND NOT crlv.I='_' THEN
WIN1(crlv.I);
win_num := 1;
EXIT;
END IF;
-- colon test
SELECT COL3(NUM_NAME(crlv.N)) INTO tmpvar1 FROM DUAL;
dbms_output.put_line('Col check:' || tmpvar1);

IF NOT tmpvar1 = '_' THEN
WIN1(tmpvar1);
win_num := 1;
EXIT;
END IF;
END LOOP;
-- diagonal test
tmpx1 := COL4('X');
tmpx2 := COL4('O');
IF NOT tmpx1 = '_' THEN
WIN1(tmpx1);
win_num := 1;
END IF;
IF NOT tmpx2 = '_' THEN
WIN1(tmpx2);
win_num := 1;
END IF;

-- draw scenario
SELECT COUNT(*) into blank_count FROM T_T_Table WHERE I='_' or J='_' or K='_';
if blank_count = 0 then
WIN1('_');
win_num := 1;
end if;
DISPLAY();
if win_num != 0 then
dbms_output.put_line('Game is over... Please reset data...!');
end if;
--dbms_output.put_line('RESET' || sys.diutil.bool_to_int(tic_tac_package.is_reset));
END;
/



EXECUTE RESET1;
--SYM, COL, ROW
EXECUTE PLAY('X',1,1 );
EXECUTE PLAY('O',3,1);
EXECUTE PLAY('X',1,2);
EXECUTE PLAY('O',2,2);
EXECUTE PLAY('X',1,3);

/*
EXECUTE play('X', 1, 1);
EXECUTE play('O', 1, 2);
EXECUTE play('X', 2, 3);
EXECUTE play('O', 2, 1);
EXECUTE play('X', 1, 3);
EXECUTE play('O', 3, 3);
EXECUTE play('X', 2, 2);
EXECUTE play('O', 3, 1);
EXECUTE play('X', 3, 2);
*/
--EXECUTE COL1('X','Y');