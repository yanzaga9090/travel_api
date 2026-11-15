-- Админ хэрэглэгчдийн хүснэгт
CREATE TABLE IF NOT EXISTS admins (
    admin_id      SERIAL PRIMARY KEY,
    email         VARCHAR(255) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL   -- bcrypt hash (жинхэнэ нууц үг биш!)
);
