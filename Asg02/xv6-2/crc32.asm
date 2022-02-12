
_crc32:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
	return crc ^ ~0U;
}

int
main(int argc, char *argv[])
{
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	pushl  -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	57                   	push   %edi
   e:	56                   	push   %esi
   f:	53                   	push   %ebx
  10:	51                   	push   %ecx
  11:	83 ec 28             	sub    $0x28,%esp
  int fd;
  struct stat st;
  if(argc != 2){
  14:	83 39 02             	cmpl   $0x2,(%ecx)
{
  17:	8b 71 04             	mov    0x4(%ecx),%esi
  if(argc != 2){
  1a:	74 1a                	je     36 <main+0x36>
	printf(1, "ERROR: crc32 does not have the correct amount of arguments\n");
  1c:	50                   	push   %eax
  1d:	50                   	push   %eax
  1e:	68 1c 0a 00 00       	push   $0xa1c
  23:	6a 01                	push   $0x1
  25:	e8 46 06 00 00       	call   670 <printf>
    exit2(-1);
  2a:	c7 04 24 ff ff ff ff 	movl   $0xffffffff,(%esp)
  31:	e8 63 05 00 00       	call   599 <exit2>
  }

  if((fd = open(argv[1], 0)) < 0){
  36:	50                   	push   %eax
  37:	50                   	push   %eax
  38:	6a 00                	push   $0x0
  3a:	ff 76 04             	pushl  0x4(%esi)
  3d:	e8 ef 04 00 00       	call   531 <open>
  42:	83 c4 10             	add    $0x10,%esp
  45:	89 c7                	mov    %eax,%edi
  47:	85 c0                	test   %eax,%eax
  49:	0f 88 16 01 00 00    	js     165 <main+0x165>
    printf(2, "crc32: cannot open %s\n", argv[1]);
	exit2(-1);
  } 

  if(fstat(fd, &st) < 0){
  4f:	50                   	push   %eax
  50:	50                   	push   %eax
  51:	8d 45 d4             	lea    -0x2c(%ebp),%eax
  54:	50                   	push   %eax
  55:	57                   	push   %edi
  56:	e8 ee 04 00 00       	call   549 <fstat>
  5b:	83 c4 10             	add    $0x10,%esp
  5e:	85 c0                	test   %eax,%eax
  60:	0f 88 db 00 00 00    	js     141 <main+0x141>
    printf(2, "crc32: cannot stat %s\n", argv[1]);
    close(fd);
    exit2(-1);
  }
  
  char* buffer = malloc(st.size);
  66:	83 ec 0c             	sub    $0xc,%esp
  69:	ff 75 e4             	pushl  -0x1c(%ebp)
  6c:	e8 5f 08 00 00       	call   8d0 <malloc>
  if(read(fd, buffer, st.size) < 0)
  71:	83 c4 0c             	add    $0xc,%esp
  74:	ff 75 e4             	pushl  -0x1c(%ebp)
  77:	50                   	push   %eax
  char* buffer = malloc(st.size);
  78:	89 c3                	mov    %eax,%ebx
  if(read(fd, buffer, st.size) < 0)
  7a:	57                   	push   %edi
  7b:	e8 89 04 00 00       	call   509 <read>
  80:	83 c4 10             	add    $0x10,%esp
  83:	85 c0                	test   %eax,%eax
  85:	0f 88 f6 00 00 00    	js     181 <main+0x181>
	  printf(1, "ERROR: Could not read file %s\n", argv[1]);
	  close(fd);
	  exit2(-1);
  }

  printf(1, "%x\n", crc32(0, buffer, st.size));
  8b:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
	while (size--)
  8e:	85 c9                	test   %ecx,%ecx
  90:	0f 84 f8 00 00 00    	je     18e <main+0x18e>
  96:	01 d9                	add    %ebx,%ecx
	crc = crc ^ ~0U;
  98:	83 c8 ff             	or     $0xffffffff,%eax
  9b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  9f:	90                   	nop
	crc = crc32_tab[(crc ^ *p++) & 0xFF] ^ (crc >> 8);
  a0:	83 c3 01             	add    $0x1,%ebx
  a3:	0f b6 53 ff          	movzbl -0x1(%ebx),%edx
  a7:	31 c2                	xor    %eax,%edx
  a9:	c1 e8 08             	shr    $0x8,%eax
  ac:	0f b6 d2             	movzbl %dl,%edx
  af:	33 04 95 80 0a 00 00 	xor    0xa80(,%edx,4),%eax
	while (size--)
  b6:	39 cb                	cmp    %ecx,%ebx
  b8:	75 e6                	jne    a0 <main+0xa0>
	return crc ^ ~0U;
  ba:	f7 d0                	not    %eax
  printf(1, "%x\n", crc32(0, buffer, st.size));
  bc:	51                   	push   %ecx
  bd:	50                   	push   %eax
  be:	68 15 0a 00 00       	push   $0xa15
  c3:	6a 01                	push   $0x1
  c5:	e8 a6 05 00 00       	call   670 <printf>
  ca:	83 c4 10             	add    $0x10,%esp
	crc = crc ^ ~0U;
  cd:	83 c8 ff             	or     $0xffffffff,%eax
	p = buf;
  d0:	ba e0 09 00 00       	mov    $0x9e0,%edx
  d5:	8d 76 00             	lea    0x0(%esi),%esi
	crc = crc32_tab[(crc ^ *p++) & 0xFF] ^ (crc >> 8);
  d8:	83 c2 01             	add    $0x1,%edx
  db:	0f b6 4a ff          	movzbl -0x1(%edx),%ecx
  df:	31 c1                	xor    %eax,%ecx
  e1:	c1 e8 08             	shr    $0x8,%eax
  e4:	0f b6 c9             	movzbl %cl,%ecx
  e7:	33 04 8d 80 0a 00 00 	xor    0xa80(,%ecx,4),%eax
	while (size--)
  ee:	81 fa e6 09 00 00    	cmp    $0x9e6,%edx
  f4:	75 e2                	jne    d8 <main+0xd8>
	return crc ^ ~0U;
  f6:	f7 d0                	not    %eax
  const int len = 6;

  unsigned long crc_whole = crc32(0, whole_buf, len);

  unsigned long crc_byte_by_byte = 0;
  for (int i = 0; i < len; ++i)
  f8:	31 d2                	xor    %edx,%edx
  unsigned long crc_byte_by_byte = 0;
  fa:	31 db                	xor    %ebx,%ebx
	crc = crc32_tab[(crc ^ *p++) & 0xFF] ^ (crc >> 8);
  fc:	0f b6 8a e0 09 00 00 	movzbl 0x9e0(%edx),%ecx
	crc = crc ^ ~0U;
 103:	f7 d3                	not    %ebx
  for (int i = 0; i < len; ++i)
 105:	83 c2 01             	add    $0x1,%edx
	crc = crc32_tab[(crc ^ *p++) & 0xFF] ^ (crc >> 8);
 108:	31 d9                	xor    %ebx,%ecx
 10a:	c1 eb 08             	shr    $0x8,%ebx
 10d:	0f b6 c9             	movzbl %cl,%ecx
 110:	33 1c 8d 80 0a 00 00 	xor    0xa80(,%ecx,4),%ebx
	return crc ^ ~0U;
 117:	f7 d3                	not    %ebx
  for (int i = 0; i < len; ++i)
 119:	83 fa 06             	cmp    $0x6,%edx
 11c:	75 de                	jne    fc <main+0xfc>
    crc_byte_by_byte = crc32(crc_byte_by_byte, &whole_buf[i], 1);

  printf(1, "%x\n", crc_whole);
 11e:	52                   	push   %edx
 11f:	50                   	push   %eax
 120:	68 15 0a 00 00       	push   $0xa15
 125:	6a 01                	push   $0x1
 127:	e8 44 05 00 00       	call   670 <printf>
  printf(1, "%x\n", crc_byte_by_byte);
 12c:	83 c4 0c             	add    $0xc,%esp
 12f:	53                   	push   %ebx
 130:	68 15 0a 00 00       	push   $0xa15
 135:	6a 01                	push   $0x1
 137:	e8 34 05 00 00       	call   670 <printf>

  exit();
 13c:	e8 b0 03 00 00       	call   4f1 <exit>
    printf(2, "crc32: cannot stat %s\n", argv[1]);
 141:	50                   	push   %eax
 142:	ff 76 04             	pushl  0x4(%esi)
 145:	68 fe 09 00 00       	push   $0x9fe
 14a:	6a 02                	push   $0x2
	  printf(1, "ERROR: Could not read file %s\n", argv[1]);
 14c:	e8 1f 05 00 00       	call   670 <printf>
	  close(fd);
 151:	89 3c 24             	mov    %edi,(%esp)
 154:	e8 c0 03 00 00       	call   519 <close>
	  exit2(-1);
 159:	c7 04 24 ff ff ff ff 	movl   $0xffffffff,(%esp)
 160:	e8 34 04 00 00       	call   599 <exit2>
    printf(2, "crc32: cannot open %s\n", argv[1]);
 165:	50                   	push   %eax
 166:	ff 76 04             	pushl  0x4(%esi)
 169:	68 e7 09 00 00       	push   $0x9e7
 16e:	6a 02                	push   $0x2
 170:	e8 fb 04 00 00       	call   670 <printf>
	exit2(-1);
 175:	c7 04 24 ff ff ff ff 	movl   $0xffffffff,(%esp)
 17c:	e8 18 04 00 00       	call   599 <exit2>
	  printf(1, "ERROR: Could not read file %s\n", argv[1]);
 181:	53                   	push   %ebx
 182:	ff 76 04             	pushl  0x4(%esi)
 185:	68 58 0a 00 00       	push   $0xa58
 18a:	6a 01                	push   $0x1
 18c:	eb be                	jmp    14c <main+0x14c>
	crc = crc ^ ~0U;
 18e:	83 c8 ff             	or     $0xffffffff,%eax
 191:	e9 24 ff ff ff       	jmp    ba <main+0xba>
 196:	66 90                	xchg   %ax,%ax
 198:	66 90                	xchg   %ax,%ax
 19a:	66 90                	xchg   %ax,%ax
 19c:	66 90                	xchg   %ax,%ax
 19e:	66 90                	xchg   %ax,%ax

000001a0 <fmtname>:
{
 1a0:	55                   	push   %ebp
 1a1:	89 e5                	mov    %esp,%ebp
 1a3:	56                   	push   %esi
 1a4:	53                   	push   %ebx
 1a5:	8b 75 08             	mov    0x8(%ebp),%esi
  for(p=path+strlen(path); p >= path && *p != '/'; p--)
 1a8:	83 ec 0c             	sub    $0xc,%esp
 1ab:	56                   	push   %esi
 1ac:	e8 6f 01 00 00       	call   320 <strlen>
 1b1:	83 c4 10             	add    $0x10,%esp
 1b4:	01 f0                	add    %esi,%eax
 1b6:	89 c3                	mov    %eax,%ebx
 1b8:	0f 82 82 00 00 00    	jb     240 <fmtname+0xa0>
 1be:	80 38 2f             	cmpb   $0x2f,(%eax)
 1c1:	75 0d                	jne    1d0 <fmtname+0x30>
 1c3:	eb 7b                	jmp    240 <fmtname+0xa0>
 1c5:	8d 76 00             	lea    0x0(%esi),%esi
 1c8:	80 7b ff 2f          	cmpb   $0x2f,-0x1(%ebx)
 1cc:	74 09                	je     1d7 <fmtname+0x37>
 1ce:	89 c3                	mov    %eax,%ebx
 1d0:	8d 43 ff             	lea    -0x1(%ebx),%eax
 1d3:	39 c6                	cmp    %eax,%esi
 1d5:	76 f1                	jbe    1c8 <fmtname+0x28>
  if(strlen(p) >= DIRSIZ)
 1d7:	83 ec 0c             	sub    $0xc,%esp
 1da:	53                   	push   %ebx
 1db:	e8 40 01 00 00       	call   320 <strlen>
 1e0:	83 c4 10             	add    $0x10,%esp
 1e3:	83 f8 0d             	cmp    $0xd,%eax
 1e6:	77 4a                	ja     232 <fmtname+0x92>
  memmove(buf, p, strlen(p));
 1e8:	83 ec 0c             	sub    $0xc,%esp
 1eb:	53                   	push   %ebx
 1ec:	e8 2f 01 00 00       	call   320 <strlen>
 1f1:	83 c4 0c             	add    $0xc,%esp
 1f4:	50                   	push   %eax
 1f5:	53                   	push   %ebx
 1f6:	68 98 11 00 00       	push   $0x1198
 1fb:	e8 c0 02 00 00       	call   4c0 <memmove>
  memset(buf+strlen(p), ' ', DIRSIZ-strlen(p));
 200:	89 1c 24             	mov    %ebx,(%esp)
 203:	e8 18 01 00 00       	call   320 <strlen>
 208:	89 1c 24             	mov    %ebx,(%esp)
  return buf;
 20b:	bb 98 11 00 00       	mov    $0x1198,%ebx
  memset(buf+strlen(p), ' ', DIRSIZ-strlen(p));
 210:	89 c6                	mov    %eax,%esi
 212:	e8 09 01 00 00       	call   320 <strlen>
 217:	ba 0e 00 00 00       	mov    $0xe,%edx
 21c:	83 c4 0c             	add    $0xc,%esp
 21f:	29 f2                	sub    %esi,%edx
 221:	05 98 11 00 00       	add    $0x1198,%eax
 226:	52                   	push   %edx
 227:	6a 20                	push   $0x20
 229:	50                   	push   %eax
 22a:	e8 21 01 00 00       	call   350 <memset>
  return buf;
 22f:	83 c4 10             	add    $0x10,%esp
}
 232:	8d 65 f8             	lea    -0x8(%ebp),%esp
 235:	89 d8                	mov    %ebx,%eax
 237:	5b                   	pop    %ebx
 238:	5e                   	pop    %esi
 239:	5d                   	pop    %ebp
 23a:	c3                   	ret    
 23b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 23f:	90                   	nop
 240:	83 c3 01             	add    $0x1,%ebx
 243:	eb 92                	jmp    1d7 <fmtname+0x37>
 245:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 24c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000250 <crc32>:
{
 250:	55                   	push   %ebp
 251:	89 e5                	mov    %esp,%ebp
 253:	53                   	push   %ebx
 254:	8b 5d 10             	mov    0x10(%ebp),%ebx
 257:	8b 55 0c             	mov    0xc(%ebp),%edx
	crc = crc ^ ~0U;
 25a:	8b 45 08             	mov    0x8(%ebp),%eax
	while (size--)
 25d:	85 db                	test   %ebx,%ebx
 25f:	74 2f                	je     290 <crc32+0x40>
 261:	f7 d0                	not    %eax
 263:	01 d3                	add    %edx,%ebx
 265:	8d 76 00             	lea    0x0(%esi),%esi
	crc = crc32_tab[(crc ^ *p++) & 0xFF] ^ (crc >> 8);
 268:	83 c2 01             	add    $0x1,%edx
 26b:	0f b6 4a ff          	movzbl -0x1(%edx),%ecx
 26f:	31 c1                	xor    %eax,%ecx
 271:	c1 e8 08             	shr    $0x8,%eax
 274:	0f b6 c9             	movzbl %cl,%ecx
 277:	33 04 8d 80 0a 00 00 	xor    0xa80(,%ecx,4),%eax
	while (size--)
 27e:	39 da                	cmp    %ebx,%edx
 280:	75 e6                	jne    268 <crc32+0x18>
 282:	f7 d0                	not    %eax
}
 284:	5b                   	pop    %ebx
 285:	5d                   	pop    %ebp
 286:	c3                   	ret    
 287:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 28e:	66 90                	xchg   %ax,%ax
	while (size--)
 290:	8b 45 08             	mov    0x8(%ebp),%eax
}
 293:	5b                   	pop    %ebx
 294:	5d                   	pop    %ebp
 295:	c3                   	ret    
 296:	66 90                	xchg   %ax,%ax
 298:	66 90                	xchg   %ax,%ax
 29a:	66 90                	xchg   %ax,%ax
 29c:	66 90                	xchg   %ax,%ax
 29e:	66 90                	xchg   %ax,%ax

000002a0 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
 2a0:	55                   	push   %ebp
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 2a1:	31 d2                	xor    %edx,%edx
{
 2a3:	89 e5                	mov    %esp,%ebp
 2a5:	53                   	push   %ebx
 2a6:	8b 45 08             	mov    0x8(%ebp),%eax
 2a9:	8b 5d 0c             	mov    0xc(%ebp),%ebx
 2ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while((*s++ = *t++) != 0)
 2b0:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
 2b4:	88 0c 10             	mov    %cl,(%eax,%edx,1)
 2b7:	83 c2 01             	add    $0x1,%edx
 2ba:	84 c9                	test   %cl,%cl
 2bc:	75 f2                	jne    2b0 <strcpy+0x10>
    ;
  return os;
}
 2be:	5b                   	pop    %ebx
 2bf:	5d                   	pop    %ebp
 2c0:	c3                   	ret    
 2c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 2c8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 2cf:	90                   	nop

000002d0 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 2d0:	55                   	push   %ebp
 2d1:	89 e5                	mov    %esp,%ebp
 2d3:	56                   	push   %esi
 2d4:	53                   	push   %ebx
 2d5:	8b 5d 08             	mov    0x8(%ebp),%ebx
 2d8:	8b 75 0c             	mov    0xc(%ebp),%esi
  while(*p && *p == *q)
 2db:	0f b6 13             	movzbl (%ebx),%edx
 2de:	0f b6 0e             	movzbl (%esi),%ecx
 2e1:	84 d2                	test   %dl,%dl
 2e3:	74 1e                	je     303 <strcmp+0x33>
 2e5:	b8 01 00 00 00       	mov    $0x1,%eax
 2ea:	38 ca                	cmp    %cl,%dl
 2ec:	74 09                	je     2f7 <strcmp+0x27>
 2ee:	eb 20                	jmp    310 <strcmp+0x40>
 2f0:	83 c0 01             	add    $0x1,%eax
 2f3:	38 ca                	cmp    %cl,%dl
 2f5:	75 19                	jne    310 <strcmp+0x40>
 2f7:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
 2fb:	0f b6 0c 06          	movzbl (%esi,%eax,1),%ecx
 2ff:	84 d2                	test   %dl,%dl
 301:	75 ed                	jne    2f0 <strcmp+0x20>
 303:	31 c0                	xor    %eax,%eax
    p++, q++;
  return (uchar)*p - (uchar)*q;
}
 305:	5b                   	pop    %ebx
 306:	5e                   	pop    %esi
  return (uchar)*p - (uchar)*q;
 307:	29 c8                	sub    %ecx,%eax
}
 309:	5d                   	pop    %ebp
 30a:	c3                   	ret    
 30b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 30f:	90                   	nop
 310:	0f b6 c2             	movzbl %dl,%eax
 313:	5b                   	pop    %ebx
 314:	5e                   	pop    %esi
  return (uchar)*p - (uchar)*q;
 315:	29 c8                	sub    %ecx,%eax
}
 317:	5d                   	pop    %ebp
 318:	c3                   	ret    
 319:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000320 <strlen>:

uint
strlen(const char *s)
{
 320:	55                   	push   %ebp
 321:	89 e5                	mov    %esp,%ebp
 323:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
 326:	80 39 00             	cmpb   $0x0,(%ecx)
 329:	74 15                	je     340 <strlen+0x20>
 32b:	31 d2                	xor    %edx,%edx
 32d:	8d 76 00             	lea    0x0(%esi),%esi
 330:	83 c2 01             	add    $0x1,%edx
 333:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
 337:	89 d0                	mov    %edx,%eax
 339:	75 f5                	jne    330 <strlen+0x10>
    ;
  return n;
}
 33b:	5d                   	pop    %ebp
 33c:	c3                   	ret    
 33d:	8d 76 00             	lea    0x0(%esi),%esi
  for(n = 0; s[n]; n++)
 340:	31 c0                	xor    %eax,%eax
}
 342:	5d                   	pop    %ebp
 343:	c3                   	ret    
 344:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 34b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 34f:	90                   	nop

00000350 <memset>:

void*
memset(void *dst, int c, uint n)
{
 350:	55                   	push   %ebp
 351:	89 e5                	mov    %esp,%ebp
 353:	57                   	push   %edi
 354:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 357:	8b 4d 10             	mov    0x10(%ebp),%ecx
 35a:	8b 45 0c             	mov    0xc(%ebp),%eax
 35d:	89 d7                	mov    %edx,%edi
 35f:	fc                   	cld    
 360:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 362:	89 d0                	mov    %edx,%eax
 364:	5f                   	pop    %edi
 365:	5d                   	pop    %ebp
 366:	c3                   	ret    
 367:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 36e:	66 90                	xchg   %ax,%ax

00000370 <strchr>:

char*
strchr(const char *s, char c)
{
 370:	55                   	push   %ebp
 371:	89 e5                	mov    %esp,%ebp
 373:	53                   	push   %ebx
 374:	8b 45 08             	mov    0x8(%ebp),%eax
 377:	8b 55 0c             	mov    0xc(%ebp),%edx
  for(; *s; s++)
 37a:	0f b6 18             	movzbl (%eax),%ebx
 37d:	84 db                	test   %bl,%bl
 37f:	74 1d                	je     39e <strchr+0x2e>
 381:	89 d1                	mov    %edx,%ecx
    if(*s == c)
 383:	38 d3                	cmp    %dl,%bl
 385:	75 0d                	jne    394 <strchr+0x24>
 387:	eb 17                	jmp    3a0 <strchr+0x30>
 389:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 390:	38 ca                	cmp    %cl,%dl
 392:	74 0c                	je     3a0 <strchr+0x30>
  for(; *s; s++)
 394:	83 c0 01             	add    $0x1,%eax
 397:	0f b6 10             	movzbl (%eax),%edx
 39a:	84 d2                	test   %dl,%dl
 39c:	75 f2                	jne    390 <strchr+0x20>
      return (char*)s;
  return 0;
 39e:	31 c0                	xor    %eax,%eax
}
 3a0:	5b                   	pop    %ebx
 3a1:	5d                   	pop    %ebp
 3a2:	c3                   	ret    
 3a3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 3aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

000003b0 <gets>:

char*
gets(char *buf, int max)
{
 3b0:	55                   	push   %ebp
 3b1:	89 e5                	mov    %esp,%ebp
 3b3:	57                   	push   %edi
 3b4:	56                   	push   %esi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 3b5:	31 f6                	xor    %esi,%esi
{
 3b7:	53                   	push   %ebx
 3b8:	89 f3                	mov    %esi,%ebx
 3ba:	83 ec 1c             	sub    $0x1c,%esp
 3bd:	8b 7d 08             	mov    0x8(%ebp),%edi
  for(i=0; i+1 < max; ){
 3c0:	eb 2f                	jmp    3f1 <gets+0x41>
 3c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    cc = read(0, &c, 1);
 3c8:	83 ec 04             	sub    $0x4,%esp
 3cb:	8d 45 e7             	lea    -0x19(%ebp),%eax
 3ce:	6a 01                	push   $0x1
 3d0:	50                   	push   %eax
 3d1:	6a 00                	push   $0x0
 3d3:	e8 31 01 00 00       	call   509 <read>
    if(cc < 1)
 3d8:	83 c4 10             	add    $0x10,%esp
 3db:	85 c0                	test   %eax,%eax
 3dd:	7e 1c                	jle    3fb <gets+0x4b>
      break;
    buf[i++] = c;
 3df:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 3e3:	83 c7 01             	add    $0x1,%edi
 3e6:	88 47 ff             	mov    %al,-0x1(%edi)
    if(c == '\n' || c == '\r')
 3e9:	3c 0a                	cmp    $0xa,%al
 3eb:	74 23                	je     410 <gets+0x60>
 3ed:	3c 0d                	cmp    $0xd,%al
 3ef:	74 1f                	je     410 <gets+0x60>
  for(i=0; i+1 < max; ){
 3f1:	83 c3 01             	add    $0x1,%ebx
 3f4:	89 fe                	mov    %edi,%esi
 3f6:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 3f9:	7c cd                	jl     3c8 <gets+0x18>
 3fb:	89 f3                	mov    %esi,%ebx
      break;
  }
  buf[i] = '\0';
  return buf;
}
 3fd:	8b 45 08             	mov    0x8(%ebp),%eax
  buf[i] = '\0';
 400:	c6 03 00             	movb   $0x0,(%ebx)
}
 403:	8d 65 f4             	lea    -0xc(%ebp),%esp
 406:	5b                   	pop    %ebx
 407:	5e                   	pop    %esi
 408:	5f                   	pop    %edi
 409:	5d                   	pop    %ebp
 40a:	c3                   	ret    
 40b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 40f:	90                   	nop
 410:	8b 75 08             	mov    0x8(%ebp),%esi
 413:	8b 45 08             	mov    0x8(%ebp),%eax
 416:	01 de                	add    %ebx,%esi
 418:	89 f3                	mov    %esi,%ebx
  buf[i] = '\0';
 41a:	c6 03 00             	movb   $0x0,(%ebx)
}
 41d:	8d 65 f4             	lea    -0xc(%ebp),%esp
 420:	5b                   	pop    %ebx
 421:	5e                   	pop    %esi
 422:	5f                   	pop    %edi
 423:	5d                   	pop    %ebp
 424:	c3                   	ret    
 425:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 42c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000430 <stat>:

int
stat(const char *n, struct stat *st)
{
 430:	55                   	push   %ebp
 431:	89 e5                	mov    %esp,%ebp
 433:	56                   	push   %esi
 434:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 435:	83 ec 08             	sub    $0x8,%esp
 438:	6a 00                	push   $0x0
 43a:	ff 75 08             	pushl  0x8(%ebp)
 43d:	e8 ef 00 00 00       	call   531 <open>
  if(fd < 0)
 442:	83 c4 10             	add    $0x10,%esp
 445:	85 c0                	test   %eax,%eax
 447:	78 27                	js     470 <stat+0x40>
    return -1;
  r = fstat(fd, st);
 449:	83 ec 08             	sub    $0x8,%esp
 44c:	ff 75 0c             	pushl  0xc(%ebp)
 44f:	89 c3                	mov    %eax,%ebx
 451:	50                   	push   %eax
 452:	e8 f2 00 00 00       	call   549 <fstat>
  close(fd);
 457:	89 1c 24             	mov    %ebx,(%esp)
  r = fstat(fd, st);
 45a:	89 c6                	mov    %eax,%esi
  close(fd);
 45c:	e8 b8 00 00 00       	call   519 <close>
  return r;
 461:	83 c4 10             	add    $0x10,%esp
}
 464:	8d 65 f8             	lea    -0x8(%ebp),%esp
 467:	89 f0                	mov    %esi,%eax
 469:	5b                   	pop    %ebx
 46a:	5e                   	pop    %esi
 46b:	5d                   	pop    %ebp
 46c:	c3                   	ret    
 46d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
 470:	be ff ff ff ff       	mov    $0xffffffff,%esi
 475:	eb ed                	jmp    464 <stat+0x34>
 477:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 47e:	66 90                	xchg   %ax,%ax

00000480 <atoi>:

int
atoi(const char *s)
{
 480:	55                   	push   %ebp
 481:	89 e5                	mov    %esp,%ebp
 483:	53                   	push   %ebx
 484:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 487:	0f be 11             	movsbl (%ecx),%edx
 48a:	8d 42 d0             	lea    -0x30(%edx),%eax
 48d:	3c 09                	cmp    $0x9,%al
  n = 0;
 48f:	b8 00 00 00 00       	mov    $0x0,%eax
  while('0' <= *s && *s <= '9')
 494:	77 1f                	ja     4b5 <atoi+0x35>
 496:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 49d:	8d 76 00             	lea    0x0(%esi),%esi
    n = n*10 + *s++ - '0';
 4a0:	83 c1 01             	add    $0x1,%ecx
 4a3:	8d 04 80             	lea    (%eax,%eax,4),%eax
 4a6:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
  while('0' <= *s && *s <= '9')
 4aa:	0f be 11             	movsbl (%ecx),%edx
 4ad:	8d 5a d0             	lea    -0x30(%edx),%ebx
 4b0:	80 fb 09             	cmp    $0x9,%bl
 4b3:	76 eb                	jbe    4a0 <atoi+0x20>
  return n;
}
 4b5:	5b                   	pop    %ebx
 4b6:	5d                   	pop    %ebp
 4b7:	c3                   	ret    
 4b8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 4bf:	90                   	nop

000004c0 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 4c0:	55                   	push   %ebp
 4c1:	89 e5                	mov    %esp,%ebp
 4c3:	57                   	push   %edi
 4c4:	8b 55 10             	mov    0x10(%ebp),%edx
 4c7:	8b 45 08             	mov    0x8(%ebp),%eax
 4ca:	56                   	push   %esi
 4cb:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 4ce:	85 d2                	test   %edx,%edx
 4d0:	7e 13                	jle    4e5 <memmove+0x25>
 4d2:	01 c2                	add    %eax,%edx
  dst = vdst;
 4d4:	89 c7                	mov    %eax,%edi
 4d6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 4dd:	8d 76 00             	lea    0x0(%esi),%esi
    *dst++ = *src++;
 4e0:	a4                   	movsb  %ds:(%esi),%es:(%edi)
  while(n-- > 0)
 4e1:	39 fa                	cmp    %edi,%edx
 4e3:	75 fb                	jne    4e0 <memmove+0x20>
  return vdst;
}
 4e5:	5e                   	pop    %esi
 4e6:	5f                   	pop    %edi
 4e7:	5d                   	pop    %ebp
 4e8:	c3                   	ret    

000004e9 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 4e9:	b8 01 00 00 00       	mov    $0x1,%eax
 4ee:	cd 40                	int    $0x40
 4f0:	c3                   	ret    

000004f1 <exit>:
SYSCALL(exit)
 4f1:	b8 02 00 00 00       	mov    $0x2,%eax
 4f6:	cd 40                	int    $0x40
 4f8:	c3                   	ret    

000004f9 <wait>:
SYSCALL(wait)
 4f9:	b8 03 00 00 00       	mov    $0x3,%eax
 4fe:	cd 40                	int    $0x40
 500:	c3                   	ret    

00000501 <pipe>:
SYSCALL(pipe)
 501:	b8 04 00 00 00       	mov    $0x4,%eax
 506:	cd 40                	int    $0x40
 508:	c3                   	ret    

00000509 <read>:
SYSCALL(read)
 509:	b8 05 00 00 00       	mov    $0x5,%eax
 50e:	cd 40                	int    $0x40
 510:	c3                   	ret    

00000511 <write>:
SYSCALL(write)
 511:	b8 10 00 00 00       	mov    $0x10,%eax
 516:	cd 40                	int    $0x40
 518:	c3                   	ret    

00000519 <close>:
SYSCALL(close)
 519:	b8 15 00 00 00       	mov    $0x15,%eax
 51e:	cd 40                	int    $0x40
 520:	c3                   	ret    

00000521 <kill>:
SYSCALL(kill)
 521:	b8 06 00 00 00       	mov    $0x6,%eax
 526:	cd 40                	int    $0x40
 528:	c3                   	ret    

00000529 <exec>:
SYSCALL(exec)
 529:	b8 07 00 00 00       	mov    $0x7,%eax
 52e:	cd 40                	int    $0x40
 530:	c3                   	ret    

00000531 <open>:
SYSCALL(open)
 531:	b8 0f 00 00 00       	mov    $0xf,%eax
 536:	cd 40                	int    $0x40
 538:	c3                   	ret    

00000539 <mknod>:
SYSCALL(mknod)
 539:	b8 11 00 00 00       	mov    $0x11,%eax
 53e:	cd 40                	int    $0x40
 540:	c3                   	ret    

00000541 <unlink>:
SYSCALL(unlink)
 541:	b8 12 00 00 00       	mov    $0x12,%eax
 546:	cd 40                	int    $0x40
 548:	c3                   	ret    

00000549 <fstat>:
SYSCALL(fstat)
 549:	b8 08 00 00 00       	mov    $0x8,%eax
 54e:	cd 40                	int    $0x40
 550:	c3                   	ret    

00000551 <link>:
SYSCALL(link)
 551:	b8 13 00 00 00       	mov    $0x13,%eax
 556:	cd 40                	int    $0x40
 558:	c3                   	ret    

00000559 <mkdir>:
SYSCALL(mkdir)
 559:	b8 14 00 00 00       	mov    $0x14,%eax
 55e:	cd 40                	int    $0x40
 560:	c3                   	ret    

00000561 <chdir>:
SYSCALL(chdir)
 561:	b8 09 00 00 00       	mov    $0x9,%eax
 566:	cd 40                	int    $0x40
 568:	c3                   	ret    

00000569 <dup>:
SYSCALL(dup)
 569:	b8 0a 00 00 00       	mov    $0xa,%eax
 56e:	cd 40                	int    $0x40
 570:	c3                   	ret    

00000571 <getpid>:
SYSCALL(getpid)
 571:	b8 0b 00 00 00       	mov    $0xb,%eax
 576:	cd 40                	int    $0x40
 578:	c3                   	ret    

00000579 <sbrk>:
SYSCALL(sbrk)
 579:	b8 0c 00 00 00       	mov    $0xc,%eax
 57e:	cd 40                	int    $0x40
 580:	c3                   	ret    

00000581 <sleep>:
SYSCALL(sleep)
 581:	b8 0d 00 00 00       	mov    $0xd,%eax
 586:	cd 40                	int    $0x40
 588:	c3                   	ret    

00000589 <uptime>:
SYSCALL(uptime)
 589:	b8 0e 00 00 00       	mov    $0xe,%eax
 58e:	cd 40                	int    $0x40
 590:	c3                   	ret    

00000591 <freemem>:
SYSCALL(freemem)
 591:	b8 16 00 00 00       	mov    $0x16,%eax
 596:	cd 40                	int    $0x40
 598:	c3                   	ret    

00000599 <exit2>:
SYSCALL(exit2)
 599:	b8 17 00 00 00       	mov    $0x17,%eax
 59e:	cd 40                	int    $0x40
 5a0:	c3                   	ret    

000005a1 <wait2>:
SYSCALL(wait2)
 5a1:	b8 18 00 00 00       	mov    $0x18,%eax
 5a6:	cd 40                	int    $0x40
 5a8:	c3                   	ret    
 5a9:	66 90                	xchg   %ax,%ax
 5ab:	66 90                	xchg   %ax,%ax
 5ad:	66 90                	xchg   %ax,%ax
 5af:	90                   	nop

000005b0 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 5b0:	55                   	push   %ebp
 5b1:	89 e5                	mov    %esp,%ebp
 5b3:	57                   	push   %edi
 5b4:	56                   	push   %esi
 5b5:	53                   	push   %ebx
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
 5b6:	89 d3                	mov    %edx,%ebx
{
 5b8:	83 ec 3c             	sub    $0x3c,%esp
 5bb:	89 45 bc             	mov    %eax,-0x44(%ebp)
  if(sgn && xx < 0){
 5be:	85 d2                	test   %edx,%edx
 5c0:	0f 89 92 00 00 00    	jns    658 <printint+0xa8>
 5c6:	f6 45 08 01          	testb  $0x1,0x8(%ebp)
 5ca:	0f 84 88 00 00 00    	je     658 <printint+0xa8>
    neg = 1;
 5d0:	c7 45 c0 01 00 00 00 	movl   $0x1,-0x40(%ebp)
    x = -xx;
 5d7:	f7 db                	neg    %ebx
  } else {
    x = xx;
  }

  i = 0;
 5d9:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
 5e0:	8d 75 d7             	lea    -0x29(%ebp),%esi
 5e3:	eb 08                	jmp    5ed <printint+0x3d>
 5e5:	8d 76 00             	lea    0x0(%esi),%esi
  do{
    buf[i++] = digits[x % base];
 5e8:	89 7d c4             	mov    %edi,-0x3c(%ebp)
  }while((x /= base) != 0);
 5eb:	89 c3                	mov    %eax,%ebx
    buf[i++] = digits[x % base];
 5ed:	89 d8                	mov    %ebx,%eax
 5ef:	31 d2                	xor    %edx,%edx
 5f1:	8b 7d c4             	mov    -0x3c(%ebp),%edi
 5f4:	f7 f1                	div    %ecx
 5f6:	83 c7 01             	add    $0x1,%edi
 5f9:	0f b6 92 88 0e 00 00 	movzbl 0xe88(%edx),%edx
 600:	88 14 3e             	mov    %dl,(%esi,%edi,1)
  }while((x /= base) != 0);
 603:	39 d9                	cmp    %ebx,%ecx
 605:	76 e1                	jbe    5e8 <printint+0x38>
  if(neg)
 607:	8b 45 c0             	mov    -0x40(%ebp),%eax
 60a:	85 c0                	test   %eax,%eax
 60c:	74 0d                	je     61b <printint+0x6b>
    buf[i++] = '-';
 60e:	c6 44 3d d8 2d       	movb   $0x2d,-0x28(%ebp,%edi,1)
 613:	ba 2d 00 00 00       	mov    $0x2d,%edx
    buf[i++] = digits[x % base];
 618:	89 7d c4             	mov    %edi,-0x3c(%ebp)

  while(--i >= 0)
 61b:	8b 45 c4             	mov    -0x3c(%ebp),%eax
 61e:	8b 7d bc             	mov    -0x44(%ebp),%edi
 621:	8d 5c 05 d7          	lea    -0x29(%ebp,%eax,1),%ebx
 625:	eb 0f                	jmp    636 <printint+0x86>
 627:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 62e:	66 90                	xchg   %ax,%ax
 630:	0f b6 13             	movzbl (%ebx),%edx
 633:	83 eb 01             	sub    $0x1,%ebx
  write(fd, &c, 1);
 636:	83 ec 04             	sub    $0x4,%esp
 639:	88 55 d7             	mov    %dl,-0x29(%ebp)
 63c:	6a 01                	push   $0x1
 63e:	56                   	push   %esi
 63f:	57                   	push   %edi
 640:	e8 cc fe ff ff       	call   511 <write>
  while(--i >= 0)
 645:	83 c4 10             	add    $0x10,%esp
 648:	39 de                	cmp    %ebx,%esi
 64a:	75 e4                	jne    630 <printint+0x80>
    putc(fd, buf[i]);
}
 64c:	8d 65 f4             	lea    -0xc(%ebp),%esp
 64f:	5b                   	pop    %ebx
 650:	5e                   	pop    %esi
 651:	5f                   	pop    %edi
 652:	5d                   	pop    %ebp
 653:	c3                   	ret    
 654:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  neg = 0;
 658:	c7 45 c0 00 00 00 00 	movl   $0x0,-0x40(%ebp)
 65f:	e9 75 ff ff ff       	jmp    5d9 <printint+0x29>
 664:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 66b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 66f:	90                   	nop

00000670 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 670:	55                   	push   %ebp
 671:	89 e5                	mov    %esp,%ebp
 673:	57                   	push   %edi
 674:	56                   	push   %esi
 675:	53                   	push   %ebx
 676:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 679:	8b 75 0c             	mov    0xc(%ebp),%esi
 67c:	0f b6 1e             	movzbl (%esi),%ebx
 67f:	84 db                	test   %bl,%bl
 681:	0f 84 b9 00 00 00    	je     740 <printf+0xd0>
  ap = (uint*)(void*)&fmt + 1;
 687:	8d 45 10             	lea    0x10(%ebp),%eax
 68a:	83 c6 01             	add    $0x1,%esi
  write(fd, &c, 1);
 68d:	8d 7d e7             	lea    -0x19(%ebp),%edi
  state = 0;
 690:	31 d2                	xor    %edx,%edx
  ap = (uint*)(void*)&fmt + 1;
 692:	89 45 d0             	mov    %eax,-0x30(%ebp)
 695:	eb 38                	jmp    6cf <printf+0x5f>
 697:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 69e:	66 90                	xchg   %ax,%ax
 6a0:	89 55 d4             	mov    %edx,-0x2c(%ebp)
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
 6a3:	ba 25 00 00 00       	mov    $0x25,%edx
      if(c == '%'){
 6a8:	83 f8 25             	cmp    $0x25,%eax
 6ab:	74 17                	je     6c4 <printf+0x54>
  write(fd, &c, 1);
 6ad:	83 ec 04             	sub    $0x4,%esp
 6b0:	88 5d e7             	mov    %bl,-0x19(%ebp)
 6b3:	6a 01                	push   $0x1
 6b5:	57                   	push   %edi
 6b6:	ff 75 08             	pushl  0x8(%ebp)
 6b9:	e8 53 fe ff ff       	call   511 <write>
 6be:	8b 55 d4             	mov    -0x2c(%ebp),%edx
      } else {
        putc(fd, c);
 6c1:	83 c4 10             	add    $0x10,%esp
  for(i = 0; fmt[i]; i++){
 6c4:	83 c6 01             	add    $0x1,%esi
 6c7:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
 6cb:	84 db                	test   %bl,%bl
 6cd:	74 71                	je     740 <printf+0xd0>
    c = fmt[i] & 0xff;
 6cf:	0f be cb             	movsbl %bl,%ecx
 6d2:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
 6d5:	85 d2                	test   %edx,%edx
 6d7:	74 c7                	je     6a0 <printf+0x30>
      }
    } else if(state == '%'){
 6d9:	83 fa 25             	cmp    $0x25,%edx
 6dc:	75 e6                	jne    6c4 <printf+0x54>
      if(c == 'd'){
 6de:	83 f8 64             	cmp    $0x64,%eax
 6e1:	0f 84 99 00 00 00    	je     780 <printf+0x110>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 6e7:	81 e1 f7 00 00 00    	and    $0xf7,%ecx
 6ed:	83 f9 70             	cmp    $0x70,%ecx
 6f0:	74 5e                	je     750 <printf+0xe0>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 6f2:	83 f8 73             	cmp    $0x73,%eax
 6f5:	0f 84 d5 00 00 00    	je     7d0 <printf+0x160>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 6fb:	83 f8 63             	cmp    $0x63,%eax
 6fe:	0f 84 8c 00 00 00    	je     790 <printf+0x120>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 704:	83 f8 25             	cmp    $0x25,%eax
 707:	0f 84 b3 00 00 00    	je     7c0 <printf+0x150>
  write(fd, &c, 1);
 70d:	83 ec 04             	sub    $0x4,%esp
 710:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
 714:	6a 01                	push   $0x1
 716:	57                   	push   %edi
 717:	ff 75 08             	pushl  0x8(%ebp)
 71a:	e8 f2 fd ff ff       	call   511 <write>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
 71f:	88 5d e7             	mov    %bl,-0x19(%ebp)
  write(fd, &c, 1);
 722:	83 c4 0c             	add    $0xc,%esp
 725:	6a 01                	push   $0x1
 727:	83 c6 01             	add    $0x1,%esi
 72a:	57                   	push   %edi
 72b:	ff 75 08             	pushl  0x8(%ebp)
 72e:	e8 de fd ff ff       	call   511 <write>
  for(i = 0; fmt[i]; i++){
 733:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
        putc(fd, c);
 737:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 73a:	31 d2                	xor    %edx,%edx
  for(i = 0; fmt[i]; i++){
 73c:	84 db                	test   %bl,%bl
 73e:	75 8f                	jne    6cf <printf+0x5f>
    }
  }
}
 740:	8d 65 f4             	lea    -0xc(%ebp),%esp
 743:	5b                   	pop    %ebx
 744:	5e                   	pop    %esi
 745:	5f                   	pop    %edi
 746:	5d                   	pop    %ebp
 747:	c3                   	ret    
 748:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 74f:	90                   	nop
        printint(fd, *ap, 16, 0);
 750:	83 ec 0c             	sub    $0xc,%esp
 753:	b9 10 00 00 00       	mov    $0x10,%ecx
 758:	6a 00                	push   $0x0
 75a:	8b 5d d0             	mov    -0x30(%ebp),%ebx
 75d:	8b 45 08             	mov    0x8(%ebp),%eax
 760:	8b 13                	mov    (%ebx),%edx
 762:	e8 49 fe ff ff       	call   5b0 <printint>
        ap++;
 767:	89 d8                	mov    %ebx,%eax
 769:	83 c4 10             	add    $0x10,%esp
      state = 0;
 76c:	31 d2                	xor    %edx,%edx
        ap++;
 76e:	83 c0 04             	add    $0x4,%eax
 771:	89 45 d0             	mov    %eax,-0x30(%ebp)
 774:	e9 4b ff ff ff       	jmp    6c4 <printf+0x54>
 779:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        printint(fd, *ap, 10, 1);
 780:	83 ec 0c             	sub    $0xc,%esp
 783:	b9 0a 00 00 00       	mov    $0xa,%ecx
 788:	6a 01                	push   $0x1
 78a:	eb ce                	jmp    75a <printf+0xea>
 78c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        putc(fd, *ap);
 790:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  write(fd, &c, 1);
 793:	83 ec 04             	sub    $0x4,%esp
        putc(fd, *ap);
 796:	8b 03                	mov    (%ebx),%eax
  write(fd, &c, 1);
 798:	6a 01                	push   $0x1
        ap++;
 79a:	83 c3 04             	add    $0x4,%ebx
  write(fd, &c, 1);
 79d:	57                   	push   %edi
 79e:	ff 75 08             	pushl  0x8(%ebp)
        putc(fd, *ap);
 7a1:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 7a4:	e8 68 fd ff ff       	call   511 <write>
        ap++;
 7a9:	89 5d d0             	mov    %ebx,-0x30(%ebp)
 7ac:	83 c4 10             	add    $0x10,%esp
      state = 0;
 7af:	31 d2                	xor    %edx,%edx
 7b1:	e9 0e ff ff ff       	jmp    6c4 <printf+0x54>
 7b6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 7bd:	8d 76 00             	lea    0x0(%esi),%esi
        putc(fd, c);
 7c0:	88 5d e7             	mov    %bl,-0x19(%ebp)
  write(fd, &c, 1);
 7c3:	83 ec 04             	sub    $0x4,%esp
 7c6:	e9 5a ff ff ff       	jmp    725 <printf+0xb5>
 7cb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 7cf:	90                   	nop
        s = (char*)*ap;
 7d0:	8b 45 d0             	mov    -0x30(%ebp),%eax
 7d3:	8b 18                	mov    (%eax),%ebx
        ap++;
 7d5:	83 c0 04             	add    $0x4,%eax
 7d8:	89 45 d0             	mov    %eax,-0x30(%ebp)
        if(s == 0)
 7db:	85 db                	test   %ebx,%ebx
 7dd:	74 17                	je     7f6 <printf+0x186>
        while(*s != 0){
 7df:	0f b6 03             	movzbl (%ebx),%eax
      state = 0;
 7e2:	31 d2                	xor    %edx,%edx
        while(*s != 0){
 7e4:	84 c0                	test   %al,%al
 7e6:	0f 84 d8 fe ff ff    	je     6c4 <printf+0x54>
 7ec:	89 75 d4             	mov    %esi,-0x2c(%ebp)
 7ef:	89 de                	mov    %ebx,%esi
 7f1:	8b 5d 08             	mov    0x8(%ebp),%ebx
 7f4:	eb 1a                	jmp    810 <printf+0x1a0>
          s = "(null)";
 7f6:	bb 80 0e 00 00       	mov    $0xe80,%ebx
        while(*s != 0){
 7fb:	89 75 d4             	mov    %esi,-0x2c(%ebp)
 7fe:	b8 28 00 00 00       	mov    $0x28,%eax
 803:	89 de                	mov    %ebx,%esi
 805:	8b 5d 08             	mov    0x8(%ebp),%ebx
 808:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 80f:	90                   	nop
  write(fd, &c, 1);
 810:	83 ec 04             	sub    $0x4,%esp
          s++;
 813:	83 c6 01             	add    $0x1,%esi
 816:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 819:	6a 01                	push   $0x1
 81b:	57                   	push   %edi
 81c:	53                   	push   %ebx
 81d:	e8 ef fc ff ff       	call   511 <write>
        while(*s != 0){
 822:	0f b6 06             	movzbl (%esi),%eax
 825:	83 c4 10             	add    $0x10,%esp
 828:	84 c0                	test   %al,%al
 82a:	75 e4                	jne    810 <printf+0x1a0>
 82c:	8b 75 d4             	mov    -0x2c(%ebp),%esi
      state = 0;
 82f:	31 d2                	xor    %edx,%edx
 831:	e9 8e fe ff ff       	jmp    6c4 <printf+0x54>
 836:	66 90                	xchg   %ax,%ax
 838:	66 90                	xchg   %ax,%ax
 83a:	66 90                	xchg   %ax,%ax
 83c:	66 90                	xchg   %ax,%ax
 83e:	66 90                	xchg   %ax,%ax

00000840 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 840:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 841:	a1 a8 11 00 00       	mov    0x11a8,%eax
{
 846:	89 e5                	mov    %esp,%ebp
 848:	57                   	push   %edi
 849:	56                   	push   %esi
 84a:	53                   	push   %ebx
 84b:	8b 5d 08             	mov    0x8(%ebp),%ebx
 84e:	8b 10                	mov    (%eax),%edx
  bp = (Header*)ap - 1;
 850:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 853:	39 c8                	cmp    %ecx,%eax
 855:	73 19                	jae    870 <free+0x30>
 857:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 85e:	66 90                	xchg   %ax,%ax
 860:	39 d1                	cmp    %edx,%ecx
 862:	72 14                	jb     878 <free+0x38>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 864:	39 d0                	cmp    %edx,%eax
 866:	73 10                	jae    878 <free+0x38>
{
 868:	89 d0                	mov    %edx,%eax
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 86a:	8b 10                	mov    (%eax),%edx
 86c:	39 c8                	cmp    %ecx,%eax
 86e:	72 f0                	jb     860 <free+0x20>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 870:	39 d0                	cmp    %edx,%eax
 872:	72 f4                	jb     868 <free+0x28>
 874:	39 d1                	cmp    %edx,%ecx
 876:	73 f0                	jae    868 <free+0x28>
      break;
  if(bp + bp->s.size == p->s.ptr){
 878:	8b 73 fc             	mov    -0x4(%ebx),%esi
 87b:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 87e:	39 fa                	cmp    %edi,%edx
 880:	74 1e                	je     8a0 <free+0x60>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 882:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 885:	8b 50 04             	mov    0x4(%eax),%edx
 888:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 88b:	39 f1                	cmp    %esi,%ecx
 88d:	74 28                	je     8b7 <free+0x77>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 88f:	89 08                	mov    %ecx,(%eax)
  freep = p;
}
 891:	5b                   	pop    %ebx
  freep = p;
 892:	a3 a8 11 00 00       	mov    %eax,0x11a8
}
 897:	5e                   	pop    %esi
 898:	5f                   	pop    %edi
 899:	5d                   	pop    %ebp
 89a:	c3                   	ret    
 89b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 89f:	90                   	nop
    bp->s.size += p->s.ptr->s.size;
 8a0:	03 72 04             	add    0x4(%edx),%esi
 8a3:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 8a6:	8b 10                	mov    (%eax),%edx
 8a8:	8b 12                	mov    (%edx),%edx
 8aa:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 8ad:	8b 50 04             	mov    0x4(%eax),%edx
 8b0:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 8b3:	39 f1                	cmp    %esi,%ecx
 8b5:	75 d8                	jne    88f <free+0x4f>
    p->s.size += bp->s.size;
 8b7:	03 53 fc             	add    -0x4(%ebx),%edx
  freep = p;
 8ba:	a3 a8 11 00 00       	mov    %eax,0x11a8
    p->s.size += bp->s.size;
 8bf:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 8c2:	8b 53 f8             	mov    -0x8(%ebx),%edx
 8c5:	89 10                	mov    %edx,(%eax)
}
 8c7:	5b                   	pop    %ebx
 8c8:	5e                   	pop    %esi
 8c9:	5f                   	pop    %edi
 8ca:	5d                   	pop    %ebp
 8cb:	c3                   	ret    
 8cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

000008d0 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 8d0:	55                   	push   %ebp
 8d1:	89 e5                	mov    %esp,%ebp
 8d3:	57                   	push   %edi
 8d4:	56                   	push   %esi
 8d5:	53                   	push   %ebx
 8d6:	83 ec 1c             	sub    $0x1c,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 8d9:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
 8dc:	8b 3d a8 11 00 00    	mov    0x11a8,%edi
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 8e2:	8d 70 07             	lea    0x7(%eax),%esi
 8e5:	c1 ee 03             	shr    $0x3,%esi
 8e8:	83 c6 01             	add    $0x1,%esi
  if((prevp = freep) == 0){
 8eb:	85 ff                	test   %edi,%edi
 8ed:	0f 84 ad 00 00 00    	je     9a0 <malloc+0xd0>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8f3:	8b 17                	mov    (%edi),%edx
    if(p->s.size >= nunits){
 8f5:	8b 4a 04             	mov    0x4(%edx),%ecx
 8f8:	39 f1                	cmp    %esi,%ecx
 8fa:	73 72                	jae    96e <malloc+0x9e>
 8fc:	81 fe 00 10 00 00    	cmp    $0x1000,%esi
 902:	bb 00 10 00 00       	mov    $0x1000,%ebx
 907:	0f 43 de             	cmovae %esi,%ebx
  p = sbrk(nu * sizeof(Header));
 90a:	8d 04 dd 00 00 00 00 	lea    0x0(,%ebx,8),%eax
 911:	89 45 e4             	mov    %eax,-0x1c(%ebp)
 914:	eb 1b                	jmp    931 <malloc+0x61>
 916:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 91d:	8d 76 00             	lea    0x0(%esi),%esi
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 920:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 922:	8b 48 04             	mov    0x4(%eax),%ecx
 925:	39 f1                	cmp    %esi,%ecx
 927:	73 4f                	jae    978 <malloc+0xa8>
 929:	8b 3d a8 11 00 00    	mov    0x11a8,%edi
 92f:	89 c2                	mov    %eax,%edx
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 931:	39 d7                	cmp    %edx,%edi
 933:	75 eb                	jne    920 <malloc+0x50>
  p = sbrk(nu * sizeof(Header));
 935:	83 ec 0c             	sub    $0xc,%esp
 938:	ff 75 e4             	pushl  -0x1c(%ebp)
 93b:	e8 39 fc ff ff       	call   579 <sbrk>
  if(p == (char*)-1)
 940:	83 c4 10             	add    $0x10,%esp
 943:	83 f8 ff             	cmp    $0xffffffff,%eax
 946:	74 1c                	je     964 <malloc+0x94>
  hp->s.size = nu;
 948:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 94b:	83 ec 0c             	sub    $0xc,%esp
 94e:	83 c0 08             	add    $0x8,%eax
 951:	50                   	push   %eax
 952:	e8 e9 fe ff ff       	call   840 <free>
  return freep;
 957:	8b 15 a8 11 00 00    	mov    0x11a8,%edx
      if((p = morecore(nunits)) == 0)
 95d:	83 c4 10             	add    $0x10,%esp
 960:	85 d2                	test   %edx,%edx
 962:	75 bc                	jne    920 <malloc+0x50>
        return 0;
  }
}
 964:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return 0;
 967:	31 c0                	xor    %eax,%eax
}
 969:	5b                   	pop    %ebx
 96a:	5e                   	pop    %esi
 96b:	5f                   	pop    %edi
 96c:	5d                   	pop    %ebp
 96d:	c3                   	ret    
    if(p->s.size >= nunits){
 96e:	89 d0                	mov    %edx,%eax
 970:	89 fa                	mov    %edi,%edx
 972:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      if(p->s.size == nunits)
 978:	39 ce                	cmp    %ecx,%esi
 97a:	74 54                	je     9d0 <malloc+0x100>
        p->s.size -= nunits;
 97c:	29 f1                	sub    %esi,%ecx
 97e:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
 981:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
 984:	89 70 04             	mov    %esi,0x4(%eax)
      freep = prevp;
 987:	89 15 a8 11 00 00    	mov    %edx,0x11a8
}
 98d:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return (void*)(p + 1);
 990:	83 c0 08             	add    $0x8,%eax
}
 993:	5b                   	pop    %ebx
 994:	5e                   	pop    %esi
 995:	5f                   	pop    %edi
 996:	5d                   	pop    %ebp
 997:	c3                   	ret    
 998:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 99f:	90                   	nop
    base.s.ptr = freep = prevp = &base;
 9a0:	c7 05 a8 11 00 00 ac 	movl   $0x11ac,0x11a8
 9a7:	11 00 00 
    base.s.size = 0;
 9aa:	bf ac 11 00 00       	mov    $0x11ac,%edi
    base.s.ptr = freep = prevp = &base;
 9af:	c7 05 ac 11 00 00 ac 	movl   $0x11ac,0x11ac
 9b6:	11 00 00 
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 9b9:	89 fa                	mov    %edi,%edx
    base.s.size = 0;
 9bb:	c7 05 b0 11 00 00 00 	movl   $0x0,0x11b0
 9c2:	00 00 00 
    if(p->s.size >= nunits){
 9c5:	e9 32 ff ff ff       	jmp    8fc <malloc+0x2c>
 9ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        prevp->s.ptr = p->s.ptr;
 9d0:	8b 08                	mov    (%eax),%ecx
 9d2:	89 0a                	mov    %ecx,(%edx)
 9d4:	eb b1                	jmp    987 <malloc+0xb7>
