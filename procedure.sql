CREATE OR REPLACE PROCEDURE print_employee_row(emp_rec IN employee%ROWTYPE)
AS
BEGIN
    DBMS_OUTPUT.PUT_LINE(emp_rec.emp_id || ' - ' || emp_rec.emp_name || ' - ' || emp_rec.salary || ' - ' || TO_CHAR(emp_rec.joining_date, 'DD-MON-YYYY')
    );
END;
/
