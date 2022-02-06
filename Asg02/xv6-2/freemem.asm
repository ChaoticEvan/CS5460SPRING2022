
_freemem:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "stat.h"
#include "user.h"

int
main(int argc, char *argv[])
{
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	pushl  -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	51                   	push   %ecx
   e:	83 ec 04             	sub    $0x4,%esp
  int i = freemem();
  11:	e8 1b 03 00 00       	call   331 <freemem>
  printf(1, "%d", i, 1);
  16:	6a 01                	push   $0x1
  18:	50                   	push   %eax
  19:	68 78 07 00 00       	push   $0x778
  1e:	6a 01                	push   $0x1
  20:	e8 eb 03 00 00       	call   410 <printf>
  printf(1, "\n");
  25:	58                   	pop    %eax
  26:	5a                   	pop    %edx
  27:	68 7b 07 00 00       	push   $0x77b
  2c:	6a 01                	push   $0x1
  2e:	e8 dd 03 00 00       	call   410 <printf>
  exit();
  33:	e8 59 02 00 00       	call   291 <exit>
  38:	66 90                	xchg   %ax,%ax
  3a:	66 90                	xchg   %ax,%ax
  3c:	66 90                	xchg   %ax,%ax
  3e:	66 90                	xchg   %ax,%ax

00000040 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
  40:	55                   	push   %ebp
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  41:	31 d2                	xor    %edx,%edx
{
  43:	89 e5                	mov    %esp,%ebp
  45:	53                   	push   %ebx
  46:	8b 45 08             	mov    0x8(%ebp),%eax
  49:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while((*s++ = *t++) != 0)
  50:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  54:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  57:	83 c2 01             	add    $0x1,%edx
  5a:	84 c9                	test   %cl,%cl
  5c:	75 f2                	jne    50 <strcpy+0x10>
    ;
  return os;
}
  5e:	5b                   	pop    %ebx
  5f:	5d                   	pop    %ebp
  60:	c3                   	ret    
  61:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  68:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  6f:	90                   	nop

00000070 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  70:	55                   	push   %ebp
  71:	89 e5                	mov    %esp,%ebp
  73:	56                   	push   %esi
  74:	53                   	push   %ebx
  75:	8b 5d 08             	mov    0x8(%ebp),%ebx
  78:	8b 75 0c             	mov    0xc(%ebp),%esi
  while(*p && *p == *q)
  7b:	0f b6 13             	movzbl (%ebx),%edx
  7e:	0f b6 0e             	movzbl (%esi),%ecx
  81:	84 d2                	test   %dl,%dl
  83:	74 1e                	je     a3 <strcmp+0x33>
  85:	b8 01 00 00 00       	mov    $0x1,%eax
  8a:	38 ca                	cmp    %cl,%dl
  8c:	74 09                	je     97 <strcmp+0x27>
  8e:	eb 20                	jmp    b0 <strcmp+0x40>
  90:	83 c0 01             	add    $0x1,%eax
  93:	38 ca                	cmp    %cl,%dl
  95:	75 19                	jne    b0 <strcmp+0x40>
  97:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
  9b:	0f b6 0c 06          	movzbl (%esi,%eax,1),%ecx
  9f:	84 d2                	test   %dl,%dl
  a1:	75 ed                	jne    90 <strcmp+0x20>
  a3:	31 c0                	xor    %eax,%eax
    p++, q++;
  return (uchar)*p - (uchar)*q;
}
  a5:	5b                   	pop    %ebx
  a6:	5e                   	pop    %esi
  return (uchar)*p - (uchar)*q;
  a7:	29 c8                	sub    %ecx,%eax
}
  a9:	5d                   	pop    %ebp
  aa:	c3                   	ret    
  ab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  af:	90                   	nop
  b0:	0f b6 c2             	movzbl %dl,%eax
  b3:	5b                   	pop    %ebx
  b4:	5e                   	pop    %esi
  return (uchar)*p - (uchar)*q;
  b5:	29 c8                	sub    %ecx,%eax
}
  b7:	5d                   	pop    %ebp
  b8:	c3                   	ret    
  b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

000000c0 <strlen>:

uint
strlen(const char *s)
{
  c0:	55                   	push   %ebp
  c1:	89 e5                	mov    %esp,%ebp
  c3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
  c6:	80 39 00             	cmpb   $0x0,(%ecx)
  c9:	74 15                	je     e0 <strlen+0x20>
  cb:	31 d2                	xor    %edx,%edx
  cd:	8d 76 00             	lea    0x0(%esi),%esi
  d0:	83 c2 01             	add    $0x1,%edx
  d3:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  d7:	89 d0                	mov    %edx,%eax
  d9:	75 f5                	jne    d0 <strlen+0x10>
    ;
  return n;
}
  db:	5d                   	pop    %ebp
  dc:	c3                   	ret    
  dd:	8d 76 00             	lea    0x0(%esi),%esi
  for(n = 0; s[n]; n++)
  e0:	31 c0                	xor    %eax,%eax
}
  e2:	5d                   	pop    %ebp
  e3:	c3                   	ret    
  e4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  eb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  ef:	90                   	nop

000000f0 <memset>:

void*
memset(void *dst, int c, uint n)
{
  f0:	55                   	push   %ebp
  f1:	89 e5                	mov    %esp,%ebp
  f3:	57                   	push   %edi
  f4:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
  f7:	8b 4d 10             	mov    0x10(%ebp),%ecx
  fa:	8b 45 0c             	mov    0xc(%ebp),%eax
  fd:	89 d7                	mov    %edx,%edi
  ff:	fc                   	cld    
 100:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 102:	89 d0                	mov    %edx,%eax
 104:	5f                   	pop    %edi
 105:	5d                   	pop    %ebp
 106:	c3                   	ret    
 107:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 10e:	66 90                	xchg   %ax,%ax

00000110 <strchr>:

char*
strchr(const char *s, char c)
{
 110:	55                   	push   %ebp
 111:	89 e5                	mov    %esp,%ebp
 113:	53                   	push   %ebx
 114:	8b 45 08             	mov    0x8(%ebp),%eax
 117:	8b 55 0c             	mov    0xc(%ebp),%edx
  for(; *s; s++)
 11a:	0f b6 18             	movzbl (%eax),%ebx
 11d:	84 db                	test   %bl,%bl
 11f:	74 1d                	je     13e <strchr+0x2e>
 121:	89 d1                	mov    %edx,%ecx
    if(*s == c)
 123:	38 d3                	cmp    %dl,%bl
 125:	75 0d                	jne    134 <strchr+0x24>
 127:	eb 17                	jmp    140 <strchr+0x30>
 129:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 130:	38 ca                	cmp    %cl,%dl
 132:	74 0c                	je     140 <strchr+0x30>
  for(; *s; s++)
 134:	83 c0 01             	add    $0x1,%eax
 137:	0f b6 10             	movzbl (%eax),%edx
 13a:	84 d2                	test   %dl,%dl
 13c:	75 f2                	jne    130 <strchr+0x20>
      return (char*)s;
  return 0;
 13e:	31 c0                	xor    %eax,%eax
}
 140:	5b                   	pop    %ebx
 141:	5d                   	pop    %ebp
 142:	c3                   	ret    
 143:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 14a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00000150 <gets>:

char*
gets(char *buf, int max)
{
 150:	55                   	push   %ebp
 151:	89 e5                	mov    %esp,%ebp
 153:	57                   	push   %edi
 154:	56                   	push   %esi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 155:	31 f6                	xor    %esi,%esi
{
 157:	53                   	push   %ebx
 158:	89 f3                	mov    %esi,%ebx
 15a:	83 ec 1c             	sub    $0x1c,%esp
 15d:	8b 7d 08             	mov    0x8(%ebp),%edi
  for(i=0; i+1 < max; ){
 160:	eb 2f                	jmp    191 <gets+0x41>
 162:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    cc = read(0, &c, 1);
 168:	83 ec 04             	sub    $0x4,%esp
 16b:	8d 45 e7             	lea    -0x19(%ebp),%eax
 16e:	6a 01                	push   $0x1
 170:	50                   	push   %eax
 171:	6a 00                	push   $0x0
 173:	e8 31 01 00 00       	call   2a9 <read>
    if(cc < 1)
 178:	83 c4 10             	add    $0x10,%esp
 17b:	85 c0                	test   %eax,%eax
 17d:	7e 1c                	jle    19b <gets+0x4b>
      break;
    buf[i++] = c;
 17f:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 183:	83 c7 01             	add    $0x1,%edi
 186:	88 47 ff             	mov    %al,-0x1(%edi)
    if(c == '\n' || c == '\r')
 189:	3c 0a                	cmp    $0xa,%al
 18b:	74 23                	je     1b0 <gets+0x60>
 18d:	3c 0d                	cmp    $0xd,%al
 18f:	74 1f                	je     1b0 <gets+0x60>
  for(i=0; i+1 < max; ){
 191:	83 c3 01             	add    $0x1,%ebx
 194:	89 fe                	mov    %edi,%esi
 196:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 199:	7c cd                	jl     168 <gets+0x18>
 19b:	89 f3                	mov    %esi,%ebx
      break;
  }
  buf[i] = '\0';
  return buf;
}
 19d:	8b 45 08             	mov    0x8(%ebp),%eax
  buf[i] = '\0';
 1a0:	c6 03 00             	movb   $0x0,(%ebx)
}
 1a3:	8d 65 f4             	lea    -0xc(%ebp),%esp
 1a6:	5b                   	pop    %ebx
 1a7:	5e                   	pop    %esi
 1a8:	5f                   	pop    %edi
 1a9:	5d                   	pop    %ebp
 1aa:	c3                   	ret    
 1ab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 1af:	90                   	nop
 1b0:	8b 75 08             	mov    0x8(%ebp),%esi
 1b3:	8b 45 08             	mov    0x8(%ebp),%eax
 1b6:	01 de                	add    %ebx,%esi
 1b8:	89 f3                	mov    %esi,%ebx
  buf[i] = '\0';
 1ba:	c6 03 00             	movb   $0x0,(%ebx)
}
 1bd:	8d 65 f4             	lea    -0xc(%ebp),%esp
 1c0:	5b                   	pop    %ebx
 1c1:	5e                   	pop    %esi
 1c2:	5f                   	pop    %edi
 1c3:	5d                   	pop    %ebp
 1c4:	c3                   	ret    
 1c5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 1cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

000001d0 <stat>:

int
stat(const char *n, struct stat *st)
{
 1d0:	55                   	push   %ebp
 1d1:	89 e5                	mov    %esp,%ebp
 1d3:	56                   	push   %esi
 1d4:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1d5:	83 ec 08             	sub    $0x8,%esp
 1d8:	6a 00                	push   $0x0
 1da:	ff 75 08             	pushl  0x8(%ebp)
 1dd:	e8 ef 00 00 00       	call   2d1 <open>
  if(fd < 0)
 1e2:	83 c4 10             	add    $0x10,%esp
 1e5:	85 c0                	test   %eax,%eax
 1e7:	78 27                	js     210 <stat+0x40>
    return -1;
  r = fstat(fd, st);
 1e9:	83 ec 08             	sub    $0x8,%esp
 1ec:	ff 75 0c             	pushl  0xc(%ebp)
 1ef:	89 c3                	mov    %eax,%ebx
 1f1:	50                   	push   %eax
 1f2:	e8 f2 00 00 00       	call   2e9 <fstat>
  close(fd);
 1f7:	89 1c 24             	mov    %ebx,(%esp)
  r = fstat(fd, st);
 1fa:	89 c6                	mov    %eax,%esi
  close(fd);
 1fc:	e8 b8 00 00 00       	call   2b9 <close>
  return r;
 201:	83 c4 10             	add    $0x10,%esp
}
 204:	8d 65 f8             	lea    -0x8(%ebp),%esp
 207:	89 f0                	mov    %esi,%eax
 209:	5b                   	pop    %ebx
 20a:	5e                   	pop    %esi
 20b:	5d                   	pop    %ebp
 20c:	c3                   	ret    
 20d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
 210:	be ff ff ff ff       	mov    $0xffffffff,%esi
 215:	eb ed                	jmp    204 <stat+0x34>
 217:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 21e:	66 90                	xchg   %ax,%ax

00000220 <atoi>:

int
atoi(const char *s)
{
 220:	55                   	push   %ebp
 221:	89 e5                	mov    %esp,%ebp
 223:	53                   	push   %ebx
 224:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 227:	0f be 11             	movsbl (%ecx),%edx
 22a:	8d 42 d0             	lea    -0x30(%edx),%eax
 22d:	3c 09                	cmp    $0x9,%al
  n = 0;
 22f:	b8 00 00 00 00       	mov    $0x0,%eax
  while('0' <= *s && *s <= '9')
 234:	77 1f                	ja     255 <atoi+0x35>
 236:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 23d:	8d 76 00             	lea    0x0(%esi),%esi
    n = n*10 + *s++ - '0';
 240:	83 c1 01             	add    $0x1,%ecx
 243:	8d 04 80             	lea    (%eax,%eax,4),%eax
 246:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
  while('0' <= *s && *s <= '9')
 24a:	0f be 11             	movsbl (%ecx),%edx
 24d:	8d 5a d0             	lea    -0x30(%edx),%ebx
 250:	80 fb 09             	cmp    $0x9,%bl
 253:	76 eb                	jbe    240 <atoi+0x20>
  return n;
}
 255:	5b                   	pop    %ebx
 256:	5d                   	pop    %ebp
 257:	c3                   	ret    
 258:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 25f:	90                   	nop

00000260 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 260:	55                   	push   %ebp
 261:	89 e5                	mov    %esp,%ebp
 263:	57                   	push   %edi
 264:	8b 55 10             	mov    0x10(%ebp),%edx
 267:	8b 45 08             	mov    0x8(%ebp),%eax
 26a:	56                   	push   %esi
 26b:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 26e:	85 d2                	test   %edx,%edx
 270:	7e 13                	jle    285 <memmove+0x25>
 272:	01 c2                	add    %eax,%edx
  dst = vdst;
 274:	89 c7                	mov    %eax,%edi
 276:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 27d:	8d 76 00             	lea    0x0(%esi),%esi
    *dst++ = *src++;
 280:	a4                   	movsb  %ds:(%esi),%es:(%edi)
  while(n-- > 0)
 281:	39 fa                	cmp    %edi,%edx
 283:	75 fb                	jne    280 <memmove+0x20>
  return vdst;
}
 285:	5e                   	pop    %esi
 286:	5f                   	pop    %edi
 287:	5d                   	pop    %ebp
 288:	c3                   	ret    

00000289 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 289:	b8 01 00 00 00       	mov    $0x1,%eax
 28e:	cd 40                	int    $0x40
 290:	c3                   	ret    

00000291 <exit>:
SYSCALL(exit)
 291:	b8 02 00 00 00       	mov    $0x2,%eax
 296:	cd 40                	int    $0x40
 298:	c3                   	ret    

00000299 <wait>:
SYSCALL(wait)
 299:	b8 03 00 00 00       	mov    $0x3,%eax
 29e:	cd 40                	int    $0x40
 2a0:	c3                   	ret    

000002a1 <pipe>:
SYSCALL(pipe)
 2a1:	b8 04 00 00 00       	mov    $0x4,%eax
 2a6:	cd 40                	int    $0x40
 2a8:	c3                   	ret    

000002a9 <read>:
SYSCALL(read)
 2a9:	b8 05 00 00 00       	mov    $0x5,%eax
 2ae:	cd 40                	int    $0x40
 2b0:	c3                   	ret    

000002b1 <write>:
SYSCALL(write)
 2b1:	b8 10 00 00 00       	mov    $0x10,%eax
 2b6:	cd 40                	int    $0x40
 2b8:	c3                   	ret    

000002b9 <close>:
SYSCALL(close)
 2b9:	b8 15 00 00 00       	mov    $0x15,%eax
 2be:	cd 40                	int    $0x40
 2c0:	c3                   	ret    

000002c1 <kill>:
SYSCALL(kill)
 2c1:	b8 06 00 00 00       	mov    $0x6,%eax
 2c6:	cd 40                	int    $0x40
 2c8:	c3                   	ret    

000002c9 <exec>:
SYSCALL(exec)
 2c9:	b8 07 00 00 00       	mov    $0x7,%eax
 2ce:	cd 40                	int    $0x40
 2d0:	c3                   	ret    

000002d1 <open>:
SYSCALL(open)
 2d1:	b8 0f 00 00 00       	mov    $0xf,%eax
 2d6:	cd 40                	int    $0x40
 2d8:	c3                   	ret    

000002d9 <mknod>:
SYSCALL(mknod)
 2d9:	b8 11 00 00 00       	mov    $0x11,%eax
 2de:	cd 40                	int    $0x40
 2e0:	c3                   	ret    

000002e1 <unlink>:
SYSCALL(unlink)
 2e1:	b8 12 00 00 00       	mov    $0x12,%eax
 2e6:	cd 40                	int    $0x40
 2e8:	c3                   	ret    

000002e9 <fstat>:
SYSCALL(fstat)
 2e9:	b8 08 00 00 00       	mov    $0x8,%eax
 2ee:	cd 40                	int    $0x40
 2f0:	c3                   	ret    

000002f1 <link>:
SYSCALL(link)
 2f1:	b8 13 00 00 00       	mov    $0x13,%eax
 2f6:	cd 40                	int    $0x40
 2f8:	c3                   	ret    

000002f9 <mkdir>:
SYSCALL(mkdir)
 2f9:	b8 14 00 00 00       	mov    $0x14,%eax
 2fe:	cd 40                	int    $0x40
 300:	c3                   	ret    

00000301 <chdir>:
SYSCALL(chdir)
 301:	b8 09 00 00 00       	mov    $0x9,%eax
 306:	cd 40                	int    $0x40
 308:	c3                   	ret    

00000309 <dup>:
SYSCALL(dup)
 309:	b8 0a 00 00 00       	mov    $0xa,%eax
 30e:	cd 40                	int    $0x40
 310:	c3                   	ret    

00000311 <getpid>:
SYSCALL(getpid)
 311:	b8 0b 00 00 00       	mov    $0xb,%eax
 316:	cd 40                	int    $0x40
 318:	c3                   	ret    

00000319 <sbrk>:
SYSCALL(sbrk)
 319:	b8 0c 00 00 00       	mov    $0xc,%eax
 31e:	cd 40                	int    $0x40
 320:	c3                   	ret    

00000321 <sleep>:
SYSCALL(sleep)
 321:	b8 0d 00 00 00       	mov    $0xd,%eax
 326:	cd 40                	int    $0x40
 328:	c3                   	ret    

00000329 <uptime>:
SYSCALL(uptime)
 329:	b8 0e 00 00 00       	mov    $0xe,%eax
 32e:	cd 40                	int    $0x40
 330:	c3                   	ret    

00000331 <freemem>:
SYSCALL(freemem)
 331:	b8 16 00 00 00       	mov    $0x16,%eax
 336:	cd 40                	int    $0x40
 338:	c3                   	ret    

00000339 <exit2>:
SYSCALL(exit2)
 339:	b8 17 00 00 00       	mov    $0x17,%eax
 33e:	cd 40                	int    $0x40
 340:	c3                   	ret    

00000341 <wait2>:
SYSCALL(wait2)
 341:	b8 18 00 00 00       	mov    $0x18,%eax
 346:	cd 40                	int    $0x40
 348:	c3                   	ret    
 349:	66 90                	xchg   %ax,%ax
 34b:	66 90                	xchg   %ax,%ax
 34d:	66 90                	xchg   %ax,%ax
 34f:	90                   	nop

00000350 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 350:	55                   	push   %ebp
 351:	89 e5                	mov    %esp,%ebp
 353:	57                   	push   %edi
 354:	56                   	push   %esi
 355:	53                   	push   %ebx
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
 356:	89 d3                	mov    %edx,%ebx
{
 358:	83 ec 3c             	sub    $0x3c,%esp
 35b:	89 45 bc             	mov    %eax,-0x44(%ebp)
  if(sgn && xx < 0){
 35e:	85 d2                	test   %edx,%edx
 360:	0f 89 92 00 00 00    	jns    3f8 <printint+0xa8>
 366:	f6 45 08 01          	testb  $0x1,0x8(%ebp)
 36a:	0f 84 88 00 00 00    	je     3f8 <printint+0xa8>
    neg = 1;
 370:	c7 45 c0 01 00 00 00 	movl   $0x1,-0x40(%ebp)
    x = -xx;
 377:	f7 db                	neg    %ebx
  } else {
    x = xx;
  }

  i = 0;
 379:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
 380:	8d 75 d7             	lea    -0x29(%ebp),%esi
 383:	eb 08                	jmp    38d <printint+0x3d>
 385:	8d 76 00             	lea    0x0(%esi),%esi
  do{
    buf[i++] = digits[x % base];
 388:	89 7d c4             	mov    %edi,-0x3c(%ebp)
  }while((x /= base) != 0);
 38b:	89 c3                	mov    %eax,%ebx
    buf[i++] = digits[x % base];
 38d:	89 d8                	mov    %ebx,%eax
 38f:	31 d2                	xor    %edx,%edx
 391:	8b 7d c4             	mov    -0x3c(%ebp),%edi
 394:	f7 f1                	div    %ecx
 396:	83 c7 01             	add    $0x1,%edi
 399:	0f b6 92 84 07 00 00 	movzbl 0x784(%edx),%edx
 3a0:	88 14 3e             	mov    %dl,(%esi,%edi,1)
  }while((x /= base) != 0);
 3a3:	39 d9                	cmp    %ebx,%ecx
 3a5:	76 e1                	jbe    388 <printint+0x38>
  if(neg)
 3a7:	8b 45 c0             	mov    -0x40(%ebp),%eax
 3aa:	85 c0                	test   %eax,%eax
 3ac:	74 0d                	je     3bb <printint+0x6b>
    buf[i++] = '-';
 3ae:	c6 44 3d d8 2d       	movb   $0x2d,-0x28(%ebp,%edi,1)
 3b3:	ba 2d 00 00 00       	mov    $0x2d,%edx
    buf[i++] = digits[x % base];
 3b8:	89 7d c4             	mov    %edi,-0x3c(%ebp)

  while(--i >= 0)
 3bb:	8b 45 c4             	mov    -0x3c(%ebp),%eax
 3be:	8b 7d bc             	mov    -0x44(%ebp),%edi
 3c1:	8d 5c 05 d7          	lea    -0x29(%ebp,%eax,1),%ebx
 3c5:	eb 0f                	jmp    3d6 <printint+0x86>
 3c7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 3ce:	66 90                	xchg   %ax,%ax
 3d0:	0f b6 13             	movzbl (%ebx),%edx
 3d3:	83 eb 01             	sub    $0x1,%ebx
  write(fd, &c, 1);
 3d6:	83 ec 04             	sub    $0x4,%esp
 3d9:	88 55 d7             	mov    %dl,-0x29(%ebp)
 3dc:	6a 01                	push   $0x1
 3de:	56                   	push   %esi
 3df:	57                   	push   %edi
 3e0:	e8 cc fe ff ff       	call   2b1 <write>
  while(--i >= 0)
 3e5:	83 c4 10             	add    $0x10,%esp
 3e8:	39 de                	cmp    %ebx,%esi
 3ea:	75 e4                	jne    3d0 <printint+0x80>
    putc(fd, buf[i]);
}
 3ec:	8d 65 f4             	lea    -0xc(%ebp),%esp
 3ef:	5b                   	pop    %ebx
 3f0:	5e                   	pop    %esi
 3f1:	5f                   	pop    %edi
 3f2:	5d                   	pop    %ebp
 3f3:	c3                   	ret    
 3f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  neg = 0;
 3f8:	c7 45 c0 00 00 00 00 	movl   $0x0,-0x40(%ebp)
 3ff:	e9 75 ff ff ff       	jmp    379 <printint+0x29>
 404:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 40b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 40f:	90                   	nop

00000410 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 410:	55                   	push   %ebp
 411:	89 e5                	mov    %esp,%ebp
 413:	57                   	push   %edi
 414:	56                   	push   %esi
 415:	53                   	push   %ebx
 416:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 419:	8b 75 0c             	mov    0xc(%ebp),%esi
 41c:	0f b6 1e             	movzbl (%esi),%ebx
 41f:	84 db                	test   %bl,%bl
 421:	0f 84 b9 00 00 00    	je     4e0 <printf+0xd0>
  ap = (uint*)(void*)&fmt + 1;
 427:	8d 45 10             	lea    0x10(%ebp),%eax
 42a:	83 c6 01             	add    $0x1,%esi
  write(fd, &c, 1);
 42d:	8d 7d e7             	lea    -0x19(%ebp),%edi
  state = 0;
 430:	31 d2                	xor    %edx,%edx
  ap = (uint*)(void*)&fmt + 1;
 432:	89 45 d0             	mov    %eax,-0x30(%ebp)
 435:	eb 38                	jmp    46f <printf+0x5f>
 437:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 43e:	66 90                	xchg   %ax,%ax
 440:	89 55 d4             	mov    %edx,-0x2c(%ebp)
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
 443:	ba 25 00 00 00       	mov    $0x25,%edx
      if(c == '%'){
 448:	83 f8 25             	cmp    $0x25,%eax
 44b:	74 17                	je     464 <printf+0x54>
  write(fd, &c, 1);
 44d:	83 ec 04             	sub    $0x4,%esp
 450:	88 5d e7             	mov    %bl,-0x19(%ebp)
 453:	6a 01                	push   $0x1
 455:	57                   	push   %edi
 456:	ff 75 08             	pushl  0x8(%ebp)
 459:	e8 53 fe ff ff       	call   2b1 <write>
 45e:	8b 55 d4             	mov    -0x2c(%ebp),%edx
      } else {
        putc(fd, c);
 461:	83 c4 10             	add    $0x10,%esp
  for(i = 0; fmt[i]; i++){
 464:	83 c6 01             	add    $0x1,%esi
 467:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
 46b:	84 db                	test   %bl,%bl
 46d:	74 71                	je     4e0 <printf+0xd0>
    c = fmt[i] & 0xff;
 46f:	0f be cb             	movsbl %bl,%ecx
 472:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
 475:	85 d2                	test   %edx,%edx
 477:	74 c7                	je     440 <printf+0x30>
      }
    } else if(state == '%'){
 479:	83 fa 25             	cmp    $0x25,%edx
 47c:	75 e6                	jne    464 <printf+0x54>
      if(c == 'd'){
 47e:	83 f8 64             	cmp    $0x64,%eax
 481:	0f 84 99 00 00 00    	je     520 <printf+0x110>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 487:	81 e1 f7 00 00 00    	and    $0xf7,%ecx
 48d:	83 f9 70             	cmp    $0x70,%ecx
 490:	74 5e                	je     4f0 <printf+0xe0>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 492:	83 f8 73             	cmp    $0x73,%eax
 495:	0f 84 d5 00 00 00    	je     570 <printf+0x160>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 49b:	83 f8 63             	cmp    $0x63,%eax
 49e:	0f 84 8c 00 00 00    	je     530 <printf+0x120>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 4a4:	83 f8 25             	cmp    $0x25,%eax
 4a7:	0f 84 b3 00 00 00    	je     560 <printf+0x150>
  write(fd, &c, 1);
 4ad:	83 ec 04             	sub    $0x4,%esp
 4b0:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
 4b4:	6a 01                	push   $0x1
 4b6:	57                   	push   %edi
 4b7:	ff 75 08             	pushl  0x8(%ebp)
 4ba:	e8 f2 fd ff ff       	call   2b1 <write>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
 4bf:	88 5d e7             	mov    %bl,-0x19(%ebp)
  write(fd, &c, 1);
 4c2:	83 c4 0c             	add    $0xc,%esp
 4c5:	6a 01                	push   $0x1
 4c7:	83 c6 01             	add    $0x1,%esi
 4ca:	57                   	push   %edi
 4cb:	ff 75 08             	pushl  0x8(%ebp)
 4ce:	e8 de fd ff ff       	call   2b1 <write>
  for(i = 0; fmt[i]; i++){
 4d3:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
        putc(fd, c);
 4d7:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 4da:	31 d2                	xor    %edx,%edx
  for(i = 0; fmt[i]; i++){
 4dc:	84 db                	test   %bl,%bl
 4de:	75 8f                	jne    46f <printf+0x5f>
    }
  }
}
 4e0:	8d 65 f4             	lea    -0xc(%ebp),%esp
 4e3:	5b                   	pop    %ebx
 4e4:	5e                   	pop    %esi
 4e5:	5f                   	pop    %edi
 4e6:	5d                   	pop    %ebp
 4e7:	c3                   	ret    
 4e8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 4ef:	90                   	nop
        printint(fd, *ap, 16, 0);
 4f0:	83 ec 0c             	sub    $0xc,%esp
 4f3:	b9 10 00 00 00       	mov    $0x10,%ecx
 4f8:	6a 00                	push   $0x0
 4fa:	8b 5d d0             	mov    -0x30(%ebp),%ebx
 4fd:	8b 45 08             	mov    0x8(%ebp),%eax
 500:	8b 13                	mov    (%ebx),%edx
 502:	e8 49 fe ff ff       	call   350 <printint>
        ap++;
 507:	89 d8                	mov    %ebx,%eax
 509:	83 c4 10             	add    $0x10,%esp
      state = 0;
 50c:	31 d2                	xor    %edx,%edx
        ap++;
 50e:	83 c0 04             	add    $0x4,%eax
 511:	89 45 d0             	mov    %eax,-0x30(%ebp)
 514:	e9 4b ff ff ff       	jmp    464 <printf+0x54>
 519:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        printint(fd, *ap, 10, 1);
 520:	83 ec 0c             	sub    $0xc,%esp
 523:	b9 0a 00 00 00       	mov    $0xa,%ecx
 528:	6a 01                	push   $0x1
 52a:	eb ce                	jmp    4fa <printf+0xea>
 52c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        putc(fd, *ap);
 530:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  write(fd, &c, 1);
 533:	83 ec 04             	sub    $0x4,%esp
        putc(fd, *ap);
 536:	8b 03                	mov    (%ebx),%eax
  write(fd, &c, 1);
 538:	6a 01                	push   $0x1
        ap++;
 53a:	83 c3 04             	add    $0x4,%ebx
  write(fd, &c, 1);
 53d:	57                   	push   %edi
 53e:	ff 75 08             	pushl  0x8(%ebp)
        putc(fd, *ap);
 541:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 544:	e8 68 fd ff ff       	call   2b1 <write>
        ap++;
 549:	89 5d d0             	mov    %ebx,-0x30(%ebp)
 54c:	83 c4 10             	add    $0x10,%esp
      state = 0;
 54f:	31 d2                	xor    %edx,%edx
 551:	e9 0e ff ff ff       	jmp    464 <printf+0x54>
 556:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 55d:	8d 76 00             	lea    0x0(%esi),%esi
        putc(fd, c);
 560:	88 5d e7             	mov    %bl,-0x19(%ebp)
  write(fd, &c, 1);
 563:	83 ec 04             	sub    $0x4,%esp
 566:	e9 5a ff ff ff       	jmp    4c5 <printf+0xb5>
 56b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 56f:	90                   	nop
        s = (char*)*ap;
 570:	8b 45 d0             	mov    -0x30(%ebp),%eax
 573:	8b 18                	mov    (%eax),%ebx
        ap++;
 575:	83 c0 04             	add    $0x4,%eax
 578:	89 45 d0             	mov    %eax,-0x30(%ebp)
        if(s == 0)
 57b:	85 db                	test   %ebx,%ebx
 57d:	74 17                	je     596 <printf+0x186>
        while(*s != 0){
 57f:	0f b6 03             	movzbl (%ebx),%eax
      state = 0;
 582:	31 d2                	xor    %edx,%edx
        while(*s != 0){
 584:	84 c0                	test   %al,%al
 586:	0f 84 d8 fe ff ff    	je     464 <printf+0x54>
 58c:	89 75 d4             	mov    %esi,-0x2c(%ebp)
 58f:	89 de                	mov    %ebx,%esi
 591:	8b 5d 08             	mov    0x8(%ebp),%ebx
 594:	eb 1a                	jmp    5b0 <printf+0x1a0>
          s = "(null)";
 596:	bb 7d 07 00 00       	mov    $0x77d,%ebx
        while(*s != 0){
 59b:	89 75 d4             	mov    %esi,-0x2c(%ebp)
 59e:	b8 28 00 00 00       	mov    $0x28,%eax
 5a3:	89 de                	mov    %ebx,%esi
 5a5:	8b 5d 08             	mov    0x8(%ebp),%ebx
 5a8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 5af:	90                   	nop
  write(fd, &c, 1);
 5b0:	83 ec 04             	sub    $0x4,%esp
          s++;
 5b3:	83 c6 01             	add    $0x1,%esi
 5b6:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 5b9:	6a 01                	push   $0x1
 5bb:	57                   	push   %edi
 5bc:	53                   	push   %ebx
 5bd:	e8 ef fc ff ff       	call   2b1 <write>
        while(*s != 0){
 5c2:	0f b6 06             	movzbl (%esi),%eax
 5c5:	83 c4 10             	add    $0x10,%esp
 5c8:	84 c0                	test   %al,%al
 5ca:	75 e4                	jne    5b0 <printf+0x1a0>
 5cc:	8b 75 d4             	mov    -0x2c(%ebp),%esi
      state = 0;
 5cf:	31 d2                	xor    %edx,%edx
 5d1:	e9 8e fe ff ff       	jmp    464 <printf+0x54>
 5d6:	66 90                	xchg   %ax,%ax
 5d8:	66 90                	xchg   %ax,%ax
 5da:	66 90                	xchg   %ax,%ax
 5dc:	66 90                	xchg   %ax,%ax
 5de:	66 90                	xchg   %ax,%ax

000005e0 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 5e0:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 5e1:	a1 2c 0a 00 00       	mov    0xa2c,%eax
{
 5e6:	89 e5                	mov    %esp,%ebp
 5e8:	57                   	push   %edi
 5e9:	56                   	push   %esi
 5ea:	53                   	push   %ebx
 5eb:	8b 5d 08             	mov    0x8(%ebp),%ebx
 5ee:	8b 10                	mov    (%eax),%edx
  bp = (Header*)ap - 1;
 5f0:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 5f3:	39 c8                	cmp    %ecx,%eax
 5f5:	73 19                	jae    610 <free+0x30>
 5f7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 5fe:	66 90                	xchg   %ax,%ax
 600:	39 d1                	cmp    %edx,%ecx
 602:	72 14                	jb     618 <free+0x38>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 604:	39 d0                	cmp    %edx,%eax
 606:	73 10                	jae    618 <free+0x38>
{
 608:	89 d0                	mov    %edx,%eax
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 60a:	8b 10                	mov    (%eax),%edx
 60c:	39 c8                	cmp    %ecx,%eax
 60e:	72 f0                	jb     600 <free+0x20>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 610:	39 d0                	cmp    %edx,%eax
 612:	72 f4                	jb     608 <free+0x28>
 614:	39 d1                	cmp    %edx,%ecx
 616:	73 f0                	jae    608 <free+0x28>
      break;
  if(bp + bp->s.size == p->s.ptr){
 618:	8b 73 fc             	mov    -0x4(%ebx),%esi
 61b:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 61e:	39 fa                	cmp    %edi,%edx
 620:	74 1e                	je     640 <free+0x60>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 622:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 625:	8b 50 04             	mov    0x4(%eax),%edx
 628:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 62b:	39 f1                	cmp    %esi,%ecx
 62d:	74 28                	je     657 <free+0x77>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 62f:	89 08                	mov    %ecx,(%eax)
  freep = p;
}
 631:	5b                   	pop    %ebx
  freep = p;
 632:	a3 2c 0a 00 00       	mov    %eax,0xa2c
}
 637:	5e                   	pop    %esi
 638:	5f                   	pop    %edi
 639:	5d                   	pop    %ebp
 63a:	c3                   	ret    
 63b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 63f:	90                   	nop
    bp->s.size += p->s.ptr->s.size;
 640:	03 72 04             	add    0x4(%edx),%esi
 643:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 646:	8b 10                	mov    (%eax),%edx
 648:	8b 12                	mov    (%edx),%edx
 64a:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 64d:	8b 50 04             	mov    0x4(%eax),%edx
 650:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 653:	39 f1                	cmp    %esi,%ecx
 655:	75 d8                	jne    62f <free+0x4f>
    p->s.size += bp->s.size;
 657:	03 53 fc             	add    -0x4(%ebx),%edx
  freep = p;
 65a:	a3 2c 0a 00 00       	mov    %eax,0xa2c
    p->s.size += bp->s.size;
 65f:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 662:	8b 53 f8             	mov    -0x8(%ebx),%edx
 665:	89 10                	mov    %edx,(%eax)
}
 667:	5b                   	pop    %ebx
 668:	5e                   	pop    %esi
 669:	5f                   	pop    %edi
 66a:	5d                   	pop    %ebp
 66b:	c3                   	ret    
 66c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000670 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 670:	55                   	push   %ebp
 671:	89 e5                	mov    %esp,%ebp
 673:	57                   	push   %edi
 674:	56                   	push   %esi
 675:	53                   	push   %ebx
 676:	83 ec 1c             	sub    $0x1c,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 679:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
 67c:	8b 3d 2c 0a 00 00    	mov    0xa2c,%edi
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 682:	8d 70 07             	lea    0x7(%eax),%esi
 685:	c1 ee 03             	shr    $0x3,%esi
 688:	83 c6 01             	add    $0x1,%esi
  if((prevp = freep) == 0){
 68b:	85 ff                	test   %edi,%edi
 68d:	0f 84 ad 00 00 00    	je     740 <malloc+0xd0>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 693:	8b 17                	mov    (%edi),%edx
    if(p->s.size >= nunits){
 695:	8b 4a 04             	mov    0x4(%edx),%ecx
 698:	39 f1                	cmp    %esi,%ecx
 69a:	73 72                	jae    70e <malloc+0x9e>
 69c:	81 fe 00 10 00 00    	cmp    $0x1000,%esi
 6a2:	bb 00 10 00 00       	mov    $0x1000,%ebx
 6a7:	0f 43 de             	cmovae %esi,%ebx
  p = sbrk(nu * sizeof(Header));
 6aa:	8d 04 dd 00 00 00 00 	lea    0x0(,%ebx,8),%eax
 6b1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
 6b4:	eb 1b                	jmp    6d1 <malloc+0x61>
 6b6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 6bd:	8d 76 00             	lea    0x0(%esi),%esi
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 6c0:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 6c2:	8b 48 04             	mov    0x4(%eax),%ecx
 6c5:	39 f1                	cmp    %esi,%ecx
 6c7:	73 4f                	jae    718 <malloc+0xa8>
 6c9:	8b 3d 2c 0a 00 00    	mov    0xa2c,%edi
 6cf:	89 c2                	mov    %eax,%edx
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 6d1:	39 d7                	cmp    %edx,%edi
 6d3:	75 eb                	jne    6c0 <malloc+0x50>
  p = sbrk(nu * sizeof(Header));
 6d5:	83 ec 0c             	sub    $0xc,%esp
 6d8:	ff 75 e4             	pushl  -0x1c(%ebp)
 6db:	e8 39 fc ff ff       	call   319 <sbrk>
  if(p == (char*)-1)
 6e0:	83 c4 10             	add    $0x10,%esp
 6e3:	83 f8 ff             	cmp    $0xffffffff,%eax
 6e6:	74 1c                	je     704 <malloc+0x94>
  hp->s.size = nu;
 6e8:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 6eb:	83 ec 0c             	sub    $0xc,%esp
 6ee:	83 c0 08             	add    $0x8,%eax
 6f1:	50                   	push   %eax
 6f2:	e8 e9 fe ff ff       	call   5e0 <free>
  return freep;
 6f7:	8b 15 2c 0a 00 00    	mov    0xa2c,%edx
      if((p = morecore(nunits)) == 0)
 6fd:	83 c4 10             	add    $0x10,%esp
 700:	85 d2                	test   %edx,%edx
 702:	75 bc                	jne    6c0 <malloc+0x50>
        return 0;
  }
}
 704:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return 0;
 707:	31 c0                	xor    %eax,%eax
}
 709:	5b                   	pop    %ebx
 70a:	5e                   	pop    %esi
 70b:	5f                   	pop    %edi
 70c:	5d                   	pop    %ebp
 70d:	c3                   	ret    
    if(p->s.size >= nunits){
 70e:	89 d0                	mov    %edx,%eax
 710:	89 fa                	mov    %edi,%edx
 712:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      if(p->s.size == nunits)
 718:	39 ce                	cmp    %ecx,%esi
 71a:	74 54                	je     770 <malloc+0x100>
        p->s.size -= nunits;
 71c:	29 f1                	sub    %esi,%ecx
 71e:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
 721:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
 724:	89 70 04             	mov    %esi,0x4(%eax)
      freep = prevp;
 727:	89 15 2c 0a 00 00    	mov    %edx,0xa2c
}
 72d:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return (void*)(p + 1);
 730:	83 c0 08             	add    $0x8,%eax
}
 733:	5b                   	pop    %ebx
 734:	5e                   	pop    %esi
 735:	5f                   	pop    %edi
 736:	5d                   	pop    %ebp
 737:	c3                   	ret    
 738:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 73f:	90                   	nop
    base.s.ptr = freep = prevp = &base;
 740:	c7 05 2c 0a 00 00 30 	movl   $0xa30,0xa2c
 747:	0a 00 00 
    base.s.size = 0;
 74a:	bf 30 0a 00 00       	mov    $0xa30,%edi
    base.s.ptr = freep = prevp = &base;
 74f:	c7 05 30 0a 00 00 30 	movl   $0xa30,0xa30
 756:	0a 00 00 
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 759:	89 fa                	mov    %edi,%edx
    base.s.size = 0;
 75b:	c7 05 34 0a 00 00 00 	movl   $0x0,0xa34
 762:	00 00 00 
    if(p->s.size >= nunits){
 765:	e9 32 ff ff ff       	jmp    69c <malloc+0x2c>
 76a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        prevp->s.ptr = p->s.ptr;
 770:	8b 08                	mov    (%eax),%ecx
 772:	89 0a                	mov    %ecx,(%edx)
 774:	eb b1                	jmp    727 <malloc+0xb7>
