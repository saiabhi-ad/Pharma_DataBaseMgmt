-- DROP TABLES
BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE drug_pharmacy CASCADE CONSTRAINTS';
    EXECUTE IMMEDIATE 'DROP TABLE presc_drugs CASCADE CONSTRAINTS';
    EXECUTE IMMEDIATE 'DROP TABLE prescription CASCADE CONSTRAINTS';
    EXECUTE IMMEDIATE 'DROP TABLE drugs CASCADE CONSTRAINTS';
    EXECUTE IMMEDIATE 'DROP TABLE pharmacy CASCADE CONSTRAINTS';
    EXECUTE IMMEDIATE 'DROP TABLE pharma_company CASCADE CONSTRAINTS';
    EXECUTE IMMEDIATE 'DROP TABLE patient CASCADE CONSTRAINTS';
    EXECUTE IMMEDIATE 'DROP TABLE doctor CASCADE CONSTRAINTS';
    EXECUTE IMMEDIATE 'DROP TABLE contract CASCADE CONSTRAINTS';
EXCEPTION
    WHEN OTHERS THEN
        NULL;
END;
/

CREATE TABLE doctor (
    doc_aadhar INT PRIMARY KEY,
    doc_name VARCHAR2(20),
    speciality VARCHAR2(20),
    years_exp INT
);

CREATE TABLE patient (
    p_aadhar INT PRIMARY KEY,
    p_name VARCHAR2(20),
    p_address VARCHAR2(50),
    age INT,
    d_aadhar INT,
    FOREIGN KEY (d_aadhar) REFERENCES doctor(doc_aadhar)
);

CREATE TABLE pharma_company (
    pcompany_name VARCHAR2(20) PRIMARY KEY,
    phone VARCHAR2(10),
    email VARCHAR2(30)
);

CREATE TABLE prescription (
    prescription_id INT PRIMARY KEY,
    d_aadhar INT,
    p_aadhar INT,
    p_date DATE,
    FOREIGN KEY (p_aadhar) REFERENCES patient(p_aadhar),
    FOREIGN KEY (d_aadhar) REFERENCES doctor(doc_aadhar)
);

CREATE TABLE drugs (
    trade_name VARCHAR2(20),
    pc_name VARCHAR2(20),   
    formula VARCHAR2(30),
    PRIMARY KEY (trade_name, pc_name),
    FOREIGN KEY (pc_name) REFERENCES pharma_company(pcompany_name)
);

CREATE TABLE presc_drugs (
    prescription_id INT,
    d_trade VARCHAR2(20),
    pc_name VARCHAR2(20),
    quantity INT,
    FOREIGN KEY (prescription_id) REFERENCES prescription(prescription_id),
    FOREIGN KEY (d_trade, pc_name) REFERENCES drugs(trade_name, pc_name)
);

CREATE TABLE pharmacy (
    pharmacy_name VARCHAR2(20) PRIMARY KEY,
    pharma_address VARCHAR2(30),
    phone VARCHAR2(10),
    email VARCHAR2(30)
);

CREATE TABLE drug_pharmacy (
    d_trade VARCHAR2(20),
    pc_name VARCHAR2(20),
    pharmacy_name VARCHAR2(20),
    stock INT,
    FOREIGN KEY (d_trade, pc_name) REFERENCES drugs(trade_name, pc_name),
    FOREIGN KEY (pharmacy_name) REFERENCES pharmacy(pharmacy_name)
);

CREATE TABLE contract (
    pname VARCHAR(20),
    pcname VARCHAR(20),
    start_date DATE,
    end_date DATE,
    supervisor VARCHAR(20),
    content VARCHAR(50),
    PRIMARY KEY (pname, pcname),
    FOREIGN KEY (pname) REFERENCES pharmacy(pharmacy_name),
    FOREIGN KEY (pcname) REFERENCES pharma_company(pcompany_name)
);

-- Procedures to insert into the tables

-- Procedure to insert into the 'doctor' table
CREATE OR REPLACE PROCEDURE insert_doctor (
    p_doc_aadhar IN NUMBER,
    p_doc_name IN VARCHAR2,
    p_speciality IN VARCHAR2,
    p_years_exp IN NUMBER
) AS
BEGIN
    INSERT INTO doctor (doc_aadhar, doc_name, speciality, years_exp)
    VALUES (p_doc_aadhar, p_doc_name, p_speciality, p_years_exp);
END;
/

-- Procedure to insert into the 'patient' table
CREATE OR REPLACE PROCEDURE insert_patient (
    p_patient_aadhar IN NUMBER,
    p_patient_name IN VARCHAR2,
    p_patient_address IN VARCHAR2,
    p_patient_age IN NUMBER,
    p_patient_doc_aadhar IN NUMBER
) AS
BEGIN
    INSERT INTO patient (p_aadhar, p_name, p_address, age, d_aadhar)
    VALUES (p_patient_aadhar, p_patient_name, p_patient_address, p_patient_age, p_patient_doc_aadhar);
END;
/

-- Procedure to insert into the 'pharma_company' table
CREATE OR REPLACE PROCEDURE insert_pharma_company (
    p_company_name IN VARCHAR2,
    p_phone IN VARCHAR2,
    p_email IN VARCHAR2
) AS
BEGIN
    INSERT INTO pharma_company (pcompany_name, phone, email)
    VALUES (p_company_name, p_phone, p_email);
END;
/

-- Procedure to insert into the 'drugs' table
CREATE OR REPLACE PROCEDURE insert_drug (
    p_trade_name IN VARCHAR2,
    p_pc_name IN VARCHAR2,
    p_formula IN VARCHAR2
) AS
BEGIN
    INSERT INTO drugs (trade_name, pc_name, formula)
    VALUES (p_trade_name, p_pc_name, p_formula);
END;
/

-- Procedure to insert into the 'pharmacy' table
CREATE OR REPLACE PROCEDURE insert_pharmacy (
    p_pharmacy_name IN VARCHAR2,
    p_address IN VARCHAR2,
    p_phone IN VARCHAR2,
    p_email IN VARCHAR2
) AS
BEGIN
    INSERT INTO pharmacy (pharmacy_name, pharma_address, phone, email)
    VALUES (p_pharmacy_name, p_address, p_phone, p_email);
END;
/

-- Procedure to insert into the 'drug_pharmacy' table
CREATE OR REPLACE PROCEDURE insert_drug_pharmacy (
    p_d_trade IN VARCHAR2,
    p_pc_name IN VARCHAR2,
    p_pharmacy_name IN VARCHAR2,
    p_stock IN NUMBER
) AS
BEGIN
    INSERT INTO drug_pharmacy (d_trade, pc_name, pharmacy_name, stock)
    VALUES (p_d_trade, p_pc_name, p_pharmacy_name, p_stock);
END;
/

-- Procedure to insert into the 'prescription' table
CREATE OR REPLACE PROCEDURE insert_prescription (
    p_prescription_id IN NUMBER,
    p_d_aadhar IN NUMBER,
    p_p_aadhar IN NUMBER,
    p_p_date IN DATE
) AS
BEGIN
    INSERT INTO prescription (prescription_id, d_aadhar, p_aadhar, p_date)
    VALUES (p_prescription_id, p_d_aadhar, p_p_aadhar, p_p_date);
END;
/

-- Procedure to insert into the 'presc_drugs' table
CREATE OR REPLACE PROCEDURE insert_presc_drug (
    p_prescription_id IN NUMBER,
    p_d_trade IN VARCHAR2,
    p_pc_name IN VARCHAR2,
    p_quantity IN NUMBER
) AS
BEGIN
    INSERT INTO presc_drugs (prescription_id, d_trade, pc_name, quantity)
    VALUES (p_prescription_id, p_d_trade, p_pc_name, p_quantity);
END;
/

-- Procedure to insert into the 'contract' table
CREATE OR REPLACE PROCEDURE insert_contract (
    p_pname IN VARCHAR2,
    p_pcname IN VARCHAR2,
    p_start_date IN DATE,
    p_end_date IN DATE,
    p_supervisor IN VARCHAR2,
    p_content IN VARCHAR2
) AS
BEGIN
    INSERT INTO contract (pname, pcname, start_date, end_date, supervisor, content)
    VALUES (p_pname, p_pcname, p_start_date, p_end_date, p_supervisor, p_content);
END;
/

-- Inserting data via procedures
BEGIN
    insert_doctor(1001, 'Dr. Sharma', 'General', 12);
    insert_doctor(1002, 'Dr. Arjun', 'Cardiology', 15);
    insert_doctor(1003, 'Dr. Khan', 'Dermatology', 10);
    insert_doctor(1004, 'Dr. Meera', 'Pediatrics', 7);

    insert_patient(2001, 'Arjun', 'Hyderabad', 30, 1001);
    insert_patient(2002, 'Neha', 'Mumbai', 25, 1001);
    insert_patient(2003, 'Rajeev', 'Bangalore', 45, 1003);
    insert_patient(2004, 'Tanya', 'Pune', 32, 1004);
    insert_patient(2005, 'Isha', 'Chennai', 28, 1002);

    insert_pharma_company('MedLife', '9876543210', 'contact@medlife.com');
    insert_pharma_company('PharmaCare', '9123456789', 'info@pharmacare.com');
    insert_pharma_company('ZenithPharma', '9988776655', 'contact@zenith.com');
    insert_pharma_company('CureMax', '9845123456', 'support@curemax.com');

    insert_drug('Paracet', 'MedLife', 'C8H9NO2');
    insert_drug('HeadClear', 'MedLife', 'C16H19NO4');
    insert_drug('Neurozil', 'PharmaCare', 'C15H13N2O2');
    insert_drug('Skinlite', 'ZenithPharma', 'C14H11NO2');
    insert_drug('KidSafe', 'CureMax', 'C18H27NO3');

    insert_pharmacy('CityMeds', 'Madhapur', '7766554433', 'citymeds@pharmacy.com');
    insert_pharmacy('HealthPlus', 'Banjara Hills', '7755443322', 'healthplus@pharmacy.com');

    insert_drug_pharmacy('Paracet', 'MedLife', 'CityMeds', 200);
    insert_drug_pharmacy('HeadClear', 'MedLife', 'HealthPlus', 150);
    insert_drug_pharmacy('Neurozil', 'PharmaCare', 'CityMeds', 100);
    insert_drug_pharmacy('Skinlite', 'ZenithPharma', 'HealthPlus', 120);
    insert_drug_pharmacy('KidSafe', 'CureMax', 'CityMeds', 250);

    insert_prescription(3001, 1001, 2001, TO_DATE('2025-04-20', 'YYYY-MM-DD'));
    insert_prescription(3002, 1002, 2002, TO_DATE('2025-04-18', 'YYYY-MM-DD'));
    insert_prescription(3003, 1001, 2001, TO_DATE('2025-04-20', 'YYYY-MM-DD'));

    insert_presc_drug(3001, 'Paracet', 'MedLife', 2);
    insert_presc_drug(3002, 'HeadClear', 'MedLife', 1);
    insert_presc_drug(3003, 'HeadClear', 'MedLife', 1);

    insert_contract('CityMeds', 'MedLife', TO_DATE('2025-01-01', 'YYYY-MM-DD'), TO_DATE('2026-01-01', 'YYYY-MM-DD'), 'John Doe', 'Drug supply agreement');
    insert_contract('HealthPlus', 'PharmaCare', TO_DATE('2025-02-01', 'YYYY-MM-DD'), TO_DATE('2026-02-01', 'YYYY-MM-DD'), 'Jane Smith', 'Pharmacy agreement');
END;
/
-- Procedure to delete a doctor by doc_aadhar
CREATE OR REPLACE PROCEDURE delete_doctor (
    p_doc_aadhar IN NUMBER
) AS
BEGIN
    DELETE FROM doctor WHERE doc_aadhar = p_doc_aadhar;
    IF SQL%ROWCOUNT > 0 THEN
        DBMS_OUTPUT.PUT_LINE('Doctor deleted successfully');
    ELSE
        DBMS_OUTPUT.PUT_LINE('Doctor not found');
    END IF;
END;
/

-- Procedure to delete a patient by p_aadhar
CREATE OR REPLACE PROCEDURE delete_patient (
    p_patient_aadhar IN NUMBER
) AS
BEGIN
    DELETE FROM patient WHERE p_aadhar = p_patient_aadhar;
    IF SQL%ROWCOUNT > 0 THEN
        DBMS_OUTPUT.PUT_LINE('Patient deleted successfully');
    ELSE
        DBMS_OUTPUT.PUT_LINE('Patient not found');
    END IF;
END;
/

-- Procedure to delete a pharma company by pcompany_name
CREATE OR REPLACE PROCEDURE delete_pharma_company (
    p_company_name IN VARCHAR2
) AS
BEGIN
    DELETE FROM pharma_company WHERE pcompany_name = p_company_name;
    IF SQL%ROWCOUNT > 0 THEN
        DBMS_OUTPUT.PUT_LINE('Pharma company deleted successfully');
    ELSE
        DBMS_OUTPUT.PUT_LINE('Pharma company not found');
    END IF;
END;
/

-- Procedure to delete a drug by trade_name and pc_name
CREATE OR REPLACE PROCEDURE delete_drug (
    p_trade_name IN VARCHAR2,
    p_pc_name IN VARCHAR2
) AS
BEGIN
    DELETE FROM drugs WHERE trade_name = p_trade_name AND pc_name = p_pc_name;
    IF SQL%ROWCOUNT > 0 THEN
        DBMS_OUTPUT.PUT_LINE('Drug deleted successfully');
    ELSE
        DBMS_OUTPUT.PUT_LINE('Drug not found');
    END IF;
END;
/

-- Procedure to delete a pharmacy by pharmacy_name
CREATE OR REPLACE PROCEDURE delete_pharmacy (
    p_pharmacy_name IN VARCHAR2
) AS
BEGIN
    DELETE FROM pharmacy WHERE pharmacy_name = p_pharmacy_name;
    IF SQL%ROWCOUNT > 0 THEN
        DBMS_OUTPUT.PUT_LINE('Pharmacy deleted successfully');
    ELSE
        DBMS_OUTPUT.PUT_LINE('Pharmacy not found');
    END IF;
END;
/

-- Procedure to delete a drug-pharmacy relation by d_trade, pc_name, and pharmacy_name
CREATE OR REPLACE PROCEDURE delete_drug_pharmacy (
    p_d_trade IN VARCHAR2,
    p_pc_name IN VARCHAR2,
    p_pharmacy_name IN VARCHAR2
) AS
BEGIN
    DELETE FROM drug_pharmacy WHERE d_trade = p_d_trade AND pc_name = p_pc_name AND pharmacy_name = p_pharmacy_name;
    IF SQL%ROWCOUNT > 0 THEN
        DBMS_OUTPUT.PUT_LINE('Drug-pharmacy relation deleted successfully');
    ELSE
        DBMS_OUTPUT.PUT_LINE('Drug-pharmacy relation not found');
    END IF;
END;
/

-- Procedure to delete a prescription by prescription_id
CREATE OR REPLACE PROCEDURE delete_prescription (
    p_prescription_id IN NUMBER
) AS
BEGIN
    DELETE FROM prescription WHERE prescription_id = p_prescription_id;
    IF SQL%ROWCOUNT > 0 THEN
        DBMS_OUTPUT.PUT_LINE('Prescription deleted successfully');
    ELSE
        DBMS_OUTPUT.PUT_LINE('Prescription not found');
    END IF;
END;
/

-- Procedure to delete a prescribed drug by prescription_id, trade_name, and pc_name
CREATE OR REPLACE PROCEDURE delete_presc_drug (
    p_prescription_id IN NUMBER,
    p_d_trade IN VARCHAR2,
    p_pc_name IN VARCHAR2
) AS
BEGIN
    DELETE FROM presc_drugs WHERE prescription_id = p_prescription_id AND d_trade = p_d_trade AND pc_name = p_pc_name;
    IF SQL%ROWCOUNT > 0 THEN
        DBMS_OUTPUT.PUT_LINE('Prescribed drug deleted successfully');
    ELSE
        DBMS_OUTPUT.PUT_LINE('Prescribed drug not found');
    END IF;
END;
/

-- Procedure to delete a contract by pharmacy_name and pharma_company_name
CREATE OR REPLACE PROCEDURE delete_contract (
    p_pname IN VARCHAR2,
    p_pcname IN VARCHAR2
) AS
BEGIN
    DELETE FROM contract WHERE pname = p_pname AND pcname = p_pcname;
    IF SQL%ROWCOUNT > 0 THEN
        DBMS_OUTPUT.PUT_LINE('Contract deleted successfully');
    ELSE
        DBMS_OUTPUT.PUT_LINE('Contract not found');
    END IF;
END;
/
