
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
  11:	81 ec 58 04 00 00    	sub    $0x458,%esp
  int fd;
  char buffer[512], *p;
  struct dirent de;
  struct stat st;

  if(argc != 2){
  17:	83 39 02             	cmpl   $0x2,(%ecx)
{
  1a:	8b 71 04             	mov    0x4(%ecx),%esi
  if(argc != 2){
  1d:	74 1a                	je     39 <main+0x39>
	printf(1, "ERROR: crc32 does not have the correct amount of arguments\n");
  1f:	52                   	push   %edx
  20:	52                   	push   %edx
  21:	68 40 0b 00 00       	push   $0xb40
  26:	6a 01                	push   $0x1
  28:	e8 a3 07 00 00       	call   7d0 <printf>
    exit2(-1);
  2d:	c7 04 24 ff ff ff ff 	movl   $0xffffffff,(%esp)
  34:	e8 c0 06 00 00       	call   6f9 <exit2>
  }

  if((fd = open(argv[1], 0)) < 0){
  39:	50                   	push   %eax
  3a:	50                   	push   %eax
  3b:	6a 00                	push   $0x0
  3d:	ff 76 04             	pushl  0x4(%esi)
  40:	e8 4c 06 00 00       	call   691 <open>
  45:	83 c4 10             	add    $0x10,%esp
  48:	89 c3                	mov    %eax,%ebx
  4a:	85 c0                	test   %eax,%eax
  4c:	0f 88 be 00 00 00    	js     110 <main+0x110>
    printf(2, "crc32: cannot open %s\n", argv[1]);
	exit2(-1);
  } 

  if(fstat(fd, &st) < 0){
  52:	50                   	push   %eax
  53:	50                   	push   %eax
  54:	8d 85 c0 fb ff ff    	lea    -0x440(%ebp),%eax
  5a:	50                   	push   %eax
  5b:	53                   	push   %ebx
  5c:	e8 48 06 00 00       	call   6a9 <fstat>
  61:	83 c4 10             	add    $0x10,%esp
  64:	85 c0                	test   %eax,%eax
  66:	0f 88 80 00 00 00    	js     ec <main+0xec>
    printf(2, "crc32: cannot stat %s\n", argv[1]);
    close(fd);
    exit2(-1);
  }

  switch(st.type) {
  6c:	0f b7 85 c0 fb ff ff 	movzwl -0x440(%ebp),%eax
  73:	66 83 f8 01          	cmp    $0x1,%ax
  77:	0f 84 bc 00 00 00    	je     139 <main+0x139>
  7d:	66 83 f8 02          	cmp    $0x2,%ax
  81:	75 5b                	jne    de <main+0xde>
	case T_FILE:
	    if(read(fd, buffer, st.size) < 0) {
  83:	8d bd e8 fb ff ff    	lea    -0x418(%ebp),%edi
  89:	50                   	push   %eax
  8a:	ff b5 d0 fb ff ff    	pushl  -0x430(%ebp)
  90:	57                   	push   %edi
  91:	53                   	push   %ebx
  92:	e8 d2 05 00 00       	call   669 <read>
  97:	83 c4 10             	add    $0x10,%esp
  9a:	85 c0                	test   %eax,%eax
  9c:	0f 88 8a 00 00 00    	js     12c <main+0x12c>
	while (size--)
  a2:	8b b5 d0 fb ff ff    	mov    -0x430(%ebp),%esi
	p = buf;
  a8:	89 fa                	mov    %edi,%edx
	crc = crc ^ ~0U;
  aa:	83 c8 ff             	or     $0xffffffff,%eax
  ad:	01 fe                	add    %edi,%esi
  af:	eb 16                	jmp    c7 <main+0xc7>
	crc = crc32_tab[(crc ^ *p++) & 0xFF] ^ (crc >> 8);
  b1:	83 c2 01             	add    $0x1,%edx
  b4:	0f b6 4a ff          	movzbl -0x1(%edx),%ecx
  b8:	31 c1                	xor    %eax,%ecx
  ba:	c1 e8 08             	shr    $0x8,%eax
  bd:	0f b6 c9             	movzbl %cl,%ecx
  c0:	33 04 8d 00 0c 00 00 	xor    0xc00(,%ecx,4),%eax
	while (size--)
  c7:	39 f2                	cmp    %esi,%edx
  c9:	75 e6                	jne    b1 <main+0xb1>
	return crc ^ ~0U;
  cb:	f7 d0                	not    %eax
			printf(1, "ERROR: Could not read file %s\n", argv[1]);
			close(fd);
			exit2(-1);
		}

	    printf(1, "%x\n", crc32(0, buffer, st.size));
  cd:	57                   	push   %edi
  ce:	50                   	push   %eax
  cf:	68 ca 0b 00 00       	push   $0xbca
  d4:	6a 01                	push   $0x1
  d6:	e8 f5 06 00 00       	call   7d0 <printf>
		break;
  db:	83 c4 10             	add    $0x10,%esp
			printf(1, "%x\n", crc32(0, currBuffer, currSt.size));			
		}
		break;	
  }
  
  close(fd);
  de:	83 ec 0c             	sub    $0xc,%esp
  e1:	53                   	push   %ebx
  e2:	e8 92 05 00 00       	call   679 <close>
  exit();
  e7:	e8 65 05 00 00       	call   651 <exit>
    printf(2, "crc32: cannot stat %s\n", argv[1]);
  ec:	50                   	push   %eax
  ed:	ff 76 04             	pushl  0x4(%esi)
  f0:	68 b3 0b 00 00       	push   $0xbb3
  f5:	6a 02                	push   $0x2
			printf(1, "ERROR: Could not read file %s\n", argv[1]);
  f7:	e8 d4 06 00 00       	call   7d0 <printf>
			close(fd);
  fc:	89 1c 24             	mov    %ebx,(%esp)
  ff:	e8 75 05 00 00       	call   679 <close>
			exit2(-1);
 104:	c7 04 24 ff ff ff ff 	movl   $0xffffffff,(%esp)
 10b:	e8 e9 05 00 00       	call   6f9 <exit2>
    printf(2, "crc32: cannot open %s\n", argv[1]);
 110:	50                   	push   %eax
 111:	ff 76 04             	pushl  0x4(%esi)
 114:	68 9c 0b 00 00       	push   $0xb9c
 119:	6a 02                	push   $0x2
 11b:	e8 b0 06 00 00       	call   7d0 <printf>
	exit2(-1);
 120:	c7 04 24 ff ff ff ff 	movl   $0xffffffff,(%esp)
 127:	e8 cd 05 00 00       	call   6f9 <exit2>
			printf(1, "ERROR: Could not read file %s\n", argv[1]);
 12c:	50                   	push   %eax
 12d:	ff 76 04             	pushl  0x4(%esi)
 130:	68 7c 0b 00 00       	push   $0xb7c
 135:	6a 01                	push   $0x1
 137:	eb be                	jmp    f7 <main+0xf7>
		if(strlen(argv[1]) + 1 + DIRSIZ + 1 > sizeof buffer){
 139:	83 ec 0c             	sub    $0xc,%esp
 13c:	ff 76 04             	pushl  0x4(%esi)
 13f:	e8 3c 03 00 00       	call   480 <strlen>
 144:	83 c4 10             	add    $0x10,%esp
 147:	83 c0 10             	add    $0x10,%eax
 14a:	3d 00 02 00 00       	cmp    $0x200,%eax
 14f:	76 16                	jbe    167 <main+0x167>
			printf(1, "crc32: path too long\n");
 151:	56                   	push   %esi
 152:	56                   	push   %esi
 153:	68 ce 0b 00 00       	push   $0xbce
 158:	6a 01                	push   $0x1
 15a:	e8 71 06 00 00       	call   7d0 <printf>
			break;
 15f:	83 c4 10             	add    $0x10,%esp
 162:	e9 77 ff ff ff       	jmp    de <main+0xde>
		strcpy(buffer, argv[1]);
 167:	8d 85 e8 fb ff ff    	lea    -0x418(%ebp),%eax
 16d:	51                   	push   %ecx
		p = buffer + strlen(buffer);
 16e:	8d bd e8 fb ff ff    	lea    -0x418(%ebp),%edi
		strcpy(buffer, argv[1]);
 174:	51                   	push   %ecx
 175:	ff 76 04             	pushl  0x4(%esi)
 178:	50                   	push   %eax
 179:	e8 82 02 00 00       	call   400 <strcpy>
		p = buffer + strlen(buffer);
 17e:	8d 85 e8 fb ff ff    	lea    -0x418(%ebp),%eax
 184:	89 04 24             	mov    %eax,(%esp)
 187:	e8 f4 02 00 00       	call   480 <strlen>
		while(read(fd, &de, sizeof(de)) == sizeof(de)){
 18c:	83 c4 10             	add    $0x10,%esp
		p = buffer + strlen(buffer);
 18f:	01 f8                	add    %edi,%eax
		*p++ = '/';
 191:	8d 78 01             	lea    0x1(%eax),%edi
		p = buffer + strlen(buffer);
 194:	89 85 a4 fb ff ff    	mov    %eax,-0x45c(%ebp)
		*p++ = '/';
 19a:	89 bd a0 fb ff ff    	mov    %edi,-0x460(%ebp)
 1a0:	c6 00 2f             	movb   $0x2f,(%eax)
		while(read(fd, &de, sizeof(de)) == sizeof(de)){
 1a3:	50                   	push   %eax
 1a4:	8d 85 b0 fb ff ff    	lea    -0x450(%ebp),%eax
 1aa:	6a 10                	push   $0x10
 1ac:	50                   	push   %eax
 1ad:	53                   	push   %ebx
 1ae:	e8 b6 04 00 00       	call   669 <read>
 1b3:	83 c4 10             	add    $0x10,%esp
 1b6:	83 f8 10             	cmp    $0x10,%eax
 1b9:	0f 85 1f ff ff ff    	jne    de <main+0xde>
			if(de.inum == 0) {
 1bf:	66 83 bd b0 fb ff ff 	cmpw   $0x0,-0x450(%ebp)
 1c6:	00 
 1c7:	74 da                	je     1a3 <main+0x1a3>
			memmove(p, de.name, DIRSIZ);
 1c9:	50                   	push   %eax
 1ca:	8d 85 b2 fb ff ff    	lea    -0x44e(%ebp),%eax
 1d0:	6a 0e                	push   $0xe
 1d2:	50                   	push   %eax
 1d3:	ff b5 a0 fb ff ff    	pushl  -0x460(%ebp)
 1d9:	e8 42 04 00 00       	call   620 <memmove>
			p[DIRSIZ] = 0;
 1de:	8b 85 a4 fb ff ff    	mov    -0x45c(%ebp),%eax
 1e4:	c6 40 0f 00          	movb   $0x0,0xf(%eax)
			if(stat(buffer, &st) < 0){
 1e8:	58                   	pop    %eax
 1e9:	8d 85 c0 fb ff ff    	lea    -0x440(%ebp),%eax
 1ef:	5a                   	pop    %edx
 1f0:	50                   	push   %eax
 1f1:	8d 85 e8 fb ff ff    	lea    -0x418(%ebp),%eax
 1f7:	50                   	push   %eax
 1f8:	e8 93 03 00 00       	call   590 <stat>
 1fd:	83 c4 10             	add    $0x10,%esp
 200:	85 c0                	test   %eax,%eax
 202:	79 19                	jns    21d <main+0x21d>
				printf(1, "ls: cannot stat %s\n", buffer);
 204:	50                   	push   %eax
 205:	8d 85 e8 fb ff ff    	lea    -0x418(%ebp),%eax
 20b:	50                   	push   %eax
 20c:	68 e4 0b 00 00       	push   $0xbe4
 211:	6a 01                	push   $0x1
 213:	e8 b8 05 00 00       	call   7d0 <printf>
				continue;
 218:	83 c4 10             	add    $0x10,%esp
 21b:	eb 86                	jmp    1a3 <main+0x1a3>
			if((currFd = open(buffer, 0)) < 0){
 21d:	50                   	push   %eax
 21e:	50                   	push   %eax
 21f:	8d 85 e8 fb ff ff    	lea    -0x418(%ebp),%eax
 225:	6a 00                	push   $0x0
 227:	50                   	push   %eax
 228:	e8 64 04 00 00       	call   691 <open>
 22d:	83 c4 10             	add    $0x10,%esp
 230:	89 c7                	mov    %eax,%edi
 232:	85 c0                	test   %eax,%eax
 234:	0f 88 8d 00 00 00    	js     2c7 <main+0x2c7>
			if(fstat(currFd, &currSt) < 0){
 23a:	50                   	push   %eax
 23b:	50                   	push   %eax
 23c:	8d 85 d4 fb ff ff    	lea    -0x42c(%ebp),%eax
 242:	50                   	push   %eax
 243:	57                   	push   %edi
 244:	e8 60 04 00 00       	call   6a9 <fstat>
 249:	83 c4 10             	add    $0x10,%esp
 24c:	85 c0                	test   %eax,%eax
 24e:	0f 88 93 00 00 00    	js     2e7 <main+0x2e7>
			if(read(currFd, currBuffer, currSt.size) < 0) {
 254:	8d 95 e8 fd ff ff    	lea    -0x218(%ebp),%edx
 25a:	51                   	push   %ecx
 25b:	ff b5 e4 fb ff ff    	pushl  -0x41c(%ebp)
 261:	52                   	push   %edx
 262:	57                   	push   %edi
 263:	e8 01 04 00 00       	call   669 <read>
 268:	83 c4 10             	add    $0x10,%esp
 26b:	8d 95 e8 fd ff ff    	lea    -0x218(%ebp),%edx
 271:	85 c0                	test   %eax,%eax
 273:	0f 88 b3 fe ff ff    	js     12c <main+0x12c>
			printf(1, "%x\n", crc32(0, currBuffer, currSt.size));			
 279:	8b bd e4 fb ff ff    	mov    -0x41c(%ebp),%edi
	while (size--)
 27f:	85 ff                	test   %edi,%edi
 281:	74 3f                	je     2c2 <main+0x2c2>
 283:	01 d7                	add    %edx,%edi
	crc = crc ^ ~0U;
 285:	83 c8 ff             	or     $0xffffffff,%eax
 288:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 28f:	90                   	nop
	crc = crc32_tab[(crc ^ *p++) & 0xFF] ^ (crc >> 8);
 290:	83 c2 01             	add    $0x1,%edx
 293:	0f b6 4a ff          	movzbl -0x1(%edx),%ecx
 297:	31 c1                	xor    %eax,%ecx
 299:	c1 e8 08             	shr    $0x8,%eax
 29c:	0f b6 c9             	movzbl %cl,%ecx
 29f:	33 04 8d 00 0c 00 00 	xor    0xc00(,%ecx,4),%eax
	while (size--)
 2a6:	39 fa                	cmp    %edi,%edx
 2a8:	75 e6                	jne    290 <main+0x290>
	return crc ^ ~0U;
 2aa:	f7 d0                	not    %eax
			printf(1, "%x\n", crc32(0, currBuffer, currSt.size));			
 2ac:	52                   	push   %edx
 2ad:	50                   	push   %eax
 2ae:	68 ca 0b 00 00       	push   $0xbca
 2b3:	6a 01                	push   $0x1
 2b5:	e8 16 05 00 00       	call   7d0 <printf>
 2ba:	83 c4 10             	add    $0x10,%esp
 2bd:	e9 e1 fe ff ff       	jmp    1a3 <main+0x1a3>
	crc = crc ^ ~0U;
 2c2:	83 c8 ff             	or     $0xffffffff,%eax
 2c5:	eb e3                	jmp    2aa <main+0x2aa>
				printf(1, "crc32: cannot open %s\n", buffer);
 2c7:	50                   	push   %eax
 2c8:	8d 85 e8 fb ff ff    	lea    -0x418(%ebp),%eax
 2ce:	50                   	push   %eax
 2cf:	68 9c 0b 00 00       	push   $0xb9c
 2d4:	6a 01                	push   $0x1
 2d6:	e8 f5 04 00 00       	call   7d0 <printf>
				exit2(-1);
 2db:	c7 04 24 ff ff ff ff 	movl   $0xffffffff,(%esp)
 2e2:	e8 12 04 00 00       	call   6f9 <exit2>
				printf(2, "crc32: cannot stat %s\n", buffer);
 2e7:	8d 85 e8 fb ff ff    	lea    -0x418(%ebp),%eax
 2ed:	56                   	push   %esi
 2ee:	50                   	push   %eax
 2ef:	68 b3 0b 00 00       	push   $0xbb3
 2f4:	6a 02                	push   $0x2
 2f6:	e9 fc fd ff ff       	jmp    f7 <main+0xf7>
 2fb:	66 90                	xchg   %ax,%ax
 2fd:	66 90                	xchg   %ax,%ax
 2ff:	90                   	nop

00000300 <fmtname>:
{
 300:	55                   	push   %ebp
 301:	89 e5                	mov    %esp,%ebp
 303:	56                   	push   %esi
 304:	53                   	push   %ebx
 305:	8b 75 08             	mov    0x8(%ebp),%esi
  for(p=path+strlen(path); p >= path && *p != '/'; p--)
 308:	83 ec 0c             	sub    $0xc,%esp
 30b:	56                   	push   %esi
 30c:	e8 6f 01 00 00       	call   480 <strlen>
 311:	83 c4 10             	add    $0x10,%esp
 314:	01 f0                	add    %esi,%eax
 316:	89 c3                	mov    %eax,%ebx
 318:	0f 82 82 00 00 00    	jb     3a0 <fmtname+0xa0>
 31e:	80 38 2f             	cmpb   $0x2f,(%eax)
 321:	75 0d                	jne    330 <fmtname+0x30>
 323:	eb 7b                	jmp    3a0 <fmtname+0xa0>
 325:	8d 76 00             	lea    0x0(%esi),%esi
 328:	80 7b ff 2f          	cmpb   $0x2f,-0x1(%ebx)
 32c:	74 09                	je     337 <fmtname+0x37>
 32e:	89 c3                	mov    %eax,%ebx
 330:	8d 43 ff             	lea    -0x1(%ebx),%eax
 333:	39 c6                	cmp    %eax,%esi
 335:	76 f1                	jbe    328 <fmtname+0x28>
  if(strlen(p) >= DIRSIZ)
 337:	83 ec 0c             	sub    $0xc,%esp
 33a:	53                   	push   %ebx
 33b:	e8 40 01 00 00       	call   480 <strlen>
 340:	83 c4 10             	add    $0x10,%esp
 343:	83 f8 0d             	cmp    $0xd,%eax
 346:	77 4a                	ja     392 <fmtname+0x92>
  memmove(buf, p, strlen(p));
 348:	83 ec 0c             	sub    $0xc,%esp
 34b:	53                   	push   %ebx
 34c:	e8 2f 01 00 00       	call   480 <strlen>
 351:	83 c4 0c             	add    $0xc,%esp
 354:	50                   	push   %eax
 355:	53                   	push   %ebx
 356:	68 18 13 00 00       	push   $0x1318
 35b:	e8 c0 02 00 00       	call   620 <memmove>
  memset(buf+strlen(p), ' ', DIRSIZ-strlen(p));
 360:	89 1c 24             	mov    %ebx,(%esp)
 363:	e8 18 01 00 00       	call   480 <strlen>
 368:	89 1c 24             	mov    %ebx,(%esp)
  return buf;
 36b:	bb 18 13 00 00       	mov    $0x1318,%ebx
  memset(buf+strlen(p), ' ', DIRSIZ-strlen(p));
 370:	89 c6                	mov    %eax,%esi
 372:	e8 09 01 00 00       	call   480 <strlen>
 377:	ba 0e 00 00 00       	mov    $0xe,%edx
 37c:	83 c4 0c             	add    $0xc,%esp
 37f:	29 f2                	sub    %esi,%edx
 381:	05 18 13 00 00       	add    $0x1318,%eax
 386:	52                   	push   %edx
 387:	6a 20                	push   $0x20
 389:	50                   	push   %eax
 38a:	e8 21 01 00 00       	call   4b0 <memset>
  return buf;
 38f:	83 c4 10             	add    $0x10,%esp
}
 392:	8d 65 f8             	lea    -0x8(%ebp),%esp
 395:	89 d8                	mov    %ebx,%eax
 397:	5b                   	pop    %ebx
 398:	5e                   	pop    %esi
 399:	5d                   	pop    %ebp
 39a:	c3                   	ret    
 39b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 39f:	90                   	nop
 3a0:	83 c3 01             	add    $0x1,%ebx
 3a3:	eb 92                	jmp    337 <fmtname+0x37>
 3a5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 3ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

000003b0 <crc32>:
{
 3b0:	55                   	push   %ebp
 3b1:	89 e5                	mov    %esp,%ebp
 3b3:	53                   	push   %ebx
 3b4:	8b 5d 10             	mov    0x10(%ebp),%ebx
 3b7:	8b 55 0c             	mov    0xc(%ebp),%edx
	crc = crc ^ ~0U;
 3ba:	8b 45 08             	mov    0x8(%ebp),%eax
	while (size--)
 3bd:	85 db                	test   %ebx,%ebx
 3bf:	74 2f                	je     3f0 <crc32+0x40>
 3c1:	f7 d0                	not    %eax
 3c3:	01 d3                	add    %edx,%ebx
 3c5:	8d 76 00             	lea    0x0(%esi),%esi
	crc = crc32_tab[(crc ^ *p++) & 0xFF] ^ (crc >> 8);
 3c8:	83 c2 01             	add    $0x1,%edx
 3cb:	0f b6 4a ff          	movzbl -0x1(%edx),%ecx
 3cf:	31 c1                	xor    %eax,%ecx
 3d1:	c1 e8 08             	shr    $0x8,%eax
 3d4:	0f b6 c9             	movzbl %cl,%ecx
 3d7:	33 04 8d 00 0c 00 00 	xor    0xc00(,%ecx,4),%eax
	while (size--)
 3de:	39 da                	cmp    %ebx,%edx
 3e0:	75 e6                	jne    3c8 <crc32+0x18>
 3e2:	f7 d0                	not    %eax
}
 3e4:	5b                   	pop    %ebx
 3e5:	5d                   	pop    %ebp
 3e6:	c3                   	ret    
 3e7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 3ee:	66 90                	xchg   %ax,%ax
	while (size--)
 3f0:	8b 45 08             	mov    0x8(%ebp),%eax
}
 3f3:	5b                   	pop    %ebx
 3f4:	5d                   	pop    %ebp
 3f5:	c3                   	ret    
 3f6:	66 90                	xchg   %ax,%ax
 3f8:	66 90                	xchg   %ax,%ax
 3fa:	66 90                	xchg   %ax,%ax
 3fc:	66 90                	xchg   %ax,%ax
 3fe:	66 90                	xchg   %ax,%ax

00000400 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
 400:	55                   	push   %ebp
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 401:	31 d2                	xor    %edx,%edx
{
 403:	89 e5                	mov    %esp,%ebp
 405:	53                   	push   %ebx
 406:	8b 45 08             	mov    0x8(%ebp),%eax
 409:	8b 5d 0c             	mov    0xc(%ebp),%ebx
 40c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while((*s++ = *t++) != 0)
 410:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
 414:	88 0c 10             	mov    %cl,(%eax,%edx,1)
 417:	83 c2 01             	add    $0x1,%edx
 41a:	84 c9                	test   %cl,%cl
 41c:	75 f2                	jne    410 <strcpy+0x10>
    ;
  return os;
}
 41e:	5b                   	pop    %ebx
 41f:	5d                   	pop    %ebp
 420:	c3                   	ret    
 421:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 428:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 42f:	90                   	nop

00000430 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 430:	55                   	push   %ebp
 431:	89 e5                	mov    %esp,%ebp
 433:	56                   	push   %esi
 434:	53                   	push   %ebx
 435:	8b 5d 08             	mov    0x8(%ebp),%ebx
 438:	8b 75 0c             	mov    0xc(%ebp),%esi
  while(*p && *p == *q)
 43b:	0f b6 13             	movzbl (%ebx),%edx
 43e:	0f b6 0e             	movzbl (%esi),%ecx
 441:	84 d2                	test   %dl,%dl
 443:	74 1e                	je     463 <strcmp+0x33>
 445:	b8 01 00 00 00       	mov    $0x1,%eax
 44a:	38 ca                	cmp    %cl,%dl
 44c:	74 09                	je     457 <strcmp+0x27>
 44e:	eb 20                	jmp    470 <strcmp+0x40>
 450:	83 c0 01             	add    $0x1,%eax
 453:	38 ca                	cmp    %cl,%dl
 455:	75 19                	jne    470 <strcmp+0x40>
 457:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
 45b:	0f b6 0c 06          	movzbl (%esi,%eax,1),%ecx
 45f:	84 d2                	test   %dl,%dl
 461:	75 ed                	jne    450 <strcmp+0x20>
 463:	31 c0                	xor    %eax,%eax
    p++, q++;
  return (uchar)*p - (uchar)*q;
}
 465:	5b                   	pop    %ebx
 466:	5e                   	pop    %esi
  return (uchar)*p - (uchar)*q;
 467:	29 c8                	sub    %ecx,%eax
}
 469:	5d                   	pop    %ebp
 46a:	c3                   	ret    
 46b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 46f:	90                   	nop
 470:	0f b6 c2             	movzbl %dl,%eax
 473:	5b                   	pop    %ebx
 474:	5e                   	pop    %esi
  return (uchar)*p - (uchar)*q;
 475:	29 c8                	sub    %ecx,%eax
}
 477:	5d                   	pop    %ebp
 478:	c3                   	ret    
 479:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000480 <strlen>:

uint
strlen(const char *s)
{
 480:	55                   	push   %ebp
 481:	89 e5                	mov    %esp,%ebp
 483:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
 486:	80 39 00             	cmpb   $0x0,(%ecx)
 489:	74 15                	je     4a0 <strlen+0x20>
 48b:	31 d2                	xor    %edx,%edx
 48d:	8d 76 00             	lea    0x0(%esi),%esi
 490:	83 c2 01             	add    $0x1,%edx
 493:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
 497:	89 d0                	mov    %edx,%eax
 499:	75 f5                	jne    490 <strlen+0x10>
    ;
  return n;
}
 49b:	5d                   	pop    %ebp
 49c:	c3                   	ret    
 49d:	8d 76 00             	lea    0x0(%esi),%esi
  for(n = 0; s[n]; n++)
 4a0:	31 c0                	xor    %eax,%eax
}
 4a2:	5d                   	pop    %ebp
 4a3:	c3                   	ret    
 4a4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 4ab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 4af:	90                   	nop

000004b0 <memset>:

void*
memset(void *dst, int c, uint n)
{
 4b0:	55                   	push   %ebp
 4b1:	89 e5                	mov    %esp,%ebp
 4b3:	57                   	push   %edi
 4b4:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 4b7:	8b 4d 10             	mov    0x10(%ebp),%ecx
 4ba:	8b 45 0c             	mov    0xc(%ebp),%eax
 4bd:	89 d7                	mov    %edx,%edi
 4bf:	fc                   	cld    
 4c0:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 4c2:	89 d0                	mov    %edx,%eax
 4c4:	5f                   	pop    %edi
 4c5:	5d                   	pop    %ebp
 4c6:	c3                   	ret    
 4c7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 4ce:	66 90                	xchg   %ax,%ax

000004d0 <strchr>:

char*
strchr(const char *s, char c)
{
 4d0:	55                   	push   %ebp
 4d1:	89 e5                	mov    %esp,%ebp
 4d3:	53                   	push   %ebx
 4d4:	8b 45 08             	mov    0x8(%ebp),%eax
 4d7:	8b 55 0c             	mov    0xc(%ebp),%edx
  for(; *s; s++)
 4da:	0f b6 18             	movzbl (%eax),%ebx
 4dd:	84 db                	test   %bl,%bl
 4df:	74 1d                	je     4fe <strchr+0x2e>
 4e1:	89 d1                	mov    %edx,%ecx
    if(*s == c)
 4e3:	38 d3                	cmp    %dl,%bl
 4e5:	75 0d                	jne    4f4 <strchr+0x24>
 4e7:	eb 17                	jmp    500 <strchr+0x30>
 4e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 4f0:	38 ca                	cmp    %cl,%dl
 4f2:	74 0c                	je     500 <strchr+0x30>
  for(; *s; s++)
 4f4:	83 c0 01             	add    $0x1,%eax
 4f7:	0f b6 10             	movzbl (%eax),%edx
 4fa:	84 d2                	test   %dl,%dl
 4fc:	75 f2                	jne    4f0 <strchr+0x20>
      return (char*)s;
  return 0;
 4fe:	31 c0                	xor    %eax,%eax
}
 500:	5b                   	pop    %ebx
 501:	5d                   	pop    %ebp
 502:	c3                   	ret    
 503:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 50a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00000510 <gets>:

char*
gets(char *buf, int max)
{
 510:	55                   	push   %ebp
 511:	89 e5                	mov    %esp,%ebp
 513:	57                   	push   %edi
 514:	56                   	push   %esi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 515:	31 f6                	xor    %esi,%esi
{
 517:	53                   	push   %ebx
 518:	89 f3                	mov    %esi,%ebx
 51a:	83 ec 1c             	sub    $0x1c,%esp
 51d:	8b 7d 08             	mov    0x8(%ebp),%edi
  for(i=0; i+1 < max; ){
 520:	eb 2f                	jmp    551 <gets+0x41>
 522:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    cc = read(0, &c, 1);
 528:	83 ec 04             	sub    $0x4,%esp
 52b:	8d 45 e7             	lea    -0x19(%ebp),%eax
 52e:	6a 01                	push   $0x1
 530:	50                   	push   %eax
 531:	6a 00                	push   $0x0
 533:	e8 31 01 00 00       	call   669 <read>
    if(cc < 1)
 538:	83 c4 10             	add    $0x10,%esp
 53b:	85 c0                	test   %eax,%eax
 53d:	7e 1c                	jle    55b <gets+0x4b>
      break;
    buf[i++] = c;
 53f:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 543:	83 c7 01             	add    $0x1,%edi
 546:	88 47 ff             	mov    %al,-0x1(%edi)
    if(c == '\n' || c == '\r')
 549:	3c 0a                	cmp    $0xa,%al
 54b:	74 23                	je     570 <gets+0x60>
 54d:	3c 0d                	cmp    $0xd,%al
 54f:	74 1f                	je     570 <gets+0x60>
  for(i=0; i+1 < max; ){
 551:	83 c3 01             	add    $0x1,%ebx
 554:	89 fe                	mov    %edi,%esi
 556:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 559:	7c cd                	jl     528 <gets+0x18>
 55b:	89 f3                	mov    %esi,%ebx
      break;
  }
  buf[i] = '\0';
  return buf;
}
 55d:	8b 45 08             	mov    0x8(%ebp),%eax
  buf[i] = '\0';
 560:	c6 03 00             	movb   $0x0,(%ebx)
}
 563:	8d 65 f4             	lea    -0xc(%ebp),%esp
 566:	5b                   	pop    %ebx
 567:	5e                   	pop    %esi
 568:	5f                   	pop    %edi
 569:	5d                   	pop    %ebp
 56a:	c3                   	ret    
 56b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 56f:	90                   	nop
 570:	8b 75 08             	mov    0x8(%ebp),%esi
 573:	8b 45 08             	mov    0x8(%ebp),%eax
 576:	01 de                	add    %ebx,%esi
 578:	89 f3                	mov    %esi,%ebx
  buf[i] = '\0';
 57a:	c6 03 00             	movb   $0x0,(%ebx)
}
 57d:	8d 65 f4             	lea    -0xc(%ebp),%esp
 580:	5b                   	pop    %ebx
 581:	5e                   	pop    %esi
 582:	5f                   	pop    %edi
 583:	5d                   	pop    %ebp
 584:	c3                   	ret    
 585:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 58c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000590 <stat>:

int
stat(const char *n, struct stat *st)
{
 590:	55                   	push   %ebp
 591:	89 e5                	mov    %esp,%ebp
 593:	56                   	push   %esi
 594:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 595:	83 ec 08             	sub    $0x8,%esp
 598:	6a 00                	push   $0x0
 59a:	ff 75 08             	pushl  0x8(%ebp)
 59d:	e8 ef 00 00 00       	call   691 <open>
  if(fd < 0)
 5a2:	83 c4 10             	add    $0x10,%esp
 5a5:	85 c0                	test   %eax,%eax
 5a7:	78 27                	js     5d0 <stat+0x40>
    return -1;
  r = fstat(fd, st);
 5a9:	83 ec 08             	sub    $0x8,%esp
 5ac:	ff 75 0c             	pushl  0xc(%ebp)
 5af:	89 c3                	mov    %eax,%ebx
 5b1:	50                   	push   %eax
 5b2:	e8 f2 00 00 00       	call   6a9 <fstat>
  close(fd);
 5b7:	89 1c 24             	mov    %ebx,(%esp)
  r = fstat(fd, st);
 5ba:	89 c6                	mov    %eax,%esi
  close(fd);
 5bc:	e8 b8 00 00 00       	call   679 <close>
  return r;
 5c1:	83 c4 10             	add    $0x10,%esp
}
 5c4:	8d 65 f8             	lea    -0x8(%ebp),%esp
 5c7:	89 f0                	mov    %esi,%eax
 5c9:	5b                   	pop    %ebx
 5ca:	5e                   	pop    %esi
 5cb:	5d                   	pop    %ebp
 5cc:	c3                   	ret    
 5cd:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
 5d0:	be ff ff ff ff       	mov    $0xffffffff,%esi
 5d5:	eb ed                	jmp    5c4 <stat+0x34>
 5d7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 5de:	66 90                	xchg   %ax,%ax

000005e0 <atoi>:

int
atoi(const char *s)
{
 5e0:	55                   	push   %ebp
 5e1:	89 e5                	mov    %esp,%ebp
 5e3:	53                   	push   %ebx
 5e4:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 5e7:	0f be 11             	movsbl (%ecx),%edx
 5ea:	8d 42 d0             	lea    -0x30(%edx),%eax
 5ed:	3c 09                	cmp    $0x9,%al
  n = 0;
 5ef:	b8 00 00 00 00       	mov    $0x0,%eax
  while('0' <= *s && *s <= '9')
 5f4:	77 1f                	ja     615 <atoi+0x35>
 5f6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 5fd:	8d 76 00             	lea    0x0(%esi),%esi
    n = n*10 + *s++ - '0';
 600:	83 c1 01             	add    $0x1,%ecx
 603:	8d 04 80             	lea    (%eax,%eax,4),%eax
 606:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
  while('0' <= *s && *s <= '9')
 60a:	0f be 11             	movsbl (%ecx),%edx
 60d:	8d 5a d0             	lea    -0x30(%edx),%ebx
 610:	80 fb 09             	cmp    $0x9,%bl
 613:	76 eb                	jbe    600 <atoi+0x20>
  return n;
}
 615:	5b                   	pop    %ebx
 616:	5d                   	pop    %ebp
 617:	c3                   	ret    
 618:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 61f:	90                   	nop

00000620 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 620:	55                   	push   %ebp
 621:	89 e5                	mov    %esp,%ebp
 623:	57                   	push   %edi
 624:	8b 55 10             	mov    0x10(%ebp),%edx
 627:	8b 45 08             	mov    0x8(%ebp),%eax
 62a:	56                   	push   %esi
 62b:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 62e:	85 d2                	test   %edx,%edx
 630:	7e 13                	jle    645 <memmove+0x25>
 632:	01 c2                	add    %eax,%edx
  dst = vdst;
 634:	89 c7                	mov    %eax,%edi
 636:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 63d:	8d 76 00             	lea    0x0(%esi),%esi
    *dst++ = *src++;
 640:	a4                   	movsb  %ds:(%esi),%es:(%edi)
  while(n-- > 0)
 641:	39 fa                	cmp    %edi,%edx
 643:	75 fb                	jne    640 <memmove+0x20>
  return vdst;
}
 645:	5e                   	pop    %esi
 646:	5f                   	pop    %edi
 647:	5d                   	pop    %ebp
 648:	c3                   	ret    

00000649 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 649:	b8 01 00 00 00       	mov    $0x1,%eax
 64e:	cd 40                	int    $0x40
 650:	c3                   	ret    

00000651 <exit>:
SYSCALL(exit)
 651:	b8 02 00 00 00       	mov    $0x2,%eax
 656:	cd 40                	int    $0x40
 658:	c3                   	ret    

00000659 <wait>:
SYSCALL(wait)
 659:	b8 03 00 00 00       	mov    $0x3,%eax
 65e:	cd 40                	int    $0x40
 660:	c3                   	ret    

00000661 <pipe>:
SYSCALL(pipe)
 661:	b8 04 00 00 00       	mov    $0x4,%eax
 666:	cd 40                	int    $0x40
 668:	c3                   	ret    

00000669 <read>:
SYSCALL(read)
 669:	b8 05 00 00 00       	mov    $0x5,%eax
 66e:	cd 40                	int    $0x40
 670:	c3                   	ret    

00000671 <write>:
SYSCALL(write)
 671:	b8 10 00 00 00       	mov    $0x10,%eax
 676:	cd 40                	int    $0x40
 678:	c3                   	ret    

00000679 <close>:
SYSCALL(close)
 679:	b8 15 00 00 00       	mov    $0x15,%eax
 67e:	cd 40                	int    $0x40
 680:	c3                   	ret    

00000681 <kill>:
SYSCALL(kill)
 681:	b8 06 00 00 00       	mov    $0x6,%eax
 686:	cd 40                	int    $0x40
 688:	c3                   	ret    

00000689 <exec>:
SYSCALL(exec)
 689:	b8 07 00 00 00       	mov    $0x7,%eax
 68e:	cd 40                	int    $0x40
 690:	c3                   	ret    

00000691 <open>:
SYSCALL(open)
 691:	b8 0f 00 00 00       	mov    $0xf,%eax
 696:	cd 40                	int    $0x40
 698:	c3                   	ret    

00000699 <mknod>:
SYSCALL(mknod)
 699:	b8 11 00 00 00       	mov    $0x11,%eax
 69e:	cd 40                	int    $0x40
 6a0:	c3                   	ret    

000006a1 <unlink>:
SYSCALL(unlink)
 6a1:	b8 12 00 00 00       	mov    $0x12,%eax
 6a6:	cd 40                	int    $0x40
 6a8:	c3                   	ret    

000006a9 <fstat>:
SYSCALL(fstat)
 6a9:	b8 08 00 00 00       	mov    $0x8,%eax
 6ae:	cd 40                	int    $0x40
 6b0:	c3                   	ret    

000006b1 <link>:
SYSCALL(link)
 6b1:	b8 13 00 00 00       	mov    $0x13,%eax
 6b6:	cd 40                	int    $0x40
 6b8:	c3                   	ret    

000006b9 <mkdir>:
SYSCALL(mkdir)
 6b9:	b8 14 00 00 00       	mov    $0x14,%eax
 6be:	cd 40                	int    $0x40
 6c0:	c3                   	ret    

000006c1 <chdir>:
SYSCALL(chdir)
 6c1:	b8 09 00 00 00       	mov    $0x9,%eax
 6c6:	cd 40                	int    $0x40
 6c8:	c3                   	ret    

000006c9 <dup>:
SYSCALL(dup)
 6c9:	b8 0a 00 00 00       	mov    $0xa,%eax
 6ce:	cd 40                	int    $0x40
 6d0:	c3                   	ret    

000006d1 <getpid>:
SYSCALL(getpid)
 6d1:	b8 0b 00 00 00       	mov    $0xb,%eax
 6d6:	cd 40                	int    $0x40
 6d8:	c3                   	ret    

000006d9 <sbrk>:
SYSCALL(sbrk)
 6d9:	b8 0c 00 00 00       	mov    $0xc,%eax
 6de:	cd 40                	int    $0x40
 6e0:	c3                   	ret    

000006e1 <sleep>:
SYSCALL(sleep)
 6e1:	b8 0d 00 00 00       	mov    $0xd,%eax
 6e6:	cd 40                	int    $0x40
 6e8:	c3                   	ret    

000006e9 <uptime>:
SYSCALL(uptime)
 6e9:	b8 0e 00 00 00       	mov    $0xe,%eax
 6ee:	cd 40                	int    $0x40
 6f0:	c3                   	ret    

000006f1 <freemem>:
SYSCALL(freemem)
 6f1:	b8 16 00 00 00       	mov    $0x16,%eax
 6f6:	cd 40                	int    $0x40
 6f8:	c3                   	ret    

000006f9 <exit2>:
SYSCALL(exit2)
 6f9:	b8 17 00 00 00       	mov    $0x17,%eax
 6fe:	cd 40                	int    $0x40
 700:	c3                   	ret    

00000701 <wait2>:
SYSCALL(wait2)
 701:	b8 18 00 00 00       	mov    $0x18,%eax
 706:	cd 40                	int    $0x40
 708:	c3                   	ret    
 709:	66 90                	xchg   %ax,%ax
 70b:	66 90                	xchg   %ax,%ax
 70d:	66 90                	xchg   %ax,%ax
 70f:	90                   	nop

00000710 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 710:	55                   	push   %ebp
 711:	89 e5                	mov    %esp,%ebp
 713:	57                   	push   %edi
 714:	56                   	push   %esi
 715:	53                   	push   %ebx
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
 716:	89 d3                	mov    %edx,%ebx
{
 718:	83 ec 3c             	sub    $0x3c,%esp
 71b:	89 45 bc             	mov    %eax,-0x44(%ebp)
  if(sgn && xx < 0){
 71e:	85 d2                	test   %edx,%edx
 720:	0f 89 92 00 00 00    	jns    7b8 <printint+0xa8>
 726:	f6 45 08 01          	testb  $0x1,0x8(%ebp)
 72a:	0f 84 88 00 00 00    	je     7b8 <printint+0xa8>
    neg = 1;
 730:	c7 45 c0 01 00 00 00 	movl   $0x1,-0x40(%ebp)
    x = -xx;
 737:	f7 db                	neg    %ebx
  } else {
    x = xx;
  }

  i = 0;
 739:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
 740:	8d 75 d7             	lea    -0x29(%ebp),%esi
 743:	eb 08                	jmp    74d <printint+0x3d>
 745:	8d 76 00             	lea    0x0(%esi),%esi
  do{
    buf[i++] = digits[x % base];
 748:	89 7d c4             	mov    %edi,-0x3c(%ebp)
  }while((x /= base) != 0);
 74b:	89 c3                	mov    %eax,%ebx
    buf[i++] = digits[x % base];
 74d:	89 d8                	mov    %ebx,%eax
 74f:	31 d2                	xor    %edx,%edx
 751:	8b 7d c4             	mov    -0x3c(%ebp),%edi
 754:	f7 f1                	div    %ecx
 756:	83 c7 01             	add    $0x1,%edi
 759:	0f b6 92 08 10 00 00 	movzbl 0x1008(%edx),%edx
 760:	88 14 3e             	mov    %dl,(%esi,%edi,1)
  }while((x /= base) != 0);
 763:	39 d9                	cmp    %ebx,%ecx
 765:	76 e1                	jbe    748 <printint+0x38>
  if(neg)
 767:	8b 45 c0             	mov    -0x40(%ebp),%eax
 76a:	85 c0                	test   %eax,%eax
 76c:	74 0d                	je     77b <printint+0x6b>
    buf[i++] = '-';
 76e:	c6 44 3d d8 2d       	movb   $0x2d,-0x28(%ebp,%edi,1)
 773:	ba 2d 00 00 00       	mov    $0x2d,%edx
    buf[i++] = digits[x % base];
 778:	89 7d c4             	mov    %edi,-0x3c(%ebp)

  while(--i >= 0)
 77b:	8b 45 c4             	mov    -0x3c(%ebp),%eax
 77e:	8b 7d bc             	mov    -0x44(%ebp),%edi
 781:	8d 5c 05 d7          	lea    -0x29(%ebp,%eax,1),%ebx
 785:	eb 0f                	jmp    796 <printint+0x86>
 787:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 78e:	66 90                	xchg   %ax,%ax
 790:	0f b6 13             	movzbl (%ebx),%edx
 793:	83 eb 01             	sub    $0x1,%ebx
  write(fd, &c, 1);
 796:	83 ec 04             	sub    $0x4,%esp
 799:	88 55 d7             	mov    %dl,-0x29(%ebp)
 79c:	6a 01                	push   $0x1
 79e:	56                   	push   %esi
 79f:	57                   	push   %edi
 7a0:	e8 cc fe ff ff       	call   671 <write>
  while(--i >= 0)
 7a5:	83 c4 10             	add    $0x10,%esp
 7a8:	39 de                	cmp    %ebx,%esi
 7aa:	75 e4                	jne    790 <printint+0x80>
    putc(fd, buf[i]);
}
 7ac:	8d 65 f4             	lea    -0xc(%ebp),%esp
 7af:	5b                   	pop    %ebx
 7b0:	5e                   	pop    %esi
 7b1:	5f                   	pop    %edi
 7b2:	5d                   	pop    %ebp
 7b3:	c3                   	ret    
 7b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  neg = 0;
 7b8:	c7 45 c0 00 00 00 00 	movl   $0x0,-0x40(%ebp)
 7bf:	e9 75 ff ff ff       	jmp    739 <printint+0x29>
 7c4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 7cb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 7cf:	90                   	nop

000007d0 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 7d0:	55                   	push   %ebp
 7d1:	89 e5                	mov    %esp,%ebp
 7d3:	57                   	push   %edi
 7d4:	56                   	push   %esi
 7d5:	53                   	push   %ebx
 7d6:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 7d9:	8b 75 0c             	mov    0xc(%ebp),%esi
 7dc:	0f b6 1e             	movzbl (%esi),%ebx
 7df:	84 db                	test   %bl,%bl
 7e1:	0f 84 b9 00 00 00    	je     8a0 <printf+0xd0>
  ap = (uint*)(void*)&fmt + 1;
 7e7:	8d 45 10             	lea    0x10(%ebp),%eax
 7ea:	83 c6 01             	add    $0x1,%esi
  write(fd, &c, 1);
 7ed:	8d 7d e7             	lea    -0x19(%ebp),%edi
  state = 0;
 7f0:	31 d2                	xor    %edx,%edx
  ap = (uint*)(void*)&fmt + 1;
 7f2:	89 45 d0             	mov    %eax,-0x30(%ebp)
 7f5:	eb 38                	jmp    82f <printf+0x5f>
 7f7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 7fe:	66 90                	xchg   %ax,%ax
 800:	89 55 d4             	mov    %edx,-0x2c(%ebp)
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
 803:	ba 25 00 00 00       	mov    $0x25,%edx
      if(c == '%'){
 808:	83 f8 25             	cmp    $0x25,%eax
 80b:	74 17                	je     824 <printf+0x54>
  write(fd, &c, 1);
 80d:	83 ec 04             	sub    $0x4,%esp
 810:	88 5d e7             	mov    %bl,-0x19(%ebp)
 813:	6a 01                	push   $0x1
 815:	57                   	push   %edi
 816:	ff 75 08             	pushl  0x8(%ebp)
 819:	e8 53 fe ff ff       	call   671 <write>
 81e:	8b 55 d4             	mov    -0x2c(%ebp),%edx
      } else {
        putc(fd, c);
 821:	83 c4 10             	add    $0x10,%esp
  for(i = 0; fmt[i]; i++){
 824:	83 c6 01             	add    $0x1,%esi
 827:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
 82b:	84 db                	test   %bl,%bl
 82d:	74 71                	je     8a0 <printf+0xd0>
    c = fmt[i] & 0xff;
 82f:	0f be cb             	movsbl %bl,%ecx
 832:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
 835:	85 d2                	test   %edx,%edx
 837:	74 c7                	je     800 <printf+0x30>
      }
    } else if(state == '%'){
 839:	83 fa 25             	cmp    $0x25,%edx
 83c:	75 e6                	jne    824 <printf+0x54>
      if(c == 'd'){
 83e:	83 f8 64             	cmp    $0x64,%eax
 841:	0f 84 99 00 00 00    	je     8e0 <printf+0x110>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 847:	81 e1 f7 00 00 00    	and    $0xf7,%ecx
 84d:	83 f9 70             	cmp    $0x70,%ecx
 850:	74 5e                	je     8b0 <printf+0xe0>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 852:	83 f8 73             	cmp    $0x73,%eax
 855:	0f 84 d5 00 00 00    	je     930 <printf+0x160>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 85b:	83 f8 63             	cmp    $0x63,%eax
 85e:	0f 84 8c 00 00 00    	je     8f0 <printf+0x120>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 864:	83 f8 25             	cmp    $0x25,%eax
 867:	0f 84 b3 00 00 00    	je     920 <printf+0x150>
  write(fd, &c, 1);
 86d:	83 ec 04             	sub    $0x4,%esp
 870:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
 874:	6a 01                	push   $0x1
 876:	57                   	push   %edi
 877:	ff 75 08             	pushl  0x8(%ebp)
 87a:	e8 f2 fd ff ff       	call   671 <write>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
 87f:	88 5d e7             	mov    %bl,-0x19(%ebp)
  write(fd, &c, 1);
 882:	83 c4 0c             	add    $0xc,%esp
 885:	6a 01                	push   $0x1
 887:	83 c6 01             	add    $0x1,%esi
 88a:	57                   	push   %edi
 88b:	ff 75 08             	pushl  0x8(%ebp)
 88e:	e8 de fd ff ff       	call   671 <write>
  for(i = 0; fmt[i]; i++){
 893:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
        putc(fd, c);
 897:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 89a:	31 d2                	xor    %edx,%edx
  for(i = 0; fmt[i]; i++){
 89c:	84 db                	test   %bl,%bl
 89e:	75 8f                	jne    82f <printf+0x5f>
    }
  }
}
 8a0:	8d 65 f4             	lea    -0xc(%ebp),%esp
 8a3:	5b                   	pop    %ebx
 8a4:	5e                   	pop    %esi
 8a5:	5f                   	pop    %edi
 8a6:	5d                   	pop    %ebp
 8a7:	c3                   	ret    
 8a8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 8af:	90                   	nop
        printint(fd, *ap, 16, 0);
 8b0:	83 ec 0c             	sub    $0xc,%esp
 8b3:	b9 10 00 00 00       	mov    $0x10,%ecx
 8b8:	6a 00                	push   $0x0
 8ba:	8b 5d d0             	mov    -0x30(%ebp),%ebx
 8bd:	8b 45 08             	mov    0x8(%ebp),%eax
 8c0:	8b 13                	mov    (%ebx),%edx
 8c2:	e8 49 fe ff ff       	call   710 <printint>
        ap++;
 8c7:	89 d8                	mov    %ebx,%eax
 8c9:	83 c4 10             	add    $0x10,%esp
      state = 0;
 8cc:	31 d2                	xor    %edx,%edx
        ap++;
 8ce:	83 c0 04             	add    $0x4,%eax
 8d1:	89 45 d0             	mov    %eax,-0x30(%ebp)
 8d4:	e9 4b ff ff ff       	jmp    824 <printf+0x54>
 8d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        printint(fd, *ap, 10, 1);
 8e0:	83 ec 0c             	sub    $0xc,%esp
 8e3:	b9 0a 00 00 00       	mov    $0xa,%ecx
 8e8:	6a 01                	push   $0x1
 8ea:	eb ce                	jmp    8ba <printf+0xea>
 8ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        putc(fd, *ap);
 8f0:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  write(fd, &c, 1);
 8f3:	83 ec 04             	sub    $0x4,%esp
        putc(fd, *ap);
 8f6:	8b 03                	mov    (%ebx),%eax
  write(fd, &c, 1);
 8f8:	6a 01                	push   $0x1
        ap++;
 8fa:	83 c3 04             	add    $0x4,%ebx
  write(fd, &c, 1);
 8fd:	57                   	push   %edi
 8fe:	ff 75 08             	pushl  0x8(%ebp)
        putc(fd, *ap);
 901:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 904:	e8 68 fd ff ff       	call   671 <write>
        ap++;
 909:	89 5d d0             	mov    %ebx,-0x30(%ebp)
 90c:	83 c4 10             	add    $0x10,%esp
      state = 0;
 90f:	31 d2                	xor    %edx,%edx
 911:	e9 0e ff ff ff       	jmp    824 <printf+0x54>
 916:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 91d:	8d 76 00             	lea    0x0(%esi),%esi
        putc(fd, c);
 920:	88 5d e7             	mov    %bl,-0x19(%ebp)
  write(fd, &c, 1);
 923:	83 ec 04             	sub    $0x4,%esp
 926:	e9 5a ff ff ff       	jmp    885 <printf+0xb5>
 92b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 92f:	90                   	nop
        s = (char*)*ap;
 930:	8b 45 d0             	mov    -0x30(%ebp),%eax
 933:	8b 18                	mov    (%eax),%ebx
        ap++;
 935:	83 c0 04             	add    $0x4,%eax
 938:	89 45 d0             	mov    %eax,-0x30(%ebp)
        if(s == 0)
 93b:	85 db                	test   %ebx,%ebx
 93d:	74 17                	je     956 <printf+0x186>
        while(*s != 0){
 93f:	0f b6 03             	movzbl (%ebx),%eax
      state = 0;
 942:	31 d2                	xor    %edx,%edx
        while(*s != 0){
 944:	84 c0                	test   %al,%al
 946:	0f 84 d8 fe ff ff    	je     824 <printf+0x54>
 94c:	89 75 d4             	mov    %esi,-0x2c(%ebp)
 94f:	89 de                	mov    %ebx,%esi
 951:	8b 5d 08             	mov    0x8(%ebp),%ebx
 954:	eb 1a                	jmp    970 <printf+0x1a0>
          s = "(null)";
 956:	bb 00 10 00 00       	mov    $0x1000,%ebx
        while(*s != 0){
 95b:	89 75 d4             	mov    %esi,-0x2c(%ebp)
 95e:	b8 28 00 00 00       	mov    $0x28,%eax
 963:	89 de                	mov    %ebx,%esi
 965:	8b 5d 08             	mov    0x8(%ebp),%ebx
 968:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 96f:	90                   	nop
  write(fd, &c, 1);
 970:	83 ec 04             	sub    $0x4,%esp
          s++;
 973:	83 c6 01             	add    $0x1,%esi
 976:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 979:	6a 01                	push   $0x1
 97b:	57                   	push   %edi
 97c:	53                   	push   %ebx
 97d:	e8 ef fc ff ff       	call   671 <write>
        while(*s != 0){
 982:	0f b6 06             	movzbl (%esi),%eax
 985:	83 c4 10             	add    $0x10,%esp
 988:	84 c0                	test   %al,%al
 98a:	75 e4                	jne    970 <printf+0x1a0>
 98c:	8b 75 d4             	mov    -0x2c(%ebp),%esi
      state = 0;
 98f:	31 d2                	xor    %edx,%edx
 991:	e9 8e fe ff ff       	jmp    824 <printf+0x54>
 996:	66 90                	xchg   %ax,%ax
 998:	66 90                	xchg   %ax,%ax
 99a:	66 90                	xchg   %ax,%ax
 99c:	66 90                	xchg   %ax,%ax
 99e:	66 90                	xchg   %ax,%ax

000009a0 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 9a0:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 9a1:	a1 28 13 00 00       	mov    0x1328,%eax
{
 9a6:	89 e5                	mov    %esp,%ebp
 9a8:	57                   	push   %edi
 9a9:	56                   	push   %esi
 9aa:	53                   	push   %ebx
 9ab:	8b 5d 08             	mov    0x8(%ebp),%ebx
 9ae:	8b 10                	mov    (%eax),%edx
  bp = (Header*)ap - 1;
 9b0:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 9b3:	39 c8                	cmp    %ecx,%eax
 9b5:	73 19                	jae    9d0 <free+0x30>
 9b7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 9be:	66 90                	xchg   %ax,%ax
 9c0:	39 d1                	cmp    %edx,%ecx
 9c2:	72 14                	jb     9d8 <free+0x38>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 9c4:	39 d0                	cmp    %edx,%eax
 9c6:	73 10                	jae    9d8 <free+0x38>
{
 9c8:	89 d0                	mov    %edx,%eax
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 9ca:	8b 10                	mov    (%eax),%edx
 9cc:	39 c8                	cmp    %ecx,%eax
 9ce:	72 f0                	jb     9c0 <free+0x20>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 9d0:	39 d0                	cmp    %edx,%eax
 9d2:	72 f4                	jb     9c8 <free+0x28>
 9d4:	39 d1                	cmp    %edx,%ecx
 9d6:	73 f0                	jae    9c8 <free+0x28>
      break;
  if(bp + bp->s.size == p->s.ptr){
 9d8:	8b 73 fc             	mov    -0x4(%ebx),%esi
 9db:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 9de:	39 fa                	cmp    %edi,%edx
 9e0:	74 1e                	je     a00 <free+0x60>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 9e2:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 9e5:	8b 50 04             	mov    0x4(%eax),%edx
 9e8:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 9eb:	39 f1                	cmp    %esi,%ecx
 9ed:	74 28                	je     a17 <free+0x77>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 9ef:	89 08                	mov    %ecx,(%eax)
  freep = p;
}
 9f1:	5b                   	pop    %ebx
  freep = p;
 9f2:	a3 28 13 00 00       	mov    %eax,0x1328
}
 9f7:	5e                   	pop    %esi
 9f8:	5f                   	pop    %edi
 9f9:	5d                   	pop    %ebp
 9fa:	c3                   	ret    
 9fb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 9ff:	90                   	nop
    bp->s.size += p->s.ptr->s.size;
 a00:	03 72 04             	add    0x4(%edx),%esi
 a03:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 a06:	8b 10                	mov    (%eax),%edx
 a08:	8b 12                	mov    (%edx),%edx
 a0a:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 a0d:	8b 50 04             	mov    0x4(%eax),%edx
 a10:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 a13:	39 f1                	cmp    %esi,%ecx
 a15:	75 d8                	jne    9ef <free+0x4f>
    p->s.size += bp->s.size;
 a17:	03 53 fc             	add    -0x4(%ebx),%edx
  freep = p;
 a1a:	a3 28 13 00 00       	mov    %eax,0x1328
    p->s.size += bp->s.size;
 a1f:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 a22:	8b 53 f8             	mov    -0x8(%ebx),%edx
 a25:	89 10                	mov    %edx,(%eax)
}
 a27:	5b                   	pop    %ebx
 a28:	5e                   	pop    %esi
 a29:	5f                   	pop    %edi
 a2a:	5d                   	pop    %ebp
 a2b:	c3                   	ret    
 a2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000a30 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 a30:	55                   	push   %ebp
 a31:	89 e5                	mov    %esp,%ebp
 a33:	57                   	push   %edi
 a34:	56                   	push   %esi
 a35:	53                   	push   %ebx
 a36:	83 ec 1c             	sub    $0x1c,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 a39:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
 a3c:	8b 3d 28 13 00 00    	mov    0x1328,%edi
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 a42:	8d 70 07             	lea    0x7(%eax),%esi
 a45:	c1 ee 03             	shr    $0x3,%esi
 a48:	83 c6 01             	add    $0x1,%esi
  if((prevp = freep) == 0){
 a4b:	85 ff                	test   %edi,%edi
 a4d:	0f 84 ad 00 00 00    	je     b00 <malloc+0xd0>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a53:	8b 17                	mov    (%edi),%edx
    if(p->s.size >= nunits){
 a55:	8b 4a 04             	mov    0x4(%edx),%ecx
 a58:	39 f1                	cmp    %esi,%ecx
 a5a:	73 72                	jae    ace <malloc+0x9e>
 a5c:	81 fe 00 10 00 00    	cmp    $0x1000,%esi
 a62:	bb 00 10 00 00       	mov    $0x1000,%ebx
 a67:	0f 43 de             	cmovae %esi,%ebx
  p = sbrk(nu * sizeof(Header));
 a6a:	8d 04 dd 00 00 00 00 	lea    0x0(,%ebx,8),%eax
 a71:	89 45 e4             	mov    %eax,-0x1c(%ebp)
 a74:	eb 1b                	jmp    a91 <malloc+0x61>
 a76:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 a7d:	8d 76 00             	lea    0x0(%esi),%esi
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a80:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 a82:	8b 48 04             	mov    0x4(%eax),%ecx
 a85:	39 f1                	cmp    %esi,%ecx
 a87:	73 4f                	jae    ad8 <malloc+0xa8>
 a89:	8b 3d 28 13 00 00    	mov    0x1328,%edi
 a8f:	89 c2                	mov    %eax,%edx
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 a91:	39 d7                	cmp    %edx,%edi
 a93:	75 eb                	jne    a80 <malloc+0x50>
  p = sbrk(nu * sizeof(Header));
 a95:	83 ec 0c             	sub    $0xc,%esp
 a98:	ff 75 e4             	pushl  -0x1c(%ebp)
 a9b:	e8 39 fc ff ff       	call   6d9 <sbrk>
  if(p == (char*)-1)
 aa0:	83 c4 10             	add    $0x10,%esp
 aa3:	83 f8 ff             	cmp    $0xffffffff,%eax
 aa6:	74 1c                	je     ac4 <malloc+0x94>
  hp->s.size = nu;
 aa8:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 aab:	83 ec 0c             	sub    $0xc,%esp
 aae:	83 c0 08             	add    $0x8,%eax
 ab1:	50                   	push   %eax
 ab2:	e8 e9 fe ff ff       	call   9a0 <free>
  return freep;
 ab7:	8b 15 28 13 00 00    	mov    0x1328,%edx
      if((p = morecore(nunits)) == 0)
 abd:	83 c4 10             	add    $0x10,%esp
 ac0:	85 d2                	test   %edx,%edx
 ac2:	75 bc                	jne    a80 <malloc+0x50>
        return 0;
  }
}
 ac4:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return 0;
 ac7:	31 c0                	xor    %eax,%eax
}
 ac9:	5b                   	pop    %ebx
 aca:	5e                   	pop    %esi
 acb:	5f                   	pop    %edi
 acc:	5d                   	pop    %ebp
 acd:	c3                   	ret    
    if(p->s.size >= nunits){
 ace:	89 d0                	mov    %edx,%eax
 ad0:	89 fa                	mov    %edi,%edx
 ad2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      if(p->s.size == nunits)
 ad8:	39 ce                	cmp    %ecx,%esi
 ada:	74 54                	je     b30 <malloc+0x100>
        p->s.size -= nunits;
 adc:	29 f1                	sub    %esi,%ecx
 ade:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
 ae1:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
 ae4:	89 70 04             	mov    %esi,0x4(%eax)
      freep = prevp;
 ae7:	89 15 28 13 00 00    	mov    %edx,0x1328
}
 aed:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return (void*)(p + 1);
 af0:	83 c0 08             	add    $0x8,%eax
}
 af3:	5b                   	pop    %ebx
 af4:	5e                   	pop    %esi
 af5:	5f                   	pop    %edi
 af6:	5d                   	pop    %ebp
 af7:	c3                   	ret    
 af8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 aff:	90                   	nop
    base.s.ptr = freep = prevp = &base;
 b00:	c7 05 28 13 00 00 2c 	movl   $0x132c,0x1328
 b07:	13 00 00 
    base.s.size = 0;
 b0a:	bf 2c 13 00 00       	mov    $0x132c,%edi
    base.s.ptr = freep = prevp = &base;
 b0f:	c7 05 2c 13 00 00 2c 	movl   $0x132c,0x132c
 b16:	13 00 00 
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 b19:	89 fa                	mov    %edi,%edx
    base.s.size = 0;
 b1b:	c7 05 30 13 00 00 00 	movl   $0x0,0x1330
 b22:	00 00 00 
    if(p->s.size >= nunits){
 b25:	e9 32 ff ff ff       	jmp    a5c <malloc+0x2c>
 b2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        prevp->s.ptr = p->s.ptr;
 b30:	8b 08                	mov    (%eax),%ecx
 b32:	89 0a                	mov    %ecx,(%edx)
 b34:	eb b1                	jmp    ae7 <malloc+0xb7>
