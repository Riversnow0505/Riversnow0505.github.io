import { readFileSync, writeFileSync } from 'fs';
import { join, dirname } from 'path';
import { fileURLToPath } from 'url';

const __filename = fileURLToPath(import.meta.url);
const __dirname = dirname(__filename);
const filePath = join(__dirname, 'index.html');

let content = readFileSync(filePath, 'utf8');

content = updateContent(content);

writeFileSync(filePath, content, 'utf8');
console.log('Done. File updated successfully.');

function updateContent(content) {
  // 1. Insert new card as the first element in card-grid
  const newCard = `
<!-- ========== CARD 1: Snow的学业冒险 ========== -->
    <a href="https://riversnow0505.github.io/gradequest/" target="_blank" rel="noopener noreferrer"
       class="project-card card-accent-green" data-category="教育" data-tags="家庭 教育 成绩 游戏化 追踪 积分 三年级" data-title="Snow的学业冒险 · 游戏化成绩追踪器">
      <div class="card-header">
        <div class="card-icon-wrap icon-green">&#127947;</div>
        <span class="card-date">2026-07-02</span>
      </div>
      <div class="card-title">Snow的学业冒险</div>
      <div class="card-desc">游戏化成绩追踪器——记录每次考试、赚取积分、解锁成就、兑换奖励。20级XP成长系统、积分商店（家长可定制）、成就墙、家长仪表盘（折线图+成绩管理）。单HTML文件，localStorage存储，纯本地使用。</div>
      <div class="tags-row">
        <span class="tag tag-green">家庭教育</span>
        <span class="tag tag-green">成绩追踪</span>
        <span class="tag tag-green">游戏化</span>
      </div>
      <div class="card-footer">
        <span class="card-link-text">打开网站<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M7 17L17 7"/><polyline points="7 7 17 7 17 17"/></svg></span>
        <span class="card-status-dot status-live" title="在线"></span>
      </div>
    </a>
`;

  content = content.replace('<div class="card-grid" id="cardGrid">\n', `$&${newCard}\n`);

  // 2. Renumber existing cards from N→N+1 (highest first to avoid conflicts)
  for (let i = 28; i >= 1; i--) {
    const pattern = `<!-- ========== CARD ${i}:`;
    const replacement = `<!-- ========== CARD ${i + 1}:`;
    content = content.replace(new RegExp(pattern, 'g'), replacement);
  }

  // 3. Update totalCount
  content = content.replace(/id="totalCount">28</, 'id="totalCount">29<');

  // 4. Update visibleCount
  content = content.replace('显示 28 个', '显示 29 个');

  // 5. Update filter counts
  content = content.replace(/全部 <span class="count">28<\/span>/, '全部 <span class="count">29</span>');
  content = content.replace(/家庭教育 <span class="count">8<\/span>/, '家庭教育 <span class="count">9</span>');

  // 6. Add CSS animation rule for :nth-child(29)
  const css28 = '.project-card:nth-child(28) { animation-delay:1.62s; }';
  const css29 = '.project-card:nth-child(29) { animation-delay:1.68s; }';
  content = content.replace(css28, `${css28}\n${css29}`);

  // 7. Update lastUpdate date
  content = content.replace('最后更新：2026-07-01', '最后更新：2026-07-02');

  // 8. Clean up excessive blank lines before ADD NEW CARD section
  content = content.replace(/(\n){4,}(\s*<!-- ========== ADD NEW CARD)/, '$1$2');

  return content;
}
