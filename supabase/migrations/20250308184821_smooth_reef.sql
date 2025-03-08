/*
  # Appointment and Consultation Tables

  1. New Tables
    - agendamentos (appointments)
    - consultas (consultations)
    - procedimentos (procedures)
    
  2. Security
    - Enable RLS
    - Add policies for scheduling and consultation management
    - Ensure proper access control for medical staff
*/

CREATE TABLE IF NOT EXISTS agendamentos (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    empresa_id UUID NOT NULL REFERENCES empresas(id),
    paciente_id UUID REFERENCES pacientes(id),
    profissional_id UUID REFERENCES usuarios(id),
    data_hora_inicio TIMESTAMPTZ NOT NULL,
    data_hora_fim TIMESTAMPTZ NOT NULL,
    tipo VARCHAR(20) NOT NULL,
    status VARCHAR(20) NOT NULL DEFAULT 'agendado',
    observacoes TEXT,
    valor DECIMAL(10, 2),
    forma_pagamento VARCHAR(50),
    enviado_lembrete BOOLEAN NOT NULL DEFAULT FALSE,
    origem VARCHAR(20) NOT NULL DEFAULT 'sistema',
    criado_por UUID REFERENCES usuarios(id),
    atualizado_por UUID REFERENCES usuarios(id),
    criado_em TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    atualizado_em TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    CONSTRAINT agendamentos_tipo_check CHECK (tipo IN ('consulta', 'retorno', 'exame', 'procedimento')),
    CONSTRAINT agendamentos_status_check CHECK (status IN ('agendado', 'confirmado', 'cancelado', 'finalizado', 'no_show')),
    CONSTRAINT agendamentos_origem_check CHECK (origem IN ('sistema', 'online', 'telefone', 'presencial'))
);

CREATE TABLE IF NOT EXISTS consultas (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    agendamento_id UUID REFERENCES agendamentos(id),
    empresa_id UUID NOT NULL REFERENCES empresas(id),
    paciente_id UUID NOT NULL REFERENCES pacientes(id),
    profissional_id UUID NOT NULL REFERENCES usuarios(id),
    data_hora TIMESTAMPTZ NOT NULL,
    sintomas TEXT,
    diagnostico TEXT,
    tratamento TEXT,
    prescricoes TEXT,
    evolucao TEXT,
    observacoes TEXT,
    imagens TEXT[],
    documentos JSONB[],
    status VARCHAR(20) NOT NULL DEFAULT 'realizada',
    criado_por UUID REFERENCES usuarios(id),
    atualizado_por UUID REFERENCES usuarios(id),
    criado_em TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    atualizado_em TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    CONSTRAINT consultas_status_check CHECK (status IN ('realizada', 'nao_realizada', 'remarcada'))
);

CREATE TABLE IF NOT EXISTS procedimentos (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    empresa_id UUID NOT NULL REFERENCES empresas(id),
    nome VARCHAR(255) NOT NULL,
    descricao TEXT,
    duracao_minutos INTEGER NOT NULL,
    valor DECIMAL(10, 2) NOT NULL,
    categoria VARCHAR(100),
    ativo BOOLEAN NOT NULL DEFAULT TRUE,
    criado_por UUID REFERENCES usuarios(id),
    atualizado_por UUID REFERENCES usuarios(id),
    criado_em TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    atualizado_em TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Enable RLS
ALTER TABLE agendamentos ENABLE ROW LEVEL SECURITY;
ALTER TABLE consultas ENABLE ROW LEVEL SECURITY;
ALTER TABLE procedimentos ENABLE ROW LEVEL SECURITY;

-- Agendamentos policies
CREATE POLICY "Usuários podem ver agendamentos da própria empresa" ON agendamentos
    FOR SELECT USING (
        auth.uid() IN (
            SELECT id FROM usuarios WHERE empresa_id = agendamentos.empresa_id
        )
    );

CREATE POLICY "Staff pode gerenciar agendamentos" ON agendamentos
    FOR ALL USING (
        auth.uid() IN (
            SELECT id FROM usuarios 
            WHERE empresa_id = agendamentos.empresa_id 
            AND funcao IN ('admin', 'medico', 'recepcionista')
        )
    );

-- Consultas policies
CREATE POLICY "Médicos podem ver consultas da própria empresa" ON consultas
    FOR SELECT USING (
        auth.uid() IN (
            SELECT id FROM usuarios 
            WHERE empresa_id = consultas.empresa_id 
            AND funcao IN ('admin', 'medico')
        )
    );

CREATE POLICY "Médicos podem gerenciar suas consultas" ON consultas
    FOR ALL USING (
        auth.uid() IN (
            SELECT id FROM usuarios 
            WHERE empresa_id = consultas.empresa_id 
            AND funcao = 'medico'
            AND (id = consultas.profissional_id OR funcao = 'admin')
        )
    );

-- Procedimentos policies
CREATE POLICY "Usuários podem ver procedimentos da própria empresa" ON procedimentos
    FOR SELECT USING (
        auth.uid() IN (
            SELECT id FROM usuarios WHERE empresa_id = procedimentos.empresa_id
        )
    );

CREATE POLICY "Admins podem gerenciar procedimentos" ON procedimentos
    FOR ALL USING (
        auth.uid() IN (
            SELECT id FROM usuarios 
            WHERE empresa_id = procedimentos.empresa_id 
            AND funcao = 'admin'
        )
    );

-- Create indexes
CREATE INDEX IF NOT EXISTS idx_agendamentos_empresa_id ON agendamentos(empresa_id);
CREATE INDEX IF NOT EXISTS idx_agendamentos_paciente_id ON agendamentos(paciente_id);
CREATE INDEX IF NOT EXISTS idx_agendamentos_profissional_id ON agendamentos(profissional_id);
CREATE INDEX IF NOT EXISTS idx_agendamentos_data_hora_inicio ON agendamentos(data_hora_inicio);
CREATE INDEX IF NOT EXISTS idx_consultas_empresa_id ON consultas(empresa_id);
CREATE INDEX IF NOT EXISTS idx_consultas_paciente_id ON consultas(paciente_id);
CREATE INDEX IF NOT EXISTS idx_consultas_profissional_id ON consultas(profissional_id);
CREATE INDEX IF NOT EXISTS idx_consultas_data_hora ON consultas(data_hora);
CREATE INDEX IF NOT EXISTS idx_procedimentos_empresa_id ON procedimentos(empresa_id);