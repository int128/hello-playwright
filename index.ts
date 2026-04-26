import { chromium, devices } from 'playwright';
import assert from 'node:assert';

// https://playwright.dev/docs/library
(async () => {
  // Setup
  const browser = await chromium.launch();
  const context = await browser.newContext(devices['Desktop Chrome']);
  const page = await context.newPage();
  console.log('Browser launched and page created');

  // The actual interesting bit
  await context.route('**.jpg', route => route.abort());
  await page.goto('https://example.com/');
  console.log('Page loaded', page.url());

  assert.strictEqual(await page.title(), 'Example Domain');

  // Teardown
  await context.close();
  await browser.close();
})();
