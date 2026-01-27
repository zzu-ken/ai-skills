const puppeteer = require('puppeteer-core');
const yargs = require('yargs/yargs');
const { hideBin } = require('yargs/helpers');
const path = require('path');
const fs = require('fs');

// Helper to find Chrome/Edge on macOS
function findBrowser() {
    const paths = [
        '/Applications/Google Chrome.app/Contents/MacOS/Google Chrome',
        '/Applications/Google Chrome Canary.app/Contents/MacOS/Google Chrome Canary',
        '/Applications/Microsoft Edge.app/Contents/MacOS/Microsoft Edge',
        '/Applications/Brave Browser.app/Contents/MacOS/Brave Browser',
        '/usr/bin/google-chrome' // Linux fallback just in case
    ];
    for (const p of paths) {
        if (fs.existsSync(p)) return p;
    }
    return null;
}

const argv = yargs(hideBin(process.argv))
    .option('text', { type: 'string', describe: 'Main title text', demandOption: true })
    .option('subtext', { type: 'string', describe: 'Subtitle text' })
    .option('footer', { type: 'string', describe: 'Footer text (e.g. brand name)' })
    .option('colors', { type: 'string', describe: 'Comma separated colors (e.g. "#ff0000,#0000ff")' })
    .option('gradient', { type: 'string', describe: 'Full css gradient string (overrides colors)' })
    .option('direction', { type: 'string', default: '135deg', describe: 'Gradient direction' })
    .option('width', { type: 'number', default: 1080, describe: 'Image width' })
    .option('height', { type: 'number', default: 1440, describe: 'Image height (1440 for 3:4, 1920 for 9:16)' })
    .option('output', { type: 'string', default: 'cover.png', describe: 'Output filename' })
    .option('dark', { type: 'boolean', default: false, describe: 'Use dark card theme' })
    .argv;

(async () => {
    const executablePath = findBrowser();
    if (!executablePath) {
        console.error('Error: Could not find Google Chrome or Edge. Please install one of them.');
        process.exit(1);
    }

    console.log(`Using browser: ${executablePath}`);

    const browser = await puppeteer.launch({
        executablePath,
        args: ['--no-sandbox', '--disable-setuid-sandbox'],
        headless: true
    });

    const page = await browser.newPage();
    
    // Set viewport
    await page.setViewport({
        width: argv.width,
        height: argv.height,
        deviceScaleFactor: 2 // High DPI for better quality
    });

    // Load local template
    const templatePath = path.join(__dirname, 'template.html');
    await page.goto(`file://${templatePath}`);

    // Prepare config object
    const config = {
        text: argv.text,
        subtext: argv.subtext,
        footer: argv.footer,
        colors: argv.colors ? argv.colors.split(',') : ['#a18cd1', '#fbc2eb'], // Default pastel gradient
        gradient: argv.gradient,
        direction: argv.direction,
        darkMode: argv.dark
    };

    // Inject config into page
    await page.evaluate((cfg) => {
        window.updateContent(cfg);
    }, config);

    // Wait a tiny bit for fonts or rendering adjustments
    await new Promise(r => setTimeout(r, 100));

    // Save screenshot
    const outputPath = path.resolve(process.cwd(), argv.output);
    await page.screenshot({ path: outputPath });

    console.log(`✨ Cover image generated: ${outputPath}`);

    await browser.close();
})();
