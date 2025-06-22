--Question 1 - To update
BEGIN
    update_patient(2001,'Arjun','Jubilee Hills, Hyderabad',31,1001);
END;
/


--Question 2 
BEGIN
    get_patient_prescription_info(2001, TO_DATE('2025-02-01', 'YYYY-MM-DD'), TO_DATE('2025-04-19', 'YYYY-MM-DD'));
END;
/

--Question 3
BEGIN
    print_prescription_details(2002, TO_DATE('2025-04-18', 'YYYY-MM-DD'));
END;
/

--Question 4
BEGIN
    get_drugs_by_company('MedLife');
END;
/
--Question 5
BEGIN
    print_stock_position('CityMeds');
END;
/

--Question 6
BEGIN
    print_contract_details('CityMeds', 'MedLife');
END;
/

--Question 7 
BEGIN
    print_patients_by_doctor(1001);
END;
/