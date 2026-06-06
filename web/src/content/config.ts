import { defineCollection, z } from 'astro:content';

const lecciones = defineCollection({
  type: 'content',
  schema: z.object({
    title: z.string(),
    description: z.string().optional(),
    pubDate: z.date(),
    draft: z.boolean().optional(),
    slug: z.string().optional(),
    type: z.enum(['leccion', 'tarea']).default('leccion'),
  }),
});

export const collections = { lecciones };
