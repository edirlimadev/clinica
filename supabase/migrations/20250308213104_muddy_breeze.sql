/*
  # Update empresas table RLS policies

  1. Security Changes
    - Enable RLS on empresas table
    - Add policy for public registration
    - Add policy for authenticated users to view own company
    - Add policy for authenticated users to update own company
*/

-- Enable RLS
ALTER TABLE empresas ENABLE ROW LEVEL SECURITY;

-- Drop existing policies if any
DROP POLICY IF EXISTS "Allow registration" ON empresas;
DROP POLICY IF EXISTS "Users can view own company" ON empresas;

-- Create new policies
CREATE POLICY "Allow public registration"
ON empresas
FOR INSERT
TO public
WITH CHECK (true);

CREATE POLICY "Users can view own company"
ON empresas
FOR SELECT
TO authenticated
USING (
  id IN (
    SELECT empresa_id 
    FROM usuarios 
    WHERE usuarios.id = auth.uid()
  )
);

CREATE POLICY "Users can update own company"
ON empresas
FOR UPDATE
TO authenticated
USING (
  id IN (
    SELECT empresa_id 
    FROM usuarios 
    WHERE usuarios.id = auth.uid()
  )
)
WITH CHECK (
  id IN (
    SELECT empresa_id 
    FROM usuarios 
    WHERE usuarios.id = auth.uid()
  )
);