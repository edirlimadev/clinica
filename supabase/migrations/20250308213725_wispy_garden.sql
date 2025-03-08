/*
  # Setup empresas table security

  1. Security Changes
    - Enable RLS on empresas table
    - Add policy for public registration
    - Add policy for authenticated users to view own company
    - Add policy for authenticated users to update own company
    - Add policy for admins to manage all companies

  2. Changes
    - Ensures new companies can be created during registration
    - Restricts company access to authorized users only
    - Allows company updates by authorized users
*/

-- Enable RLS
ALTER TABLE empresas ENABLE ROW LEVEL SECURITY;

-- Drop existing policies to avoid conflicts
DROP POLICY IF EXISTS "Allow public registration" ON empresas;
DROP POLICY IF EXISTS "Users can view own company" ON empresas;
DROP POLICY IF EXISTS "Users can update own company" ON empresas;
DROP POLICY IF EXISTS "Admins can manage all companies" ON empresas;

-- Allow public registration (needed for signup flow)
CREATE POLICY "Allow public registration"
ON empresas
FOR INSERT
TO public
WITH CHECK (true);

-- Allow users to view their own company
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
  OR 
  EXISTS (
    SELECT 1 
    FROM usuarios 
    WHERE usuarios.id = auth.uid() 
    AND usuarios.funcao = 'admin'
  )
);

-- Allow users to update their own company
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
  OR 
  EXISTS (
    SELECT 1 
    FROM usuarios 
    WHERE usuarios.id = auth.uid() 
    AND usuarios.funcao = 'admin'
  )
)
WITH CHECK (
  id IN (
    SELECT empresa_id 
    FROM usuarios 
    WHERE usuarios.id = auth.uid()
  )
  OR 
  EXISTS (
    SELECT 1 
    FROM usuarios 
    WHERE usuarios.id = auth.uid() 
    AND usuarios.funcao = 'admin'
  )
);

-- Allow admins to delete companies
CREATE POLICY "Admins can delete companies"
ON empresas
FOR DELETE
TO authenticated
USING (
  EXISTS (
    SELECT 1 
    FROM usuarios 
    WHERE usuarios.id = auth.uid() 
    AND usuarios.funcao = 'admin'
  )
);