const express = require('express');
const puppeteer = require('puppeteer');
const fs = require('fs');
const path = require('path');
const compression = require('compression');

const app = express();
app.use(compression());
const port = process.argv.find(arg => arg.startsWith('--port='))?.split('=')[1] || 3000;
const buildDir = path.join(process.cwd(), 'build/web');

let browser;
(async () => {
  browser = await puppeteer.launch({ headless: true, args: ['--no-sandbox'] });
  console.log('✅ SSR browser ready');
})();

app.use(express.static(buildDir, { extensions: ['html'], index: false }));

app.get('*', async (req, res) => {
  const requestedPath = req.path === '/' ? '/index.html' : req.path;
  const staticFile = path.join(buildDir, requestedPath);
  if (fs.existsSync(staticFile) && staticFile.endsWith('.html')) {
    return res.sendFile(staticFile);
  }
  const page = await browser.newPage();
  try {
    await page.goto(`http://localhost:8080${req.path}`, { waitUntil: 'networkidle0' });
    const html = await page.content();
    res.set('Cache-Control', 'public, max-age=300');
    res.send(html);
  } catch (err) {
    res.status(500).send('SSR Error');
  } finally {
    await page.close();
  }
});

app.listen(port, () => console.log(`🚀 SFWF SSR Server running on http://localhost:${port}`));