Playwright visual tests

Run locally:

```bash
cd tools/visual-test
npm install
npx playwright install --with-deps
npm run screenshot
```

Outputs are written to `tools/visual-test/artifacts/screenshots`.
