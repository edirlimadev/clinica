import React from 'react';
import { Link } from 'react-router-dom';
import { Stethoscope, BarChart, Users } from 'lucide-react';

export const Hero = () => {
  return (
    <div className="relative overflow-hidden bg-white dark:bg-gray-900">
      <nav className="fixed top-0 left-0 right-0 z-50 bg-white/80 backdrop-blur-md dark:bg-gray-900/80 border-b border-gray-200 dark:border-gray-800">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="flex justify-between h-16 items-center">
            <div className="flex items-center">
              <Stethoscope className="h-8 w-8 text-blue-600" />
              <span className="ml-2 text-xl font-bold">MediManage</span>
            </div>
            <div className="hidden md:flex items-center space-x-8">
              <Link to="/" className="text-gray-600 hover:text-gray-900 dark:text-gray-300 dark:hover:text-white">Início</Link>
              <Link to="/" className="text-gray-600 hover:text-gray-900 dark:text-gray-300 dark:hover:text-white">Planos</Link>
              <Link to="/login" className="text-gray-600 hover:text-gray-900 dark:text-gray-300 dark:hover:text-white">Entrar</Link>
              <Link to="/register" className="bg-blue-600 text-white px-4 py-2 rounded-lg hover:bg-blue-700 transition-colors">
                Cadastrar
              </Link>
            </div>
          </div>
        </div>
      </nav>

      <div className="pt-24 pb-16 sm:pt-32 sm:pb-24">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="lg:grid lg:grid-cols-12 lg:gap-8">
            <div className="sm:text-center md:max-w-2xl md:mx-auto lg:col-span-6 lg:text-left">
              <h1 className="text-4xl tracking-tight font-extrabold text-gray-900 dark:text-white sm:text-5xl md:text-6xl">
                <span className="block">Gestão Inteligentes</span>
                <span className="block text-blue-600">para sua Clínica</span>
              </h1>
              <p className="mt-3 text-base text-gray-500 dark:text-gray-400 sm:mt-5 sm:text-xl lg:text-lg xl:text-xl">
                Simplifique a gestão do seu consultório com nossa plataforma completa. Agendamentos, prontuários eletrônicos e faturamento em um só lugar.
              </p>
              <div className="mt-8 sm:max-w-lg sm:mx-auto sm:text-center lg:text-left">
                <div className="space-y-4 sm:space-y-0 sm:flex sm:space-x-4">
                  <Link to="/" className="w-full sm:w-auto flex items-center justify-center px-8 py-3 border border-transparent text-base font-medium rounded-lg text-white bg-blue-600 hover:bg-blue-700 md:text-lg md:px-10">
                    Ver Planos
                  </Link>
                  <Link to="/register" className="w-full sm:w-auto flex items-center justify-center px-8 py-3 border border-gray-300 dark:border-gray-700 text-base font-medium rounded-lg text-gray-700 dark:text-gray-200 bg-white dark:bg-gray-800 hover:bg-gray-50 dark:hover:bg-gray-700 md:text-lg md:px-10">
                    Cadastre-se Agora
                  </Link>
                </div>
              </div>
              <div className="mt-8 border-t border-gray-200 dark:border-gray-800 pt-8">
                <div className="flex justify-between items-center">
                  <div className="flex items-center">
                    <Users className="h-6 w-6 text-blue-600" />
                    <p className="ml-2 text-sm text-gray-500 dark:text-gray-400">
                      <span className="font-semibold text-gray-900 dark:text-white">5,000+</span> profissionais
                    </p>
                  </div>
                  <div className="flex items-center">
                    <BarChart className="h-6 w-6 text-blue-600" />
                    <p className="ml-2 text-sm text-gray-500 dark:text-gray-400">
                      <span className="font-semibold text-gray-900 dark:text-white">1M+</span> consultas
                    </p>
                  </div>
                </div>
              </div>
            </div>
            <div className="mt-12 relative sm:max-w-lg sm:mx-auto lg:mt-0 lg:max-w-none lg:mx-0 lg:col-span-6 lg:flex lg:items-center">
              <div className="relative mx-auto w-full rounded-lg shadow-lg lg:max-w-md">
                <img
                  className="w-full rounded-lg"
                  src="https://images.unsplash.com/photo-1576091160550-2173dba999ef?auto=format&fit=crop&w=1200&q=80"
                  alt="Profissional de saúde usando tablet"
                />
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
};