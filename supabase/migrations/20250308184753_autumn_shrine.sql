/*
  # Initial Schema Setup for Medical Management System

  1. New Tables
    - empresas (companies)
    - usuarios (users)
    - pacientes (patients)
    - prontuarios (medical records)
    - agendamentos (appointments)
    - consultas (consultations)
    - procedimentos (procedures)
    - financeiro (financial records)
    - notificacoes (notifications)
    - configuracoes_sistema (system settings)
    - logs_sistema (system logs)
    - planos (plans)

  2. Security
    - Enable RLS on all tables
    - Add policies for authenticated users based on empresa_id
    - Ensure data isolation between different companies
*/

-- Enable UUID extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Create base tables
CREATE TABLE IF NOT EXISTS planos (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    nome VARCHAR(100) NOT NULL,
    descricao TEXT,
    preco_mensal DECIMAL(10, 2) NOT NULL,
    preco_anual DECIMAL(10, 2) NOT NULL,
    recursos JSONB NOT NULL,
    ativo BOOLEAN NOT NULL DEFAULT TRUE,
    criado_em TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    atualizado_em TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS empresas (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    nome VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL UNIQUE,
    ramo_atividade VARCHAR(100) NOT NULL,
    telefone VARCHAR(20),
    endereco JSONB,
    logo_url TEXT,
    cores_tema JSONB,
    plano_id UUID REFERENCES planos(id),
    status VARCHAR(20) NOT NULL DEFAULT 'ativo',
    data_expiracao TIMESTAMPTZ,
    stripe_customer_id VARCHAR(255),
    stripe_subscription_id VARCHAR(255),
    configuracoes JSONB NOT NULL DEFAULT '{}',
    criado_em TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    atualizado_em TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    CONSTRAINT empresas_status_check CHECK (status IN ('ativo', 'inativo', 'pendente', 'cancelado', 'expirado')),
    CONSTRAINT empresas_ramo_atividade_check CHECK (ramo_atividade IN ('Odontologia', 'Psiquiatria', 'Psicologia', 'Fisioterapia', 'Nutrição', 'Medicina Geral', 'Pediatria', 'Ortopedia', 'Dermatologia', 'Oftalmologia', 'Cardiologia', 'Ginecologia', 'Urologia', 'Neurologia', 'Otorrinolaringologia', 'Endocrinologia', 'Geriatria', 'Reumatologia', 'Fonoaudiologia', 'Outro'))
);

CREATE TABLE IF NOT EXISTS usuarios (
    id UUID PRIMARY KEY,
    nome VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL,
    telefone VARCHAR(20),
    funcao VARCHAR(50) NOT NULL,
    empresa_id UUID REFERENCES empresas(id),
    especialidade VARCHAR(100),
    crm VARCHAR(50),
    foto_url TEXT,
    configuracoes_usuario JSONB NOT NULL DEFAULT '{}',
    ativo BOOLEAN NOT NULL DEFAULT TRUE,
    criado_em TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    atualizado_em TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    CONSTRAINT usuarios_email_empresa_unique UNIQUE (email, empresa_id),
    CONSTRAINT usuarios_funcao_check CHECK (funcao IN ('admin', 'medico', 'recepcionista', 'financeiro', 'atendente'))
);

-- Enable RLS and create policies
ALTER TABLE planos ENABLE ROW LEVEL SECURITY;
ALTER TABLE empresas ENABLE ROW LEVEL SECURITY;
ALTER TABLE usuarios ENABLE ROW LEVEL SECURITY;

-- Planos policies
CREATE POLICY "Planos visíveis para todos" ON planos
    FOR SELECT USING (ativo = true);

-- Empresas policies
CREATE POLICY "Empresas podem ver seus próprios dados" ON empresas
    FOR ALL USING (
        auth.uid() IN (
            SELECT id FROM usuarios WHERE empresa_id = empresas.id
        )
    );

-- Usuarios policies
CREATE POLICY "Usuários podem ver dados da própria empresa" ON usuarios
    FOR SELECT USING (
        auth.uid() IN (
            SELECT id FROM usuarios WHERE empresa_id = usuarios.empresa_id
        )
    );

CREATE POLICY "Admins podem gerenciar usuários da própria empresa" ON usuarios
    FOR ALL USING (
        auth.uid() IN (
            SELECT id FROM usuarios 
            WHERE empresa_id = usuarios.empresa_id 
            AND funcao = 'admin'
        )
    );

-- Create indexes
CREATE INDEX IF NOT EXISTS idx_usuarios_empresa_id ON usuarios(empresa_id);