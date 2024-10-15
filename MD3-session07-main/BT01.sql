create database s07_bt1;
use s07_bt1;
create table subjects(
	subject_id int auto_increment primary key,
    subject_name nvarchar(50)
);
create table students(
	student_id int primary key auto_increment,
    student_name nvarchar(50),
    age int(4),
    email varchar(100)
);
create table marks(
	mark int,
    subject_id int,
    student_id int,
    constraint fk_mark01 foreign key(subject_id) references subjects(subject_id),
    constraint fk_mark02 foreign key(student_id) references students(student_id)
);
create table classes(
	class_id int primary key auto_increment,
    class_name nvarchar(50)
);
create table class_student(
	student_id int,
    class_id int,
    constraint fk_cs01 foreign key(student_id) references students(student_id),
    constraint fk_cs02 foreign key(class_id) references classes(class_id)
);

insert into students(student_name,age,email) values
('Nguyen Quang An',18,'an@yahoo.com'),('Nguyen Cong Vinh',20,'vinh@gmail.com'),
('Nguyen Van Quyen',19,'quyen'),('Pham Thanh Binh',25,'binh@com'),('Nguyen Van Tai Em',30,'taiem@sport.vn');

insert into classes(class_name) values ('C0706L'),('C0708G');
insert into class_student(student_id,class_id) values
(1,1),(2,1),(3,2),(4,2),(5,2);
insert into subjects(subject_name) values
('SQL'),('Java'),('C'),('Visual Basic');
insert into marks(mark,subject_id,student_id) values
(8,1,1),(4,2,1),(9,1,1),(7,1,3),(3,1,4),(5,2,5),(8,3,3),(1,3,5),(3,2,4);

#Hiển thị danh sách tất cả học viên
SELECT * FROM students;

# Hiển thị danh sách tất cả môn học
SELECT * FROM subjects;

# Tính điểm trung bình theo từng học viên
SELECT s.student_name as 'Tên sinh viên',AVG(mark) as 'Điểm Trung Bình' from marks as m
inner join students as s on m.student_id = s.student_id
group by m.student_id;

# Hiển thị môn học có học sinh thi được điểm cao nhất
select s.subject_name as 'Tên môn học',m.mark as 'Điểm' from marks as m
inner join subjects as s on m.subject_id = s.subject_id
where mark = (select MAX(mark) from marks);

# Đánh số thứ tự của điểm theo chiều giảm
SELECT mark as 'Điểm' from marks order by mark desc;

# Thay đổi kiểu dữ liệu của cột SubjectName trong bang subjects thanh 7
alter table subjects modify column subject_name varchar(7);

# Cập nhật thêm dòng chữ << Đây là môn học >> vào trước các bản ghi trên cột subjectname trong bang subjects
UPDATE subjects set subject_name = concat('Đây là môn học ',subject_name);

# Viết check constraint để kiểm tra độ tuổi nhập vào trong bảng Student > 15 và < 50
Alter table students modify column age int check (age >15 AND age < 50);

#Loại bỏ tất cả quan hệ giữa các bảng
alter table marks DROP foreign key fk_mark01;
alter table marks DROP foreign key fk_mark02;
alter table class_student DROP foreign key fk_cs01;
alter table class_student DROP foreign key fk_cs02;

# Xoá học viên có student Id = 1;
delete from students where student_id = 1;

# Trong bảng student thêm 1 cột Status có kiểu dữ liệu là bit và có default là 1
alter table students add column status bit default(1);

# Cập nhật giá trị status trong bảng student thành 0
update students set status = 0;
