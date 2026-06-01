import { readFileSync, writeFileSync, readdirSync, statSync, existsSync, mkdirSync } from 'fs';
import { join, dirname } from 'path';
import { fileURLToPath } from 'url';

const __dirname = dirname(fileURLToPath(import.meta.url));

const docsDir = join(__dirname, '..', '..', 'docs');
const outDir  = join(__dirname, '..', 'src', 'content', 'lecciones');

if (!existsSync(outDir)) {
  mkdirSync(outDir, { recursive: true });
}

for (const file of readdirSync(docsDir).filter(f => f.endsWith('.md'))) {
  const filePath = join(docsDir, file);
  const raw = readFileSync(filePath, 'utf-8');

  const titleMatch = raw.match(/^#\s+(.+)$/m);
  const title = titleMatch ? titleMatch[1].trim() : file.replace('.md', '');
  const descMatch = raw.match(/\n\n(.+?)(?:\n|$)/s);
  const description = descMatch ? descMatch[1].trim().replace(/^[`#]*/, '').trim() : '';
  const slug = file.replace('.md', '');
  const pubDate = statSync(filePath).mtime.toISOString().split('T')[0];
  const isIndex = slug === 'index';

  const lines = [
    '---',
    `title: "${title.replace(/"/g, '\\"')}"`,
    `description: "${description.replace(/"/g, '\\"')}"`,
    `pubDate: ${pubDate}`,
    `slug: "${isIndex ? 'inicio' : slug}"`,
  ];
  if (isIndex) lines.push('draft: true');
  lines.push('---', '');

  writeFileSync(join(outDir, `${slug}.md`), lines.join('\n') + raw);
}
