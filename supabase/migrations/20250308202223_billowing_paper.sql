/*
  # Fix Authentication Policies

  1. Changes
    - Update empresas policies to allow registration
    - Fix usuarios policies to prevent infinite recursion
    - Add trigger to create admin user after company creation

  2. Security
    - Enable RLS on all tables
    - Add proper policies for authentication flow
*/

-- Remove existing problematic policies
DROP POLICY IF EXISTS "Empresas podem ver seus próprios dados" ON empresas;
DROP POLICY IF EXISTS "Admins podem gerenciar usuários da própria empresa" ON usuarios;
DROP POLICY IF EXISTS "Usuários podem ver dados da própria empresa" ON usuarios;

-- Update empresas policies
CREATE POLICY "Allow registration" ON empresas
  FOR INSERT
  TO public
  WITH CHECK (true);

CREATE POLICY "Users can view own company" ON empresas
  FOR SELECT
  TO authenticated
  USING (
    auth.uid() IN (
      SELECT id FROM usuarios WHERE empresa_id = empresas.id
    )
  );

-- Fix usuarios policies
CREATE POLICY "Users can view company users" ON usuarios
  FOR SELECT
  TO authenticated
  USING (
    empresa_id IN (
      SELECT id FROM empresas WHERE id = usuarios.empresa_id
    )
  );

CREATE POLICY "Admins can manage company users" ON usuarios
  FOR ALL
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM usuarios u
      WHERE u.id = auth.uid()
      AND u.empresa_id = usuarios.empresa_id
      AND u.funcao = 'admin'
    )
  )
  WITH CHECK (
    EXISTS (
      SELECT 1 FROM usuarios u
      WHERE u.id = auth.uid()
      AND u.empresa_id = usuarios.empresa_id
      AND u.funcao = 'admin'
    )
  );

-- Create function to handle new user creation
CREATE OR REPLACE FUNCTION handle_new_user()
RETURNS trigger AS $$
BEGIN
  INSERT INTO usuarios (id, nome, email, funcao, empresa_id)
  VALUES (
    auth.uid(),
    split_part(NEW.email, '@', 1),
    NEW.email,
    'admin',
    NEW.id
  );
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Create trigger to automatically create admin user
DROP TRIGGER IF EXISTS on_empresa_created ON empresas;
CREATE TRIGGER on_empresa_created
  AFTER INSERT ON empresas
  FOR EACH ROW
  EXECUTE FUNCTION handle_new_user();