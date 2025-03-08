/*
  # Financial and System Configuration Tables

  1. New Tables
    - financeiro (financial records)
    - configuracoes_sistema (system settings)
    - logs_sistema (system logs)
    - notificacoes (notifications)
    
  2. Security
    - Enable RLS
    - Add policies for financial access control
    - Ensure proper logging and notification access
*/

CREATE TABLE IF NOT EXISTS financeiro (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    empresa_id UUID NOT NULL REFERENCES empresas(id),
    paciente_id UUID REFERENCES pacientes(id),
    consulta_id UUID REFERENCES consultas(id),
    tipo VARCHAR(20) NOT NULL,
    categoria VARCHAR(100) NOT NULL,
    descricao VARCHAR(255) NOT NULL,
    valor DECIMAL(10, 2) NOT NULL,
    data_vencimento DATE,
    data_pagamento DATE,
    status VARCHAR(20) NOT NULL DEFAULT 'pendente',
    forma_pagamento VARCHAR(50),
    comprovante_url TEXT,
    observacoes TEXT,
    criado_por UUID REFERENCES usuarios(id),
    atualizado_por UUID REFERENCES usuarios(id),
    criado_em TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    atualizado_em TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    CONSTRAINT financeiro_tipo_check CHECK (tipo IN ('receita', 'despesa')),
    CONSTRAINT financeiro_status_check CHECK (status IN ('pendente', 'pago', 'cancelado'))
);

CREATE TABLE IF NOT EXISTS configuracoes_sistema (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    empresa_id UUID NOT NULL REFERENCES empresas(id) UNIQUE,
    horario_funcionamento JSONB,
    dias_funcionamento TEXT[],
    intervalo_agendamento INTEGER NOT NULL DEFAULT 30,
    enviar_lembretes BOOLEAN NOT NULL DEFAULT TRUE,
    antecedencia_lembrete INTEGER NOT NULL DEFAULT 24,
    permitir_agendamento_online BOOLEAN NOT NULL DEFAULT FALSE,
    configuracoes_email JSONB,
    termos_uso TEXT,
    politica_privacidade TEXT,
    criado_por UUID REFERENCES usuarios(id),
    atualizado_por UUID REFERENCES usuarios(id),
    criado_em TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    atualizado_em TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS notificacoes (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    empresa_id UUID NOT NULL REFERENCES empresas(id),
    usuario_id UUID REFERENCES usuarios(id),
    titulo VARCHAR(255) NOT NULL,
    mensagem TEXT NOT NULL,
    tipo VARCHAR(20) NOT NULL,
    lida BOOLEAN NOT NULL DEFAULT FALSE,
    data_leitura TIMESTAMPTZ,
    link TEXT,
    criado_em TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    CONSTRAINT notificacoes_tipo_check CHECK (tipo IN ('sistema', 'agendamento', 'financeiro', 'paciente'))
);

CREATE TABLE IF NOT EXISTS logs_sistema (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    empresa_id UUID REFERENCES empresas(id),
    usuario_id UUID REFERENCES usuarios(id),
    acao VARCHAR(255) NOT NULL,
    tabela_afetada VARCHAR(50),
    registro_id UUID,
    detalhes JSONB,
    ip VARCHAR(50),
    user_agent TEXT,
    criado_em TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Enable RLS
ALTER TABLE financeiro ENABLE ROW LEVEL SECURITY;
ALTER TABLE configuracoes_sistema ENABLE ROW LEVEL SECURITY;
ALTER TABLE notificacoes ENABLE ROW LEVEL SECURITY;
ALTER TABLE logs_sistema ENABLE ROW LEVEL SECURITY;

-- Financeiro policies
CREATE POLICY "Usuários financeiros podem ver registros da empresa" ON financeiro
    FOR SELECT USING (
        auth.uid() IN (
            SELECT id FROM usuarios 
            WHERE empresa_id = financeiro.empresa_id 
            AND funcao IN ('admin', 'financeiro')
        )
    );

CREATE POLICY "Usuários financeiros podem gerenciar registros" ON financeiro
    FOR ALL USING (
        auth.uid() IN (
            SELECT id FROM usuarios 
            WHERE empresa_id = financeiro.empresa_id 
            AND funcao IN ('admin', 'financeiro')
        )
    );

-- Configurações policies
CREATE POLICY "Admins podem ver configurações da empresa" ON configuracoes_sistema
    FOR SELECT USING (
        auth.uid() IN (
            SELECT id FROM usuarios 
            WHERE empresa_id = configuracoes_sistema.empresa_id 
            AND funcao = 'admin'
        )
    );

CREATE POLICY "Admins podem gerenciar configurações" ON configuracoes_sistema
    FOR ALL USING (
        auth.uid() IN (
            SELECT id FROM usuarios 
            WHERE empresa_id = configuracoes_sistema.empresa_id 
            AND funcao = 'admin'
        )
    );

-- Notificações policies
CREATE POLICY "Usuários podem ver suas notificações" ON notificacoes
    FOR SELECT USING (
        auth.uid() = usuario_id OR
        auth.uid() IN (
            SELECT id FROM usuarios 
            WHERE empresa_id = notificacoes.empresa_id 
            AND funcao = 'admin'
        )
    );

-- Logs policies
CREATE POLICY "Admins podem ver logs da empresa" ON logs_sistema
    FOR SELECT USING (
        auth.uid() IN (
            SELECT id FROM usuarios 
            WHERE empresa_id = logs_sistema.empresa_id 
            AND funcao = 'admin'
        )
    );

-- Create indexes
CREATE INDEX IF NOT EXISTS idx_financeiro_empresa_id ON financeiro(empresa_id);
CREATE INDEX IF NOT EXISTS idx_financeiro_paciente_id ON financeiro(paciente_id);
CREATE INDEX IF NOT EXISTS idx_financeiro_data_vencimento ON financeiro(data_vencimento);
CREATE INDEX IF NOT EXISTS idx_notificacoes_empresa_id ON notificacoes(empresa_id);
CREATE INDEX IF NOT EXISTS idx_notificacoes_usuario_id ON notificacoes(usuario_id);
CREATE INDEX IF NOT EXISTS idx_logs_sistema_empresa_id ON logs_sistema(empresa_id);
CREATE INDEX IF NOT EXISTS idx_logs_sistema_usuario_id ON logs_sistema(usuario_id);
CREATE INDEX IF NOT EXISTS idx_logs_sistema_criado_em ON logs_sistema(criado_em);