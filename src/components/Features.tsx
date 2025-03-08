import React from 'react';
import { Calendar, BarChart as ChartBar, Users, Shield, Clock, FileText } from 'lucide-react';

const features = [
  {
    icon: Calendar,
    title: 'Smart Scheduling',
    description: 'AI-powered appointment management that reduces no-shows by 60%'
  },
  {
    icon: ChartBar,
    title: 'Analytics Dashboard',
    description: 'Real-time insights into your clinic\'s performance and patient trends'
  },
  {
    icon: Users,
    title: 'Patient Portal',
    description: 'Secure patient access to records, appointments, and communications'
  },
  {
    icon: Shield,
    title: 'HIPAA Compliant',
    description: 'Enterprise-grade security ensuring patient data protection'
  },
  {
    icon: Clock,
    title: 'Automated Billing',
    description: 'Streamlined insurance claims and payment processing'
  },
  {
    icon: FileText,
    title: 'Digital Records',
    description: 'Comprehensive EMR system with easy document management'
  }
];

export const Features = () => {
  return (
    <div id="features" className="py-24 bg-gray-50 dark:bg-gray-800">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div className="text-center">
          <h2 className="text-3xl font-extrabold text-gray-900 dark:text-white sm:text-4xl">
            Everything you need to run your clinic
          </h2>
          <p className="mt-4 max-w-2xl mx-auto text-xl text-gray-500 dark:text-gray-400">
            Powerful features designed specifically for medical practices
          </p>
        </div>

        <div className="mt-20">
          <div className="grid grid-cols-1 gap-8 sm:grid-cols-2 lg:grid-cols-3">
            {features.map((feature, index) => {
              const Icon = feature.icon;
              return (
                <div
                  key={index}
                  className="relative group bg-white dark:bg-gray-900 p-6 focus-within:ring-2 focus-within:ring-inset focus-within:ring-blue-500 rounded-lg shadow-lg transition-all duration-300 hover:transform hover:-translate-y-1 hover:shadow-xl"
                >
                  <div>
                    <span className="rounded-lg inline-flex p-3 bg-blue-50 dark:bg-blue-900 text-blue-700 dark:text-blue-300 ring-4 ring-white dark:ring-gray-900">
                      <Icon className="h-6 w-6" />
                    </span>
                  </div>
                  <div className="mt-8">
                    <h3 className="text-lg font-medium text-gray-900 dark:text-white">
                      {feature.title}
                    </h3>
                    <p className="mt-2 text-base text-gray-500 dark:text-gray-400">
                      {feature.description}
                    </p>
                  </div>
                </div>
              );
            })}
          </div>
        </div>
      </div>
    </div>
  );
};