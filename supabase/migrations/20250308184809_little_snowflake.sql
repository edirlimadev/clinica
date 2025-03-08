/*
  # Patient Related Tables

  1. New Tables
    - pacientes (patients)
    - prontuarios (medical records)
    
  2. Security
    - Enable RLS
    - Add policies for data access based on empresa_id
    - Ensure medical staff can access patient records
*/

CREATE TABLE IF NOT EXISTS pacientes (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    empresa_id UUID NOT NULL REFERENCES empresas(id),
    nome VARCHAR(255) NOT NULL,
    email VARCHAR(255),
    telefone VARCHAR(20),
    cpf VARCHAR(14),
    data_nascimento DATE,
    genero VARCHAR(20),
    endereco JSONB,
    profissao VARCHAR(100),
    contato_emergencia JSONB,
    plano_saude JSONB,
    observacoes TEXT,
    imagem_perfil TEXT,
    status VARCHAR(20) NOT NULL DEFAULT 'ativo',
    criado_por UUID REFERENCES usuarios(id),
    atualizado_por UUID REFERENCES usuarios(id),
    criado_em TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    atualizado_em TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    CONSTRAINT pacientes_cpf_empresa_unique UNIQUE (cpf, empresa_id),
    CONSTRAINT pacientes_genero_check CHECK (genero IN ('masculino', 'feminino', 'outro')),
    CONSTRAINT pacientes_status_check CHECK (status IN ('ativo', 'inativo', 'arquivado'))
);

CREATE TABLE IF NOT EXISTS prontuarios (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    paciente_id UUID NOT NULL REFERENCES pacientes(id) ON DELETE CASCADE,
    empresa_id UUID NOT NULL REFERENCES empresas(id),
    historico_medico JSONB,
    alergias TEXT[],
    medicamentos TEXT[],
    cirurgias TEXT[],
    antecedentes_familiares TEXT,
    habitos_vida TEXT,
    criado_por UUID REFERENCES usuarios(id),
    atualizado_por UUID REFERENCES usuarios(id),
    criado_em TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    atualizado_em TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    CONSTRAINT prontuarios_paciente_empresa_unique UNIQUE (paciente_id, empresa_id)
);

-- Enable RLS
ALTER TABLE pacientes ENABLE ROW LEVEL SECURITY;
ALTER TABLE prontuarios ENABLE ROW LEVEL SECURITY;

-- Pacientes policies
CREATE POLICY "Usuários podem ver pacientes da própria empresa" ON pacientes
    FOR SELECT USING (
        auth.uid() IN (
            SELECT id FROM usuarios WHERE empresa_id = pacientes.empresa_id
        )
    );

CREATE POLICY "Staff pode gerenciar pacientes da própria empresa" ON pacientes
    FOR ALL USING (
        auth.uid() IN (
            SELECT id FROM usuarios 
            WHERE empresa_id = pacientes.empresa_id 
            AND funcao IN ('admin', 'medico', 'recepcionista')
        )
    );

-- Prontuarios policies
CREATE POLICY "Médicos e admins podem ver prontuários" ON prontuarios
    FOR SELECT USING (
        auth.uid() IN (
            SELECT id FROM usuarios 
            WHERE empresa_id = prontuarios.empresa_id 
            AND funcao IN ('admin', 'medico')
        )
    );

CREATE POLICY "Médicos podem gerenciar prontuários" ON prontuarios
    FOR ALL USING (
        auth.uid() IN (
            SELECT id FROM usuarios 
            WHERE empresa_id = prontuarios.empresa_id 
            AND funcao = 'medico'
        )
    );

-- Create indexes
CREATE INDEX IF NOT EXISTS idx_pacientes_empresa_id ON pacientes(empresa_id);
CREATE INDEX IF NOT EXISTS idx_pacientes_nome ON pacientes(nome);
CREATE INDEX IF NOT EXISTS idx_pacientes_cpf ON pacientes(cpf);
CREATE INDEX IF NOT EXISTS idx_prontuarios_paciente_id ON prontuarios(paciente_id);
CREATE INDEX IF NOT EXISTS idx_prontuarios_empresa_id ON prontuarios(empresa_id);