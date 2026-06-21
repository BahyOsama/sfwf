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
  try {
    browser = await puppeteer.launch({ headless: true, args: ['--no-sandbox', '--disable-gpu'] });
    console.log('SSR browser ready');
  } catch (err) {
    console.error('Failed to launch browser:', err.message);
    process.exit(1);
  }
})();

app.use(express.static(buildDir, { extensions: ['html'], index: false }));

app.get('*', async (req, res) => {
  const requestedPath = req.path === '/' ? '/index.html' : req.path;
  const staticFile = path.join(buildDir, requestedPath);

  if (fs.existsSync(staticFile) && staticFile.endsWith('.html')) {
    res.set('Cache-Control', 'public, max-age=3600');
    return res.sendFile(staticFile);
  }

  if (!browser) {
    return res.status(503).send('SSR browser not ready');
  }

  const page = await browser.newPage();
  try {
    await page.goto(`http://localhost:8080${req.path}`, { waitUntil: 'networkidle0' });
    const html = await page.content();
    res.set('Cache-Control', 'public, max-age=300');
    res.send(html);
  } catch (err) {
    res.status(500).send(`SSR Error: ${err.message}`);
  } finally {
    await page.close();
  }
});

app.listen(port, () => console.log(`SFWF SSR Server running on http://localhost:${port}`));

process.on('SIGINT', async () => {
  console.log('\nShutting down...');
  if (browser) await browser.close();
  process.exit(0);
});
