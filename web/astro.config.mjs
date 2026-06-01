import { defineConfig } from 'astro/config';

export default defineConfig({
  site: 'https://aprende-ensamblador.vercel.app',
  markdown: {
    syntaxHighlight: 'shiki',
    shikiConfig: {
      themes: {
        light: 'catppuccin-latte',
        dark: 'catppuccin-macchiato',
      },
      langAlias: {
        nasm: 'asm',
      },
      wrap: false,
    },
  },
});
