-- Table EMPLOYEE created
CREATE TABLE EMPLOYEE (
    EMP_ID        NUMBER PRIMARY KEY,
    EMP_NAME      VARCHAR2(50),
    DEPARTMENT    VARCHAR2(50),
    SALARY        NUMBER(10,2),
    JOINING_DATE  DATE
);

-- 20 rows inserted in EMPLOYEE Table
INSERT ALL
    INTO EMPLOYEE (EMP_ID, EMP_NAME, DEPARTMENT, SALARY, JOINING_DATE)
        VALUES (1, 'Rohit Sharma', 'HR', 45000, DATE '2022-01-10')
    INTO EMPLOYEE VALUES (2, 'Virat Kohli', 'Finance', 55000, DATE '2022-02-14')
    INTO EMPLOYEE VALUES (3, 'Shubman Gill', 'IT', 60000, DATE '2022-03-18')
    INTO EMPLOYEE VALUES (4, 'KL Rahul', 'IT', 65000, DATE '2022-04-22')
    INTO EMPLOYEE VALUES (5, 'Suryakumar Yadav', 'Sales', 40000, DATE '2022-05-09')
    INTO EMPLOYEE VALUES (6, 'Hardik Pandya', 'HR', 47000, DATE '2022-06-15')
    INTO EMPLOYEE VALUES (7, 'Ravindra Jadeja', 'Finance', 52000, DATE '2022-07-03')
    INTO EMPLOYEE VALUES (8, 'Rishabh Pant', 'IT', 70000, DATE '2022-08-21')
    INTO EMPLOYEE VALUES (9, 'Jasprit Bumrah', 'Sales', 39000, DATE '2022-09-11')
    INTO EMPLOYEE VALUES (10, 'Mohammed Shami', 'HR', 48000, DATE '2022-10-25')
    INTO EMPLOYEE VALUES (11, 'Mohammed Siraj', 'IT', 72000, DATE '2022-11-08')
    INTO EMPLOYEE VALUES (12, 'Yuzvendra Chahal', 'Finance', 53000, DATE '2022-12-05')
    INTO EMPLOYEE VALUES (13, 'Kuldeep Yadav', 'Sales', 41000, DATE '2023-01-17')
    INTO EMPLOYEE VALUES (14, 'Shreyas Iyer', 'IT', 68000, DATE '2023-02-12')
    INTO EMPLOYEE VALUES (15, 'Ishan Kishan', 'HR', 46000, DATE '2023-03-29')
    INTO EMPLOYEE VALUES (16, 'Axar Patel', 'Finance', 51000, DATE '2023-04-07')
    INTO EMPLOYEE VALUES (17, 'Sanju Samson', 'IT', 75000, DATE '2023-05-23')
    INTO EMPLOYEE VALUES (18, 'Deepak Chahar', 'Sales', 42000, DATE '2023-06-18')
    INTO EMPLOYEE VALUES (19, 'Bhuvneshwar Kumar', 'HR', 50000, DATE '2023-07-01')
    INTO EMPLOYEE VALUES (20, 'Ruturaj Gaikwad', 'IT', 69000, DATE '2023-08-11')
SELECT * FROM DUAL;


-- (1.) Fetch Employee using cursor

DECLARE
    v_dept VARCHAR2(50) := '&Department';

    CURSOR emp_cur IS
        SELECT EMP_ID, EMP_NAME, SALARY, JOINING_DATE
        FROM EMPLOYEE
        WHERE DEPARTMENT = v_dept;

    v_emp_id EMPLOYEE.EMP_ID%TYPE;
    v_emp_name EMPLOYEE.EMP_NAME%TYPE;
    v_sal EMPLOYEE.SALARY%TYPE;
    v_joining_date EMPLOYEE.JOINING_DATE%TYPE;
    
BEGIN
    
    DBMS_OUTPUT.PUT_LINE('Enter Department: ' || v_dept);

    OPEN emp_cur;
    LOOP
        FETCH emp_cur INTO v_emp_id, v_emp_name, v_sal, v_joining_date;
        EXIT WHEN emp_cur%NOTFOUND;

            DBMS_OUTPUT.PUT_LINE(
            'ID: ' || v_emp_id ||
            ' | Name: ' || v_emp_name ||
            ' | Salary: ' || v_sal ||
            ' | Joined: ' || TO_CHAR(v_joining_date, 'DD-MON-YYYY')
        );
    END LOOP;
    CLOSE emp_cur;

END;

/

-- (2.) Use ROWTYPE

ACCEPT Department;
--it will always ask user to input the department
DECLARE
    v_dept VARCHAR2(50) := '&Department';

        CURSOR emp_cur IS
            SELECT EMP_ID, EMP_NAME, SALARY, JOINING_DATE
            FROM EMPLOYEE
            WHERE DEPARTMENT = v_dept;

-- declaring a record 
    emp_rec emp_cur%ROWTYPE;

BEGIN

    DBMS_OUTPUT.PUT_LINE('Enter Department: ' || v_dept);

    OPEN emp_cur;
    LOOP
        FETCH emp_cur INTO emp_rec;
        EXIT WHEN emp_cur%NOTFOUND;

            DBMS_OUTPUT.PUT_LINE(
            'ID: ' || emp_rec.EMP_ID ||
            ' | Name: ' || emp_rec.EMP_NAME ||
            ' | Salary: ' || emp_rec.SALARY ||
            ' | Joined: ' || TO_CHAR(emp_rec.JOINING_DATE, 'DD-MON-YYYY')
        );
    END LOOP;
    CLOSE emp_cur;
END;

    -- (3.) Create a Procedure

CREATE OR REPLACE PROCEDURE print_employee_row(emp_rec IN employee%ROWTYPE)
AS
BEGIN
    DBMS_OUTPUT.PUT_LINE(emp_rec.emp_id || ' - ' || emp_rec.emp_name || ' - ' || emp_rec.salary || ' - ' || TO_CHAR(emp_rec.joining_date, 'DD-MON-YYYY')
    );
END;
/


ACCEPT Department;
--it will always ask user to input the department
DECLARE
    v_dept VARCHAR2(50) := '&Department';

    CURSOR emp_cur IS
        SELECT * -- EMP_ID, EMP_NAME, SALARY, JOINING_DATE
        FROM EMPLOYEE
        WHERE DEPARTMENT = v_dept;


-- declaring a record 
    emp_rec emp_cur%ROWTYPE;

BEGIN
    
    DBMS_OUTPUT.PUT_LINE('Enter Department: ' || v_dept);

    OPEN emp_cur;
    LOOP
        FETCH emp_cur INTO emp_rec;
        EXIT WHEN emp_cur%NOTFOUND;

        print_employee_row(emp_rec);

    END LOOP;
    CLOSE emp_cur;

END;

/


-- (4.) Create a Function

CREATE OR REPLACE FUNCTION get_total_salary(p_dept IN VARCHAR2)
RETURN NUMBER
AS
    v_total_salary NUMBER;
BEGIN
    SELECT SUM(salary)
    INTO v_total_salary
    FROM employee
    WHERE department = p_dept;

    RETURN NVL(v_total_salary, 0);  
END;
/


ACCEPT Department;
DECLARE
    v_dept VARCHAR2(50) := '&Department';

    CURSOR emp_cur IS
        SELECT * 
        FROM EMPLOYEE
        WHERE DEPARTMENT = v_dept;

    emp_rec emp_cur%ROWTYPE;

    v_total NUMBER;
BEGIN
    
    DBMS_OUTPUT.PUT_LINE('Enter Department: ' || v_dept);

    v_total := GET_TOTAL_SALARY(v_dept);
    DBMS_OUTPUT.PUT_LINE('Total salary for '|| v_dept || ' is ' || v_total);

    OPEN emp_cur;
    LOOP
        FETCH emp_cur INTO emp_rec;
        EXIT WHEN emp_cur%NOTFOUND;

        print_employee_row(emp_rec);
    END LOOP;
    CLOSE emp_cur;

END;

/


-- (5.) e_emp_not_found EXCEPTION / OTHERS Exception

ACCEPT Department;
DECLARE
    v_dept VARCHAR2(50) := '&Department';

    CURSOR emp_cur IS
        SELECT * 
        FROM EMPLOYEE
        WHERE DEPARTMENT = v_dept;

    emp_rec emp_cur%ROWTYPE;

    v_total NUMBER;

    v_count NUMBER := 0;

    e_emp_not_found EXCEPTION;

BEGIN
    
    DBMS_OUTPUT.PUT_LINE('Enter Department: ' || v_dept);

    v_total := get_total_salary(v_dept);
    DBMS_OUTPUT.PUT_LINE('Total Salary for ' || v_dept || ' is ' || v_total);
    OPEN emp_cur;
    LOOP
        FETCH emp_cur INTO emp_rec;
        EXIT WHEN emp_cur%NOTFOUND;

        v_count := v_count + 1;

        print_employee_row(emp_rec);
    END LOOP;
    CLOSE emp_cur;

    IF v_count = 0 THEN
        RAISE e_emp_not_found;
    END IF;

    EXCEPTION
        WHEN e_emp_not_found THEN
            DBMS_OUTPUT.PUT_LINE('NO EMPLOYEE FOUND IN THIS DEPARTMENT');

        WHEN OTHERS THEN 
            DBMS_OUTPUT.PUT_LINE('Unexpected Error: ' || SQLERRM);
END;

/
