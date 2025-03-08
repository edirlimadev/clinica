import React, { useState } from 'react';
import { Check } from 'lucide-react';

const plans = [
  {
    name: 'Básico',
    price: {
      monthly: 159.90,
      annual: 1499.00
    },
    description: 'Ideal para profissionais autônomos',
    features: [
      'Agenda online',
      'Cadastro de pacientes',
      'Prontuário eletrônico básico',
      'Lembretes automáticos',
      'Suporte por email'
    ]
  },
  {
    name: 'Profissional',
    price: {
      monthly: 249.90,
      annual: 2499.00
    },
    description: 'Perfeito para clínicas em crescimento',
    features: [
      'Tudo do plano Básico',
      'Múltiplas agendas',
      'Prontuário completo',
      'Prescrição digital',
      'Faturamento convênios',
      'Suporte prioritário'
    ],
    isPopular: true
  },
  {
    name: 'Enterprise',
    price: {
      monthly: 449.90,
      annual: 4499.00
    },
    description: 'Para redes de clínicas',
    features: [
      'Tudo do plano Profissional',
      'Gestão multi-unidades',
      'Business Intelligence',
      'API personalizada',
      'Relatórios avançados',
      'Suporte 24/7'
    ]
  }
];

export const Pricing = () => {
  const [isAnnual, setIsAnnual] = useState(false);

  return (
    <section id="pricing" className="py-24 bg-white dark:bg-gray-900">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div className="text-center">
          <h2 className="text-3xl font-extrabold text-gray-900 dark:text-white sm:text-4xl">
            Escolha o Plano Ideal para sua Clínica
          </h2>
          <p className="mt-4 text-xl text-gray-500 dark:text-gray-400">
            Soluções flexíveis que se adaptam ao tamanho do seu consultório
          </p>
        </div>

        <div className="mt-12 flex justify-center">
          <div className="relative flex items-center">
            <span className="mr-3 text-sm font-medium text-gray-900 dark:text-white">Mensal</span>
            <button
              type="button"
              className={`relative inline-flex h-6 w-11 flex-shrink-0 cursor-pointer rounded-full border-2 border-transparent transition-colors duration-200 ease-in-out focus:outline-none ${
                isAnnual ? 'bg-blue-600' : 'bg-gray-200'
              }`}
              onClick={() => setIsAnnual(!isAnnual)}
            >
              <span
                className={`pointer-events-none inline-block h-5 w-5 transform rounded-full bg-white shadow ring-0 transition duration-200 ease-in-out ${
                  isAnnual ? 'translate-x-5' : 'translate-x-0'
                }`}
              />
            </button>
            <span className="ml-3 text-sm font-medium text-gray-900 dark:text-white">
              Anual <span className="text-green-500">(2 meses grátis)</span>
            </span>
          </div>
        </div>

        <div className="mt-12 space-y-4 sm:mt-16 sm:grid sm:grid-cols-3 sm:gap-6 sm:space-y-0">
          {plans.map((plan, index) => (
            <div
              key={plan.name}
              className={`rounded-lg shadow-lg divide-y divide-gray-200 dark:divide-gray-700 ${
                plan.isPopular
                  ? 'border-2 border-blue-500 dark:border-blue-400'
                  : 'border border-gray-200 dark:border-gray-700'
              }`}
            >
              <div className="p-6">
                {plan.isPopular && (
                  <span className="inline-flex px-4 py-1 rounded-full text-sm font-semibold tracking-wide uppercase bg-blue-100 text-blue-600 dark:bg-blue-800 dark:text-blue-200">
                    Mais Popular
                  </span>
                )}
                <h3 className="text-lg leading-6 font-medium text-gray-900 dark:text-white mt-4">
                  {plan.name}
                </h3>
                <p className="mt-4 text-sm text-gray-500 dark:text-gray-400">{plan.description}</p>
                <p className="mt-8">
                  <span className="text-4xl font-extrabold text-gray-900 dark:text-white">
                    R$ {isAnnual ? plan.price.annual.toFixed(2) : plan.price.monthly.toFixed(2)}
                  </span>
                  <span className="text-base font-medium text-gray-500 dark:text-gray-400">
                    {isAnnual ? '/ano' : '/mês'}
                  </span>
                </p>
                <button
                  className={`mt-8 block w-full bg-blue-600 dark:bg-blue-500 hover:bg-blue-700 dark:hover:bg-blue-600 text-white font-medium py-2 px-4 rounded-md text-sm text-center transition-colors duration-200`}
                >
                  Começar agora
                </button>
              </div>
              <div className="px-6 pt-6 pb-8">
                <h4 className="text-sm font-medium text-gray-900 dark:text-white tracking-wide uppercase">
                  O que está incluído
                </h4>
                <ul className="mt-6 space-y-4">
                  {plan.features.map((feature) => (
                    <li key={feature} className="flex space-x-3">
                      <Check className="flex-shrink-0 h-5 w-5 text-green-500" />
                      <span className="text-sm text-gray-500 dark:text-gray-400">{feature}</span>
                    </li>
                  ))}
                </ul>
              </div>
            </div>
          ))}
        </div>
      </div>
    </section>
  );
};