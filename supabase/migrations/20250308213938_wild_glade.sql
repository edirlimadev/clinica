/*
  # Disable empresas table security temporarily

  1. Security Changes
    - Disable RLS on empresas table
    - Drop all existing policies
*/

-- Disable RLS
ALTER TABLE empresas DISABLE ROW LEVEL SECURITY;

-- Drop existing policies
DROP POLICY IF EXISTS "Allow public registration" ON empresas;
DROP POLICY IF EXISTS "Users can view own company" ON empresas;
DROP POLICY IF EXISTS "Users can update own company" ON empresas;
DROP POLICY IF EXISTS "Admins can manage all companies" ON empresas;
DROP POLICY IF EXISTS "Admins can delete companies" ON empresas;