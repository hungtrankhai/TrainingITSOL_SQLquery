
host chcp 1258;

-- them 
--insert into student values (8, n'Nguyễn Thị Nga', n'Nữ', to_date('19940223', 'YYYYMMDD'), 'Hà Nội', 130000, 1);
--insert into student values (9, n'Trần Khải Hưng', n'Nam', to_date('19981214', 'YYYYMMDD'), 'Vĩnh Phúc', 120000, 4);
--insert into student values (10, n'Lê Văn Minh', n'Nam', to_date('19950221', 'YYYYMMDD'), 'Hà Nội', 180000, 2);
--insert into student values (11, n'Nguyễn Thị Liên', n'Nữ', to_date('19960223', 'YYYYMMDD'), 'Hải Phòng', 130000, 3);
--insert into student values (12, n'Nguyễn Văn Anh', n'Nam', to_date('19911024', 'YYYYMMDD'), 'Hà Nội', 150000, 2);
--insert into student values (13, n'Lê Văn Hiếu', n'Nam', to_date('19920201', 'YYYYMMDD'), 'Hòa Bình', 50000, 4);


/********* A. BASIC QUERY *********/

-- 1. Li?t kê danh sách sinh viên s?p x?p theo th? t?:
--      a. id t?ng d?n
select * from student
order by id ASC
--      b. gi?i tính
select student.id, student.name, student.gender
from student
order by student.gender asc
--      c. ngày sinh T?NG D?N và h?c b?ng GI?M D?N
select * from student
order by student.SCHOLARSHIP DESC, student.birthday ASC

-- 2. Môn h?c có tên b?t ??u b?ng ch? 'T'
select * from subject
where subject.name link 'T%'

-- 3. Sinh viên có ch? cái cu?i cùng trong tên là 'i'
select * from student
where student.name like '%i'
-- 4. Nh?ng khoa có ký t? th? hai c?a tên khoa có ch?a ch? 'n'
select * from faculty
where faculty.name like '_n%'
-- 5. Sinh viên trong tên có t? 'Th?'
select * from student
where student.name like '%Thị%'
-- 6. Sinh viên có ký t? ??u tiên c?a tên n?m trong kho?ng t? 'a' ??n 'm', s?p x?p theo h? tên sinh viên
select * from student
where student.name between 'A' and 'M'
order by student.name asc
-- 7. Sinh viên có h?c b?ng l?n h?n 100000, s?p x?p theo mã khoa gi?m d?n
select * from student
where student.scholarship > 100000
order by faculty_id desc
-- 8. Sinh viên có h?c b?ng t? 150000 tr? lên và sinh ? Hà N?i
select * from student
where student.scholarship > 150000 and student.hometown = 'Hà Nội'
-- 9. Nh?ng sinh viên có ngày sinh t? ngày 01/01/1991 ??n ngày 05/06/1992   ???  to_date(date, 'type')
select * from student 
where student.birthday between to_date('01/01/1991','DD/MM/YYYY') and to_date('05/06/1992','DD/MM/YYYY');
-- 10. Nh?ng sinh viên có h?c b?ng t? 80000 ??n 150000
select * from student
where student.scholarship between 80000 and 150000
-- 11. Nh?ng môn h?c có s? ti?t l?n h?n 30 và nh? h?n 45
select * from subject
where subject.lesson_quantity >30 and subject.lesson_quantity <45 

/********* B. CALCULATION QUERY *********/

-- 1. Cho bi?t thông tin v? m?c h?c b?ng c?a các sinh viên, g?m: Mã sinh viên, Gi?i tính, Mã 
		-- khoa, M?c h?c b?ng. Trong ?ó, m?c h?c b?ng s? hi?n th? là “H?c b?ng cao” n?u giá tr? 
		-- c?a h?c b?ng l?n h?n 500,000 và ng??c l?i hi?n th? là “M?c trung bình”.
		
-- 2. Tính t?ng s? sinh viên c?a toàn tr??ng
select count(student.id) as tongsinhvien
from student
-- 3. Tính t?ng s? sinh viên nam và t?ng s? sinh viên n?.
select student.gender , count(student.id) 
from student
group by student.gender

-- 4. Tính t?ng s? sinh viên t?ng khoa
select faculty.name, count(faculty.id) as tongsinhvien
from student join faculty on student.faculty_id = faculty.id
group by faculty.name
-- 5. Tính t?ng s? sinh viên c?a t?ng môn h?c
select subject_id, count(student_id) as tongsosinhvien
from exam_management
group by subject_id
-- 6. Tính s? l??ng môn h?c mà sinh viên ?ã h?c

--select student_id, count(subject_id) as tongsomondahoc
--from exam_management
--group by student_id
 -- tong so mon trong truong chu ko phai cua moi sinh vien
select count(distinct exam_management.subject_id) as tongsomon
from exam_management
-- 7. T?ng s? h?c b?ng c?a m?i khoa	
select faculty.name, count(student.scholarship) as tongsohocbong
from student inner join faculty
on student.faculty_id = faculty.id
group by faculty.name
-- 8. Cho bi?t h?c b?ng cao nh?t c?a m?i khoa
select faculty.name, max(student.scholarship) as hocbongcaonhat
from faculty full outer join student 
on faculty.id = student.faculty_id
group by faculty.name

-- 9. Cho bi?t t?ng s? sinh viên nam và t?ng s? sinh viên n? c?a m?i khoa
select faculty.name, student.gender, count(student.id) as soluongsv
from faculty full outer join student 
on faculty.id = student.faculty_id
group by faculty.name, student.gender

-- 10. Cho bi?t s? l??ng sinh viên theo t?ng ?? tu?i          ?? 
-- (YEAR(CURDATE()) - YEAR(birthday))  // mysql
select extract(year from student.birthday)  as dotuoi, count(student.id) as sosinhvien
from student
group by extract(year from student.birthday)


-- 11. Cho bi?t nh?ng n?i nào có ít nh?t 2 sinh viên ?ang theo h?c t?i tr??ng
select student.hometown, count(student.id) as sosinhvien
from student
group by student.hometown
having count(student.id) >1
-- 12. Cho bi?t nh?ng sinh viên thi l?i ít nh?t 2 l?n
select exam_management.student_id, student.name, count(exam_management.number_of_exam_taking) as solanthilai
from exam_management inner join student 
on exam_management.student_id = student.id
group by exam_management.student_id, student.name
having count(exam_management.number_of_exam_taking) > 1

-- 13. Cho bi?t nh?ng sinh viên nam có ?i?m trung bình l?n 1 trên 7.0 
select student.name, student.gender, exam_management.number_of_exam_taking, avg(exam_management.mark) as DTB
from exam_management inner join student 
on exam_management.student_id = student.id
where exam_management.number_of_exam_taking = 1 and student.gender = 'Nam'
group by student.name, student.gender, exam_management.number_of_exam_taking
having avg(exam_management.mark) > 7

-- 14. Cho bi?t danh sách các sinh viên r?t ít nh?t 2 môn ? l?n thi 1 (r?t môn là ?i?m thi c?a môn không quá 4 ?i?m)
-- tim ra cac sinh vien co diem thi cua 2 mon duoi 4, trong lan thi 1
select exam_management.student_id, count(exam_management.subject_id) as somonrot
from exam_management
where exam_management.number_of_exam_taking = 1 and exam_management.mark < 4
group by exam_management.student_id
having count(exam_management.subject_id) > 1
-- 15. Cho bi?t danh sách nh?ng khoa có nhi?u h?n 2 sinh viên nam
select student.faculty_id, count(student.id) as sosinhviennam
from student
where student.gender = 'Nam' 
group by student.faculty_id
having count(student.id) > 2

-- 16. Cho bi?t nh?ng khoa có 2 sinh viên ??t h?c b?ng t? 200000 ??n 300000

select student.faculty_id, count(student.id) as sosinhvien
from student
where student.scholarship between 200000 and 300000
group by student.faculty_id
having count(student.id) = 2

-- 17. Cho bi?t sinh viên nào có h?c b?ng cao nh?t
select student.name, student.scholarship as hocbongcaonhat
from student
where student.scholarship = (select MAX(student.scholarship) from student)

/********* C. DATE/TIME QUERY *********/

-- 1. Sinh viên có n?i sinh ? Hà N?i và sinh vào tháng 02      to_char(date, 'type')
select student.name, student.hometown, student.birthday
from student
where student.hometown = 'Hà Nội' and to_char(student.birthday, 'MM') =2

-- 2. Sinh viên có tu?i l?n h?n 20
-- oracle extract
select * from student 
where extract(year from SYSDATE) - extract(year from student.birthday)>20;

-- 3. Sinh viên sinh vào mùa xuân n?m 1990

select student.name, student.birthday
from student
where to_char(student.birthday, 'MM') < 4 and to_char(student.birthday, 'YYYY') = 1990

/********* D. JOIN QUERY *********/

-- 1. Danh sách các sinh viên c?a khoa ANH V?N và khoa V?T LÝ

select faculty.name as khoa , student.name as tensinhvien
from faculty inner join student on faculty.id = student.faculty_id
where faculty.id = 1 or faculty.id = 4


-- 2. Nh?ng sinh viên nam c?a khoa ANH V?N và khoa TIN H?C
select faculty.name, student.name, student.gender
from student join faculty on student.faculty_id  = faculty.id
where (student.faculty_id = 1 or student.faculty_id = 2 ) and student.gender = 'Nam'

-- 3. Cho bi?t sinh viên nào có điểm thi lần 1 môn cơ sở dữ liệu cao nh?t
select student.name, subject.name, exam_management.number_of_exam_taking as lanthi, exam_management.mark as diem
from exam_management, student, subject
where exam_management.student_id = student.id 
and exam_management.subject_id = subject.id 
and subject.name = 'Cơ sở dữ liệu'
and exam_management.number_of_exam_taking = 1
and exam_management.mark = (select max(exam_management.mark) 
                             from exam_management,subject where exam_management.subject_id = subject.id
                             and subject.name = 'Cơ sở dữ liệu' and exam_management.number_of_exam_taking = 1
                            )

-- 4. Cho bi?t sinh viên khoa anh v?n có tu?i l?n nh?t.

-- 5. Cho bi?t khoa nào có ?ông sinh viên nh?t        ??

--select faculty.id as khoa
--from falcuty, student
--where faculty.id = student.faculty_id
--group by faculty.id
--having count(faculty.name) >= all(
--                                     select count(student.id) 
--                                     from student 
--                                     group by faculty.id
--                                     )


select faculty.name, count(student.id) from faculty, student    
where faculty.id = student.faculty_id group by faculty.name 
having count(student.faculty_id)>= all(
                                        select count(student.id) 
                                        from student 
                                        group by student.faculty_id
                                        )

-- 6. Cho bi?t khoa nào có đông nữ nhất
select faculty.name, count(student.id) as sosvnu from faculty, student  
where faculty.id = student.faculty_id and student.gender = 'Nữ' group by faculty.name
having count(student.faculty_id) >= all(
                                         select count(student.id) 
                                         from student 
                                         where student.gender = 'Nữ' 
                                         group by student.faculty_id
                                         )


-- 7. Cho bi?t nh?ng sinh viên ??t ?i?m cao nh?t trong t?ng môn

-- 8. Cho bi?t nh?ng khoa không có sinh viên h?c

-- 9. Cho bi?t sinh viên ch?a thi môn c? s? d? li?u
select student.name
from student
where id not in (select exam_management.student_id 
                 from exam_management
                 where exam_management.subject_id = (select id from subject
                                                     where subject.name =  n'Cơ sở dữ liệu'
                                                     )
                 group by exam_management.student_id)
                
                
-- 10. Cho bi?t sinh viên nào không thi l?n 1 mà có d? thi l?n 2


