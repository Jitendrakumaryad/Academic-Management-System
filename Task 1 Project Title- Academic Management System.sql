CREATE Database task1;
use task1;
--- -- Academic Management System (1. Database creation)
 
CREATE TABLE StudentInfo (
    STU_ID INT PRIMARY KEY,
    STU_NAME VARCHAR(100) NOT NULL,
    DOB DATE,
    PHONE_NO VARCHAR(15),
    EMAIL_ID VARCHAR(100) UNIQUE,
    ADDRESS VARCHAR(255)
);

CREATE TABLE CoursesInfo (
    COURSE_ID INT PRIMARY KEY,
    COURSE_NAME VARCHAR(100) NOT NULL,
    COURSE_INSTRUCTOR_NAME VARCHAR(100)
);

CREATE TABLE EnrollmentInfo (
    ENROLLMENT_ID INT PRIMARY KEY,
    STU_ID INT,
    COURSE_ID INT,
    ENROLL_STATUS VARCHAR(20) CHECK (ENROLL_STATUS IN ('Enrolled', 'Not Enrolled')),
    FOREIGN KEY (STU_ID) REFERENCES StudentInfo(STU_ID),
    FOREIGN KEY (COURSE_ID) REFERENCES CoursesInfo(COURSE_ID)
);

------ Academic Management System (2. Data creation) 

INSERT INTO StudentInfo (STU_ID, STU_NAME, DOB, PHONE_NO, EMAIL_ID, ADDRESS) VALUES
(101, 'Ajay', '2000-01-15', '9876543210', 'ajay@gmail.com', '123, Gandhi Road, Delhi'),
(102, 'Raj', '1999-05-20', '9988776655', 'raj@gmail.com', '456, Nehru Street, Mumbai'),
(103, 'Dev', '2001-11-10', '9765432109', 'dev@gmail.com', '789, Patel Nagar, Bangalore'),
(104, 'Ganesh', '1998-03-25', '9123456789', 'ganesh@gmail.com', '101, MG Road, Chennai');

INSERT INTO CoursesInfo (COURSE_ID, COURSE_NAME, COURSE_INSTRUCTOR_NAME) VALUES
(201, 'Engineering', 'Prof. Pradeep'),
(202, 'Medicine', 'Prof. Sanjay'),
(203, 'Science', 'Prof. Singh'),
(204, 'Finance', 'Prof. Jay');  

INSERT INTO EnrollmentInfo (ENROLLMENT_ID, STU_ID, COURSE_ID, ENROLL_STATUS) VALUES
(1, 101, 201, 'Enrolled'),
(2, 101, 202, 'Enrolled'),
(3, 102, 201, 'Enrolled'),
(4, 102, 203, 'Enrolled'),
(5, 103, 202, 'Enrolled'),
(6, 103, 204, 'Not Enrolled')
 
 -- Academic Management System (3. Retrieve the Student Information) -- A)- Write a query to retrieve student details, such as student name, contact information, and Enrollment status.

SELECT s.STU_NAME, s.PHONE_NO, s.EMAIL_ID, s.ADDRESS, e.ENROLL_STATUS
FROM StudentInfo s, EnrollmentInfo e
WHERE s.STU_ID = e.STU_ID;

-- Academic Management System (3. Retrieve the Student Information) -- B) retrieve a list of courses in which a specific student is enrolled

SELECT
    S.STU_NAME,
    C.COURSE_NAME,
    E.ENROLL_STATUS
FROM
    StudentInfo AS S
JOIN
    EnrollmentInfo AS E ON S.STU_ID = E.STU_ID
JOIN
    CoursesInfo AS C ON E.COURSE_ID = C.COURSE_ID
WHERE
    S.STU_NAME = 'Ajay' AND E.ENROLL_STATUS = 'Enrolled';

 -- Academic Management System (3. Retrieve the Student Information) -- C) retrieve course information, including course name, instructor information.

SELECT
    COURSE_NAME,
    COURSE_INSTRUCTOR_NAME
FROM
    CoursesInfo;
    
    -- Academic Management System (3. Retrieve the Student Information) -- D) retrieve course information for a specific course .

-- (retrieve information for COURSE_ID = 201)
SELECT
    COURSE_NAME,
    COURSE_INSTRUCTOR_NAME
FROM
    CoursesInfo
WHERE
    COURSE_ID = 201;
    -- Academic Management System (3. Retrieve the Student Information) -- E) retrieve course information for multiple courses.
    --- retrieve information for COURSE_ID 201 and 203
SELECT 
COURSE_NAME,
    COURSE_INSTRUCTOR_NAME
FROM
    CoursesInfo
WHERE
    COURSE_ID IN (201, 203);
    -- Academic Management System (3. Retrieve the Student Information) -- F)Test the queries to ensure accurate retrieval of student information.( execute the queries and verify the results against the expected output.)
    
    ---- verify Ajay's enrollment
    
SELECT STU_NAME, COURSE_NAME, ENROLL_STATUS
FROM StudentInfo
JOIN EnrollmentInfo USING (STU_ID)
JOIN CoursesInfo USING (COURSE_ID)
WHERE STU_NAME = 'Ajay';

-- Academic Management System (4.Reporting and Analytics (Using joining queries) A) query to retrieve the number of students enrolled in each course

SELECT 
    COURSE_NAME,
    COUNT(*) AS StudentCount
FROM 
    CoursesInfo c
JOIN 
    EnrollmentInfo e ON c.COURSE_ID = e.COURSE_ID
WHERE 
    ENROLL_STATUS = 'Enrolled'
GROUP BY 
    COURSE_NAME
ORDER BY 
    StudentCount DESC;
    
    -- Academic Management System (4.Reporting and Analytics (Using joining queries) B) query to retrieve the number of students enrolled in each course
    
    --- retrieval students enrolled in (COURSE_ID = 201)
    
  SELECT
    S.STU_NAME,
    C.COURSE_NAME
FROM
    StudentInfo AS S
JOIN
    EnrollmentInfo AS E ON S.STU_ID = E.STU_ID
JOIN
    CoursesInfo AS C ON E.COURSE_ID = C.COURSE_ID
WHERE
    C.COURSE_ID = 201 AND E.ENROLL_STATUS = 'Enrolled';
    -- Academic Management System (4.Reporting and Analytics (Using joining queries) C) query to retrieve the count of enrolled students for each instructor.
    
    SELECT
    C.COURSE_INSTRUCTOR_NAME,
    COUNT(DISTINCT E.STU_ID) AS NumberOfEnrolledStudents
FROM
    CoursesInfo AS C
JOIN
    EnrollmentInfo AS E ON C.COURSE_ID = E.COURSE_ID
WHERE
    E.ENROLL_STATUS = 'Enrolled'
GROUP BY
    C.COURSE_INSTRUCTOR_NAME
ORDER BY
    NumberOfEnrolledStudents DESC;

    -- Academic Management System (4.Reporting and Analytics (Using joining queries) D) query to retrieve the list of students who are enrolled in multiple courses
    
    SELECT
    S.STU_NAME,
    COUNT(E.COURSE_ID) AS NumberOfCoursesEnrolled
FROM
    StudentInfo AS S
JOIN
    EnrollmentInfo AS E ON S.STU_ID = E.STU_ID
WHERE
    E.ENROLL_STATUS = 'Enrolled'
GROUP BY
    S.STU_NAME
HAVING
    COUNT(E.COURSE_ID) > 1
ORDER BY
    NumberOfCoursesEnrolled DESC;

-- Academic Management System (4.Reporting and Analytics (Using joining queries) E) Query to retrieve the courses that have the highest number of enrolled students(arranging from highest to lowest)

SELECT
    C.COURSE_NAME,
    COUNT(E.STU_ID) AS NumberOfStudentsEnrolled
FROM
    CoursesInfo AS C
JOIN
    EnrollmentInfo AS E ON C.COURSE_ID = E.COURSE_ID
WHERE
    E.ENROLL_STATUS = 'Enrolled'
GROUP BY
    C.COURSE_NAME
ORDER BY
    NumberOfStudentsEnrolled DESC;
