import React from 'react';
import { Hero } from '../components/Hero';
import { Features } from '../components/Features';
import { Pricing } from '../components/Pricing';

export const Home = () => {
  return (
    <div className="min-h-screen bg-white dark:bg-gray-900">
      <Hero />
      <Features />
      <Pricing />
    </div>
  );
};