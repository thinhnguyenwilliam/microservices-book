-- ================================================================
-- V1__create_users_table.sql
-- Migration: Khởi tạo bảng users
-- Author: identity-service
-- ================================================================

CREATE TABLE IF NOT EXISTS users (
    id          VARCHAR(36)     NOT NULL,
    username    VARCHAR(255)    NOT NULL COLLATE utf8mb4_unicode_ci,
    password    VARCHAR(255)    NOT NULL,
    first_name  VARCHAR(100),
    last_name   VARCHAR(100),
    dob         DATE,
    created_at  DATETIME,
    updated_at  DATETIME,

    CONSTRAINT pk_users PRIMARY KEY (id),
    CONSTRAINT uq_users_username UNIQUE (username)
) ENGINE=InnoDB
  DEFAULT CHARSET=utf8mb4
  COLLATE=utf8mb4_unicode_ci;
