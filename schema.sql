-- ===================================================
--  数据库表结构 for Novel Pro D1 Database (Idempotent Version)
--  与 functions/api/[[path]].js 中的查询保持一致
-- ===================================================

-- 用户表
CREATE TABLE IF NOT EXISTS Users (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    username TEXT NOT NULL UNIQUE,
    password_hash TEXT NOT NULL,
    role TEXT NOT NULL DEFAULT 'user',
    status TEXT NOT NULL DEFAULT 'active',
    created_at TEXT DEFAULT CURRENT_TIMESTAMP
);

-- 站点信息表（用于导航与阅读记录 JOIN）
CREATE TABLE IF NOT EXISTS Sites (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL,
    subdomain TEXT NOT NULL UNIQUE,
    type TEXT NOT NULL,
    author TEXT,
    description TEXT,
    created_at TEXT DEFAULT CURRENT_TIMESTAMP
);

-- 阅读记录表
CREATE TABLE IF NOT EXISTS ReadingRecords (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    user_id INTEGER NOT NULL,
    novel_id TEXT NOT NULL,
    chapter_id TEXT,
    position REAL DEFAULT 0,
    updated_at TEXT DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES Users(id) ON DELETE CASCADE,
    UNIQUE (user_id, novel_id)
);

-- 收藏片段表
CREATE TABLE IF NOT EXISTS Snippets (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    user_id INTEGER NOT NULL,
    novel_id TEXT NOT NULL,
    chapter_id TEXT NOT NULL,
    content TEXT NOT NULL,
    position REAL DEFAULT 0,
    created_at TEXT DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES Users(id) ON DELETE CASCADE
);

-- 公告/私信表
CREATE TABLE IF NOT EXISTS Announcements (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    user_id INTEGER NOT NULL,
    content TEXT NOT NULL,
    is_read INTEGER NOT NULL DEFAULT 0,
    created_at TEXT DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES Users(id) ON DELETE CASCADE
);
