CREATE DATABASE toyshop;

-- 1. Tạo user mới
CREATE USER toyshop_user WITH PASSWORD 'your_strong_password';

-- 2. Cấp quyền cho user vừa tạo với database mới
GRANT ALL PRIVILEGES ON DATABASE toyshop TO toyshop_user;

-- 3. Full quyền muốn user này có quyền tạo bảng, cập nhật, xóa,...
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO toyshop_user;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO toyshop_user;