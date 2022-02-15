
_crc32:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
  printf(1, "%x\n", crc32(0, buffer, st->size));
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
  11:	81 ec 48 02 00 00    	sub    $0x248,%esp
  int fd;
  struct stat st;
  struct dirent de;
  char *p, buffer[512];

  if(argc != 2){
  17:	83 39 02             	cmpl   $0x2,(%ecx)
{
  1a:	8b 79 04             	mov    0x4(%ecx),%edi
  if(argc != 2){
  1d:	74 1a                	je     39 <main+0x39>
	printf(1, "ERROR: crc32 does not have the correct amount of arguments\n");
  1f:	50                   	push   %eax
  20:	50                   	push   %eax
  21:	68 00 0b 00 00       	push   $0xb00
  26:	6a 01                	push   $0x1
  28:	e8 43 07 00 00       	call   770 <printf>
    exit2(-1);
  2d:	c7 04 24 ff ff ff ff 	movl   $0xffffffff,(%esp)
  34:	e8 60 06 00 00       	call   699 <exit2>
  }

  if((fd = open(argv[1], 0)) < 0){
  39:	50                   	push   %eax
  3a:	50                   	push   %eax
  3b:	6a 00                	push   $0x0
  3d:	ff 77 04             	pushl  0x4(%edi)
  40:	e8 ec 05 00 00       	call   631 <open>
  45:	83 c4 10             	add    $0x10,%esp
  48:	89 c3                	mov    %eax,%ebx
  4a:	85 c0                	test   %eax,%eax
  4c:	78 60                	js     ae <main+0xae>
    printf(2, "crc32: cannot open %s\n", argv[1]);
	exit2(-1);
  } 

  if(fstat(fd, &st) < 0){
  4e:	8d b5 d4 fd ff ff    	lea    -0x22c(%ebp),%esi
  54:	50                   	push   %eax
  55:	50                   	push   %eax
  56:	56                   	push   %esi
  57:	53                   	push   %ebx
  58:	e8 ec 05 00 00       	call   649 <fstat>
  5d:	83 c4 10             	add    $0x10,%esp
  60:	85 c0                	test   %eax,%eax
  62:	78 26                	js     8a <main+0x8a>
    printf(2, "crc32: cannot stat %s\n", argv[1]);
    close(fd);
    exit2(-1);
  }
  
  switch (st.type) {
  64:	0f b7 85 d4 fd ff ff 	movzwl -0x22c(%ebp),%eax
  6b:	66 83 f8 01          	cmp    $0x1,%ax
  6f:	74 59                	je     ca <main+0xca>
  71:	66 83 f8 02          	cmp    $0x2,%ax
  75:	75 0e                	jne    85 <main+0x85>
	case T_FILE:
		crcFile(fd, &st, argv[1]);
  77:	50                   	push   %eax
  78:	ff 77 04             	pushl  0x4(%edi)
  7b:	56                   	push   %esi
  7c:	53                   	push   %ebx
  7d:	e8 6e 02 00 00       	call   2f0 <crcFile>
		break;
  82:	83 c4 10             	add    $0x10,%esp
			}
			printf(1, "%x\n", crc32(0, &de, st.size));
		}
		break;
  }
  exit();
  85:	e8 67 05 00 00       	call   5f1 <exit>
    printf(2, "crc32: cannot stat %s\n", argv[1]);
  8a:	50                   	push   %eax
  8b:	ff 77 04             	pushl  0x4(%edi)
  8e:	68 57 0b 00 00       	push   $0xb57
  93:	6a 02                	push   $0x2
  95:	e8 d6 06 00 00       	call   770 <printf>
    close(fd);
  9a:	89 1c 24             	mov    %ebx,(%esp)
  9d:	e8 77 05 00 00       	call   619 <close>
    exit2(-1);
  a2:	c7 04 24 ff ff ff ff 	movl   $0xffffffff,(%esp)
  a9:	e8 eb 05 00 00       	call   699 <exit2>
    printf(2, "crc32: cannot open %s\n", argv[1]);
  ae:	50                   	push   %eax
  af:	ff 77 04             	pushl  0x4(%edi)
  b2:	68 40 0b 00 00       	push   $0xb40
  b7:	6a 02                	push   $0x2
  b9:	e8 b2 06 00 00       	call   770 <printf>
	exit2(-1);
  be:	c7 04 24 ff ff ff ff 	movl   $0xffffffff,(%esp)
  c5:	e8 cf 05 00 00       	call   699 <exit2>
	    if(strlen(argv[1]) + 1 + DIRSIZ + 1 > sizeof buffer){
  ca:	83 ec 0c             	sub    $0xc,%esp
  cd:	ff 77 04             	pushl  0x4(%edi)
  d0:	e8 4b 03 00 00       	call   420 <strlen>
  d5:	83 c4 10             	add    $0x10,%esp
  d8:	83 c0 10             	add    $0x10,%eax
  db:	3d 00 02 00 00       	cmp    $0x200,%eax
  e0:	76 13                	jbe    f5 <main+0xf5>
			printf(1, "CRC32: path too long\n");
  e2:	53                   	push   %ebx
  e3:	53                   	push   %ebx
  e4:	68 6e 0b 00 00       	push   $0xb6e
  e9:	6a 01                	push   $0x1
  eb:	e8 80 06 00 00       	call   770 <printf>
			break;
  f0:	83 c4 10             	add    $0x10,%esp
  f3:	eb 90                	jmp    85 <main+0x85>
		strcpy(buffer, argv[1]);
  f5:	8d 85 e8 fd ff ff    	lea    -0x218(%ebp),%eax
  fb:	51                   	push   %ecx
  fc:	51                   	push   %ecx
  fd:	ff 77 04             	pushl  0x4(%edi)
 100:	50                   	push   %eax
 101:	e8 9a 02 00 00       	call   3a0 <strcpy>
		p = buffer+strlen(buffer);
 106:	8d 85 e8 fd ff ff    	lea    -0x218(%ebp),%eax
 10c:	89 04 24             	mov    %eax,(%esp)
 10f:	e8 0c 03 00 00       	call   420 <strlen>
 114:	8d 95 e8 fd ff ff    	lea    -0x218(%ebp),%edx
		while(read(fd, &de, sizeof(de) == sizeof(de))) {
 11a:	83 c4 10             	add    $0x10,%esp
		p = buffer+strlen(buffer);
 11d:	01 d0                	add    %edx,%eax
		*p++ = '/';
 11f:	8d 50 01             	lea    0x1(%eax),%edx
		p = buffer+strlen(buffer);
 122:	89 85 b4 fd ff ff    	mov    %eax,-0x24c(%ebp)
		*p++ = '/';
 128:	89 95 b0 fd ff ff    	mov    %edx,-0x250(%ebp)
 12e:	c6 00 2f             	movb   $0x2f,(%eax)
		while(read(fd, &de, sizeof(de) == sizeof(de))) {
 131:	50                   	push   %eax
 132:	8d 85 c4 fd ff ff    	lea    -0x23c(%ebp),%eax
 138:	6a 01                	push   $0x1
 13a:	50                   	push   %eax
 13b:	53                   	push   %ebx
 13c:	e8 c8 04 00 00       	call   609 <read>
 141:	83 c4 10             	add    $0x10,%esp
 144:	85 c0                	test   %eax,%eax
 146:	0f 84 39 ff ff ff    	je     85 <main+0x85>
			if(de.inum == 0) {
 14c:	66 83 bd c4 fd ff ff 	cmpw   $0x0,-0x23c(%ebp)
 153:	00 
 154:	74 db                	je     131 <main+0x131>
			memmove(p, de.name, DIRSIZ);
 156:	8d 85 c6 fd ff ff    	lea    -0x23a(%ebp),%eax
 15c:	57                   	push   %edi
 15d:	6a 0e                	push   $0xe
 15f:	50                   	push   %eax
 160:	ff b5 b0 fd ff ff    	pushl  -0x250(%ebp)
 166:	e8 55 04 00 00       	call   5c0 <memmove>
			p[DIRSIZ] = 0;
 16b:	8b 85 b4 fd ff ff    	mov    -0x24c(%ebp),%eax
 171:	c6 40 0f 00          	movb   $0x0,0xf(%eax)
			if(stat(buffer, &st) < 0) {
 175:	58                   	pop    %eax
 176:	8d 85 e8 fd ff ff    	lea    -0x218(%ebp),%eax
 17c:	5a                   	pop    %edx
 17d:	56                   	push   %esi
 17e:	50                   	push   %eax
 17f:	e8 ac 03 00 00       	call   530 <stat>
 184:	83 c4 10             	add    $0x10,%esp
 187:	85 c0                	test   %eax,%eax
 189:	78 49                	js     1d4 <main+0x1d4>
	while (size--)
 18b:	8d bd c4 fd ff ff    	lea    -0x23c(%ebp),%edi
	p = buf;
 191:	8d 95 c4 fd ff ff    	lea    -0x23c(%ebp),%edx
	crc = crc ^ ~0U;
 197:	83 c8 ff             	or     $0xffffffff,%eax
 19a:	03 bd e4 fd ff ff    	add    -0x21c(%ebp),%edi
 1a0:	eb 16                	jmp    1b8 <main+0x1b8>
	crc = crc32_tab[(crc ^ *p++) & 0xFF] ^ (crc >> 8);
 1a2:	83 c2 01             	add    $0x1,%edx
 1a5:	0f b6 4a ff          	movzbl -0x1(%edx),%ecx
 1a9:	31 c1                	xor    %eax,%ecx
 1ab:	c1 e8 08             	shr    $0x8,%eax
 1ae:	0f b6 c9             	movzbl %cl,%ecx
 1b1:	33 04 8d a0 0b 00 00 	xor    0xba0(,%ecx,4),%eax
	while (size--)
 1b8:	39 fa                	cmp    %edi,%edx
 1ba:	75 e6                	jne    1a2 <main+0x1a2>
	return crc ^ ~0U;
 1bc:	f7 d0                	not    %eax
			printf(1, "%x\n", crc32(0, &de, st.size));
 1be:	52                   	push   %edx
 1bf:	50                   	push   %eax
 1c0:	68 3c 0b 00 00       	push   $0xb3c
 1c5:	6a 01                	push   $0x1
 1c7:	e8 a4 05 00 00       	call   770 <printf>
 1cc:	83 c4 10             	add    $0x10,%esp
 1cf:	e9 5d ff ff ff       	jmp    131 <main+0x131>
				printf(1, "crc32: cannot stat %s\n", buffer);
 1d4:	8d 85 e8 fd ff ff    	lea    -0x218(%ebp),%eax
 1da:	51                   	push   %ecx
 1db:	50                   	push   %eax
 1dc:	68 57 0b 00 00       	push   $0xb57
 1e1:	6a 01                	push   $0x1
 1e3:	e8 88 05 00 00       	call   770 <printf>
				continue;
 1e8:	83 c4 10             	add    $0x10,%esp
 1eb:	e9 41 ff ff ff       	jmp    131 <main+0x131>

000001f0 <fmtname>:
{
 1f0:	55                   	push   %ebp
 1f1:	89 e5                	mov    %esp,%ebp
 1f3:	56                   	push   %esi
 1f4:	53                   	push   %ebx
 1f5:	8b 75 08             	mov    0x8(%ebp),%esi
  for(p=path+strlen(path); p >= path && *p != '/'; p--)
 1f8:	83 ec 0c             	sub    $0xc,%esp
 1fb:	56                   	push   %esi
 1fc:	e8 1f 02 00 00       	call   420 <strlen>
 201:	83 c4 10             	add    $0x10,%esp
 204:	01 f0                	add    %esi,%eax
 206:	89 c3                	mov    %eax,%ebx
 208:	0f 82 82 00 00 00    	jb     290 <fmtname+0xa0>
 20e:	80 38 2f             	cmpb   $0x2f,(%eax)
 211:	75 0d                	jne    220 <fmtname+0x30>
 213:	eb 7b                	jmp    290 <fmtname+0xa0>
 215:	8d 76 00             	lea    0x0(%esi),%esi
 218:	80 7b ff 2f          	cmpb   $0x2f,-0x1(%ebx)
 21c:	74 09                	je     227 <fmtname+0x37>
 21e:	89 c3                	mov    %eax,%ebx
 220:	8d 43 ff             	lea    -0x1(%ebx),%eax
 223:	39 c6                	cmp    %eax,%esi
 225:	76 f1                	jbe    218 <fmtname+0x28>
  if(strlen(p) >= DIRSIZ)
 227:	83 ec 0c             	sub    $0xc,%esp
 22a:	53                   	push   %ebx
 22b:	e8 f0 01 00 00       	call   420 <strlen>
 230:	83 c4 10             	add    $0x10,%esp
 233:	83 f8 0d             	cmp    $0xd,%eax
 236:	77 4a                	ja     282 <fmtname+0x92>
  memmove(buf, p, strlen(p));
 238:	83 ec 0c             	sub    $0xc,%esp
 23b:	53                   	push   %ebx
 23c:	e8 df 01 00 00       	call   420 <strlen>
 241:	83 c4 0c             	add    $0xc,%esp
 244:	50                   	push   %eax
 245:	53                   	push   %ebx
 246:	68 e8 12 00 00       	push   $0x12e8
 24b:	e8 70 03 00 00       	call   5c0 <memmove>
  memset(buf+strlen(p), ' ', DIRSIZ-strlen(p));
 250:	89 1c 24             	mov    %ebx,(%esp)
 253:	e8 c8 01 00 00       	call   420 <strlen>
 258:	89 1c 24             	mov    %ebx,(%esp)
  return buf;
 25b:	bb e8 12 00 00       	mov    $0x12e8,%ebx
  memset(buf+strlen(p), ' ', DIRSIZ-strlen(p));
 260:	89 c6                	mov    %eax,%esi
 262:	e8 b9 01 00 00       	call   420 <strlen>
 267:	ba 0e 00 00 00       	mov    $0xe,%edx
 26c:	83 c4 0c             	add    $0xc,%esp
 26f:	29 f2                	sub    %esi,%edx
 271:	05 e8 12 00 00       	add    $0x12e8,%eax
 276:	52                   	push   %edx
 277:	6a 20                	push   $0x20
 279:	50                   	push   %eax
 27a:	e8 d1 01 00 00       	call   450 <memset>
  return buf;
 27f:	83 c4 10             	add    $0x10,%esp
}
 282:	8d 65 f8             	lea    -0x8(%ebp),%esp
 285:	89 d8                	mov    %ebx,%eax
 287:	5b                   	pop    %ebx
 288:	5e                   	pop    %esi
 289:	5d                   	pop    %ebp
 28a:	c3                   	ret    
 28b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 28f:	90                   	nop
 290:	83 c3 01             	add    $0x1,%ebx
 293:	eb 92                	jmp    227 <fmtname+0x37>
 295:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 29c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

000002a0 <crc32>:
{
 2a0:	55                   	push   %ebp
 2a1:	89 e5                	mov    %esp,%ebp
 2a3:	53                   	push   %ebx
 2a4:	8b 5d 10             	mov    0x10(%ebp),%ebx
 2a7:	8b 55 0c             	mov    0xc(%ebp),%edx
	crc = crc ^ ~0U;
 2aa:	8b 45 08             	mov    0x8(%ebp),%eax
	while (size--)
 2ad:	85 db                	test   %ebx,%ebx
 2af:	74 2f                	je     2e0 <crc32+0x40>
 2b1:	f7 d0                	not    %eax
 2b3:	01 d3                	add    %edx,%ebx
 2b5:	8d 76 00             	lea    0x0(%esi),%esi
	crc = crc32_tab[(crc ^ *p++) & 0xFF] ^ (crc >> 8);
 2b8:	83 c2 01             	add    $0x1,%edx
 2bb:	0f b6 4a ff          	movzbl -0x1(%edx),%ecx
 2bf:	31 c1                	xor    %eax,%ecx
 2c1:	c1 e8 08             	shr    $0x8,%eax
 2c4:	0f b6 c9             	movzbl %cl,%ecx
 2c7:	33 04 8d a0 0b 00 00 	xor    0xba0(,%ecx,4),%eax
	while (size--)
 2ce:	39 da                	cmp    %ebx,%edx
 2d0:	75 e6                	jne    2b8 <crc32+0x18>
 2d2:	f7 d0                	not    %eax
}
 2d4:	5b                   	pop    %ebx
 2d5:	5d                   	pop    %ebp
 2d6:	c3                   	ret    
 2d7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 2de:	66 90                	xchg   %ax,%ax
	while (size--)
 2e0:	8b 45 08             	mov    0x8(%ebp),%eax
}
 2e3:	5b                   	pop    %ebx
 2e4:	5d                   	pop    %ebp
 2e5:	c3                   	ret    
 2e6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 2ed:	8d 76 00             	lea    0x0(%esi),%esi

000002f0 <crcFile>:
crcFile(int fd, struct stat* st, char* path) {
 2f0:	55                   	push   %ebp
 2f1:	89 e5                	mov    %esp,%ebp
 2f3:	57                   	push   %edi
 2f4:	56                   	push   %esi
 2f5:	53                   	push   %ebx
 2f6:	83 ec 28             	sub    $0x28,%esp
 2f9:	8b 7d 0c             	mov    0xc(%ebp),%edi
 2fc:	8b 45 10             	mov    0x10(%ebp),%eax
 2ff:	8b 75 08             	mov    0x8(%ebp),%esi
  char* buffer = malloc(st->size);
 302:	ff 77 10             	pushl  0x10(%edi)
crcFile(int fd, struct stat* st, char* path) {
 305:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  char* buffer = malloc(st->size);
 308:	e8 c3 06 00 00       	call   9d0 <malloc>
  if(read(fd, buffer, st->size) < 0)
 30d:	83 c4 0c             	add    $0xc,%esp
 310:	ff 77 10             	pushl  0x10(%edi)
 313:	50                   	push   %eax
  char* buffer = malloc(st->size);
 314:	89 c3                	mov    %eax,%ebx
  if(read(fd, buffer, st->size) < 0)
 316:	56                   	push   %esi
 317:	e8 ed 02 00 00       	call   609 <read>
 31c:	83 c4 10             	add    $0x10,%esp
 31f:	85 c0                	test   %eax,%eax
 321:	78 4e                	js     371 <crcFile+0x81>
  printf(1, "%x\n", crc32(0, buffer, st->size));
 323:	8b 47 10             	mov    0x10(%edi),%eax
	while (size--)
 326:	85 c0                	test   %eax,%eax
 328:	74 2a                	je     354 <crcFile+0x64>
 32a:	8d 0c 03             	lea    (%ebx,%eax,1),%ecx
	crc = crc ^ ~0U;
 32d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 332:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
	crc = crc32_tab[(crc ^ *p++) & 0xFF] ^ (crc >> 8);
 338:	83 c3 01             	add    $0x1,%ebx
 33b:	0f b6 53 ff          	movzbl -0x1(%ebx),%edx
 33f:	31 c2                	xor    %eax,%edx
 341:	c1 e8 08             	shr    $0x8,%eax
 344:	0f b6 d2             	movzbl %dl,%edx
 347:	33 04 95 a0 0b 00 00 	xor    0xba0(,%edx,4),%eax
	while (size--)
 34e:	39 cb                	cmp    %ecx,%ebx
 350:	75 e6                	jne    338 <crcFile+0x48>
 352:	f7 d0                	not    %eax
  printf(1, "%x\n", crc32(0, buffer, st->size));
 354:	89 45 10             	mov    %eax,0x10(%ebp)
 357:	c7 45 0c 3c 0b 00 00 	movl   $0xb3c,0xc(%ebp)
 35e:	c7 45 08 01 00 00 00 	movl   $0x1,0x8(%ebp)
}
 365:	8d 65 f4             	lea    -0xc(%ebp),%esp
 368:	5b                   	pop    %ebx
 369:	5e                   	pop    %esi
 36a:	5f                   	pop    %edi
 36b:	5d                   	pop    %ebp
  printf(1, "%x\n", crc32(0, buffer, st->size));
 36c:	e9 ff 03 00 00       	jmp    770 <printf>
	  printf(1, "ERROR: Could not read file %s\n", path);
 371:	50                   	push   %eax
 372:	ff 75 e4             	pushl  -0x1c(%ebp)
 375:	68 e0 0a 00 00       	push   $0xae0
 37a:	6a 01                	push   $0x1
 37c:	e8 ef 03 00 00       	call   770 <printf>
	  close(fd);
 381:	89 34 24             	mov    %esi,(%esp)
 384:	e8 90 02 00 00       	call   619 <close>
	  exit2(-1);
 389:	c7 04 24 ff ff ff ff 	movl   $0xffffffff,(%esp)
 390:	e8 04 03 00 00       	call   699 <exit2>
 395:	66 90                	xchg   %ax,%ax
 397:	66 90                	xchg   %ax,%ax
 399:	66 90                	xchg   %ax,%ax
 39b:	66 90                	xchg   %ax,%ax
 39d:	66 90                	xchg   %ax,%ax
 39f:	90                   	nop

000003a0 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
 3a0:	55                   	push   %ebp
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 3a1:	31 d2                	xor    %edx,%edx
{
 3a3:	89 e5                	mov    %esp,%ebp
 3a5:	53                   	push   %ebx
 3a6:	8b 45 08             	mov    0x8(%ebp),%eax
 3a9:	8b 5d 0c             	mov    0xc(%ebp),%ebx
 3ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while((*s++ = *t++) != 0)
 3b0:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
 3b4:	88 0c 10             	mov    %cl,(%eax,%edx,1)
 3b7:	83 c2 01             	add    $0x1,%edx
 3ba:	84 c9                	test   %cl,%cl
 3bc:	75 f2                	jne    3b0 <strcpy+0x10>
    ;
  return os;
}
 3be:	5b                   	pop    %ebx
 3bf:	5d                   	pop    %ebp
 3c0:	c3                   	ret    
 3c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 3c8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 3cf:	90                   	nop

000003d0 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 3d0:	55                   	push   %ebp
 3d1:	89 e5                	mov    %esp,%ebp
 3d3:	56                   	push   %esi
 3d4:	53                   	push   %ebx
 3d5:	8b 5d 08             	mov    0x8(%ebp),%ebx
 3d8:	8b 75 0c             	mov    0xc(%ebp),%esi
  while(*p && *p == *q)
 3db:	0f b6 13             	movzbl (%ebx),%edx
 3de:	0f b6 0e             	movzbl (%esi),%ecx
 3e1:	84 d2                	test   %dl,%dl
 3e3:	74 1e                	je     403 <strcmp+0x33>
 3e5:	b8 01 00 00 00       	mov    $0x1,%eax
 3ea:	38 ca                	cmp    %cl,%dl
 3ec:	74 09                	je     3f7 <strcmp+0x27>
 3ee:	eb 20                	jmp    410 <strcmp+0x40>
 3f0:	83 c0 01             	add    $0x1,%eax
 3f3:	38 ca                	cmp    %cl,%dl
 3f5:	75 19                	jne    410 <strcmp+0x40>
 3f7:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
 3fb:	0f b6 0c 06          	movzbl (%esi,%eax,1),%ecx
 3ff:	84 d2                	test   %dl,%dl
 401:	75 ed                	jne    3f0 <strcmp+0x20>
 403:	31 c0                	xor    %eax,%eax
    p++, q++;
  return (uchar)*p - (uchar)*q;
}
 405:	5b                   	pop    %ebx
 406:	5e                   	pop    %esi
  return (uchar)*p - (uchar)*q;
 407:	29 c8                	sub    %ecx,%eax
}
 409:	5d                   	pop    %ebp
 40a:	c3                   	ret    
 40b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 40f:	90                   	nop
 410:	0f b6 c2             	movzbl %dl,%eax
 413:	5b                   	pop    %ebx
 414:	5e                   	pop    %esi
  return (uchar)*p - (uchar)*q;
 415:	29 c8                	sub    %ecx,%eax
}
 417:	5d                   	pop    %ebp
 418:	c3                   	ret    
 419:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000420 <strlen>:

uint
strlen(const char *s)
{
 420:	55                   	push   %ebp
 421:	89 e5                	mov    %esp,%ebp
 423:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
 426:	80 39 00             	cmpb   $0x0,(%ecx)
 429:	74 15                	je     440 <strlen+0x20>
 42b:	31 d2                	xor    %edx,%edx
 42d:	8d 76 00             	lea    0x0(%esi),%esi
 430:	83 c2 01             	add    $0x1,%edx
 433:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
 437:	89 d0                	mov    %edx,%eax
 439:	75 f5                	jne    430 <strlen+0x10>
    ;
  return n;
}
 43b:	5d                   	pop    %ebp
 43c:	c3                   	ret    
 43d:	8d 76 00             	lea    0x0(%esi),%esi
  for(n = 0; s[n]; n++)
 440:	31 c0                	xor    %eax,%eax
}
 442:	5d                   	pop    %ebp
 443:	c3                   	ret    
 444:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 44b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 44f:	90                   	nop

00000450 <memset>:

void*
memset(void *dst, int c, uint n)
{
 450:	55                   	push   %ebp
 451:	89 e5                	mov    %esp,%ebp
 453:	57                   	push   %edi
 454:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 457:	8b 4d 10             	mov    0x10(%ebp),%ecx
 45a:	8b 45 0c             	mov    0xc(%ebp),%eax
 45d:	89 d7                	mov    %edx,%edi
 45f:	fc                   	cld    
 460:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 462:	89 d0                	mov    %edx,%eax
 464:	5f                   	pop    %edi
 465:	5d                   	pop    %ebp
 466:	c3                   	ret    
 467:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 46e:	66 90                	xchg   %ax,%ax

00000470 <strchr>:

char*
strchr(const char *s, char c)
{
 470:	55                   	push   %ebp
 471:	89 e5                	mov    %esp,%ebp
 473:	53                   	push   %ebx
 474:	8b 45 08             	mov    0x8(%ebp),%eax
 477:	8b 55 0c             	mov    0xc(%ebp),%edx
  for(; *s; s++)
 47a:	0f b6 18             	movzbl (%eax),%ebx
 47d:	84 db                	test   %bl,%bl
 47f:	74 1d                	je     49e <strchr+0x2e>
 481:	89 d1                	mov    %edx,%ecx
    if(*s == c)
 483:	38 d3                	cmp    %dl,%bl
 485:	75 0d                	jne    494 <strchr+0x24>
 487:	eb 17                	jmp    4a0 <strchr+0x30>
 489:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 490:	38 ca                	cmp    %cl,%dl
 492:	74 0c                	je     4a0 <strchr+0x30>
  for(; *s; s++)
 494:	83 c0 01             	add    $0x1,%eax
 497:	0f b6 10             	movzbl (%eax),%edx
 49a:	84 d2                	test   %dl,%dl
 49c:	75 f2                	jne    490 <strchr+0x20>
      return (char*)s;
  return 0;
 49e:	31 c0                	xor    %eax,%eax
}
 4a0:	5b                   	pop    %ebx
 4a1:	5d                   	pop    %ebp
 4a2:	c3                   	ret    
 4a3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 4aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

000004b0 <gets>:

char*
gets(char *buf, int max)
{
 4b0:	55                   	push   %ebp
 4b1:	89 e5                	mov    %esp,%ebp
 4b3:	57                   	push   %edi
 4b4:	56                   	push   %esi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 4b5:	31 f6                	xor    %esi,%esi
{
 4b7:	53                   	push   %ebx
 4b8:	89 f3                	mov    %esi,%ebx
 4ba:	83 ec 1c             	sub    $0x1c,%esp
 4bd:	8b 7d 08             	mov    0x8(%ebp),%edi
  for(i=0; i+1 < max; ){
 4c0:	eb 2f                	jmp    4f1 <gets+0x41>
 4c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    cc = read(0, &c, 1);
 4c8:	83 ec 04             	sub    $0x4,%esp
 4cb:	8d 45 e7             	lea    -0x19(%ebp),%eax
 4ce:	6a 01                	push   $0x1
 4d0:	50                   	push   %eax
 4d1:	6a 00                	push   $0x0
 4d3:	e8 31 01 00 00       	call   609 <read>
    if(cc < 1)
 4d8:	83 c4 10             	add    $0x10,%esp
 4db:	85 c0                	test   %eax,%eax
 4dd:	7e 1c                	jle    4fb <gets+0x4b>
      break;
    buf[i++] = c;
 4df:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 4e3:	83 c7 01             	add    $0x1,%edi
 4e6:	88 47 ff             	mov    %al,-0x1(%edi)
    if(c == '\n' || c == '\r')
 4e9:	3c 0a                	cmp    $0xa,%al
 4eb:	74 23                	je     510 <gets+0x60>
 4ed:	3c 0d                	cmp    $0xd,%al
 4ef:	74 1f                	je     510 <gets+0x60>
  for(i=0; i+1 < max; ){
 4f1:	83 c3 01             	add    $0x1,%ebx
 4f4:	89 fe                	mov    %edi,%esi
 4f6:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 4f9:	7c cd                	jl     4c8 <gets+0x18>
 4fb:	89 f3                	mov    %esi,%ebx
      break;
  }
  buf[i] = '\0';
  return buf;
}
 4fd:	8b 45 08             	mov    0x8(%ebp),%eax
  buf[i] = '\0';
 500:	c6 03 00             	movb   $0x0,(%ebx)
}
 503:	8d 65 f4             	lea    -0xc(%ebp),%esp
 506:	5b                   	pop    %ebx
 507:	5e                   	pop    %esi
 508:	5f                   	pop    %edi
 509:	5d                   	pop    %ebp
 50a:	c3                   	ret    
 50b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 50f:	90                   	nop
 510:	8b 75 08             	mov    0x8(%ebp),%esi
 513:	8b 45 08             	mov    0x8(%ebp),%eax
 516:	01 de                	add    %ebx,%esi
 518:	89 f3                	mov    %esi,%ebx
  buf[i] = '\0';
 51a:	c6 03 00             	movb   $0x0,(%ebx)
}
 51d:	8d 65 f4             	lea    -0xc(%ebp),%esp
 520:	5b                   	pop    %ebx
 521:	5e                   	pop    %esi
 522:	5f                   	pop    %edi
 523:	5d                   	pop    %ebp
 524:	c3                   	ret    
 525:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 52c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000530 <stat>:

int
stat(const char *n, struct stat *st)
{
 530:	55                   	push   %ebp
 531:	89 e5                	mov    %esp,%ebp
 533:	56                   	push   %esi
 534:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 535:	83 ec 08             	sub    $0x8,%esp
 538:	6a 00                	push   $0x0
 53a:	ff 75 08             	pushl  0x8(%ebp)
 53d:	e8 ef 00 00 00       	call   631 <open>
  if(fd < 0)
 542:	83 c4 10             	add    $0x10,%esp
 545:	85 c0                	test   %eax,%eax
 547:	78 27                	js     570 <stat+0x40>
    return -1;
  r = fstat(fd, st);
 549:	83 ec 08             	sub    $0x8,%esp
 54c:	ff 75 0c             	pushl  0xc(%ebp)
 54f:	89 c3                	mov    %eax,%ebx
 551:	50                   	push   %eax
 552:	e8 f2 00 00 00       	call   649 <fstat>
  close(fd);
 557:	89 1c 24             	mov    %ebx,(%esp)
  r = fstat(fd, st);
 55a:	89 c6                	mov    %eax,%esi
  close(fd);
 55c:	e8 b8 00 00 00       	call   619 <close>
  return r;
 561:	83 c4 10             	add    $0x10,%esp
}
 564:	8d 65 f8             	lea    -0x8(%ebp),%esp
 567:	89 f0                	mov    %esi,%eax
 569:	5b                   	pop    %ebx
 56a:	5e                   	pop    %esi
 56b:	5d                   	pop    %ebp
 56c:	c3                   	ret    
 56d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
 570:	be ff ff ff ff       	mov    $0xffffffff,%esi
 575:	eb ed                	jmp    564 <stat+0x34>
 577:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 57e:	66 90                	xchg   %ax,%ax

00000580 <atoi>:

int
atoi(const char *s)
{
 580:	55                   	push   %ebp
 581:	89 e5                	mov    %esp,%ebp
 583:	53                   	push   %ebx
 584:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 587:	0f be 11             	movsbl (%ecx),%edx
 58a:	8d 42 d0             	lea    -0x30(%edx),%eax
 58d:	3c 09                	cmp    $0x9,%al
  n = 0;
 58f:	b8 00 00 00 00       	mov    $0x0,%eax
  while('0' <= *s && *s <= '9')
 594:	77 1f                	ja     5b5 <atoi+0x35>
 596:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 59d:	8d 76 00             	lea    0x0(%esi),%esi
    n = n*10 + *s++ - '0';
 5a0:	83 c1 01             	add    $0x1,%ecx
 5a3:	8d 04 80             	lea    (%eax,%eax,4),%eax
 5a6:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
  while('0' <= *s && *s <= '9')
 5aa:	0f be 11             	movsbl (%ecx),%edx
 5ad:	8d 5a d0             	lea    -0x30(%edx),%ebx
 5b0:	80 fb 09             	cmp    $0x9,%bl
 5b3:	76 eb                	jbe    5a0 <atoi+0x20>
  return n;
}
 5b5:	5b                   	pop    %ebx
 5b6:	5d                   	pop    %ebp
 5b7:	c3                   	ret    
 5b8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 5bf:	90                   	nop

000005c0 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 5c0:	55                   	push   %ebp
 5c1:	89 e5                	mov    %esp,%ebp
 5c3:	57                   	push   %edi
 5c4:	8b 55 10             	mov    0x10(%ebp),%edx
 5c7:	8b 45 08             	mov    0x8(%ebp),%eax
 5ca:	56                   	push   %esi
 5cb:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 5ce:	85 d2                	test   %edx,%edx
 5d0:	7e 13                	jle    5e5 <memmove+0x25>
 5d2:	01 c2                	add    %eax,%edx
  dst = vdst;
 5d4:	89 c7                	mov    %eax,%edi
 5d6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 5dd:	8d 76 00             	lea    0x0(%esi),%esi
    *dst++ = *src++;
 5e0:	a4                   	movsb  %ds:(%esi),%es:(%edi)
  while(n-- > 0)
 5e1:	39 fa                	cmp    %edi,%edx
 5e3:	75 fb                	jne    5e0 <memmove+0x20>
  return vdst;
}
 5e5:	5e                   	pop    %esi
 5e6:	5f                   	pop    %edi
 5e7:	5d                   	pop    %ebp
 5e8:	c3                   	ret    

000005e9 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 5e9:	b8 01 00 00 00       	mov    $0x1,%eax
 5ee:	cd 40                	int    $0x40
 5f0:	c3                   	ret    

000005f1 <exit>:
SYSCALL(exit)
 5f1:	b8 02 00 00 00       	mov    $0x2,%eax
 5f6:	cd 40                	int    $0x40
 5f8:	c3                   	ret    

000005f9 <wait>:
SYSCALL(wait)
 5f9:	b8 03 00 00 00       	mov    $0x3,%eax
 5fe:	cd 40                	int    $0x40
 600:	c3                   	ret    

00000601 <pipe>:
SYSCALL(pipe)
 601:	b8 04 00 00 00       	mov    $0x4,%eax
 606:	cd 40                	int    $0x40
 608:	c3                   	ret    

00000609 <read>:
SYSCALL(read)
 609:	b8 05 00 00 00       	mov    $0x5,%eax
 60e:	cd 40                	int    $0x40
 610:	c3                   	ret    

00000611 <write>:
SYSCALL(write)
 611:	b8 10 00 00 00       	mov    $0x10,%eax
 616:	cd 40                	int    $0x40
 618:	c3                   	ret    

00000619 <close>:
SYSCALL(close)
 619:	b8 15 00 00 00       	mov    $0x15,%eax
 61e:	cd 40                	int    $0x40
 620:	c3                   	ret    

00000621 <kill>:
SYSCALL(kill)
 621:	b8 06 00 00 00       	mov    $0x6,%eax
 626:	cd 40                	int    $0x40
 628:	c3                   	ret    

00000629 <exec>:
SYSCALL(exec)
 629:	b8 07 00 00 00       	mov    $0x7,%eax
 62e:	cd 40                	int    $0x40
 630:	c3                   	ret    

00000631 <open>:
SYSCALL(open)
 631:	b8 0f 00 00 00       	mov    $0xf,%eax
 636:	cd 40                	int    $0x40
 638:	c3                   	ret    

00000639 <mknod>:
SYSCALL(mknod)
 639:	b8 11 00 00 00       	mov    $0x11,%eax
 63e:	cd 40                	int    $0x40
 640:	c3                   	ret    

00000641 <unlink>:
SYSCALL(unlink)
 641:	b8 12 00 00 00       	mov    $0x12,%eax
 646:	cd 40                	int    $0x40
 648:	c3                   	ret    

00000649 <fstat>:
SYSCALL(fstat)
 649:	b8 08 00 00 00       	mov    $0x8,%eax
 64e:	cd 40                	int    $0x40
 650:	c3                   	ret    

00000651 <link>:
SYSCALL(link)
 651:	b8 13 00 00 00       	mov    $0x13,%eax
 656:	cd 40                	int    $0x40
 658:	c3                   	ret    

00000659 <mkdir>:
SYSCALL(mkdir)
 659:	b8 14 00 00 00       	mov    $0x14,%eax
 65e:	cd 40                	int    $0x40
 660:	c3                   	ret    

00000661 <chdir>:
SYSCALL(chdir)
 661:	b8 09 00 00 00       	mov    $0x9,%eax
 666:	cd 40                	int    $0x40
 668:	c3                   	ret    

00000669 <dup>:
SYSCALL(dup)
 669:	b8 0a 00 00 00       	mov    $0xa,%eax
 66e:	cd 40                	int    $0x40
 670:	c3                   	ret    

00000671 <getpid>:
SYSCALL(getpid)
 671:	b8 0b 00 00 00       	mov    $0xb,%eax
 676:	cd 40                	int    $0x40
 678:	c3                   	ret    

00000679 <sbrk>:
SYSCALL(sbrk)
 679:	b8 0c 00 00 00       	mov    $0xc,%eax
 67e:	cd 40                	int    $0x40
 680:	c3                   	ret    

00000681 <sleep>:
SYSCALL(sleep)
 681:	b8 0d 00 00 00       	mov    $0xd,%eax
 686:	cd 40                	int    $0x40
 688:	c3                   	ret    

00000689 <uptime>:
SYSCALL(uptime)
 689:	b8 0e 00 00 00       	mov    $0xe,%eax
 68e:	cd 40                	int    $0x40
 690:	c3                   	ret    

00000691 <freemem>:
SYSCALL(freemem)
 691:	b8 16 00 00 00       	mov    $0x16,%eax
 696:	cd 40                	int    $0x40
 698:	c3                   	ret    

00000699 <exit2>:
SYSCALL(exit2)
 699:	b8 17 00 00 00       	mov    $0x17,%eax
 69e:	cd 40                	int    $0x40
 6a0:	c3                   	ret    

000006a1 <wait2>:
SYSCALL(wait2)
 6a1:	b8 18 00 00 00       	mov    $0x18,%eax
 6a6:	cd 40                	int    $0x40
 6a8:	c3                   	ret    
 6a9:	66 90                	xchg   %ax,%ax
 6ab:	66 90                	xchg   %ax,%ax
 6ad:	66 90                	xchg   %ax,%ax
 6af:	90                   	nop

000006b0 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 6b0:	55                   	push   %ebp
 6b1:	89 e5                	mov    %esp,%ebp
 6b3:	57                   	push   %edi
 6b4:	56                   	push   %esi
 6b5:	53                   	push   %ebx
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
 6b6:	89 d3                	mov    %edx,%ebx
{
 6b8:	83 ec 3c             	sub    $0x3c,%esp
 6bb:	89 45 bc             	mov    %eax,-0x44(%ebp)
  if(sgn && xx < 0){
 6be:	85 d2                	test   %edx,%edx
 6c0:	0f 89 92 00 00 00    	jns    758 <printint+0xa8>
 6c6:	f6 45 08 01          	testb  $0x1,0x8(%ebp)
 6ca:	0f 84 88 00 00 00    	je     758 <printint+0xa8>
    neg = 1;
 6d0:	c7 45 c0 01 00 00 00 	movl   $0x1,-0x40(%ebp)
    x = -xx;
 6d7:	f7 db                	neg    %ebx
  } else {
    x = xx;
  }

  i = 0;
 6d9:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
 6e0:	8d 75 d7             	lea    -0x29(%ebp),%esi
 6e3:	eb 08                	jmp    6ed <printint+0x3d>
 6e5:	8d 76 00             	lea    0x0(%esi),%esi
  do{
    buf[i++] = digits[x % base];
 6e8:	89 7d c4             	mov    %edi,-0x3c(%ebp)
  }while((x /= base) != 0);
 6eb:	89 c3                	mov    %eax,%ebx
    buf[i++] = digits[x % base];
 6ed:	89 d8                	mov    %ebx,%eax
 6ef:	31 d2                	xor    %edx,%edx
 6f1:	8b 7d c4             	mov    -0x3c(%ebp),%edi
 6f4:	f7 f1                	div    %ecx
 6f6:	83 c7 01             	add    $0x1,%edi
 6f9:	0f b6 92 a8 0f 00 00 	movzbl 0xfa8(%edx),%edx
 700:	88 14 3e             	mov    %dl,(%esi,%edi,1)
  }while((x /= base) != 0);
 703:	39 d9                	cmp    %ebx,%ecx
 705:	76 e1                	jbe    6e8 <printint+0x38>
  if(neg)
 707:	8b 45 c0             	mov    -0x40(%ebp),%eax
 70a:	85 c0                	test   %eax,%eax
 70c:	74 0d                	je     71b <printint+0x6b>
    buf[i++] = '-';
 70e:	c6 44 3d d8 2d       	movb   $0x2d,-0x28(%ebp,%edi,1)
 713:	ba 2d 00 00 00       	mov    $0x2d,%edx
    buf[i++] = digits[x % base];
 718:	89 7d c4             	mov    %edi,-0x3c(%ebp)

  while(--i >= 0)
 71b:	8b 45 c4             	mov    -0x3c(%ebp),%eax
 71e:	8b 7d bc             	mov    -0x44(%ebp),%edi
 721:	8d 5c 05 d7          	lea    -0x29(%ebp,%eax,1),%ebx
 725:	eb 0f                	jmp    736 <printint+0x86>
 727:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 72e:	66 90                	xchg   %ax,%ax
 730:	0f b6 13             	movzbl (%ebx),%edx
 733:	83 eb 01             	sub    $0x1,%ebx
  write(fd, &c, 1);
 736:	83 ec 04             	sub    $0x4,%esp
 739:	88 55 d7             	mov    %dl,-0x29(%ebp)
 73c:	6a 01                	push   $0x1
 73e:	56                   	push   %esi
 73f:	57                   	push   %edi
 740:	e8 cc fe ff ff       	call   611 <write>
  while(--i >= 0)
 745:	83 c4 10             	add    $0x10,%esp
 748:	39 de                	cmp    %ebx,%esi
 74a:	75 e4                	jne    730 <printint+0x80>
    putc(fd, buf[i]);
}
 74c:	8d 65 f4             	lea    -0xc(%ebp),%esp
 74f:	5b                   	pop    %ebx
 750:	5e                   	pop    %esi
 751:	5f                   	pop    %edi
 752:	5d                   	pop    %ebp
 753:	c3                   	ret    
 754:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  neg = 0;
 758:	c7 45 c0 00 00 00 00 	movl   $0x0,-0x40(%ebp)
 75f:	e9 75 ff ff ff       	jmp    6d9 <printint+0x29>
 764:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 76b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 76f:	90                   	nop

00000770 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 770:	55                   	push   %ebp
 771:	89 e5                	mov    %esp,%ebp
 773:	57                   	push   %edi
 774:	56                   	push   %esi
 775:	53                   	push   %ebx
 776:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 779:	8b 75 0c             	mov    0xc(%ebp),%esi
 77c:	0f b6 1e             	movzbl (%esi),%ebx
 77f:	84 db                	test   %bl,%bl
 781:	0f 84 b9 00 00 00    	je     840 <printf+0xd0>
  ap = (uint*)(void*)&fmt + 1;
 787:	8d 45 10             	lea    0x10(%ebp),%eax
 78a:	83 c6 01             	add    $0x1,%esi
  write(fd, &c, 1);
 78d:	8d 7d e7             	lea    -0x19(%ebp),%edi
  state = 0;
 790:	31 d2                	xor    %edx,%edx
  ap = (uint*)(void*)&fmt + 1;
 792:	89 45 d0             	mov    %eax,-0x30(%ebp)
 795:	eb 38                	jmp    7cf <printf+0x5f>
 797:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 79e:	66 90                	xchg   %ax,%ax
 7a0:	89 55 d4             	mov    %edx,-0x2c(%ebp)
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
 7a3:	ba 25 00 00 00       	mov    $0x25,%edx
      if(c == '%'){
 7a8:	83 f8 25             	cmp    $0x25,%eax
 7ab:	74 17                	je     7c4 <printf+0x54>
  write(fd, &c, 1);
 7ad:	83 ec 04             	sub    $0x4,%esp
 7b0:	88 5d e7             	mov    %bl,-0x19(%ebp)
 7b3:	6a 01                	push   $0x1
 7b5:	57                   	push   %edi
 7b6:	ff 75 08             	pushl  0x8(%ebp)
 7b9:	e8 53 fe ff ff       	call   611 <write>
 7be:	8b 55 d4             	mov    -0x2c(%ebp),%edx
      } else {
        putc(fd, c);
 7c1:	83 c4 10             	add    $0x10,%esp
  for(i = 0; fmt[i]; i++){
 7c4:	83 c6 01             	add    $0x1,%esi
 7c7:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
 7cb:	84 db                	test   %bl,%bl
 7cd:	74 71                	je     840 <printf+0xd0>
    c = fmt[i] & 0xff;
 7cf:	0f be cb             	movsbl %bl,%ecx
 7d2:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
 7d5:	85 d2                	test   %edx,%edx
 7d7:	74 c7                	je     7a0 <printf+0x30>
      }
    } else if(state == '%'){
 7d9:	83 fa 25             	cmp    $0x25,%edx
 7dc:	75 e6                	jne    7c4 <printf+0x54>
      if(c == 'd'){
 7de:	83 f8 64             	cmp    $0x64,%eax
 7e1:	0f 84 99 00 00 00    	je     880 <printf+0x110>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 7e7:	81 e1 f7 00 00 00    	and    $0xf7,%ecx
 7ed:	83 f9 70             	cmp    $0x70,%ecx
 7f0:	74 5e                	je     850 <printf+0xe0>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 7f2:	83 f8 73             	cmp    $0x73,%eax
 7f5:	0f 84 d5 00 00 00    	je     8d0 <printf+0x160>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 7fb:	83 f8 63             	cmp    $0x63,%eax
 7fe:	0f 84 8c 00 00 00    	je     890 <printf+0x120>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 804:	83 f8 25             	cmp    $0x25,%eax
 807:	0f 84 b3 00 00 00    	je     8c0 <printf+0x150>
  write(fd, &c, 1);
 80d:	83 ec 04             	sub    $0x4,%esp
 810:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
 814:	6a 01                	push   $0x1
 816:	57                   	push   %edi
 817:	ff 75 08             	pushl  0x8(%ebp)
 81a:	e8 f2 fd ff ff       	call   611 <write>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
 81f:	88 5d e7             	mov    %bl,-0x19(%ebp)
  write(fd, &c, 1);
 822:	83 c4 0c             	add    $0xc,%esp
 825:	6a 01                	push   $0x1
 827:	83 c6 01             	add    $0x1,%esi
 82a:	57                   	push   %edi
 82b:	ff 75 08             	pushl  0x8(%ebp)
 82e:	e8 de fd ff ff       	call   611 <write>
  for(i = 0; fmt[i]; i++){
 833:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
        putc(fd, c);
 837:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 83a:	31 d2                	xor    %edx,%edx
  for(i = 0; fmt[i]; i++){
 83c:	84 db                	test   %bl,%bl
 83e:	75 8f                	jne    7cf <printf+0x5f>
    }
  }
}
 840:	8d 65 f4             	lea    -0xc(%ebp),%esp
 843:	5b                   	pop    %ebx
 844:	5e                   	pop    %esi
 845:	5f                   	pop    %edi
 846:	5d                   	pop    %ebp
 847:	c3                   	ret    
 848:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 84f:	90                   	nop
        printint(fd, *ap, 16, 0);
 850:	83 ec 0c             	sub    $0xc,%esp
 853:	b9 10 00 00 00       	mov    $0x10,%ecx
 858:	6a 00                	push   $0x0
 85a:	8b 5d d0             	mov    -0x30(%ebp),%ebx
 85d:	8b 45 08             	mov    0x8(%ebp),%eax
 860:	8b 13                	mov    (%ebx),%edx
 862:	e8 49 fe ff ff       	call   6b0 <printint>
        ap++;
 867:	89 d8                	mov    %ebx,%eax
 869:	83 c4 10             	add    $0x10,%esp
      state = 0;
 86c:	31 d2                	xor    %edx,%edx
        ap++;
 86e:	83 c0 04             	add    $0x4,%eax
 871:	89 45 d0             	mov    %eax,-0x30(%ebp)
 874:	e9 4b ff ff ff       	jmp    7c4 <printf+0x54>
 879:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        printint(fd, *ap, 10, 1);
 880:	83 ec 0c             	sub    $0xc,%esp
 883:	b9 0a 00 00 00       	mov    $0xa,%ecx
 888:	6a 01                	push   $0x1
 88a:	eb ce                	jmp    85a <printf+0xea>
 88c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        putc(fd, *ap);
 890:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  write(fd, &c, 1);
 893:	83 ec 04             	sub    $0x4,%esp
        putc(fd, *ap);
 896:	8b 03                	mov    (%ebx),%eax
  write(fd, &c, 1);
 898:	6a 01                	push   $0x1
        ap++;
 89a:	83 c3 04             	add    $0x4,%ebx
  write(fd, &c, 1);
 89d:	57                   	push   %edi
 89e:	ff 75 08             	pushl  0x8(%ebp)
        putc(fd, *ap);
 8a1:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 8a4:	e8 68 fd ff ff       	call   611 <write>
        ap++;
 8a9:	89 5d d0             	mov    %ebx,-0x30(%ebp)
 8ac:	83 c4 10             	add    $0x10,%esp
      state = 0;
 8af:	31 d2                	xor    %edx,%edx
 8b1:	e9 0e ff ff ff       	jmp    7c4 <printf+0x54>
 8b6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 8bd:	8d 76 00             	lea    0x0(%esi),%esi
        putc(fd, c);
 8c0:	88 5d e7             	mov    %bl,-0x19(%ebp)
  write(fd, &c, 1);
 8c3:	83 ec 04             	sub    $0x4,%esp
 8c6:	e9 5a ff ff ff       	jmp    825 <printf+0xb5>
 8cb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 8cf:	90                   	nop
        s = (char*)*ap;
 8d0:	8b 45 d0             	mov    -0x30(%ebp),%eax
 8d3:	8b 18                	mov    (%eax),%ebx
        ap++;
 8d5:	83 c0 04             	add    $0x4,%eax
 8d8:	89 45 d0             	mov    %eax,-0x30(%ebp)
        if(s == 0)
 8db:	85 db                	test   %ebx,%ebx
 8dd:	74 17                	je     8f6 <printf+0x186>
        while(*s != 0){
 8df:	0f b6 03             	movzbl (%ebx),%eax
      state = 0;
 8e2:	31 d2                	xor    %edx,%edx
        while(*s != 0){
 8e4:	84 c0                	test   %al,%al
 8e6:	0f 84 d8 fe ff ff    	je     7c4 <printf+0x54>
 8ec:	89 75 d4             	mov    %esi,-0x2c(%ebp)
 8ef:	89 de                	mov    %ebx,%esi
 8f1:	8b 5d 08             	mov    0x8(%ebp),%ebx
 8f4:	eb 1a                	jmp    910 <printf+0x1a0>
          s = "(null)";
 8f6:	bb a0 0f 00 00       	mov    $0xfa0,%ebx
        while(*s != 0){
 8fb:	89 75 d4             	mov    %esi,-0x2c(%ebp)
 8fe:	b8 28 00 00 00       	mov    $0x28,%eax
 903:	89 de                	mov    %ebx,%esi
 905:	8b 5d 08             	mov    0x8(%ebp),%ebx
 908:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 90f:	90                   	nop
  write(fd, &c, 1);
 910:	83 ec 04             	sub    $0x4,%esp
          s++;
 913:	83 c6 01             	add    $0x1,%esi
 916:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 919:	6a 01                	push   $0x1
 91b:	57                   	push   %edi
 91c:	53                   	push   %ebx
 91d:	e8 ef fc ff ff       	call   611 <write>
        while(*s != 0){
 922:	0f b6 06             	movzbl (%esi),%eax
 925:	83 c4 10             	add    $0x10,%esp
 928:	84 c0                	test   %al,%al
 92a:	75 e4                	jne    910 <printf+0x1a0>
 92c:	8b 75 d4             	mov    -0x2c(%ebp),%esi
      state = 0;
 92f:	31 d2                	xor    %edx,%edx
 931:	e9 8e fe ff ff       	jmp    7c4 <printf+0x54>
 936:	66 90                	xchg   %ax,%ax
 938:	66 90                	xchg   %ax,%ax
 93a:	66 90                	xchg   %ax,%ax
 93c:	66 90                	xchg   %ax,%ax
 93e:	66 90                	xchg   %ax,%ax

00000940 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 940:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 941:	a1 f8 12 00 00       	mov    0x12f8,%eax
{
 946:	89 e5                	mov    %esp,%ebp
 948:	57                   	push   %edi
 949:	56                   	push   %esi
 94a:	53                   	push   %ebx
 94b:	8b 5d 08             	mov    0x8(%ebp),%ebx
 94e:	8b 10                	mov    (%eax),%edx
  bp = (Header*)ap - 1;
 950:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 953:	39 c8                	cmp    %ecx,%eax
 955:	73 19                	jae    970 <free+0x30>
 957:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 95e:	66 90                	xchg   %ax,%ax
 960:	39 d1                	cmp    %edx,%ecx
 962:	72 14                	jb     978 <free+0x38>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 964:	39 d0                	cmp    %edx,%eax
 966:	73 10                	jae    978 <free+0x38>
{
 968:	89 d0                	mov    %edx,%eax
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 96a:	8b 10                	mov    (%eax),%edx
 96c:	39 c8                	cmp    %ecx,%eax
 96e:	72 f0                	jb     960 <free+0x20>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 970:	39 d0                	cmp    %edx,%eax
 972:	72 f4                	jb     968 <free+0x28>
 974:	39 d1                	cmp    %edx,%ecx
 976:	73 f0                	jae    968 <free+0x28>
      break;
  if(bp + bp->s.size == p->s.ptr){
 978:	8b 73 fc             	mov    -0x4(%ebx),%esi
 97b:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 97e:	39 fa                	cmp    %edi,%edx
 980:	74 1e                	je     9a0 <free+0x60>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 982:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 985:	8b 50 04             	mov    0x4(%eax),%edx
 988:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 98b:	39 f1                	cmp    %esi,%ecx
 98d:	74 28                	je     9b7 <free+0x77>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 98f:	89 08                	mov    %ecx,(%eax)
  freep = p;
}
 991:	5b                   	pop    %ebx
  freep = p;
 992:	a3 f8 12 00 00       	mov    %eax,0x12f8
}
 997:	5e                   	pop    %esi
 998:	5f                   	pop    %edi
 999:	5d                   	pop    %ebp
 99a:	c3                   	ret    
 99b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 99f:	90                   	nop
    bp->s.size += p->s.ptr->s.size;
 9a0:	03 72 04             	add    0x4(%edx),%esi
 9a3:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 9a6:	8b 10                	mov    (%eax),%edx
 9a8:	8b 12                	mov    (%edx),%edx
 9aa:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 9ad:	8b 50 04             	mov    0x4(%eax),%edx
 9b0:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 9b3:	39 f1                	cmp    %esi,%ecx
 9b5:	75 d8                	jne    98f <free+0x4f>
    p->s.size += bp->s.size;
 9b7:	03 53 fc             	add    -0x4(%ebx),%edx
  freep = p;
 9ba:	a3 f8 12 00 00       	mov    %eax,0x12f8
    p->s.size += bp->s.size;
 9bf:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 9c2:	8b 53 f8             	mov    -0x8(%ebx),%edx
 9c5:	89 10                	mov    %edx,(%eax)
}
 9c7:	5b                   	pop    %ebx
 9c8:	5e                   	pop    %esi
 9c9:	5f                   	pop    %edi
 9ca:	5d                   	pop    %ebp
 9cb:	c3                   	ret    
 9cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

000009d0 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 9d0:	55                   	push   %ebp
 9d1:	89 e5                	mov    %esp,%ebp
 9d3:	57                   	push   %edi
 9d4:	56                   	push   %esi
 9d5:	53                   	push   %ebx
 9d6:	83 ec 1c             	sub    $0x1c,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 9d9:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
 9dc:	8b 3d f8 12 00 00    	mov    0x12f8,%edi
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 9e2:	8d 70 07             	lea    0x7(%eax),%esi
 9e5:	c1 ee 03             	shr    $0x3,%esi
 9e8:	83 c6 01             	add    $0x1,%esi
  if((prevp = freep) == 0){
 9eb:	85 ff                	test   %edi,%edi
 9ed:	0f 84 ad 00 00 00    	je     aa0 <malloc+0xd0>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 9f3:	8b 17                	mov    (%edi),%edx
    if(p->s.size >= nunits){
 9f5:	8b 4a 04             	mov    0x4(%edx),%ecx
 9f8:	39 f1                	cmp    %esi,%ecx
 9fa:	73 72                	jae    a6e <malloc+0x9e>
 9fc:	81 fe 00 10 00 00    	cmp    $0x1000,%esi
 a02:	bb 00 10 00 00       	mov    $0x1000,%ebx
 a07:	0f 43 de             	cmovae %esi,%ebx
  p = sbrk(nu * sizeof(Header));
 a0a:	8d 04 dd 00 00 00 00 	lea    0x0(,%ebx,8),%eax
 a11:	89 45 e4             	mov    %eax,-0x1c(%ebp)
 a14:	eb 1b                	jmp    a31 <malloc+0x61>
 a16:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 a1d:	8d 76 00             	lea    0x0(%esi),%esi
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a20:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 a22:	8b 48 04             	mov    0x4(%eax),%ecx
 a25:	39 f1                	cmp    %esi,%ecx
 a27:	73 4f                	jae    a78 <malloc+0xa8>
 a29:	8b 3d f8 12 00 00    	mov    0x12f8,%edi
 a2f:	89 c2                	mov    %eax,%edx
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 a31:	39 d7                	cmp    %edx,%edi
 a33:	75 eb                	jne    a20 <malloc+0x50>
  p = sbrk(nu * sizeof(Header));
 a35:	83 ec 0c             	sub    $0xc,%esp
 a38:	ff 75 e4             	pushl  -0x1c(%ebp)
 a3b:	e8 39 fc ff ff       	call   679 <sbrk>
  if(p == (char*)-1)
 a40:	83 c4 10             	add    $0x10,%esp
 a43:	83 f8 ff             	cmp    $0xffffffff,%eax
 a46:	74 1c                	je     a64 <malloc+0x94>
  hp->s.size = nu;
 a48:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 a4b:	83 ec 0c             	sub    $0xc,%esp
 a4e:	83 c0 08             	add    $0x8,%eax
 a51:	50                   	push   %eax
 a52:	e8 e9 fe ff ff       	call   940 <free>
  return freep;
 a57:	8b 15 f8 12 00 00    	mov    0x12f8,%edx
      if((p = morecore(nunits)) == 0)
 a5d:	83 c4 10             	add    $0x10,%esp
 a60:	85 d2                	test   %edx,%edx
 a62:	75 bc                	jne    a20 <malloc+0x50>
        return 0;
  }
}
 a64:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return 0;
 a67:	31 c0                	xor    %eax,%eax
}
 a69:	5b                   	pop    %ebx
 a6a:	5e                   	pop    %esi
 a6b:	5f                   	pop    %edi
 a6c:	5d                   	pop    %ebp
 a6d:	c3                   	ret    
    if(p->s.size >= nunits){
 a6e:	89 d0                	mov    %edx,%eax
 a70:	89 fa                	mov    %edi,%edx
 a72:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      if(p->s.size == nunits)
 a78:	39 ce                	cmp    %ecx,%esi
 a7a:	74 54                	je     ad0 <malloc+0x100>
        p->s.size -= nunits;
 a7c:	29 f1                	sub    %esi,%ecx
 a7e:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
 a81:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
 a84:	89 70 04             	mov    %esi,0x4(%eax)
      freep = prevp;
 a87:	89 15 f8 12 00 00    	mov    %edx,0x12f8
}
 a8d:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return (void*)(p + 1);
 a90:	83 c0 08             	add    $0x8,%eax
}
 a93:	5b                   	pop    %ebx
 a94:	5e                   	pop    %esi
 a95:	5f                   	pop    %edi
 a96:	5d                   	pop    %ebp
 a97:	c3                   	ret    
 a98:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 a9f:	90                   	nop
    base.s.ptr = freep = prevp = &base;
 aa0:	c7 05 f8 12 00 00 fc 	movl   $0x12fc,0x12f8
 aa7:	12 00 00 
    base.s.size = 0;
 aaa:	bf fc 12 00 00       	mov    $0x12fc,%edi
    base.s.ptr = freep = prevp = &base;
 aaf:	c7 05 fc 12 00 00 fc 	movl   $0x12fc,0x12fc
 ab6:	12 00 00 
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 ab9:	89 fa                	mov    %edi,%edx
    base.s.size = 0;
 abb:	c7 05 00 13 00 00 00 	movl   $0x0,0x1300
 ac2:	00 00 00 
    if(p->s.size >= nunits){
 ac5:	e9 32 ff ff ff       	jmp    9fc <malloc+0x2c>
 aca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        prevp->s.ptr = p->s.ptr;
 ad0:	8b 08                	mov    (%eax),%ecx
 ad2:	89 0a                	mov    %ecx,(%edx)
 ad4:	eb b1                	jmp    a87 <malloc+0xb7>
