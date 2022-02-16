
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
  21:	68 40 0b 00 00       	push   $0xb40
  26:	6a 01                	push   $0x1
  28:	e8 73 07 00 00       	call   7a0 <printf>
    exit2(-1);
  2d:	c7 04 24 ff ff ff ff 	movl   $0xffffffff,(%esp)
  34:	e8 90 06 00 00       	call   6c9 <exit2>
  }

  if((fd = open(argv[1], 0)) < 0){
  39:	50                   	push   %eax
  3a:	50                   	push   %eax
  3b:	6a 00                	push   $0x0
  3d:	ff 77 04             	pushl  0x4(%edi)
  40:	e8 1c 06 00 00       	call   661 <open>
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
  58:	e8 1c 06 00 00       	call   679 <fstat>
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
  7d:	e8 9e 02 00 00       	call   320 <crcFile>
		break;
  82:	83 c4 10             	add    $0x10,%esp
			}
			
		}
		break;
  }
  exit();
  85:	e8 97 05 00 00       	call   621 <exit>
    printf(2, "crc32: cannot stat %s\n", argv[1]);
  8a:	50                   	push   %eax
  8b:	ff 77 04             	pushl  0x4(%edi)
  8e:	68 97 0b 00 00       	push   $0xb97
  93:	6a 02                	push   $0x2
  95:	e8 06 07 00 00       	call   7a0 <printf>
    close(fd);
  9a:	89 1c 24             	mov    %ebx,(%esp)
  9d:	e8 a7 05 00 00       	call   649 <close>
    exit2(-1);
  a2:	c7 04 24 ff ff ff ff 	movl   $0xffffffff,(%esp)
  a9:	e8 1b 06 00 00       	call   6c9 <exit2>
    printf(2, "crc32: cannot open %s\n", argv[1]);
  ae:	50                   	push   %eax
  af:	ff 77 04             	pushl  0x4(%edi)
  b2:	68 80 0b 00 00       	push   $0xb80
  b7:	6a 02                	push   $0x2
  b9:	e8 e2 06 00 00       	call   7a0 <printf>
	exit2(-1);
  be:	c7 04 24 ff ff ff ff 	movl   $0xffffffff,(%esp)
  c5:	e8 ff 05 00 00       	call   6c9 <exit2>
	    if(strlen(argv[1]) + 1 + DIRSIZ + 1 > sizeof buffer){
  ca:	83 ec 0c             	sub    $0xc,%esp
  cd:	ff 77 04             	pushl  0x4(%edi)
  d0:	e8 7b 03 00 00       	call   450 <strlen>
  d5:	83 c4 10             	add    $0x10,%esp
  d8:	83 c0 10             	add    $0x10,%eax
  db:	3d 00 02 00 00       	cmp    $0x200,%eax
  e0:	76 13                	jbe    f5 <main+0xf5>
			printf(1, "CRC32: path too long\n");
  e2:	53                   	push   %ebx
  e3:	53                   	push   %ebx
  e4:	68 ae 0b 00 00       	push   $0xbae
  e9:	6a 01                	push   $0x1
  eb:	e8 b0 06 00 00       	call   7a0 <printf>
			break;
  f0:	83 c4 10             	add    $0x10,%esp
  f3:	eb 90                	jmp    85 <main+0x85>
		strcpy(buffer, argv[1]);
  f5:	8d 85 e8 fd ff ff    	lea    -0x218(%ebp),%eax
  fb:	51                   	push   %ecx
  fc:	51                   	push   %ecx
  fd:	ff 77 04             	pushl  0x4(%edi)
 100:	50                   	push   %eax
 101:	e8 ca 02 00 00       	call   3d0 <strcpy>
		p = buffer+strlen(buffer);
 106:	8d 85 e8 fd ff ff    	lea    -0x218(%ebp),%eax
 10c:	89 04 24             	mov    %eax,(%esp)
 10f:	e8 3c 03 00 00       	call   450 <strlen>
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
 13c:	e8 f8 04 00 00       	call   639 <read>
 141:	83 c4 10             	add    $0x10,%esp
 144:	85 c0                	test   %eax,%eax
 146:	0f 84 39 ff ff ff    	je     85 <main+0x85>
			pid = fork();
 14c:	e8 c8 04 00 00       	call   619 <fork>
			if(pid == 0) {
 151:	85 c0                	test   %eax,%eax
 153:	0f 85 88 00 00 00    	jne    1e1 <main+0x1e1>
				if(de.inum == 0) {
 159:	66 83 bd c4 fd ff ff 	cmpw   $0x0,-0x23c(%ebp)
 160:	00 
 161:	74 ce                	je     131 <main+0x131>
				memmove(p, de.name, DIRSIZ);
 163:	8d 85 c6 fd ff ff    	lea    -0x23a(%ebp),%eax
 169:	57                   	push   %edi
 16a:	6a 0e                	push   $0xe
 16c:	50                   	push   %eax
 16d:	ff b5 b0 fd ff ff    	pushl  -0x250(%ebp)
 173:	e8 78 04 00 00       	call   5f0 <memmove>
				p[DIRSIZ] = 0;
 178:	8b 85 b4 fd ff ff    	mov    -0x24c(%ebp),%eax
 17e:	c6 40 0f 00          	movb   $0x0,0xf(%eax)
				if(stat(buffer, &st) < 0) {
 182:	58                   	pop    %eax
 183:	8d 85 e8 fd ff ff    	lea    -0x218(%ebp),%eax
 189:	5a                   	pop    %edx
 18a:	56                   	push   %esi
 18b:	50                   	push   %eax
 18c:	e8 cf 03 00 00       	call   560 <stat>
 191:	83 c4 10             	add    $0x10,%esp
 194:	85 c0                	test   %eax,%eax
 196:	78 60                	js     1f8 <main+0x1f8>
	while (size--)
 198:	8d bd c4 fd ff ff    	lea    -0x23c(%ebp),%edi
	p = buf;
 19e:	8d 95 c4 fd ff ff    	lea    -0x23c(%ebp),%edx
	crc = crc ^ ~0U;
 1a4:	83 c8 ff             	or     $0xffffffff,%eax
 1a7:	03 bd e4 fd ff ff    	add    -0x21c(%ebp),%edi
 1ad:	eb 16                	jmp    1c5 <main+0x1c5>
	crc = crc32_tab[(crc ^ *p++) & 0xFF] ^ (crc >> 8);
 1af:	83 c2 01             	add    $0x1,%edx
 1b2:	0f b6 4a ff          	movzbl -0x1(%edx),%ecx
 1b6:	31 c1                	xor    %eax,%ecx
 1b8:	c1 e8 08             	shr    $0x8,%eax
 1bb:	0f b6 c9             	movzbl %cl,%ecx
 1be:	33 04 8d e0 0b 00 00 	xor    0xbe0(,%ecx,4),%eax
	while (size--)
 1c5:	39 d7                	cmp    %edx,%edi
 1c7:	75 e6                	jne    1af <main+0x1af>
	return crc ^ ~0U;
 1c9:	f7 d0                	not    %eax
				printf(1, "%x\n", crc32(0, &de, st.size));
 1cb:	52                   	push   %edx
 1cc:	50                   	push   %eax
 1cd:	68 7c 0b 00 00       	push   $0xb7c
 1d2:	6a 01                	push   $0x1
 1d4:	e8 c7 05 00 00       	call   7a0 <printf>
 1d9:	83 c4 10             	add    $0x10,%esp
 1dc:	e9 50 ff ff ff       	jmp    131 <main+0x131>
				wait2(&exitStatus);
 1e1:	83 ec 0c             	sub    $0xc,%esp
 1e4:	8d 85 c0 fd ff ff    	lea    -0x240(%ebp),%eax
 1ea:	50                   	push   %eax
 1eb:	e8 e1 04 00 00       	call   6d1 <wait2>
 1f0:	83 c4 10             	add    $0x10,%esp
 1f3:	e9 39 ff ff ff       	jmp    131 <main+0x131>
					printf(1, "crc32: cannot stat %s\n", buffer);
 1f8:	8d 85 e8 fd ff ff    	lea    -0x218(%ebp),%eax
 1fe:	51                   	push   %ecx
 1ff:	50                   	push   %eax
 200:	68 97 0b 00 00       	push   $0xb97
 205:	6a 01                	push   $0x1
 207:	e8 94 05 00 00       	call   7a0 <printf>
					continue;
 20c:	83 c4 10             	add    $0x10,%esp
 20f:	e9 1d ff ff ff       	jmp    131 <main+0x131>
 214:	66 90                	xchg   %ax,%ax
 216:	66 90                	xchg   %ax,%ax
 218:	66 90                	xchg   %ax,%ax
 21a:	66 90                	xchg   %ax,%ax
 21c:	66 90                	xchg   %ax,%ax
 21e:	66 90                	xchg   %ax,%ax

00000220 <fmtname>:
{
 220:	55                   	push   %ebp
 221:	89 e5                	mov    %esp,%ebp
 223:	56                   	push   %esi
 224:	53                   	push   %ebx
 225:	8b 75 08             	mov    0x8(%ebp),%esi
  for(p=path+strlen(path); p >= path && *p != '/'; p--)
 228:	83 ec 0c             	sub    $0xc,%esp
 22b:	56                   	push   %esi
 22c:	e8 1f 02 00 00       	call   450 <strlen>
 231:	83 c4 10             	add    $0x10,%esp
 234:	01 f0                	add    %esi,%eax
 236:	89 c3                	mov    %eax,%ebx
 238:	0f 82 82 00 00 00    	jb     2c0 <fmtname+0xa0>
 23e:	80 38 2f             	cmpb   $0x2f,(%eax)
 241:	75 0d                	jne    250 <fmtname+0x30>
 243:	eb 7b                	jmp    2c0 <fmtname+0xa0>
 245:	8d 76 00             	lea    0x0(%esi),%esi
 248:	80 7b ff 2f          	cmpb   $0x2f,-0x1(%ebx)
 24c:	74 09                	je     257 <fmtname+0x37>
 24e:	89 c3                	mov    %eax,%ebx
 250:	8d 43 ff             	lea    -0x1(%ebx),%eax
 253:	39 c6                	cmp    %eax,%esi
 255:	76 f1                	jbe    248 <fmtname+0x28>
  if(strlen(p) >= DIRSIZ)
 257:	83 ec 0c             	sub    $0xc,%esp
 25a:	53                   	push   %ebx
 25b:	e8 f0 01 00 00       	call   450 <strlen>
 260:	83 c4 10             	add    $0x10,%esp
 263:	83 f8 0d             	cmp    $0xd,%eax
 266:	77 4a                	ja     2b2 <fmtname+0x92>
  memmove(buf, p, strlen(p));
 268:	83 ec 0c             	sub    $0xc,%esp
 26b:	53                   	push   %ebx
 26c:	e8 df 01 00 00       	call   450 <strlen>
 271:	83 c4 0c             	add    $0xc,%esp
 274:	50                   	push   %eax
 275:	53                   	push   %ebx
 276:	68 28 13 00 00       	push   $0x1328
 27b:	e8 70 03 00 00       	call   5f0 <memmove>
  memset(buf+strlen(p), ' ', DIRSIZ-strlen(p));
 280:	89 1c 24             	mov    %ebx,(%esp)
 283:	e8 c8 01 00 00       	call   450 <strlen>
 288:	89 1c 24             	mov    %ebx,(%esp)
  return buf;
 28b:	bb 28 13 00 00       	mov    $0x1328,%ebx
  memset(buf+strlen(p), ' ', DIRSIZ-strlen(p));
 290:	89 c6                	mov    %eax,%esi
 292:	e8 b9 01 00 00       	call   450 <strlen>
 297:	ba 0e 00 00 00       	mov    $0xe,%edx
 29c:	83 c4 0c             	add    $0xc,%esp
 29f:	29 f2                	sub    %esi,%edx
 2a1:	05 28 13 00 00       	add    $0x1328,%eax
 2a6:	52                   	push   %edx
 2a7:	6a 20                	push   $0x20
 2a9:	50                   	push   %eax
 2aa:	e8 d1 01 00 00       	call   480 <memset>
  return buf;
 2af:	83 c4 10             	add    $0x10,%esp
}
 2b2:	8d 65 f8             	lea    -0x8(%ebp),%esp
 2b5:	89 d8                	mov    %ebx,%eax
 2b7:	5b                   	pop    %ebx
 2b8:	5e                   	pop    %esi
 2b9:	5d                   	pop    %ebp
 2ba:	c3                   	ret    
 2bb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 2bf:	90                   	nop
 2c0:	83 c3 01             	add    $0x1,%ebx
 2c3:	eb 92                	jmp    257 <fmtname+0x37>
 2c5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 2cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

000002d0 <crc32>:
{
 2d0:	55                   	push   %ebp
 2d1:	89 e5                	mov    %esp,%ebp
 2d3:	53                   	push   %ebx
 2d4:	8b 5d 10             	mov    0x10(%ebp),%ebx
 2d7:	8b 55 0c             	mov    0xc(%ebp),%edx
	crc = crc ^ ~0U;
 2da:	8b 45 08             	mov    0x8(%ebp),%eax
	while (size--)
 2dd:	85 db                	test   %ebx,%ebx
 2df:	74 2f                	je     310 <crc32+0x40>
 2e1:	f7 d0                	not    %eax
 2e3:	01 d3                	add    %edx,%ebx
 2e5:	8d 76 00             	lea    0x0(%esi),%esi
	crc = crc32_tab[(crc ^ *p++) & 0xFF] ^ (crc >> 8);
 2e8:	83 c2 01             	add    $0x1,%edx
 2eb:	0f b6 4a ff          	movzbl -0x1(%edx),%ecx
 2ef:	31 c1                	xor    %eax,%ecx
 2f1:	c1 e8 08             	shr    $0x8,%eax
 2f4:	0f b6 c9             	movzbl %cl,%ecx
 2f7:	33 04 8d e0 0b 00 00 	xor    0xbe0(,%ecx,4),%eax
	while (size--)
 2fe:	39 da                	cmp    %ebx,%edx
 300:	75 e6                	jne    2e8 <crc32+0x18>
 302:	f7 d0                	not    %eax
}
 304:	5b                   	pop    %ebx
 305:	5d                   	pop    %ebp
 306:	c3                   	ret    
 307:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 30e:	66 90                	xchg   %ax,%ax
	while (size--)
 310:	8b 45 08             	mov    0x8(%ebp),%eax
}
 313:	5b                   	pop    %ebx
 314:	5d                   	pop    %ebp
 315:	c3                   	ret    
 316:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 31d:	8d 76 00             	lea    0x0(%esi),%esi

00000320 <crcFile>:
crcFile(int fd, struct stat* st, char* path) {
 320:	55                   	push   %ebp
 321:	89 e5                	mov    %esp,%ebp
 323:	57                   	push   %edi
 324:	56                   	push   %esi
 325:	53                   	push   %ebx
 326:	83 ec 28             	sub    $0x28,%esp
 329:	8b 7d 0c             	mov    0xc(%ebp),%edi
 32c:	8b 45 10             	mov    0x10(%ebp),%eax
 32f:	8b 75 08             	mov    0x8(%ebp),%esi
  char* buffer = malloc(st->size);
 332:	ff 77 10             	pushl  0x10(%edi)
crcFile(int fd, struct stat* st, char* path) {
 335:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  char* buffer = malloc(st->size);
 338:	e8 c3 06 00 00       	call   a00 <malloc>
  if(read(fd, buffer, st->size) < 0)
 33d:	83 c4 0c             	add    $0xc,%esp
 340:	ff 77 10             	pushl  0x10(%edi)
 343:	50                   	push   %eax
  char* buffer = malloc(st->size);
 344:	89 c3                	mov    %eax,%ebx
  if(read(fd, buffer, st->size) < 0)
 346:	56                   	push   %esi
 347:	e8 ed 02 00 00       	call   639 <read>
 34c:	83 c4 10             	add    $0x10,%esp
 34f:	85 c0                	test   %eax,%eax
 351:	78 4e                	js     3a1 <crcFile+0x81>
  printf(1, "%x\n", crc32(0, buffer, st->size));
 353:	8b 47 10             	mov    0x10(%edi),%eax
	while (size--)
 356:	85 c0                	test   %eax,%eax
 358:	74 2a                	je     384 <crcFile+0x64>
 35a:	8d 0c 03             	lea    (%ebx,%eax,1),%ecx
	crc = crc ^ ~0U;
 35d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 362:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
	crc = crc32_tab[(crc ^ *p++) & 0xFF] ^ (crc >> 8);
 368:	83 c3 01             	add    $0x1,%ebx
 36b:	0f b6 53 ff          	movzbl -0x1(%ebx),%edx
 36f:	31 c2                	xor    %eax,%edx
 371:	c1 e8 08             	shr    $0x8,%eax
 374:	0f b6 d2             	movzbl %dl,%edx
 377:	33 04 95 e0 0b 00 00 	xor    0xbe0(,%edx,4),%eax
	while (size--)
 37e:	39 cb                	cmp    %ecx,%ebx
 380:	75 e6                	jne    368 <crcFile+0x48>
 382:	f7 d0                	not    %eax
  printf(1, "%x\n", crc32(0, buffer, st->size));
 384:	89 45 10             	mov    %eax,0x10(%ebp)
 387:	c7 45 0c 7c 0b 00 00 	movl   $0xb7c,0xc(%ebp)
 38e:	c7 45 08 01 00 00 00 	movl   $0x1,0x8(%ebp)
}
 395:	8d 65 f4             	lea    -0xc(%ebp),%esp
 398:	5b                   	pop    %ebx
 399:	5e                   	pop    %esi
 39a:	5f                   	pop    %edi
 39b:	5d                   	pop    %ebp
  printf(1, "%x\n", crc32(0, buffer, st->size));
 39c:	e9 ff 03 00 00       	jmp    7a0 <printf>
	  printf(1, "ERROR: Could not read file %s\n", path);
 3a1:	50                   	push   %eax
 3a2:	ff 75 e4             	pushl  -0x1c(%ebp)
 3a5:	68 20 0b 00 00       	push   $0xb20
 3aa:	6a 01                	push   $0x1
 3ac:	e8 ef 03 00 00       	call   7a0 <printf>
	  close(fd);
 3b1:	89 34 24             	mov    %esi,(%esp)
 3b4:	e8 90 02 00 00       	call   649 <close>
	  exit2(-1);
 3b9:	c7 04 24 ff ff ff ff 	movl   $0xffffffff,(%esp)
 3c0:	e8 04 03 00 00       	call   6c9 <exit2>
 3c5:	66 90                	xchg   %ax,%ax
 3c7:	66 90                	xchg   %ax,%ax
 3c9:	66 90                	xchg   %ax,%ax
 3cb:	66 90                	xchg   %ax,%ax
 3cd:	66 90                	xchg   %ax,%ax
 3cf:	90                   	nop

000003d0 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
 3d0:	55                   	push   %ebp
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 3d1:	31 d2                	xor    %edx,%edx
{
 3d3:	89 e5                	mov    %esp,%ebp
 3d5:	53                   	push   %ebx
 3d6:	8b 45 08             	mov    0x8(%ebp),%eax
 3d9:	8b 5d 0c             	mov    0xc(%ebp),%ebx
 3dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while((*s++ = *t++) != 0)
 3e0:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
 3e4:	88 0c 10             	mov    %cl,(%eax,%edx,1)
 3e7:	83 c2 01             	add    $0x1,%edx
 3ea:	84 c9                	test   %cl,%cl
 3ec:	75 f2                	jne    3e0 <strcpy+0x10>
    ;
  return os;
}
 3ee:	5b                   	pop    %ebx
 3ef:	5d                   	pop    %ebp
 3f0:	c3                   	ret    
 3f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 3f8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 3ff:	90                   	nop

00000400 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 400:	55                   	push   %ebp
 401:	89 e5                	mov    %esp,%ebp
 403:	56                   	push   %esi
 404:	53                   	push   %ebx
 405:	8b 5d 08             	mov    0x8(%ebp),%ebx
 408:	8b 75 0c             	mov    0xc(%ebp),%esi
  while(*p && *p == *q)
 40b:	0f b6 13             	movzbl (%ebx),%edx
 40e:	0f b6 0e             	movzbl (%esi),%ecx
 411:	84 d2                	test   %dl,%dl
 413:	74 1e                	je     433 <strcmp+0x33>
 415:	b8 01 00 00 00       	mov    $0x1,%eax
 41a:	38 ca                	cmp    %cl,%dl
 41c:	74 09                	je     427 <strcmp+0x27>
 41e:	eb 20                	jmp    440 <strcmp+0x40>
 420:	83 c0 01             	add    $0x1,%eax
 423:	38 ca                	cmp    %cl,%dl
 425:	75 19                	jne    440 <strcmp+0x40>
 427:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
 42b:	0f b6 0c 06          	movzbl (%esi,%eax,1),%ecx
 42f:	84 d2                	test   %dl,%dl
 431:	75 ed                	jne    420 <strcmp+0x20>
 433:	31 c0                	xor    %eax,%eax
    p++, q++;
  return (uchar)*p - (uchar)*q;
}
 435:	5b                   	pop    %ebx
 436:	5e                   	pop    %esi
  return (uchar)*p - (uchar)*q;
 437:	29 c8                	sub    %ecx,%eax
}
 439:	5d                   	pop    %ebp
 43a:	c3                   	ret    
 43b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 43f:	90                   	nop
 440:	0f b6 c2             	movzbl %dl,%eax
 443:	5b                   	pop    %ebx
 444:	5e                   	pop    %esi
  return (uchar)*p - (uchar)*q;
 445:	29 c8                	sub    %ecx,%eax
}
 447:	5d                   	pop    %ebp
 448:	c3                   	ret    
 449:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000450 <strlen>:

uint
strlen(const char *s)
{
 450:	55                   	push   %ebp
 451:	89 e5                	mov    %esp,%ebp
 453:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
 456:	80 39 00             	cmpb   $0x0,(%ecx)
 459:	74 15                	je     470 <strlen+0x20>
 45b:	31 d2                	xor    %edx,%edx
 45d:	8d 76 00             	lea    0x0(%esi),%esi
 460:	83 c2 01             	add    $0x1,%edx
 463:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
 467:	89 d0                	mov    %edx,%eax
 469:	75 f5                	jne    460 <strlen+0x10>
    ;
  return n;
}
 46b:	5d                   	pop    %ebp
 46c:	c3                   	ret    
 46d:	8d 76 00             	lea    0x0(%esi),%esi
  for(n = 0; s[n]; n++)
 470:	31 c0                	xor    %eax,%eax
}
 472:	5d                   	pop    %ebp
 473:	c3                   	ret    
 474:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 47b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 47f:	90                   	nop

00000480 <memset>:

void*
memset(void *dst, int c, uint n)
{
 480:	55                   	push   %ebp
 481:	89 e5                	mov    %esp,%ebp
 483:	57                   	push   %edi
 484:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 487:	8b 4d 10             	mov    0x10(%ebp),%ecx
 48a:	8b 45 0c             	mov    0xc(%ebp),%eax
 48d:	89 d7                	mov    %edx,%edi
 48f:	fc                   	cld    
 490:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 492:	89 d0                	mov    %edx,%eax
 494:	5f                   	pop    %edi
 495:	5d                   	pop    %ebp
 496:	c3                   	ret    
 497:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 49e:	66 90                	xchg   %ax,%ax

000004a0 <strchr>:

char*
strchr(const char *s, char c)
{
 4a0:	55                   	push   %ebp
 4a1:	89 e5                	mov    %esp,%ebp
 4a3:	53                   	push   %ebx
 4a4:	8b 45 08             	mov    0x8(%ebp),%eax
 4a7:	8b 55 0c             	mov    0xc(%ebp),%edx
  for(; *s; s++)
 4aa:	0f b6 18             	movzbl (%eax),%ebx
 4ad:	84 db                	test   %bl,%bl
 4af:	74 1d                	je     4ce <strchr+0x2e>
 4b1:	89 d1                	mov    %edx,%ecx
    if(*s == c)
 4b3:	38 d3                	cmp    %dl,%bl
 4b5:	75 0d                	jne    4c4 <strchr+0x24>
 4b7:	eb 17                	jmp    4d0 <strchr+0x30>
 4b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 4c0:	38 ca                	cmp    %cl,%dl
 4c2:	74 0c                	je     4d0 <strchr+0x30>
  for(; *s; s++)
 4c4:	83 c0 01             	add    $0x1,%eax
 4c7:	0f b6 10             	movzbl (%eax),%edx
 4ca:	84 d2                	test   %dl,%dl
 4cc:	75 f2                	jne    4c0 <strchr+0x20>
      return (char*)s;
  return 0;
 4ce:	31 c0                	xor    %eax,%eax
}
 4d0:	5b                   	pop    %ebx
 4d1:	5d                   	pop    %ebp
 4d2:	c3                   	ret    
 4d3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 4da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

000004e0 <gets>:

char*
gets(char *buf, int max)
{
 4e0:	55                   	push   %ebp
 4e1:	89 e5                	mov    %esp,%ebp
 4e3:	57                   	push   %edi
 4e4:	56                   	push   %esi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 4e5:	31 f6                	xor    %esi,%esi
{
 4e7:	53                   	push   %ebx
 4e8:	89 f3                	mov    %esi,%ebx
 4ea:	83 ec 1c             	sub    $0x1c,%esp
 4ed:	8b 7d 08             	mov    0x8(%ebp),%edi
  for(i=0; i+1 < max; ){
 4f0:	eb 2f                	jmp    521 <gets+0x41>
 4f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    cc = read(0, &c, 1);
 4f8:	83 ec 04             	sub    $0x4,%esp
 4fb:	8d 45 e7             	lea    -0x19(%ebp),%eax
 4fe:	6a 01                	push   $0x1
 500:	50                   	push   %eax
 501:	6a 00                	push   $0x0
 503:	e8 31 01 00 00       	call   639 <read>
    if(cc < 1)
 508:	83 c4 10             	add    $0x10,%esp
 50b:	85 c0                	test   %eax,%eax
 50d:	7e 1c                	jle    52b <gets+0x4b>
      break;
    buf[i++] = c;
 50f:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 513:	83 c7 01             	add    $0x1,%edi
 516:	88 47 ff             	mov    %al,-0x1(%edi)
    if(c == '\n' || c == '\r')
 519:	3c 0a                	cmp    $0xa,%al
 51b:	74 23                	je     540 <gets+0x60>
 51d:	3c 0d                	cmp    $0xd,%al
 51f:	74 1f                	je     540 <gets+0x60>
  for(i=0; i+1 < max; ){
 521:	83 c3 01             	add    $0x1,%ebx
 524:	89 fe                	mov    %edi,%esi
 526:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 529:	7c cd                	jl     4f8 <gets+0x18>
 52b:	89 f3                	mov    %esi,%ebx
      break;
  }
  buf[i] = '\0';
  return buf;
}
 52d:	8b 45 08             	mov    0x8(%ebp),%eax
  buf[i] = '\0';
 530:	c6 03 00             	movb   $0x0,(%ebx)
}
 533:	8d 65 f4             	lea    -0xc(%ebp),%esp
 536:	5b                   	pop    %ebx
 537:	5e                   	pop    %esi
 538:	5f                   	pop    %edi
 539:	5d                   	pop    %ebp
 53a:	c3                   	ret    
 53b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 53f:	90                   	nop
 540:	8b 75 08             	mov    0x8(%ebp),%esi
 543:	8b 45 08             	mov    0x8(%ebp),%eax
 546:	01 de                	add    %ebx,%esi
 548:	89 f3                	mov    %esi,%ebx
  buf[i] = '\0';
 54a:	c6 03 00             	movb   $0x0,(%ebx)
}
 54d:	8d 65 f4             	lea    -0xc(%ebp),%esp
 550:	5b                   	pop    %ebx
 551:	5e                   	pop    %esi
 552:	5f                   	pop    %edi
 553:	5d                   	pop    %ebp
 554:	c3                   	ret    
 555:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 55c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000560 <stat>:

int
stat(const char *n, struct stat *st)
{
 560:	55                   	push   %ebp
 561:	89 e5                	mov    %esp,%ebp
 563:	56                   	push   %esi
 564:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 565:	83 ec 08             	sub    $0x8,%esp
 568:	6a 00                	push   $0x0
 56a:	ff 75 08             	pushl  0x8(%ebp)
 56d:	e8 ef 00 00 00       	call   661 <open>
  if(fd < 0)
 572:	83 c4 10             	add    $0x10,%esp
 575:	85 c0                	test   %eax,%eax
 577:	78 27                	js     5a0 <stat+0x40>
    return -1;
  r = fstat(fd, st);
 579:	83 ec 08             	sub    $0x8,%esp
 57c:	ff 75 0c             	pushl  0xc(%ebp)
 57f:	89 c3                	mov    %eax,%ebx
 581:	50                   	push   %eax
 582:	e8 f2 00 00 00       	call   679 <fstat>
  close(fd);
 587:	89 1c 24             	mov    %ebx,(%esp)
  r = fstat(fd, st);
 58a:	89 c6                	mov    %eax,%esi
  close(fd);
 58c:	e8 b8 00 00 00       	call   649 <close>
  return r;
 591:	83 c4 10             	add    $0x10,%esp
}
 594:	8d 65 f8             	lea    -0x8(%ebp),%esp
 597:	89 f0                	mov    %esi,%eax
 599:	5b                   	pop    %ebx
 59a:	5e                   	pop    %esi
 59b:	5d                   	pop    %ebp
 59c:	c3                   	ret    
 59d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
 5a0:	be ff ff ff ff       	mov    $0xffffffff,%esi
 5a5:	eb ed                	jmp    594 <stat+0x34>
 5a7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 5ae:	66 90                	xchg   %ax,%ax

000005b0 <atoi>:

int
atoi(const char *s)
{
 5b0:	55                   	push   %ebp
 5b1:	89 e5                	mov    %esp,%ebp
 5b3:	53                   	push   %ebx
 5b4:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 5b7:	0f be 11             	movsbl (%ecx),%edx
 5ba:	8d 42 d0             	lea    -0x30(%edx),%eax
 5bd:	3c 09                	cmp    $0x9,%al
  n = 0;
 5bf:	b8 00 00 00 00       	mov    $0x0,%eax
  while('0' <= *s && *s <= '9')
 5c4:	77 1f                	ja     5e5 <atoi+0x35>
 5c6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 5cd:	8d 76 00             	lea    0x0(%esi),%esi
    n = n*10 + *s++ - '0';
 5d0:	83 c1 01             	add    $0x1,%ecx
 5d3:	8d 04 80             	lea    (%eax,%eax,4),%eax
 5d6:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
  while('0' <= *s && *s <= '9')
 5da:	0f be 11             	movsbl (%ecx),%edx
 5dd:	8d 5a d0             	lea    -0x30(%edx),%ebx
 5e0:	80 fb 09             	cmp    $0x9,%bl
 5e3:	76 eb                	jbe    5d0 <atoi+0x20>
  return n;
}
 5e5:	5b                   	pop    %ebx
 5e6:	5d                   	pop    %ebp
 5e7:	c3                   	ret    
 5e8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 5ef:	90                   	nop

000005f0 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 5f0:	55                   	push   %ebp
 5f1:	89 e5                	mov    %esp,%ebp
 5f3:	57                   	push   %edi
 5f4:	8b 55 10             	mov    0x10(%ebp),%edx
 5f7:	8b 45 08             	mov    0x8(%ebp),%eax
 5fa:	56                   	push   %esi
 5fb:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 5fe:	85 d2                	test   %edx,%edx
 600:	7e 13                	jle    615 <memmove+0x25>
 602:	01 c2                	add    %eax,%edx
  dst = vdst;
 604:	89 c7                	mov    %eax,%edi
 606:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 60d:	8d 76 00             	lea    0x0(%esi),%esi
    *dst++ = *src++;
 610:	a4                   	movsb  %ds:(%esi),%es:(%edi)
  while(n-- > 0)
 611:	39 fa                	cmp    %edi,%edx
 613:	75 fb                	jne    610 <memmove+0x20>
  return vdst;
}
 615:	5e                   	pop    %esi
 616:	5f                   	pop    %edi
 617:	5d                   	pop    %ebp
 618:	c3                   	ret    

00000619 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 619:	b8 01 00 00 00       	mov    $0x1,%eax
 61e:	cd 40                	int    $0x40
 620:	c3                   	ret    

00000621 <exit>:
SYSCALL(exit)
 621:	b8 02 00 00 00       	mov    $0x2,%eax
 626:	cd 40                	int    $0x40
 628:	c3                   	ret    

00000629 <wait>:
SYSCALL(wait)
 629:	b8 03 00 00 00       	mov    $0x3,%eax
 62e:	cd 40                	int    $0x40
 630:	c3                   	ret    

00000631 <pipe>:
SYSCALL(pipe)
 631:	b8 04 00 00 00       	mov    $0x4,%eax
 636:	cd 40                	int    $0x40
 638:	c3                   	ret    

00000639 <read>:
SYSCALL(read)
 639:	b8 05 00 00 00       	mov    $0x5,%eax
 63e:	cd 40                	int    $0x40
 640:	c3                   	ret    

00000641 <write>:
SYSCALL(write)
 641:	b8 10 00 00 00       	mov    $0x10,%eax
 646:	cd 40                	int    $0x40
 648:	c3                   	ret    

00000649 <close>:
SYSCALL(close)
 649:	b8 15 00 00 00       	mov    $0x15,%eax
 64e:	cd 40                	int    $0x40
 650:	c3                   	ret    

00000651 <kill>:
SYSCALL(kill)
 651:	b8 06 00 00 00       	mov    $0x6,%eax
 656:	cd 40                	int    $0x40
 658:	c3                   	ret    

00000659 <exec>:
SYSCALL(exec)
 659:	b8 07 00 00 00       	mov    $0x7,%eax
 65e:	cd 40                	int    $0x40
 660:	c3                   	ret    

00000661 <open>:
SYSCALL(open)
 661:	b8 0f 00 00 00       	mov    $0xf,%eax
 666:	cd 40                	int    $0x40
 668:	c3                   	ret    

00000669 <mknod>:
SYSCALL(mknod)
 669:	b8 11 00 00 00       	mov    $0x11,%eax
 66e:	cd 40                	int    $0x40
 670:	c3                   	ret    

00000671 <unlink>:
SYSCALL(unlink)
 671:	b8 12 00 00 00       	mov    $0x12,%eax
 676:	cd 40                	int    $0x40
 678:	c3                   	ret    

00000679 <fstat>:
SYSCALL(fstat)
 679:	b8 08 00 00 00       	mov    $0x8,%eax
 67e:	cd 40                	int    $0x40
 680:	c3                   	ret    

00000681 <link>:
SYSCALL(link)
 681:	b8 13 00 00 00       	mov    $0x13,%eax
 686:	cd 40                	int    $0x40
 688:	c3                   	ret    

00000689 <mkdir>:
SYSCALL(mkdir)
 689:	b8 14 00 00 00       	mov    $0x14,%eax
 68e:	cd 40                	int    $0x40
 690:	c3                   	ret    

00000691 <chdir>:
SYSCALL(chdir)
 691:	b8 09 00 00 00       	mov    $0x9,%eax
 696:	cd 40                	int    $0x40
 698:	c3                   	ret    

00000699 <dup>:
SYSCALL(dup)
 699:	b8 0a 00 00 00       	mov    $0xa,%eax
 69e:	cd 40                	int    $0x40
 6a0:	c3                   	ret    

000006a1 <getpid>:
SYSCALL(getpid)
 6a1:	b8 0b 00 00 00       	mov    $0xb,%eax
 6a6:	cd 40                	int    $0x40
 6a8:	c3                   	ret    

000006a9 <sbrk>:
SYSCALL(sbrk)
 6a9:	b8 0c 00 00 00       	mov    $0xc,%eax
 6ae:	cd 40                	int    $0x40
 6b0:	c3                   	ret    

000006b1 <sleep>:
SYSCALL(sleep)
 6b1:	b8 0d 00 00 00       	mov    $0xd,%eax
 6b6:	cd 40                	int    $0x40
 6b8:	c3                   	ret    

000006b9 <uptime>:
SYSCALL(uptime)
 6b9:	b8 0e 00 00 00       	mov    $0xe,%eax
 6be:	cd 40                	int    $0x40
 6c0:	c3                   	ret    

000006c1 <freemem>:
SYSCALL(freemem)
 6c1:	b8 16 00 00 00       	mov    $0x16,%eax
 6c6:	cd 40                	int    $0x40
 6c8:	c3                   	ret    

000006c9 <exit2>:
SYSCALL(exit2)
 6c9:	b8 17 00 00 00       	mov    $0x17,%eax
 6ce:	cd 40                	int    $0x40
 6d0:	c3                   	ret    

000006d1 <wait2>:
SYSCALL(wait2)
 6d1:	b8 18 00 00 00       	mov    $0x18,%eax
 6d6:	cd 40                	int    $0x40
 6d8:	c3                   	ret    
 6d9:	66 90                	xchg   %ax,%ax
 6db:	66 90                	xchg   %ax,%ax
 6dd:	66 90                	xchg   %ax,%ax
 6df:	90                   	nop

000006e0 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 6e0:	55                   	push   %ebp
 6e1:	89 e5                	mov    %esp,%ebp
 6e3:	57                   	push   %edi
 6e4:	56                   	push   %esi
 6e5:	53                   	push   %ebx
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
 6e6:	89 d3                	mov    %edx,%ebx
{
 6e8:	83 ec 3c             	sub    $0x3c,%esp
 6eb:	89 45 bc             	mov    %eax,-0x44(%ebp)
  if(sgn && xx < 0){
 6ee:	85 d2                	test   %edx,%edx
 6f0:	0f 89 92 00 00 00    	jns    788 <printint+0xa8>
 6f6:	f6 45 08 01          	testb  $0x1,0x8(%ebp)
 6fa:	0f 84 88 00 00 00    	je     788 <printint+0xa8>
    neg = 1;
 700:	c7 45 c0 01 00 00 00 	movl   $0x1,-0x40(%ebp)
    x = -xx;
 707:	f7 db                	neg    %ebx
  } else {
    x = xx;
  }

  i = 0;
 709:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
 710:	8d 75 d7             	lea    -0x29(%ebp),%esi
 713:	eb 08                	jmp    71d <printint+0x3d>
 715:	8d 76 00             	lea    0x0(%esi),%esi
  do{
    buf[i++] = digits[x % base];
 718:	89 7d c4             	mov    %edi,-0x3c(%ebp)
  }while((x /= base) != 0);
 71b:	89 c3                	mov    %eax,%ebx
    buf[i++] = digits[x % base];
 71d:	89 d8                	mov    %ebx,%eax
 71f:	31 d2                	xor    %edx,%edx
 721:	8b 7d c4             	mov    -0x3c(%ebp),%edi
 724:	f7 f1                	div    %ecx
 726:	83 c7 01             	add    $0x1,%edi
 729:	0f b6 92 e8 0f 00 00 	movzbl 0xfe8(%edx),%edx
 730:	88 14 3e             	mov    %dl,(%esi,%edi,1)
  }while((x /= base) != 0);
 733:	39 d9                	cmp    %ebx,%ecx
 735:	76 e1                	jbe    718 <printint+0x38>
  if(neg)
 737:	8b 45 c0             	mov    -0x40(%ebp),%eax
 73a:	85 c0                	test   %eax,%eax
 73c:	74 0d                	je     74b <printint+0x6b>
    buf[i++] = '-';
 73e:	c6 44 3d d8 2d       	movb   $0x2d,-0x28(%ebp,%edi,1)
 743:	ba 2d 00 00 00       	mov    $0x2d,%edx
    buf[i++] = digits[x % base];
 748:	89 7d c4             	mov    %edi,-0x3c(%ebp)

  while(--i >= 0)
 74b:	8b 45 c4             	mov    -0x3c(%ebp),%eax
 74e:	8b 7d bc             	mov    -0x44(%ebp),%edi
 751:	8d 5c 05 d7          	lea    -0x29(%ebp,%eax,1),%ebx
 755:	eb 0f                	jmp    766 <printint+0x86>
 757:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 75e:	66 90                	xchg   %ax,%ax
 760:	0f b6 13             	movzbl (%ebx),%edx
 763:	83 eb 01             	sub    $0x1,%ebx
  write(fd, &c, 1);
 766:	83 ec 04             	sub    $0x4,%esp
 769:	88 55 d7             	mov    %dl,-0x29(%ebp)
 76c:	6a 01                	push   $0x1
 76e:	56                   	push   %esi
 76f:	57                   	push   %edi
 770:	e8 cc fe ff ff       	call   641 <write>
  while(--i >= 0)
 775:	83 c4 10             	add    $0x10,%esp
 778:	39 de                	cmp    %ebx,%esi
 77a:	75 e4                	jne    760 <printint+0x80>
    putc(fd, buf[i]);
}
 77c:	8d 65 f4             	lea    -0xc(%ebp),%esp
 77f:	5b                   	pop    %ebx
 780:	5e                   	pop    %esi
 781:	5f                   	pop    %edi
 782:	5d                   	pop    %ebp
 783:	c3                   	ret    
 784:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  neg = 0;
 788:	c7 45 c0 00 00 00 00 	movl   $0x0,-0x40(%ebp)
 78f:	e9 75 ff ff ff       	jmp    709 <printint+0x29>
 794:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 79b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 79f:	90                   	nop

000007a0 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 7a0:	55                   	push   %ebp
 7a1:	89 e5                	mov    %esp,%ebp
 7a3:	57                   	push   %edi
 7a4:	56                   	push   %esi
 7a5:	53                   	push   %ebx
 7a6:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 7a9:	8b 75 0c             	mov    0xc(%ebp),%esi
 7ac:	0f b6 1e             	movzbl (%esi),%ebx
 7af:	84 db                	test   %bl,%bl
 7b1:	0f 84 b9 00 00 00    	je     870 <printf+0xd0>
  ap = (uint*)(void*)&fmt + 1;
 7b7:	8d 45 10             	lea    0x10(%ebp),%eax
 7ba:	83 c6 01             	add    $0x1,%esi
  write(fd, &c, 1);
 7bd:	8d 7d e7             	lea    -0x19(%ebp),%edi
  state = 0;
 7c0:	31 d2                	xor    %edx,%edx
  ap = (uint*)(void*)&fmt + 1;
 7c2:	89 45 d0             	mov    %eax,-0x30(%ebp)
 7c5:	eb 38                	jmp    7ff <printf+0x5f>
 7c7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 7ce:	66 90                	xchg   %ax,%ax
 7d0:	89 55 d4             	mov    %edx,-0x2c(%ebp)
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
 7d3:	ba 25 00 00 00       	mov    $0x25,%edx
      if(c == '%'){
 7d8:	83 f8 25             	cmp    $0x25,%eax
 7db:	74 17                	je     7f4 <printf+0x54>
  write(fd, &c, 1);
 7dd:	83 ec 04             	sub    $0x4,%esp
 7e0:	88 5d e7             	mov    %bl,-0x19(%ebp)
 7e3:	6a 01                	push   $0x1
 7e5:	57                   	push   %edi
 7e6:	ff 75 08             	pushl  0x8(%ebp)
 7e9:	e8 53 fe ff ff       	call   641 <write>
 7ee:	8b 55 d4             	mov    -0x2c(%ebp),%edx
      } else {
        putc(fd, c);
 7f1:	83 c4 10             	add    $0x10,%esp
  for(i = 0; fmt[i]; i++){
 7f4:	83 c6 01             	add    $0x1,%esi
 7f7:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
 7fb:	84 db                	test   %bl,%bl
 7fd:	74 71                	je     870 <printf+0xd0>
    c = fmt[i] & 0xff;
 7ff:	0f be cb             	movsbl %bl,%ecx
 802:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
 805:	85 d2                	test   %edx,%edx
 807:	74 c7                	je     7d0 <printf+0x30>
      }
    } else if(state == '%'){
 809:	83 fa 25             	cmp    $0x25,%edx
 80c:	75 e6                	jne    7f4 <printf+0x54>
      if(c == 'd'){
 80e:	83 f8 64             	cmp    $0x64,%eax
 811:	0f 84 99 00 00 00    	je     8b0 <printf+0x110>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 817:	81 e1 f7 00 00 00    	and    $0xf7,%ecx
 81d:	83 f9 70             	cmp    $0x70,%ecx
 820:	74 5e                	je     880 <printf+0xe0>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 822:	83 f8 73             	cmp    $0x73,%eax
 825:	0f 84 d5 00 00 00    	je     900 <printf+0x160>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 82b:	83 f8 63             	cmp    $0x63,%eax
 82e:	0f 84 8c 00 00 00    	je     8c0 <printf+0x120>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 834:	83 f8 25             	cmp    $0x25,%eax
 837:	0f 84 b3 00 00 00    	je     8f0 <printf+0x150>
  write(fd, &c, 1);
 83d:	83 ec 04             	sub    $0x4,%esp
 840:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
 844:	6a 01                	push   $0x1
 846:	57                   	push   %edi
 847:	ff 75 08             	pushl  0x8(%ebp)
 84a:	e8 f2 fd ff ff       	call   641 <write>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
 84f:	88 5d e7             	mov    %bl,-0x19(%ebp)
  write(fd, &c, 1);
 852:	83 c4 0c             	add    $0xc,%esp
 855:	6a 01                	push   $0x1
 857:	83 c6 01             	add    $0x1,%esi
 85a:	57                   	push   %edi
 85b:	ff 75 08             	pushl  0x8(%ebp)
 85e:	e8 de fd ff ff       	call   641 <write>
  for(i = 0; fmt[i]; i++){
 863:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
        putc(fd, c);
 867:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 86a:	31 d2                	xor    %edx,%edx
  for(i = 0; fmt[i]; i++){
 86c:	84 db                	test   %bl,%bl
 86e:	75 8f                	jne    7ff <printf+0x5f>
    }
  }
}
 870:	8d 65 f4             	lea    -0xc(%ebp),%esp
 873:	5b                   	pop    %ebx
 874:	5e                   	pop    %esi
 875:	5f                   	pop    %edi
 876:	5d                   	pop    %ebp
 877:	c3                   	ret    
 878:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 87f:	90                   	nop
        printint(fd, *ap, 16, 0);
 880:	83 ec 0c             	sub    $0xc,%esp
 883:	b9 10 00 00 00       	mov    $0x10,%ecx
 888:	6a 00                	push   $0x0
 88a:	8b 5d d0             	mov    -0x30(%ebp),%ebx
 88d:	8b 45 08             	mov    0x8(%ebp),%eax
 890:	8b 13                	mov    (%ebx),%edx
 892:	e8 49 fe ff ff       	call   6e0 <printint>
        ap++;
 897:	89 d8                	mov    %ebx,%eax
 899:	83 c4 10             	add    $0x10,%esp
      state = 0;
 89c:	31 d2                	xor    %edx,%edx
        ap++;
 89e:	83 c0 04             	add    $0x4,%eax
 8a1:	89 45 d0             	mov    %eax,-0x30(%ebp)
 8a4:	e9 4b ff ff ff       	jmp    7f4 <printf+0x54>
 8a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        printint(fd, *ap, 10, 1);
 8b0:	83 ec 0c             	sub    $0xc,%esp
 8b3:	b9 0a 00 00 00       	mov    $0xa,%ecx
 8b8:	6a 01                	push   $0x1
 8ba:	eb ce                	jmp    88a <printf+0xea>
 8bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        putc(fd, *ap);
 8c0:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  write(fd, &c, 1);
 8c3:	83 ec 04             	sub    $0x4,%esp
        putc(fd, *ap);
 8c6:	8b 03                	mov    (%ebx),%eax
  write(fd, &c, 1);
 8c8:	6a 01                	push   $0x1
        ap++;
 8ca:	83 c3 04             	add    $0x4,%ebx
  write(fd, &c, 1);
 8cd:	57                   	push   %edi
 8ce:	ff 75 08             	pushl  0x8(%ebp)
        putc(fd, *ap);
 8d1:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 8d4:	e8 68 fd ff ff       	call   641 <write>
        ap++;
 8d9:	89 5d d0             	mov    %ebx,-0x30(%ebp)
 8dc:	83 c4 10             	add    $0x10,%esp
      state = 0;
 8df:	31 d2                	xor    %edx,%edx
 8e1:	e9 0e ff ff ff       	jmp    7f4 <printf+0x54>
 8e6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 8ed:	8d 76 00             	lea    0x0(%esi),%esi
        putc(fd, c);
 8f0:	88 5d e7             	mov    %bl,-0x19(%ebp)
  write(fd, &c, 1);
 8f3:	83 ec 04             	sub    $0x4,%esp
 8f6:	e9 5a ff ff ff       	jmp    855 <printf+0xb5>
 8fb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 8ff:	90                   	nop
        s = (char*)*ap;
 900:	8b 45 d0             	mov    -0x30(%ebp),%eax
 903:	8b 18                	mov    (%eax),%ebx
        ap++;
 905:	83 c0 04             	add    $0x4,%eax
 908:	89 45 d0             	mov    %eax,-0x30(%ebp)
        if(s == 0)
 90b:	85 db                	test   %ebx,%ebx
 90d:	74 17                	je     926 <printf+0x186>
        while(*s != 0){
 90f:	0f b6 03             	movzbl (%ebx),%eax
      state = 0;
 912:	31 d2                	xor    %edx,%edx
        while(*s != 0){
 914:	84 c0                	test   %al,%al
 916:	0f 84 d8 fe ff ff    	je     7f4 <printf+0x54>
 91c:	89 75 d4             	mov    %esi,-0x2c(%ebp)
 91f:	89 de                	mov    %ebx,%esi
 921:	8b 5d 08             	mov    0x8(%ebp),%ebx
 924:	eb 1a                	jmp    940 <printf+0x1a0>
          s = "(null)";
 926:	bb e0 0f 00 00       	mov    $0xfe0,%ebx
        while(*s != 0){
 92b:	89 75 d4             	mov    %esi,-0x2c(%ebp)
 92e:	b8 28 00 00 00       	mov    $0x28,%eax
 933:	89 de                	mov    %ebx,%esi
 935:	8b 5d 08             	mov    0x8(%ebp),%ebx
 938:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 93f:	90                   	nop
  write(fd, &c, 1);
 940:	83 ec 04             	sub    $0x4,%esp
          s++;
 943:	83 c6 01             	add    $0x1,%esi
 946:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 949:	6a 01                	push   $0x1
 94b:	57                   	push   %edi
 94c:	53                   	push   %ebx
 94d:	e8 ef fc ff ff       	call   641 <write>
        while(*s != 0){
 952:	0f b6 06             	movzbl (%esi),%eax
 955:	83 c4 10             	add    $0x10,%esp
 958:	84 c0                	test   %al,%al
 95a:	75 e4                	jne    940 <printf+0x1a0>
 95c:	8b 75 d4             	mov    -0x2c(%ebp),%esi
      state = 0;
 95f:	31 d2                	xor    %edx,%edx
 961:	e9 8e fe ff ff       	jmp    7f4 <printf+0x54>
 966:	66 90                	xchg   %ax,%ax
 968:	66 90                	xchg   %ax,%ax
 96a:	66 90                	xchg   %ax,%ax
 96c:	66 90                	xchg   %ax,%ax
 96e:	66 90                	xchg   %ax,%ax

00000970 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 970:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 971:	a1 38 13 00 00       	mov    0x1338,%eax
{
 976:	89 e5                	mov    %esp,%ebp
 978:	57                   	push   %edi
 979:	56                   	push   %esi
 97a:	53                   	push   %ebx
 97b:	8b 5d 08             	mov    0x8(%ebp),%ebx
 97e:	8b 10                	mov    (%eax),%edx
  bp = (Header*)ap - 1;
 980:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 983:	39 c8                	cmp    %ecx,%eax
 985:	73 19                	jae    9a0 <free+0x30>
 987:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 98e:	66 90                	xchg   %ax,%ax
 990:	39 d1                	cmp    %edx,%ecx
 992:	72 14                	jb     9a8 <free+0x38>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 994:	39 d0                	cmp    %edx,%eax
 996:	73 10                	jae    9a8 <free+0x38>
{
 998:	89 d0                	mov    %edx,%eax
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 99a:	8b 10                	mov    (%eax),%edx
 99c:	39 c8                	cmp    %ecx,%eax
 99e:	72 f0                	jb     990 <free+0x20>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 9a0:	39 d0                	cmp    %edx,%eax
 9a2:	72 f4                	jb     998 <free+0x28>
 9a4:	39 d1                	cmp    %edx,%ecx
 9a6:	73 f0                	jae    998 <free+0x28>
      break;
  if(bp + bp->s.size == p->s.ptr){
 9a8:	8b 73 fc             	mov    -0x4(%ebx),%esi
 9ab:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 9ae:	39 fa                	cmp    %edi,%edx
 9b0:	74 1e                	je     9d0 <free+0x60>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 9b2:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 9b5:	8b 50 04             	mov    0x4(%eax),%edx
 9b8:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 9bb:	39 f1                	cmp    %esi,%ecx
 9bd:	74 28                	je     9e7 <free+0x77>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 9bf:	89 08                	mov    %ecx,(%eax)
  freep = p;
}
 9c1:	5b                   	pop    %ebx
  freep = p;
 9c2:	a3 38 13 00 00       	mov    %eax,0x1338
}
 9c7:	5e                   	pop    %esi
 9c8:	5f                   	pop    %edi
 9c9:	5d                   	pop    %ebp
 9ca:	c3                   	ret    
 9cb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 9cf:	90                   	nop
    bp->s.size += p->s.ptr->s.size;
 9d0:	03 72 04             	add    0x4(%edx),%esi
 9d3:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 9d6:	8b 10                	mov    (%eax),%edx
 9d8:	8b 12                	mov    (%edx),%edx
 9da:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 9dd:	8b 50 04             	mov    0x4(%eax),%edx
 9e0:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 9e3:	39 f1                	cmp    %esi,%ecx
 9e5:	75 d8                	jne    9bf <free+0x4f>
    p->s.size += bp->s.size;
 9e7:	03 53 fc             	add    -0x4(%ebx),%edx
  freep = p;
 9ea:	a3 38 13 00 00       	mov    %eax,0x1338
    p->s.size += bp->s.size;
 9ef:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 9f2:	8b 53 f8             	mov    -0x8(%ebx),%edx
 9f5:	89 10                	mov    %edx,(%eax)
}
 9f7:	5b                   	pop    %ebx
 9f8:	5e                   	pop    %esi
 9f9:	5f                   	pop    %edi
 9fa:	5d                   	pop    %ebp
 9fb:	c3                   	ret    
 9fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000a00 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 a00:	55                   	push   %ebp
 a01:	89 e5                	mov    %esp,%ebp
 a03:	57                   	push   %edi
 a04:	56                   	push   %esi
 a05:	53                   	push   %ebx
 a06:	83 ec 1c             	sub    $0x1c,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 a09:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
 a0c:	8b 3d 38 13 00 00    	mov    0x1338,%edi
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 a12:	8d 70 07             	lea    0x7(%eax),%esi
 a15:	c1 ee 03             	shr    $0x3,%esi
 a18:	83 c6 01             	add    $0x1,%esi
  if((prevp = freep) == 0){
 a1b:	85 ff                	test   %edi,%edi
 a1d:	0f 84 ad 00 00 00    	je     ad0 <malloc+0xd0>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a23:	8b 17                	mov    (%edi),%edx
    if(p->s.size >= nunits){
 a25:	8b 4a 04             	mov    0x4(%edx),%ecx
 a28:	39 f1                	cmp    %esi,%ecx
 a2a:	73 72                	jae    a9e <malloc+0x9e>
 a2c:	81 fe 00 10 00 00    	cmp    $0x1000,%esi
 a32:	bb 00 10 00 00       	mov    $0x1000,%ebx
 a37:	0f 43 de             	cmovae %esi,%ebx
  p = sbrk(nu * sizeof(Header));
 a3a:	8d 04 dd 00 00 00 00 	lea    0x0(,%ebx,8),%eax
 a41:	89 45 e4             	mov    %eax,-0x1c(%ebp)
 a44:	eb 1b                	jmp    a61 <malloc+0x61>
 a46:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 a4d:	8d 76 00             	lea    0x0(%esi),%esi
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a50:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 a52:	8b 48 04             	mov    0x4(%eax),%ecx
 a55:	39 f1                	cmp    %esi,%ecx
 a57:	73 4f                	jae    aa8 <malloc+0xa8>
 a59:	8b 3d 38 13 00 00    	mov    0x1338,%edi
 a5f:	89 c2                	mov    %eax,%edx
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 a61:	39 d7                	cmp    %edx,%edi
 a63:	75 eb                	jne    a50 <malloc+0x50>
  p = sbrk(nu * sizeof(Header));
 a65:	83 ec 0c             	sub    $0xc,%esp
 a68:	ff 75 e4             	pushl  -0x1c(%ebp)
 a6b:	e8 39 fc ff ff       	call   6a9 <sbrk>
  if(p == (char*)-1)
 a70:	83 c4 10             	add    $0x10,%esp
 a73:	83 f8 ff             	cmp    $0xffffffff,%eax
 a76:	74 1c                	je     a94 <malloc+0x94>
  hp->s.size = nu;
 a78:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 a7b:	83 ec 0c             	sub    $0xc,%esp
 a7e:	83 c0 08             	add    $0x8,%eax
 a81:	50                   	push   %eax
 a82:	e8 e9 fe ff ff       	call   970 <free>
  return freep;
 a87:	8b 15 38 13 00 00    	mov    0x1338,%edx
      if((p = morecore(nunits)) == 0)
 a8d:	83 c4 10             	add    $0x10,%esp
 a90:	85 d2                	test   %edx,%edx
 a92:	75 bc                	jne    a50 <malloc+0x50>
        return 0;
  }
}
 a94:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return 0;
 a97:	31 c0                	xor    %eax,%eax
}
 a99:	5b                   	pop    %ebx
 a9a:	5e                   	pop    %esi
 a9b:	5f                   	pop    %edi
 a9c:	5d                   	pop    %ebp
 a9d:	c3                   	ret    
    if(p->s.size >= nunits){
 a9e:	89 d0                	mov    %edx,%eax
 aa0:	89 fa                	mov    %edi,%edx
 aa2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      if(p->s.size == nunits)
 aa8:	39 ce                	cmp    %ecx,%esi
 aaa:	74 54                	je     b00 <malloc+0x100>
        p->s.size -= nunits;
 aac:	29 f1                	sub    %esi,%ecx
 aae:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
 ab1:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
 ab4:	89 70 04             	mov    %esi,0x4(%eax)
      freep = prevp;
 ab7:	89 15 38 13 00 00    	mov    %edx,0x1338
}
 abd:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return (void*)(p + 1);
 ac0:	83 c0 08             	add    $0x8,%eax
}
 ac3:	5b                   	pop    %ebx
 ac4:	5e                   	pop    %esi
 ac5:	5f                   	pop    %edi
 ac6:	5d                   	pop    %ebp
 ac7:	c3                   	ret    
 ac8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 acf:	90                   	nop
    base.s.ptr = freep = prevp = &base;
 ad0:	c7 05 38 13 00 00 3c 	movl   $0x133c,0x1338
 ad7:	13 00 00 
    base.s.size = 0;
 ada:	bf 3c 13 00 00       	mov    $0x133c,%edi
    base.s.ptr = freep = prevp = &base;
 adf:	c7 05 3c 13 00 00 3c 	movl   $0x133c,0x133c
 ae6:	13 00 00 
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 ae9:	89 fa                	mov    %edi,%edx
    base.s.size = 0;
 aeb:	c7 05 40 13 00 00 00 	movl   $0x0,0x1340
 af2:	00 00 00 
    if(p->s.size >= nunits){
 af5:	e9 32 ff ff ff       	jmp    a2c <malloc+0x2c>
 afa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        prevp->s.ptr = p->s.ptr;
 b00:	8b 08                	mov    (%eax),%ecx
 b02:	89 0a                	mov    %ecx,(%edx)
 b04:	eb b1                	jmp    ab7 <malloc+0xb7>
