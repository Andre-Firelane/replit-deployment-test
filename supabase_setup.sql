-- ============================================
-- Supabase Setup: Tasks Table
-- Dieses SQL im Supabase SQL Editor ausführen
-- ============================================

CREATE TABLE tasks (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  title TEXT NOT NULL,
  description TEXT,
  status TEXT DEFAULT 'open' CHECK (status IN ('open', 'done')),
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Row Level Security aktivieren (empfohlen)
ALTER TABLE tasks ENABLE ROW LEVEL SECURITY;

-- Policy: Alle Operationen erlauben (für den Test-Workflow)
-- In Produktion durch Auth-basierte Policies ersetzen!
CREATE POLICY "Allow all for now" ON tasks
  FOR ALL USING (true) WITH CHECK (true);
