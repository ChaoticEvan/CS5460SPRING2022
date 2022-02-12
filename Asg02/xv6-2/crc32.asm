
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
  1e:	68 80 09 00 00       	push   $0x980
  23:	6a 01                	push   $0x1
  25:	e8 d6 05 00 00       	call   600 <printf>
    exit2(-1);
  2a:	c7 04 24 ff ff ff ff 	movl   $0xffffffff,(%esp)
  31:	e8 f3 04 00 00       	call   529 <exit2>
  }

  if((fd = open(argv[1], 0)) < 0){
  36:	50                   	push   %eax
  37:	50                   	push   %eax
  38:	6a 00                	push   $0x0
  3a:	ff 76 04             	pushl  0x4(%esi)
  3d:	e8 7f 04 00 00       	call   4c1 <open>
  42:	83 c4 10             	add    $0x10,%esp
  45:	89 c7                	mov    %eax,%edi
  47:	85 c0                	test   %eax,%eax
  49:	0f 88 a4 00 00 00    	js     f3 <main+0xf3>
    printf(2, "crc32: cannot open %s\n", argv[1]);
	exit2(-1);
  } 

  if(fstat(fd, &st) < 0){
  4f:	50                   	push   %eax
  50:	50                   	push   %eax
  51:	8d 45 d4             	lea    -0x2c(%ebp),%eax
  54:	50                   	push   %eax
  55:	57                   	push   %edi
  56:	e8 7e 04 00 00       	call   4d9 <fstat>
  5b:	83 c4 10             	add    $0x10,%esp
  5e:	85 c0                	test   %eax,%eax
  60:	78 6d                	js     cf <main+0xcf>
    printf(2, "crc32: cannot stat %s\n", argv[1]);
    close(fd);
    exit2(-1);
  }
  
  char* buffer = malloc(st.size);
  62:	83 ec 0c             	sub    $0xc,%esp
  65:	ff 75 e4             	pushl  -0x1c(%ebp)
  68:	e8 f3 07 00 00       	call   860 <malloc>
  if(read(fd, buffer, st.size) < 0)
  6d:	83 c4 0c             	add    $0xc,%esp
  70:	ff 75 e4             	pushl  -0x1c(%ebp)
  73:	50                   	push   %eax
  char* buffer = malloc(st.size);
  74:	89 c3                	mov    %eax,%ebx
  if(read(fd, buffer, st.size) < 0)
  76:	57                   	push   %edi
  77:	e8 1d 04 00 00       	call   499 <read>
  7c:	83 c4 10             	add    $0x10,%esp
  7f:	85 c0                	test   %eax,%eax
  81:	0f 88 88 00 00 00    	js     10f <main+0x10f>
	  printf(1, "ERROR: Could not read file %s\n", argv[1]);
	  close(fd);
	  exit2(-1);
  }

  printf(1, "%x\n", crc32(0, buffer, st.size));
  87:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
	while (size--)
  8a:	85 c9                	test   %ecx,%ecx
  8c:	0f 84 8a 00 00 00    	je     11c <main+0x11c>
  92:	01 d9                	add    %ebx,%ecx
	crc = crc ^ ~0U;
  94:	83 c8 ff             	or     $0xffffffff,%eax
  97:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  9e:	66 90                	xchg   %ax,%ax
	crc = crc32_tab[(crc ^ *p++) & 0xFF] ^ (crc >> 8);
  a0:	83 c3 01             	add    $0x1,%ebx
  a3:	0f b6 53 ff          	movzbl -0x1(%ebx),%edx
  a7:	31 c2                	xor    %eax,%edx
  a9:	c1 e8 08             	shr    $0x8,%eax
  ac:	0f b6 d2             	movzbl %dl,%edx
  af:	33 04 95 20 0a 00 00 	xor    0xa20(,%edx,4),%eax
	while (size--)
  b6:	39 cb                	cmp    %ecx,%ebx
  b8:	75 e6                	jne    a0 <main+0xa0>
	return crc ^ ~0U;
  ba:	f7 d0                	not    %eax
  printf(1, "%x\n", crc32(0, buffer, st.size));
  bc:	52                   	push   %edx
  bd:	50                   	push   %eax
  be:	68 0a 0a 00 00       	push   $0xa0a
  c3:	6a 01                	push   $0x1
  c5:	e8 36 05 00 00       	call   600 <printf>
  exit();
  ca:	e8 b2 03 00 00       	call   481 <exit>
    printf(2, "crc32: cannot stat %s\n", argv[1]);
  cf:	53                   	push   %ebx
  d0:	ff 76 04             	pushl  0x4(%esi)
  d3:	68 f3 09 00 00       	push   $0x9f3
  d8:	6a 02                	push   $0x2
	  printf(1, "ERROR: Could not read file %s\n", argv[1]);
  da:	e8 21 05 00 00       	call   600 <printf>
	  close(fd);
  df:	89 3c 24             	mov    %edi,(%esp)
  e2:	e8 c2 03 00 00       	call   4a9 <close>
	  exit2(-1);
  e7:	c7 04 24 ff ff ff ff 	movl   $0xffffffff,(%esp)
  ee:	e8 36 04 00 00       	call   529 <exit2>
    printf(2, "crc32: cannot open %s\n", argv[1]);
  f3:	50                   	push   %eax
  f4:	ff 76 04             	pushl  0x4(%esi)
  f7:	68 dc 09 00 00       	push   $0x9dc
  fc:	6a 02                	push   $0x2
  fe:	e8 fd 04 00 00       	call   600 <printf>
	exit2(-1);
 103:	c7 04 24 ff ff ff ff 	movl   $0xffffffff,(%esp)
 10a:	e8 1a 04 00 00       	call   529 <exit2>
	  printf(1, "ERROR: Could not read file %s\n", argv[1]);
 10f:	51                   	push   %ecx
 110:	ff 76 04             	pushl  0x4(%esi)
 113:	68 bc 09 00 00       	push   $0x9bc
 118:	6a 01                	push   $0x1
 11a:	eb be                	jmp    da <main+0xda>
	crc = crc ^ ~0U;
 11c:	83 c8 ff             	or     $0xffffffff,%eax
 11f:	eb 99                	jmp    ba <main+0xba>
 121:	66 90                	xchg   %ax,%ax
 123:	66 90                	xchg   %ax,%ax
 125:	66 90                	xchg   %ax,%ax
 127:	66 90                	xchg   %ax,%ax
 129:	66 90                	xchg   %ax,%ax
 12b:	66 90                	xchg   %ax,%ax
 12d:	66 90                	xchg   %ax,%ax
 12f:	90                   	nop

00000130 <fmtname>:
{
 130:	55                   	push   %ebp
 131:	89 e5                	mov    %esp,%ebp
 133:	56                   	push   %esi
 134:	53                   	push   %ebx
 135:	8b 75 08             	mov    0x8(%ebp),%esi
  for(p=path+strlen(path); p >= path && *p != '/'; p--)
 138:	83 ec 0c             	sub    $0xc,%esp
 13b:	56                   	push   %esi
 13c:	e8 6f 01 00 00       	call   2b0 <strlen>
 141:	83 c4 10             	add    $0x10,%esp
 144:	01 f0                	add    %esi,%eax
 146:	89 c3                	mov    %eax,%ebx
 148:	0f 82 82 00 00 00    	jb     1d0 <fmtname+0xa0>
 14e:	80 38 2f             	cmpb   $0x2f,(%eax)
 151:	75 0d                	jne    160 <fmtname+0x30>
 153:	eb 7b                	jmp    1d0 <fmtname+0xa0>
 155:	8d 76 00             	lea    0x0(%esi),%esi
 158:	80 7b ff 2f          	cmpb   $0x2f,-0x1(%ebx)
 15c:	74 09                	je     167 <fmtname+0x37>
 15e:	89 c3                	mov    %eax,%ebx
 160:	8d 43 ff             	lea    -0x1(%ebx),%eax
 163:	39 c6                	cmp    %eax,%esi
 165:	76 f1                	jbe    158 <fmtname+0x28>
  if(strlen(p) >= DIRSIZ)
 167:	83 ec 0c             	sub    $0xc,%esp
 16a:	53                   	push   %ebx
 16b:	e8 40 01 00 00       	call   2b0 <strlen>
 170:	83 c4 10             	add    $0x10,%esp
 173:	83 f8 0d             	cmp    $0xd,%eax
 176:	77 4a                	ja     1c2 <fmtname+0x92>
  memmove(buf, p, strlen(p));
 178:	83 ec 0c             	sub    $0xc,%esp
 17b:	53                   	push   %ebx
 17c:	e8 2f 01 00 00       	call   2b0 <strlen>
 181:	83 c4 0c             	add    $0xc,%esp
 184:	50                   	push   %eax
 185:	53                   	push   %ebx
 186:	68 38 11 00 00       	push   $0x1138
 18b:	e8 c0 02 00 00       	call   450 <memmove>
  memset(buf+strlen(p), ' ', DIRSIZ-strlen(p));
 190:	89 1c 24             	mov    %ebx,(%esp)
 193:	e8 18 01 00 00       	call   2b0 <strlen>
 198:	89 1c 24             	mov    %ebx,(%esp)
  return buf;
 19b:	bb 38 11 00 00       	mov    $0x1138,%ebx
  memset(buf+strlen(p), ' ', DIRSIZ-strlen(p));
 1a0:	89 c6                	mov    %eax,%esi
 1a2:	e8 09 01 00 00       	call   2b0 <strlen>
 1a7:	ba 0e 00 00 00       	mov    $0xe,%edx
 1ac:	83 c4 0c             	add    $0xc,%esp
 1af:	29 f2                	sub    %esi,%edx
 1b1:	05 38 11 00 00       	add    $0x1138,%eax
 1b6:	52                   	push   %edx
 1b7:	6a 20                	push   $0x20
 1b9:	50                   	push   %eax
 1ba:	e8 21 01 00 00       	call   2e0 <memset>
  return buf;
 1bf:	83 c4 10             	add    $0x10,%esp
}
 1c2:	8d 65 f8             	lea    -0x8(%ebp),%esp
 1c5:	89 d8                	mov    %ebx,%eax
 1c7:	5b                   	pop    %ebx
 1c8:	5e                   	pop    %esi
 1c9:	5d                   	pop    %ebp
 1ca:	c3                   	ret    
 1cb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 1cf:	90                   	nop
 1d0:	83 c3 01             	add    $0x1,%ebx
 1d3:	eb 92                	jmp    167 <fmtname+0x37>
 1d5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 1dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

000001e0 <crc32>:
{
 1e0:	55                   	push   %ebp
 1e1:	89 e5                	mov    %esp,%ebp
 1e3:	53                   	push   %ebx
 1e4:	8b 5d 10             	mov    0x10(%ebp),%ebx
 1e7:	8b 55 0c             	mov    0xc(%ebp),%edx
	crc = crc ^ ~0U;
 1ea:	8b 45 08             	mov    0x8(%ebp),%eax
	while (size--)
 1ed:	85 db                	test   %ebx,%ebx
 1ef:	74 2f                	je     220 <crc32+0x40>
 1f1:	f7 d0                	not    %eax
 1f3:	01 d3                	add    %edx,%ebx
 1f5:	8d 76 00             	lea    0x0(%esi),%esi
	crc = crc32_tab[(crc ^ *p++) & 0xFF] ^ (crc >> 8);
 1f8:	83 c2 01             	add    $0x1,%edx
 1fb:	0f b6 4a ff          	movzbl -0x1(%edx),%ecx
 1ff:	31 c1                	xor    %eax,%ecx
 201:	c1 e8 08             	shr    $0x8,%eax
 204:	0f b6 c9             	movzbl %cl,%ecx
 207:	33 04 8d 20 0a 00 00 	xor    0xa20(,%ecx,4),%eax
	while (size--)
 20e:	39 da                	cmp    %ebx,%edx
 210:	75 e6                	jne    1f8 <crc32+0x18>
 212:	f7 d0                	not    %eax
}
 214:	5b                   	pop    %ebx
 215:	5d                   	pop    %ebp
 216:	c3                   	ret    
 217:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 21e:	66 90                	xchg   %ax,%ax
	while (size--)
 220:	8b 45 08             	mov    0x8(%ebp),%eax
}
 223:	5b                   	pop    %ebx
 224:	5d                   	pop    %ebp
 225:	c3                   	ret    
 226:	66 90                	xchg   %ax,%ax
 228:	66 90                	xchg   %ax,%ax
 22a:	66 90                	xchg   %ax,%ax
 22c:	66 90                	xchg   %ax,%ax
 22e:	66 90                	xchg   %ax,%ax

00000230 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
 230:	55                   	push   %ebp
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 231:	31 d2                	xor    %edx,%edx
{
 233:	89 e5                	mov    %esp,%ebp
 235:	53                   	push   %ebx
 236:	8b 45 08             	mov    0x8(%ebp),%eax
 239:	8b 5d 0c             	mov    0xc(%ebp),%ebx
 23c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while((*s++ = *t++) != 0)
 240:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
 244:	88 0c 10             	mov    %cl,(%eax,%edx,1)
 247:	83 c2 01             	add    $0x1,%edx
 24a:	84 c9                	test   %cl,%cl
 24c:	75 f2                	jne    240 <strcpy+0x10>
    ;
  return os;
}
 24e:	5b                   	pop    %ebx
 24f:	5d                   	pop    %ebp
 250:	c3                   	ret    
 251:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 258:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 25f:	90                   	nop

00000260 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 260:	55                   	push   %ebp
 261:	89 e5                	mov    %esp,%ebp
 263:	56                   	push   %esi
 264:	53                   	push   %ebx
 265:	8b 5d 08             	mov    0x8(%ebp),%ebx
 268:	8b 75 0c             	mov    0xc(%ebp),%esi
  while(*p && *p == *q)
 26b:	0f b6 13             	movzbl (%ebx),%edx
 26e:	0f b6 0e             	movzbl (%esi),%ecx
 271:	84 d2                	test   %dl,%dl
 273:	74 1e                	je     293 <strcmp+0x33>
 275:	b8 01 00 00 00       	mov    $0x1,%eax
 27a:	38 ca                	cmp    %cl,%dl
 27c:	74 09                	je     287 <strcmp+0x27>
 27e:	eb 20                	jmp    2a0 <strcmp+0x40>
 280:	83 c0 01             	add    $0x1,%eax
 283:	38 ca                	cmp    %cl,%dl
 285:	75 19                	jne    2a0 <strcmp+0x40>
 287:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
 28b:	0f b6 0c 06          	movzbl (%esi,%eax,1),%ecx
 28f:	84 d2                	test   %dl,%dl
 291:	75 ed                	jne    280 <strcmp+0x20>
 293:	31 c0                	xor    %eax,%eax
    p++, q++;
  return (uchar)*p - (uchar)*q;
}
 295:	5b                   	pop    %ebx
 296:	5e                   	pop    %esi
  return (uchar)*p - (uchar)*q;
 297:	29 c8                	sub    %ecx,%eax
}
 299:	5d                   	pop    %ebp
 29a:	c3                   	ret    
 29b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 29f:	90                   	nop
 2a0:	0f b6 c2             	movzbl %dl,%eax
 2a3:	5b                   	pop    %ebx
 2a4:	5e                   	pop    %esi
  return (uchar)*p - (uchar)*q;
 2a5:	29 c8                	sub    %ecx,%eax
}
 2a7:	5d                   	pop    %ebp
 2a8:	c3                   	ret    
 2a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

000002b0 <strlen>:

uint
strlen(const char *s)
{
 2b0:	55                   	push   %ebp
 2b1:	89 e5                	mov    %esp,%ebp
 2b3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
 2b6:	80 39 00             	cmpb   $0x0,(%ecx)
 2b9:	74 15                	je     2d0 <strlen+0x20>
 2bb:	31 d2                	xor    %edx,%edx
 2bd:	8d 76 00             	lea    0x0(%esi),%esi
 2c0:	83 c2 01             	add    $0x1,%edx
 2c3:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
 2c7:	89 d0                	mov    %edx,%eax
 2c9:	75 f5                	jne    2c0 <strlen+0x10>
    ;
  return n;
}
 2cb:	5d                   	pop    %ebp
 2cc:	c3                   	ret    
 2cd:	8d 76 00             	lea    0x0(%esi),%esi
  for(n = 0; s[n]; n++)
 2d0:	31 c0                	xor    %eax,%eax
}
 2d2:	5d                   	pop    %ebp
 2d3:	c3                   	ret    
 2d4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 2db:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 2df:	90                   	nop

000002e0 <memset>:

void*
memset(void *dst, int c, uint n)
{
 2e0:	55                   	push   %ebp
 2e1:	89 e5                	mov    %esp,%ebp
 2e3:	57                   	push   %edi
 2e4:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 2e7:	8b 4d 10             	mov    0x10(%ebp),%ecx
 2ea:	8b 45 0c             	mov    0xc(%ebp),%eax
 2ed:	89 d7                	mov    %edx,%edi
 2ef:	fc                   	cld    
 2f0:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 2f2:	89 d0                	mov    %edx,%eax
 2f4:	5f                   	pop    %edi
 2f5:	5d                   	pop    %ebp
 2f6:	c3                   	ret    
 2f7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 2fe:	66 90                	xchg   %ax,%ax

00000300 <strchr>:

char*
strchr(const char *s, char c)
{
 300:	55                   	push   %ebp
 301:	89 e5                	mov    %esp,%ebp
 303:	53                   	push   %ebx
 304:	8b 45 08             	mov    0x8(%ebp),%eax
 307:	8b 55 0c             	mov    0xc(%ebp),%edx
  for(; *s; s++)
 30a:	0f b6 18             	movzbl (%eax),%ebx
 30d:	84 db                	test   %bl,%bl
 30f:	74 1d                	je     32e <strchr+0x2e>
 311:	89 d1                	mov    %edx,%ecx
    if(*s == c)
 313:	38 d3                	cmp    %dl,%bl
 315:	75 0d                	jne    324 <strchr+0x24>
 317:	eb 17                	jmp    330 <strchr+0x30>
 319:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 320:	38 ca                	cmp    %cl,%dl
 322:	74 0c                	je     330 <strchr+0x30>
  for(; *s; s++)
 324:	83 c0 01             	add    $0x1,%eax
 327:	0f b6 10             	movzbl (%eax),%edx
 32a:	84 d2                	test   %dl,%dl
 32c:	75 f2                	jne    320 <strchr+0x20>
      return (char*)s;
  return 0;
 32e:	31 c0                	xor    %eax,%eax
}
 330:	5b                   	pop    %ebx
 331:	5d                   	pop    %ebp
 332:	c3                   	ret    
 333:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 33a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00000340 <gets>:

char*
gets(char *buf, int max)
{
 340:	55                   	push   %ebp
 341:	89 e5                	mov    %esp,%ebp
 343:	57                   	push   %edi
 344:	56                   	push   %esi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 345:	31 f6                	xor    %esi,%esi
{
 347:	53                   	push   %ebx
 348:	89 f3                	mov    %esi,%ebx
 34a:	83 ec 1c             	sub    $0x1c,%esp
 34d:	8b 7d 08             	mov    0x8(%ebp),%edi
  for(i=0; i+1 < max; ){
 350:	eb 2f                	jmp    381 <gets+0x41>
 352:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    cc = read(0, &c, 1);
 358:	83 ec 04             	sub    $0x4,%esp
 35b:	8d 45 e7             	lea    -0x19(%ebp),%eax
 35e:	6a 01                	push   $0x1
 360:	50                   	push   %eax
 361:	6a 00                	push   $0x0
 363:	e8 31 01 00 00       	call   499 <read>
    if(cc < 1)
 368:	83 c4 10             	add    $0x10,%esp
 36b:	85 c0                	test   %eax,%eax
 36d:	7e 1c                	jle    38b <gets+0x4b>
      break;
    buf[i++] = c;
 36f:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 373:	83 c7 01             	add    $0x1,%edi
 376:	88 47 ff             	mov    %al,-0x1(%edi)
    if(c == '\n' || c == '\r')
 379:	3c 0a                	cmp    $0xa,%al
 37b:	74 23                	je     3a0 <gets+0x60>
 37d:	3c 0d                	cmp    $0xd,%al
 37f:	74 1f                	je     3a0 <gets+0x60>
  for(i=0; i+1 < max; ){
 381:	83 c3 01             	add    $0x1,%ebx
 384:	89 fe                	mov    %edi,%esi
 386:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 389:	7c cd                	jl     358 <gets+0x18>
 38b:	89 f3                	mov    %esi,%ebx
      break;
  }
  buf[i] = '\0';
  return buf;
}
 38d:	8b 45 08             	mov    0x8(%ebp),%eax
  buf[i] = '\0';
 390:	c6 03 00             	movb   $0x0,(%ebx)
}
 393:	8d 65 f4             	lea    -0xc(%ebp),%esp
 396:	5b                   	pop    %ebx
 397:	5e                   	pop    %esi
 398:	5f                   	pop    %edi
 399:	5d                   	pop    %ebp
 39a:	c3                   	ret    
 39b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 39f:	90                   	nop
 3a0:	8b 75 08             	mov    0x8(%ebp),%esi
 3a3:	8b 45 08             	mov    0x8(%ebp),%eax
 3a6:	01 de                	add    %ebx,%esi
 3a8:	89 f3                	mov    %esi,%ebx
  buf[i] = '\0';
 3aa:	c6 03 00             	movb   $0x0,(%ebx)
}
 3ad:	8d 65 f4             	lea    -0xc(%ebp),%esp
 3b0:	5b                   	pop    %ebx
 3b1:	5e                   	pop    %esi
 3b2:	5f                   	pop    %edi
 3b3:	5d                   	pop    %ebp
 3b4:	c3                   	ret    
 3b5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 3bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

000003c0 <stat>:

int
stat(const char *n, struct stat *st)
{
 3c0:	55                   	push   %ebp
 3c1:	89 e5                	mov    %esp,%ebp
 3c3:	56                   	push   %esi
 3c4:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 3c5:	83 ec 08             	sub    $0x8,%esp
 3c8:	6a 00                	push   $0x0
 3ca:	ff 75 08             	pushl  0x8(%ebp)
 3cd:	e8 ef 00 00 00       	call   4c1 <open>
  if(fd < 0)
 3d2:	83 c4 10             	add    $0x10,%esp
 3d5:	85 c0                	test   %eax,%eax
 3d7:	78 27                	js     400 <stat+0x40>
    return -1;
  r = fstat(fd, st);
 3d9:	83 ec 08             	sub    $0x8,%esp
 3dc:	ff 75 0c             	pushl  0xc(%ebp)
 3df:	89 c3                	mov    %eax,%ebx
 3e1:	50                   	push   %eax
 3e2:	e8 f2 00 00 00       	call   4d9 <fstat>
  close(fd);
 3e7:	89 1c 24             	mov    %ebx,(%esp)
  r = fstat(fd, st);
 3ea:	89 c6                	mov    %eax,%esi
  close(fd);
 3ec:	e8 b8 00 00 00       	call   4a9 <close>
  return r;
 3f1:	83 c4 10             	add    $0x10,%esp
}
 3f4:	8d 65 f8             	lea    -0x8(%ebp),%esp
 3f7:	89 f0                	mov    %esi,%eax
 3f9:	5b                   	pop    %ebx
 3fa:	5e                   	pop    %esi
 3fb:	5d                   	pop    %ebp
 3fc:	c3                   	ret    
 3fd:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
 400:	be ff ff ff ff       	mov    $0xffffffff,%esi
 405:	eb ed                	jmp    3f4 <stat+0x34>
 407:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 40e:	66 90                	xchg   %ax,%ax

00000410 <atoi>:

int
atoi(const char *s)
{
 410:	55                   	push   %ebp
 411:	89 e5                	mov    %esp,%ebp
 413:	53                   	push   %ebx
 414:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 417:	0f be 11             	movsbl (%ecx),%edx
 41a:	8d 42 d0             	lea    -0x30(%edx),%eax
 41d:	3c 09                	cmp    $0x9,%al
  n = 0;
 41f:	b8 00 00 00 00       	mov    $0x0,%eax
  while('0' <= *s && *s <= '9')
 424:	77 1f                	ja     445 <atoi+0x35>
 426:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 42d:	8d 76 00             	lea    0x0(%esi),%esi
    n = n*10 + *s++ - '0';
 430:	83 c1 01             	add    $0x1,%ecx
 433:	8d 04 80             	lea    (%eax,%eax,4),%eax
 436:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
  while('0' <= *s && *s <= '9')
 43a:	0f be 11             	movsbl (%ecx),%edx
 43d:	8d 5a d0             	lea    -0x30(%edx),%ebx
 440:	80 fb 09             	cmp    $0x9,%bl
 443:	76 eb                	jbe    430 <atoi+0x20>
  return n;
}
 445:	5b                   	pop    %ebx
 446:	5d                   	pop    %ebp
 447:	c3                   	ret    
 448:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 44f:	90                   	nop

00000450 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 450:	55                   	push   %ebp
 451:	89 e5                	mov    %esp,%ebp
 453:	57                   	push   %edi
 454:	8b 55 10             	mov    0x10(%ebp),%edx
 457:	8b 45 08             	mov    0x8(%ebp),%eax
 45a:	56                   	push   %esi
 45b:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 45e:	85 d2                	test   %edx,%edx
 460:	7e 13                	jle    475 <memmove+0x25>
 462:	01 c2                	add    %eax,%edx
  dst = vdst;
 464:	89 c7                	mov    %eax,%edi
 466:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 46d:	8d 76 00             	lea    0x0(%esi),%esi
    *dst++ = *src++;
 470:	a4                   	movsb  %ds:(%esi),%es:(%edi)
  while(n-- > 0)
 471:	39 fa                	cmp    %edi,%edx
 473:	75 fb                	jne    470 <memmove+0x20>
  return vdst;
}
 475:	5e                   	pop    %esi
 476:	5f                   	pop    %edi
 477:	5d                   	pop    %ebp
 478:	c3                   	ret    

00000479 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 479:	b8 01 00 00 00       	mov    $0x1,%eax
 47e:	cd 40                	int    $0x40
 480:	c3                   	ret    

00000481 <exit>:
SYSCALL(exit)
 481:	b8 02 00 00 00       	mov    $0x2,%eax
 486:	cd 40                	int    $0x40
 488:	c3                   	ret    

00000489 <wait>:
SYSCALL(wait)
 489:	b8 03 00 00 00       	mov    $0x3,%eax
 48e:	cd 40                	int    $0x40
 490:	c3                   	ret    

00000491 <pipe>:
SYSCALL(pipe)
 491:	b8 04 00 00 00       	mov    $0x4,%eax
 496:	cd 40                	int    $0x40
 498:	c3                   	ret    

00000499 <read>:
SYSCALL(read)
 499:	b8 05 00 00 00       	mov    $0x5,%eax
 49e:	cd 40                	int    $0x40
 4a0:	c3                   	ret    

000004a1 <write>:
SYSCALL(write)
 4a1:	b8 10 00 00 00       	mov    $0x10,%eax
 4a6:	cd 40                	int    $0x40
 4a8:	c3                   	ret    

000004a9 <close>:
SYSCALL(close)
 4a9:	b8 15 00 00 00       	mov    $0x15,%eax
 4ae:	cd 40                	int    $0x40
 4b0:	c3                   	ret    

000004b1 <kill>:
SYSCALL(kill)
 4b1:	b8 06 00 00 00       	mov    $0x6,%eax
 4b6:	cd 40                	int    $0x40
 4b8:	c3                   	ret    

000004b9 <exec>:
SYSCALL(exec)
 4b9:	b8 07 00 00 00       	mov    $0x7,%eax
 4be:	cd 40                	int    $0x40
 4c0:	c3                   	ret    

000004c1 <open>:
SYSCALL(open)
 4c1:	b8 0f 00 00 00       	mov    $0xf,%eax
 4c6:	cd 40                	int    $0x40
 4c8:	c3                   	ret    

000004c9 <mknod>:
SYSCALL(mknod)
 4c9:	b8 11 00 00 00       	mov    $0x11,%eax
 4ce:	cd 40                	int    $0x40
 4d0:	c3                   	ret    

000004d1 <unlink>:
SYSCALL(unlink)
 4d1:	b8 12 00 00 00       	mov    $0x12,%eax
 4d6:	cd 40                	int    $0x40
 4d8:	c3                   	ret    

000004d9 <fstat>:
SYSCALL(fstat)
 4d9:	b8 08 00 00 00       	mov    $0x8,%eax
 4de:	cd 40                	int    $0x40
 4e0:	c3                   	ret    

000004e1 <link>:
SYSCALL(link)
 4e1:	b8 13 00 00 00       	mov    $0x13,%eax
 4e6:	cd 40                	int    $0x40
 4e8:	c3                   	ret    

000004e9 <mkdir>:
SYSCALL(mkdir)
 4e9:	b8 14 00 00 00       	mov    $0x14,%eax
 4ee:	cd 40                	int    $0x40
 4f0:	c3                   	ret    

000004f1 <chdir>:
SYSCALL(chdir)
 4f1:	b8 09 00 00 00       	mov    $0x9,%eax
 4f6:	cd 40                	int    $0x40
 4f8:	c3                   	ret    

000004f9 <dup>:
SYSCALL(dup)
 4f9:	b8 0a 00 00 00       	mov    $0xa,%eax
 4fe:	cd 40                	int    $0x40
 500:	c3                   	ret    

00000501 <getpid>:
SYSCALL(getpid)
 501:	b8 0b 00 00 00       	mov    $0xb,%eax
 506:	cd 40                	int    $0x40
 508:	c3                   	ret    

00000509 <sbrk>:
SYSCALL(sbrk)
 509:	b8 0c 00 00 00       	mov    $0xc,%eax
 50e:	cd 40                	int    $0x40
 510:	c3                   	ret    

00000511 <sleep>:
SYSCALL(sleep)
 511:	b8 0d 00 00 00       	mov    $0xd,%eax
 516:	cd 40                	int    $0x40
 518:	c3                   	ret    

00000519 <uptime>:
SYSCALL(uptime)
 519:	b8 0e 00 00 00       	mov    $0xe,%eax
 51e:	cd 40                	int    $0x40
 520:	c3                   	ret    

00000521 <freemem>:
SYSCALL(freemem)
 521:	b8 16 00 00 00       	mov    $0x16,%eax
 526:	cd 40                	int    $0x40
 528:	c3                   	ret    

00000529 <exit2>:
SYSCALL(exit2)
 529:	b8 17 00 00 00       	mov    $0x17,%eax
 52e:	cd 40                	int    $0x40
 530:	c3                   	ret    

00000531 <wait2>:
SYSCALL(wait2)
 531:	b8 18 00 00 00       	mov    $0x18,%eax
 536:	cd 40                	int    $0x40
 538:	c3                   	ret    
 539:	66 90                	xchg   %ax,%ax
 53b:	66 90                	xchg   %ax,%ax
 53d:	66 90                	xchg   %ax,%ax
 53f:	90                   	nop

00000540 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 540:	55                   	push   %ebp
 541:	89 e5                	mov    %esp,%ebp
 543:	57                   	push   %edi
 544:	56                   	push   %esi
 545:	53                   	push   %ebx
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
 546:	89 d3                	mov    %edx,%ebx
{
 548:	83 ec 3c             	sub    $0x3c,%esp
 54b:	89 45 bc             	mov    %eax,-0x44(%ebp)
  if(sgn && xx < 0){
 54e:	85 d2                	test   %edx,%edx
 550:	0f 89 92 00 00 00    	jns    5e8 <printint+0xa8>
 556:	f6 45 08 01          	testb  $0x1,0x8(%ebp)
 55a:	0f 84 88 00 00 00    	je     5e8 <printint+0xa8>
    neg = 1;
 560:	c7 45 c0 01 00 00 00 	movl   $0x1,-0x40(%ebp)
    x = -xx;
 567:	f7 db                	neg    %ebx
  } else {
    x = xx;
  }

  i = 0;
 569:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
 570:	8d 75 d7             	lea    -0x29(%ebp),%esi
 573:	eb 08                	jmp    57d <printint+0x3d>
 575:	8d 76 00             	lea    0x0(%esi),%esi
  do{
    buf[i++] = digits[x % base];
 578:	89 7d c4             	mov    %edi,-0x3c(%ebp)
  }while((x /= base) != 0);
 57b:	89 c3                	mov    %eax,%ebx
    buf[i++] = digits[x % base];
 57d:	89 d8                	mov    %ebx,%eax
 57f:	31 d2                	xor    %edx,%edx
 581:	8b 7d c4             	mov    -0x3c(%ebp),%edi
 584:	f7 f1                	div    %ecx
 586:	83 c7 01             	add    $0x1,%edi
 589:	0f b6 92 28 0e 00 00 	movzbl 0xe28(%edx),%edx
 590:	88 14 3e             	mov    %dl,(%esi,%edi,1)
  }while((x /= base) != 0);
 593:	39 d9                	cmp    %ebx,%ecx
 595:	76 e1                	jbe    578 <printint+0x38>
  if(neg)
 597:	8b 45 c0             	mov    -0x40(%ebp),%eax
 59a:	85 c0                	test   %eax,%eax
 59c:	74 0d                	je     5ab <printint+0x6b>
    buf[i++] = '-';
 59e:	c6 44 3d d8 2d       	movb   $0x2d,-0x28(%ebp,%edi,1)
 5a3:	ba 2d 00 00 00       	mov    $0x2d,%edx
    buf[i++] = digits[x % base];
 5a8:	89 7d c4             	mov    %edi,-0x3c(%ebp)

  while(--i >= 0)
 5ab:	8b 45 c4             	mov    -0x3c(%ebp),%eax
 5ae:	8b 7d bc             	mov    -0x44(%ebp),%edi
 5b1:	8d 5c 05 d7          	lea    -0x29(%ebp,%eax,1),%ebx
 5b5:	eb 0f                	jmp    5c6 <printint+0x86>
 5b7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 5be:	66 90                	xchg   %ax,%ax
 5c0:	0f b6 13             	movzbl (%ebx),%edx
 5c3:	83 eb 01             	sub    $0x1,%ebx
  write(fd, &c, 1);
 5c6:	83 ec 04             	sub    $0x4,%esp
 5c9:	88 55 d7             	mov    %dl,-0x29(%ebp)
 5cc:	6a 01                	push   $0x1
 5ce:	56                   	push   %esi
 5cf:	57                   	push   %edi
 5d0:	e8 cc fe ff ff       	call   4a1 <write>
  while(--i >= 0)
 5d5:	83 c4 10             	add    $0x10,%esp
 5d8:	39 de                	cmp    %ebx,%esi
 5da:	75 e4                	jne    5c0 <printint+0x80>
    putc(fd, buf[i]);
}
 5dc:	8d 65 f4             	lea    -0xc(%ebp),%esp
 5df:	5b                   	pop    %ebx
 5e0:	5e                   	pop    %esi
 5e1:	5f                   	pop    %edi
 5e2:	5d                   	pop    %ebp
 5e3:	c3                   	ret    
 5e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  neg = 0;
 5e8:	c7 45 c0 00 00 00 00 	movl   $0x0,-0x40(%ebp)
 5ef:	e9 75 ff ff ff       	jmp    569 <printint+0x29>
 5f4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 5fb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 5ff:	90                   	nop

00000600 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 600:	55                   	push   %ebp
 601:	89 e5                	mov    %esp,%ebp
 603:	57                   	push   %edi
 604:	56                   	push   %esi
 605:	53                   	push   %ebx
 606:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 609:	8b 75 0c             	mov    0xc(%ebp),%esi
 60c:	0f b6 1e             	movzbl (%esi),%ebx
 60f:	84 db                	test   %bl,%bl
 611:	0f 84 b9 00 00 00    	je     6d0 <printf+0xd0>
  ap = (uint*)(void*)&fmt + 1;
 617:	8d 45 10             	lea    0x10(%ebp),%eax
 61a:	83 c6 01             	add    $0x1,%esi
  write(fd, &c, 1);
 61d:	8d 7d e7             	lea    -0x19(%ebp),%edi
  state = 0;
 620:	31 d2                	xor    %edx,%edx
  ap = (uint*)(void*)&fmt + 1;
 622:	89 45 d0             	mov    %eax,-0x30(%ebp)
 625:	eb 38                	jmp    65f <printf+0x5f>
 627:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 62e:	66 90                	xchg   %ax,%ax
 630:	89 55 d4             	mov    %edx,-0x2c(%ebp)
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
 633:	ba 25 00 00 00       	mov    $0x25,%edx
      if(c == '%'){
 638:	83 f8 25             	cmp    $0x25,%eax
 63b:	74 17                	je     654 <printf+0x54>
  write(fd, &c, 1);
 63d:	83 ec 04             	sub    $0x4,%esp
 640:	88 5d e7             	mov    %bl,-0x19(%ebp)
 643:	6a 01                	push   $0x1
 645:	57                   	push   %edi
 646:	ff 75 08             	pushl  0x8(%ebp)
 649:	e8 53 fe ff ff       	call   4a1 <write>
 64e:	8b 55 d4             	mov    -0x2c(%ebp),%edx
      } else {
        putc(fd, c);
 651:	83 c4 10             	add    $0x10,%esp
  for(i = 0; fmt[i]; i++){
 654:	83 c6 01             	add    $0x1,%esi
 657:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
 65b:	84 db                	test   %bl,%bl
 65d:	74 71                	je     6d0 <printf+0xd0>
    c = fmt[i] & 0xff;
 65f:	0f be cb             	movsbl %bl,%ecx
 662:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
 665:	85 d2                	test   %edx,%edx
 667:	74 c7                	je     630 <printf+0x30>
      }
    } else if(state == '%'){
 669:	83 fa 25             	cmp    $0x25,%edx
 66c:	75 e6                	jne    654 <printf+0x54>
      if(c == 'd'){
 66e:	83 f8 64             	cmp    $0x64,%eax
 671:	0f 84 99 00 00 00    	je     710 <printf+0x110>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 677:	81 e1 f7 00 00 00    	and    $0xf7,%ecx
 67d:	83 f9 70             	cmp    $0x70,%ecx
 680:	74 5e                	je     6e0 <printf+0xe0>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 682:	83 f8 73             	cmp    $0x73,%eax
 685:	0f 84 d5 00 00 00    	je     760 <printf+0x160>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 68b:	83 f8 63             	cmp    $0x63,%eax
 68e:	0f 84 8c 00 00 00    	je     720 <printf+0x120>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 694:	83 f8 25             	cmp    $0x25,%eax
 697:	0f 84 b3 00 00 00    	je     750 <printf+0x150>
  write(fd, &c, 1);
 69d:	83 ec 04             	sub    $0x4,%esp
 6a0:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
 6a4:	6a 01                	push   $0x1
 6a6:	57                   	push   %edi
 6a7:	ff 75 08             	pushl  0x8(%ebp)
 6aa:	e8 f2 fd ff ff       	call   4a1 <write>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
 6af:	88 5d e7             	mov    %bl,-0x19(%ebp)
  write(fd, &c, 1);
 6b2:	83 c4 0c             	add    $0xc,%esp
 6b5:	6a 01                	push   $0x1
 6b7:	83 c6 01             	add    $0x1,%esi
 6ba:	57                   	push   %edi
 6bb:	ff 75 08             	pushl  0x8(%ebp)
 6be:	e8 de fd ff ff       	call   4a1 <write>
  for(i = 0; fmt[i]; i++){
 6c3:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
        putc(fd, c);
 6c7:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 6ca:	31 d2                	xor    %edx,%edx
  for(i = 0; fmt[i]; i++){
 6cc:	84 db                	test   %bl,%bl
 6ce:	75 8f                	jne    65f <printf+0x5f>
    }
  }
}
 6d0:	8d 65 f4             	lea    -0xc(%ebp),%esp
 6d3:	5b                   	pop    %ebx
 6d4:	5e                   	pop    %esi
 6d5:	5f                   	pop    %edi
 6d6:	5d                   	pop    %ebp
 6d7:	c3                   	ret    
 6d8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 6df:	90                   	nop
        printint(fd, *ap, 16, 0);
 6e0:	83 ec 0c             	sub    $0xc,%esp
 6e3:	b9 10 00 00 00       	mov    $0x10,%ecx
 6e8:	6a 00                	push   $0x0
 6ea:	8b 5d d0             	mov    -0x30(%ebp),%ebx
 6ed:	8b 45 08             	mov    0x8(%ebp),%eax
 6f0:	8b 13                	mov    (%ebx),%edx
 6f2:	e8 49 fe ff ff       	call   540 <printint>
        ap++;
 6f7:	89 d8                	mov    %ebx,%eax
 6f9:	83 c4 10             	add    $0x10,%esp
      state = 0;
 6fc:	31 d2                	xor    %edx,%edx
        ap++;
 6fe:	83 c0 04             	add    $0x4,%eax
 701:	89 45 d0             	mov    %eax,-0x30(%ebp)
 704:	e9 4b ff ff ff       	jmp    654 <printf+0x54>
 709:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        printint(fd, *ap, 10, 1);
 710:	83 ec 0c             	sub    $0xc,%esp
 713:	b9 0a 00 00 00       	mov    $0xa,%ecx
 718:	6a 01                	push   $0x1
 71a:	eb ce                	jmp    6ea <printf+0xea>
 71c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        putc(fd, *ap);
 720:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  write(fd, &c, 1);
 723:	83 ec 04             	sub    $0x4,%esp
        putc(fd, *ap);
 726:	8b 03                	mov    (%ebx),%eax
  write(fd, &c, 1);
 728:	6a 01                	push   $0x1
        ap++;
 72a:	83 c3 04             	add    $0x4,%ebx
  write(fd, &c, 1);
 72d:	57                   	push   %edi
 72e:	ff 75 08             	pushl  0x8(%ebp)
        putc(fd, *ap);
 731:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 734:	e8 68 fd ff ff       	call   4a1 <write>
        ap++;
 739:	89 5d d0             	mov    %ebx,-0x30(%ebp)
 73c:	83 c4 10             	add    $0x10,%esp
      state = 0;
 73f:	31 d2                	xor    %edx,%edx
 741:	e9 0e ff ff ff       	jmp    654 <printf+0x54>
 746:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 74d:	8d 76 00             	lea    0x0(%esi),%esi
        putc(fd, c);
 750:	88 5d e7             	mov    %bl,-0x19(%ebp)
  write(fd, &c, 1);
 753:	83 ec 04             	sub    $0x4,%esp
 756:	e9 5a ff ff ff       	jmp    6b5 <printf+0xb5>
 75b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 75f:	90                   	nop
        s = (char*)*ap;
 760:	8b 45 d0             	mov    -0x30(%ebp),%eax
 763:	8b 18                	mov    (%eax),%ebx
        ap++;
 765:	83 c0 04             	add    $0x4,%eax
 768:	89 45 d0             	mov    %eax,-0x30(%ebp)
        if(s == 0)
 76b:	85 db                	test   %ebx,%ebx
 76d:	74 17                	je     786 <printf+0x186>
        while(*s != 0){
 76f:	0f b6 03             	movzbl (%ebx),%eax
      state = 0;
 772:	31 d2                	xor    %edx,%edx
        while(*s != 0){
 774:	84 c0                	test   %al,%al
 776:	0f 84 d8 fe ff ff    	je     654 <printf+0x54>
 77c:	89 75 d4             	mov    %esi,-0x2c(%ebp)
 77f:	89 de                	mov    %ebx,%esi
 781:	8b 5d 08             	mov    0x8(%ebp),%ebx
 784:	eb 1a                	jmp    7a0 <printf+0x1a0>
          s = "(null)";
 786:	bb 20 0e 00 00       	mov    $0xe20,%ebx
        while(*s != 0){
 78b:	89 75 d4             	mov    %esi,-0x2c(%ebp)
 78e:	b8 28 00 00 00       	mov    $0x28,%eax
 793:	89 de                	mov    %ebx,%esi
 795:	8b 5d 08             	mov    0x8(%ebp),%ebx
 798:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 79f:	90                   	nop
  write(fd, &c, 1);
 7a0:	83 ec 04             	sub    $0x4,%esp
          s++;
 7a3:	83 c6 01             	add    $0x1,%esi
 7a6:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 7a9:	6a 01                	push   $0x1
 7ab:	57                   	push   %edi
 7ac:	53                   	push   %ebx
 7ad:	e8 ef fc ff ff       	call   4a1 <write>
        while(*s != 0){
 7b2:	0f b6 06             	movzbl (%esi),%eax
 7b5:	83 c4 10             	add    $0x10,%esp
 7b8:	84 c0                	test   %al,%al
 7ba:	75 e4                	jne    7a0 <printf+0x1a0>
 7bc:	8b 75 d4             	mov    -0x2c(%ebp),%esi
      state = 0;
 7bf:	31 d2                	xor    %edx,%edx
 7c1:	e9 8e fe ff ff       	jmp    654 <printf+0x54>
 7c6:	66 90                	xchg   %ax,%ax
 7c8:	66 90                	xchg   %ax,%ax
 7ca:	66 90                	xchg   %ax,%ax
 7cc:	66 90                	xchg   %ax,%ax
 7ce:	66 90                	xchg   %ax,%ax

000007d0 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 7d0:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7d1:	a1 48 11 00 00       	mov    0x1148,%eax
{
 7d6:	89 e5                	mov    %esp,%ebp
 7d8:	57                   	push   %edi
 7d9:	56                   	push   %esi
 7da:	53                   	push   %ebx
 7db:	8b 5d 08             	mov    0x8(%ebp),%ebx
 7de:	8b 10                	mov    (%eax),%edx
  bp = (Header*)ap - 1;
 7e0:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7e3:	39 c8                	cmp    %ecx,%eax
 7e5:	73 19                	jae    800 <free+0x30>
 7e7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 7ee:	66 90                	xchg   %ax,%ax
 7f0:	39 d1                	cmp    %edx,%ecx
 7f2:	72 14                	jb     808 <free+0x38>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7f4:	39 d0                	cmp    %edx,%eax
 7f6:	73 10                	jae    808 <free+0x38>
{
 7f8:	89 d0                	mov    %edx,%eax
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7fa:	8b 10                	mov    (%eax),%edx
 7fc:	39 c8                	cmp    %ecx,%eax
 7fe:	72 f0                	jb     7f0 <free+0x20>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 800:	39 d0                	cmp    %edx,%eax
 802:	72 f4                	jb     7f8 <free+0x28>
 804:	39 d1                	cmp    %edx,%ecx
 806:	73 f0                	jae    7f8 <free+0x28>
      break;
  if(bp + bp->s.size == p->s.ptr){
 808:	8b 73 fc             	mov    -0x4(%ebx),%esi
 80b:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 80e:	39 fa                	cmp    %edi,%edx
 810:	74 1e                	je     830 <free+0x60>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 812:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 815:	8b 50 04             	mov    0x4(%eax),%edx
 818:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 81b:	39 f1                	cmp    %esi,%ecx
 81d:	74 28                	je     847 <free+0x77>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 81f:	89 08                	mov    %ecx,(%eax)
  freep = p;
}
 821:	5b                   	pop    %ebx
  freep = p;
 822:	a3 48 11 00 00       	mov    %eax,0x1148
}
 827:	5e                   	pop    %esi
 828:	5f                   	pop    %edi
 829:	5d                   	pop    %ebp
 82a:	c3                   	ret    
 82b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 82f:	90                   	nop
    bp->s.size += p->s.ptr->s.size;
 830:	03 72 04             	add    0x4(%edx),%esi
 833:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 836:	8b 10                	mov    (%eax),%edx
 838:	8b 12                	mov    (%edx),%edx
 83a:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 83d:	8b 50 04             	mov    0x4(%eax),%edx
 840:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 843:	39 f1                	cmp    %esi,%ecx
 845:	75 d8                	jne    81f <free+0x4f>
    p->s.size += bp->s.size;
 847:	03 53 fc             	add    -0x4(%ebx),%edx
  freep = p;
 84a:	a3 48 11 00 00       	mov    %eax,0x1148
    p->s.size += bp->s.size;
 84f:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 852:	8b 53 f8             	mov    -0x8(%ebx),%edx
 855:	89 10                	mov    %edx,(%eax)
}
 857:	5b                   	pop    %ebx
 858:	5e                   	pop    %esi
 859:	5f                   	pop    %edi
 85a:	5d                   	pop    %ebp
 85b:	c3                   	ret    
 85c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000860 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 860:	55                   	push   %ebp
 861:	89 e5                	mov    %esp,%ebp
 863:	57                   	push   %edi
 864:	56                   	push   %esi
 865:	53                   	push   %ebx
 866:	83 ec 1c             	sub    $0x1c,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 869:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
 86c:	8b 3d 48 11 00 00    	mov    0x1148,%edi
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 872:	8d 70 07             	lea    0x7(%eax),%esi
 875:	c1 ee 03             	shr    $0x3,%esi
 878:	83 c6 01             	add    $0x1,%esi
  if((prevp = freep) == 0){
 87b:	85 ff                	test   %edi,%edi
 87d:	0f 84 ad 00 00 00    	je     930 <malloc+0xd0>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 883:	8b 17                	mov    (%edi),%edx
    if(p->s.size >= nunits){
 885:	8b 4a 04             	mov    0x4(%edx),%ecx
 888:	39 f1                	cmp    %esi,%ecx
 88a:	73 72                	jae    8fe <malloc+0x9e>
 88c:	81 fe 00 10 00 00    	cmp    $0x1000,%esi
 892:	bb 00 10 00 00       	mov    $0x1000,%ebx
 897:	0f 43 de             	cmovae %esi,%ebx
  p = sbrk(nu * sizeof(Header));
 89a:	8d 04 dd 00 00 00 00 	lea    0x0(,%ebx,8),%eax
 8a1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
 8a4:	eb 1b                	jmp    8c1 <malloc+0x61>
 8a6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 8ad:	8d 76 00             	lea    0x0(%esi),%esi
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8b0:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 8b2:	8b 48 04             	mov    0x4(%eax),%ecx
 8b5:	39 f1                	cmp    %esi,%ecx
 8b7:	73 4f                	jae    908 <malloc+0xa8>
 8b9:	8b 3d 48 11 00 00    	mov    0x1148,%edi
 8bf:	89 c2                	mov    %eax,%edx
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 8c1:	39 d7                	cmp    %edx,%edi
 8c3:	75 eb                	jne    8b0 <malloc+0x50>
  p = sbrk(nu * sizeof(Header));
 8c5:	83 ec 0c             	sub    $0xc,%esp
 8c8:	ff 75 e4             	pushl  -0x1c(%ebp)
 8cb:	e8 39 fc ff ff       	call   509 <sbrk>
  if(p == (char*)-1)
 8d0:	83 c4 10             	add    $0x10,%esp
 8d3:	83 f8 ff             	cmp    $0xffffffff,%eax
 8d6:	74 1c                	je     8f4 <malloc+0x94>
  hp->s.size = nu;
 8d8:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 8db:	83 ec 0c             	sub    $0xc,%esp
 8de:	83 c0 08             	add    $0x8,%eax
 8e1:	50                   	push   %eax
 8e2:	e8 e9 fe ff ff       	call   7d0 <free>
  return freep;
 8e7:	8b 15 48 11 00 00    	mov    0x1148,%edx
      if((p = morecore(nunits)) == 0)
 8ed:	83 c4 10             	add    $0x10,%esp
 8f0:	85 d2                	test   %edx,%edx
 8f2:	75 bc                	jne    8b0 <malloc+0x50>
        return 0;
  }
}
 8f4:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return 0;
 8f7:	31 c0                	xor    %eax,%eax
}
 8f9:	5b                   	pop    %ebx
 8fa:	5e                   	pop    %esi
 8fb:	5f                   	pop    %edi
 8fc:	5d                   	pop    %ebp
 8fd:	c3                   	ret    
    if(p->s.size >= nunits){
 8fe:	89 d0                	mov    %edx,%eax
 900:	89 fa                	mov    %edi,%edx
 902:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      if(p->s.size == nunits)
 908:	39 ce                	cmp    %ecx,%esi
 90a:	74 54                	je     960 <malloc+0x100>
        p->s.size -= nunits;
 90c:	29 f1                	sub    %esi,%ecx
 90e:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
 911:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
 914:	89 70 04             	mov    %esi,0x4(%eax)
      freep = prevp;
 917:	89 15 48 11 00 00    	mov    %edx,0x1148
}
 91d:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return (void*)(p + 1);
 920:	83 c0 08             	add    $0x8,%eax
}
 923:	5b                   	pop    %ebx
 924:	5e                   	pop    %esi
 925:	5f                   	pop    %edi
 926:	5d                   	pop    %ebp
 927:	c3                   	ret    
 928:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 92f:	90                   	nop
    base.s.ptr = freep = prevp = &base;
 930:	c7 05 48 11 00 00 4c 	movl   $0x114c,0x1148
 937:	11 00 00 
    base.s.size = 0;
 93a:	bf 4c 11 00 00       	mov    $0x114c,%edi
    base.s.ptr = freep = prevp = &base;
 93f:	c7 05 4c 11 00 00 4c 	movl   $0x114c,0x114c
 946:	11 00 00 
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 949:	89 fa                	mov    %edi,%edx
    base.s.size = 0;
 94b:	c7 05 50 11 00 00 00 	movl   $0x0,0x1150
 952:	00 00 00 
    if(p->s.size >= nunits){
 955:	e9 32 ff ff ff       	jmp    88c <malloc+0x2c>
 95a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        prevp->s.ptr = p->s.ptr;
 960:	8b 08                	mov    (%eax),%ecx
 962:	89 0a                	mov    %ecx,(%edx)
 964:	eb b1                	jmp    917 <malloc+0xb7>
