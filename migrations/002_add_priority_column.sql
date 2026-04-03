-- ============================================
-- Migration 002: Add priority column to tasks
-- ============================================

ALTER TABLE tasks
ADD COLUMN priority TEXT DEFAULT 'medium'
CHECK (priority IN ('low', 'medium', 'high'));
