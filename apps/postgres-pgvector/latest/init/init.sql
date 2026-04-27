-- Auto-create pgvector extension for all databases
-- This runs automatically on first container initialization
DO $
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_extension WHERE extname = 'vector') THEN
        CREATE EXTENSION IF NOT EXISTS vector;
    END IF;
END
$;
