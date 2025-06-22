--Question 1 

-- 1. Update Doctor
CREATE OR REPLACE PROCEDURE update_doctor (
    p_doc_aadhar IN NUMBER,
    p_doc_name IN VARCHAR2,
    p_speciality IN VARCHAR2,
    p_years_exp IN NUMBER
) AS
BEGIN
    UPDATE doctor
    SET doc_name = p_doc_name,
        speciality = p_speciality,
        years_exp = p_years_exp
    WHERE doc_aadhar = p_doc_aadhar;
    IF SQL%ROWCOUNT > 0 THEN
        DBMS_OUTPUT.PUT_LINE('Doctor updated successfully');
    ELSE
        DBMS_OUTPUT.PUT_LINE('Doctor not found');
    END IF;
END;
/

-- 2. Update Patient
CREATE OR REPLACE PROCEDURE update_patient (
    p_aadhar IN NUMBER,
    p_name IN VARCHAR2,
    p_address IN VARCHAR2,
    p_age IN NUMBER,
    p_d_aadhar IN NUMBER
) AS
BEGIN
    UPDATE patient
    SET p_name = p_name,
        p_address = p_address,
        age = p_age,
        d_aadhar = p_d_aadhar
    WHERE p_aadhar = p_aadhar;
    IF SQL%ROWCOUNT > 0 THEN
        DBMS_OUTPUT.PUT_LINE('Patient updated successfully');
    ELSE
        DBMS_OUTPUT.PUT_LINE('Patient not found');
    END IF;
END;
/

-- 3. Update Pharma Company
CREATE OR REPLACE PROCEDURE update_pharma_company (
    pcompany_name IN VARCHAR2,
    p_phone IN VARCHAR2,
    p_email IN VARCHAR2
) AS
BEGIN
    UPDATE pharma_company
    SET phone = p_phone,
        email = p_email
    WHERE pcompany_name = pcompany_name;
    IF SQL%ROWCOUNT > 0 THEN
        DBMS_OUTPUT.PUT_LINE('Pharma company updated successfully');
    ELSE
        DBMS_OUTPUT.PUT_LINE('Pharma company not found');
    END IF;
END;
/

-- 4. Update Drug
CREATE OR REPLACE PROCEDURE update_drug (
    p_trade_name IN VARCHAR2,
    p_pc_name IN VARCHAR2,
    p_formula IN VARCHAR2
) AS
BEGIN
    UPDATE drugs
    SET formula = p_formula
    WHERE trade_name = p_trade_name AND pc_name = p_pc_name;
    IF SQL%ROWCOUNT > 0 THEN
        DBMS_OUTPUT.PUT_LINE('Drug updated successfully');
    ELSE
        DBMS_OUTPUT.PUT_LINE('Drug not found');
    END IF;
END;
/

-- 5. Update Pharmacy
CREATE OR REPLACE PROCEDURE update_pharmacy (
    p_pharmacy_name IN VARCHAR2,
    p_address IN VARCHAR2,
    p_phone IN VARCHAR2,
    p_email IN VARCHAR2
) AS
BEGIN
    UPDATE pharmacy
    SET pharma_address = p_address,
        phone = p_phone,
        email = p_email
    WHERE pharmacy_name = p_pharmacy_name;
    IF SQL%ROWCOUNT > 0 THEN
        DBMS_OUTPUT.PUT_LINE('Pharmacy updated successfully');
    ELSE
        DBMS_OUTPUT.PUT_LINE('Pharmacy not found');
    END IF;
END;
/

-- 6. Update Drug-Pharmacy Stock
CREATE OR REPLACE PROCEDURE update_drug_pharmacy (
    p_d_trade IN VARCHAR2,
    p_pc_name IN VARCHAR2,
    p_pharmacy_name IN VARCHAR2,
    p_stock IN NUMBER
) AS
BEGIN
    UPDATE drug_pharmacy
    SET stock = p_stock
    WHERE d_trade = p_d_trade AND pc_name = p_pc_name AND pharmacy_name = p_pharmacy_name;
    IF SQL%ROWCOUNT > 0 THEN
        DBMS_OUTPUT.PUT_LINE('Drug-pharmacy stock updated successfully');
    ELSE
        DBMS_OUTPUT.PUT_LINE('Drug-pharmacy entry not found');
    END IF;
END;
/

-- 7. Update Prescription
CREATE OR REPLACE PROCEDURE update_prescription (
    p_prescription_id IN NUMBER,
    p_d_aadhar IN NUMBER,
    p_p_aadhar IN NUMBER,
    p_date IN DATE
) AS
BEGIN
    UPDATE prescription
    SET d_aadhar = p_d_aadhar,
        p_aadhar = p_p_aadhar,
        p_date = p_date
    WHERE prescription_id = p_prescription_id;
    IF SQL%ROWCOUNT > 0 THEN
        DBMS_OUTPUT.PUT_LINE('Prescription updated successfully');
    ELSE
        DBMS_OUTPUT.PUT_LINE('Prescription not found');
    END IF;
END;
/

-- 8. Update Prescribed Drug
CREATE OR REPLACE PROCEDURE update_presc_drug (
    p_prescription_id IN NUMBER,
    p_d_trade IN VARCHAR2,
    p_pc_name IN VARCHAR2,
    p_quantity IN NUMBER
) AS
BEGIN
    UPDATE presc_drugs
    SET quantity = p_quantity
    WHERE prescription_id = p_prescription_id AND d_trade = p_d_trade AND pc_name = p_pc_name;
    IF SQL%ROWCOUNT > 0 THEN
        DBMS_OUTPUT.PUT_LINE('Prescribed drug updated successfully');
    ELSE
        DBMS_OUTPUT.PUT_LINE('Prescribed drug not found');
    END IF;
END;
/

-- 9. Update Contract
CREATE OR REPLACE PROCEDURE update_contract (
    p_pname IN VARCHAR2,
    p_pcname IN VARCHAR2,
    p_start_date IN DATE,
    p_end_date IN DATE,
    p_supervisor IN VARCHAR2,
    p_content IN VARCHAR2
) AS
BEGIN
    UPDATE contract
    SET start_date = p_start_date,
        end_date = p_end_date,
        supervisor = p_supervisor,
        content = p_content
    WHERE pname = p_pname AND pcname = p_pcname;
    IF SQL%ROWCOUNT > 0 THEN
        DBMS_OUTPUT.PUT_LINE('Contract updated successfully');
    ELSE
        DBMS_OUTPUT.PUT_LINE('Contract not found');
    END IF;
END;
/








--Question 2
CREATE OR REPLACE PROCEDURE get_patient_prescription_info (
    p_patient_id IN NUMBER,
    p_start_date IN DATE,
    p_end_date IN DATE
) AS
BEGIN
    FOR rec IN (
        SELECT
            pd.d_trade,
            pd.quantity,
            pa.p_name AS patient_name,
            d.doc_name AS doctor_name,
            pr.p_date
        FROM
            presc_drugs pd
            JOIN prescription pr ON pd.prescription_id = pr.prescription_id
            JOIN patient pa ON pr.p_aadhar = pa.p_aadhar
            JOIN doctor d ON pr.d_aadhar = d.doc_aadhar
        WHERE
            pr.p_aadhar = p_patient_id
            AND pr.p_date BETWEEN p_start_date AND p_end_date
    )
    LOOP
        DBMS_OUTPUT.PUT_LINE('Date: ' || TO_CHAR(rec.p_date, 'YYYY-MM-DD'));
        DBMS_OUTPUT.PUT_LINE('Drug: ' || rec.d_trade || ', Quantity: ' || rec.quantity);
        DBMS_OUTPUT.PUT_LINE('Patient: ' || rec.patient_name || ', Doctor: ' || rec.doctor_name);
        DBMS_OUTPUT.PUT_LINE('----------------------------------------');
    END LOOP;
END;
/



--Question 3
CREATE OR REPLACE PROCEDURE print_prescription_details (
    p_patient_id IN NUMBER,
    p_presc_date IN DATE
) AS
BEGIN
    FOR rec IN (
        SELECT 
            p.p_name AS patient_name,
            d.doc_name AS doctor_name,
            pr.prescription_id,
            pr.p_date,
            pd.d_trade,
            pd.pc_name,
            pd.quantity
        FROM 
            patient p
        JOIN prescription pr ON p.p_aadhar = pr.p_aadhar
        JOIN doctor d ON pr.d_aadhar = d.doc_aadhar
        JOIN presc_drugs pd ON pr.prescription_id = pd.prescription_id
        WHERE 
            p.p_aadhar = p_patient_id
            AND pr.p_date = p_presc_date
    ) LOOP
        DBMS_OUTPUT.PUT_LINE('Prescription ID: ' || rec.prescription_id);
        DBMS_OUTPUT.PUT_LINE('Date: ' || TO_CHAR(rec.p_date, 'YYYY-MM-DD'));
        DBMS_OUTPUT.PUT_LINE('Patient Name: ' || rec.patient_name);
        DBMS_OUTPUT.PUT_LINE('Doctor Name: ' || rec.doctor_name);
        DBMS_OUTPUT.PUT_LINE('Drug: ' || rec.d_trade || ' (' || rec.pc_name || ')');
        DBMS_OUTPUT.PUT_LINE('Quantity: ' || rec.quantity);
        DBMS_OUTPUT.PUT_LINE('------------------------------------');
    END LOOP;
END;
/


--Question 4
CREATE OR REPLACE PROCEDURE get_drugs_by_company(p_company_name IN VARCHAR2) IS
BEGIN
    FOR rec IN (
        SELECT trade_name, formula
        FROM drugs
        WHERE pc_name = p_company_name
    ) LOOP
        DBMS_OUTPUT.PUT_LINE('Drug Name: ' || rec.trade_name || ', Formula: ' || rec.formula);
    END LOOP;
END;
/



--Question 5
CREATE OR REPLACE PROCEDURE print_stock_position (
    p_pharmacy_name IN VARCHAR2
) AS
BEGIN
    DBMS_OUTPUT.PUT_LINE('Stock details for pharmacy: ' || p_pharmacy_name);
    DBMS_OUTPUT.PUT_LINE(RPAD('Drug Name', 20) || RPAD('Company', 20) || 'Stock');

    FOR drug_rec IN (
        SELECT dp.d_trade, dp.pc_name, dp.stock
        FROM drug_pharmacy dp
        WHERE dp.pharmacy_name = p_pharmacy_name
    ) LOOP
        DBMS_OUTPUT.PUT_LINE(
            RPAD(drug_rec.d_trade, 20) || RPAD(drug_rec.pc_name, 20) || drug_rec.stock
        );
    END LOOP;
END;
/


--Question 6 
CREATE OR REPLACE PROCEDURE print_contract_details (
    p_pharmacy_name IN VARCHAR2,
    p_pharma_company_name IN VARCHAR2
) AS
    v_start_date    DATE;
    v_end_date      DATE;
    v_supervisor    VARCHAR2(20);
    v_content       VARCHAR2(50);
BEGIN
    SELECT start_date, end_date, supervisor, content
    INTO v_start_date, v_end_date, v_supervisor, v_content
    FROM contract
    WHERE pname = p_pharmacy_name AND pcname = p_pharma_company_name;

    DBMS_OUTPUT.PUT_LINE('Contract Details:');
    DBMS_OUTPUT.PUT_LINE('Pharmacy: ' || p_pharmacy_name);
    DBMS_OUTPUT.PUT_LINE('Pharma Company: ' || p_pharma_company_name);
    DBMS_OUTPUT.PUT_LINE('Start Date: ' || TO_CHAR(v_start_date, 'YYYY-MM-DD'));
    DBMS_OUTPUT.PUT_LINE('End Date: ' || TO_CHAR(v_end_date, 'YYYY-MM-DD'));
    DBMS_OUTPUT.PUT_LINE('Supervisor: ' || v_supervisor);
    DBMS_OUTPUT.PUT_LINE('Content: ' || v_content);
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('No contract found between the given pharmacy and pharma company.');
END;
/


--Question 7
CREATE OR REPLACE PROCEDURE print_patients_by_doctor (
    p_doc_aadhar IN NUMBER
) AS
    v_doc_name VARCHAR2(20);
BEGIN
    -- Get doctor's name for display
    SELECT doc_name INTO v_doc_name FROM doctor WHERE doc_aadhar = p_doc_aadhar;

    DBMS_OUTPUT.PUT_LINE('Patients under ' || v_doc_name || ' (Aadhar: ' || p_doc_aadhar || '):');
    DBMS_OUTPUT.PUT_LINE(RPAD('Patient Name', 20) || RPAD('Address', 30) || 'Age');

    FOR pat_rec IN (
        SELECT p_name, p_address, age
        FROM patient
        WHERE d_aadhar = p_doc_aadhar
    ) LOOP
        DBMS_OUTPUT.PUT_LINE(
            RPAD(pat_rec.p_name, 20) || RPAD(pat_rec.p_address, 30) || pat_rec.age
        );
    END LOOP;

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('No doctor found with Aadhar: ' || p_doc_aadhar);
END;
/



