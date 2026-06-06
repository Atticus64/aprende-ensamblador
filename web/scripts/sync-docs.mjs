import { readFileSync, writeFileSync, readdirSync, statSync, existsSync, mkdirSync } from 'fs';
import { join, dirname } from 'path';
import { fileURLToPath } from 'url';

const __dirname = dirname(fileURLToPath(import.meta.url));

const docsDir = join(__dirname, '..', '..', 'docs');
const outDir  = join(__dirname, '..', 'src', 'content', 'lecciones');

if (!existsSync(outDir)) {
  mkdirSync(outDir, { recursive: true });
}

function syncFile(filePath, type) {
  const raw = readFileSync(filePath, 'utf-8');
  const fileName = filePath.split(/[\\/]/).pop();

  const titleMatch = raw.match(/^#\s+(.+)$/m);
  const title = titleMatch ? titleMatch[1].trim() : fileName.replace('.md', '');
  const descMatch = raw.match(/\n\n(.+?)(?:\n|$)/s);
  const description = descMatch ? descMatch[1].trim().replace(/^[`#]*/, '').trim() : '';
  const slug = fileName.replace('.md', '');
  const pubDate = statSync(filePath).mtime.toISOString().split('T')[0];

  const lines = [
    '---',
    `title: "${title.replace(/"/g, '\\"')}"`,
    `description: "${description.replace(/"/g, '\\"')}"`,
    `pubDate: ${pubDate}`,
    `slug: "${slug}"`,
    `type: "${type}"`,
  ];
  lines.push('---', '');

  writeFileSync(join(outDir, `${slug}.md`), lines.join('\n') + raw);
}

// Process root docs (only index.md)
for (const file of readdirSync(docsDir).filter(f => f.endsWith('.md'))) {
  if (file === 'index.md') {
    const filePath = join(docsDir, file);
    const raw = readFileSync(filePath, 'utf-8');
    const pubDate = statSync(filePath).mtime.toISOString().split('T')[0];

    const lines = [
      '---',
      `title: "c-asm-learn"`,
      `description: "Proyecto plantilla para aprender ensamblador NASM x86-64 junto con C"`,
      `pubDate: ${pubDate}`,
      `slug: "inicio"`,
      `type: "leccion"`,
      'draft: true',
      '---',
      '',
    ];
    writeFileSync(join(outDir, 'index.md'), lines.join('\n') + raw);
  }
}

// Process subdirectories
const subDirs = {
  lecciones: 'leccion',
  tareas: 'tarea',
};

for (const [dir, type] of Object.entries(subDirs)) {
  const dirPath = join(docsDir, dir);
  if (!existsSync(dirPath)) continue;

  for (const file of readdirSync(dirPath).filter(f => f.endsWith('.md'))) {
    syncFile(join(dirPath, file), type);
  }
}
