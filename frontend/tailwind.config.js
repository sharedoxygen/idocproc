/** @type {import('tailwindcss').Config} */
export default {
  content: [
    "./index.html",
    "./src/**/*.{js,ts,jsx,tsx}",
  ],
  theme: {
    extend: {
      colors: {
        primary: {
          light: '#42a5f5',
          main: '#1976d2',
          dark: '#1565c0',
        },
        secondary: {
          light: '#ff4081',
          main: '#dc004e',
          dark: '#c51162',
        },
      },
    },
  },
  plugins: [],
  // Enable MUI + Tailwind compatibility
  important: '#root',
} 