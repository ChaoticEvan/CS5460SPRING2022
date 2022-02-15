
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
  11:	83 ec 28             	sub    $0x28,%esp
  int fd;
  struct stat st;
  if(argc != 2){
  14:	83 39 02             	cmpl   $0x2,(%ecx)
{
  17:	8b 59 04             	mov    0x4(%ecx),%ebx
  if(argc != 2){
  1a:	74 1a                	je     36 <main+0x36>
	printf(1, "ERROR: crc32 does not have the correct amount of arguments\n");
  1c:	50                   	push   %eax
  1d:	50                   	push   %eax
  1e:	68 e0 09 00 00       	push   $0x9e0
  23:	6a 01                	push   $0x1
  25:	e8 16 06 00 00       	call   640 <printf>
    exit2(-1);
  2a:	c7 04 24 ff ff ff ff 	movl   $0xffffffff,(%esp)
  31:	e8 33 05 00 00       	call   569 <exit2>
  }

  if((fd = open(argv[1], 0)) < 0){
  36:	57                   	push   %edi
  37:	57                   	push   %edi
  38:	6a 00                	push   $0x0
  3a:	ff 73 04             	pushl  0x4(%ebx)
  3d:	e8 bf 04 00 00       	call   501 <open>
  42:	83 c4 10             	add    $0x10,%esp
  45:	89 c6                	mov    %eax,%esi
  47:	85 c0                	test   %eax,%eax
  49:	78 43                	js     8e <main+0x8e>
    printf(2, "crc32: cannot open %s\n", argv[1]);
	exit2(-1);
  } 

  if(fstat(fd, &st) < 0){
  4b:	8d 7d d4             	lea    -0x2c(%ebp),%edi
  4e:	51                   	push   %ecx
  4f:	51                   	push   %ecx
  50:	57                   	push   %edi
  51:	50                   	push   %eax
  52:	e8 c2 04 00 00       	call   519 <fstat>
  57:	83 c4 10             	add    $0x10,%esp
  5a:	85 c0                	test   %eax,%eax
  5c:	78 0c                	js     6a <main+0x6a>
    printf(2, "crc32: cannot stat %s\n", argv[1]);
    close(fd);
    exit2(-1);
  }
  
  switch (st.type) {
  5e:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
  63:	74 45                	je     aa <main+0xaa>
		break;
	
	default:
		break;
  }
  exit();
  65:	e8 57 04 00 00       	call   4c1 <exit>
    printf(2, "crc32: cannot stat %s\n", argv[1]);
  6a:	52                   	push   %edx
  6b:	ff 73 04             	pushl  0x4(%ebx)
  6e:	68 37 0a 00 00       	push   $0xa37
  73:	6a 02                	push   $0x2
  75:	e8 c6 05 00 00       	call   640 <printf>
    close(fd);
  7a:	89 34 24             	mov    %esi,(%esp)
  7d:	e8 67 04 00 00       	call   4e9 <close>
    exit2(-1);
  82:	c7 04 24 ff ff ff ff 	movl   $0xffffffff,(%esp)
  89:	e8 db 04 00 00       	call   569 <exit2>
    printf(2, "crc32: cannot open %s\n", argv[1]);
  8e:	56                   	push   %esi
  8f:	ff 73 04             	pushl  0x4(%ebx)
  92:	68 20 0a 00 00       	push   $0xa20
  97:	6a 02                	push   $0x2
  99:	e8 a2 05 00 00       	call   640 <printf>
	exit2(-1);
  9e:	c7 04 24 ff ff ff ff 	movl   $0xffffffff,(%esp)
  a5:	e8 bf 04 00 00       	call   569 <exit2>
		crcFile(fd, &st, argv[1]);
  aa:	50                   	push   %eax
  ab:	ff 73 04             	pushl  0x4(%ebx)
  ae:	57                   	push   %edi
  af:	56                   	push   %esi
  b0:	e8 0b 01 00 00       	call   1c0 <crcFile>
		break;
  b5:	83 c4 10             	add    $0x10,%esp
  b8:	eb ab                	jmp    65 <main+0x65>
  ba:	66 90                	xchg   %ax,%ax
  bc:	66 90                	xchg   %ax,%ax
  be:	66 90                	xchg   %ax,%ax

000000c0 <fmtname>:
{
  c0:	55                   	push   %ebp
  c1:	89 e5                	mov    %esp,%ebp
  c3:	56                   	push   %esi
  c4:	53                   	push   %ebx
  c5:	8b 75 08             	mov    0x8(%ebp),%esi
  for(p=path+strlen(path); p >= path && *p != '/'; p--)
  c8:	83 ec 0c             	sub    $0xc,%esp
  cb:	56                   	push   %esi
  cc:	e8 1f 02 00 00       	call   2f0 <strlen>
  d1:	83 c4 10             	add    $0x10,%esp
  d4:	01 f0                	add    %esi,%eax
  d6:	89 c3                	mov    %eax,%ebx
  d8:	0f 82 82 00 00 00    	jb     160 <fmtname+0xa0>
  de:	80 38 2f             	cmpb   $0x2f,(%eax)
  e1:	75 0d                	jne    f0 <fmtname+0x30>
  e3:	eb 7b                	jmp    160 <fmtname+0xa0>
  e5:	8d 76 00             	lea    0x0(%esi),%esi
  e8:	80 7b ff 2f          	cmpb   $0x2f,-0x1(%ebx)
  ec:	74 09                	je     f7 <fmtname+0x37>
  ee:	89 c3                	mov    %eax,%ebx
  f0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  f3:	39 c6                	cmp    %eax,%esi
  f5:	76 f1                	jbe    e8 <fmtname+0x28>
  if(strlen(p) >= DIRSIZ)
  f7:	83 ec 0c             	sub    $0xc,%esp
  fa:	53                   	push   %ebx
  fb:	e8 f0 01 00 00       	call   2f0 <strlen>
 100:	83 c4 10             	add    $0x10,%esp
 103:	83 f8 0d             	cmp    $0xd,%eax
 106:	77 4a                	ja     152 <fmtname+0x92>
  memmove(buf, p, strlen(p));
 108:	83 ec 0c             	sub    $0xc,%esp
 10b:	53                   	push   %ebx
 10c:	e8 df 01 00 00       	call   2f0 <strlen>
 111:	83 c4 0c             	add    $0xc,%esp
 114:	50                   	push   %eax
 115:	53                   	push   %ebx
 116:	68 a8 11 00 00       	push   $0x11a8
 11b:	e8 70 03 00 00       	call   490 <memmove>
  memset(buf+strlen(p), ' ', DIRSIZ-strlen(p));
 120:	89 1c 24             	mov    %ebx,(%esp)
 123:	e8 c8 01 00 00       	call   2f0 <strlen>
 128:	89 1c 24             	mov    %ebx,(%esp)
  return buf;
 12b:	bb a8 11 00 00       	mov    $0x11a8,%ebx
  memset(buf+strlen(p), ' ', DIRSIZ-strlen(p));
 130:	89 c6                	mov    %eax,%esi
 132:	e8 b9 01 00 00       	call   2f0 <strlen>
 137:	ba 0e 00 00 00       	mov    $0xe,%edx
 13c:	83 c4 0c             	add    $0xc,%esp
 13f:	29 f2                	sub    %esi,%edx
 141:	05 a8 11 00 00       	add    $0x11a8,%eax
 146:	52                   	push   %edx
 147:	6a 20                	push   $0x20
 149:	50                   	push   %eax
 14a:	e8 d1 01 00 00       	call   320 <memset>
  return buf;
 14f:	83 c4 10             	add    $0x10,%esp
}
 152:	8d 65 f8             	lea    -0x8(%ebp),%esp
 155:	89 d8                	mov    %ebx,%eax
 157:	5b                   	pop    %ebx
 158:	5e                   	pop    %esi
 159:	5d                   	pop    %ebp
 15a:	c3                   	ret    
 15b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 15f:	90                   	nop
 160:	83 c3 01             	add    $0x1,%ebx
 163:	eb 92                	jmp    f7 <fmtname+0x37>
 165:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 16c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000170 <crc32>:
{
 170:	55                   	push   %ebp
 171:	89 e5                	mov    %esp,%ebp
 173:	53                   	push   %ebx
 174:	8b 5d 10             	mov    0x10(%ebp),%ebx
 177:	8b 55 0c             	mov    0xc(%ebp),%edx
	crc = crc ^ ~0U;
 17a:	8b 45 08             	mov    0x8(%ebp),%eax
	while (size--)
 17d:	85 db                	test   %ebx,%ebx
 17f:	74 2f                	je     1b0 <crc32+0x40>
 181:	f7 d0                	not    %eax
 183:	01 d3                	add    %edx,%ebx
 185:	8d 76 00             	lea    0x0(%esi),%esi
	crc = crc32_tab[(crc ^ *p++) & 0xFF] ^ (crc >> 8);
 188:	83 c2 01             	add    $0x1,%edx
 18b:	0f b6 4a ff          	movzbl -0x1(%edx),%ecx
 18f:	31 c1                	xor    %eax,%ecx
 191:	c1 e8 08             	shr    $0x8,%eax
 194:	0f b6 c9             	movzbl %cl,%ecx
 197:	33 04 8d 60 0a 00 00 	xor    0xa60(,%ecx,4),%eax
	while (size--)
 19e:	39 da                	cmp    %ebx,%edx
 1a0:	75 e6                	jne    188 <crc32+0x18>
 1a2:	f7 d0                	not    %eax
}
 1a4:	5b                   	pop    %ebx
 1a5:	5d                   	pop    %ebp
 1a6:	c3                   	ret    
 1a7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 1ae:	66 90                	xchg   %ax,%ax
	while (size--)
 1b0:	8b 45 08             	mov    0x8(%ebp),%eax
}
 1b3:	5b                   	pop    %ebx
 1b4:	5d                   	pop    %ebp
 1b5:	c3                   	ret    
 1b6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 1bd:	8d 76 00             	lea    0x0(%esi),%esi

000001c0 <crcFile>:
crcFile(int fd, struct stat* st, char* path) {
 1c0:	55                   	push   %ebp
 1c1:	89 e5                	mov    %esp,%ebp
 1c3:	57                   	push   %edi
 1c4:	56                   	push   %esi
 1c5:	53                   	push   %ebx
 1c6:	83 ec 28             	sub    $0x28,%esp
 1c9:	8b 7d 0c             	mov    0xc(%ebp),%edi
 1cc:	8b 45 10             	mov    0x10(%ebp),%eax
 1cf:	8b 75 08             	mov    0x8(%ebp),%esi
  char* buffer = malloc(st->size);
 1d2:	ff 77 10             	pushl  0x10(%edi)
crcFile(int fd, struct stat* st, char* path) {
 1d5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  char* buffer = malloc(st->size);
 1d8:	e8 c3 06 00 00       	call   8a0 <malloc>
  if(read(fd, buffer, st->size) < 0)
 1dd:	83 c4 0c             	add    $0xc,%esp
 1e0:	ff 77 10             	pushl  0x10(%edi)
 1e3:	50                   	push   %eax
  char* buffer = malloc(st->size);
 1e4:	89 c3                	mov    %eax,%ebx
  if(read(fd, buffer, st->size) < 0)
 1e6:	56                   	push   %esi
 1e7:	e8 ed 02 00 00       	call   4d9 <read>
 1ec:	83 c4 10             	add    $0x10,%esp
 1ef:	85 c0                	test   %eax,%eax
 1f1:	78 4e                	js     241 <crcFile+0x81>
  printf(1, "%x\n", crc32(0, buffer, st->size));
 1f3:	8b 47 10             	mov    0x10(%edi),%eax
	while (size--)
 1f6:	85 c0                	test   %eax,%eax
 1f8:	74 2a                	je     224 <crcFile+0x64>
 1fa:	8d 0c 03             	lea    (%ebx,%eax,1),%ecx
	crc = crc ^ ~0U;
 1fd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 202:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
	crc = crc32_tab[(crc ^ *p++) & 0xFF] ^ (crc >> 8);
 208:	83 c3 01             	add    $0x1,%ebx
 20b:	0f b6 53 ff          	movzbl -0x1(%ebx),%edx
 20f:	31 c2                	xor    %eax,%edx
 211:	c1 e8 08             	shr    $0x8,%eax
 214:	0f b6 d2             	movzbl %dl,%edx
 217:	33 04 95 60 0a 00 00 	xor    0xa60(,%edx,4),%eax
	while (size--)
 21e:	39 cb                	cmp    %ecx,%ebx
 220:	75 e6                	jne    208 <crcFile+0x48>
 222:	f7 d0                	not    %eax
  printf(1, "%x\n", crc32(0, buffer, st->size));
 224:	89 45 10             	mov    %eax,0x10(%ebp)
 227:	c7 45 0c 1c 0a 00 00 	movl   $0xa1c,0xc(%ebp)
 22e:	c7 45 08 01 00 00 00 	movl   $0x1,0x8(%ebp)
}
 235:	8d 65 f4             	lea    -0xc(%ebp),%esp
 238:	5b                   	pop    %ebx
 239:	5e                   	pop    %esi
 23a:	5f                   	pop    %edi
 23b:	5d                   	pop    %ebp
  printf(1, "%x\n", crc32(0, buffer, st->size));
 23c:	e9 ff 03 00 00       	jmp    640 <printf>
	  printf(1, "ERROR: Could not read file %s\n", path);
 241:	50                   	push   %eax
 242:	ff 75 e4             	pushl  -0x1c(%ebp)
 245:	68 c0 09 00 00       	push   $0x9c0
 24a:	6a 01                	push   $0x1
 24c:	e8 ef 03 00 00       	call   640 <printf>
	  close(fd);
 251:	89 34 24             	mov    %esi,(%esp)
 254:	e8 90 02 00 00       	call   4e9 <close>
	  exit2(-1);
 259:	c7 04 24 ff ff ff ff 	movl   $0xffffffff,(%esp)
 260:	e8 04 03 00 00       	call   569 <exit2>
 265:	66 90                	xchg   %ax,%ax
 267:	66 90                	xchg   %ax,%ax
 269:	66 90                	xchg   %ax,%ax
 26b:	66 90                	xchg   %ax,%ax
 26d:	66 90                	xchg   %ax,%ax
 26f:	90                   	nop

00000270 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
 270:	55                   	push   %ebp
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 271:	31 d2                	xor    %edx,%edx
{
 273:	89 e5                	mov    %esp,%ebp
 275:	53                   	push   %ebx
 276:	8b 45 08             	mov    0x8(%ebp),%eax
 279:	8b 5d 0c             	mov    0xc(%ebp),%ebx
 27c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while((*s++ = *t++) != 0)
 280:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
 284:	88 0c 10             	mov    %cl,(%eax,%edx,1)
 287:	83 c2 01             	add    $0x1,%edx
 28a:	84 c9                	test   %cl,%cl
 28c:	75 f2                	jne    280 <strcpy+0x10>
    ;
  return os;
}
 28e:	5b                   	pop    %ebx
 28f:	5d                   	pop    %ebp
 290:	c3                   	ret    
 291:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 298:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 29f:	90                   	nop

000002a0 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 2a0:	55                   	push   %ebp
 2a1:	89 e5                	mov    %esp,%ebp
 2a3:	56                   	push   %esi
 2a4:	53                   	push   %ebx
 2a5:	8b 5d 08             	mov    0x8(%ebp),%ebx
 2a8:	8b 75 0c             	mov    0xc(%ebp),%esi
  while(*p && *p == *q)
 2ab:	0f b6 13             	movzbl (%ebx),%edx
 2ae:	0f b6 0e             	movzbl (%esi),%ecx
 2b1:	84 d2                	test   %dl,%dl
 2b3:	74 1e                	je     2d3 <strcmp+0x33>
 2b5:	b8 01 00 00 00       	mov    $0x1,%eax
 2ba:	38 ca                	cmp    %cl,%dl
 2bc:	74 09                	je     2c7 <strcmp+0x27>
 2be:	eb 20                	jmp    2e0 <strcmp+0x40>
 2c0:	83 c0 01             	add    $0x1,%eax
 2c3:	38 ca                	cmp    %cl,%dl
 2c5:	75 19                	jne    2e0 <strcmp+0x40>
 2c7:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
 2cb:	0f b6 0c 06          	movzbl (%esi,%eax,1),%ecx
 2cf:	84 d2                	test   %dl,%dl
 2d1:	75 ed                	jne    2c0 <strcmp+0x20>
 2d3:	31 c0                	xor    %eax,%eax
    p++, q++;
  return (uchar)*p - (uchar)*q;
}
 2d5:	5b                   	pop    %ebx
 2d6:	5e                   	pop    %esi
  return (uchar)*p - (uchar)*q;
 2d7:	29 c8                	sub    %ecx,%eax
}
 2d9:	5d                   	pop    %ebp
 2da:	c3                   	ret    
 2db:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 2df:	90                   	nop
 2e0:	0f b6 c2             	movzbl %dl,%eax
 2e3:	5b                   	pop    %ebx
 2e4:	5e                   	pop    %esi
  return (uchar)*p - (uchar)*q;
 2e5:	29 c8                	sub    %ecx,%eax
}
 2e7:	5d                   	pop    %ebp
 2e8:	c3                   	ret    
 2e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

000002f0 <strlen>:

uint
strlen(const char *s)
{
 2f0:	55                   	push   %ebp
 2f1:	89 e5                	mov    %esp,%ebp
 2f3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
 2f6:	80 39 00             	cmpb   $0x0,(%ecx)
 2f9:	74 15                	je     310 <strlen+0x20>
 2fb:	31 d2                	xor    %edx,%edx
 2fd:	8d 76 00             	lea    0x0(%esi),%esi
 300:	83 c2 01             	add    $0x1,%edx
 303:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
 307:	89 d0                	mov    %edx,%eax
 309:	75 f5                	jne    300 <strlen+0x10>
    ;
  return n;
}
 30b:	5d                   	pop    %ebp
 30c:	c3                   	ret    
 30d:	8d 76 00             	lea    0x0(%esi),%esi
  for(n = 0; s[n]; n++)
 310:	31 c0                	xor    %eax,%eax
}
 312:	5d                   	pop    %ebp
 313:	c3                   	ret    
 314:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 31b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 31f:	90                   	nop

00000320 <memset>:

void*
memset(void *dst, int c, uint n)
{
 320:	55                   	push   %ebp
 321:	89 e5                	mov    %esp,%ebp
 323:	57                   	push   %edi
 324:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 327:	8b 4d 10             	mov    0x10(%ebp),%ecx
 32a:	8b 45 0c             	mov    0xc(%ebp),%eax
 32d:	89 d7                	mov    %edx,%edi
 32f:	fc                   	cld    
 330:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 332:	89 d0                	mov    %edx,%eax
 334:	5f                   	pop    %edi
 335:	5d                   	pop    %ebp
 336:	c3                   	ret    
 337:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 33e:	66 90                	xchg   %ax,%ax

00000340 <strchr>:

char*
strchr(const char *s, char c)
{
 340:	55                   	push   %ebp
 341:	89 e5                	mov    %esp,%ebp
 343:	53                   	push   %ebx
 344:	8b 45 08             	mov    0x8(%ebp),%eax
 347:	8b 55 0c             	mov    0xc(%ebp),%edx
  for(; *s; s++)
 34a:	0f b6 18             	movzbl (%eax),%ebx
 34d:	84 db                	test   %bl,%bl
 34f:	74 1d                	je     36e <strchr+0x2e>
 351:	89 d1                	mov    %edx,%ecx
    if(*s == c)
 353:	38 d3                	cmp    %dl,%bl
 355:	75 0d                	jne    364 <strchr+0x24>
 357:	eb 17                	jmp    370 <strchr+0x30>
 359:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 360:	38 ca                	cmp    %cl,%dl
 362:	74 0c                	je     370 <strchr+0x30>
  for(; *s; s++)
 364:	83 c0 01             	add    $0x1,%eax
 367:	0f b6 10             	movzbl (%eax),%edx
 36a:	84 d2                	test   %dl,%dl
 36c:	75 f2                	jne    360 <strchr+0x20>
      return (char*)s;
  return 0;
 36e:	31 c0                	xor    %eax,%eax
}
 370:	5b                   	pop    %ebx
 371:	5d                   	pop    %ebp
 372:	c3                   	ret    
 373:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 37a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00000380 <gets>:

char*
gets(char *buf, int max)
{
 380:	55                   	push   %ebp
 381:	89 e5                	mov    %esp,%ebp
 383:	57                   	push   %edi
 384:	56                   	push   %esi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 385:	31 f6                	xor    %esi,%esi
{
 387:	53                   	push   %ebx
 388:	89 f3                	mov    %esi,%ebx
 38a:	83 ec 1c             	sub    $0x1c,%esp
 38d:	8b 7d 08             	mov    0x8(%ebp),%edi
  for(i=0; i+1 < max; ){
 390:	eb 2f                	jmp    3c1 <gets+0x41>
 392:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    cc = read(0, &c, 1);
 398:	83 ec 04             	sub    $0x4,%esp
 39b:	8d 45 e7             	lea    -0x19(%ebp),%eax
 39e:	6a 01                	push   $0x1
 3a0:	50                   	push   %eax
 3a1:	6a 00                	push   $0x0
 3a3:	e8 31 01 00 00       	call   4d9 <read>
    if(cc < 1)
 3a8:	83 c4 10             	add    $0x10,%esp
 3ab:	85 c0                	test   %eax,%eax
 3ad:	7e 1c                	jle    3cb <gets+0x4b>
      break;
    buf[i++] = c;
 3af:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 3b3:	83 c7 01             	add    $0x1,%edi
 3b6:	88 47 ff             	mov    %al,-0x1(%edi)
    if(c == '\n' || c == '\r')
 3b9:	3c 0a                	cmp    $0xa,%al
 3bb:	74 23                	je     3e0 <gets+0x60>
 3bd:	3c 0d                	cmp    $0xd,%al
 3bf:	74 1f                	je     3e0 <gets+0x60>
  for(i=0; i+1 < max; ){
 3c1:	83 c3 01             	add    $0x1,%ebx
 3c4:	89 fe                	mov    %edi,%esi
 3c6:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 3c9:	7c cd                	jl     398 <gets+0x18>
 3cb:	89 f3                	mov    %esi,%ebx
      break;
  }
  buf[i] = '\0';
  return buf;
}
 3cd:	8b 45 08             	mov    0x8(%ebp),%eax
  buf[i] = '\0';
 3d0:	c6 03 00             	movb   $0x0,(%ebx)
}
 3d3:	8d 65 f4             	lea    -0xc(%ebp),%esp
 3d6:	5b                   	pop    %ebx
 3d7:	5e                   	pop    %esi
 3d8:	5f                   	pop    %edi
 3d9:	5d                   	pop    %ebp
 3da:	c3                   	ret    
 3db:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 3df:	90                   	nop
 3e0:	8b 75 08             	mov    0x8(%ebp),%esi
 3e3:	8b 45 08             	mov    0x8(%ebp),%eax
 3e6:	01 de                	add    %ebx,%esi
 3e8:	89 f3                	mov    %esi,%ebx
  buf[i] = '\0';
 3ea:	c6 03 00             	movb   $0x0,(%ebx)
}
 3ed:	8d 65 f4             	lea    -0xc(%ebp),%esp
 3f0:	5b                   	pop    %ebx
 3f1:	5e                   	pop    %esi
 3f2:	5f                   	pop    %edi
 3f3:	5d                   	pop    %ebp
 3f4:	c3                   	ret    
 3f5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 3fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000400 <stat>:

int
stat(const char *n, struct stat *st)
{
 400:	55                   	push   %ebp
 401:	89 e5                	mov    %esp,%ebp
 403:	56                   	push   %esi
 404:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 405:	83 ec 08             	sub    $0x8,%esp
 408:	6a 00                	push   $0x0
 40a:	ff 75 08             	pushl  0x8(%ebp)
 40d:	e8 ef 00 00 00       	call   501 <open>
  if(fd < 0)
 412:	83 c4 10             	add    $0x10,%esp
 415:	85 c0                	test   %eax,%eax
 417:	78 27                	js     440 <stat+0x40>
    return -1;
  r = fstat(fd, st);
 419:	83 ec 08             	sub    $0x8,%esp
 41c:	ff 75 0c             	pushl  0xc(%ebp)
 41f:	89 c3                	mov    %eax,%ebx
 421:	50                   	push   %eax
 422:	e8 f2 00 00 00       	call   519 <fstat>
  close(fd);
 427:	89 1c 24             	mov    %ebx,(%esp)
  r = fstat(fd, st);
 42a:	89 c6                	mov    %eax,%esi
  close(fd);
 42c:	e8 b8 00 00 00       	call   4e9 <close>
  return r;
 431:	83 c4 10             	add    $0x10,%esp
}
 434:	8d 65 f8             	lea    -0x8(%ebp),%esp
 437:	89 f0                	mov    %esi,%eax
 439:	5b                   	pop    %ebx
 43a:	5e                   	pop    %esi
 43b:	5d                   	pop    %ebp
 43c:	c3                   	ret    
 43d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
 440:	be ff ff ff ff       	mov    $0xffffffff,%esi
 445:	eb ed                	jmp    434 <stat+0x34>
 447:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 44e:	66 90                	xchg   %ax,%ax

00000450 <atoi>:

int
atoi(const char *s)
{
 450:	55                   	push   %ebp
 451:	89 e5                	mov    %esp,%ebp
 453:	53                   	push   %ebx
 454:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 457:	0f be 11             	movsbl (%ecx),%edx
 45a:	8d 42 d0             	lea    -0x30(%edx),%eax
 45d:	3c 09                	cmp    $0x9,%al
  n = 0;
 45f:	b8 00 00 00 00       	mov    $0x0,%eax
  while('0' <= *s && *s <= '9')
 464:	77 1f                	ja     485 <atoi+0x35>
 466:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 46d:	8d 76 00             	lea    0x0(%esi),%esi
    n = n*10 + *s++ - '0';
 470:	83 c1 01             	add    $0x1,%ecx
 473:	8d 04 80             	lea    (%eax,%eax,4),%eax
 476:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
  while('0' <= *s && *s <= '9')
 47a:	0f be 11             	movsbl (%ecx),%edx
 47d:	8d 5a d0             	lea    -0x30(%edx),%ebx
 480:	80 fb 09             	cmp    $0x9,%bl
 483:	76 eb                	jbe    470 <atoi+0x20>
  return n;
}
 485:	5b                   	pop    %ebx
 486:	5d                   	pop    %ebp
 487:	c3                   	ret    
 488:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 48f:	90                   	nop

00000490 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 490:	55                   	push   %ebp
 491:	89 e5                	mov    %esp,%ebp
 493:	57                   	push   %edi
 494:	8b 55 10             	mov    0x10(%ebp),%edx
 497:	8b 45 08             	mov    0x8(%ebp),%eax
 49a:	56                   	push   %esi
 49b:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 49e:	85 d2                	test   %edx,%edx
 4a0:	7e 13                	jle    4b5 <memmove+0x25>
 4a2:	01 c2                	add    %eax,%edx
  dst = vdst;
 4a4:	89 c7                	mov    %eax,%edi
 4a6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 4ad:	8d 76 00             	lea    0x0(%esi),%esi
    *dst++ = *src++;
 4b0:	a4                   	movsb  %ds:(%esi),%es:(%edi)
  while(n-- > 0)
 4b1:	39 fa                	cmp    %edi,%edx
 4b3:	75 fb                	jne    4b0 <memmove+0x20>
  return vdst;
}
 4b5:	5e                   	pop    %esi
 4b6:	5f                   	pop    %edi
 4b7:	5d                   	pop    %ebp
 4b8:	c3                   	ret    

000004b9 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 4b9:	b8 01 00 00 00       	mov    $0x1,%eax
 4be:	cd 40                	int    $0x40
 4c0:	c3                   	ret    

000004c1 <exit>:
SYSCALL(exit)
 4c1:	b8 02 00 00 00       	mov    $0x2,%eax
 4c6:	cd 40                	int    $0x40
 4c8:	c3                   	ret    

000004c9 <wait>:
SYSCALL(wait)
 4c9:	b8 03 00 00 00       	mov    $0x3,%eax
 4ce:	cd 40                	int    $0x40
 4d0:	c3                   	ret    

000004d1 <pipe>:
SYSCALL(pipe)
 4d1:	b8 04 00 00 00       	mov    $0x4,%eax
 4d6:	cd 40                	int    $0x40
 4d8:	c3                   	ret    

000004d9 <read>:
SYSCALL(read)
 4d9:	b8 05 00 00 00       	mov    $0x5,%eax
 4de:	cd 40                	int    $0x40
 4e0:	c3                   	ret    

000004e1 <write>:
SYSCALL(write)
 4e1:	b8 10 00 00 00       	mov    $0x10,%eax
 4e6:	cd 40                	int    $0x40
 4e8:	c3                   	ret    

000004e9 <close>:
SYSCALL(close)
 4e9:	b8 15 00 00 00       	mov    $0x15,%eax
 4ee:	cd 40                	int    $0x40
 4f0:	c3                   	ret    

000004f1 <kill>:
SYSCALL(kill)
 4f1:	b8 06 00 00 00       	mov    $0x6,%eax
 4f6:	cd 40                	int    $0x40
 4f8:	c3                   	ret    

000004f9 <exec>:
SYSCALL(exec)
 4f9:	b8 07 00 00 00       	mov    $0x7,%eax
 4fe:	cd 40                	int    $0x40
 500:	c3                   	ret    

00000501 <open>:
SYSCALL(open)
 501:	b8 0f 00 00 00       	mov    $0xf,%eax
 506:	cd 40                	int    $0x40
 508:	c3                   	ret    

00000509 <mknod>:
SYSCALL(mknod)
 509:	b8 11 00 00 00       	mov    $0x11,%eax
 50e:	cd 40                	int    $0x40
 510:	c3                   	ret    

00000511 <unlink>:
SYSCALL(unlink)
 511:	b8 12 00 00 00       	mov    $0x12,%eax
 516:	cd 40                	int    $0x40
 518:	c3                   	ret    

00000519 <fstat>:
SYSCALL(fstat)
 519:	b8 08 00 00 00       	mov    $0x8,%eax
 51e:	cd 40                	int    $0x40
 520:	c3                   	ret    

00000521 <link>:
SYSCALL(link)
 521:	b8 13 00 00 00       	mov    $0x13,%eax
 526:	cd 40                	int    $0x40
 528:	c3                   	ret    

00000529 <mkdir>:
SYSCALL(mkdir)
 529:	b8 14 00 00 00       	mov    $0x14,%eax
 52e:	cd 40                	int    $0x40
 530:	c3                   	ret    

00000531 <chdir>:
SYSCALL(chdir)
 531:	b8 09 00 00 00       	mov    $0x9,%eax
 536:	cd 40                	int    $0x40
 538:	c3                   	ret    

00000539 <dup>:
SYSCALL(dup)
 539:	b8 0a 00 00 00       	mov    $0xa,%eax
 53e:	cd 40                	int    $0x40
 540:	c3                   	ret    

00000541 <getpid>:
SYSCALL(getpid)
 541:	b8 0b 00 00 00       	mov    $0xb,%eax
 546:	cd 40                	int    $0x40
 548:	c3                   	ret    

00000549 <sbrk>:
SYSCALL(sbrk)
 549:	b8 0c 00 00 00       	mov    $0xc,%eax
 54e:	cd 40                	int    $0x40
 550:	c3                   	ret    

00000551 <sleep>:
SYSCALL(sleep)
 551:	b8 0d 00 00 00       	mov    $0xd,%eax
 556:	cd 40                	int    $0x40
 558:	c3                   	ret    

00000559 <uptime>:
SYSCALL(uptime)
 559:	b8 0e 00 00 00       	mov    $0xe,%eax
 55e:	cd 40                	int    $0x40
 560:	c3                   	ret    

00000561 <freemem>:
SYSCALL(freemem)
 561:	b8 16 00 00 00       	mov    $0x16,%eax
 566:	cd 40                	int    $0x40
 568:	c3                   	ret    

00000569 <exit2>:
SYSCALL(exit2)
 569:	b8 17 00 00 00       	mov    $0x17,%eax
 56e:	cd 40                	int    $0x40
 570:	c3                   	ret    

00000571 <wait2>:
SYSCALL(wait2)
 571:	b8 18 00 00 00       	mov    $0x18,%eax
 576:	cd 40                	int    $0x40
 578:	c3                   	ret    
 579:	66 90                	xchg   %ax,%ax
 57b:	66 90                	xchg   %ax,%ax
 57d:	66 90                	xchg   %ax,%ax
 57f:	90                   	nop

00000580 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 580:	55                   	push   %ebp
 581:	89 e5                	mov    %esp,%ebp
 583:	57                   	push   %edi
 584:	56                   	push   %esi
 585:	53                   	push   %ebx
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
 586:	89 d3                	mov    %edx,%ebx
{
 588:	83 ec 3c             	sub    $0x3c,%esp
 58b:	89 45 bc             	mov    %eax,-0x44(%ebp)
  if(sgn && xx < 0){
 58e:	85 d2                	test   %edx,%edx
 590:	0f 89 92 00 00 00    	jns    628 <printint+0xa8>
 596:	f6 45 08 01          	testb  $0x1,0x8(%ebp)
 59a:	0f 84 88 00 00 00    	je     628 <printint+0xa8>
    neg = 1;
 5a0:	c7 45 c0 01 00 00 00 	movl   $0x1,-0x40(%ebp)
    x = -xx;
 5a7:	f7 db                	neg    %ebx
  } else {
    x = xx;
  }

  i = 0;
 5a9:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
 5b0:	8d 75 d7             	lea    -0x29(%ebp),%esi
 5b3:	eb 08                	jmp    5bd <printint+0x3d>
 5b5:	8d 76 00             	lea    0x0(%esi),%esi
  do{
    buf[i++] = digits[x % base];
 5b8:	89 7d c4             	mov    %edi,-0x3c(%ebp)
  }while((x /= base) != 0);
 5bb:	89 c3                	mov    %eax,%ebx
    buf[i++] = digits[x % base];
 5bd:	89 d8                	mov    %ebx,%eax
 5bf:	31 d2                	xor    %edx,%edx
 5c1:	8b 7d c4             	mov    -0x3c(%ebp),%edi
 5c4:	f7 f1                	div    %ecx
 5c6:	83 c7 01             	add    $0x1,%edi
 5c9:	0f b6 92 68 0e 00 00 	movzbl 0xe68(%edx),%edx
 5d0:	88 14 3e             	mov    %dl,(%esi,%edi,1)
  }while((x /= base) != 0);
 5d3:	39 d9                	cmp    %ebx,%ecx
 5d5:	76 e1                	jbe    5b8 <printint+0x38>
  if(neg)
 5d7:	8b 45 c0             	mov    -0x40(%ebp),%eax
 5da:	85 c0                	test   %eax,%eax
 5dc:	74 0d                	je     5eb <printint+0x6b>
    buf[i++] = '-';
 5de:	c6 44 3d d8 2d       	movb   $0x2d,-0x28(%ebp,%edi,1)
 5e3:	ba 2d 00 00 00       	mov    $0x2d,%edx
    buf[i++] = digits[x % base];
 5e8:	89 7d c4             	mov    %edi,-0x3c(%ebp)

  while(--i >= 0)
 5eb:	8b 45 c4             	mov    -0x3c(%ebp),%eax
 5ee:	8b 7d bc             	mov    -0x44(%ebp),%edi
 5f1:	8d 5c 05 d7          	lea    -0x29(%ebp,%eax,1),%ebx
 5f5:	eb 0f                	jmp    606 <printint+0x86>
 5f7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 5fe:	66 90                	xchg   %ax,%ax
 600:	0f b6 13             	movzbl (%ebx),%edx
 603:	83 eb 01             	sub    $0x1,%ebx
  write(fd, &c, 1);
 606:	83 ec 04             	sub    $0x4,%esp
 609:	88 55 d7             	mov    %dl,-0x29(%ebp)
 60c:	6a 01                	push   $0x1
 60e:	56                   	push   %esi
 60f:	57                   	push   %edi
 610:	e8 cc fe ff ff       	call   4e1 <write>
  while(--i >= 0)
 615:	83 c4 10             	add    $0x10,%esp
 618:	39 de                	cmp    %ebx,%esi
 61a:	75 e4                	jne    600 <printint+0x80>
    putc(fd, buf[i]);
}
 61c:	8d 65 f4             	lea    -0xc(%ebp),%esp
 61f:	5b                   	pop    %ebx
 620:	5e                   	pop    %esi
 621:	5f                   	pop    %edi
 622:	5d                   	pop    %ebp
 623:	c3                   	ret    
 624:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  neg = 0;
 628:	c7 45 c0 00 00 00 00 	movl   $0x0,-0x40(%ebp)
 62f:	e9 75 ff ff ff       	jmp    5a9 <printint+0x29>
 634:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 63b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 63f:	90                   	nop

00000640 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 640:	55                   	push   %ebp
 641:	89 e5                	mov    %esp,%ebp
 643:	57                   	push   %edi
 644:	56                   	push   %esi
 645:	53                   	push   %ebx
 646:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 649:	8b 75 0c             	mov    0xc(%ebp),%esi
 64c:	0f b6 1e             	movzbl (%esi),%ebx
 64f:	84 db                	test   %bl,%bl
 651:	0f 84 b9 00 00 00    	je     710 <printf+0xd0>
  ap = (uint*)(void*)&fmt + 1;
 657:	8d 45 10             	lea    0x10(%ebp),%eax
 65a:	83 c6 01             	add    $0x1,%esi
  write(fd, &c, 1);
 65d:	8d 7d e7             	lea    -0x19(%ebp),%edi
  state = 0;
 660:	31 d2                	xor    %edx,%edx
  ap = (uint*)(void*)&fmt + 1;
 662:	89 45 d0             	mov    %eax,-0x30(%ebp)
 665:	eb 38                	jmp    69f <printf+0x5f>
 667:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 66e:	66 90                	xchg   %ax,%ax
 670:	89 55 d4             	mov    %edx,-0x2c(%ebp)
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
 673:	ba 25 00 00 00       	mov    $0x25,%edx
      if(c == '%'){
 678:	83 f8 25             	cmp    $0x25,%eax
 67b:	74 17                	je     694 <printf+0x54>
  write(fd, &c, 1);
 67d:	83 ec 04             	sub    $0x4,%esp
 680:	88 5d e7             	mov    %bl,-0x19(%ebp)
 683:	6a 01                	push   $0x1
 685:	57                   	push   %edi
 686:	ff 75 08             	pushl  0x8(%ebp)
 689:	e8 53 fe ff ff       	call   4e1 <write>
 68e:	8b 55 d4             	mov    -0x2c(%ebp),%edx
      } else {
        putc(fd, c);
 691:	83 c4 10             	add    $0x10,%esp
  for(i = 0; fmt[i]; i++){
 694:	83 c6 01             	add    $0x1,%esi
 697:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
 69b:	84 db                	test   %bl,%bl
 69d:	74 71                	je     710 <printf+0xd0>
    c = fmt[i] & 0xff;
 69f:	0f be cb             	movsbl %bl,%ecx
 6a2:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
 6a5:	85 d2                	test   %edx,%edx
 6a7:	74 c7                	je     670 <printf+0x30>
      }
    } else if(state == '%'){
 6a9:	83 fa 25             	cmp    $0x25,%edx
 6ac:	75 e6                	jne    694 <printf+0x54>
      if(c == 'd'){
 6ae:	83 f8 64             	cmp    $0x64,%eax
 6b1:	0f 84 99 00 00 00    	je     750 <printf+0x110>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 6b7:	81 e1 f7 00 00 00    	and    $0xf7,%ecx
 6bd:	83 f9 70             	cmp    $0x70,%ecx
 6c0:	74 5e                	je     720 <printf+0xe0>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 6c2:	83 f8 73             	cmp    $0x73,%eax
 6c5:	0f 84 d5 00 00 00    	je     7a0 <printf+0x160>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 6cb:	83 f8 63             	cmp    $0x63,%eax
 6ce:	0f 84 8c 00 00 00    	je     760 <printf+0x120>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 6d4:	83 f8 25             	cmp    $0x25,%eax
 6d7:	0f 84 b3 00 00 00    	je     790 <printf+0x150>
  write(fd, &c, 1);
 6dd:	83 ec 04             	sub    $0x4,%esp
 6e0:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
 6e4:	6a 01                	push   $0x1
 6e6:	57                   	push   %edi
 6e7:	ff 75 08             	pushl  0x8(%ebp)
 6ea:	e8 f2 fd ff ff       	call   4e1 <write>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
 6ef:	88 5d e7             	mov    %bl,-0x19(%ebp)
  write(fd, &c, 1);
 6f2:	83 c4 0c             	add    $0xc,%esp
 6f5:	6a 01                	push   $0x1
 6f7:	83 c6 01             	add    $0x1,%esi
 6fa:	57                   	push   %edi
 6fb:	ff 75 08             	pushl  0x8(%ebp)
 6fe:	e8 de fd ff ff       	call   4e1 <write>
  for(i = 0; fmt[i]; i++){
 703:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
        putc(fd, c);
 707:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 70a:	31 d2                	xor    %edx,%edx
  for(i = 0; fmt[i]; i++){
 70c:	84 db                	test   %bl,%bl
 70e:	75 8f                	jne    69f <printf+0x5f>
    }
  }
}
 710:	8d 65 f4             	lea    -0xc(%ebp),%esp
 713:	5b                   	pop    %ebx
 714:	5e                   	pop    %esi
 715:	5f                   	pop    %edi
 716:	5d                   	pop    %ebp
 717:	c3                   	ret    
 718:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 71f:	90                   	nop
        printint(fd, *ap, 16, 0);
 720:	83 ec 0c             	sub    $0xc,%esp
 723:	b9 10 00 00 00       	mov    $0x10,%ecx
 728:	6a 00                	push   $0x0
 72a:	8b 5d d0             	mov    -0x30(%ebp),%ebx
 72d:	8b 45 08             	mov    0x8(%ebp),%eax
 730:	8b 13                	mov    (%ebx),%edx
 732:	e8 49 fe ff ff       	call   580 <printint>
        ap++;
 737:	89 d8                	mov    %ebx,%eax
 739:	83 c4 10             	add    $0x10,%esp
      state = 0;
 73c:	31 d2                	xor    %edx,%edx
        ap++;
 73e:	83 c0 04             	add    $0x4,%eax
 741:	89 45 d0             	mov    %eax,-0x30(%ebp)
 744:	e9 4b ff ff ff       	jmp    694 <printf+0x54>
 749:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        printint(fd, *ap, 10, 1);
 750:	83 ec 0c             	sub    $0xc,%esp
 753:	b9 0a 00 00 00       	mov    $0xa,%ecx
 758:	6a 01                	push   $0x1
 75a:	eb ce                	jmp    72a <printf+0xea>
 75c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        putc(fd, *ap);
 760:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  write(fd, &c, 1);
 763:	83 ec 04             	sub    $0x4,%esp
        putc(fd, *ap);
 766:	8b 03                	mov    (%ebx),%eax
  write(fd, &c, 1);
 768:	6a 01                	push   $0x1
        ap++;
 76a:	83 c3 04             	add    $0x4,%ebx
  write(fd, &c, 1);
 76d:	57                   	push   %edi
 76e:	ff 75 08             	pushl  0x8(%ebp)
        putc(fd, *ap);
 771:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 774:	e8 68 fd ff ff       	call   4e1 <write>
        ap++;
 779:	89 5d d0             	mov    %ebx,-0x30(%ebp)
 77c:	83 c4 10             	add    $0x10,%esp
      state = 0;
 77f:	31 d2                	xor    %edx,%edx
 781:	e9 0e ff ff ff       	jmp    694 <printf+0x54>
 786:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 78d:	8d 76 00             	lea    0x0(%esi),%esi
        putc(fd, c);
 790:	88 5d e7             	mov    %bl,-0x19(%ebp)
  write(fd, &c, 1);
 793:	83 ec 04             	sub    $0x4,%esp
 796:	e9 5a ff ff ff       	jmp    6f5 <printf+0xb5>
 79b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 79f:	90                   	nop
        s = (char*)*ap;
 7a0:	8b 45 d0             	mov    -0x30(%ebp),%eax
 7a3:	8b 18                	mov    (%eax),%ebx
        ap++;
 7a5:	83 c0 04             	add    $0x4,%eax
 7a8:	89 45 d0             	mov    %eax,-0x30(%ebp)
        if(s == 0)
 7ab:	85 db                	test   %ebx,%ebx
 7ad:	74 17                	je     7c6 <printf+0x186>
        while(*s != 0){
 7af:	0f b6 03             	movzbl (%ebx),%eax
      state = 0;
 7b2:	31 d2                	xor    %edx,%edx
        while(*s != 0){
 7b4:	84 c0                	test   %al,%al
 7b6:	0f 84 d8 fe ff ff    	je     694 <printf+0x54>
 7bc:	89 75 d4             	mov    %esi,-0x2c(%ebp)
 7bf:	89 de                	mov    %ebx,%esi
 7c1:	8b 5d 08             	mov    0x8(%ebp),%ebx
 7c4:	eb 1a                	jmp    7e0 <printf+0x1a0>
          s = "(null)";
 7c6:	bb 60 0e 00 00       	mov    $0xe60,%ebx
        while(*s != 0){
 7cb:	89 75 d4             	mov    %esi,-0x2c(%ebp)
 7ce:	b8 28 00 00 00       	mov    $0x28,%eax
 7d3:	89 de                	mov    %ebx,%esi
 7d5:	8b 5d 08             	mov    0x8(%ebp),%ebx
 7d8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 7df:	90                   	nop
  write(fd, &c, 1);
 7e0:	83 ec 04             	sub    $0x4,%esp
          s++;
 7e3:	83 c6 01             	add    $0x1,%esi
 7e6:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 7e9:	6a 01                	push   $0x1
 7eb:	57                   	push   %edi
 7ec:	53                   	push   %ebx
 7ed:	e8 ef fc ff ff       	call   4e1 <write>
        while(*s != 0){
 7f2:	0f b6 06             	movzbl (%esi),%eax
 7f5:	83 c4 10             	add    $0x10,%esp
 7f8:	84 c0                	test   %al,%al
 7fa:	75 e4                	jne    7e0 <printf+0x1a0>
 7fc:	8b 75 d4             	mov    -0x2c(%ebp),%esi
      state = 0;
 7ff:	31 d2                	xor    %edx,%edx
 801:	e9 8e fe ff ff       	jmp    694 <printf+0x54>
 806:	66 90                	xchg   %ax,%ax
 808:	66 90                	xchg   %ax,%ax
 80a:	66 90                	xchg   %ax,%ax
 80c:	66 90                	xchg   %ax,%ax
 80e:	66 90                	xchg   %ax,%ax

00000810 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 810:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 811:	a1 b8 11 00 00       	mov    0x11b8,%eax
{
 816:	89 e5                	mov    %esp,%ebp
 818:	57                   	push   %edi
 819:	56                   	push   %esi
 81a:	53                   	push   %ebx
 81b:	8b 5d 08             	mov    0x8(%ebp),%ebx
 81e:	8b 10                	mov    (%eax),%edx
  bp = (Header*)ap - 1;
 820:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 823:	39 c8                	cmp    %ecx,%eax
 825:	73 19                	jae    840 <free+0x30>
 827:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 82e:	66 90                	xchg   %ax,%ax
 830:	39 d1                	cmp    %edx,%ecx
 832:	72 14                	jb     848 <free+0x38>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 834:	39 d0                	cmp    %edx,%eax
 836:	73 10                	jae    848 <free+0x38>
{
 838:	89 d0                	mov    %edx,%eax
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 83a:	8b 10                	mov    (%eax),%edx
 83c:	39 c8                	cmp    %ecx,%eax
 83e:	72 f0                	jb     830 <free+0x20>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 840:	39 d0                	cmp    %edx,%eax
 842:	72 f4                	jb     838 <free+0x28>
 844:	39 d1                	cmp    %edx,%ecx
 846:	73 f0                	jae    838 <free+0x28>
      break;
  if(bp + bp->s.size == p->s.ptr){
 848:	8b 73 fc             	mov    -0x4(%ebx),%esi
 84b:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 84e:	39 fa                	cmp    %edi,%edx
 850:	74 1e                	je     870 <free+0x60>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 852:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 855:	8b 50 04             	mov    0x4(%eax),%edx
 858:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 85b:	39 f1                	cmp    %esi,%ecx
 85d:	74 28                	je     887 <free+0x77>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 85f:	89 08                	mov    %ecx,(%eax)
  freep = p;
}
 861:	5b                   	pop    %ebx
  freep = p;
 862:	a3 b8 11 00 00       	mov    %eax,0x11b8
}
 867:	5e                   	pop    %esi
 868:	5f                   	pop    %edi
 869:	5d                   	pop    %ebp
 86a:	c3                   	ret    
 86b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 86f:	90                   	nop
    bp->s.size += p->s.ptr->s.size;
 870:	03 72 04             	add    0x4(%edx),%esi
 873:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 876:	8b 10                	mov    (%eax),%edx
 878:	8b 12                	mov    (%edx),%edx
 87a:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 87d:	8b 50 04             	mov    0x4(%eax),%edx
 880:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 883:	39 f1                	cmp    %esi,%ecx
 885:	75 d8                	jne    85f <free+0x4f>
    p->s.size += bp->s.size;
 887:	03 53 fc             	add    -0x4(%ebx),%edx
  freep = p;
 88a:	a3 b8 11 00 00       	mov    %eax,0x11b8
    p->s.size += bp->s.size;
 88f:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 892:	8b 53 f8             	mov    -0x8(%ebx),%edx
 895:	89 10                	mov    %edx,(%eax)
}
 897:	5b                   	pop    %ebx
 898:	5e                   	pop    %esi
 899:	5f                   	pop    %edi
 89a:	5d                   	pop    %ebp
 89b:	c3                   	ret    
 89c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

000008a0 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 8a0:	55                   	push   %ebp
 8a1:	89 e5                	mov    %esp,%ebp
 8a3:	57                   	push   %edi
 8a4:	56                   	push   %esi
 8a5:	53                   	push   %ebx
 8a6:	83 ec 1c             	sub    $0x1c,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 8a9:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
 8ac:	8b 3d b8 11 00 00    	mov    0x11b8,%edi
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 8b2:	8d 70 07             	lea    0x7(%eax),%esi
 8b5:	c1 ee 03             	shr    $0x3,%esi
 8b8:	83 c6 01             	add    $0x1,%esi
  if((prevp = freep) == 0){
 8bb:	85 ff                	test   %edi,%edi
 8bd:	0f 84 ad 00 00 00    	je     970 <malloc+0xd0>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8c3:	8b 17                	mov    (%edi),%edx
    if(p->s.size >= nunits){
 8c5:	8b 4a 04             	mov    0x4(%edx),%ecx
 8c8:	39 f1                	cmp    %esi,%ecx
 8ca:	73 72                	jae    93e <malloc+0x9e>
 8cc:	81 fe 00 10 00 00    	cmp    $0x1000,%esi
 8d2:	bb 00 10 00 00       	mov    $0x1000,%ebx
 8d7:	0f 43 de             	cmovae %esi,%ebx
  p = sbrk(nu * sizeof(Header));
 8da:	8d 04 dd 00 00 00 00 	lea    0x0(,%ebx,8),%eax
 8e1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
 8e4:	eb 1b                	jmp    901 <malloc+0x61>
 8e6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 8ed:	8d 76 00             	lea    0x0(%esi),%esi
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8f0:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 8f2:	8b 48 04             	mov    0x4(%eax),%ecx
 8f5:	39 f1                	cmp    %esi,%ecx
 8f7:	73 4f                	jae    948 <malloc+0xa8>
 8f9:	8b 3d b8 11 00 00    	mov    0x11b8,%edi
 8ff:	89 c2                	mov    %eax,%edx
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 901:	39 d7                	cmp    %edx,%edi
 903:	75 eb                	jne    8f0 <malloc+0x50>
  p = sbrk(nu * sizeof(Header));
 905:	83 ec 0c             	sub    $0xc,%esp
 908:	ff 75 e4             	pushl  -0x1c(%ebp)
 90b:	e8 39 fc ff ff       	call   549 <sbrk>
  if(p == (char*)-1)
 910:	83 c4 10             	add    $0x10,%esp
 913:	83 f8 ff             	cmp    $0xffffffff,%eax
 916:	74 1c                	je     934 <malloc+0x94>
  hp->s.size = nu;
 918:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 91b:	83 ec 0c             	sub    $0xc,%esp
 91e:	83 c0 08             	add    $0x8,%eax
 921:	50                   	push   %eax
 922:	e8 e9 fe ff ff       	call   810 <free>
  return freep;
 927:	8b 15 b8 11 00 00    	mov    0x11b8,%edx
      if((p = morecore(nunits)) == 0)
 92d:	83 c4 10             	add    $0x10,%esp
 930:	85 d2                	test   %edx,%edx
 932:	75 bc                	jne    8f0 <malloc+0x50>
        return 0;
  }
}
 934:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return 0;
 937:	31 c0                	xor    %eax,%eax
}
 939:	5b                   	pop    %ebx
 93a:	5e                   	pop    %esi
 93b:	5f                   	pop    %edi
 93c:	5d                   	pop    %ebp
 93d:	c3                   	ret    
    if(p->s.size >= nunits){
 93e:	89 d0                	mov    %edx,%eax
 940:	89 fa                	mov    %edi,%edx
 942:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      if(p->s.size == nunits)
 948:	39 ce                	cmp    %ecx,%esi
 94a:	74 54                	je     9a0 <malloc+0x100>
        p->s.size -= nunits;
 94c:	29 f1                	sub    %esi,%ecx
 94e:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
 951:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
 954:	89 70 04             	mov    %esi,0x4(%eax)
      freep = prevp;
 957:	89 15 b8 11 00 00    	mov    %edx,0x11b8
}
 95d:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return (void*)(p + 1);
 960:	83 c0 08             	add    $0x8,%eax
}
 963:	5b                   	pop    %ebx
 964:	5e                   	pop    %esi
 965:	5f                   	pop    %edi
 966:	5d                   	pop    %ebp
 967:	c3                   	ret    
 968:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 96f:	90                   	nop
    base.s.ptr = freep = prevp = &base;
 970:	c7 05 b8 11 00 00 bc 	movl   $0x11bc,0x11b8
 977:	11 00 00 
    base.s.size = 0;
 97a:	bf bc 11 00 00       	mov    $0x11bc,%edi
    base.s.ptr = freep = prevp = &base;
 97f:	c7 05 bc 11 00 00 bc 	movl   $0x11bc,0x11bc
 986:	11 00 00 
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 989:	89 fa                	mov    %edi,%edx
    base.s.size = 0;
 98b:	c7 05 c0 11 00 00 00 	movl   $0x0,0x11c0
 992:	00 00 00 
    if(p->s.size >= nunits){
 995:	e9 32 ff ff ff       	jmp    8cc <malloc+0x2c>
 99a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        prevp->s.ptr = p->s.ptr;
 9a0:	8b 08                	mov    (%eax),%ecx
 9a2:	89 0a                	mov    %ecx,(%edx)
 9a4:	eb b1                	jmp    957 <malloc+0xb7>
