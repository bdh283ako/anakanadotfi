const { chromium } = require('playwright');
const fs = require('fs');
const path = require('path');

const URL = process.env.TEST_URL || 'https://www.anakana.fi/';
const outDir = path.resolve(__dirname, 'artifacts', 'screenshots');
fs.mkdirSync(outDir, { recursive: true });

const viewports = [
  { name: 'mobile', width: 375, height: 812 },
  { name: 'tablet', width: 768, height: 1024 },
  { name: 'desktop', width: 1920, height: 1080 },
  { name: '4k', width: 3840, height: 2160 }
];

(async () => {
  const browser = await chromium.launch();
  const context = await browser.newContext();
  for (const vp of viewports) {
    const page = await context.newPage();
    await page.setViewportSize({ width: vp.width, height: vp.height });
    const resp = await page.goto(URL, { waitUntil: 'networkidle' });
    if (!resp || resp.status() >= 400) {
      console.error(`Failed to load ${URL}: ${resp ? resp.status() : 'no response'}`);
      process.exitCode = 2;
      continue;
    }
    const filename = path.join(outDir, `${vp.name}-${vp.width}x${vp.height}.png`);
    await page.screenshot({ path: filename, fullPage: true });
    console.log(`Wrote ${filename}`);
  }
  await browser.close();
})();
