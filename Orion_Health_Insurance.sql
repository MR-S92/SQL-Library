DROP DATABASE IF EXISTS `Orion_Health_Insurance`;
CREATE DATABASE `Orion_Health_Insurance`;
USE `Orion_Health_Insurance`;

CREATE TABLE Orion_Health_Insurance_members (
    member_id INT AUTO_INCREMENT,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    birth_date DATE,
    gender VARCHAR(15),
    `language` ENUM('English', 'Spanish', 'Bilingual'),
    enrollment_status ENUM('Active', 'Inactive'),
    member_since DATE,
    Financial_stability ENUM('Low Risk', 'Medium', 'High Risk'),
    Life_style ENUM('Smoker', 'Drinks', 'Active', 'Non-Active'),
    state VARCHAR(50),
    PRIMARY KEY (member_id)
);

-- This line below is to calculate age automatic since it changes. 
-- SELECT TIMESTAMPDIFF(YEAR, birth_date, CURDATE()) AS age FROM Orion_Health_Insurance_members;

INSERT INTO Orion_Health_Insurance_members 
    (first_name, last_name, birth_date, gender, `language`, enrollment_status, member_since, Financial_stability, Life_style, state) 
VALUES
    ('Manuel', 'Sierra', '1979-09-25

', 'Male', 'Bilingual', 'Active', '2020-01-25', 'Low Risk', 'Active', 'Florida'),
    ('Jane', 'Smith', '1981-04-14', 'Female', 'English', 'Inactive', '2019-03-22', 'Low Risk', 'Active', 'Alabama');

CREATE TABLE Orion_Health_Insurance_Policies (
    policy_id INT AUTO_INCREMENT PRIMARY KEY,
    member_id INT NOT NULL,
    policy_tier ENUM('Secure', 'Bronze', 'Silver', 'Gold', 'Platinum') NOT NULL,
    coverage_amount DECIMAL(10,2) NOT NULL,
    premium DECIMAL(10,2) NOT NULL,
    deductible DECIMAL(10,2) NOT NULL,
    coinsurance_percentage TINYINT NOT NULL,
    out_of_pocket_max DECIMAL(10,2) NOT NULL,
    enrollment_start DATE NOT NULL,
    enrollment_end DATE NOT NULL,
    network_type ENUM('HMO', 'PPO', 'EPO') NOT NULL DEFAULT 'HMO',
    virtual_care_covered BOOLEAN NOT NULL DEFAULT TRUE,
    status ENUM('Active', 'Pending', 'Expired', 'Cancelled') NOT NULL DEFAULT 'Pending',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (member_id) REFERENCES Orion_Health_Insurance_members(member_id) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB;

INSERT INTO Orion_Health_Insurance_Policies (
    member_id, policy_tier, coverage_amount, premium, deductible, 
    coinsurance_percentage, out_of_pocket_max, enrollment_start, enrollment_end
) VALUES
    (1, 'Secure', 500000.00, 150.00, 8700.00, 50, 8700.00, '2025-01-01', '2025-12-31'),
    (2, 'Bronze', 750000.00, 250.00, 6000.00, 40, 8700.00, '2025-01-01', '2025-12-31');

CREATE TABLE Orion_Health_Insurance_Claims (
    claim_id INT AUTO_INCREMENT PRIMARY KEY,
    member_id INT NOT NULL,
    policy_id INT NOT NULL,
    claim_date DATE NOT NULL,
    service_date DATE NOT NULL,
    claim_type ENUM('Medical', 'Prescription', 'Emergency', 'Preventive', 'Other') NOT NULL,
    claim_amount DECIMAL(10,2) NOT NULL,
    covered_amount DECIMAL(10,2) NOT NULL,
    status ENUM('Pending', 'Approved', 'Denied', 'Paid', 'Appealed') NOT NULL DEFAULT 'Pending',
    provider_name VARCHAR(100) NOT NULL,
    description TEXT,
    denial_reason VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (member_id) REFERENCES Orion_Health_Insurance_members(member_id) ON DELETE RESTRICT ON UPDATE CASCADE,
    FOREIGN KEY (policy_id) REFERENCES Orion_Health_Insurance_Policies(policy_id) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB;

INSERT INTO Orion_Health_Insurance_Claims (
    member_id, policy_id, claim_date, service_date, claim_type, 
    claim_amount, covered_amount, status, provider_name, description
) VALUES
    (1, 1, '2025-02-15', '2025-02-10', 'Emergency', 5000.00, 2500.00, 'Approved', 'City Hospital', 'Broken arm treatment'),
    (1, 1, '2025-03-01', '2025-02-28', 'Prescription', 50.00, 45.00, 'Paid', 'Walgreens', 'Generic antibiotic'),
    (2, 2, '2025-04-05', '2025-04-03', 'Medical', 200.00, 120.00, 'Pending', 'Dr. Jane Doe', 'Annual checkup');

SELECT *
FROM Orion_Health_Insurance_Claims;