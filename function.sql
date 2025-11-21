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
