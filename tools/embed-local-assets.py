from pathlib import Path
import re,base64,mimetypes
from PIL import Image
root=Path(__file__).resolve().parents[1];p=root/'index.html';s=p.read_text();count=0
for asset in sorted(set(re.findall(r'(?<![A-Za-z0-9_/])assets/[A-Za-z0-9_./-]+',s)),key=len,reverse=True):
 f=root/asset
 if not f.is_file():
  if f.is_dir():continue
  raise Exception('Missing asset: '+asset)
 mime=mimetypes.guess_type(f.name)[0]
 if not mime:
  try:mime=Image.MIME[Image.open(f).format]
  except:mime='application/octet-stream'
 data='data:'+mime+';base64,'+base64.b64encode(f.read_bytes()).decode();s=s.replace(asset,data);count+=1
p.write_text(s);print('Embedded',count,'local assets; HTML',p.stat().st_size,'bytes')
