$filePath = "D:\BaiduNetdiskWorkspace\私人文件\N 女儿相关\女儿-workbuddy\portal-site\index.html"
$content = [System.IO.File]::ReadAllText($filePath, [System.Text.Encoding]::UTF8)

# 1. Insert new card as the first element in card-grid
$newCard = @'

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

'@

$gridOpen = '<div class="card-grid" id="cardGrid">'
$insertAfter = $gridOpen + "`r`n"
$newContent = $gridOpen + "`r`n" + $newCard
$content = $content.Replace($insertAfter, $newContent)

# 2. Renumber existing cards from N→N+1 (working from highest to lowest to avoid conflicts)
for ($i = 28; $i -ge 1; $i--) {
    $oldNum = $i
    $newNum = $i + 1
    $content = [regex]::Replace($content, "<!-- ========== CARD $oldNum:", "<!-- ========== CARD $newNum:")
}

# 3. Update totalCount 28→29
$content = $content -replace '"id="totalCount">28<', '"id="totalCount">29<'

# 4. Update visibleCount
$content = $content -replace '显示 28 个', '显示 29 个'

# 5. Update filter "全部" count: 28→29
$content = $content -replace '全部 <span class="count">28</span>', '全部 <span class="count">29</span>'

# 6. Update filter "家庭教育" count: 8→9
$content = $content -replace '家庭教育 <span class="count">8</span>', '家庭教育 <span class="count">9</span>'

# 7. Add CSS animation rule for :nth-child(29) with delay 1.68s
$cssOld = '.project-card:nth-child(28) { animation-delay:1.62s; }'
$cssNew = ".project-card:nth-child(28) { animation-delay:1.62s; }`r`n.project-card:nth-child(29) { animation-delay:1.68s; }"
$content = $content.Replace($cssOld, $cssNew)

# 8. Update lastUpdate date
$content = $content -replace '最后更新：2026-07-01', '最后更新：2026-07-02'

# 9. Clean up excessive blank lines before ADD NEW CARD section
$content = [regex]::Replace($content, "(\r\n){4,}(\s*<!-- ========== ADD NEW CARD)", "`r`n`r`n`$2")

# Save with UTF-8
[System.IO.File]::WriteAllText($filePath, $content, [System.Text.Encoding]::UTF8)
Write-Output "Done. File updated successfully."
