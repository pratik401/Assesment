-- 1 to 4 
CREATE TABLE Companies (
    CompanyID INT PRIMARY KEY IDENTITY(1,1),
    CompanyName VARCHAR(255) NOT NULL,
    Location VARCHAR(255)
);

CREATE TABLE Jobs (
    JobID INT PRIMARY KEY IDENTITY(1,1),
    CompanyID INT,
    JobTitle VARCHAR(255) NOT NULL,
    JobDescription TEXT,
    JobLocation VARCHAR(255),
    Salary DECIMAL(18, 2),
    JobType VARCHAR(50),
    PostedDate DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (CompanyID) REFERENCES Companies(CompanyID)
);

CREATE TABLE Applicants (
    ApplicantID INT PRIMARY KEY IDENTITY(1,1),
    FirstName VARCHAR(100) NOT NULL,
    LastName VARCHAR(100) NOT NULL,
    Email VARCHAR(255) NOT NULL,
    Phone VARCHAR(20),
	Experience int ,
    Resume TEXT
);

CREATE TABLE Applications (
    ApplicationID INT PRIMARY KEY IDENTITY(1,1),
    JobID INT,
    ApplicantID INT,
    ApplicationDate DATETIME DEFAULT GETDATE(),
    CoverLetter TEXT,
    FOREIGN KEY (JobID) REFERENCES Jobs(JobID),
    FOREIGN KEY (ApplicantID) REFERENCES Applicants(ApplicantID)
);


INSERT INTO Companies (CompanyName, Location)
VALUES 
('Tech Innovations', 'Bangalore'),
('Health Solutions', 'Mumbai'),
('EduTech', 'Hyderabad'),
('Eco Energy', 'Chennai');


INSERT INTO Jobs (CompanyID, JobTitle, JobDescription, JobLocation, Salary, JobType, PostedDate)
VALUES 
(1, 'Software Developer', 'Design and develop scalable software solutions.', 'Bangalore', 800000.00, 'Full-time', GETDATE()),
(2, 'Data Scientist', 'Analyze complex data sets to drive business strategies.', 'Mumbai', 1200000.00, 'Full-time', GETDATE()),
(3, 'Project Coordinator', 'Manage educational projects and liaise with stakeholders.', 'Hyderabad', 600000.00, 'Contract', GETDATE()),
(4, 'Environmental Consultant', 'Provide consultancy for eco-friendly projects.', 'Chennai', 900000.00, 'Part-time', GETDATE());


INSERT INTO Applicants (FirstName, LastName, Email, Phone,Experience, Resume)
VALUES 
('Ravi', 'Kumar', 'ravi.kumar@email.com', '9876543210',3 ,'Software developer with expertise in Java and Python.'),
('Aisha', 'Verma', 'aisha.verma@email.com', '9876543211',2, 'Data scientist experienced in machine learning algorithms.'),
('Anil', 'Sharma', 'anil.sharma@email.com', '9876543212',1, 'Project coordinator with a focus on educational initiatives.'),
('Neha', 'Iyer', 'neha.iyer@email.com', '9876543213', 4,'Environmental consultant with a passion for sustainability.');

INSERT INTO Applications (JobID, ApplicantID, ApplicationDate, CoverLetter)
VALUES 
(1, 1, GETDATE(), 'I am excited to apply for the Software Developer position at Tech Innovations.'),
(2, 2, GETDATE(), 'My background in data science makes me a great fit for Health Solutions.'),
(3, 3, GETDATE(), 'I am keen to contribute to EduTech as a Project Coordinator.'),
(4, 4, GETDATE(), 'I am passionate about sustainability and would love to work with Eco Energy.');

select * from Applicants;
select * from Companies;
select * from Jobs;
select * from Applications;
go

-- 5 Write an SQL query to count the number of applications received for each job listing in the 
--"Jobs" table. Display the job title and the corresponding application count. Ensure that it lists all 
--jobs, even if they have no applications. 

SELECT 
    j.JobTitle,
    COUNT(a.ApplicationID) AS ApplicationCount FROM Jobs j LEFT JOIN 
    Applications a ON j.JobID = a.JobID
GROUP BY 
    j.JobTitle;


-- 6 Develop an SQL query that retrieves job listings from the "Jobs" table within a specified salary range. Allow parameters for the minimum and maximum salary values. Display the job title, company name, location, and salary for each matching job. 

SELECT 
    j.JobTitle,
    c.CompanyName,
    c.Location,
    j.Salary FROM  Jobs j JOIN  Companies c ON j.CompanyID = c.CompanyID
WHERE 
    j.Salary BETWEEN 800000.00  AND 900000.00;

--7 Write an SQL query that retrieves the job application history for a specific applicant. Allow a parameter for the ApplicantID, and return a result set with the job titles, company names, and application dates for all the jobs the applicant has applied to. 

SELECT j.JobTitle, c.CompanyName, a.ApplicationDate FROM Applications a JOIN Jobs j ON a.JobID = j.JobID 
JOIN Companies c ON j.CompanyID = c.CompanyID WHERE a.ApplicantID = 1;

-- 8 Create an SQL query that calculates and displays the average salary offered by all companies for job listings in the "Jobs" table. Ensure that the query filters out jobs with a salary of zero. 

select * from Jobs;
INSERT INTO Jobs (CompanyID,JobTitle,JobDescription,JobLocation,Salary,JobType,PostedDate)

SELECT AVG(Salary) AS AverageSalary FROM Jobs WHERE Salary > 0;

-- 9 Write an SQL query to identify the company that has posted the most job listings. Display thecompany name along with the count of job listings they have posted. Handle ties if multiple  have the same maximum count. 

SELECT c.CompanyName, COUNT(j.JobID) AS JobCount FROM Companies c JOIN Jobs j ON c.CompanyID = j.CompanyID GROUP BY c.CompanyName HAVING COUNT(j.JobID) = (SELECT MAX(JobCount) FROM (SELECT COUNT(JobID) AS JobCount FROM Jobs GROUP BY CompanyID) AS JobCounts);

-- 10  Find the applicants who have applied for positions in companies located in 'CityX' and have at least 3 years of experience.

SELECT a.FirstName, a.LastName, a.Email, a.Phone FROM Applicants a JOIN Applications ap ON a.ApplicantID = ap.ApplicantID JOIN 
Jobs j ON ap.JobID = j.JobID JOIN Companies c ON j.CompanyID = c.CompanyID WHERE c.Location = 'Bangalore' AND a.Experience >= 3;

select * from jobs;
select * from Applicants;

--11  Retrieve a list of distinct job titles with salaries between $60,000 and $80,000. 
SELECT DISTINCT JobTitle FROM Jobs WHERE Salary BETWEEN 600000 AND 800000;

--12 Find the jobs that have not received any applications. 

-- first added a job without application 
INSERT INTO Jobs (CompanyID, JobTitle, JobDescription, JobLocation, Salary, JobType, PostedDate)
VALUES (1, 'Quality Assurance Engineer', 'Ensure the quality of software products through testing.', 'Bangalore', 700000.00, 'Full-time', GETDATE());

SELECT j.JobID, j.JobTitle, j.CompanyID FROM Jobs j LEFT JOIN Applications a ON j.JobID = a.JobID WHERE a.ApplicationID IS NULL;

--13  Retrieve a list of job applicants along with the companies they have applied to and the positions they have applied for. 

SELECT a.FirstName, a.LastName, c.CompanyName, j.JobTitle FROM Applicants a JOIN Applications ap ON a.ApplicantID = ap.ApplicantID 
JOIN Jobs j ON ap.JobID = j.JobID JOIN Companies c ON j.CompanyID = c.CompanyID;

-- 14  Retrieve a list of companies along with the count of jobs they have posted, even if they have not received any applications.

   SELECT c.CompanyName, COUNT(j.JobID) AS JobCount FROM Companies c LEFT JOIN Jobs j ON c.CompanyID = j.CompanyID GROUP BY c.CompanyName;

-- 15 

-- first insert new applicant who has not applied
INSERT INTO Applicants (FirstName, LastName, Email, Phone, Resume, Experience) 
VALUES ('Rohan', 'Kumar', 'rohan.kumar@example.com', '9876543210', 'Resume text or file reference', 2);


SELECT a.FirstName, a.LastName, c.CompanyName, j.JobTitle FROM Applicants a LEFT JOIN 
Applications ap ON a.ApplicantID = ap.ApplicantID LEFT JOIN Jobs j ON ap.JobID = j.JobID 
LEFT JOIN Companies c ON j.CompanyID = c.CompanyID;

-- 16  Find companies that have posted jobs with a salary higher than the average salary of all jobs.

SELECT AVG(salary) from Jobs;
SELECT * FROM  Companies c join Jobs j on c.CompanyID=j.CompanyID;
SELECT DISTINCT c.CompanyName FROM Companies c JOIN Jobs j ON c.CompanyID = j.CompanyID WHERE j.Salary > (SELECT AVG(Salary) FROM Jobs);

--17 Display a list of applicants with their names and a concatenated string of their city and state. 
ALTER TABLE Applicants 
ADD City VARCHAR(100), 
    State VARCHAR(100);

select * from Applicants;

INSERT INTO Applicants (FirstName, LastName, Email, Phone, Resume, Experience, City, State) 
VALUES ('Aditi', 'Sharma', 'aditi.sharma@example.com', '9876543210', 'Resume text or file reference', 3, 'Chennai', 'Tamil Nadu');

SELECT a.FirstName, a.LastName, CONCAT(a.City, ', ', a.State) AS Location FROM Applicants a;



-- 18 Retrieve a list of jobs with titles containing either 'Developer' or 'Engineer'.

SELECT * FROM Jobs WHERE JobTitle LIKE '%Developer%' OR JobTitle LIKE '%Engineer%';

-- 19  Retrieve a list of applicants and the jobs they have applied for, including those who have not applied and jobs without applicants. 

SELECT a.FirstName, a.LastName, j.JobTitle, c.CompanyName FROM Applicants a LEFT JOIN
Applications ap ON a.ApplicantID = ap.ApplicantID LEFT JOIN Jobs j ON ap.JobID = j.JobID 
LEFT JOIN Companies c ON j.CompanyID = c.CompanyID ORDER BY a.FirstName, j.JobTitle;

-- 20 . List all combinations of applicants and companies where the company is in a specific city and the applicant has more than 2 years of experience. For example: city=Chennai 

SELECT a.FirstName, a.LastName, c.CompanyName FROM Applicants a JOIN Applications ap ON a.ApplicantID = ap.ApplicantID 
JOIN Jobs j ON ap.JobID = j.JobID JOIN Companies c ON j.CompanyID = c.CompanyID WHERE c.Location = 'Chennai' AND a.Experience > 2;

select * from Applicants;
select * from Companies;
select * from Jobs;
