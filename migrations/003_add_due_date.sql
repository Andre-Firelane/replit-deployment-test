-- ============================================
-- Migration 003: Add due_date column to tasks
-- ============================================

ALTER TABLE tasks
ADD COLUMN IF NOT EXISTS due_date DATE;
