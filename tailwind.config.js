/** @type {import('tailwindcss').Config} */
export default {
    content: ['./index.html', './src/**/*.{elm, css}'],
    theme: {
        extend: {
            boxShadow: {
                heavy: '0 20px 24px -4px rgb(0 0 0 / 0.2), 0 8px 12px -6px rgb(0 0 0 / 0.2);',
            },
        },
    },
    plugins: [],
};
