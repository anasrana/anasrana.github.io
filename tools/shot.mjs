// Headless Chrome screenshot and horizontal-overflow check (Node 22+, no dependencies).
// usage: node tools/shot.mjs URL WIDTH OUT.png [dark|light]
// Prints {sw, cw, h, wide}: sw > cw means horizontal scroll; wide lists overflowing elements.
import { spawn } from 'node:child_process';
const [url, width, out, scheme] = process.argv.slice(2);
const CH = '/Applications/Google Chrome.app/Contents/MacOS/Google Chrome';
const port = 9300 + Math.floor(Math.random()*500);
const p = spawn(CH, ['--headless=new','--disable-gpu','--hide-scrollbars',`--remote-debugging-port=${port}`,`--user-data-dir=${process.env.TMPDIR || '/tmp'}/shot-cdp-${port}`,'about:blank'], {stdio:'ignore'});
const sleep = ms => new Promise(r=>setTimeout(r,ms));
let tabs; for (let i=0;i<50;i++){ try{ tabs = await (await fetch(`http://127.0.0.1:${port}/json`)).json(); if(tabs.find(t=>t.type==='page')) break;}catch{} await sleep(200); }
const ws = new WebSocket(tabs.find(t=>t.type==='page').webSocketDebuggerUrl);
await new Promise(r=>ws.onopen=r);
let id=0; const pending={};
ws.onmessage = e => { const m=JSON.parse(e.data); if(m.id&&pending[m.id]){pending[m.id](m.result); delete pending[m.id];} };
const send=(method,params={})=>new Promise(r=>{const i=++id; pending[i]=r; ws.send(JSON.stringify({id:i,method,params}));});
const w=+width;
await send('Emulation.setDeviceMetricsOverride',{width:w,height:900,deviceScaleFactor:1,mobile:w<600});
if (scheme) await send('Emulation.setEmulatedMedia',{features:[{name:'prefers-color-scheme',value:scheme}]});
await send('Page.enable'); await send('Page.navigate',{url}); await sleep(4000);
const r = await send('Runtime.evaluate',{expression:`JSON.stringify({sw:document.documentElement.scrollWidth, cw:document.documentElement.clientWidth, h:document.documentElement.scrollHeight, wide:[...document.querySelectorAll('body *')].filter(e=>e.getBoundingClientRect().right>document.documentElement.clientWidth+1).slice(0,5).map(e=>e.tagName+'.'+e.className)})`,returnByValue:true});
console.log(r.result.value);
const h = JSON.parse(r.result.value).h;
await send('Emulation.setDeviceMetricsOverride',{width:w,height:Math.min(h,6000),deviceScaleFactor:1,mobile:w<600});
await sleep(500);
const s = await send('Page.captureScreenshot',{format:'png',captureBeyondViewport:true});
(await import('node:fs')).writeFileSync(out, Buffer.from(s.data,'base64'));
p.kill(); process.exit(0);
