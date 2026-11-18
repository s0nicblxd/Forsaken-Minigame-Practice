const {chromium}=require('playwright'),fs=require('fs'),path=require('path'),assert=require('node:assert/strict');
(async()=>{
 const root=path.resolve(__dirname,'..'),browser=await chromium.launch({executablePath:'/usr/bin/chromium',args:['--no-sandbox']}),page=await browser.newPage({viewport:{width:1440,height:1000}}),errors=[],missing=[];
 page.on('pageerror',e=>errors.push(e.message));
 await page.route('https://**/*',r=>r.abort());
 await page.route('http://fmp.test/**',r=>{
   const pathname=decodeURIComponent(new URL(r.request().url()).pathname),file=path.join(root,pathname==='/'?'index.html':pathname);
   if(!file.startsWith(root+path.sep)){return r.fulfill({status:403});}
   if(!fs.existsSync(file)){missing.push(pathname);return r.fulfill({status:404});}
   if(pathname==='/')return r.fulfill({contentType:'text/html',body:fs.readFileSync(file,'utf8').replace('})();\n</script>','window.shopQA={showScreen,shopCatalog,renderShopPage};})();\n</script>')});
   return r.fulfill({path:file,contentType:/\/assets\/(shop|update-log)\//.test(pathname)?(/json$/.test(file)?'application/json':'image/png'):undefined});
 });
 await page.goto('http://fmp.test/');await page.evaluate(()=>{document.getElementById('loadingScreen').style.display='none';shopQA.showScreen('menu');});
 await page.locator('[data-lobby="shop"]').click();await page.waitForTimeout(600);
 assert.equal(await page.locator('.shopTab').count(),3);assert.equal(await page.locator('.shopTab[aria-selected=true]').textContent(),'Practice');
 for(const [category,groups] of [['cosmetics',['Minigames','Profile']],['audio',['Music','Sounds']],['practice',['Puzzles','Challenges']]]){
  await page.locator('#shop-tab-'+category).click();await page.waitForTimeout(550);assert.deepEqual(await page.locator('.shopSubtab').allTextContents(),groups);
  await page.locator('.shopSubtab').last().click();assert.equal(await page.locator('.shopSubtab[aria-pressed=true]').textContent(),groups[1]);
 }
 await page.locator('.shopSearch input').fill('nothing');assert.equal(await page.locator('#shopPage h3').textContent(),'No results found');
 await page.locator('.shopSearch input').fill('');await page.locator('.shopUnowned').click();assert.equal(await page.locator('#shopPage h3').textContent(),'No unowned items');await page.locator('.shopUnowned').click();
 await page.locator('#shop-tab-practice').focus();await page.keyboard.press('ArrowRight');await page.waitForTimeout(550);assert.equal(await page.locator('.shopTab[aria-selected=true]').textContent(),'Cosmetics');
 for(const id of ['audio','practice','cosmetics','audio'])await page.locator('#shop-tab-'+id).click();await page.waitForTimeout(600);assert.equal(await page.locator('#shopPage').count(),1);assert.equal(await page.locator('.shopPageOutgoing').count(),0);
 await page.evaluate(()=>{shopQA.shopCatalog.push({id:'qa-only',name:'Test music',description:'Test-only preview fixture',category:'audio',group:'sounds',price:100,image:'assets/shop/131461582354827.png',owned:false,isNew:true},{id:'qa-owned',name:'Owned music',description:'Owned fixture',category:'audio',group:'sounds',price:0,image:'assets/shop/131461582354827.png',owned:true});shopQA.renderShopPage();});
 assert.equal(await page.locator('.shopCard').count(),2);await page.locator('.shopUnowned').click();assert.equal(await page.locator('.shopCard').count(),1);
 await page.locator('.shopCard').click();assert(await page.locator('.shopPreview').isVisible());assert(await page.locator('.shopBuy').isDisabled());await page.keyboard.press('Escape');assert.equal(await page.locator('.shopPreview').count(),0);assert(await page.locator('#lobbyDialog').evaluate(e=>e.open));
 await page.locator('.shopSearch input').fill('OWNED');assert.equal(await page.locator('.shopCard').count(),0);await page.locator('.shopUnowned').click();assert.equal(await page.locator('.shopCard').count(),1);await page.locator('.shopSearch input').fill('');
 await page.evaluate(()=>{shopQA.shopCatalog.length=0;shopQA.renderShopPage();document.querySelectorAll('.achievementNotification').forEach(e=>e.remove());});
 await page.screenshot({path:'/workspace/exports/fmp-shop-desktop.png'});
 await page.locator('[data-lobby="settings"]').click();await page.waitForTimeout(600);assert.equal(await page.locator('.shopChrome').count(),0);assert(await page.locator('.lobbyMusicSetting').first().isVisible());
 await page.locator('[data-lobby="shop"]').click();await page.waitForTimeout(600);await page.locator('.shopClose').click();await page.waitForTimeout(350);assert.equal(await page.locator('#lobbyDialog').evaluate(e=>e.open),false);
 for(const viewport of [{width:390,height:844},{width:844,height:390}]){
  await page.setViewportSize(viewport);await page.locator('[data-lobby="shop"]').click();await page.waitForTimeout(600);
  const box=await page.locator('#lobbyDialog').boundingBox();assert(box.x>=0&&box.y>=0&&box.x+box.width<=viewport.width+1&&box.y+box.height<=viewport.height+1);
  assert(await page.locator('.shopSearch input').isVisible());await page.screenshot({path:`/workspace/exports/fmp-shop-${viewport.width}.png`});
  await page.keyboard.press('Escape');await page.waitForTimeout(350);
 }
 assert.deepEqual(errors,[]);assert.deepEqual(missing,[]);console.log('PASS: categories, subtabs, search, unowned filter, keyboard navigation, rapid switching, close, settings handoff, portrait/landscape bounds; no JS errors or missing assets.');await browser.close();
})().catch(e=>{console.error(e);process.exit(1)});
