import { defineConfig } from 'vite';
import elmPlugin from 'vite-plugin-elm';

export default defineConfig({
    base: "./",
    plugins: [
        elmPlugin({
            compilationCommand:
                'node_modules/elm-optimize-level-2/bin/elm-optimize-level-2',
        }),
    ],
});
