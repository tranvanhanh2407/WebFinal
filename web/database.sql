-- Kiểm tra xem cơ sở dữ liệu có tồn tại không trước khi thực hiện bất kỳ thao tác nào
DROP DATABASE IF EXISTS score_management;

-- Tạo cơ sở dữ liệu mới
CREATE DATABASE IF NOT EXISTS score_management;

-- Sử dụng cơ sở dữ liệu mới để tạo bảng
USE score_management;

-- Tạo bảng quản trị viên
CREATE TABLE admins (
  id INT(10) NOT NULL AUTO_INCREMENT, -- Tự động tăng
  login_id VARCHAR(20) NOT NULL UNIQUE, -- Đảm bảo rằng ID đăng nhập là duy nhất
  password VARCHAR(64) NOT NULL, -- Mật khẩu không được để trống
  actived_flag INT(1) DEFAULT 1, -- Cờ kích hoạt mặc định là 1
  reset_password_token VARCHAR(100), -- Token để đặt lại mật khẩu
  updated DATETIME ON UPDATE CURRENT_TIMESTAMP, -- Thời gian cập nhật mặc định là thời gian hiện tại khi cập nhật
  created DATETIME DEFAULT CURRENT_TIMESTAMP, -- Thời gian tạo mặc định là thời gian hiện tại
  PRIMARY KEY (id) -- Khóa chính
) ENGINE=InnoDB; -- Sử dụng InnoDB vì nó hỗ trợ các giao dịch

-- Tạo bảng môn học
CREATE TABLE subjects (
  id INT(10) NOT NULL AUTO_INCREMENT, -- Tự động tăng
  name VARCHAR(250), -- Tên môn học
  avatar VARCHAR(250), -- Tên của tệp avatar (không lưu trữ đường dẫn của tệp trong DB)
  description TEXT, -- Mô tả môn học
  school_year CHAR(10), -- Mã của năm học
  updated DATETIME, -- Thời gian cập nhật
  created DATETIME DEFAULT CURRENT_TIMESTAMP, -- Thời gian tạo mặc định là thời gian hiện tại
  PRIMARY KEY (id) -- Khóa chính
) ENGINE=InnoDB;

-- Tạo bảng giáo viên
CREATE TABLE teachers (
  id INT(10) NOT NULL AUTO_INCREMENT, -- Tự động tăng
  name VARCHAR(250), -- Tên giáo viên
  avatar VARCHAR(250), -- Tên của tệp avatar (không lưu trữ đường dẫn của tệp trong DB)
  description TEXT, -- Mô tả giáo viên
  specialized CHAR(10), -- Mã của chuyên ngành
  degree CHAR(10), -- Mã của bằng cấp
  updated DATETIME, -- Thời gian cập nhật
  created DATETIME DEFAULT CURRENT_TIMESTAMP, -- Thời gian tạo mặc định là thời gian hiện tại
  PRIMARY KEY (id) -- Khóa chính
) ENGINE=InnoDB;

-- Tạo bảng sinh viên
CREATE TABLE students (
  id INT(10) NOT NULL AUTO_INCREMENT, -- Tự động tăng
  name VARCHAR(250), -- Tên sinh viên
  avatar VARCHAR(250), -- Tên của tệp avatar (không lưu trữ đường dẫn của tệp trong DB)
  description TEXT, -- Mô tả sinh viên
  updated DATETIME, -- Thời gian cập nhật
  created DATETIME DEFAULT CURRENT_TIMESTAMP, -- Thời gian tạo mặc định là thời gian hiện tại
  PRIMARY KEY (id) -- Khóa chính
) ENGINE=InnoDB;

-- Tạo bảng điểm
CREATE TABLE scores (
  id INT(10) NOT NULL AUTO_INCREMENT, -- Tự động tăng
  student_id INT(10), -- Khóa ngoại liên kết với bảng students
  teacher_id INT(10), -- Khóa ngoại liên kết với bảng teachers
  subject_id INT(10), -- Khóa ngoại liên kết với bảng subjects
  score INT(2) DEFAULT 0, -- Điểm số mặc định là 0
  description TEXT, -- Mô tả thêm về điểm số
  updated DATETIME, -- Thời gian cập nhật điểm
  created DATETIME DEFAULT CURRENT_TIMESTAMP, -- Thời gian tạo điểm, mặc định là thời gian hiện tại
  PRIMARY KEY (id) -- Khóa chính
) ENGINE=InnoDB;

-- Thêm khóa ngoại cho bảng scores
ALTER TABLE scores
ADD CONSTRAINT FK_student -- Khóa ngoại liên kết với bảng students
FOREIGN KEY (student_id) REFERENCES students(id),
ADD CONSTRAINT FK_teacher -- Khóa ngoại liên kết với bảng teachers
FOREIGN KEY (teacher_id) REFERENCES teachers(id),
ADD CONSTRAINT FK_subject -- Khóa ngoại liên kết với bảng subjects
FOREIGN KEY (subject_id) REFERENCES subjects(id);

-- Trigger cho bảng admins
DELIMITER //
CREATE TRIGGER admins_before_update 
BEFORE UPDATE ON admins
FOR EACH ROW 
BEGIN
   SET NEW.updated = NOW();
END;//
DELIMITER ;

-- Trigger cho bảng subjects
DELIMITER //
CREATE TRIGGER subjects_before_update 
BEFORE UPDATE ON subjects
FOR EACH ROW 
BEGIN
   SET NEW.updated = NOW();
END;//
DELIMITER ;

-- Trigger cho bảng teachers
DELIMITER //
CREATE TRIGGER teachers_before_update 
BEFORE UPDATE ON teachers
FOR EACH ROW 
BEGIN
   SET NEW.updated = NOW();
END;//
DELIMITER ;

-- Trigger cho bảng students
DELIMITER //
CREATE TRIGGER students_before_update 
BEFORE UPDATE ON students
FOR EACH ROW 
BEGIN
   SET NEW.updated = NOW();
END;//
DELIMITER ;

-- Trigger cho bảng scores
DELIMITER //
CREATE TRIGGER scores_before_update 
BEFORE UPDATE ON scores
FOR EACH ROW 
BEGIN
   SET NEW.updated = NOW();
END;//
DELIMITER ;

-- Stored Procedure để thêm một giáo viên mới
DELIMITER //
CREATE PROCEDURE AddTeacher(IN name VARCHAR(250), IN avatar VARCHAR(250), IN description TEXT, IN specialized CHAR(10), IN degree CHAR(10))
BEGIN
  INSERT INTO teachers(name, avatar, description, specialized, degree) 
  VALUES (name, avatar, description, specialized, degree);
END;//
DELIMITER ;

-- Stored Procedure để cập nhật thông tin giáo viên
DELIMITER //
CREATE PROCEDURE UpdateTeacher(IN id INT(10), IN name VARCHAR(250), IN avatar VARCHAR(250), IN description TEXT, IN specialized CHAR(10), IN degree CHAR(10))
BEGIN
  UPDATE teachers 
  SET name = name, avatar = avatar, description = description, specialized = specialized, degree = degree
  WHERE id = id;
END;//
DELIMITER ;

-- Stored Procedure để xóa một giáo viên
DELIMITER //
CREATE PROCEDURE DeleteTeacher(IN id INT(10))
BEGIN
  DELETE FROM teachers WHERE id = id;
END;//
DELIMITER ;

-- Stored Procedure để lấy thông tin của tất cả giáo viên
DELIMITER //
CREATE PROCEDURE GetAllTeachers()
BEGIN
  SELECT * FROM teachers;
END;//
DELIMITER ;

-- Thêm dữ liệu
INSERT INTO admins (login_id, password) VALUES
('admin1', 'password1'),
('admin2', 'password2');

INSERT INTO subjects (name, avatar, description, school_year) VALUES
('Mathematics', 'avatar1.jpg', 'Mathematics subject description', '2023-2024'),
('Physics', 'avatar2.jpg', 'Physics subject description', '2023-2024'),
('Chemistry', 'avatar3.jpg', 'Chemistry subject description', '2023-2024'),
('Biology', 'avatar4.jpg', 'Biology subject description', '2023-2024'),
('History', 'avatar5.jpg', 'History subject description', '2023-2024');

INSERT INTO teachers (name, avatar, description, specialized, degree) VALUES
('John Doe', 'avatar1.jpg', 'Mathematics teacher', 'Math', 'Bachelor'),
('Jane Smith', 'avatar2.jpg', 'Physics teacher', 'Physics', 'Master'),
('David Johnson', 'avatar3.jpg', 'Chemistry teacher', 'Chemistry', 'PhD'),
('Emily Wilson', 'avatar4.jpg', 'Biology teacher', 'Biology', 'Bachelor'),
('Michael Brown', 'avatar5.jpg', 'History teacher', 'History', 'Master');

INSERT INTO students (name, avatar, description) VALUES
('Alice Johnson', 'avatar1.jpg', 'Student description'),
('Bob Smith', 'avatar2.jpg', 'Student description'),
('Charlie Davis', 'avatar3.jpg', 'Student description'),
('Eva Wilson', 'avatar4.jpg', 'Student description'),
('Frank Miller', 'avatar5.jpg', 'Student description');

INSERT INTO scores (student_id, teacher_id, subject_id, score, description) VALUES
(1, 1, 1, 85, 'Mathematics score'),
(2, 2, 2, 92, 'Physics score'),
(3, 3, 3, 78, 'Chemistry score'),
(4, 4, 4, 90, 'Biology score'),
(5, 5, 5, 87, 'History score');

