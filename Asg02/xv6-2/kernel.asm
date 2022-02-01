
kernel:     file format elf32-i386


Disassembly of section .text:

80100000 <multiboot_header>:
80100000:	02 b0 ad 1b 00 00    	add    0x1bad(%eax),%dh
80100006:	00 00                	add    %al,(%eax)
80100008:	fe 4f 52             	decb   0x52(%edi)
8010000b:	e4                   	.byte 0xe4

8010000c <entry>:

# Entering xv6 on boot processor, with paging off.
.globl entry
entry:
  # Turn on page size extension for 4Mbyte pages
  movl    %cr4, %eax
8010000c:	0f 20 e0             	mov    %cr4,%eax
  orl     $(CR4_PSE), %eax
8010000f:	83 c8 10             	or     $0x10,%eax
  movl    %eax, %cr4
80100012:	0f 22 e0             	mov    %eax,%cr4
  # Set page directory
  movl    $(V2P_WO(entrypgdir)), %eax
80100015:	b8 00 90 10 00       	mov    $0x109000,%eax
  movl    %eax, %cr3
8010001a:	0f 22 d8             	mov    %eax,%cr3
  # Turn on paging.
  movl    %cr0, %eax
8010001d:	0f 20 c0             	mov    %cr0,%eax
  orl     $(CR0_PG|CR0_WP), %eax
80100020:	0d 00 00 01 80       	or     $0x80010000,%eax
  movl    %eax, %cr0
80100025:	0f 22 c0             	mov    %eax,%cr0

  # Set up the stack pointer.
  movl $(stack + KSTACKSIZE), %esp
80100028:	bc c0 b5 10 80       	mov    $0x8010b5c0,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 30 30 10 80       	mov    $0x80103030,%eax
  jmp *%eax
80100032:	ff e0                	jmp    *%eax
80100034:	66 90                	xchg   %ax,%ax
80100036:	66 90                	xchg   %ax,%ax
80100038:	66 90                	xchg   %ax,%ax
8010003a:	66 90                	xchg   %ax,%ax
8010003c:	66 90                	xchg   %ax,%ax
8010003e:	66 90                	xchg   %ax,%ax

80100040 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
80100040:	55                   	push   %ebp
80100041:	89 e5                	mov    %esp,%ebp
80100043:	53                   	push   %ebx

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100044:	bb f4 b5 10 80       	mov    $0x8010b5f4,%ebx
{
80100049:	83 ec 0c             	sub    $0xc,%esp
  initlock(&bcache.lock, "bcache");
8010004c:	68 00 70 10 80       	push   $0x80107000
80100051:	68 c0 b5 10 80       	push   $0x8010b5c0
80100056:	e8 25 43 00 00       	call   80104380 <initlock>
  bcache.head.next = &bcache.head;
8010005b:	83 c4 10             	add    $0x10,%esp
8010005e:	ba bc fc 10 80       	mov    $0x8010fcbc,%edx
  bcache.head.prev = &bcache.head;
80100063:	c7 05 0c fd 10 80 bc 	movl   $0x8010fcbc,0x8010fd0c
8010006a:	fc 10 80 
  bcache.head.next = &bcache.head;
8010006d:	c7 05 10 fd 10 80 bc 	movl   $0x8010fcbc,0x8010fd10
80100074:	fc 10 80 
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100077:	eb 09                	jmp    80100082 <binit+0x42>
80100079:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100080:	89 c3                	mov    %eax,%ebx
    b->next = bcache.head.next;
    b->prev = &bcache.head;
    initsleeplock(&b->lock, "buffer");
80100082:	83 ec 08             	sub    $0x8,%esp
80100085:	8d 43 0c             	lea    0xc(%ebx),%eax
    b->next = bcache.head.next;
80100088:	89 53 54             	mov    %edx,0x54(%ebx)
    b->prev = &bcache.head;
8010008b:	c7 43 50 bc fc 10 80 	movl   $0x8010fcbc,0x50(%ebx)
    initsleeplock(&b->lock, "buffer");
80100092:	68 07 70 10 80       	push   $0x80107007
80100097:	50                   	push   %eax
80100098:	e8 b3 41 00 00       	call   80104250 <initsleeplock>
    bcache.head.next->prev = b;
8010009d:	a1 10 fd 10 80       	mov    0x8010fd10,%eax
801000a2:	89 da                	mov    %ebx,%edx
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000a4:	83 c4 10             	add    $0x10,%esp
    bcache.head.next->prev = b;
801000a7:	89 58 50             	mov    %ebx,0x50(%eax)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000aa:	8d 83 5c 02 00 00    	lea    0x25c(%ebx),%eax
    bcache.head.next = b;
801000b0:	89 1d 10 fd 10 80    	mov    %ebx,0x8010fd10
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000b6:	3d bc fc 10 80       	cmp    $0x8010fcbc,%eax
801000bb:	75 c3                	jne    80100080 <binit+0x40>
  }
}
801000bd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801000c0:	c9                   	leave  
801000c1:	c3                   	ret    
801000c2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801000c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801000d0 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
801000d0:	55                   	push   %ebp
801000d1:	89 e5                	mov    %esp,%ebp
801000d3:	57                   	push   %edi
801000d4:	56                   	push   %esi
801000d5:	53                   	push   %ebx
801000d6:	83 ec 18             	sub    $0x18,%esp
801000d9:	8b 7d 08             	mov    0x8(%ebp),%edi
801000dc:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&bcache.lock);
801000df:	68 c0 b5 10 80       	push   $0x8010b5c0
801000e4:	e8 f7 43 00 00       	call   801044e0 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000e9:	8b 1d 10 fd 10 80    	mov    0x8010fd10,%ebx
801000ef:	83 c4 10             	add    $0x10,%esp
801000f2:	81 fb bc fc 10 80    	cmp    $0x8010fcbc,%ebx
801000f8:	75 11                	jne    8010010b <bread+0x3b>
801000fa:	eb 24                	jmp    80100120 <bread+0x50>
801000fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100100:	8b 5b 54             	mov    0x54(%ebx),%ebx
80100103:	81 fb bc fc 10 80    	cmp    $0x8010fcbc,%ebx
80100109:	74 15                	je     80100120 <bread+0x50>
    if(b->dev == dev && b->blockno == blockno){
8010010b:	3b 7b 04             	cmp    0x4(%ebx),%edi
8010010e:	75 f0                	jne    80100100 <bread+0x30>
80100110:	3b 73 08             	cmp    0x8(%ebx),%esi
80100113:	75 eb                	jne    80100100 <bread+0x30>
      b->refcnt++;
80100115:	83 43 4c 01          	addl   $0x1,0x4c(%ebx)
      release(&bcache.lock);
80100119:	eb 3f                	jmp    8010015a <bread+0x8a>
8010011b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010011f:	90                   	nop
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100120:	8b 1d 0c fd 10 80    	mov    0x8010fd0c,%ebx
80100126:	81 fb bc fc 10 80    	cmp    $0x8010fcbc,%ebx
8010012c:	75 0d                	jne    8010013b <bread+0x6b>
8010012e:	eb 70                	jmp    801001a0 <bread+0xd0>
80100130:	8b 5b 50             	mov    0x50(%ebx),%ebx
80100133:	81 fb bc fc 10 80    	cmp    $0x8010fcbc,%ebx
80100139:	74 65                	je     801001a0 <bread+0xd0>
    if(b->refcnt == 0 && (b->flags & B_DIRTY) == 0) {
8010013b:	8b 43 4c             	mov    0x4c(%ebx),%eax
8010013e:	85 c0                	test   %eax,%eax
80100140:	75 ee                	jne    80100130 <bread+0x60>
80100142:	f6 03 04             	testb  $0x4,(%ebx)
80100145:	75 e9                	jne    80100130 <bread+0x60>
      b->dev = dev;
80100147:	89 7b 04             	mov    %edi,0x4(%ebx)
      b->blockno = blockno;
8010014a:	89 73 08             	mov    %esi,0x8(%ebx)
      b->flags = 0;
8010014d:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
      b->refcnt = 1;
80100153:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
      release(&bcache.lock);
8010015a:	83 ec 0c             	sub    $0xc,%esp
8010015d:	68 c0 b5 10 80       	push   $0x8010b5c0
80100162:	e8 39 44 00 00       	call   801045a0 <release>
      acquiresleep(&b->lock);
80100167:	8d 43 0c             	lea    0xc(%ebx),%eax
8010016a:	89 04 24             	mov    %eax,(%esp)
8010016d:	e8 1e 41 00 00       	call   80104290 <acquiresleep>
80100172:	83 c4 10             	add    $0x10,%esp
  struct buf *b;

  b = bget(dev, blockno);
  if((b->flags & B_VALID) == 0) {
80100175:	f6 03 02             	testb  $0x2,(%ebx)
80100178:	74 0e                	je     80100188 <bread+0xb8>
    iderw(b);
  }
  return b;
}
8010017a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010017d:	89 d8                	mov    %ebx,%eax
8010017f:	5b                   	pop    %ebx
80100180:	5e                   	pop    %esi
80100181:	5f                   	pop    %edi
80100182:	5d                   	pop    %ebp
80100183:	c3                   	ret    
80100184:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    iderw(b);
80100188:	83 ec 0c             	sub    $0xc,%esp
8010018b:	53                   	push   %ebx
8010018c:	e8 6f 20 00 00       	call   80102200 <iderw>
80100191:	83 c4 10             	add    $0x10,%esp
}
80100194:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100197:	89 d8                	mov    %ebx,%eax
80100199:	5b                   	pop    %ebx
8010019a:	5e                   	pop    %esi
8010019b:	5f                   	pop    %edi
8010019c:	5d                   	pop    %ebp
8010019d:	c3                   	ret    
8010019e:	66 90                	xchg   %ax,%ax
  panic("bget: no buffers");
801001a0:	83 ec 0c             	sub    $0xc,%esp
801001a3:	68 0e 70 10 80       	push   $0x8010700e
801001a8:	e8 e3 01 00 00       	call   80100390 <panic>
801001ad:	8d 76 00             	lea    0x0(%esi),%esi

801001b0 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
801001b0:	55                   	push   %ebp
801001b1:	89 e5                	mov    %esp,%ebp
801001b3:	53                   	push   %ebx
801001b4:	83 ec 10             	sub    $0x10,%esp
801001b7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001ba:	8d 43 0c             	lea    0xc(%ebx),%eax
801001bd:	50                   	push   %eax
801001be:	e8 6d 41 00 00       	call   80104330 <holdingsleep>
801001c3:	83 c4 10             	add    $0x10,%esp
801001c6:	85 c0                	test   %eax,%eax
801001c8:	74 0f                	je     801001d9 <bwrite+0x29>
    panic("bwrite");
  b->flags |= B_DIRTY;
801001ca:	83 0b 04             	orl    $0x4,(%ebx)
  iderw(b);
801001cd:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801001d0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801001d3:	c9                   	leave  
  iderw(b);
801001d4:	e9 27 20 00 00       	jmp    80102200 <iderw>
    panic("bwrite");
801001d9:	83 ec 0c             	sub    $0xc,%esp
801001dc:	68 1f 70 10 80       	push   $0x8010701f
801001e1:	e8 aa 01 00 00       	call   80100390 <panic>
801001e6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801001ed:	8d 76 00             	lea    0x0(%esi),%esi

801001f0 <brelse>:

// Release a locked buffer.
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
801001f0:	55                   	push   %ebp
801001f1:	89 e5                	mov    %esp,%ebp
801001f3:	56                   	push   %esi
801001f4:	53                   	push   %ebx
801001f5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001f8:	8d 73 0c             	lea    0xc(%ebx),%esi
801001fb:	83 ec 0c             	sub    $0xc,%esp
801001fe:	56                   	push   %esi
801001ff:	e8 2c 41 00 00       	call   80104330 <holdingsleep>
80100204:	83 c4 10             	add    $0x10,%esp
80100207:	85 c0                	test   %eax,%eax
80100209:	74 66                	je     80100271 <brelse+0x81>
    panic("brelse");

  releasesleep(&b->lock);
8010020b:	83 ec 0c             	sub    $0xc,%esp
8010020e:	56                   	push   %esi
8010020f:	e8 dc 40 00 00       	call   801042f0 <releasesleep>

  acquire(&bcache.lock);
80100214:	c7 04 24 c0 b5 10 80 	movl   $0x8010b5c0,(%esp)
8010021b:	e8 c0 42 00 00       	call   801044e0 <acquire>
  b->refcnt--;
80100220:	8b 43 4c             	mov    0x4c(%ebx),%eax
  if (b->refcnt == 0) {
80100223:	83 c4 10             	add    $0x10,%esp
  b->refcnt--;
80100226:	83 e8 01             	sub    $0x1,%eax
80100229:	89 43 4c             	mov    %eax,0x4c(%ebx)
  if (b->refcnt == 0) {
8010022c:	85 c0                	test   %eax,%eax
8010022e:	75 2f                	jne    8010025f <brelse+0x6f>
    // no one is waiting for it.
    b->next->prev = b->prev;
80100230:	8b 43 54             	mov    0x54(%ebx),%eax
80100233:	8b 53 50             	mov    0x50(%ebx),%edx
80100236:	89 50 50             	mov    %edx,0x50(%eax)
    b->prev->next = b->next;
80100239:	8b 43 50             	mov    0x50(%ebx),%eax
8010023c:	8b 53 54             	mov    0x54(%ebx),%edx
8010023f:	89 50 54             	mov    %edx,0x54(%eax)
    b->next = bcache.head.next;
80100242:	a1 10 fd 10 80       	mov    0x8010fd10,%eax
    b->prev = &bcache.head;
80100247:	c7 43 50 bc fc 10 80 	movl   $0x8010fcbc,0x50(%ebx)
    b->next = bcache.head.next;
8010024e:	89 43 54             	mov    %eax,0x54(%ebx)
    bcache.head.next->prev = b;
80100251:	a1 10 fd 10 80       	mov    0x8010fd10,%eax
80100256:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
80100259:	89 1d 10 fd 10 80    	mov    %ebx,0x8010fd10
  }
  
  release(&bcache.lock);
8010025f:	c7 45 08 c0 b5 10 80 	movl   $0x8010b5c0,0x8(%ebp)
}
80100266:	8d 65 f8             	lea    -0x8(%ebp),%esp
80100269:	5b                   	pop    %ebx
8010026a:	5e                   	pop    %esi
8010026b:	5d                   	pop    %ebp
  release(&bcache.lock);
8010026c:	e9 2f 43 00 00       	jmp    801045a0 <release>
    panic("brelse");
80100271:	83 ec 0c             	sub    $0xc,%esp
80100274:	68 26 70 10 80       	push   $0x80107026
80100279:	e8 12 01 00 00       	call   80100390 <panic>
8010027e:	66 90                	xchg   %ax,%ax

80100280 <consoleread>:
  }
}

int
consoleread(struct inode *ip, char *dst, int n)
{
80100280:	55                   	push   %ebp
80100281:	89 e5                	mov    %esp,%ebp
80100283:	57                   	push   %edi
80100284:	56                   	push   %esi
80100285:	53                   	push   %ebx
80100286:	83 ec 28             	sub    $0x28,%esp
  uint target;
  int c;

  iunlock(ip);
80100289:	ff 75 08             	pushl  0x8(%ebp)
{
8010028c:	8b 75 10             	mov    0x10(%ebp),%esi
  iunlock(ip);
8010028f:	e8 6c 15 00 00       	call   80101800 <iunlock>
  target = n;
  acquire(&cons.lock);
80100294:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
8010029b:	e8 40 42 00 00       	call   801044e0 <acquire>
        // caller gets a 0-byte result.
        input.r--;
      }
      break;
    }
    *dst++ = c;
801002a0:	8b 7d 0c             	mov    0xc(%ebp),%edi
  while(n > 0){
801002a3:	83 c4 10             	add    $0x10,%esp
801002a6:	31 c0                	xor    %eax,%eax
    *dst++ = c;
801002a8:	01 f7                	add    %esi,%edi
  while(n > 0){
801002aa:	85 f6                	test   %esi,%esi
801002ac:	0f 8e a0 00 00 00    	jle    80100352 <consoleread+0xd2>
801002b2:	89 f3                	mov    %esi,%ebx
    while(input.r == input.w){
801002b4:	8b 15 a0 ff 10 80    	mov    0x8010ffa0,%edx
801002ba:	39 15 a4 ff 10 80    	cmp    %edx,0x8010ffa4
801002c0:	74 29                	je     801002eb <consoleread+0x6b>
801002c2:	eb 5c                	jmp    80100320 <consoleread+0xa0>
801002c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      sleep(&input.r, &cons.lock);
801002c8:	83 ec 08             	sub    $0x8,%esp
801002cb:	68 20 a5 10 80       	push   $0x8010a520
801002d0:	68 a0 ff 10 80       	push   $0x8010ffa0
801002d5:	e8 26 3c 00 00       	call   80103f00 <sleep>
    while(input.r == input.w){
801002da:	8b 15 a0 ff 10 80    	mov    0x8010ffa0,%edx
801002e0:	83 c4 10             	add    $0x10,%esp
801002e3:	3b 15 a4 ff 10 80    	cmp    0x8010ffa4,%edx
801002e9:	75 35                	jne    80100320 <consoleread+0xa0>
      if(myproc()->killed){
801002eb:	e8 70 36 00 00       	call   80103960 <myproc>
801002f0:	8b 48 24             	mov    0x24(%eax),%ecx
801002f3:	85 c9                	test   %ecx,%ecx
801002f5:	74 d1                	je     801002c8 <consoleread+0x48>
        release(&cons.lock);
801002f7:	83 ec 0c             	sub    $0xc,%esp
801002fa:	68 20 a5 10 80       	push   $0x8010a520
801002ff:	e8 9c 42 00 00       	call   801045a0 <release>
        ilock(ip);
80100304:	5a                   	pop    %edx
80100305:	ff 75 08             	pushl  0x8(%ebp)
80100308:	e8 13 14 00 00       	call   80101720 <ilock>
        return -1;
8010030d:	83 c4 10             	add    $0x10,%esp
  }
  release(&cons.lock);
  ilock(ip);

  return target - n;
}
80100310:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return -1;
80100313:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100318:	5b                   	pop    %ebx
80100319:	5e                   	pop    %esi
8010031a:	5f                   	pop    %edi
8010031b:	5d                   	pop    %ebp
8010031c:	c3                   	ret    
8010031d:	8d 76 00             	lea    0x0(%esi),%esi
    c = input.buf[input.r++ % INPUT_BUF];
80100320:	8d 42 01             	lea    0x1(%edx),%eax
80100323:	a3 a0 ff 10 80       	mov    %eax,0x8010ffa0
80100328:	89 d0                	mov    %edx,%eax
8010032a:	83 e0 7f             	and    $0x7f,%eax
8010032d:	0f be 80 20 ff 10 80 	movsbl -0x7fef00e0(%eax),%eax
    if(c == C('D')){  // EOF
80100334:	83 f8 04             	cmp    $0x4,%eax
80100337:	74 46                	je     8010037f <consoleread+0xff>
    *dst++ = c;
80100339:	89 da                	mov    %ebx,%edx
    --n;
8010033b:	83 eb 01             	sub    $0x1,%ebx
    *dst++ = c;
8010033e:	f7 da                	neg    %edx
80100340:	88 04 17             	mov    %al,(%edi,%edx,1)
    if(c == '\n')
80100343:	83 f8 0a             	cmp    $0xa,%eax
80100346:	74 31                	je     80100379 <consoleread+0xf9>
  while(n > 0){
80100348:	85 db                	test   %ebx,%ebx
8010034a:	0f 85 64 ff ff ff    	jne    801002b4 <consoleread+0x34>
80100350:	89 f0                	mov    %esi,%eax
  release(&cons.lock);
80100352:	83 ec 0c             	sub    $0xc,%esp
80100355:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80100358:	68 20 a5 10 80       	push   $0x8010a520
8010035d:	e8 3e 42 00 00       	call   801045a0 <release>
  ilock(ip);
80100362:	58                   	pop    %eax
80100363:	ff 75 08             	pushl  0x8(%ebp)
80100366:	e8 b5 13 00 00       	call   80101720 <ilock>
  return target - n;
8010036b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010036e:	83 c4 10             	add    $0x10,%esp
}
80100371:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100374:	5b                   	pop    %ebx
80100375:	5e                   	pop    %esi
80100376:	5f                   	pop    %edi
80100377:	5d                   	pop    %ebp
80100378:	c3                   	ret    
80100379:	89 f0                	mov    %esi,%eax
8010037b:	29 d8                	sub    %ebx,%eax
8010037d:	eb d3                	jmp    80100352 <consoleread+0xd2>
      if(n < target){
8010037f:	89 f0                	mov    %esi,%eax
80100381:	29 d8                	sub    %ebx,%eax
80100383:	39 f3                	cmp    %esi,%ebx
80100385:	73 cb                	jae    80100352 <consoleread+0xd2>
        input.r--;
80100387:	89 15 a0 ff 10 80    	mov    %edx,0x8010ffa0
8010038d:	eb c3                	jmp    80100352 <consoleread+0xd2>
8010038f:	90                   	nop

80100390 <panic>:
{
80100390:	55                   	push   %ebp
80100391:	89 e5                	mov    %esp,%ebp
80100393:	56                   	push   %esi
80100394:	53                   	push   %ebx
80100395:	83 ec 30             	sub    $0x30,%esp
}

static inline void
cli(void)
{
  asm volatile("cli");
80100398:	fa                   	cli    
  cons.locking = 0;
80100399:	c7 05 54 a5 10 80 00 	movl   $0x0,0x8010a554
801003a0:	00 00 00 
  getcallerpcs(&s, pcs);
801003a3:	8d 5d d0             	lea    -0x30(%ebp),%ebx
801003a6:	8d 75 f8             	lea    -0x8(%ebp),%esi
  cprintf("lapicid %d: panic: ", lapicid());
801003a9:	e8 02 25 00 00       	call   801028b0 <lapicid>
801003ae:	83 ec 08             	sub    $0x8,%esp
801003b1:	50                   	push   %eax
801003b2:	68 2d 70 10 80       	push   $0x8010702d
801003b7:	e8 f4 02 00 00       	call   801006b0 <cprintf>
  cprintf(s);
801003bc:	58                   	pop    %eax
801003bd:	ff 75 08             	pushl  0x8(%ebp)
801003c0:	e8 eb 02 00 00       	call   801006b0 <cprintf>
  cprintf("\n");
801003c5:	c7 04 24 7b 79 10 80 	movl   $0x8010797b,(%esp)
801003cc:	e8 df 02 00 00       	call   801006b0 <cprintf>
  getcallerpcs(&s, pcs);
801003d1:	8d 45 08             	lea    0x8(%ebp),%eax
801003d4:	5a                   	pop    %edx
801003d5:	59                   	pop    %ecx
801003d6:	53                   	push   %ebx
801003d7:	50                   	push   %eax
801003d8:	e8 c3 3f 00 00       	call   801043a0 <getcallerpcs>
  for(i=0; i<10; i++)
801003dd:	83 c4 10             	add    $0x10,%esp
    cprintf(" %p", pcs[i]);
801003e0:	83 ec 08             	sub    $0x8,%esp
801003e3:	ff 33                	pushl  (%ebx)
801003e5:	83 c3 04             	add    $0x4,%ebx
801003e8:	68 41 70 10 80       	push   $0x80107041
801003ed:	e8 be 02 00 00       	call   801006b0 <cprintf>
  for(i=0; i<10; i++)
801003f2:	83 c4 10             	add    $0x10,%esp
801003f5:	39 f3                	cmp    %esi,%ebx
801003f7:	75 e7                	jne    801003e0 <panic+0x50>
  panicked = 1; // freeze other CPU
801003f9:	c7 05 58 a5 10 80 01 	movl   $0x1,0x8010a558
80100400:	00 00 00 
  for(;;)
80100403:	eb fe                	jmp    80100403 <panic+0x73>
80100405:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010040c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100410 <consputc.part.0>:
consputc(int c)
80100410:	55                   	push   %ebp
80100411:	89 e5                	mov    %esp,%ebp
80100413:	57                   	push   %edi
80100414:	56                   	push   %esi
80100415:	53                   	push   %ebx
80100416:	89 c3                	mov    %eax,%ebx
80100418:	83 ec 1c             	sub    $0x1c,%esp
  if(c == BACKSPACE){
8010041b:	3d 00 01 00 00       	cmp    $0x100,%eax
80100420:	0f 84 ea 00 00 00    	je     80100510 <consputc.part.0+0x100>
    uartputc(c);
80100426:	83 ec 0c             	sub    $0xc,%esp
80100429:	50                   	push   %eax
8010042a:	e8 f1 57 00 00       	call   80105c20 <uartputc>
8010042f:	83 c4 10             	add    $0x10,%esp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100432:	bf d4 03 00 00       	mov    $0x3d4,%edi
80100437:	b8 0e 00 00 00       	mov    $0xe,%eax
8010043c:	89 fa                	mov    %edi,%edx
8010043e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010043f:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
80100444:	89 ca                	mov    %ecx,%edx
80100446:	ec                   	in     (%dx),%al
  pos = inb(CRTPORT+1) << 8;
80100447:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010044a:	89 fa                	mov    %edi,%edx
8010044c:	c1 e0 08             	shl    $0x8,%eax
8010044f:	89 c6                	mov    %eax,%esi
80100451:	b8 0f 00 00 00       	mov    $0xf,%eax
80100456:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100457:	89 ca                	mov    %ecx,%edx
80100459:	ec                   	in     (%dx),%al
  pos |= inb(CRTPORT+1);
8010045a:	0f b6 c0             	movzbl %al,%eax
8010045d:	09 f0                	or     %esi,%eax
  if(c == '\n')
8010045f:	83 fb 0a             	cmp    $0xa,%ebx
80100462:	0f 84 90 00 00 00    	je     801004f8 <consputc.part.0+0xe8>
  else if(c == BACKSPACE){
80100468:	81 fb 00 01 00 00    	cmp    $0x100,%ebx
8010046e:	74 70                	je     801004e0 <consputc.part.0+0xd0>
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
80100470:	0f b6 db             	movzbl %bl,%ebx
80100473:	8d 70 01             	lea    0x1(%eax),%esi
80100476:	80 cf 07             	or     $0x7,%bh
80100479:	66 89 9c 00 00 80 0b 	mov    %bx,-0x7ff48000(%eax,%eax,1)
80100480:	80 
  if(pos < 0 || pos > 25*80)
80100481:	81 fe d0 07 00 00    	cmp    $0x7d0,%esi
80100487:	0f 8f f9 00 00 00    	jg     80100586 <consputc.part.0+0x176>
  if((pos/80) >= 24){  // Scroll up.
8010048d:	81 fe 7f 07 00 00    	cmp    $0x77f,%esi
80100493:	0f 8f a7 00 00 00    	jg     80100540 <consputc.part.0+0x130>
80100499:	89 f0                	mov    %esi,%eax
8010049b:	8d b4 36 00 80 0b 80 	lea    -0x7ff48000(%esi,%esi,1),%esi
801004a2:	88 45 e7             	mov    %al,-0x19(%ebp)
801004a5:	0f b6 fc             	movzbl %ah,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801004a8:	bb d4 03 00 00       	mov    $0x3d4,%ebx
801004ad:	b8 0e 00 00 00       	mov    $0xe,%eax
801004b2:	89 da                	mov    %ebx,%edx
801004b4:	ee                   	out    %al,(%dx)
801004b5:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
801004ba:	89 f8                	mov    %edi,%eax
801004bc:	89 ca                	mov    %ecx,%edx
801004be:	ee                   	out    %al,(%dx)
801004bf:	b8 0f 00 00 00       	mov    $0xf,%eax
801004c4:	89 da                	mov    %ebx,%edx
801004c6:	ee                   	out    %al,(%dx)
801004c7:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
801004cb:	89 ca                	mov    %ecx,%edx
801004cd:	ee                   	out    %al,(%dx)
  crt[pos] = ' ' | 0x0700;
801004ce:	b8 20 07 00 00       	mov    $0x720,%eax
801004d3:	66 89 06             	mov    %ax,(%esi)
}
801004d6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801004d9:	5b                   	pop    %ebx
801004da:	5e                   	pop    %esi
801004db:	5f                   	pop    %edi
801004dc:	5d                   	pop    %ebp
801004dd:	c3                   	ret    
801004de:	66 90                	xchg   %ax,%ax
    if(pos > 0) --pos;
801004e0:	8d 70 ff             	lea    -0x1(%eax),%esi
801004e3:	85 c0                	test   %eax,%eax
801004e5:	75 9a                	jne    80100481 <consputc.part.0+0x71>
801004e7:	be 00 80 0b 80       	mov    $0x800b8000,%esi
801004ec:	c6 45 e7 00          	movb   $0x0,-0x19(%ebp)
801004f0:	31 ff                	xor    %edi,%edi
801004f2:	eb b4                	jmp    801004a8 <consputc.part.0+0x98>
801004f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    pos += 80 - pos%80;
801004f8:	ba cd cc cc cc       	mov    $0xcccccccd,%edx
801004fd:	f7 e2                	mul    %edx
801004ff:	c1 ea 06             	shr    $0x6,%edx
80100502:	8d 04 92             	lea    (%edx,%edx,4),%eax
80100505:	c1 e0 04             	shl    $0x4,%eax
80100508:	8d 70 50             	lea    0x50(%eax),%esi
8010050b:	e9 71 ff ff ff       	jmp    80100481 <consputc.part.0+0x71>
    uartputc('\b'); uartputc(' '); uartputc('\b');
80100510:	83 ec 0c             	sub    $0xc,%esp
80100513:	6a 08                	push   $0x8
80100515:	e8 06 57 00 00       	call   80105c20 <uartputc>
8010051a:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80100521:	e8 fa 56 00 00       	call   80105c20 <uartputc>
80100526:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
8010052d:	e8 ee 56 00 00       	call   80105c20 <uartputc>
80100532:	83 c4 10             	add    $0x10,%esp
80100535:	e9 f8 fe ff ff       	jmp    80100432 <consputc.part.0+0x22>
8010053a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
80100540:	83 ec 04             	sub    $0x4,%esp
    pos -= 80;
80100543:	8d 5e b0             	lea    -0x50(%esi),%ebx
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100546:	bf 07 00 00 00       	mov    $0x7,%edi
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
8010054b:	68 60 0e 00 00       	push   $0xe60
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100550:	8d b4 1b 00 80 0b 80 	lea    -0x7ff48000(%ebx,%ebx,1),%esi
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
80100557:	68 a0 80 0b 80       	push   $0x800b80a0
8010055c:	68 00 80 0b 80       	push   $0x800b8000
80100561:	e8 2a 41 00 00       	call   80104690 <memmove>
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100566:	b8 80 07 00 00       	mov    $0x780,%eax
8010056b:	83 c4 0c             	add    $0xc,%esp
8010056e:	29 d8                	sub    %ebx,%eax
80100570:	01 c0                	add    %eax,%eax
80100572:	50                   	push   %eax
80100573:	6a 00                	push   $0x0
80100575:	56                   	push   %esi
80100576:	e8 75 40 00 00       	call   801045f0 <memset>
8010057b:	88 5d e7             	mov    %bl,-0x19(%ebp)
8010057e:	83 c4 10             	add    $0x10,%esp
80100581:	e9 22 ff ff ff       	jmp    801004a8 <consputc.part.0+0x98>
    panic("pos under/overflow");
80100586:	83 ec 0c             	sub    $0xc,%esp
80100589:	68 45 70 10 80       	push   $0x80107045
8010058e:	e8 fd fd ff ff       	call   80100390 <panic>
80100593:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010059a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801005a0 <printint>:
{
801005a0:	55                   	push   %ebp
801005a1:	89 e5                	mov    %esp,%ebp
801005a3:	57                   	push   %edi
801005a4:	56                   	push   %esi
801005a5:	53                   	push   %ebx
801005a6:	83 ec 2c             	sub    $0x2c,%esp
801005a9:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  if(sign && (sign = xx < 0))
801005ac:	85 c9                	test   %ecx,%ecx
801005ae:	74 04                	je     801005b4 <printint+0x14>
801005b0:	85 c0                	test   %eax,%eax
801005b2:	78 68                	js     8010061c <printint+0x7c>
    x = xx;
801005b4:	89 c1                	mov    %eax,%ecx
801005b6:	31 f6                	xor    %esi,%esi
  i = 0;
801005b8:	31 db                	xor    %ebx,%ebx
801005ba:	eb 04                	jmp    801005c0 <printint+0x20>
  }while((x /= base) != 0);
801005bc:	89 c1                	mov    %eax,%ecx
    buf[i++] = digits[x % base];
801005be:	89 fb                	mov    %edi,%ebx
801005c0:	89 c8                	mov    %ecx,%eax
801005c2:	31 d2                	xor    %edx,%edx
801005c4:	8d 7b 01             	lea    0x1(%ebx),%edi
801005c7:	f7 75 d4             	divl   -0x2c(%ebp)
801005ca:	0f b6 92 70 70 10 80 	movzbl -0x7fef8f90(%edx),%edx
801005d1:	88 54 3d d7          	mov    %dl,-0x29(%ebp,%edi,1)
  }while((x /= base) != 0);
801005d5:	39 4d d4             	cmp    %ecx,-0x2c(%ebp)
801005d8:	76 e2                	jbe    801005bc <printint+0x1c>
  if(sign)
801005da:	85 f6                	test   %esi,%esi
801005dc:	75 32                	jne    80100610 <printint+0x70>
801005de:	0f be c2             	movsbl %dl,%eax
801005e1:	89 df                	mov    %ebx,%edi
  if(panicked){
801005e3:	8b 0d 58 a5 10 80    	mov    0x8010a558,%ecx
801005e9:	85 c9                	test   %ecx,%ecx
801005eb:	75 20                	jne    8010060d <printint+0x6d>
801005ed:	8d 5c 3d d7          	lea    -0x29(%ebp,%edi,1),%ebx
801005f1:	e8 1a fe ff ff       	call   80100410 <consputc.part.0>
  while(--i >= 0)
801005f6:	8d 45 d7             	lea    -0x29(%ebp),%eax
801005f9:	39 d8                	cmp    %ebx,%eax
801005fb:	74 27                	je     80100624 <printint+0x84>
  if(panicked){
801005fd:	8b 15 58 a5 10 80    	mov    0x8010a558,%edx
    consputc(buf[i]);
80100603:	0f be 03             	movsbl (%ebx),%eax
  if(panicked){
80100606:	83 eb 01             	sub    $0x1,%ebx
80100609:	85 d2                	test   %edx,%edx
8010060b:	74 e4                	je     801005f1 <printint+0x51>
  asm volatile("cli");
8010060d:	fa                   	cli    
    for(;;)
8010060e:	eb fe                	jmp    8010060e <printint+0x6e>
    buf[i++] = '-';
80100610:	c6 44 3d d8 2d       	movb   $0x2d,-0x28(%ebp,%edi,1)
80100615:	b8 2d 00 00 00       	mov    $0x2d,%eax
8010061a:	eb c7                	jmp    801005e3 <printint+0x43>
    x = -xx;
8010061c:	f7 d8                	neg    %eax
8010061e:	89 ce                	mov    %ecx,%esi
80100620:	89 c1                	mov    %eax,%ecx
80100622:	eb 94                	jmp    801005b8 <printint+0x18>
}
80100624:	83 c4 2c             	add    $0x2c,%esp
80100627:	5b                   	pop    %ebx
80100628:	5e                   	pop    %esi
80100629:	5f                   	pop    %edi
8010062a:	5d                   	pop    %ebp
8010062b:	c3                   	ret    
8010062c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100630 <consolewrite>:

int
consolewrite(struct inode *ip, char *buf, int n)
{
80100630:	55                   	push   %ebp
80100631:	89 e5                	mov    %esp,%ebp
80100633:	57                   	push   %edi
80100634:	56                   	push   %esi
80100635:	53                   	push   %ebx
80100636:	83 ec 18             	sub    $0x18,%esp
80100639:	8b 7d 10             	mov    0x10(%ebp),%edi
8010063c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  int i;

  iunlock(ip);
8010063f:	ff 75 08             	pushl  0x8(%ebp)
80100642:	e8 b9 11 00 00       	call   80101800 <iunlock>
  acquire(&cons.lock);
80100647:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
8010064e:	e8 8d 3e 00 00       	call   801044e0 <acquire>
  for(i = 0; i < n; i++)
80100653:	83 c4 10             	add    $0x10,%esp
80100656:	85 ff                	test   %edi,%edi
80100658:	7e 36                	jle    80100690 <consolewrite+0x60>
  if(panicked){
8010065a:	8b 0d 58 a5 10 80    	mov    0x8010a558,%ecx
80100660:	85 c9                	test   %ecx,%ecx
80100662:	75 21                	jne    80100685 <consolewrite+0x55>
    consputc(buf[i] & 0xff);
80100664:	0f b6 03             	movzbl (%ebx),%eax
80100667:	8d 73 01             	lea    0x1(%ebx),%esi
8010066a:	01 fb                	add    %edi,%ebx
8010066c:	e8 9f fd ff ff       	call   80100410 <consputc.part.0>
  for(i = 0; i < n; i++)
80100671:	39 de                	cmp    %ebx,%esi
80100673:	74 1b                	je     80100690 <consolewrite+0x60>
  if(panicked){
80100675:	8b 15 58 a5 10 80    	mov    0x8010a558,%edx
    consputc(buf[i] & 0xff);
8010067b:	0f b6 06             	movzbl (%esi),%eax
  if(panicked){
8010067e:	83 c6 01             	add    $0x1,%esi
80100681:	85 d2                	test   %edx,%edx
80100683:	74 e7                	je     8010066c <consolewrite+0x3c>
80100685:	fa                   	cli    
    for(;;)
80100686:	eb fe                	jmp    80100686 <consolewrite+0x56>
80100688:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010068f:	90                   	nop
  release(&cons.lock);
80100690:	83 ec 0c             	sub    $0xc,%esp
80100693:	68 20 a5 10 80       	push   $0x8010a520
80100698:	e8 03 3f 00 00       	call   801045a0 <release>
  ilock(ip);
8010069d:	58                   	pop    %eax
8010069e:	ff 75 08             	pushl  0x8(%ebp)
801006a1:	e8 7a 10 00 00       	call   80101720 <ilock>

  return n;
}
801006a6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801006a9:	89 f8                	mov    %edi,%eax
801006ab:	5b                   	pop    %ebx
801006ac:	5e                   	pop    %esi
801006ad:	5f                   	pop    %edi
801006ae:	5d                   	pop    %ebp
801006af:	c3                   	ret    

801006b0 <cprintf>:
{
801006b0:	55                   	push   %ebp
801006b1:	89 e5                	mov    %esp,%ebp
801006b3:	57                   	push   %edi
801006b4:	56                   	push   %esi
801006b5:	53                   	push   %ebx
801006b6:	83 ec 1c             	sub    $0x1c,%esp
  locking = cons.locking;
801006b9:	a1 54 a5 10 80       	mov    0x8010a554,%eax
801006be:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if(locking)
801006c1:	85 c0                	test   %eax,%eax
801006c3:	0f 85 df 00 00 00    	jne    801007a8 <cprintf+0xf8>
  if (fmt == 0)
801006c9:	8b 45 08             	mov    0x8(%ebp),%eax
801006cc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801006cf:	85 c0                	test   %eax,%eax
801006d1:	0f 84 5e 01 00 00    	je     80100835 <cprintf+0x185>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006d7:	0f b6 00             	movzbl (%eax),%eax
801006da:	85 c0                	test   %eax,%eax
801006dc:	74 32                	je     80100710 <cprintf+0x60>
  argp = (uint*)(void*)(&fmt + 1);
801006de:	8d 5d 0c             	lea    0xc(%ebp),%ebx
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006e1:	31 f6                	xor    %esi,%esi
    if(c != '%'){
801006e3:	83 f8 25             	cmp    $0x25,%eax
801006e6:	74 40                	je     80100728 <cprintf+0x78>
  if(panicked){
801006e8:	8b 0d 58 a5 10 80    	mov    0x8010a558,%ecx
801006ee:	85 c9                	test   %ecx,%ecx
801006f0:	74 0b                	je     801006fd <cprintf+0x4d>
801006f2:	fa                   	cli    
    for(;;)
801006f3:	eb fe                	jmp    801006f3 <cprintf+0x43>
801006f5:	8d 76 00             	lea    0x0(%esi),%esi
801006f8:	b8 25 00 00 00       	mov    $0x25,%eax
801006fd:	e8 0e fd ff ff       	call   80100410 <consputc.part.0>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100702:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100705:	83 c6 01             	add    $0x1,%esi
80100708:	0f b6 04 30          	movzbl (%eax,%esi,1),%eax
8010070c:	85 c0                	test   %eax,%eax
8010070e:	75 d3                	jne    801006e3 <cprintf+0x33>
  if(locking)
80100710:	8b 5d e0             	mov    -0x20(%ebp),%ebx
80100713:	85 db                	test   %ebx,%ebx
80100715:	0f 85 05 01 00 00    	jne    80100820 <cprintf+0x170>
}
8010071b:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010071e:	5b                   	pop    %ebx
8010071f:	5e                   	pop    %esi
80100720:	5f                   	pop    %edi
80100721:	5d                   	pop    %ebp
80100722:	c3                   	ret    
80100723:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100727:	90                   	nop
    c = fmt[++i] & 0xff;
80100728:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010072b:	83 c6 01             	add    $0x1,%esi
8010072e:	0f b6 3c 30          	movzbl (%eax,%esi,1),%edi
    if(c == 0)
80100732:	85 ff                	test   %edi,%edi
80100734:	74 da                	je     80100710 <cprintf+0x60>
    switch(c){
80100736:	83 ff 70             	cmp    $0x70,%edi
80100739:	0f 84 7e 00 00 00    	je     801007bd <cprintf+0x10d>
8010073f:	7f 26                	jg     80100767 <cprintf+0xb7>
80100741:	83 ff 25             	cmp    $0x25,%edi
80100744:	0f 84 be 00 00 00    	je     80100808 <cprintf+0x158>
8010074a:	83 ff 64             	cmp    $0x64,%edi
8010074d:	75 46                	jne    80100795 <cprintf+0xe5>
      printint(*argp++, 10, 1);
8010074f:	8b 03                	mov    (%ebx),%eax
80100751:	8d 7b 04             	lea    0x4(%ebx),%edi
80100754:	b9 01 00 00 00       	mov    $0x1,%ecx
80100759:	ba 0a 00 00 00       	mov    $0xa,%edx
8010075e:	89 fb                	mov    %edi,%ebx
80100760:	e8 3b fe ff ff       	call   801005a0 <printint>
      break;
80100765:	eb 9b                	jmp    80100702 <cprintf+0x52>
    switch(c){
80100767:	83 ff 73             	cmp    $0x73,%edi
8010076a:	75 24                	jne    80100790 <cprintf+0xe0>
      if((s = (char*)*argp++) == 0)
8010076c:	8d 7b 04             	lea    0x4(%ebx),%edi
8010076f:	8b 1b                	mov    (%ebx),%ebx
80100771:	85 db                	test   %ebx,%ebx
80100773:	75 68                	jne    801007dd <cprintf+0x12d>
80100775:	b8 28 00 00 00       	mov    $0x28,%eax
        s = "(null)";
8010077a:	bb 58 70 10 80       	mov    $0x80107058,%ebx
  if(panicked){
8010077f:	8b 15 58 a5 10 80    	mov    0x8010a558,%edx
80100785:	85 d2                	test   %edx,%edx
80100787:	74 4c                	je     801007d5 <cprintf+0x125>
80100789:	fa                   	cli    
    for(;;)
8010078a:	eb fe                	jmp    8010078a <cprintf+0xda>
8010078c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    switch(c){
80100790:	83 ff 78             	cmp    $0x78,%edi
80100793:	74 28                	je     801007bd <cprintf+0x10d>
  if(panicked){
80100795:	8b 15 58 a5 10 80    	mov    0x8010a558,%edx
8010079b:	85 d2                	test   %edx,%edx
8010079d:	74 4c                	je     801007eb <cprintf+0x13b>
8010079f:	fa                   	cli    
    for(;;)
801007a0:	eb fe                	jmp    801007a0 <cprintf+0xf0>
801007a2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    acquire(&cons.lock);
801007a8:	83 ec 0c             	sub    $0xc,%esp
801007ab:	68 20 a5 10 80       	push   $0x8010a520
801007b0:	e8 2b 3d 00 00       	call   801044e0 <acquire>
801007b5:	83 c4 10             	add    $0x10,%esp
801007b8:	e9 0c ff ff ff       	jmp    801006c9 <cprintf+0x19>
      printint(*argp++, 16, 0);
801007bd:	8b 03                	mov    (%ebx),%eax
801007bf:	8d 7b 04             	lea    0x4(%ebx),%edi
801007c2:	31 c9                	xor    %ecx,%ecx
801007c4:	ba 10 00 00 00       	mov    $0x10,%edx
801007c9:	89 fb                	mov    %edi,%ebx
801007cb:	e8 d0 fd ff ff       	call   801005a0 <printint>
      break;
801007d0:	e9 2d ff ff ff       	jmp    80100702 <cprintf+0x52>
801007d5:	e8 36 fc ff ff       	call   80100410 <consputc.part.0>
      for(; *s; s++)
801007da:	83 c3 01             	add    $0x1,%ebx
801007dd:	0f be 03             	movsbl (%ebx),%eax
801007e0:	84 c0                	test   %al,%al
801007e2:	75 9b                	jne    8010077f <cprintf+0xcf>
      if((s = (char*)*argp++) == 0)
801007e4:	89 fb                	mov    %edi,%ebx
801007e6:	e9 17 ff ff ff       	jmp    80100702 <cprintf+0x52>
801007eb:	b8 25 00 00 00       	mov    $0x25,%eax
801007f0:	e8 1b fc ff ff       	call   80100410 <consputc.part.0>
  if(panicked){
801007f5:	a1 58 a5 10 80       	mov    0x8010a558,%eax
801007fa:	85 c0                	test   %eax,%eax
801007fc:	74 4a                	je     80100848 <cprintf+0x198>
801007fe:	fa                   	cli    
    for(;;)
801007ff:	eb fe                	jmp    801007ff <cprintf+0x14f>
80100801:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(panicked){
80100808:	8b 0d 58 a5 10 80    	mov    0x8010a558,%ecx
8010080e:	85 c9                	test   %ecx,%ecx
80100810:	0f 84 e2 fe ff ff    	je     801006f8 <cprintf+0x48>
80100816:	fa                   	cli    
    for(;;)
80100817:	eb fe                	jmp    80100817 <cprintf+0x167>
80100819:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    release(&cons.lock);
80100820:	83 ec 0c             	sub    $0xc,%esp
80100823:	68 20 a5 10 80       	push   $0x8010a520
80100828:	e8 73 3d 00 00       	call   801045a0 <release>
8010082d:	83 c4 10             	add    $0x10,%esp
}
80100830:	e9 e6 fe ff ff       	jmp    8010071b <cprintf+0x6b>
    panic("null fmt");
80100835:	83 ec 0c             	sub    $0xc,%esp
80100838:	68 5f 70 10 80       	push   $0x8010705f
8010083d:	e8 4e fb ff ff       	call   80100390 <panic>
80100842:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80100848:	89 f8                	mov    %edi,%eax
8010084a:	e8 c1 fb ff ff       	call   80100410 <consputc.part.0>
8010084f:	e9 ae fe ff ff       	jmp    80100702 <cprintf+0x52>
80100854:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010085b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010085f:	90                   	nop

80100860 <consoleintr>:
{
80100860:	55                   	push   %ebp
80100861:	89 e5                	mov    %esp,%ebp
80100863:	57                   	push   %edi
80100864:	56                   	push   %esi
  int c, doprocdump = 0;
80100865:	31 f6                	xor    %esi,%esi
{
80100867:	53                   	push   %ebx
80100868:	83 ec 18             	sub    $0x18,%esp
8010086b:	8b 7d 08             	mov    0x8(%ebp),%edi
  acquire(&cons.lock);
8010086e:	68 20 a5 10 80       	push   $0x8010a520
80100873:	e8 68 3c 00 00       	call   801044e0 <acquire>
  while((c = getc()) >= 0){
80100878:	83 c4 10             	add    $0x10,%esp
8010087b:	ff d7                	call   *%edi
8010087d:	89 c3                	mov    %eax,%ebx
8010087f:	85 c0                	test   %eax,%eax
80100881:	0f 88 38 01 00 00    	js     801009bf <consoleintr+0x15f>
    switch(c){
80100887:	83 fb 10             	cmp    $0x10,%ebx
8010088a:	0f 84 f0 00 00 00    	je     80100980 <consoleintr+0x120>
80100890:	0f 8e ba 00 00 00    	jle    80100950 <consoleintr+0xf0>
80100896:	83 fb 15             	cmp    $0x15,%ebx
80100899:	75 35                	jne    801008d0 <consoleintr+0x70>
      while(input.e != input.w &&
8010089b:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
801008a0:	39 05 a4 ff 10 80    	cmp    %eax,0x8010ffa4
801008a6:	74 d3                	je     8010087b <consoleintr+0x1b>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
801008a8:	83 e8 01             	sub    $0x1,%eax
801008ab:	89 c2                	mov    %eax,%edx
801008ad:	83 e2 7f             	and    $0x7f,%edx
      while(input.e != input.w &&
801008b0:	80 ba 20 ff 10 80 0a 	cmpb   $0xa,-0x7fef00e0(%edx)
801008b7:	74 c2                	je     8010087b <consoleintr+0x1b>
  if(panicked){
801008b9:	8b 15 58 a5 10 80    	mov    0x8010a558,%edx
        input.e--;
801008bf:	a3 a8 ff 10 80       	mov    %eax,0x8010ffa8
  if(panicked){
801008c4:	85 d2                	test   %edx,%edx
801008c6:	0f 84 be 00 00 00    	je     8010098a <consoleintr+0x12a>
801008cc:	fa                   	cli    
    for(;;)
801008cd:	eb fe                	jmp    801008cd <consoleintr+0x6d>
801008cf:	90                   	nop
    switch(c){
801008d0:	83 fb 7f             	cmp    $0x7f,%ebx
801008d3:	0f 84 7c 00 00 00    	je     80100955 <consoleintr+0xf5>
      if(c != 0 && input.e-input.r < INPUT_BUF){
801008d9:	85 db                	test   %ebx,%ebx
801008db:	74 9e                	je     8010087b <consoleintr+0x1b>
801008dd:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
801008e2:	89 c2                	mov    %eax,%edx
801008e4:	2b 15 a0 ff 10 80    	sub    0x8010ffa0,%edx
801008ea:	83 fa 7f             	cmp    $0x7f,%edx
801008ed:	77 8c                	ja     8010087b <consoleintr+0x1b>
        c = (c == '\r') ? '\n' : c;
801008ef:	8d 48 01             	lea    0x1(%eax),%ecx
801008f2:	8b 15 58 a5 10 80    	mov    0x8010a558,%edx
801008f8:	83 e0 7f             	and    $0x7f,%eax
        input.buf[input.e++ % INPUT_BUF] = c;
801008fb:	89 0d a8 ff 10 80    	mov    %ecx,0x8010ffa8
        c = (c == '\r') ? '\n' : c;
80100901:	83 fb 0d             	cmp    $0xd,%ebx
80100904:	0f 84 d1 00 00 00    	je     801009db <consoleintr+0x17b>
        input.buf[input.e++ % INPUT_BUF] = c;
8010090a:	88 98 20 ff 10 80    	mov    %bl,-0x7fef00e0(%eax)
  if(panicked){
80100910:	85 d2                	test   %edx,%edx
80100912:	0f 85 ce 00 00 00    	jne    801009e6 <consoleintr+0x186>
80100918:	89 d8                	mov    %ebx,%eax
8010091a:	e8 f1 fa ff ff       	call   80100410 <consputc.part.0>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
8010091f:	83 fb 0a             	cmp    $0xa,%ebx
80100922:	0f 84 d2 00 00 00    	je     801009fa <consoleintr+0x19a>
80100928:	83 fb 04             	cmp    $0x4,%ebx
8010092b:	0f 84 c9 00 00 00    	je     801009fa <consoleintr+0x19a>
80100931:	a1 a0 ff 10 80       	mov    0x8010ffa0,%eax
80100936:	83 e8 80             	sub    $0xffffff80,%eax
80100939:	39 05 a8 ff 10 80    	cmp    %eax,0x8010ffa8
8010093f:	0f 85 36 ff ff ff    	jne    8010087b <consoleintr+0x1b>
80100945:	e9 b5 00 00 00       	jmp    801009ff <consoleintr+0x19f>
8010094a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    switch(c){
80100950:	83 fb 08             	cmp    $0x8,%ebx
80100953:	75 84                	jne    801008d9 <consoleintr+0x79>
      if(input.e != input.w){
80100955:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
8010095a:	3b 05 a4 ff 10 80    	cmp    0x8010ffa4,%eax
80100960:	0f 84 15 ff ff ff    	je     8010087b <consoleintr+0x1b>
        input.e--;
80100966:	83 e8 01             	sub    $0x1,%eax
80100969:	a3 a8 ff 10 80       	mov    %eax,0x8010ffa8
  if(panicked){
8010096e:	a1 58 a5 10 80       	mov    0x8010a558,%eax
80100973:	85 c0                	test   %eax,%eax
80100975:	74 39                	je     801009b0 <consoleintr+0x150>
80100977:	fa                   	cli    
    for(;;)
80100978:	eb fe                	jmp    80100978 <consoleintr+0x118>
8010097a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      doprocdump = 1;
80100980:	be 01 00 00 00       	mov    $0x1,%esi
80100985:	e9 f1 fe ff ff       	jmp    8010087b <consoleintr+0x1b>
8010098a:	b8 00 01 00 00       	mov    $0x100,%eax
8010098f:	e8 7c fa ff ff       	call   80100410 <consputc.part.0>
      while(input.e != input.w &&
80100994:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
80100999:	3b 05 a4 ff 10 80    	cmp    0x8010ffa4,%eax
8010099f:	0f 85 03 ff ff ff    	jne    801008a8 <consoleintr+0x48>
801009a5:	e9 d1 fe ff ff       	jmp    8010087b <consoleintr+0x1b>
801009aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801009b0:	b8 00 01 00 00       	mov    $0x100,%eax
801009b5:	e8 56 fa ff ff       	call   80100410 <consputc.part.0>
801009ba:	e9 bc fe ff ff       	jmp    8010087b <consoleintr+0x1b>
  release(&cons.lock);
801009bf:	83 ec 0c             	sub    $0xc,%esp
801009c2:	68 20 a5 10 80       	push   $0x8010a520
801009c7:	e8 d4 3b 00 00       	call   801045a0 <release>
  if(doprocdump) {
801009cc:	83 c4 10             	add    $0x10,%esp
801009cf:	85 f6                	test   %esi,%esi
801009d1:	75 46                	jne    80100a19 <consoleintr+0x1b9>
}
801009d3:	8d 65 f4             	lea    -0xc(%ebp),%esp
801009d6:	5b                   	pop    %ebx
801009d7:	5e                   	pop    %esi
801009d8:	5f                   	pop    %edi
801009d9:	5d                   	pop    %ebp
801009da:	c3                   	ret    
        input.buf[input.e++ % INPUT_BUF] = c;
801009db:	c6 80 20 ff 10 80 0a 	movb   $0xa,-0x7fef00e0(%eax)
  if(panicked){
801009e2:	85 d2                	test   %edx,%edx
801009e4:	74 0a                	je     801009f0 <consoleintr+0x190>
801009e6:	fa                   	cli    
    for(;;)
801009e7:	eb fe                	jmp    801009e7 <consoleintr+0x187>
801009e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801009f0:	b8 0a 00 00 00       	mov    $0xa,%eax
801009f5:	e8 16 fa ff ff       	call   80100410 <consputc.part.0>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
801009fa:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
          wakeup(&input.r);
801009ff:	83 ec 0c             	sub    $0xc,%esp
          input.w = input.e;
80100a02:	a3 a4 ff 10 80       	mov    %eax,0x8010ffa4
          wakeup(&input.r);
80100a07:	68 a0 ff 10 80       	push   $0x8010ffa0
80100a0c:	e8 9f 36 00 00       	call   801040b0 <wakeup>
80100a11:	83 c4 10             	add    $0x10,%esp
80100a14:	e9 62 fe ff ff       	jmp    8010087b <consoleintr+0x1b>
}
80100a19:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100a1c:	5b                   	pop    %ebx
80100a1d:	5e                   	pop    %esi
80100a1e:	5f                   	pop    %edi
80100a1f:	5d                   	pop    %ebp
    procdump();  // now call procdump() wo. cons.lock held
80100a20:	e9 6b 37 00 00       	jmp    80104190 <procdump>
80100a25:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100a2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100a30 <consoleinit>:

void
consoleinit(void)
{
80100a30:	55                   	push   %ebp
80100a31:	89 e5                	mov    %esp,%ebp
80100a33:	83 ec 10             	sub    $0x10,%esp
  initlock(&cons.lock, "console");
80100a36:	68 68 70 10 80       	push   $0x80107068
80100a3b:	68 20 a5 10 80       	push   $0x8010a520
80100a40:	e8 3b 39 00 00       	call   80104380 <initlock>

  devsw[CONSOLE].write = consolewrite;
  devsw[CONSOLE].read = consoleread;
  cons.locking = 1;

  ioapicenable(IRQ_KBD, 0);
80100a45:	58                   	pop    %eax
80100a46:	5a                   	pop    %edx
80100a47:	6a 00                	push   $0x0
80100a49:	6a 01                	push   $0x1
  devsw[CONSOLE].write = consolewrite;
80100a4b:	c7 05 6c 09 11 80 30 	movl   $0x80100630,0x8011096c
80100a52:	06 10 80 
  devsw[CONSOLE].read = consoleread;
80100a55:	c7 05 68 09 11 80 80 	movl   $0x80100280,0x80110968
80100a5c:	02 10 80 
  cons.locking = 1;
80100a5f:	c7 05 54 a5 10 80 01 	movl   $0x1,0x8010a554
80100a66:	00 00 00 
  ioapicenable(IRQ_KBD, 0);
80100a69:	e8 42 19 00 00       	call   801023b0 <ioapicenable>
}
80100a6e:	83 c4 10             	add    $0x10,%esp
80100a71:	c9                   	leave  
80100a72:	c3                   	ret    
80100a73:	66 90                	xchg   %ax,%ax
80100a75:	66 90                	xchg   %ax,%ax
80100a77:	66 90                	xchg   %ax,%ax
80100a79:	66 90                	xchg   %ax,%ax
80100a7b:	66 90                	xchg   %ax,%ax
80100a7d:	66 90                	xchg   %ax,%ax
80100a7f:	90                   	nop

80100a80 <exec>:
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
{
80100a80:	55                   	push   %ebp
80100a81:	89 e5                	mov    %esp,%ebp
80100a83:	57                   	push   %edi
80100a84:	56                   	push   %esi
80100a85:	53                   	push   %ebx
80100a86:	81 ec 0c 01 00 00    	sub    $0x10c,%esp
  uint argc, sz, sp, ustack[3+MAXARG+1];
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;
  struct proc *curproc = myproc();
80100a8c:	e8 cf 2e 00 00       	call   80103960 <myproc>
80100a91:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)

  begin_op();
80100a97:	e8 84 22 00 00       	call   80102d20 <begin_op>

  if((ip = namei(path)) == 0){
80100a9c:	83 ec 0c             	sub    $0xc,%esp
80100a9f:	ff 75 08             	pushl  0x8(%ebp)
80100aa2:	e8 19 15 00 00       	call   80101fc0 <namei>
80100aa7:	83 c4 10             	add    $0x10,%esp
80100aaa:	85 c0                	test   %eax,%eax
80100aac:	0f 84 02 03 00 00    	je     80100db4 <exec+0x334>
    end_op();
    cprintf("exec: fail\n");
    return -1;
  }
  ilock(ip);
80100ab2:	83 ec 0c             	sub    $0xc,%esp
80100ab5:	89 c3                	mov    %eax,%ebx
80100ab7:	50                   	push   %eax
80100ab8:	e8 63 0c 00 00       	call   80101720 <ilock>
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
80100abd:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
80100ac3:	6a 34                	push   $0x34
80100ac5:	6a 00                	push   $0x0
80100ac7:	50                   	push   %eax
80100ac8:	53                   	push   %ebx
80100ac9:	e8 32 0f 00 00       	call   80101a00 <readi>
80100ace:	83 c4 20             	add    $0x20,%esp
80100ad1:	83 f8 34             	cmp    $0x34,%eax
80100ad4:	74 22                	je     80100af8 <exec+0x78>

 bad:
  if(pgdir)
    freevm(pgdir);
  if(ip){
    iunlockput(ip);
80100ad6:	83 ec 0c             	sub    $0xc,%esp
80100ad9:	53                   	push   %ebx
80100ada:	e8 d1 0e 00 00       	call   801019b0 <iunlockput>
    end_op();
80100adf:	e8 ac 22 00 00       	call   80102d90 <end_op>
80100ae4:	83 c4 10             	add    $0x10,%esp
  }
  return -1;
80100ae7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100aec:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100aef:	5b                   	pop    %ebx
80100af0:	5e                   	pop    %esi
80100af1:	5f                   	pop    %edi
80100af2:	5d                   	pop    %ebp
80100af3:	c3                   	ret    
80100af4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(elf.magic != ELF_MAGIC)
80100af8:	81 bd 24 ff ff ff 7f 	cmpl   $0x464c457f,-0xdc(%ebp)
80100aff:	45 4c 46 
80100b02:	75 d2                	jne    80100ad6 <exec+0x56>
  if((pgdir = setupkvm()) == 0)
80100b04:	e8 67 62 00 00       	call   80106d70 <setupkvm>
80100b09:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)
80100b0f:	85 c0                	test   %eax,%eax
80100b11:	74 c3                	je     80100ad6 <exec+0x56>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100b13:	66 83 bd 50 ff ff ff 	cmpw   $0x0,-0xb0(%ebp)
80100b1a:	00 
80100b1b:	8b b5 40 ff ff ff    	mov    -0xc0(%ebp),%esi
80100b21:	0f 84 ac 02 00 00    	je     80100dd3 <exec+0x353>
  sz = 0;
80100b27:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
80100b2e:	00 00 00 
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100b31:	31 ff                	xor    %edi,%edi
80100b33:	e9 8e 00 00 00       	jmp    80100bc6 <exec+0x146>
80100b38:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100b3f:	90                   	nop
    if(ph.type != ELF_PROG_LOAD)
80100b40:	83 bd 04 ff ff ff 01 	cmpl   $0x1,-0xfc(%ebp)
80100b47:	75 6c                	jne    80100bb5 <exec+0x135>
    if(ph.memsz < ph.filesz)
80100b49:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
80100b4f:	3b 85 14 ff ff ff    	cmp    -0xec(%ebp),%eax
80100b55:	0f 82 87 00 00 00    	jb     80100be2 <exec+0x162>
    if(ph.vaddr + ph.memsz < ph.vaddr)
80100b5b:	03 85 0c ff ff ff    	add    -0xf4(%ebp),%eax
80100b61:	72 7f                	jb     80100be2 <exec+0x162>
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100b63:	83 ec 04             	sub    $0x4,%esp
80100b66:	50                   	push   %eax
80100b67:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100b6d:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100b73:	e8 18 60 00 00       	call   80106b90 <allocuvm>
80100b78:	83 c4 10             	add    $0x10,%esp
80100b7b:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80100b81:	85 c0                	test   %eax,%eax
80100b83:	74 5d                	je     80100be2 <exec+0x162>
    if(ph.vaddr % PGSIZE != 0)
80100b85:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
80100b8b:	a9 ff 0f 00 00       	test   $0xfff,%eax
80100b90:	75 50                	jne    80100be2 <exec+0x162>
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100b92:	83 ec 0c             	sub    $0xc,%esp
80100b95:	ff b5 14 ff ff ff    	pushl  -0xec(%ebp)
80100b9b:	ff b5 08 ff ff ff    	pushl  -0xf8(%ebp)
80100ba1:	53                   	push   %ebx
80100ba2:	50                   	push   %eax
80100ba3:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100ba9:	e8 22 5f 00 00       	call   80106ad0 <loaduvm>
80100bae:	83 c4 20             	add    $0x20,%esp
80100bb1:	85 c0                	test   %eax,%eax
80100bb3:	78 2d                	js     80100be2 <exec+0x162>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100bb5:	0f b7 85 50 ff ff ff 	movzwl -0xb0(%ebp),%eax
80100bbc:	83 c7 01             	add    $0x1,%edi
80100bbf:	83 c6 20             	add    $0x20,%esi
80100bc2:	39 f8                	cmp    %edi,%eax
80100bc4:	7e 3a                	jle    80100c00 <exec+0x180>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80100bc6:	8d 85 04 ff ff ff    	lea    -0xfc(%ebp),%eax
80100bcc:	6a 20                	push   $0x20
80100bce:	56                   	push   %esi
80100bcf:	50                   	push   %eax
80100bd0:	53                   	push   %ebx
80100bd1:	e8 2a 0e 00 00       	call   80101a00 <readi>
80100bd6:	83 c4 10             	add    $0x10,%esp
80100bd9:	83 f8 20             	cmp    $0x20,%eax
80100bdc:	0f 84 5e ff ff ff    	je     80100b40 <exec+0xc0>
    freevm(pgdir);
80100be2:	83 ec 0c             	sub    $0xc,%esp
80100be5:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100beb:	e8 00 61 00 00       	call   80106cf0 <freevm>
  if(ip){
80100bf0:	83 c4 10             	add    $0x10,%esp
80100bf3:	e9 de fe ff ff       	jmp    80100ad6 <exec+0x56>
80100bf8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100bff:	90                   	nop
80100c00:	8b bd f0 fe ff ff    	mov    -0x110(%ebp),%edi
80100c06:	81 c7 ff 0f 00 00    	add    $0xfff,%edi
80100c0c:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
80100c12:	8d b7 00 20 00 00    	lea    0x2000(%edi),%esi
  iunlockput(ip);
80100c18:	83 ec 0c             	sub    $0xc,%esp
80100c1b:	53                   	push   %ebx
80100c1c:	e8 8f 0d 00 00       	call   801019b0 <iunlockput>
  end_op();
80100c21:	e8 6a 21 00 00       	call   80102d90 <end_op>
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100c26:	83 c4 0c             	add    $0xc,%esp
80100c29:	56                   	push   %esi
80100c2a:	57                   	push   %edi
80100c2b:	8b bd f4 fe ff ff    	mov    -0x10c(%ebp),%edi
80100c31:	57                   	push   %edi
80100c32:	e8 59 5f 00 00       	call   80106b90 <allocuvm>
80100c37:	83 c4 10             	add    $0x10,%esp
80100c3a:	89 c6                	mov    %eax,%esi
80100c3c:	85 c0                	test   %eax,%eax
80100c3e:	0f 84 94 00 00 00    	je     80100cd8 <exec+0x258>
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100c44:	83 ec 08             	sub    $0x8,%esp
80100c47:	8d 80 00 e0 ff ff    	lea    -0x2000(%eax),%eax
  for(argc = 0; argv[argc]; argc++) {
80100c4d:	89 f3                	mov    %esi,%ebx
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100c4f:	50                   	push   %eax
80100c50:	57                   	push   %edi
  for(argc = 0; argv[argc]; argc++) {
80100c51:	31 ff                	xor    %edi,%edi
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100c53:	e8 b8 61 00 00       	call   80106e10 <clearpteu>
  for(argc = 0; argv[argc]; argc++) {
80100c58:	8b 45 0c             	mov    0xc(%ebp),%eax
80100c5b:	83 c4 10             	add    $0x10,%esp
80100c5e:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
80100c64:	8b 00                	mov    (%eax),%eax
80100c66:	85 c0                	test   %eax,%eax
80100c68:	0f 84 8b 00 00 00    	je     80100cf9 <exec+0x279>
80100c6e:	89 b5 f0 fe ff ff    	mov    %esi,-0x110(%ebp)
80100c74:	8b b5 f4 fe ff ff    	mov    -0x10c(%ebp),%esi
80100c7a:	eb 23                	jmp    80100c9f <exec+0x21f>
80100c7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100c80:	8b 45 0c             	mov    0xc(%ebp),%eax
    ustack[3+argc] = sp;
80100c83:	89 9c bd 64 ff ff ff 	mov    %ebx,-0x9c(%ebp,%edi,4)
  for(argc = 0; argv[argc]; argc++) {
80100c8a:	83 c7 01             	add    $0x1,%edi
    ustack[3+argc] = sp;
80100c8d:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
  for(argc = 0; argv[argc]; argc++) {
80100c93:	8b 04 b8             	mov    (%eax,%edi,4),%eax
80100c96:	85 c0                	test   %eax,%eax
80100c98:	74 59                	je     80100cf3 <exec+0x273>
    if(argc >= MAXARG)
80100c9a:	83 ff 20             	cmp    $0x20,%edi
80100c9d:	74 39                	je     80100cd8 <exec+0x258>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100c9f:	83 ec 0c             	sub    $0xc,%esp
80100ca2:	50                   	push   %eax
80100ca3:	e8 58 3b 00 00       	call   80104800 <strlen>
80100ca8:	f7 d0                	not    %eax
80100caa:	01 c3                	add    %eax,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100cac:	58                   	pop    %eax
80100cad:	8b 45 0c             	mov    0xc(%ebp),%eax
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100cb0:	83 e3 fc             	and    $0xfffffffc,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100cb3:	ff 34 b8             	pushl  (%eax,%edi,4)
80100cb6:	e8 45 3b 00 00       	call   80104800 <strlen>
80100cbb:	83 c0 01             	add    $0x1,%eax
80100cbe:	50                   	push   %eax
80100cbf:	8b 45 0c             	mov    0xc(%ebp),%eax
80100cc2:	ff 34 b8             	pushl  (%eax,%edi,4)
80100cc5:	53                   	push   %ebx
80100cc6:	56                   	push   %esi
80100cc7:	e8 a4 62 00 00       	call   80106f70 <copyout>
80100ccc:	83 c4 20             	add    $0x20,%esp
80100ccf:	85 c0                	test   %eax,%eax
80100cd1:	79 ad                	jns    80100c80 <exec+0x200>
80100cd3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100cd7:	90                   	nop
    freevm(pgdir);
80100cd8:	83 ec 0c             	sub    $0xc,%esp
80100cdb:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100ce1:	e8 0a 60 00 00       	call   80106cf0 <freevm>
80100ce6:	83 c4 10             	add    $0x10,%esp
  return -1;
80100ce9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100cee:	e9 f9 fd ff ff       	jmp    80100aec <exec+0x6c>
80100cf3:	8b b5 f0 fe ff ff    	mov    -0x110(%ebp),%esi
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100cf9:	8d 04 bd 04 00 00 00 	lea    0x4(,%edi,4),%eax
80100d00:	89 d9                	mov    %ebx,%ecx
  ustack[3+argc] = 0;
80100d02:	c7 84 bd 64 ff ff ff 	movl   $0x0,-0x9c(%ebp,%edi,4)
80100d09:	00 00 00 00 
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100d0d:	29 c1                	sub    %eax,%ecx
  sp -= (3+argc+1) * 4;
80100d0f:	83 c0 0c             	add    $0xc,%eax
  ustack[1] = argc;
80100d12:	89 bd 5c ff ff ff    	mov    %edi,-0xa4(%ebp)
  sp -= (3+argc+1) * 4;
80100d18:	29 c3                	sub    %eax,%ebx
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100d1a:	50                   	push   %eax
80100d1b:	52                   	push   %edx
80100d1c:	53                   	push   %ebx
80100d1d:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
  ustack[0] = 0xffffffff;  // fake return PC
80100d23:	c7 85 58 ff ff ff ff 	movl   $0xffffffff,-0xa8(%ebp)
80100d2a:	ff ff ff 
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100d2d:	89 8d 60 ff ff ff    	mov    %ecx,-0xa0(%ebp)
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100d33:	e8 38 62 00 00       	call   80106f70 <copyout>
80100d38:	83 c4 10             	add    $0x10,%esp
80100d3b:	85 c0                	test   %eax,%eax
80100d3d:	78 99                	js     80100cd8 <exec+0x258>
  for(last=s=path; *s; s++)
80100d3f:	8b 45 08             	mov    0x8(%ebp),%eax
80100d42:	8b 55 08             	mov    0x8(%ebp),%edx
80100d45:	0f b6 00             	movzbl (%eax),%eax
80100d48:	84 c0                	test   %al,%al
80100d4a:	74 13                	je     80100d5f <exec+0x2df>
80100d4c:	89 d1                	mov    %edx,%ecx
80100d4e:	66 90                	xchg   %ax,%ax
    if(*s == '/')
80100d50:	83 c1 01             	add    $0x1,%ecx
80100d53:	3c 2f                	cmp    $0x2f,%al
  for(last=s=path; *s; s++)
80100d55:	0f b6 01             	movzbl (%ecx),%eax
    if(*s == '/')
80100d58:	0f 44 d1             	cmove  %ecx,%edx
  for(last=s=path; *s; s++)
80100d5b:	84 c0                	test   %al,%al
80100d5d:	75 f1                	jne    80100d50 <exec+0x2d0>
  safestrcpy(curproc->name, last, sizeof(curproc->name));
80100d5f:	8b bd ec fe ff ff    	mov    -0x114(%ebp),%edi
80100d65:	83 ec 04             	sub    $0x4,%esp
80100d68:	6a 10                	push   $0x10
80100d6a:	89 f8                	mov    %edi,%eax
80100d6c:	52                   	push   %edx
80100d6d:	83 c0 6c             	add    $0x6c,%eax
80100d70:	50                   	push   %eax
80100d71:	e8 4a 3a 00 00       	call   801047c0 <safestrcpy>
  curproc->pgdir = pgdir;
80100d76:	8b 8d f4 fe ff ff    	mov    -0x10c(%ebp),%ecx
  oldpgdir = curproc->pgdir;
80100d7c:	89 f8                	mov    %edi,%eax
80100d7e:	8b 7f 04             	mov    0x4(%edi),%edi
  curproc->sz = sz;
80100d81:	89 30                	mov    %esi,(%eax)
  curproc->pgdir = pgdir;
80100d83:	89 48 04             	mov    %ecx,0x4(%eax)
  curproc->tf->eip = elf.entry;  // main
80100d86:	89 c1                	mov    %eax,%ecx
80100d88:	8b 95 3c ff ff ff    	mov    -0xc4(%ebp),%edx
80100d8e:	8b 40 18             	mov    0x18(%eax),%eax
80100d91:	89 50 38             	mov    %edx,0x38(%eax)
  curproc->tf->esp = sp;
80100d94:	8b 41 18             	mov    0x18(%ecx),%eax
80100d97:	89 58 44             	mov    %ebx,0x44(%eax)
  switchuvm(curproc);
80100d9a:	89 0c 24             	mov    %ecx,(%esp)
80100d9d:	e8 9e 5b 00 00       	call   80106940 <switchuvm>
  freevm(oldpgdir);
80100da2:	89 3c 24             	mov    %edi,(%esp)
80100da5:	e8 46 5f 00 00       	call   80106cf0 <freevm>
  return 0;
80100daa:	83 c4 10             	add    $0x10,%esp
80100dad:	31 c0                	xor    %eax,%eax
80100daf:	e9 38 fd ff ff       	jmp    80100aec <exec+0x6c>
    end_op();
80100db4:	e8 d7 1f 00 00       	call   80102d90 <end_op>
    cprintf("exec: fail\n");
80100db9:	83 ec 0c             	sub    $0xc,%esp
80100dbc:	68 81 70 10 80       	push   $0x80107081
80100dc1:	e8 ea f8 ff ff       	call   801006b0 <cprintf>
    return -1;
80100dc6:	83 c4 10             	add    $0x10,%esp
80100dc9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100dce:	e9 19 fd ff ff       	jmp    80100aec <exec+0x6c>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100dd3:	31 ff                	xor    %edi,%edi
80100dd5:	be 00 20 00 00       	mov    $0x2000,%esi
80100dda:	e9 39 fe ff ff       	jmp    80100c18 <exec+0x198>
80100ddf:	90                   	nop

80100de0 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80100de0:	55                   	push   %ebp
80100de1:	89 e5                	mov    %esp,%ebp
80100de3:	83 ec 10             	sub    $0x10,%esp
  initlock(&ftable.lock, "ftable");
80100de6:	68 8d 70 10 80       	push   $0x8010708d
80100deb:	68 c0 ff 10 80       	push   $0x8010ffc0
80100df0:	e8 8b 35 00 00       	call   80104380 <initlock>
}
80100df5:	83 c4 10             	add    $0x10,%esp
80100df8:	c9                   	leave  
80100df9:	c3                   	ret    
80100dfa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100e00 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80100e00:	55                   	push   %ebp
80100e01:	89 e5                	mov    %esp,%ebp
80100e03:	53                   	push   %ebx
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100e04:	bb f4 ff 10 80       	mov    $0x8010fff4,%ebx
{
80100e09:	83 ec 10             	sub    $0x10,%esp
  acquire(&ftable.lock);
80100e0c:	68 c0 ff 10 80       	push   $0x8010ffc0
80100e11:	e8 ca 36 00 00       	call   801044e0 <acquire>
80100e16:	83 c4 10             	add    $0x10,%esp
80100e19:	eb 10                	jmp    80100e2b <filealloc+0x2b>
80100e1b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100e1f:	90                   	nop
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100e20:	83 c3 18             	add    $0x18,%ebx
80100e23:	81 fb 54 09 11 80    	cmp    $0x80110954,%ebx
80100e29:	74 25                	je     80100e50 <filealloc+0x50>
    if(f->ref == 0){
80100e2b:	8b 43 04             	mov    0x4(%ebx),%eax
80100e2e:	85 c0                	test   %eax,%eax
80100e30:	75 ee                	jne    80100e20 <filealloc+0x20>
      f->ref = 1;
      release(&ftable.lock);
80100e32:	83 ec 0c             	sub    $0xc,%esp
      f->ref = 1;
80100e35:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
      release(&ftable.lock);
80100e3c:	68 c0 ff 10 80       	push   $0x8010ffc0
80100e41:	e8 5a 37 00 00       	call   801045a0 <release>
      return f;
    }
  }
  release(&ftable.lock);
  return 0;
}
80100e46:	89 d8                	mov    %ebx,%eax
      return f;
80100e48:	83 c4 10             	add    $0x10,%esp
}
80100e4b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100e4e:	c9                   	leave  
80100e4f:	c3                   	ret    
  release(&ftable.lock);
80100e50:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80100e53:	31 db                	xor    %ebx,%ebx
  release(&ftable.lock);
80100e55:	68 c0 ff 10 80       	push   $0x8010ffc0
80100e5a:	e8 41 37 00 00       	call   801045a0 <release>
}
80100e5f:	89 d8                	mov    %ebx,%eax
  return 0;
80100e61:	83 c4 10             	add    $0x10,%esp
}
80100e64:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100e67:	c9                   	leave  
80100e68:	c3                   	ret    
80100e69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100e70 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80100e70:	55                   	push   %ebp
80100e71:	89 e5                	mov    %esp,%ebp
80100e73:	53                   	push   %ebx
80100e74:	83 ec 10             	sub    $0x10,%esp
80100e77:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ftable.lock);
80100e7a:	68 c0 ff 10 80       	push   $0x8010ffc0
80100e7f:	e8 5c 36 00 00       	call   801044e0 <acquire>
  if(f->ref < 1)
80100e84:	8b 43 04             	mov    0x4(%ebx),%eax
80100e87:	83 c4 10             	add    $0x10,%esp
80100e8a:	85 c0                	test   %eax,%eax
80100e8c:	7e 1a                	jle    80100ea8 <filedup+0x38>
    panic("filedup");
  f->ref++;
80100e8e:	83 c0 01             	add    $0x1,%eax
  release(&ftable.lock);
80100e91:	83 ec 0c             	sub    $0xc,%esp
  f->ref++;
80100e94:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&ftable.lock);
80100e97:	68 c0 ff 10 80       	push   $0x8010ffc0
80100e9c:	e8 ff 36 00 00       	call   801045a0 <release>
  return f;
}
80100ea1:	89 d8                	mov    %ebx,%eax
80100ea3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100ea6:	c9                   	leave  
80100ea7:	c3                   	ret    
    panic("filedup");
80100ea8:	83 ec 0c             	sub    $0xc,%esp
80100eab:	68 94 70 10 80       	push   $0x80107094
80100eb0:	e8 db f4 ff ff       	call   80100390 <panic>
80100eb5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100ebc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100ec0 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80100ec0:	55                   	push   %ebp
80100ec1:	89 e5                	mov    %esp,%ebp
80100ec3:	57                   	push   %edi
80100ec4:	56                   	push   %esi
80100ec5:	53                   	push   %ebx
80100ec6:	83 ec 28             	sub    $0x28,%esp
80100ec9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct file ff;

  acquire(&ftable.lock);
80100ecc:	68 c0 ff 10 80       	push   $0x8010ffc0
80100ed1:	e8 0a 36 00 00       	call   801044e0 <acquire>
  if(f->ref < 1)
80100ed6:	8b 43 04             	mov    0x4(%ebx),%eax
80100ed9:	83 c4 10             	add    $0x10,%esp
80100edc:	85 c0                	test   %eax,%eax
80100ede:	0f 8e a3 00 00 00    	jle    80100f87 <fileclose+0xc7>
    panic("fileclose");
  if(--f->ref > 0){
80100ee4:	83 e8 01             	sub    $0x1,%eax
80100ee7:	89 43 04             	mov    %eax,0x4(%ebx)
80100eea:	75 44                	jne    80100f30 <fileclose+0x70>
    release(&ftable.lock);
    return;
  }
  ff = *f;
80100eec:	0f b6 43 09          	movzbl 0x9(%ebx),%eax
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);
80100ef0:	83 ec 0c             	sub    $0xc,%esp
  ff = *f;
80100ef3:	8b 3b                	mov    (%ebx),%edi
  f->type = FD_NONE;
80100ef5:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  ff = *f;
80100efb:	8b 73 0c             	mov    0xc(%ebx),%esi
80100efe:	88 45 e7             	mov    %al,-0x19(%ebp)
80100f01:	8b 43 10             	mov    0x10(%ebx),%eax
  release(&ftable.lock);
80100f04:	68 c0 ff 10 80       	push   $0x8010ffc0
  ff = *f;
80100f09:	89 45 e0             	mov    %eax,-0x20(%ebp)
  release(&ftable.lock);
80100f0c:	e8 8f 36 00 00       	call   801045a0 <release>

  if(ff.type == FD_PIPE)
80100f11:	83 c4 10             	add    $0x10,%esp
80100f14:	83 ff 01             	cmp    $0x1,%edi
80100f17:	74 2f                	je     80100f48 <fileclose+0x88>
    pipeclose(ff.pipe, ff.writable);
  else if(ff.type == FD_INODE){
80100f19:	83 ff 02             	cmp    $0x2,%edi
80100f1c:	74 4a                	je     80100f68 <fileclose+0xa8>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
80100f1e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f21:	5b                   	pop    %ebx
80100f22:	5e                   	pop    %esi
80100f23:	5f                   	pop    %edi
80100f24:	5d                   	pop    %ebp
80100f25:	c3                   	ret    
80100f26:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100f2d:	8d 76 00             	lea    0x0(%esi),%esi
    release(&ftable.lock);
80100f30:	c7 45 08 c0 ff 10 80 	movl   $0x8010ffc0,0x8(%ebp)
}
80100f37:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f3a:	5b                   	pop    %ebx
80100f3b:	5e                   	pop    %esi
80100f3c:	5f                   	pop    %edi
80100f3d:	5d                   	pop    %ebp
    release(&ftable.lock);
80100f3e:	e9 5d 36 00 00       	jmp    801045a0 <release>
80100f43:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100f47:	90                   	nop
    pipeclose(ff.pipe, ff.writable);
80100f48:	0f be 5d e7          	movsbl -0x19(%ebp),%ebx
80100f4c:	83 ec 08             	sub    $0x8,%esp
80100f4f:	53                   	push   %ebx
80100f50:	56                   	push   %esi
80100f51:	e8 7a 25 00 00       	call   801034d0 <pipeclose>
80100f56:	83 c4 10             	add    $0x10,%esp
}
80100f59:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f5c:	5b                   	pop    %ebx
80100f5d:	5e                   	pop    %esi
80100f5e:	5f                   	pop    %edi
80100f5f:	5d                   	pop    %ebp
80100f60:	c3                   	ret    
80100f61:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    begin_op();
80100f68:	e8 b3 1d 00 00       	call   80102d20 <begin_op>
    iput(ff.ip);
80100f6d:	83 ec 0c             	sub    $0xc,%esp
80100f70:	ff 75 e0             	pushl  -0x20(%ebp)
80100f73:	e8 d8 08 00 00       	call   80101850 <iput>
    end_op();
80100f78:	83 c4 10             	add    $0x10,%esp
}
80100f7b:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f7e:	5b                   	pop    %ebx
80100f7f:	5e                   	pop    %esi
80100f80:	5f                   	pop    %edi
80100f81:	5d                   	pop    %ebp
    end_op();
80100f82:	e9 09 1e 00 00       	jmp    80102d90 <end_op>
    panic("fileclose");
80100f87:	83 ec 0c             	sub    $0xc,%esp
80100f8a:	68 9c 70 10 80       	push   $0x8010709c
80100f8f:	e8 fc f3 ff ff       	call   80100390 <panic>
80100f94:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100f9b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100f9f:	90                   	nop

80100fa0 <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
80100fa0:	55                   	push   %ebp
80100fa1:	89 e5                	mov    %esp,%ebp
80100fa3:	53                   	push   %ebx
80100fa4:	83 ec 04             	sub    $0x4,%esp
80100fa7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(f->type == FD_INODE){
80100faa:	83 3b 02             	cmpl   $0x2,(%ebx)
80100fad:	75 31                	jne    80100fe0 <filestat+0x40>
    ilock(f->ip);
80100faf:	83 ec 0c             	sub    $0xc,%esp
80100fb2:	ff 73 10             	pushl  0x10(%ebx)
80100fb5:	e8 66 07 00 00       	call   80101720 <ilock>
    stati(f->ip, st);
80100fba:	58                   	pop    %eax
80100fbb:	5a                   	pop    %edx
80100fbc:	ff 75 0c             	pushl  0xc(%ebp)
80100fbf:	ff 73 10             	pushl  0x10(%ebx)
80100fc2:	e8 09 0a 00 00       	call   801019d0 <stati>
    iunlock(f->ip);
80100fc7:	59                   	pop    %ecx
80100fc8:	ff 73 10             	pushl  0x10(%ebx)
80100fcb:	e8 30 08 00 00       	call   80101800 <iunlock>
    return 0;
80100fd0:	83 c4 10             	add    $0x10,%esp
80100fd3:	31 c0                	xor    %eax,%eax
  }
  return -1;
}
80100fd5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100fd8:	c9                   	leave  
80100fd9:	c3                   	ret    
80100fda:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return -1;
80100fe0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100fe5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100fe8:	c9                   	leave  
80100fe9:	c3                   	ret    
80100fea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100ff0 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
80100ff0:	55                   	push   %ebp
80100ff1:	89 e5                	mov    %esp,%ebp
80100ff3:	57                   	push   %edi
80100ff4:	56                   	push   %esi
80100ff5:	53                   	push   %ebx
80100ff6:	83 ec 0c             	sub    $0xc,%esp
80100ff9:	8b 5d 08             	mov    0x8(%ebp),%ebx
80100ffc:	8b 75 0c             	mov    0xc(%ebp),%esi
80100fff:	8b 7d 10             	mov    0x10(%ebp),%edi
  int r;

  if(f->readable == 0)
80101002:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
80101006:	74 60                	je     80101068 <fileread+0x78>
    return -1;
  if(f->type == FD_PIPE)
80101008:	8b 03                	mov    (%ebx),%eax
8010100a:	83 f8 01             	cmp    $0x1,%eax
8010100d:	74 41                	je     80101050 <fileread+0x60>
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
8010100f:	83 f8 02             	cmp    $0x2,%eax
80101012:	75 5b                	jne    8010106f <fileread+0x7f>
    ilock(f->ip);
80101014:	83 ec 0c             	sub    $0xc,%esp
80101017:	ff 73 10             	pushl  0x10(%ebx)
8010101a:	e8 01 07 00 00       	call   80101720 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
8010101f:	57                   	push   %edi
80101020:	ff 73 14             	pushl  0x14(%ebx)
80101023:	56                   	push   %esi
80101024:	ff 73 10             	pushl  0x10(%ebx)
80101027:	e8 d4 09 00 00       	call   80101a00 <readi>
8010102c:	83 c4 20             	add    $0x20,%esp
8010102f:	89 c6                	mov    %eax,%esi
80101031:	85 c0                	test   %eax,%eax
80101033:	7e 03                	jle    80101038 <fileread+0x48>
      f->off += r;
80101035:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
80101038:	83 ec 0c             	sub    $0xc,%esp
8010103b:	ff 73 10             	pushl  0x10(%ebx)
8010103e:	e8 bd 07 00 00       	call   80101800 <iunlock>
    return r;
80101043:	83 c4 10             	add    $0x10,%esp
  }
  panic("fileread");
}
80101046:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101049:	89 f0                	mov    %esi,%eax
8010104b:	5b                   	pop    %ebx
8010104c:	5e                   	pop    %esi
8010104d:	5f                   	pop    %edi
8010104e:	5d                   	pop    %ebp
8010104f:	c3                   	ret    
    return piperead(f->pipe, addr, n);
80101050:	8b 43 0c             	mov    0xc(%ebx),%eax
80101053:	89 45 08             	mov    %eax,0x8(%ebp)
}
80101056:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101059:	5b                   	pop    %ebx
8010105a:	5e                   	pop    %esi
8010105b:	5f                   	pop    %edi
8010105c:	5d                   	pop    %ebp
    return piperead(f->pipe, addr, n);
8010105d:	e9 1e 26 00 00       	jmp    80103680 <piperead>
80101062:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80101068:	be ff ff ff ff       	mov    $0xffffffff,%esi
8010106d:	eb d7                	jmp    80101046 <fileread+0x56>
  panic("fileread");
8010106f:	83 ec 0c             	sub    $0xc,%esp
80101072:	68 a6 70 10 80       	push   $0x801070a6
80101077:	e8 14 f3 ff ff       	call   80100390 <panic>
8010107c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101080 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
80101080:	55                   	push   %ebp
80101081:	89 e5                	mov    %esp,%ebp
80101083:	57                   	push   %edi
80101084:	56                   	push   %esi
80101085:	53                   	push   %ebx
80101086:	83 ec 1c             	sub    $0x1c,%esp
80101089:	8b 45 0c             	mov    0xc(%ebp),%eax
8010108c:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010108f:	89 45 dc             	mov    %eax,-0x24(%ebp)
80101092:	8b 45 10             	mov    0x10(%ebp),%eax
  int r;

  if(f->writable == 0)
80101095:	80 7b 09 00          	cmpb   $0x0,0x9(%ebx)
{
80101099:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(f->writable == 0)
8010109c:	0f 84 bb 00 00 00    	je     8010115d <filewrite+0xdd>
    return -1;
  if(f->type == FD_PIPE)
801010a2:	8b 03                	mov    (%ebx),%eax
801010a4:	83 f8 01             	cmp    $0x1,%eax
801010a7:	0f 84 bf 00 00 00    	je     8010116c <filewrite+0xec>
    return pipewrite(f->pipe, addr, n);
  if(f->type == FD_INODE){
801010ad:	83 f8 02             	cmp    $0x2,%eax
801010b0:	0f 85 c8 00 00 00    	jne    8010117e <filewrite+0xfe>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
801010b6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    int i = 0;
801010b9:	31 ff                	xor    %edi,%edi
    while(i < n){
801010bb:	85 c0                	test   %eax,%eax
801010bd:	7f 30                	jg     801010ef <filewrite+0x6f>
801010bf:	e9 94 00 00 00       	jmp    80101158 <filewrite+0xd8>
801010c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
801010c8:	01 43 14             	add    %eax,0x14(%ebx)
      iunlock(f->ip);
801010cb:	83 ec 0c             	sub    $0xc,%esp
801010ce:	ff 73 10             	pushl  0x10(%ebx)
        f->off += r;
801010d1:	89 45 e0             	mov    %eax,-0x20(%ebp)
      iunlock(f->ip);
801010d4:	e8 27 07 00 00       	call   80101800 <iunlock>
      end_op();
801010d9:	e8 b2 1c 00 00       	call   80102d90 <end_op>

      if(r < 0)
        break;
      if(r != n1)
801010de:	8b 45 e0             	mov    -0x20(%ebp),%eax
801010e1:	83 c4 10             	add    $0x10,%esp
801010e4:	39 f0                	cmp    %esi,%eax
801010e6:	75 60                	jne    80101148 <filewrite+0xc8>
        panic("short filewrite");
      i += r;
801010e8:	01 c7                	add    %eax,%edi
    while(i < n){
801010ea:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
801010ed:	7e 69                	jle    80101158 <filewrite+0xd8>
      int n1 = n - i;
801010ef:	8b 75 e4             	mov    -0x1c(%ebp),%esi
801010f2:	b8 00 06 00 00       	mov    $0x600,%eax
801010f7:	29 fe                	sub    %edi,%esi
      if(n1 > max)
801010f9:	81 fe 00 06 00 00    	cmp    $0x600,%esi
801010ff:	0f 4f f0             	cmovg  %eax,%esi
      begin_op();
80101102:	e8 19 1c 00 00       	call   80102d20 <begin_op>
      ilock(f->ip);
80101107:	83 ec 0c             	sub    $0xc,%esp
8010110a:	ff 73 10             	pushl  0x10(%ebx)
8010110d:	e8 0e 06 00 00       	call   80101720 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
80101112:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101115:	56                   	push   %esi
80101116:	ff 73 14             	pushl  0x14(%ebx)
80101119:	01 f8                	add    %edi,%eax
8010111b:	50                   	push   %eax
8010111c:	ff 73 10             	pushl  0x10(%ebx)
8010111f:	e8 dc 09 00 00       	call   80101b00 <writei>
80101124:	83 c4 20             	add    $0x20,%esp
80101127:	85 c0                	test   %eax,%eax
80101129:	7f 9d                	jg     801010c8 <filewrite+0x48>
      iunlock(f->ip);
8010112b:	83 ec 0c             	sub    $0xc,%esp
8010112e:	ff 73 10             	pushl  0x10(%ebx)
80101131:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80101134:	e8 c7 06 00 00       	call   80101800 <iunlock>
      end_op();
80101139:	e8 52 1c 00 00       	call   80102d90 <end_op>
      if(r < 0)
8010113e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101141:	83 c4 10             	add    $0x10,%esp
80101144:	85 c0                	test   %eax,%eax
80101146:	75 15                	jne    8010115d <filewrite+0xdd>
        panic("short filewrite");
80101148:	83 ec 0c             	sub    $0xc,%esp
8010114b:	68 af 70 10 80       	push   $0x801070af
80101150:	e8 3b f2 ff ff       	call   80100390 <panic>
80101155:	8d 76 00             	lea    0x0(%esi),%esi
    }
    return i == n ? n : -1;
80101158:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
8010115b:	74 05                	je     80101162 <filewrite+0xe2>
8010115d:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  }
  panic("filewrite");
}
80101162:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101165:	89 f8                	mov    %edi,%eax
80101167:	5b                   	pop    %ebx
80101168:	5e                   	pop    %esi
80101169:	5f                   	pop    %edi
8010116a:	5d                   	pop    %ebp
8010116b:	c3                   	ret    
    return pipewrite(f->pipe, addr, n);
8010116c:	8b 43 0c             	mov    0xc(%ebx),%eax
8010116f:	89 45 08             	mov    %eax,0x8(%ebp)
}
80101172:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101175:	5b                   	pop    %ebx
80101176:	5e                   	pop    %esi
80101177:	5f                   	pop    %edi
80101178:	5d                   	pop    %ebp
    return pipewrite(f->pipe, addr, n);
80101179:	e9 f2 23 00 00       	jmp    80103570 <pipewrite>
  panic("filewrite");
8010117e:	83 ec 0c             	sub    $0xc,%esp
80101181:	68 b5 70 10 80       	push   $0x801070b5
80101186:	e8 05 f2 ff ff       	call   80100390 <panic>
8010118b:	66 90                	xchg   %ax,%ax
8010118d:	66 90                	xchg   %ax,%ax
8010118f:	90                   	nop

80101190 <balloc>:
// Blocks.

// Allocate a zeroed disk block.
static uint
balloc(uint dev)
{
80101190:	55                   	push   %ebp
80101191:	89 e5                	mov    %esp,%ebp
80101193:	57                   	push   %edi
80101194:	56                   	push   %esi
80101195:	53                   	push   %ebx
80101196:	83 ec 1c             	sub    $0x1c,%esp
  int b, bi, m;
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
80101199:	8b 0d c0 09 11 80    	mov    0x801109c0,%ecx
{
8010119f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  for(b = 0; b < sb.size; b += BPB){
801011a2:	85 c9                	test   %ecx,%ecx
801011a4:	0f 84 87 00 00 00    	je     80101231 <balloc+0xa1>
801011aa:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    bp = bread(dev, BBLOCK(b, sb));
801011b1:	8b 75 dc             	mov    -0x24(%ebp),%esi
801011b4:	83 ec 08             	sub    $0x8,%esp
801011b7:	89 f0                	mov    %esi,%eax
801011b9:	c1 f8 0c             	sar    $0xc,%eax
801011bc:	03 05 d8 09 11 80    	add    0x801109d8,%eax
801011c2:	50                   	push   %eax
801011c3:	ff 75 d8             	pushl  -0x28(%ebp)
801011c6:	e8 05 ef ff ff       	call   801000d0 <bread>
801011cb:	83 c4 10             	add    $0x10,%esp
801011ce:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
801011d1:	a1 c0 09 11 80       	mov    0x801109c0,%eax
801011d6:	89 45 e0             	mov    %eax,-0x20(%ebp)
801011d9:	31 c0                	xor    %eax,%eax
801011db:	eb 2f                	jmp    8010120c <balloc+0x7c>
801011dd:	8d 76 00             	lea    0x0(%esi),%esi
      m = 1 << (bi % 8);
801011e0:	89 c1                	mov    %eax,%ecx
801011e2:	bb 01 00 00 00       	mov    $0x1,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
801011e7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      m = 1 << (bi % 8);
801011ea:	83 e1 07             	and    $0x7,%ecx
801011ed:	d3 e3                	shl    %cl,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
801011ef:	89 c1                	mov    %eax,%ecx
801011f1:	c1 f9 03             	sar    $0x3,%ecx
801011f4:	0f b6 7c 0a 5c       	movzbl 0x5c(%edx,%ecx,1),%edi
801011f9:	89 fa                	mov    %edi,%edx
801011fb:	85 df                	test   %ebx,%edi
801011fd:	74 41                	je     80101240 <balloc+0xb0>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
801011ff:	83 c0 01             	add    $0x1,%eax
80101202:	83 c6 01             	add    $0x1,%esi
80101205:	3d 00 10 00 00       	cmp    $0x1000,%eax
8010120a:	74 05                	je     80101211 <balloc+0x81>
8010120c:	39 75 e0             	cmp    %esi,-0x20(%ebp)
8010120f:	77 cf                	ja     801011e0 <balloc+0x50>
        brelse(bp);
        bzero(dev, b + bi);
        return b + bi;
      }
    }
    brelse(bp);
80101211:	83 ec 0c             	sub    $0xc,%esp
80101214:	ff 75 e4             	pushl  -0x1c(%ebp)
80101217:	e8 d4 ef ff ff       	call   801001f0 <brelse>
  for(b = 0; b < sb.size; b += BPB){
8010121c:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
80101223:	83 c4 10             	add    $0x10,%esp
80101226:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101229:	39 05 c0 09 11 80    	cmp    %eax,0x801109c0
8010122f:	77 80                	ja     801011b1 <balloc+0x21>
  }
  panic("balloc: out of blocks");
80101231:	83 ec 0c             	sub    $0xc,%esp
80101234:	68 bf 70 10 80       	push   $0x801070bf
80101239:	e8 52 f1 ff ff       	call   80100390 <panic>
8010123e:	66 90                	xchg   %ax,%ax
        bp->data[bi/8] |= m;  // Mark block in use.
80101240:	8b 7d e4             	mov    -0x1c(%ebp),%edi
        log_write(bp);
80101243:	83 ec 0c             	sub    $0xc,%esp
        bp->data[bi/8] |= m;  // Mark block in use.
80101246:	09 da                	or     %ebx,%edx
80101248:	88 54 0f 5c          	mov    %dl,0x5c(%edi,%ecx,1)
        log_write(bp);
8010124c:	57                   	push   %edi
8010124d:	e8 ae 1c 00 00       	call   80102f00 <log_write>
        brelse(bp);
80101252:	89 3c 24             	mov    %edi,(%esp)
80101255:	e8 96 ef ff ff       	call   801001f0 <brelse>
  bp = bread(dev, bno);
8010125a:	58                   	pop    %eax
8010125b:	5a                   	pop    %edx
8010125c:	56                   	push   %esi
8010125d:	ff 75 d8             	pushl  -0x28(%ebp)
80101260:	e8 6b ee ff ff       	call   801000d0 <bread>
  memset(bp->data, 0, BSIZE);
80101265:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, bno);
80101268:	89 c3                	mov    %eax,%ebx
  memset(bp->data, 0, BSIZE);
8010126a:	8d 40 5c             	lea    0x5c(%eax),%eax
8010126d:	68 00 02 00 00       	push   $0x200
80101272:	6a 00                	push   $0x0
80101274:	50                   	push   %eax
80101275:	e8 76 33 00 00       	call   801045f0 <memset>
  log_write(bp);
8010127a:	89 1c 24             	mov    %ebx,(%esp)
8010127d:	e8 7e 1c 00 00       	call   80102f00 <log_write>
  brelse(bp);
80101282:	89 1c 24             	mov    %ebx,(%esp)
80101285:	e8 66 ef ff ff       	call   801001f0 <brelse>
}
8010128a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010128d:	89 f0                	mov    %esi,%eax
8010128f:	5b                   	pop    %ebx
80101290:	5e                   	pop    %esi
80101291:	5f                   	pop    %edi
80101292:	5d                   	pop    %ebp
80101293:	c3                   	ret    
80101294:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010129b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010129f:	90                   	nop

801012a0 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
801012a0:	55                   	push   %ebp
801012a1:	89 e5                	mov    %esp,%ebp
801012a3:	57                   	push   %edi
801012a4:	89 c7                	mov    %eax,%edi
801012a6:	56                   	push   %esi
  struct inode *ip, *empty;

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
801012a7:	31 f6                	xor    %esi,%esi
{
801012a9:	53                   	push   %ebx
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801012aa:	bb 14 0a 11 80       	mov    $0x80110a14,%ebx
{
801012af:	83 ec 28             	sub    $0x28,%esp
801012b2:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  acquire(&icache.lock);
801012b5:	68 e0 09 11 80       	push   $0x801109e0
801012ba:	e8 21 32 00 00       	call   801044e0 <acquire>
801012bf:	83 c4 10             	add    $0x10,%esp
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801012c2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801012c5:	eb 1b                	jmp    801012e2 <iget+0x42>
801012c7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801012ce:	66 90                	xchg   %ax,%ax
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
801012d0:	39 3b                	cmp    %edi,(%ebx)
801012d2:	74 6c                	je     80101340 <iget+0xa0>
801012d4:	81 c3 90 00 00 00    	add    $0x90,%ebx
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801012da:	81 fb 34 26 11 80    	cmp    $0x80112634,%ebx
801012e0:	73 26                	jae    80101308 <iget+0x68>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
801012e2:	8b 4b 08             	mov    0x8(%ebx),%ecx
801012e5:	85 c9                	test   %ecx,%ecx
801012e7:	7f e7                	jg     801012d0 <iget+0x30>
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
801012e9:	85 f6                	test   %esi,%esi
801012eb:	75 e7                	jne    801012d4 <iget+0x34>
801012ed:	8d 83 90 00 00 00    	lea    0x90(%ebx),%eax
801012f3:	85 c9                	test   %ecx,%ecx
801012f5:	75 70                	jne    80101367 <iget+0xc7>
801012f7:	89 de                	mov    %ebx,%esi
801012f9:	89 c3                	mov    %eax,%ebx
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801012fb:	81 fb 34 26 11 80    	cmp    $0x80112634,%ebx
80101301:	72 df                	jb     801012e2 <iget+0x42>
80101303:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101307:	90                   	nop
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
80101308:	85 f6                	test   %esi,%esi
8010130a:	74 74                	je     80101380 <iget+0xe0>
  ip = empty;
  ip->dev = dev;
  ip->inum = inum;
  ip->ref = 1;
  ip->valid = 0;
  release(&icache.lock);
8010130c:	83 ec 0c             	sub    $0xc,%esp
  ip->dev = dev;
8010130f:	89 3e                	mov    %edi,(%esi)
  ip->inum = inum;
80101311:	89 56 04             	mov    %edx,0x4(%esi)
  ip->ref = 1;
80101314:	c7 46 08 01 00 00 00 	movl   $0x1,0x8(%esi)
  ip->valid = 0;
8010131b:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
  release(&icache.lock);
80101322:	68 e0 09 11 80       	push   $0x801109e0
80101327:	e8 74 32 00 00       	call   801045a0 <release>

  return ip;
8010132c:	83 c4 10             	add    $0x10,%esp
}
8010132f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101332:	89 f0                	mov    %esi,%eax
80101334:	5b                   	pop    %ebx
80101335:	5e                   	pop    %esi
80101336:	5f                   	pop    %edi
80101337:	5d                   	pop    %ebp
80101338:	c3                   	ret    
80101339:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101340:	39 53 04             	cmp    %edx,0x4(%ebx)
80101343:	75 8f                	jne    801012d4 <iget+0x34>
      release(&icache.lock);
80101345:	83 ec 0c             	sub    $0xc,%esp
      ip->ref++;
80101348:	83 c1 01             	add    $0x1,%ecx
      return ip;
8010134b:	89 de                	mov    %ebx,%esi
      ip->ref++;
8010134d:	89 4b 08             	mov    %ecx,0x8(%ebx)
      release(&icache.lock);
80101350:	68 e0 09 11 80       	push   $0x801109e0
80101355:	e8 46 32 00 00       	call   801045a0 <release>
      return ip;
8010135a:	83 c4 10             	add    $0x10,%esp
}
8010135d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101360:	89 f0                	mov    %esi,%eax
80101362:	5b                   	pop    %ebx
80101363:	5e                   	pop    %esi
80101364:	5f                   	pop    %edi
80101365:	5d                   	pop    %ebp
80101366:	c3                   	ret    
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101367:	3d 34 26 11 80       	cmp    $0x80112634,%eax
8010136c:	73 12                	jae    80101380 <iget+0xe0>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
8010136e:	8b 48 08             	mov    0x8(%eax),%ecx
80101371:	89 c3                	mov    %eax,%ebx
80101373:	85 c9                	test   %ecx,%ecx
80101375:	0f 8f 55 ff ff ff    	jg     801012d0 <iget+0x30>
8010137b:	e9 6d ff ff ff       	jmp    801012ed <iget+0x4d>
    panic("iget: no inodes");
80101380:	83 ec 0c             	sub    $0xc,%esp
80101383:	68 d5 70 10 80       	push   $0x801070d5
80101388:	e8 03 f0 ff ff       	call   80100390 <panic>
8010138d:	8d 76 00             	lea    0x0(%esi),%esi

80101390 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
80101390:	55                   	push   %ebp
80101391:	89 e5                	mov    %esp,%ebp
80101393:	57                   	push   %edi
80101394:	56                   	push   %esi
80101395:	89 c6                	mov    %eax,%esi
80101397:	53                   	push   %ebx
80101398:	83 ec 1c             	sub    $0x1c,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
8010139b:	83 fa 0b             	cmp    $0xb,%edx
8010139e:	0f 86 84 00 00 00    	jbe    80101428 <bmap+0x98>
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
801013a4:	8d 5a f4             	lea    -0xc(%edx),%ebx

  if(bn < NINDIRECT){
801013a7:	83 fb 7f             	cmp    $0x7f,%ebx
801013aa:	0f 87 98 00 00 00    	ja     80101448 <bmap+0xb8>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
801013b0:	8b 90 8c 00 00 00    	mov    0x8c(%eax),%edx
801013b6:	8b 00                	mov    (%eax),%eax
801013b8:	85 d2                	test   %edx,%edx
801013ba:	74 54                	je     80101410 <bmap+0x80>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
801013bc:	83 ec 08             	sub    $0x8,%esp
801013bf:	52                   	push   %edx
801013c0:	50                   	push   %eax
801013c1:	e8 0a ed ff ff       	call   801000d0 <bread>
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
801013c6:	83 c4 10             	add    $0x10,%esp
801013c9:	8d 54 98 5c          	lea    0x5c(%eax,%ebx,4),%edx
    bp = bread(ip->dev, addr);
801013cd:	89 c7                	mov    %eax,%edi
    if((addr = a[bn]) == 0){
801013cf:	8b 1a                	mov    (%edx),%ebx
801013d1:	85 db                	test   %ebx,%ebx
801013d3:	74 1b                	je     801013f0 <bmap+0x60>
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
801013d5:	83 ec 0c             	sub    $0xc,%esp
801013d8:	57                   	push   %edi
801013d9:	e8 12 ee ff ff       	call   801001f0 <brelse>
    return addr;
801013de:	83 c4 10             	add    $0x10,%esp
  }

  panic("bmap: out of range");
}
801013e1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801013e4:	89 d8                	mov    %ebx,%eax
801013e6:	5b                   	pop    %ebx
801013e7:	5e                   	pop    %esi
801013e8:	5f                   	pop    %edi
801013e9:	5d                   	pop    %ebp
801013ea:	c3                   	ret    
801013eb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801013ef:	90                   	nop
      a[bn] = addr = balloc(ip->dev);
801013f0:	8b 06                	mov    (%esi),%eax
801013f2:	89 55 e4             	mov    %edx,-0x1c(%ebp)
801013f5:	e8 96 fd ff ff       	call   80101190 <balloc>
801013fa:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      log_write(bp);
801013fd:	83 ec 0c             	sub    $0xc,%esp
      a[bn] = addr = balloc(ip->dev);
80101400:	89 c3                	mov    %eax,%ebx
80101402:	89 02                	mov    %eax,(%edx)
      log_write(bp);
80101404:	57                   	push   %edi
80101405:	e8 f6 1a 00 00       	call   80102f00 <log_write>
8010140a:	83 c4 10             	add    $0x10,%esp
8010140d:	eb c6                	jmp    801013d5 <bmap+0x45>
8010140f:	90                   	nop
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
80101410:	e8 7b fd ff ff       	call   80101190 <balloc>
80101415:	89 c2                	mov    %eax,%edx
80101417:	89 86 8c 00 00 00    	mov    %eax,0x8c(%esi)
8010141d:	8b 06                	mov    (%esi),%eax
8010141f:	eb 9b                	jmp    801013bc <bmap+0x2c>
80101421:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if((addr = ip->addrs[bn]) == 0)
80101428:	8d 3c 90             	lea    (%eax,%edx,4),%edi
8010142b:	8b 5f 5c             	mov    0x5c(%edi),%ebx
8010142e:	85 db                	test   %ebx,%ebx
80101430:	75 af                	jne    801013e1 <bmap+0x51>
      ip->addrs[bn] = addr = balloc(ip->dev);
80101432:	8b 00                	mov    (%eax),%eax
80101434:	e8 57 fd ff ff       	call   80101190 <balloc>
80101439:	89 47 5c             	mov    %eax,0x5c(%edi)
8010143c:	89 c3                	mov    %eax,%ebx
}
8010143e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101441:	89 d8                	mov    %ebx,%eax
80101443:	5b                   	pop    %ebx
80101444:	5e                   	pop    %esi
80101445:	5f                   	pop    %edi
80101446:	5d                   	pop    %ebp
80101447:	c3                   	ret    
  panic("bmap: out of range");
80101448:	83 ec 0c             	sub    $0xc,%esp
8010144b:	68 e5 70 10 80       	push   $0x801070e5
80101450:	e8 3b ef ff ff       	call   80100390 <panic>
80101455:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010145c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101460 <readsb>:
{
80101460:	55                   	push   %ebp
80101461:	89 e5                	mov    %esp,%ebp
80101463:	56                   	push   %esi
80101464:	53                   	push   %ebx
80101465:	8b 75 0c             	mov    0xc(%ebp),%esi
  bp = bread(dev, 1);
80101468:	83 ec 08             	sub    $0x8,%esp
8010146b:	6a 01                	push   $0x1
8010146d:	ff 75 08             	pushl  0x8(%ebp)
80101470:	e8 5b ec ff ff       	call   801000d0 <bread>
  memmove(sb, bp->data, sizeof(*sb));
80101475:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, 1);
80101478:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
8010147a:	8d 40 5c             	lea    0x5c(%eax),%eax
8010147d:	6a 1c                	push   $0x1c
8010147f:	50                   	push   %eax
80101480:	56                   	push   %esi
80101481:	e8 0a 32 00 00       	call   80104690 <memmove>
  brelse(bp);
80101486:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101489:	83 c4 10             	add    $0x10,%esp
}
8010148c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010148f:	5b                   	pop    %ebx
80101490:	5e                   	pop    %esi
80101491:	5d                   	pop    %ebp
  brelse(bp);
80101492:	e9 59 ed ff ff       	jmp    801001f0 <brelse>
80101497:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010149e:	66 90                	xchg   %ax,%ax

801014a0 <bfree>:
{
801014a0:	55                   	push   %ebp
801014a1:	89 e5                	mov    %esp,%ebp
801014a3:	56                   	push   %esi
801014a4:	89 c6                	mov    %eax,%esi
801014a6:	53                   	push   %ebx
801014a7:	89 d3                	mov    %edx,%ebx
  readsb(dev, &sb);
801014a9:	83 ec 08             	sub    $0x8,%esp
801014ac:	68 c0 09 11 80       	push   $0x801109c0
801014b1:	50                   	push   %eax
801014b2:	e8 a9 ff ff ff       	call   80101460 <readsb>
  bp = bread(dev, BBLOCK(b, sb));
801014b7:	58                   	pop    %eax
801014b8:	5a                   	pop    %edx
801014b9:	89 da                	mov    %ebx,%edx
801014bb:	c1 ea 0c             	shr    $0xc,%edx
801014be:	03 15 d8 09 11 80    	add    0x801109d8,%edx
801014c4:	52                   	push   %edx
801014c5:	56                   	push   %esi
801014c6:	e8 05 ec ff ff       	call   801000d0 <bread>
  m = 1 << (bi % 8);
801014cb:	89 d9                	mov    %ebx,%ecx
  if((bp->data[bi/8] & m) == 0)
801014cd:	c1 fb 03             	sar    $0x3,%ebx
  m = 1 << (bi % 8);
801014d0:	ba 01 00 00 00       	mov    $0x1,%edx
801014d5:	83 e1 07             	and    $0x7,%ecx
  if((bp->data[bi/8] & m) == 0)
801014d8:	81 e3 ff 01 00 00    	and    $0x1ff,%ebx
801014de:	83 c4 10             	add    $0x10,%esp
  m = 1 << (bi % 8);
801014e1:	d3 e2                	shl    %cl,%edx
  if((bp->data[bi/8] & m) == 0)
801014e3:	0f b6 4c 18 5c       	movzbl 0x5c(%eax,%ebx,1),%ecx
801014e8:	85 d1                	test   %edx,%ecx
801014ea:	74 25                	je     80101511 <bfree+0x71>
  bp->data[bi/8] &= ~m;
801014ec:	f7 d2                	not    %edx
801014ee:	89 c6                	mov    %eax,%esi
  log_write(bp);
801014f0:	83 ec 0c             	sub    $0xc,%esp
  bp->data[bi/8] &= ~m;
801014f3:	21 ca                	and    %ecx,%edx
801014f5:	88 54 1e 5c          	mov    %dl,0x5c(%esi,%ebx,1)
  log_write(bp);
801014f9:	56                   	push   %esi
801014fa:	e8 01 1a 00 00       	call   80102f00 <log_write>
  brelse(bp);
801014ff:	89 34 24             	mov    %esi,(%esp)
80101502:	e8 e9 ec ff ff       	call   801001f0 <brelse>
}
80101507:	83 c4 10             	add    $0x10,%esp
8010150a:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010150d:	5b                   	pop    %ebx
8010150e:	5e                   	pop    %esi
8010150f:	5d                   	pop    %ebp
80101510:	c3                   	ret    
    panic("freeing free block");
80101511:	83 ec 0c             	sub    $0xc,%esp
80101514:	68 f8 70 10 80       	push   $0x801070f8
80101519:	e8 72 ee ff ff       	call   80100390 <panic>
8010151e:	66 90                	xchg   %ax,%ax

80101520 <iinit>:
{
80101520:	55                   	push   %ebp
80101521:	89 e5                	mov    %esp,%ebp
80101523:	53                   	push   %ebx
80101524:	bb 20 0a 11 80       	mov    $0x80110a20,%ebx
80101529:	83 ec 0c             	sub    $0xc,%esp
  initlock(&icache.lock, "icache");
8010152c:	68 0b 71 10 80       	push   $0x8010710b
80101531:	68 e0 09 11 80       	push   $0x801109e0
80101536:	e8 45 2e 00 00       	call   80104380 <initlock>
  for(i = 0; i < NINODE; i++) {
8010153b:	83 c4 10             	add    $0x10,%esp
8010153e:	66 90                	xchg   %ax,%ax
    initsleeplock(&icache.inode[i].lock, "inode");
80101540:	83 ec 08             	sub    $0x8,%esp
80101543:	68 12 71 10 80       	push   $0x80107112
80101548:	53                   	push   %ebx
80101549:	81 c3 90 00 00 00    	add    $0x90,%ebx
8010154f:	e8 fc 2c 00 00       	call   80104250 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
80101554:	83 c4 10             	add    $0x10,%esp
80101557:	81 fb 40 26 11 80    	cmp    $0x80112640,%ebx
8010155d:	75 e1                	jne    80101540 <iinit+0x20>
  readsb(dev, &sb);
8010155f:	83 ec 08             	sub    $0x8,%esp
80101562:	68 c0 09 11 80       	push   $0x801109c0
80101567:	ff 75 08             	pushl  0x8(%ebp)
8010156a:	e8 f1 fe ff ff       	call   80101460 <readsb>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
8010156f:	ff 35 d8 09 11 80    	pushl  0x801109d8
80101575:	ff 35 d4 09 11 80    	pushl  0x801109d4
8010157b:	ff 35 d0 09 11 80    	pushl  0x801109d0
80101581:	ff 35 cc 09 11 80    	pushl  0x801109cc
80101587:	ff 35 c8 09 11 80    	pushl  0x801109c8
8010158d:	ff 35 c4 09 11 80    	pushl  0x801109c4
80101593:	ff 35 c0 09 11 80    	pushl  0x801109c0
80101599:	68 78 71 10 80       	push   $0x80107178
8010159e:	e8 0d f1 ff ff       	call   801006b0 <cprintf>
}
801015a3:	83 c4 30             	add    $0x30,%esp
801015a6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801015a9:	c9                   	leave  
801015aa:	c3                   	ret    
801015ab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801015af:	90                   	nop

801015b0 <ialloc>:
{
801015b0:	55                   	push   %ebp
801015b1:	89 e5                	mov    %esp,%ebp
801015b3:	57                   	push   %edi
801015b4:	56                   	push   %esi
801015b5:	53                   	push   %ebx
801015b6:	83 ec 1c             	sub    $0x1c,%esp
801015b9:	8b 45 0c             	mov    0xc(%ebp),%eax
  for(inum = 1; inum < sb.ninodes; inum++){
801015bc:	83 3d c8 09 11 80 01 	cmpl   $0x1,0x801109c8
{
801015c3:	8b 75 08             	mov    0x8(%ebp),%esi
801015c6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(inum = 1; inum < sb.ninodes; inum++){
801015c9:	0f 86 91 00 00 00    	jbe    80101660 <ialloc+0xb0>
801015cf:	bb 01 00 00 00       	mov    $0x1,%ebx
801015d4:	eb 21                	jmp    801015f7 <ialloc+0x47>
801015d6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801015dd:	8d 76 00             	lea    0x0(%esi),%esi
    brelse(bp);
801015e0:	83 ec 0c             	sub    $0xc,%esp
  for(inum = 1; inum < sb.ninodes; inum++){
801015e3:	83 c3 01             	add    $0x1,%ebx
    brelse(bp);
801015e6:	57                   	push   %edi
801015e7:	e8 04 ec ff ff       	call   801001f0 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
801015ec:	83 c4 10             	add    $0x10,%esp
801015ef:	3b 1d c8 09 11 80    	cmp    0x801109c8,%ebx
801015f5:	73 69                	jae    80101660 <ialloc+0xb0>
    bp = bread(dev, IBLOCK(inum, sb));
801015f7:	89 d8                	mov    %ebx,%eax
801015f9:	83 ec 08             	sub    $0x8,%esp
801015fc:	c1 e8 03             	shr    $0x3,%eax
801015ff:	03 05 d4 09 11 80    	add    0x801109d4,%eax
80101605:	50                   	push   %eax
80101606:	56                   	push   %esi
80101607:	e8 c4 ea ff ff       	call   801000d0 <bread>
    if(dip->type == 0){  // a free inode
8010160c:	83 c4 10             	add    $0x10,%esp
    bp = bread(dev, IBLOCK(inum, sb));
8010160f:	89 c7                	mov    %eax,%edi
    dip = (struct dinode*)bp->data + inum%IPB;
80101611:	89 d8                	mov    %ebx,%eax
80101613:	83 e0 07             	and    $0x7,%eax
80101616:	c1 e0 06             	shl    $0x6,%eax
80101619:	8d 4c 07 5c          	lea    0x5c(%edi,%eax,1),%ecx
    if(dip->type == 0){  // a free inode
8010161d:	66 83 39 00          	cmpw   $0x0,(%ecx)
80101621:	75 bd                	jne    801015e0 <ialloc+0x30>
      memset(dip, 0, sizeof(*dip));
80101623:	83 ec 04             	sub    $0x4,%esp
80101626:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80101629:	6a 40                	push   $0x40
8010162b:	6a 00                	push   $0x0
8010162d:	51                   	push   %ecx
8010162e:	e8 bd 2f 00 00       	call   801045f0 <memset>
      dip->type = type;
80101633:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
80101637:	8b 4d e0             	mov    -0x20(%ebp),%ecx
8010163a:	66 89 01             	mov    %ax,(%ecx)
      log_write(bp);   // mark it allocated on the disk
8010163d:	89 3c 24             	mov    %edi,(%esp)
80101640:	e8 bb 18 00 00       	call   80102f00 <log_write>
      brelse(bp);
80101645:	89 3c 24             	mov    %edi,(%esp)
80101648:	e8 a3 eb ff ff       	call   801001f0 <brelse>
      return iget(dev, inum);
8010164d:	83 c4 10             	add    $0x10,%esp
}
80101650:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return iget(dev, inum);
80101653:	89 da                	mov    %ebx,%edx
80101655:	89 f0                	mov    %esi,%eax
}
80101657:	5b                   	pop    %ebx
80101658:	5e                   	pop    %esi
80101659:	5f                   	pop    %edi
8010165a:	5d                   	pop    %ebp
      return iget(dev, inum);
8010165b:	e9 40 fc ff ff       	jmp    801012a0 <iget>
  panic("ialloc: no inodes");
80101660:	83 ec 0c             	sub    $0xc,%esp
80101663:	68 18 71 10 80       	push   $0x80107118
80101668:	e8 23 ed ff ff       	call   80100390 <panic>
8010166d:	8d 76 00             	lea    0x0(%esi),%esi

80101670 <iupdate>:
{
80101670:	55                   	push   %ebp
80101671:	89 e5                	mov    %esp,%ebp
80101673:	56                   	push   %esi
80101674:	53                   	push   %ebx
80101675:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101678:	8b 43 04             	mov    0x4(%ebx),%eax
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010167b:	83 c3 5c             	add    $0x5c,%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
8010167e:	83 ec 08             	sub    $0x8,%esp
80101681:	c1 e8 03             	shr    $0x3,%eax
80101684:	03 05 d4 09 11 80    	add    0x801109d4,%eax
8010168a:	50                   	push   %eax
8010168b:	ff 73 a4             	pushl  -0x5c(%ebx)
8010168e:	e8 3d ea ff ff       	call   801000d0 <bread>
  dip->type = ip->type;
80101693:	0f b7 53 f4          	movzwl -0xc(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101697:	83 c4 0c             	add    $0xc,%esp
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
8010169a:	89 c6                	mov    %eax,%esi
  dip = (struct dinode*)bp->data + ip->inum%IPB;
8010169c:	8b 43 a8             	mov    -0x58(%ebx),%eax
8010169f:	83 e0 07             	and    $0x7,%eax
801016a2:	c1 e0 06             	shl    $0x6,%eax
801016a5:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
  dip->type = ip->type;
801016a9:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
801016ac:	0f b7 53 f6          	movzwl -0xa(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801016b0:	83 c0 0c             	add    $0xc,%eax
  dip->major = ip->major;
801016b3:	66 89 50 f6          	mov    %dx,-0xa(%eax)
  dip->minor = ip->minor;
801016b7:	0f b7 53 f8          	movzwl -0x8(%ebx),%edx
801016bb:	66 89 50 f8          	mov    %dx,-0x8(%eax)
  dip->nlink = ip->nlink;
801016bf:	0f b7 53 fa          	movzwl -0x6(%ebx),%edx
801016c3:	66 89 50 fa          	mov    %dx,-0x6(%eax)
  dip->size = ip->size;
801016c7:	8b 53 fc             	mov    -0x4(%ebx),%edx
801016ca:	89 50 fc             	mov    %edx,-0x4(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801016cd:	6a 34                	push   $0x34
801016cf:	53                   	push   %ebx
801016d0:	50                   	push   %eax
801016d1:	e8 ba 2f 00 00       	call   80104690 <memmove>
  log_write(bp);
801016d6:	89 34 24             	mov    %esi,(%esp)
801016d9:	e8 22 18 00 00       	call   80102f00 <log_write>
  brelse(bp);
801016de:	89 75 08             	mov    %esi,0x8(%ebp)
801016e1:	83 c4 10             	add    $0x10,%esp
}
801016e4:	8d 65 f8             	lea    -0x8(%ebp),%esp
801016e7:	5b                   	pop    %ebx
801016e8:	5e                   	pop    %esi
801016e9:	5d                   	pop    %ebp
  brelse(bp);
801016ea:	e9 01 eb ff ff       	jmp    801001f0 <brelse>
801016ef:	90                   	nop

801016f0 <idup>:
{
801016f0:	55                   	push   %ebp
801016f1:	89 e5                	mov    %esp,%ebp
801016f3:	53                   	push   %ebx
801016f4:	83 ec 10             	sub    $0x10,%esp
801016f7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
801016fa:	68 e0 09 11 80       	push   $0x801109e0
801016ff:	e8 dc 2d 00 00       	call   801044e0 <acquire>
  ip->ref++;
80101704:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
80101708:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
8010170f:	e8 8c 2e 00 00       	call   801045a0 <release>
}
80101714:	89 d8                	mov    %ebx,%eax
80101716:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101719:	c9                   	leave  
8010171a:	c3                   	ret    
8010171b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010171f:	90                   	nop

80101720 <ilock>:
{
80101720:	55                   	push   %ebp
80101721:	89 e5                	mov    %esp,%ebp
80101723:	56                   	push   %esi
80101724:	53                   	push   %ebx
80101725:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || ip->ref < 1)
80101728:	85 db                	test   %ebx,%ebx
8010172a:	0f 84 b7 00 00 00    	je     801017e7 <ilock+0xc7>
80101730:	8b 53 08             	mov    0x8(%ebx),%edx
80101733:	85 d2                	test   %edx,%edx
80101735:	0f 8e ac 00 00 00    	jle    801017e7 <ilock+0xc7>
  acquiresleep(&ip->lock);
8010173b:	83 ec 0c             	sub    $0xc,%esp
8010173e:	8d 43 0c             	lea    0xc(%ebx),%eax
80101741:	50                   	push   %eax
80101742:	e8 49 2b 00 00       	call   80104290 <acquiresleep>
  if(ip->valid == 0){
80101747:	8b 43 4c             	mov    0x4c(%ebx),%eax
8010174a:	83 c4 10             	add    $0x10,%esp
8010174d:	85 c0                	test   %eax,%eax
8010174f:	74 0f                	je     80101760 <ilock+0x40>
}
80101751:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101754:	5b                   	pop    %ebx
80101755:	5e                   	pop    %esi
80101756:	5d                   	pop    %ebp
80101757:	c3                   	ret    
80101758:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010175f:	90                   	nop
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101760:	8b 43 04             	mov    0x4(%ebx),%eax
80101763:	83 ec 08             	sub    $0x8,%esp
80101766:	c1 e8 03             	shr    $0x3,%eax
80101769:	03 05 d4 09 11 80    	add    0x801109d4,%eax
8010176f:	50                   	push   %eax
80101770:	ff 33                	pushl  (%ebx)
80101772:	e8 59 e9 ff ff       	call   801000d0 <bread>
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101777:	83 c4 0c             	add    $0xc,%esp
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
8010177a:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + ip->inum%IPB;
8010177c:	8b 43 04             	mov    0x4(%ebx),%eax
8010177f:	83 e0 07             	and    $0x7,%eax
80101782:	c1 e0 06             	shl    $0x6,%eax
80101785:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
    ip->type = dip->type;
80101789:	0f b7 10             	movzwl (%eax),%edx
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
8010178c:	83 c0 0c             	add    $0xc,%eax
    ip->type = dip->type;
8010178f:	66 89 53 50          	mov    %dx,0x50(%ebx)
    ip->major = dip->major;
80101793:	0f b7 50 f6          	movzwl -0xa(%eax),%edx
80101797:	66 89 53 52          	mov    %dx,0x52(%ebx)
    ip->minor = dip->minor;
8010179b:	0f b7 50 f8          	movzwl -0x8(%eax),%edx
8010179f:	66 89 53 54          	mov    %dx,0x54(%ebx)
    ip->nlink = dip->nlink;
801017a3:	0f b7 50 fa          	movzwl -0x6(%eax),%edx
801017a7:	66 89 53 56          	mov    %dx,0x56(%ebx)
    ip->size = dip->size;
801017ab:	8b 50 fc             	mov    -0x4(%eax),%edx
801017ae:	89 53 58             	mov    %edx,0x58(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801017b1:	6a 34                	push   $0x34
801017b3:	50                   	push   %eax
801017b4:	8d 43 5c             	lea    0x5c(%ebx),%eax
801017b7:	50                   	push   %eax
801017b8:	e8 d3 2e 00 00       	call   80104690 <memmove>
    brelse(bp);
801017bd:	89 34 24             	mov    %esi,(%esp)
801017c0:	e8 2b ea ff ff       	call   801001f0 <brelse>
    if(ip->type == 0)
801017c5:	83 c4 10             	add    $0x10,%esp
801017c8:	66 83 7b 50 00       	cmpw   $0x0,0x50(%ebx)
    ip->valid = 1;
801017cd:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
    if(ip->type == 0)
801017d4:	0f 85 77 ff ff ff    	jne    80101751 <ilock+0x31>
      panic("ilock: no type");
801017da:	83 ec 0c             	sub    $0xc,%esp
801017dd:	68 30 71 10 80       	push   $0x80107130
801017e2:	e8 a9 eb ff ff       	call   80100390 <panic>
    panic("ilock");
801017e7:	83 ec 0c             	sub    $0xc,%esp
801017ea:	68 2a 71 10 80       	push   $0x8010712a
801017ef:	e8 9c eb ff ff       	call   80100390 <panic>
801017f4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801017fb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801017ff:	90                   	nop

80101800 <iunlock>:
{
80101800:	55                   	push   %ebp
80101801:	89 e5                	mov    %esp,%ebp
80101803:	56                   	push   %esi
80101804:	53                   	push   %ebx
80101805:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101808:	85 db                	test   %ebx,%ebx
8010180a:	74 28                	je     80101834 <iunlock+0x34>
8010180c:	83 ec 0c             	sub    $0xc,%esp
8010180f:	8d 73 0c             	lea    0xc(%ebx),%esi
80101812:	56                   	push   %esi
80101813:	e8 18 2b 00 00       	call   80104330 <holdingsleep>
80101818:	83 c4 10             	add    $0x10,%esp
8010181b:	85 c0                	test   %eax,%eax
8010181d:	74 15                	je     80101834 <iunlock+0x34>
8010181f:	8b 43 08             	mov    0x8(%ebx),%eax
80101822:	85 c0                	test   %eax,%eax
80101824:	7e 0e                	jle    80101834 <iunlock+0x34>
  releasesleep(&ip->lock);
80101826:	89 75 08             	mov    %esi,0x8(%ebp)
}
80101829:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010182c:	5b                   	pop    %ebx
8010182d:	5e                   	pop    %esi
8010182e:	5d                   	pop    %ebp
  releasesleep(&ip->lock);
8010182f:	e9 bc 2a 00 00       	jmp    801042f0 <releasesleep>
    panic("iunlock");
80101834:	83 ec 0c             	sub    $0xc,%esp
80101837:	68 3f 71 10 80       	push   $0x8010713f
8010183c:	e8 4f eb ff ff       	call   80100390 <panic>
80101841:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101848:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010184f:	90                   	nop

80101850 <iput>:
{
80101850:	55                   	push   %ebp
80101851:	89 e5                	mov    %esp,%ebp
80101853:	57                   	push   %edi
80101854:	56                   	push   %esi
80101855:	53                   	push   %ebx
80101856:	83 ec 28             	sub    $0x28,%esp
80101859:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquiresleep(&ip->lock);
8010185c:	8d 7b 0c             	lea    0xc(%ebx),%edi
8010185f:	57                   	push   %edi
80101860:	e8 2b 2a 00 00       	call   80104290 <acquiresleep>
  if(ip->valid && ip->nlink == 0){
80101865:	8b 53 4c             	mov    0x4c(%ebx),%edx
80101868:	83 c4 10             	add    $0x10,%esp
8010186b:	85 d2                	test   %edx,%edx
8010186d:	74 07                	je     80101876 <iput+0x26>
8010186f:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
80101874:	74 32                	je     801018a8 <iput+0x58>
  releasesleep(&ip->lock);
80101876:	83 ec 0c             	sub    $0xc,%esp
80101879:	57                   	push   %edi
8010187a:	e8 71 2a 00 00       	call   801042f0 <releasesleep>
  acquire(&icache.lock);
8010187f:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
80101886:	e8 55 2c 00 00       	call   801044e0 <acquire>
  ip->ref--;
8010188b:	83 6b 08 01          	subl   $0x1,0x8(%ebx)
  release(&icache.lock);
8010188f:	83 c4 10             	add    $0x10,%esp
80101892:	c7 45 08 e0 09 11 80 	movl   $0x801109e0,0x8(%ebp)
}
80101899:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010189c:	5b                   	pop    %ebx
8010189d:	5e                   	pop    %esi
8010189e:	5f                   	pop    %edi
8010189f:	5d                   	pop    %ebp
  release(&icache.lock);
801018a0:	e9 fb 2c 00 00       	jmp    801045a0 <release>
801018a5:	8d 76 00             	lea    0x0(%esi),%esi
    acquire(&icache.lock);
801018a8:	83 ec 0c             	sub    $0xc,%esp
801018ab:	68 e0 09 11 80       	push   $0x801109e0
801018b0:	e8 2b 2c 00 00       	call   801044e0 <acquire>
    int r = ip->ref;
801018b5:	8b 73 08             	mov    0x8(%ebx),%esi
    release(&icache.lock);
801018b8:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
801018bf:	e8 dc 2c 00 00       	call   801045a0 <release>
    if(r == 1){
801018c4:	83 c4 10             	add    $0x10,%esp
801018c7:	83 fe 01             	cmp    $0x1,%esi
801018ca:	75 aa                	jne    80101876 <iput+0x26>
801018cc:	8d 8b 8c 00 00 00    	lea    0x8c(%ebx),%ecx
801018d2:	89 7d e4             	mov    %edi,-0x1c(%ebp)
801018d5:	8d 73 5c             	lea    0x5c(%ebx),%esi
801018d8:	89 cf                	mov    %ecx,%edi
801018da:	eb 0b                	jmp    801018e7 <iput+0x97>
801018dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
801018e0:	83 c6 04             	add    $0x4,%esi
801018e3:	39 fe                	cmp    %edi,%esi
801018e5:	74 19                	je     80101900 <iput+0xb0>
    if(ip->addrs[i]){
801018e7:	8b 16                	mov    (%esi),%edx
801018e9:	85 d2                	test   %edx,%edx
801018eb:	74 f3                	je     801018e0 <iput+0x90>
      bfree(ip->dev, ip->addrs[i]);
801018ed:	8b 03                	mov    (%ebx),%eax
801018ef:	e8 ac fb ff ff       	call   801014a0 <bfree>
      ip->addrs[i] = 0;
801018f4:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
801018fa:	eb e4                	jmp    801018e0 <iput+0x90>
801018fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    }
  }

  if(ip->addrs[NDIRECT]){
80101900:	8b 83 8c 00 00 00    	mov    0x8c(%ebx),%eax
80101906:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101909:	85 c0                	test   %eax,%eax
8010190b:	75 33                	jne    80101940 <iput+0xf0>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
  iupdate(ip);
8010190d:	83 ec 0c             	sub    $0xc,%esp
  ip->size = 0;
80101910:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  iupdate(ip);
80101917:	53                   	push   %ebx
80101918:	e8 53 fd ff ff       	call   80101670 <iupdate>
      ip->type = 0;
8010191d:	31 c0                	xor    %eax,%eax
8010191f:	66 89 43 50          	mov    %ax,0x50(%ebx)
      iupdate(ip);
80101923:	89 1c 24             	mov    %ebx,(%esp)
80101926:	e8 45 fd ff ff       	call   80101670 <iupdate>
      ip->valid = 0;
8010192b:	c7 43 4c 00 00 00 00 	movl   $0x0,0x4c(%ebx)
80101932:	83 c4 10             	add    $0x10,%esp
80101935:	e9 3c ff ff ff       	jmp    80101876 <iput+0x26>
8010193a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
80101940:	83 ec 08             	sub    $0x8,%esp
80101943:	50                   	push   %eax
80101944:	ff 33                	pushl  (%ebx)
80101946:	e8 85 e7 ff ff       	call   801000d0 <bread>
8010194b:	89 7d e0             	mov    %edi,-0x20(%ebp)
8010194e:	83 c4 10             	add    $0x10,%esp
80101951:	8d 88 5c 02 00 00    	lea    0x25c(%eax),%ecx
80101957:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(j = 0; j < NINDIRECT; j++){
8010195a:	8d 70 5c             	lea    0x5c(%eax),%esi
8010195d:	89 cf                	mov    %ecx,%edi
8010195f:	eb 0e                	jmp    8010196f <iput+0x11f>
80101961:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101968:	83 c6 04             	add    $0x4,%esi
8010196b:	39 f7                	cmp    %esi,%edi
8010196d:	74 11                	je     80101980 <iput+0x130>
      if(a[j])
8010196f:	8b 16                	mov    (%esi),%edx
80101971:	85 d2                	test   %edx,%edx
80101973:	74 f3                	je     80101968 <iput+0x118>
        bfree(ip->dev, a[j]);
80101975:	8b 03                	mov    (%ebx),%eax
80101977:	e8 24 fb ff ff       	call   801014a0 <bfree>
8010197c:	eb ea                	jmp    80101968 <iput+0x118>
8010197e:	66 90                	xchg   %ax,%ax
    brelse(bp);
80101980:	83 ec 0c             	sub    $0xc,%esp
80101983:	ff 75 e4             	pushl  -0x1c(%ebp)
80101986:	8b 7d e0             	mov    -0x20(%ebp),%edi
80101989:	e8 62 e8 ff ff       	call   801001f0 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
8010198e:	8b 93 8c 00 00 00    	mov    0x8c(%ebx),%edx
80101994:	8b 03                	mov    (%ebx),%eax
80101996:	e8 05 fb ff ff       	call   801014a0 <bfree>
    ip->addrs[NDIRECT] = 0;
8010199b:	83 c4 10             	add    $0x10,%esp
8010199e:	c7 83 8c 00 00 00 00 	movl   $0x0,0x8c(%ebx)
801019a5:	00 00 00 
801019a8:	e9 60 ff ff ff       	jmp    8010190d <iput+0xbd>
801019ad:	8d 76 00             	lea    0x0(%esi),%esi

801019b0 <iunlockput>:
{
801019b0:	55                   	push   %ebp
801019b1:	89 e5                	mov    %esp,%ebp
801019b3:	53                   	push   %ebx
801019b4:	83 ec 10             	sub    $0x10,%esp
801019b7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  iunlock(ip);
801019ba:	53                   	push   %ebx
801019bb:	e8 40 fe ff ff       	call   80101800 <iunlock>
  iput(ip);
801019c0:	89 5d 08             	mov    %ebx,0x8(%ebp)
801019c3:	83 c4 10             	add    $0x10,%esp
}
801019c6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801019c9:	c9                   	leave  
  iput(ip);
801019ca:	e9 81 fe ff ff       	jmp    80101850 <iput>
801019cf:	90                   	nop

801019d0 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
801019d0:	55                   	push   %ebp
801019d1:	89 e5                	mov    %esp,%ebp
801019d3:	8b 55 08             	mov    0x8(%ebp),%edx
801019d6:	8b 45 0c             	mov    0xc(%ebp),%eax
  st->dev = ip->dev;
801019d9:	8b 0a                	mov    (%edx),%ecx
801019db:	89 48 04             	mov    %ecx,0x4(%eax)
  st->ino = ip->inum;
801019de:	8b 4a 04             	mov    0x4(%edx),%ecx
801019e1:	89 48 08             	mov    %ecx,0x8(%eax)
  st->type = ip->type;
801019e4:	0f b7 4a 50          	movzwl 0x50(%edx),%ecx
801019e8:	66 89 08             	mov    %cx,(%eax)
  st->nlink = ip->nlink;
801019eb:	0f b7 4a 56          	movzwl 0x56(%edx),%ecx
801019ef:	66 89 48 0c          	mov    %cx,0xc(%eax)
  st->size = ip->size;
801019f3:	8b 52 58             	mov    0x58(%edx),%edx
801019f6:	89 50 10             	mov    %edx,0x10(%eax)
}
801019f9:	5d                   	pop    %ebp
801019fa:	c3                   	ret    
801019fb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801019ff:	90                   	nop

80101a00 <readi>:
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101a00:	55                   	push   %ebp
80101a01:	89 e5                	mov    %esp,%ebp
80101a03:	57                   	push   %edi
80101a04:	56                   	push   %esi
80101a05:	53                   	push   %ebx
80101a06:	83 ec 1c             	sub    $0x1c,%esp
80101a09:	8b 7d 0c             	mov    0xc(%ebp),%edi
80101a0c:	8b 45 08             	mov    0x8(%ebp),%eax
80101a0f:	8b 75 10             	mov    0x10(%ebp),%esi
80101a12:	89 7d e0             	mov    %edi,-0x20(%ebp)
80101a15:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101a18:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101a1d:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101a20:	89 7d e4             	mov    %edi,-0x1c(%ebp)
  if(ip->type == T_DEV){
80101a23:	0f 84 a7 00 00 00    	je     80101ad0 <readi+0xd0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  }

  if(off > ip->size || off + n < off)
80101a29:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101a2c:	8b 40 58             	mov    0x58(%eax),%eax
80101a2f:	39 c6                	cmp    %eax,%esi
80101a31:	0f 87 ba 00 00 00    	ja     80101af1 <readi+0xf1>
80101a37:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101a3a:	31 c9                	xor    %ecx,%ecx
80101a3c:	89 da                	mov    %ebx,%edx
80101a3e:	01 f2                	add    %esi,%edx
80101a40:	0f 92 c1             	setb   %cl
80101a43:	89 cf                	mov    %ecx,%edi
80101a45:	0f 82 a6 00 00 00    	jb     80101af1 <readi+0xf1>
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
80101a4b:	89 c1                	mov    %eax,%ecx
80101a4d:	29 f1                	sub    %esi,%ecx
80101a4f:	39 d0                	cmp    %edx,%eax
80101a51:	0f 43 cb             	cmovae %ebx,%ecx
80101a54:	89 4d e4             	mov    %ecx,-0x1c(%ebp)

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101a57:	85 c9                	test   %ecx,%ecx
80101a59:	74 67                	je     80101ac2 <readi+0xc2>
80101a5b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101a5f:	90                   	nop
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101a60:	8b 5d d8             	mov    -0x28(%ebp),%ebx
80101a63:	89 f2                	mov    %esi,%edx
80101a65:	c1 ea 09             	shr    $0x9,%edx
80101a68:	89 d8                	mov    %ebx,%eax
80101a6a:	e8 21 f9 ff ff       	call   80101390 <bmap>
80101a6f:	83 ec 08             	sub    $0x8,%esp
80101a72:	50                   	push   %eax
80101a73:	ff 33                	pushl  (%ebx)
80101a75:	e8 56 e6 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101a7a:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101a7d:	b9 00 02 00 00       	mov    $0x200,%ecx
80101a82:	83 c4 0c             	add    $0xc,%esp
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101a85:	89 c2                	mov    %eax,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
80101a87:	89 f0                	mov    %esi,%eax
80101a89:	25 ff 01 00 00       	and    $0x1ff,%eax
80101a8e:	29 fb                	sub    %edi,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101a90:	89 55 dc             	mov    %edx,-0x24(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
80101a93:	29 c1                	sub    %eax,%ecx
    memmove(dst, bp->data + off%BSIZE, m);
80101a95:	8d 44 02 5c          	lea    0x5c(%edx,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101a99:	39 d9                	cmp    %ebx,%ecx
80101a9b:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101a9e:	53                   	push   %ebx
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101a9f:	01 df                	add    %ebx,%edi
80101aa1:	01 de                	add    %ebx,%esi
    memmove(dst, bp->data + off%BSIZE, m);
80101aa3:	50                   	push   %eax
80101aa4:	ff 75 e0             	pushl  -0x20(%ebp)
80101aa7:	e8 e4 2b 00 00       	call   80104690 <memmove>
    brelse(bp);
80101aac:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101aaf:	89 14 24             	mov    %edx,(%esp)
80101ab2:	e8 39 e7 ff ff       	call   801001f0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101ab7:	01 5d e0             	add    %ebx,-0x20(%ebp)
80101aba:	83 c4 10             	add    $0x10,%esp
80101abd:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101ac0:	77 9e                	ja     80101a60 <readi+0x60>
  }
  return n;
80101ac2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
80101ac5:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101ac8:	5b                   	pop    %ebx
80101ac9:	5e                   	pop    %esi
80101aca:	5f                   	pop    %edi
80101acb:	5d                   	pop    %ebp
80101acc:	c3                   	ret    
80101acd:	8d 76 00             	lea    0x0(%esi),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101ad0:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101ad4:	66 83 f8 09          	cmp    $0x9,%ax
80101ad8:	77 17                	ja     80101af1 <readi+0xf1>
80101ada:	8b 04 c5 60 09 11 80 	mov    -0x7feef6a0(,%eax,8),%eax
80101ae1:	85 c0                	test   %eax,%eax
80101ae3:	74 0c                	je     80101af1 <readi+0xf1>
    return devsw[ip->major].read(ip, dst, n);
80101ae5:	89 7d 10             	mov    %edi,0x10(%ebp)
}
80101ae8:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101aeb:	5b                   	pop    %ebx
80101aec:	5e                   	pop    %esi
80101aed:	5f                   	pop    %edi
80101aee:	5d                   	pop    %ebp
    return devsw[ip->major].read(ip, dst, n);
80101aef:	ff e0                	jmp    *%eax
      return -1;
80101af1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101af6:	eb cd                	jmp    80101ac5 <readi+0xc5>
80101af8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101aff:	90                   	nop

80101b00 <writei>:
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101b00:	55                   	push   %ebp
80101b01:	89 e5                	mov    %esp,%ebp
80101b03:	57                   	push   %edi
80101b04:	56                   	push   %esi
80101b05:	53                   	push   %ebx
80101b06:	83 ec 1c             	sub    $0x1c,%esp
80101b09:	8b 45 08             	mov    0x8(%ebp),%eax
80101b0c:	8b 75 0c             	mov    0xc(%ebp),%esi
80101b0f:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101b12:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101b17:	89 75 dc             	mov    %esi,-0x24(%ebp)
80101b1a:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101b1d:	8b 75 10             	mov    0x10(%ebp),%esi
80101b20:	89 7d e0             	mov    %edi,-0x20(%ebp)
  if(ip->type == T_DEV){
80101b23:	0f 84 b7 00 00 00    	je     80101be0 <writei+0xe0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  }

  if(off > ip->size || off + n < off)
80101b29:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101b2c:	39 70 58             	cmp    %esi,0x58(%eax)
80101b2f:	0f 82 e7 00 00 00    	jb     80101c1c <writei+0x11c>
    return -1;
  if(off + n > MAXFILE*BSIZE)
80101b35:	8b 7d e0             	mov    -0x20(%ebp),%edi
80101b38:	89 f8                	mov    %edi,%eax
80101b3a:	01 f0                	add    %esi,%eax
80101b3c:	0f 82 da 00 00 00    	jb     80101c1c <writei+0x11c>
80101b42:	3d 00 18 01 00       	cmp    $0x11800,%eax
80101b47:	0f 87 cf 00 00 00    	ja     80101c1c <writei+0x11c>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101b4d:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80101b54:	85 ff                	test   %edi,%edi
80101b56:	74 79                	je     80101bd1 <writei+0xd1>
80101b58:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101b5f:	90                   	nop
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101b60:	8b 7d d8             	mov    -0x28(%ebp),%edi
80101b63:	89 f2                	mov    %esi,%edx
80101b65:	c1 ea 09             	shr    $0x9,%edx
80101b68:	89 f8                	mov    %edi,%eax
80101b6a:	e8 21 f8 ff ff       	call   80101390 <bmap>
80101b6f:	83 ec 08             	sub    $0x8,%esp
80101b72:	50                   	push   %eax
80101b73:	ff 37                	pushl  (%edi)
80101b75:	e8 56 e5 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101b7a:	b9 00 02 00 00       	mov    $0x200,%ecx
80101b7f:	8b 5d e0             	mov    -0x20(%ebp),%ebx
80101b82:	2b 5d e4             	sub    -0x1c(%ebp),%ebx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101b85:	89 c7                	mov    %eax,%edi
    m = min(n - tot, BSIZE - off%BSIZE);
80101b87:	89 f0                	mov    %esi,%eax
80101b89:	83 c4 0c             	add    $0xc,%esp
80101b8c:	25 ff 01 00 00       	and    $0x1ff,%eax
80101b91:	29 c1                	sub    %eax,%ecx
    memmove(bp->data + off%BSIZE, src, m);
80101b93:	8d 44 07 5c          	lea    0x5c(%edi,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101b97:	39 d9                	cmp    %ebx,%ecx
80101b99:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(bp->data + off%BSIZE, src, m);
80101b9c:	53                   	push   %ebx
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101b9d:	01 de                	add    %ebx,%esi
    memmove(bp->data + off%BSIZE, src, m);
80101b9f:	ff 75 dc             	pushl  -0x24(%ebp)
80101ba2:	50                   	push   %eax
80101ba3:	e8 e8 2a 00 00       	call   80104690 <memmove>
    log_write(bp);
80101ba8:	89 3c 24             	mov    %edi,(%esp)
80101bab:	e8 50 13 00 00       	call   80102f00 <log_write>
    brelse(bp);
80101bb0:	89 3c 24             	mov    %edi,(%esp)
80101bb3:	e8 38 e6 ff ff       	call   801001f0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101bb8:	01 5d e4             	add    %ebx,-0x1c(%ebp)
80101bbb:	83 c4 10             	add    $0x10,%esp
80101bbe:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101bc1:	01 5d dc             	add    %ebx,-0x24(%ebp)
80101bc4:	39 45 e0             	cmp    %eax,-0x20(%ebp)
80101bc7:	77 97                	ja     80101b60 <writei+0x60>
  }

  if(n > 0 && off > ip->size){
80101bc9:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101bcc:	3b 70 58             	cmp    0x58(%eax),%esi
80101bcf:	77 37                	ja     80101c08 <writei+0x108>
    ip->size = off;
    iupdate(ip);
  }
  return n;
80101bd1:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
80101bd4:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101bd7:	5b                   	pop    %ebx
80101bd8:	5e                   	pop    %esi
80101bd9:	5f                   	pop    %edi
80101bda:	5d                   	pop    %ebp
80101bdb:	c3                   	ret    
80101bdc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80101be0:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101be4:	66 83 f8 09          	cmp    $0x9,%ax
80101be8:	77 32                	ja     80101c1c <writei+0x11c>
80101bea:	8b 04 c5 64 09 11 80 	mov    -0x7feef69c(,%eax,8),%eax
80101bf1:	85 c0                	test   %eax,%eax
80101bf3:	74 27                	je     80101c1c <writei+0x11c>
    return devsw[ip->major].write(ip, src, n);
80101bf5:	89 7d 10             	mov    %edi,0x10(%ebp)
}
80101bf8:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101bfb:	5b                   	pop    %ebx
80101bfc:	5e                   	pop    %esi
80101bfd:	5f                   	pop    %edi
80101bfe:	5d                   	pop    %ebp
    return devsw[ip->major].write(ip, src, n);
80101bff:	ff e0                	jmp    *%eax
80101c01:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    ip->size = off;
80101c08:	8b 45 d8             	mov    -0x28(%ebp),%eax
    iupdate(ip);
80101c0b:	83 ec 0c             	sub    $0xc,%esp
    ip->size = off;
80101c0e:	89 70 58             	mov    %esi,0x58(%eax)
    iupdate(ip);
80101c11:	50                   	push   %eax
80101c12:	e8 59 fa ff ff       	call   80101670 <iupdate>
80101c17:	83 c4 10             	add    $0x10,%esp
80101c1a:	eb b5                	jmp    80101bd1 <writei+0xd1>
      return -1;
80101c1c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101c21:	eb b1                	jmp    80101bd4 <writei+0xd4>
80101c23:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101c2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101c30 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
80101c30:	55                   	push   %ebp
80101c31:	89 e5                	mov    %esp,%ebp
80101c33:	83 ec 0c             	sub    $0xc,%esp
  return strncmp(s, t, DIRSIZ);
80101c36:	6a 0e                	push   $0xe
80101c38:	ff 75 0c             	pushl  0xc(%ebp)
80101c3b:	ff 75 08             	pushl  0x8(%ebp)
80101c3e:	e8 bd 2a 00 00       	call   80104700 <strncmp>
}
80101c43:	c9                   	leave  
80101c44:	c3                   	ret    
80101c45:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101c4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101c50 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
80101c50:	55                   	push   %ebp
80101c51:	89 e5                	mov    %esp,%ebp
80101c53:	57                   	push   %edi
80101c54:	56                   	push   %esi
80101c55:	53                   	push   %ebx
80101c56:	83 ec 1c             	sub    $0x1c,%esp
80101c59:	8b 5d 08             	mov    0x8(%ebp),%ebx
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
80101c5c:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80101c61:	0f 85 85 00 00 00    	jne    80101cec <dirlookup+0x9c>
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
80101c67:	8b 53 58             	mov    0x58(%ebx),%edx
80101c6a:	31 ff                	xor    %edi,%edi
80101c6c:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101c6f:	85 d2                	test   %edx,%edx
80101c71:	74 3e                	je     80101cb1 <dirlookup+0x61>
80101c73:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101c77:	90                   	nop
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101c78:	6a 10                	push   $0x10
80101c7a:	57                   	push   %edi
80101c7b:	56                   	push   %esi
80101c7c:	53                   	push   %ebx
80101c7d:	e8 7e fd ff ff       	call   80101a00 <readi>
80101c82:	83 c4 10             	add    $0x10,%esp
80101c85:	83 f8 10             	cmp    $0x10,%eax
80101c88:	75 55                	jne    80101cdf <dirlookup+0x8f>
      panic("dirlookup read");
    if(de.inum == 0)
80101c8a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101c8f:	74 18                	je     80101ca9 <dirlookup+0x59>
  return strncmp(s, t, DIRSIZ);
80101c91:	83 ec 04             	sub    $0x4,%esp
80101c94:	8d 45 da             	lea    -0x26(%ebp),%eax
80101c97:	6a 0e                	push   $0xe
80101c99:	50                   	push   %eax
80101c9a:	ff 75 0c             	pushl  0xc(%ebp)
80101c9d:	e8 5e 2a 00 00       	call   80104700 <strncmp>
      continue;
    if(namecmp(name, de.name) == 0){
80101ca2:	83 c4 10             	add    $0x10,%esp
80101ca5:	85 c0                	test   %eax,%eax
80101ca7:	74 17                	je     80101cc0 <dirlookup+0x70>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101ca9:	83 c7 10             	add    $0x10,%edi
80101cac:	3b 7b 58             	cmp    0x58(%ebx),%edi
80101caf:	72 c7                	jb     80101c78 <dirlookup+0x28>
      return iget(dp->dev, inum);
    }
  }

  return 0;
}
80101cb1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80101cb4:	31 c0                	xor    %eax,%eax
}
80101cb6:	5b                   	pop    %ebx
80101cb7:	5e                   	pop    %esi
80101cb8:	5f                   	pop    %edi
80101cb9:	5d                   	pop    %ebp
80101cba:	c3                   	ret    
80101cbb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101cbf:	90                   	nop
      if(poff)
80101cc0:	8b 45 10             	mov    0x10(%ebp),%eax
80101cc3:	85 c0                	test   %eax,%eax
80101cc5:	74 05                	je     80101ccc <dirlookup+0x7c>
        *poff = off;
80101cc7:	8b 45 10             	mov    0x10(%ebp),%eax
80101cca:	89 38                	mov    %edi,(%eax)
      inum = de.inum;
80101ccc:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
      return iget(dp->dev, inum);
80101cd0:	8b 03                	mov    (%ebx),%eax
80101cd2:	e8 c9 f5 ff ff       	call   801012a0 <iget>
}
80101cd7:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101cda:	5b                   	pop    %ebx
80101cdb:	5e                   	pop    %esi
80101cdc:	5f                   	pop    %edi
80101cdd:	5d                   	pop    %ebp
80101cde:	c3                   	ret    
      panic("dirlookup read");
80101cdf:	83 ec 0c             	sub    $0xc,%esp
80101ce2:	68 59 71 10 80       	push   $0x80107159
80101ce7:	e8 a4 e6 ff ff       	call   80100390 <panic>
    panic("dirlookup not DIR");
80101cec:	83 ec 0c             	sub    $0xc,%esp
80101cef:	68 47 71 10 80       	push   $0x80107147
80101cf4:	e8 97 e6 ff ff       	call   80100390 <panic>
80101cf9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101d00 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80101d00:	55                   	push   %ebp
80101d01:	89 e5                	mov    %esp,%ebp
80101d03:	57                   	push   %edi
80101d04:	56                   	push   %esi
80101d05:	53                   	push   %ebx
80101d06:	89 c3                	mov    %eax,%ebx
80101d08:	83 ec 1c             	sub    $0x1c,%esp
  struct inode *ip, *next;

  if(*path == '/')
80101d0b:	80 38 2f             	cmpb   $0x2f,(%eax)
{
80101d0e:	89 55 e0             	mov    %edx,-0x20(%ebp)
80101d11:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  if(*path == '/')
80101d14:	0f 84 86 01 00 00    	je     80101ea0 <namex+0x1a0>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
80101d1a:	e8 41 1c 00 00       	call   80103960 <myproc>
  acquire(&icache.lock);
80101d1f:	83 ec 0c             	sub    $0xc,%esp
80101d22:	89 df                	mov    %ebx,%edi
    ip = idup(myproc()->cwd);
80101d24:	8b 70 68             	mov    0x68(%eax),%esi
  acquire(&icache.lock);
80101d27:	68 e0 09 11 80       	push   $0x801109e0
80101d2c:	e8 af 27 00 00       	call   801044e0 <acquire>
  ip->ref++;
80101d31:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80101d35:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
80101d3c:	e8 5f 28 00 00       	call   801045a0 <release>
80101d41:	83 c4 10             	add    $0x10,%esp
80101d44:	eb 0d                	jmp    80101d53 <namex+0x53>
80101d46:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101d4d:	8d 76 00             	lea    0x0(%esi),%esi
    path++;
80101d50:	83 c7 01             	add    $0x1,%edi
  while(*path == '/')
80101d53:	0f b6 07             	movzbl (%edi),%eax
80101d56:	3c 2f                	cmp    $0x2f,%al
80101d58:	74 f6                	je     80101d50 <namex+0x50>
  if(*path == 0)
80101d5a:	84 c0                	test   %al,%al
80101d5c:	0f 84 ee 00 00 00    	je     80101e50 <namex+0x150>
  while(*path != '/' && *path != 0)
80101d62:	0f b6 07             	movzbl (%edi),%eax
80101d65:	84 c0                	test   %al,%al
80101d67:	0f 84 fb 00 00 00    	je     80101e68 <namex+0x168>
80101d6d:	89 fb                	mov    %edi,%ebx
80101d6f:	3c 2f                	cmp    $0x2f,%al
80101d71:	0f 84 f1 00 00 00    	je     80101e68 <namex+0x168>
80101d77:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101d7e:	66 90                	xchg   %ax,%ax
    path++;
80101d80:	83 c3 01             	add    $0x1,%ebx
  while(*path != '/' && *path != 0)
80101d83:	0f b6 03             	movzbl (%ebx),%eax
80101d86:	3c 2f                	cmp    $0x2f,%al
80101d88:	74 04                	je     80101d8e <namex+0x8e>
80101d8a:	84 c0                	test   %al,%al
80101d8c:	75 f2                	jne    80101d80 <namex+0x80>
  len = path - s;
80101d8e:	89 d8                	mov    %ebx,%eax
80101d90:	29 f8                	sub    %edi,%eax
  if(len >= DIRSIZ)
80101d92:	83 f8 0d             	cmp    $0xd,%eax
80101d95:	0f 8e 85 00 00 00    	jle    80101e20 <namex+0x120>
    memmove(name, s, DIRSIZ);
80101d9b:	83 ec 04             	sub    $0x4,%esp
80101d9e:	6a 0e                	push   $0xe
80101da0:	57                   	push   %edi
    path++;
80101da1:	89 df                	mov    %ebx,%edi
    memmove(name, s, DIRSIZ);
80101da3:	ff 75 e4             	pushl  -0x1c(%ebp)
80101da6:	e8 e5 28 00 00       	call   80104690 <memmove>
80101dab:	83 c4 10             	add    $0x10,%esp
  while(*path == '/')
80101dae:	80 3b 2f             	cmpb   $0x2f,(%ebx)
80101db1:	75 0d                	jne    80101dc0 <namex+0xc0>
80101db3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101db7:	90                   	nop
    path++;
80101db8:	83 c7 01             	add    $0x1,%edi
  while(*path == '/')
80101dbb:	80 3f 2f             	cmpb   $0x2f,(%edi)
80101dbe:	74 f8                	je     80101db8 <namex+0xb8>

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
80101dc0:	83 ec 0c             	sub    $0xc,%esp
80101dc3:	56                   	push   %esi
80101dc4:	e8 57 f9 ff ff       	call   80101720 <ilock>
    if(ip->type != T_DIR){
80101dc9:	83 c4 10             	add    $0x10,%esp
80101dcc:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80101dd1:	0f 85 a1 00 00 00    	jne    80101e78 <namex+0x178>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
80101dd7:	8b 55 e0             	mov    -0x20(%ebp),%edx
80101dda:	85 d2                	test   %edx,%edx
80101ddc:	74 09                	je     80101de7 <namex+0xe7>
80101dde:	80 3f 00             	cmpb   $0x0,(%edi)
80101de1:	0f 84 d9 00 00 00    	je     80101ec0 <namex+0x1c0>
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
80101de7:	83 ec 04             	sub    $0x4,%esp
80101dea:	6a 00                	push   $0x0
80101dec:	ff 75 e4             	pushl  -0x1c(%ebp)
80101def:	56                   	push   %esi
80101df0:	e8 5b fe ff ff       	call   80101c50 <dirlookup>
80101df5:	83 c4 10             	add    $0x10,%esp
80101df8:	89 c3                	mov    %eax,%ebx
80101dfa:	85 c0                	test   %eax,%eax
80101dfc:	74 7a                	je     80101e78 <namex+0x178>
  iunlock(ip);
80101dfe:	83 ec 0c             	sub    $0xc,%esp
80101e01:	56                   	push   %esi
80101e02:	e8 f9 f9 ff ff       	call   80101800 <iunlock>
  iput(ip);
80101e07:	89 34 24             	mov    %esi,(%esp)
80101e0a:	89 de                	mov    %ebx,%esi
80101e0c:	e8 3f fa ff ff       	call   80101850 <iput>
  while(*path == '/')
80101e11:	83 c4 10             	add    $0x10,%esp
80101e14:	e9 3a ff ff ff       	jmp    80101d53 <namex+0x53>
80101e19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101e20:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101e23:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
80101e26:	89 4d dc             	mov    %ecx,-0x24(%ebp)
    memmove(name, s, len);
80101e29:	83 ec 04             	sub    $0x4,%esp
80101e2c:	50                   	push   %eax
80101e2d:	57                   	push   %edi
    name[len] = 0;
80101e2e:	89 df                	mov    %ebx,%edi
    memmove(name, s, len);
80101e30:	ff 75 e4             	pushl  -0x1c(%ebp)
80101e33:	e8 58 28 00 00       	call   80104690 <memmove>
    name[len] = 0;
80101e38:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101e3b:	83 c4 10             	add    $0x10,%esp
80101e3e:	c6 00 00             	movb   $0x0,(%eax)
80101e41:	e9 68 ff ff ff       	jmp    80101dae <namex+0xae>
80101e46:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101e4d:	8d 76 00             	lea    0x0(%esi),%esi
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
80101e50:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101e53:	85 c0                	test   %eax,%eax
80101e55:	0f 85 85 00 00 00    	jne    80101ee0 <namex+0x1e0>
    iput(ip);
    return 0;
  }
  return ip;
}
80101e5b:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101e5e:	89 f0                	mov    %esi,%eax
80101e60:	5b                   	pop    %ebx
80101e61:	5e                   	pop    %esi
80101e62:	5f                   	pop    %edi
80101e63:	5d                   	pop    %ebp
80101e64:	c3                   	ret    
80101e65:	8d 76 00             	lea    0x0(%esi),%esi
  while(*path != '/' && *path != 0)
80101e68:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101e6b:	89 fb                	mov    %edi,%ebx
80101e6d:	89 45 dc             	mov    %eax,-0x24(%ebp)
80101e70:	31 c0                	xor    %eax,%eax
80101e72:	eb b5                	jmp    80101e29 <namex+0x129>
80101e74:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  iunlock(ip);
80101e78:	83 ec 0c             	sub    $0xc,%esp
80101e7b:	56                   	push   %esi
80101e7c:	e8 7f f9 ff ff       	call   80101800 <iunlock>
  iput(ip);
80101e81:	89 34 24             	mov    %esi,(%esp)
      return 0;
80101e84:	31 f6                	xor    %esi,%esi
  iput(ip);
80101e86:	e8 c5 f9 ff ff       	call   80101850 <iput>
      return 0;
80101e8b:	83 c4 10             	add    $0x10,%esp
}
80101e8e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101e91:	89 f0                	mov    %esi,%eax
80101e93:	5b                   	pop    %ebx
80101e94:	5e                   	pop    %esi
80101e95:	5f                   	pop    %edi
80101e96:	5d                   	pop    %ebp
80101e97:	c3                   	ret    
80101e98:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101e9f:	90                   	nop
    ip = iget(ROOTDEV, ROOTINO);
80101ea0:	ba 01 00 00 00       	mov    $0x1,%edx
80101ea5:	b8 01 00 00 00       	mov    $0x1,%eax
80101eaa:	89 df                	mov    %ebx,%edi
80101eac:	e8 ef f3 ff ff       	call   801012a0 <iget>
80101eb1:	89 c6                	mov    %eax,%esi
80101eb3:	e9 9b fe ff ff       	jmp    80101d53 <namex+0x53>
80101eb8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101ebf:	90                   	nop
      iunlock(ip);
80101ec0:	83 ec 0c             	sub    $0xc,%esp
80101ec3:	56                   	push   %esi
80101ec4:	e8 37 f9 ff ff       	call   80101800 <iunlock>
      return ip;
80101ec9:	83 c4 10             	add    $0x10,%esp
}
80101ecc:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101ecf:	89 f0                	mov    %esi,%eax
80101ed1:	5b                   	pop    %ebx
80101ed2:	5e                   	pop    %esi
80101ed3:	5f                   	pop    %edi
80101ed4:	5d                   	pop    %ebp
80101ed5:	c3                   	ret    
80101ed6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101edd:	8d 76 00             	lea    0x0(%esi),%esi
    iput(ip);
80101ee0:	83 ec 0c             	sub    $0xc,%esp
80101ee3:	56                   	push   %esi
    return 0;
80101ee4:	31 f6                	xor    %esi,%esi
    iput(ip);
80101ee6:	e8 65 f9 ff ff       	call   80101850 <iput>
    return 0;
80101eeb:	83 c4 10             	add    $0x10,%esp
80101eee:	e9 68 ff ff ff       	jmp    80101e5b <namex+0x15b>
80101ef3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101efa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101f00 <dirlink>:
{
80101f00:	55                   	push   %ebp
80101f01:	89 e5                	mov    %esp,%ebp
80101f03:	57                   	push   %edi
80101f04:	56                   	push   %esi
80101f05:	53                   	push   %ebx
80101f06:	83 ec 20             	sub    $0x20,%esp
80101f09:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if((ip = dirlookup(dp, name, 0)) != 0){
80101f0c:	6a 00                	push   $0x0
80101f0e:	ff 75 0c             	pushl  0xc(%ebp)
80101f11:	53                   	push   %ebx
80101f12:	e8 39 fd ff ff       	call   80101c50 <dirlookup>
80101f17:	83 c4 10             	add    $0x10,%esp
80101f1a:	85 c0                	test   %eax,%eax
80101f1c:	75 67                	jne    80101f85 <dirlink+0x85>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101f1e:	8b 7b 58             	mov    0x58(%ebx),%edi
80101f21:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101f24:	85 ff                	test   %edi,%edi
80101f26:	74 29                	je     80101f51 <dirlink+0x51>
80101f28:	31 ff                	xor    %edi,%edi
80101f2a:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101f2d:	eb 09                	jmp    80101f38 <dirlink+0x38>
80101f2f:	90                   	nop
80101f30:	83 c7 10             	add    $0x10,%edi
80101f33:	3b 7b 58             	cmp    0x58(%ebx),%edi
80101f36:	73 19                	jae    80101f51 <dirlink+0x51>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101f38:	6a 10                	push   $0x10
80101f3a:	57                   	push   %edi
80101f3b:	56                   	push   %esi
80101f3c:	53                   	push   %ebx
80101f3d:	e8 be fa ff ff       	call   80101a00 <readi>
80101f42:	83 c4 10             	add    $0x10,%esp
80101f45:	83 f8 10             	cmp    $0x10,%eax
80101f48:	75 4e                	jne    80101f98 <dirlink+0x98>
    if(de.inum == 0)
80101f4a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101f4f:	75 df                	jne    80101f30 <dirlink+0x30>
  strncpy(de.name, name, DIRSIZ);
80101f51:	83 ec 04             	sub    $0x4,%esp
80101f54:	8d 45 da             	lea    -0x26(%ebp),%eax
80101f57:	6a 0e                	push   $0xe
80101f59:	ff 75 0c             	pushl  0xc(%ebp)
80101f5c:	50                   	push   %eax
80101f5d:	e8 fe 27 00 00       	call   80104760 <strncpy>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101f62:	6a 10                	push   $0x10
  de.inum = inum;
80101f64:	8b 45 10             	mov    0x10(%ebp),%eax
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101f67:	57                   	push   %edi
80101f68:	56                   	push   %esi
80101f69:	53                   	push   %ebx
  de.inum = inum;
80101f6a:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101f6e:	e8 8d fb ff ff       	call   80101b00 <writei>
80101f73:	83 c4 20             	add    $0x20,%esp
80101f76:	83 f8 10             	cmp    $0x10,%eax
80101f79:	75 2a                	jne    80101fa5 <dirlink+0xa5>
  return 0;
80101f7b:	31 c0                	xor    %eax,%eax
}
80101f7d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101f80:	5b                   	pop    %ebx
80101f81:	5e                   	pop    %esi
80101f82:	5f                   	pop    %edi
80101f83:	5d                   	pop    %ebp
80101f84:	c3                   	ret    
    iput(ip);
80101f85:	83 ec 0c             	sub    $0xc,%esp
80101f88:	50                   	push   %eax
80101f89:	e8 c2 f8 ff ff       	call   80101850 <iput>
    return -1;
80101f8e:	83 c4 10             	add    $0x10,%esp
80101f91:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101f96:	eb e5                	jmp    80101f7d <dirlink+0x7d>
      panic("dirlink read");
80101f98:	83 ec 0c             	sub    $0xc,%esp
80101f9b:	68 68 71 10 80       	push   $0x80107168
80101fa0:	e8 eb e3 ff ff       	call   80100390 <panic>
    panic("dirlink");
80101fa5:	83 ec 0c             	sub    $0xc,%esp
80101fa8:	68 62 77 10 80       	push   $0x80107762
80101fad:	e8 de e3 ff ff       	call   80100390 <panic>
80101fb2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101fb9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101fc0 <namei>:

struct inode*
namei(char *path)
{
80101fc0:	55                   	push   %ebp
  char name[DIRSIZ];
  return namex(path, 0, name);
80101fc1:	31 d2                	xor    %edx,%edx
{
80101fc3:	89 e5                	mov    %esp,%ebp
80101fc5:	83 ec 18             	sub    $0x18,%esp
  return namex(path, 0, name);
80101fc8:	8b 45 08             	mov    0x8(%ebp),%eax
80101fcb:	8d 4d ea             	lea    -0x16(%ebp),%ecx
80101fce:	e8 2d fd ff ff       	call   80101d00 <namex>
}
80101fd3:	c9                   	leave  
80101fd4:	c3                   	ret    
80101fd5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101fdc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101fe0 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
80101fe0:	55                   	push   %ebp
  return namex(path, 1, name);
80101fe1:	ba 01 00 00 00       	mov    $0x1,%edx
{
80101fe6:	89 e5                	mov    %esp,%ebp
  return namex(path, 1, name);
80101fe8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80101feb:	8b 45 08             	mov    0x8(%ebp),%eax
}
80101fee:	5d                   	pop    %ebp
  return namex(path, 1, name);
80101fef:	e9 0c fd ff ff       	jmp    80101d00 <namex>
80101ff4:	66 90                	xchg   %ax,%ax
80101ff6:	66 90                	xchg   %ax,%ax
80101ff8:	66 90                	xchg   %ax,%ax
80101ffa:	66 90                	xchg   %ax,%ax
80101ffc:	66 90                	xchg   %ax,%ax
80101ffe:	66 90                	xchg   %ax,%ax

80102000 <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
80102000:	55                   	push   %ebp
80102001:	89 e5                	mov    %esp,%ebp
80102003:	57                   	push   %edi
80102004:	56                   	push   %esi
80102005:	53                   	push   %ebx
80102006:	83 ec 0c             	sub    $0xc,%esp
  if(b == 0)
80102009:	85 c0                	test   %eax,%eax
8010200b:	0f 84 b4 00 00 00    	je     801020c5 <idestart+0xc5>
    panic("idestart");
  if(b->blockno >= FSSIZE)
80102011:	8b 70 08             	mov    0x8(%eax),%esi
80102014:	89 c3                	mov    %eax,%ebx
80102016:	81 fe e7 03 00 00    	cmp    $0x3e7,%esi
8010201c:	0f 87 96 00 00 00    	ja     801020b8 <idestart+0xb8>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102022:	b9 f7 01 00 00       	mov    $0x1f7,%ecx
80102027:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010202e:	66 90                	xchg   %ax,%ax
80102030:	89 ca                	mov    %ecx,%edx
80102032:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102033:	83 e0 c0             	and    $0xffffffc0,%eax
80102036:	3c 40                	cmp    $0x40,%al
80102038:	75 f6                	jne    80102030 <idestart+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010203a:	31 ff                	xor    %edi,%edi
8010203c:	ba f6 03 00 00       	mov    $0x3f6,%edx
80102041:	89 f8                	mov    %edi,%eax
80102043:	ee                   	out    %al,(%dx)
80102044:	b8 01 00 00 00       	mov    $0x1,%eax
80102049:	ba f2 01 00 00       	mov    $0x1f2,%edx
8010204e:	ee                   	out    %al,(%dx)
8010204f:	ba f3 01 00 00       	mov    $0x1f3,%edx
80102054:	89 f0                	mov    %esi,%eax
80102056:	ee                   	out    %al,(%dx)

  idewait(0);
  outb(0x3f6, 0);  // generate interrupt
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
80102057:	89 f0                	mov    %esi,%eax
80102059:	ba f4 01 00 00       	mov    $0x1f4,%edx
8010205e:	c1 f8 08             	sar    $0x8,%eax
80102061:	ee                   	out    %al,(%dx)
80102062:	ba f5 01 00 00       	mov    $0x1f5,%edx
80102067:	89 f8                	mov    %edi,%eax
80102069:	ee                   	out    %al,(%dx)
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
8010206a:	0f b6 43 04          	movzbl 0x4(%ebx),%eax
8010206e:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102073:	c1 e0 04             	shl    $0x4,%eax
80102076:	83 e0 10             	and    $0x10,%eax
80102079:	83 c8 e0             	or     $0xffffffe0,%eax
8010207c:	ee                   	out    %al,(%dx)
  if(b->flags & B_DIRTY){
8010207d:	f6 03 04             	testb  $0x4,(%ebx)
80102080:	75 16                	jne    80102098 <idestart+0x98>
80102082:	b8 20 00 00 00       	mov    $0x20,%eax
80102087:	89 ca                	mov    %ecx,%edx
80102089:	ee                   	out    %al,(%dx)
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, read_cmd);
  }
}
8010208a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010208d:	5b                   	pop    %ebx
8010208e:	5e                   	pop    %esi
8010208f:	5f                   	pop    %edi
80102090:	5d                   	pop    %ebp
80102091:	c3                   	ret    
80102092:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102098:	b8 30 00 00 00       	mov    $0x30,%eax
8010209d:	89 ca                	mov    %ecx,%edx
8010209f:	ee                   	out    %al,(%dx)
  asm volatile("cld; rep outsl" :
801020a0:	b9 80 00 00 00       	mov    $0x80,%ecx
    outsl(0x1f0, b->data, BSIZE/4);
801020a5:	8d 73 5c             	lea    0x5c(%ebx),%esi
801020a8:	ba f0 01 00 00       	mov    $0x1f0,%edx
801020ad:	fc                   	cld    
801020ae:	f3 6f                	rep outsl %ds:(%esi),(%dx)
}
801020b0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801020b3:	5b                   	pop    %ebx
801020b4:	5e                   	pop    %esi
801020b5:	5f                   	pop    %edi
801020b6:	5d                   	pop    %ebp
801020b7:	c3                   	ret    
    panic("incorrect blockno");
801020b8:	83 ec 0c             	sub    $0xc,%esp
801020bb:	68 d4 71 10 80       	push   $0x801071d4
801020c0:	e8 cb e2 ff ff       	call   80100390 <panic>
    panic("idestart");
801020c5:	83 ec 0c             	sub    $0xc,%esp
801020c8:	68 cb 71 10 80       	push   $0x801071cb
801020cd:	e8 be e2 ff ff       	call   80100390 <panic>
801020d2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801020d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801020e0 <ideinit>:
{
801020e0:	55                   	push   %ebp
801020e1:	89 e5                	mov    %esp,%ebp
801020e3:	83 ec 10             	sub    $0x10,%esp
  initlock(&idelock, "ide");
801020e6:	68 e6 71 10 80       	push   $0x801071e6
801020eb:	68 80 a5 10 80       	push   $0x8010a580
801020f0:	e8 8b 22 00 00       	call   80104380 <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
801020f5:	58                   	pop    %eax
801020f6:	a1 00 2d 11 80       	mov    0x80112d00,%eax
801020fb:	5a                   	pop    %edx
801020fc:	83 e8 01             	sub    $0x1,%eax
801020ff:	50                   	push   %eax
80102100:	6a 0e                	push   $0xe
80102102:	e8 a9 02 00 00       	call   801023b0 <ioapicenable>
80102107:	83 c4 10             	add    $0x10,%esp
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010210a:	ba f7 01 00 00       	mov    $0x1f7,%edx
8010210f:	90                   	nop
80102110:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102111:	83 e0 c0             	and    $0xffffffc0,%eax
80102114:	3c 40                	cmp    $0x40,%al
80102116:	75 f8                	jne    80102110 <ideinit+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102118:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
8010211d:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102122:	ee                   	out    %al,(%dx)
80102123:	b9 e8 03 00 00       	mov    $0x3e8,%ecx
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102128:	ba f7 01 00 00       	mov    $0x1f7,%edx
8010212d:	eb 06                	jmp    80102135 <ideinit+0x55>
8010212f:	90                   	nop
  for(i=0; i<1000; i++){
80102130:	83 e9 01             	sub    $0x1,%ecx
80102133:	74 0f                	je     80102144 <ideinit+0x64>
80102135:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
80102136:	84 c0                	test   %al,%al
80102138:	74 f6                	je     80102130 <ideinit+0x50>
      havedisk1 = 1;
8010213a:	c7 05 60 a5 10 80 01 	movl   $0x1,0x8010a560
80102141:	00 00 00 
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102144:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
80102149:	ba f6 01 00 00       	mov    $0x1f6,%edx
8010214e:	ee                   	out    %al,(%dx)
}
8010214f:	c9                   	leave  
80102150:	c3                   	ret    
80102151:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102158:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010215f:	90                   	nop

80102160 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
80102160:	55                   	push   %ebp
80102161:	89 e5                	mov    %esp,%ebp
80102163:	57                   	push   %edi
80102164:	56                   	push   %esi
80102165:	53                   	push   %ebx
80102166:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
80102169:	68 80 a5 10 80       	push   $0x8010a580
8010216e:	e8 6d 23 00 00       	call   801044e0 <acquire>

  if((b = idequeue) == 0){
80102173:	8b 1d 64 a5 10 80    	mov    0x8010a564,%ebx
80102179:	83 c4 10             	add    $0x10,%esp
8010217c:	85 db                	test   %ebx,%ebx
8010217e:	74 63                	je     801021e3 <ideintr+0x83>
    release(&idelock);
    return;
  }
  idequeue = b->qnext;
80102180:	8b 43 58             	mov    0x58(%ebx),%eax
80102183:	a3 64 a5 10 80       	mov    %eax,0x8010a564

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
80102188:	8b 33                	mov    (%ebx),%esi
8010218a:	f7 c6 04 00 00 00    	test   $0x4,%esi
80102190:	75 2f                	jne    801021c1 <ideintr+0x61>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102192:	ba f7 01 00 00       	mov    $0x1f7,%edx
80102197:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010219e:	66 90                	xchg   %ax,%ax
801021a0:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
801021a1:	89 c1                	mov    %eax,%ecx
801021a3:	83 e1 c0             	and    $0xffffffc0,%ecx
801021a6:	80 f9 40             	cmp    $0x40,%cl
801021a9:	75 f5                	jne    801021a0 <ideintr+0x40>
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
801021ab:	a8 21                	test   $0x21,%al
801021ad:	75 12                	jne    801021c1 <ideintr+0x61>
    insl(0x1f0, b->data, BSIZE/4);
801021af:	8d 7b 5c             	lea    0x5c(%ebx),%edi
  asm volatile("cld; rep insl" :
801021b2:	b9 80 00 00 00       	mov    $0x80,%ecx
801021b7:	ba f0 01 00 00       	mov    $0x1f0,%edx
801021bc:	fc                   	cld    
801021bd:	f3 6d                	rep insl (%dx),%es:(%edi)
801021bf:	8b 33                	mov    (%ebx),%esi

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
  b->flags &= ~B_DIRTY;
801021c1:	83 e6 fb             	and    $0xfffffffb,%esi
  wakeup(b);
801021c4:	83 ec 0c             	sub    $0xc,%esp
  b->flags &= ~B_DIRTY;
801021c7:	83 ce 02             	or     $0x2,%esi
801021ca:	89 33                	mov    %esi,(%ebx)
  wakeup(b);
801021cc:	53                   	push   %ebx
801021cd:	e8 de 1e 00 00       	call   801040b0 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
801021d2:	a1 64 a5 10 80       	mov    0x8010a564,%eax
801021d7:	83 c4 10             	add    $0x10,%esp
801021da:	85 c0                	test   %eax,%eax
801021dc:	74 05                	je     801021e3 <ideintr+0x83>
    idestart(idequeue);
801021de:	e8 1d fe ff ff       	call   80102000 <idestart>
    release(&idelock);
801021e3:	83 ec 0c             	sub    $0xc,%esp
801021e6:	68 80 a5 10 80       	push   $0x8010a580
801021eb:	e8 b0 23 00 00       	call   801045a0 <release>

  release(&idelock);
}
801021f0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801021f3:	5b                   	pop    %ebx
801021f4:	5e                   	pop    %esi
801021f5:	5f                   	pop    %edi
801021f6:	5d                   	pop    %ebp
801021f7:	c3                   	ret    
801021f8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801021ff:	90                   	nop

80102200 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
80102200:	55                   	push   %ebp
80102201:	89 e5                	mov    %esp,%ebp
80102203:	53                   	push   %ebx
80102204:	83 ec 10             	sub    $0x10,%esp
80102207:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!holdingsleep(&b->lock))
8010220a:	8d 43 0c             	lea    0xc(%ebx),%eax
8010220d:	50                   	push   %eax
8010220e:	e8 1d 21 00 00       	call   80104330 <holdingsleep>
80102213:	83 c4 10             	add    $0x10,%esp
80102216:	85 c0                	test   %eax,%eax
80102218:	0f 84 d3 00 00 00    	je     801022f1 <iderw+0xf1>
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
8010221e:	8b 03                	mov    (%ebx),%eax
80102220:	83 e0 06             	and    $0x6,%eax
80102223:	83 f8 02             	cmp    $0x2,%eax
80102226:	0f 84 b8 00 00 00    	je     801022e4 <iderw+0xe4>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
8010222c:	8b 53 04             	mov    0x4(%ebx),%edx
8010222f:	85 d2                	test   %edx,%edx
80102231:	74 0d                	je     80102240 <iderw+0x40>
80102233:	a1 60 a5 10 80       	mov    0x8010a560,%eax
80102238:	85 c0                	test   %eax,%eax
8010223a:	0f 84 97 00 00 00    	je     801022d7 <iderw+0xd7>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
80102240:	83 ec 0c             	sub    $0xc,%esp
80102243:	68 80 a5 10 80       	push   $0x8010a580
80102248:	e8 93 22 00 00       	call   801044e0 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010224d:	8b 15 64 a5 10 80    	mov    0x8010a564,%edx
  b->qnext = 0;
80102253:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010225a:	83 c4 10             	add    $0x10,%esp
8010225d:	85 d2                	test   %edx,%edx
8010225f:	75 09                	jne    8010226a <iderw+0x6a>
80102261:	eb 6d                	jmp    801022d0 <iderw+0xd0>
80102263:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102267:	90                   	nop
80102268:	89 c2                	mov    %eax,%edx
8010226a:	8b 42 58             	mov    0x58(%edx),%eax
8010226d:	85 c0                	test   %eax,%eax
8010226f:	75 f7                	jne    80102268 <iderw+0x68>
80102271:	83 c2 58             	add    $0x58,%edx
    ;
  *pp = b;
80102274:	89 1a                	mov    %ebx,(%edx)

  // Start disk if necessary.
  if(idequeue == b)
80102276:	39 1d 64 a5 10 80    	cmp    %ebx,0x8010a564
8010227c:	74 42                	je     801022c0 <iderw+0xc0>
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
8010227e:	8b 03                	mov    (%ebx),%eax
80102280:	83 e0 06             	and    $0x6,%eax
80102283:	83 f8 02             	cmp    $0x2,%eax
80102286:	74 23                	je     801022ab <iderw+0xab>
80102288:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010228f:	90                   	nop
    sleep(b, &idelock);
80102290:	83 ec 08             	sub    $0x8,%esp
80102293:	68 80 a5 10 80       	push   $0x8010a580
80102298:	53                   	push   %ebx
80102299:	e8 62 1c 00 00       	call   80103f00 <sleep>
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
8010229e:	8b 03                	mov    (%ebx),%eax
801022a0:	83 c4 10             	add    $0x10,%esp
801022a3:	83 e0 06             	and    $0x6,%eax
801022a6:	83 f8 02             	cmp    $0x2,%eax
801022a9:	75 e5                	jne    80102290 <iderw+0x90>
  }


  release(&idelock);
801022ab:	c7 45 08 80 a5 10 80 	movl   $0x8010a580,0x8(%ebp)
}
801022b2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801022b5:	c9                   	leave  
  release(&idelock);
801022b6:	e9 e5 22 00 00       	jmp    801045a0 <release>
801022bb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801022bf:	90                   	nop
    idestart(b);
801022c0:	89 d8                	mov    %ebx,%eax
801022c2:	e8 39 fd ff ff       	call   80102000 <idestart>
801022c7:	eb b5                	jmp    8010227e <iderw+0x7e>
801022c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801022d0:	ba 64 a5 10 80       	mov    $0x8010a564,%edx
801022d5:	eb 9d                	jmp    80102274 <iderw+0x74>
    panic("iderw: ide disk 1 not present");
801022d7:	83 ec 0c             	sub    $0xc,%esp
801022da:	68 15 72 10 80       	push   $0x80107215
801022df:	e8 ac e0 ff ff       	call   80100390 <panic>
    panic("iderw: nothing to do");
801022e4:	83 ec 0c             	sub    $0xc,%esp
801022e7:	68 00 72 10 80       	push   $0x80107200
801022ec:	e8 9f e0 ff ff       	call   80100390 <panic>
    panic("iderw: buf not locked");
801022f1:	83 ec 0c             	sub    $0xc,%esp
801022f4:	68 ea 71 10 80       	push   $0x801071ea
801022f9:	e8 92 e0 ff ff       	call   80100390 <panic>
801022fe:	66 90                	xchg   %ax,%ax

80102300 <ioapicinit>:
  ioapic->data = data;
}

void
ioapicinit(void)
{
80102300:	55                   	push   %ebp
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
80102301:	c7 05 34 26 11 80 00 	movl   $0xfec00000,0x80112634
80102308:	00 c0 fe 
{
8010230b:	89 e5                	mov    %esp,%ebp
8010230d:	56                   	push   %esi
8010230e:	53                   	push   %ebx
  ioapic->reg = reg;
8010230f:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
80102316:	00 00 00 
  return ioapic->data;
80102319:	8b 15 34 26 11 80    	mov    0x80112634,%edx
8010231f:	8b 72 10             	mov    0x10(%edx),%esi
  ioapic->reg = reg;
80102322:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
  return ioapic->data;
80102328:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
8010232e:	0f b6 15 60 27 11 80 	movzbl 0x80112760,%edx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
80102335:	c1 ee 10             	shr    $0x10,%esi
80102338:	89 f0                	mov    %esi,%eax
8010233a:	0f b6 f0             	movzbl %al,%esi
  return ioapic->data;
8010233d:	8b 41 10             	mov    0x10(%ecx),%eax
  id = ioapicread(REG_ID) >> 24;
80102340:	c1 e8 18             	shr    $0x18,%eax
  if(id != ioapicid)
80102343:	39 c2                	cmp    %eax,%edx
80102345:	74 16                	je     8010235d <ioapicinit+0x5d>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
80102347:	83 ec 0c             	sub    $0xc,%esp
8010234a:	68 34 72 10 80       	push   $0x80107234
8010234f:	e8 5c e3 ff ff       	call   801006b0 <cprintf>
80102354:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
8010235a:	83 c4 10             	add    $0x10,%esp
8010235d:	83 c6 21             	add    $0x21,%esi
{
80102360:	ba 10 00 00 00       	mov    $0x10,%edx
80102365:	b8 20 00 00 00       	mov    $0x20,%eax
8010236a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  ioapic->reg = reg;
80102370:	89 11                	mov    %edx,(%ecx)

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
80102372:	89 c3                	mov    %eax,%ebx
  ioapic->data = data;
80102374:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
8010237a:	83 c0 01             	add    $0x1,%eax
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
8010237d:	81 cb 00 00 01 00    	or     $0x10000,%ebx
  ioapic->data = data;
80102383:	89 59 10             	mov    %ebx,0x10(%ecx)
  ioapic->reg = reg;
80102386:	8d 5a 01             	lea    0x1(%edx),%ebx
80102389:	83 c2 02             	add    $0x2,%edx
8010238c:	89 19                	mov    %ebx,(%ecx)
  ioapic->data = data;
8010238e:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
80102394:	c7 41 10 00 00 00 00 	movl   $0x0,0x10(%ecx)
  for(i = 0; i <= maxintr; i++){
8010239b:	39 f0                	cmp    %esi,%eax
8010239d:	75 d1                	jne    80102370 <ioapicinit+0x70>
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
8010239f:	8d 65 f8             	lea    -0x8(%ebp),%esp
801023a2:	5b                   	pop    %ebx
801023a3:	5e                   	pop    %esi
801023a4:	5d                   	pop    %ebp
801023a5:	c3                   	ret    
801023a6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801023ad:	8d 76 00             	lea    0x0(%esi),%esi

801023b0 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
801023b0:	55                   	push   %ebp
  ioapic->reg = reg;
801023b1:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
{
801023b7:	89 e5                	mov    %esp,%ebp
801023b9:	8b 45 08             	mov    0x8(%ebp),%eax
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
801023bc:	8d 50 20             	lea    0x20(%eax),%edx
801023bf:	8d 44 00 10          	lea    0x10(%eax,%eax,1),%eax
  ioapic->reg = reg;
801023c3:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
801023c5:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801023cb:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
801023ce:	89 51 10             	mov    %edx,0x10(%ecx)
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801023d1:	8b 55 0c             	mov    0xc(%ebp),%edx
  ioapic->reg = reg;
801023d4:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
801023d6:	a1 34 26 11 80       	mov    0x80112634,%eax
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801023db:	c1 e2 18             	shl    $0x18,%edx
  ioapic->data = data;
801023de:	89 50 10             	mov    %edx,0x10(%eax)
}
801023e1:	5d                   	pop    %ebp
801023e2:	c3                   	ret    
801023e3:	66 90                	xchg   %ax,%ax
801023e5:	66 90                	xchg   %ax,%ax
801023e7:	66 90                	xchg   %ax,%ax
801023e9:	66 90                	xchg   %ax,%ax
801023eb:	66 90                	xchg   %ax,%ax
801023ed:	66 90                	xchg   %ax,%ax
801023ef:	90                   	nop

801023f0 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
801023f0:	55                   	push   %ebp
801023f1:	89 e5                	mov    %esp,%ebp
801023f3:	53                   	push   %ebx
801023f4:	83 ec 04             	sub    $0x4,%esp
801023f7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
801023fa:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
80102400:	75 76                	jne    80102478 <kfree+0x88>
80102402:	81 fb a8 54 11 80    	cmp    $0x801154a8,%ebx
80102408:	72 6e                	jb     80102478 <kfree+0x88>
8010240a:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80102410:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
80102415:	77 61                	ja     80102478 <kfree+0x88>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
80102417:	83 ec 04             	sub    $0x4,%esp
8010241a:	68 00 10 00 00       	push   $0x1000
8010241f:	6a 01                	push   $0x1
80102421:	53                   	push   %ebx
80102422:	e8 c9 21 00 00       	call   801045f0 <memset>

  if(kmem.use_lock)
80102427:	8b 15 74 26 11 80    	mov    0x80112674,%edx
8010242d:	83 c4 10             	add    $0x10,%esp
80102430:	85 d2                	test   %edx,%edx
80102432:	75 1c                	jne    80102450 <kfree+0x60>
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
80102434:	a1 78 26 11 80       	mov    0x80112678,%eax
80102439:	89 03                	mov    %eax,(%ebx)
  kmem.freelist = r;
  if(kmem.use_lock)
8010243b:	a1 74 26 11 80       	mov    0x80112674,%eax
  kmem.freelist = r;
80102440:	89 1d 78 26 11 80    	mov    %ebx,0x80112678
  if(kmem.use_lock)
80102446:	85 c0                	test   %eax,%eax
80102448:	75 1e                	jne    80102468 <kfree+0x78>
    release(&kmem.lock);
}
8010244a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010244d:	c9                   	leave  
8010244e:	c3                   	ret    
8010244f:	90                   	nop
    acquire(&kmem.lock);
80102450:	83 ec 0c             	sub    $0xc,%esp
80102453:	68 40 26 11 80       	push   $0x80112640
80102458:	e8 83 20 00 00       	call   801044e0 <acquire>
8010245d:	83 c4 10             	add    $0x10,%esp
80102460:	eb d2                	jmp    80102434 <kfree+0x44>
80102462:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    release(&kmem.lock);
80102468:	c7 45 08 40 26 11 80 	movl   $0x80112640,0x8(%ebp)
}
8010246f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102472:	c9                   	leave  
    release(&kmem.lock);
80102473:	e9 28 21 00 00       	jmp    801045a0 <release>
    panic("kfree");
80102478:	83 ec 0c             	sub    $0xc,%esp
8010247b:	68 66 72 10 80       	push   $0x80107266
80102480:	e8 0b df ff ff       	call   80100390 <panic>
80102485:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010248c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102490 <freerange>:
{
80102490:	55                   	push   %ebp
80102491:	89 e5                	mov    %esp,%ebp
80102493:	56                   	push   %esi
  p = (char*)PGROUNDUP((uint)vstart);
80102494:	8b 45 08             	mov    0x8(%ebp),%eax
{
80102497:	8b 75 0c             	mov    0xc(%ebp),%esi
8010249a:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
8010249b:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801024a1:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801024a7:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801024ad:	39 de                	cmp    %ebx,%esi
801024af:	72 23                	jb     801024d4 <freerange+0x44>
801024b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
801024b8:	83 ec 0c             	sub    $0xc,%esp
801024bb:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801024c1:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
801024c7:	50                   	push   %eax
801024c8:	e8 23 ff ff ff       	call   801023f0 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801024cd:	83 c4 10             	add    $0x10,%esp
801024d0:	39 f3                	cmp    %esi,%ebx
801024d2:	76 e4                	jbe    801024b8 <freerange+0x28>
}
801024d4:	8d 65 f8             	lea    -0x8(%ebp),%esp
801024d7:	5b                   	pop    %ebx
801024d8:	5e                   	pop    %esi
801024d9:	5d                   	pop    %ebp
801024da:	c3                   	ret    
801024db:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801024df:	90                   	nop

801024e0 <kinit1>:
{
801024e0:	55                   	push   %ebp
801024e1:	89 e5                	mov    %esp,%ebp
801024e3:	56                   	push   %esi
801024e4:	53                   	push   %ebx
801024e5:	8b 75 0c             	mov    0xc(%ebp),%esi
  initlock(&kmem.lock, "kmem");
801024e8:	83 ec 08             	sub    $0x8,%esp
801024eb:	68 6c 72 10 80       	push   $0x8010726c
801024f0:	68 40 26 11 80       	push   $0x80112640
801024f5:	e8 86 1e 00 00       	call   80104380 <initlock>
  p = (char*)PGROUNDUP((uint)vstart);
801024fa:	8b 45 08             	mov    0x8(%ebp),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801024fd:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 0;
80102500:	c7 05 74 26 11 80 00 	movl   $0x0,0x80112674
80102507:	00 00 00 
  p = (char*)PGROUNDUP((uint)vstart);
8010250a:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102510:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102516:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010251c:	39 de                	cmp    %ebx,%esi
8010251e:	72 1c                	jb     8010253c <kinit1+0x5c>
    kfree(p);
80102520:	83 ec 0c             	sub    $0xc,%esp
80102523:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102529:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
8010252f:	50                   	push   %eax
80102530:	e8 bb fe ff ff       	call   801023f0 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102535:	83 c4 10             	add    $0x10,%esp
80102538:	39 de                	cmp    %ebx,%esi
8010253a:	73 e4                	jae    80102520 <kinit1+0x40>
}
8010253c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010253f:	5b                   	pop    %ebx
80102540:	5e                   	pop    %esi
80102541:	5d                   	pop    %ebp
80102542:	c3                   	ret    
80102543:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010254a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102550 <kinit2>:
{
80102550:	55                   	push   %ebp
80102551:	89 e5                	mov    %esp,%ebp
80102553:	56                   	push   %esi
  p = (char*)PGROUNDUP((uint)vstart);
80102554:	8b 45 08             	mov    0x8(%ebp),%eax
{
80102557:	8b 75 0c             	mov    0xc(%ebp),%esi
8010255a:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
8010255b:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102561:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102567:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010256d:	39 de                	cmp    %ebx,%esi
8010256f:	72 23                	jb     80102594 <kinit2+0x44>
80102571:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
80102578:	83 ec 0c             	sub    $0xc,%esp
8010257b:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102581:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102587:	50                   	push   %eax
80102588:	e8 63 fe ff ff       	call   801023f0 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010258d:	83 c4 10             	add    $0x10,%esp
80102590:	39 de                	cmp    %ebx,%esi
80102592:	73 e4                	jae    80102578 <kinit2+0x28>
  kmem.use_lock = 1;
80102594:	c7 05 74 26 11 80 01 	movl   $0x1,0x80112674
8010259b:	00 00 00 
}
8010259e:	8d 65 f8             	lea    -0x8(%ebp),%esp
801025a1:	5b                   	pop    %ebx
801025a2:	5e                   	pop    %esi
801025a3:	5d                   	pop    %ebp
801025a4:	c3                   	ret    
801025a5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801025ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801025b0 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
char*
kalloc(void)
{
801025b0:	55                   	push   %ebp
801025b1:	89 e5                	mov    %esp,%ebp
801025b3:	53                   	push   %ebx
801025b4:	83 ec 04             	sub    $0x4,%esp
  struct run *r;

  if(kmem.use_lock)
801025b7:	a1 74 26 11 80       	mov    0x80112674,%eax
801025bc:	85 c0                	test   %eax,%eax
801025be:	75 20                	jne    801025e0 <kalloc+0x30>
    acquire(&kmem.lock);
  r = kmem.freelist;
801025c0:	8b 1d 78 26 11 80    	mov    0x80112678,%ebx
  if(r)
801025c6:	85 db                	test   %ebx,%ebx
801025c8:	74 07                	je     801025d1 <kalloc+0x21>
    kmem.freelist = r->next;
801025ca:	8b 03                	mov    (%ebx),%eax
801025cc:	a3 78 26 11 80       	mov    %eax,0x80112678
  if(kmem.use_lock)
    release(&kmem.lock);
  return (char*)r;
}
801025d1:	89 d8                	mov    %ebx,%eax
801025d3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801025d6:	c9                   	leave  
801025d7:	c3                   	ret    
801025d8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801025df:	90                   	nop
    acquire(&kmem.lock);
801025e0:	83 ec 0c             	sub    $0xc,%esp
801025e3:	68 40 26 11 80       	push   $0x80112640
801025e8:	e8 f3 1e 00 00       	call   801044e0 <acquire>
  r = kmem.freelist;
801025ed:	8b 1d 78 26 11 80    	mov    0x80112678,%ebx
  if(r)
801025f3:	83 c4 10             	add    $0x10,%esp
801025f6:	a1 74 26 11 80       	mov    0x80112674,%eax
801025fb:	85 db                	test   %ebx,%ebx
801025fd:	74 08                	je     80102607 <kalloc+0x57>
    kmem.freelist = r->next;
801025ff:	8b 13                	mov    (%ebx),%edx
80102601:	89 15 78 26 11 80    	mov    %edx,0x80112678
  if(kmem.use_lock)
80102607:	85 c0                	test   %eax,%eax
80102609:	74 c6                	je     801025d1 <kalloc+0x21>
    release(&kmem.lock);
8010260b:	83 ec 0c             	sub    $0xc,%esp
8010260e:	68 40 26 11 80       	push   $0x80112640
80102613:	e8 88 1f 00 00       	call   801045a0 <release>
}
80102618:	89 d8                	mov    %ebx,%eax
    release(&kmem.lock);
8010261a:	83 c4 10             	add    $0x10,%esp
}
8010261d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102620:	c9                   	leave  
80102621:	c3                   	ret    
80102622:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102629:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102630 <freemem>:

int
freemem(void)
{
80102630:	55                   	push   %ebp
80102631:	89 e5                	mov    %esp,%ebp
80102633:	53                   	push   %ebx
80102634:	83 ec 04             	sub    $0x4,%esp
  int freeMemBytes = 0;
  // Acquire lock to avoid race conditions
  if(kmem.use_lock)
80102637:	a1 74 26 11 80       	mov    0x80112674,%eax
8010263c:	85 c0                	test   %eax,%eax
8010263e:	75 40                	jne    80102680 <freemem+0x50>
  {
    acquire(&kmem.lock);
  }

  struct run *r;
  r = kmem.freelist;
80102640:	8b 15 78 26 11 80    	mov    0x80112678,%edx
  while(r)
80102646:	85 d2                	test   %edx,%edx
80102648:	74 59                	je     801026a3 <freemem+0x73>
  int freeMemBytes = 0;
8010264a:	31 db                	xor    %ebx,%ebx
8010264c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  {
    freeMemBytes += 4096;
    r = r->next;
80102650:	8b 12                	mov    (%edx),%edx
    freeMemBytes += 4096;
80102652:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  while(r)
80102658:	85 d2                	test   %edx,%edx
8010265a:	75 f4                	jne    80102650 <freemem+0x20>
  {
    freeMemBytes = -1;
  }

  // Release lock
  if(kmem.use_lock)
8010265c:	85 c0                	test   %eax,%eax
8010265e:	74 10                	je     80102670 <freemem+0x40>
  {
    release(&kmem.lock);
80102660:	83 ec 0c             	sub    $0xc,%esp
80102663:	68 40 26 11 80       	push   $0x80112640
80102668:	e8 33 1f 00 00       	call   801045a0 <release>
8010266d:	83 c4 10             	add    $0x10,%esp
  }
  
  return freeMemBytes;
}
80102670:	89 d8                	mov    %ebx,%eax
80102672:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102675:	c9                   	leave  
80102676:	c3                   	ret    
80102677:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010267e:	66 90                	xchg   %ax,%ax
    acquire(&kmem.lock);
80102680:	83 ec 0c             	sub    $0xc,%esp
80102683:	68 40 26 11 80       	push   $0x80112640
80102688:	e8 53 1e 00 00       	call   801044e0 <acquire>
  r = kmem.freelist;
8010268d:	8b 15 78 26 11 80    	mov    0x80112678,%edx
  while(r)
80102693:	83 c4 10             	add    $0x10,%esp
80102696:	a1 74 26 11 80       	mov    0x80112674,%eax
8010269b:	85 d2                	test   %edx,%edx
8010269d:	75 ab                	jne    8010264a <freemem+0x1a>
  int freeMemBytes = 0;
8010269f:	31 db                	xor    %ebx,%ebx
801026a1:	eb b9                	jmp    8010265c <freemem+0x2c>
801026a3:	31 db                	xor    %ebx,%ebx
801026a5:	eb c9                	jmp    80102670 <freemem+0x40>
801026a7:	66 90                	xchg   %ax,%ax
801026a9:	66 90                	xchg   %ax,%ax
801026ab:	66 90                	xchg   %ax,%ax
801026ad:	66 90                	xchg   %ax,%ax
801026af:	90                   	nop

801026b0 <kbdgetc>:
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801026b0:	ba 64 00 00 00       	mov    $0x64,%edx
801026b5:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
801026b6:	a8 01                	test   $0x1,%al
801026b8:	0f 84 c2 00 00 00    	je     80102780 <kbdgetc+0xd0>
{
801026be:	55                   	push   %ebp
801026bf:	ba 60 00 00 00       	mov    $0x60,%edx
801026c4:	89 e5                	mov    %esp,%ebp
801026c6:	53                   	push   %ebx
801026c7:	ec                   	in     (%dx),%al
    return -1;
  data = inb(KBDATAP);
801026c8:	0f b6 d0             	movzbl %al,%edx

  if(data == 0xE0){
801026cb:	8b 1d b4 a5 10 80    	mov    0x8010a5b4,%ebx
801026d1:	81 fa e0 00 00 00    	cmp    $0xe0,%edx
801026d7:	74 57                	je     80102730 <kbdgetc+0x80>
    shift |= E0ESC;
    return 0;
  } else if(data & 0x80){
801026d9:	89 d9                	mov    %ebx,%ecx
801026db:	83 e1 40             	and    $0x40,%ecx
801026de:	84 c0                	test   %al,%al
801026e0:	78 5e                	js     80102740 <kbdgetc+0x90>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
801026e2:	85 c9                	test   %ecx,%ecx
801026e4:	74 09                	je     801026ef <kbdgetc+0x3f>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
801026e6:	83 c8 80             	or     $0xffffff80,%eax
    shift &= ~E0ESC;
801026e9:	83 e3 bf             	and    $0xffffffbf,%ebx
    data |= 0x80;
801026ec:	0f b6 d0             	movzbl %al,%edx
  }

  shift |= shiftcode[data];
801026ef:	0f b6 8a a0 73 10 80 	movzbl -0x7fef8c60(%edx),%ecx
  shift ^= togglecode[data];
801026f6:	0f b6 82 a0 72 10 80 	movzbl -0x7fef8d60(%edx),%eax
  shift |= shiftcode[data];
801026fd:	09 d9                	or     %ebx,%ecx
  shift ^= togglecode[data];
801026ff:	31 c1                	xor    %eax,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
80102701:	89 c8                	mov    %ecx,%eax
  shift ^= togglecode[data];
80102703:	89 0d b4 a5 10 80    	mov    %ecx,0x8010a5b4
  c = charcode[shift & (CTL | SHIFT)][data];
80102709:	83 e0 03             	and    $0x3,%eax
  if(shift & CAPSLOCK){
8010270c:	83 e1 08             	and    $0x8,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
8010270f:	8b 04 85 80 72 10 80 	mov    -0x7fef8d80(,%eax,4),%eax
80102716:	0f b6 04 10          	movzbl (%eax,%edx,1),%eax
  if(shift & CAPSLOCK){
8010271a:	74 0b                	je     80102727 <kbdgetc+0x77>
    if('a' <= c && c <= 'z')
8010271c:	8d 50 9f             	lea    -0x61(%eax),%edx
8010271f:	83 fa 19             	cmp    $0x19,%edx
80102722:	77 44                	ja     80102768 <kbdgetc+0xb8>
      c += 'A' - 'a';
80102724:	83 e8 20             	sub    $0x20,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
80102727:	5b                   	pop    %ebx
80102728:	5d                   	pop    %ebp
80102729:	c3                   	ret    
8010272a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    shift |= E0ESC;
80102730:	83 cb 40             	or     $0x40,%ebx
    return 0;
80102733:	31 c0                	xor    %eax,%eax
    shift |= E0ESC;
80102735:	89 1d b4 a5 10 80    	mov    %ebx,0x8010a5b4
}
8010273b:	5b                   	pop    %ebx
8010273c:	5d                   	pop    %ebp
8010273d:	c3                   	ret    
8010273e:	66 90                	xchg   %ax,%ax
    data = (shift & E0ESC ? data : data & 0x7F);
80102740:	83 e0 7f             	and    $0x7f,%eax
80102743:	85 c9                	test   %ecx,%ecx
80102745:	0f 44 d0             	cmove  %eax,%edx
    return 0;
80102748:	31 c0                	xor    %eax,%eax
    shift &= ~(shiftcode[data] | E0ESC);
8010274a:	0f b6 8a a0 73 10 80 	movzbl -0x7fef8c60(%edx),%ecx
80102751:	83 c9 40             	or     $0x40,%ecx
80102754:	0f b6 c9             	movzbl %cl,%ecx
80102757:	f7 d1                	not    %ecx
80102759:	21 d9                	and    %ebx,%ecx
}
8010275b:	5b                   	pop    %ebx
8010275c:	5d                   	pop    %ebp
    shift &= ~(shiftcode[data] | E0ESC);
8010275d:	89 0d b4 a5 10 80    	mov    %ecx,0x8010a5b4
}
80102763:	c3                   	ret    
80102764:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    else if('A' <= c && c <= 'Z')
80102768:	8d 48 bf             	lea    -0x41(%eax),%ecx
      c += 'a' - 'A';
8010276b:	8d 50 20             	lea    0x20(%eax),%edx
}
8010276e:	5b                   	pop    %ebx
8010276f:	5d                   	pop    %ebp
      c += 'a' - 'A';
80102770:	83 f9 1a             	cmp    $0x1a,%ecx
80102773:	0f 42 c2             	cmovb  %edx,%eax
}
80102776:	c3                   	ret    
80102777:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010277e:	66 90                	xchg   %ax,%ax
    return -1;
80102780:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80102785:	c3                   	ret    
80102786:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010278d:	8d 76 00             	lea    0x0(%esi),%esi

80102790 <kbdintr>:

void
kbdintr(void)
{
80102790:	55                   	push   %ebp
80102791:	89 e5                	mov    %esp,%ebp
80102793:	83 ec 14             	sub    $0x14,%esp
  consoleintr(kbdgetc);
80102796:	68 b0 26 10 80       	push   $0x801026b0
8010279b:	e8 c0 e0 ff ff       	call   80100860 <consoleintr>
}
801027a0:	83 c4 10             	add    $0x10,%esp
801027a3:	c9                   	leave  
801027a4:	c3                   	ret    
801027a5:	66 90                	xchg   %ax,%ax
801027a7:	66 90                	xchg   %ax,%ax
801027a9:	66 90                	xchg   %ax,%ax
801027ab:	66 90                	xchg   %ax,%ax
801027ad:	66 90                	xchg   %ax,%ax
801027af:	90                   	nop

801027b0 <lapicinit>:
}

void
lapicinit(void)
{
  if(!lapic)
801027b0:	a1 7c 26 11 80       	mov    0x8011267c,%eax
801027b5:	85 c0                	test   %eax,%eax
801027b7:	0f 84 cb 00 00 00    	je     80102888 <lapicinit+0xd8>
  lapic[index] = value;
801027bd:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
801027c4:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
801027c7:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801027ca:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
801027d1:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801027d4:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801027d7:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
801027de:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
801027e1:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801027e4:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
801027eb:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
801027ee:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801027f1:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
801027f8:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
801027fb:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801027fe:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
80102805:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102808:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(LINT0, MASKED);
  lapicw(LINT1, MASKED);

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
8010280b:	8b 50 30             	mov    0x30(%eax),%edx
8010280e:	c1 ea 10             	shr    $0x10,%edx
80102811:	81 e2 fc 00 00 00    	and    $0xfc,%edx
80102817:	75 77                	jne    80102890 <lapicinit+0xe0>
  lapic[index] = value;
80102819:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
80102820:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102823:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102826:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
8010282d:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102830:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102833:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
8010283a:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010283d:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102840:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102847:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010284a:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010284d:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
80102854:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102857:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010285a:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
80102861:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
80102864:	8b 50 20             	mov    0x20(%eax),%edx
80102867:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010286e:	66 90                	xchg   %ax,%ax
  lapicw(EOI, 0);

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  while(lapic[ICRLO] & DELIVS)
80102870:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
80102876:	80 e6 10             	and    $0x10,%dh
80102879:	75 f5                	jne    80102870 <lapicinit+0xc0>
  lapic[index] = value;
8010287b:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
80102882:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102885:	8b 40 20             	mov    0x20(%eax),%eax
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
80102888:	c3                   	ret    
80102889:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  lapic[index] = value;
80102890:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
80102897:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
8010289a:	8b 50 20             	mov    0x20(%eax),%edx
8010289d:	e9 77 ff ff ff       	jmp    80102819 <lapicinit+0x69>
801028a2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801028a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801028b0 <lapicid>:

int
lapicid(void)
{
  if (!lapic)
801028b0:	a1 7c 26 11 80       	mov    0x8011267c,%eax
801028b5:	85 c0                	test   %eax,%eax
801028b7:	74 07                	je     801028c0 <lapicid+0x10>
    return 0;
  return lapic[ID] >> 24;
801028b9:	8b 40 20             	mov    0x20(%eax),%eax
801028bc:	c1 e8 18             	shr    $0x18,%eax
801028bf:	c3                   	ret    
    return 0;
801028c0:	31 c0                	xor    %eax,%eax
}
801028c2:	c3                   	ret    
801028c3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801028ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801028d0 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
  if(lapic)
801028d0:	a1 7c 26 11 80       	mov    0x8011267c,%eax
801028d5:	85 c0                	test   %eax,%eax
801028d7:	74 0d                	je     801028e6 <lapiceoi+0x16>
  lapic[index] = value;
801028d9:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
801028e0:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801028e3:	8b 40 20             	mov    0x20(%eax),%eax
    lapicw(EOI, 0);
}
801028e6:	c3                   	ret    
801028e7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801028ee:	66 90                	xchg   %ax,%ax

801028f0 <microdelay>:
// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
}
801028f0:	c3                   	ret    
801028f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801028f8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801028ff:	90                   	nop

80102900 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
80102900:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102901:	b8 0f 00 00 00       	mov    $0xf,%eax
80102906:	ba 70 00 00 00       	mov    $0x70,%edx
8010290b:	89 e5                	mov    %esp,%ebp
8010290d:	53                   	push   %ebx
8010290e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80102911:	8b 5d 08             	mov    0x8(%ebp),%ebx
80102914:	ee                   	out    %al,(%dx)
80102915:	b8 0a 00 00 00       	mov    $0xa,%eax
8010291a:	ba 71 00 00 00       	mov    $0x71,%edx
8010291f:	ee                   	out    %al,(%dx)
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
80102920:	31 c0                	xor    %eax,%eax
  wrv[1] = addr >> 4;

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
80102922:	c1 e3 18             	shl    $0x18,%ebx
  wrv[0] = 0;
80102925:	66 a3 67 04 00 80    	mov    %ax,0x80000467
  wrv[1] = addr >> 4;
8010292b:	89 c8                	mov    %ecx,%eax
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
8010292d:	c1 e9 0c             	shr    $0xc,%ecx
  lapicw(ICRHI, apicid<<24);
80102930:	89 da                	mov    %ebx,%edx
  wrv[1] = addr >> 4;
80102932:	c1 e8 04             	shr    $0x4,%eax
    lapicw(ICRLO, STARTUP | (addr>>12));
80102935:	80 cd 06             	or     $0x6,%ch
  wrv[1] = addr >> 4;
80102938:	66 a3 69 04 00 80    	mov    %ax,0x80000469
  lapic[index] = value;
8010293e:	a1 7c 26 11 80       	mov    0x8011267c,%eax
80102943:	89 98 10 03 00 00    	mov    %ebx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102949:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
8010294c:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
80102953:	c5 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102956:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102959:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
80102960:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102963:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102966:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
8010296c:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
8010296f:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102975:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102978:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
8010297e:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102981:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
    microdelay(200);
  }
}
80102987:	5b                   	pop    %ebx
  lapic[ID];  // wait for write to finish, by reading
80102988:	8b 40 20             	mov    0x20(%eax),%eax
}
8010298b:	5d                   	pop    %ebp
8010298c:	c3                   	ret    
8010298d:	8d 76 00             	lea    0x0(%esi),%esi

80102990 <cmostime>:
}

// qemu seems to use 24-hour GWT and the values are BCD encoded
void
cmostime(struct rtcdate *r)
{
80102990:	55                   	push   %ebp
80102991:	b8 0b 00 00 00       	mov    $0xb,%eax
80102996:	ba 70 00 00 00       	mov    $0x70,%edx
8010299b:	89 e5                	mov    %esp,%ebp
8010299d:	57                   	push   %edi
8010299e:	56                   	push   %esi
8010299f:	53                   	push   %ebx
801029a0:	83 ec 4c             	sub    $0x4c,%esp
801029a3:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801029a4:	ba 71 00 00 00       	mov    $0x71,%edx
801029a9:	ec                   	in     (%dx),%al
  struct rtcdate t1, t2;
  int sb, bcd;

  sb = cmos_read(CMOS_STATB);

  bcd = (sb & (1 << 2)) == 0;
801029aa:	83 e0 04             	and    $0x4,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801029ad:	bb 70 00 00 00       	mov    $0x70,%ebx
801029b2:	88 45 b3             	mov    %al,-0x4d(%ebp)
801029b5:	8d 76 00             	lea    0x0(%esi),%esi
801029b8:	31 c0                	xor    %eax,%eax
801029ba:	89 da                	mov    %ebx,%edx
801029bc:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801029bd:	b9 71 00 00 00       	mov    $0x71,%ecx
801029c2:	89 ca                	mov    %ecx,%edx
801029c4:	ec                   	in     (%dx),%al
801029c5:	88 45 b7             	mov    %al,-0x49(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801029c8:	89 da                	mov    %ebx,%edx
801029ca:	b8 02 00 00 00       	mov    $0x2,%eax
801029cf:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801029d0:	89 ca                	mov    %ecx,%edx
801029d2:	ec                   	in     (%dx),%al
801029d3:	88 45 b6             	mov    %al,-0x4a(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801029d6:	89 da                	mov    %ebx,%edx
801029d8:	b8 04 00 00 00       	mov    $0x4,%eax
801029dd:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801029de:	89 ca                	mov    %ecx,%edx
801029e0:	ec                   	in     (%dx),%al
801029e1:	88 45 b5             	mov    %al,-0x4b(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801029e4:	89 da                	mov    %ebx,%edx
801029e6:	b8 07 00 00 00       	mov    $0x7,%eax
801029eb:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801029ec:	89 ca                	mov    %ecx,%edx
801029ee:	ec                   	in     (%dx),%al
801029ef:	88 45 b4             	mov    %al,-0x4c(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801029f2:	89 da                	mov    %ebx,%edx
801029f4:	b8 08 00 00 00       	mov    $0x8,%eax
801029f9:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801029fa:	89 ca                	mov    %ecx,%edx
801029fc:	ec                   	in     (%dx),%al
801029fd:	89 c7                	mov    %eax,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801029ff:	89 da                	mov    %ebx,%edx
80102a01:	b8 09 00 00 00       	mov    $0x9,%eax
80102a06:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a07:	89 ca                	mov    %ecx,%edx
80102a09:	ec                   	in     (%dx),%al
80102a0a:	89 c6                	mov    %eax,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a0c:	89 da                	mov    %ebx,%edx
80102a0e:	b8 0a 00 00 00       	mov    $0xa,%eax
80102a13:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a14:	89 ca                	mov    %ecx,%edx
80102a16:	ec                   	in     (%dx),%al

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
80102a17:	84 c0                	test   %al,%al
80102a19:	78 9d                	js     801029b8 <cmostime+0x28>
  return inb(CMOS_RETURN);
80102a1b:	0f b6 45 b7          	movzbl -0x49(%ebp),%eax
80102a1f:	89 fa                	mov    %edi,%edx
80102a21:	0f b6 fa             	movzbl %dl,%edi
80102a24:	89 f2                	mov    %esi,%edx
80102a26:	89 45 b8             	mov    %eax,-0x48(%ebp)
80102a29:	0f b6 45 b6          	movzbl -0x4a(%ebp),%eax
80102a2d:	0f b6 f2             	movzbl %dl,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a30:	89 da                	mov    %ebx,%edx
80102a32:	89 7d c8             	mov    %edi,-0x38(%ebp)
80102a35:	89 45 bc             	mov    %eax,-0x44(%ebp)
80102a38:	0f b6 45 b5          	movzbl -0x4b(%ebp),%eax
80102a3c:	89 75 cc             	mov    %esi,-0x34(%ebp)
80102a3f:	89 45 c0             	mov    %eax,-0x40(%ebp)
80102a42:	0f b6 45 b4          	movzbl -0x4c(%ebp),%eax
80102a46:	89 45 c4             	mov    %eax,-0x3c(%ebp)
80102a49:	31 c0                	xor    %eax,%eax
80102a4b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a4c:	89 ca                	mov    %ecx,%edx
80102a4e:	ec                   	in     (%dx),%al
80102a4f:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a52:	89 da                	mov    %ebx,%edx
80102a54:	89 45 d0             	mov    %eax,-0x30(%ebp)
80102a57:	b8 02 00 00 00       	mov    $0x2,%eax
80102a5c:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a5d:	89 ca                	mov    %ecx,%edx
80102a5f:	ec                   	in     (%dx),%al
80102a60:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a63:	89 da                	mov    %ebx,%edx
80102a65:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80102a68:	b8 04 00 00 00       	mov    $0x4,%eax
80102a6d:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a6e:	89 ca                	mov    %ecx,%edx
80102a70:	ec                   	in     (%dx),%al
80102a71:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a74:	89 da                	mov    %ebx,%edx
80102a76:	89 45 d8             	mov    %eax,-0x28(%ebp)
80102a79:	b8 07 00 00 00       	mov    $0x7,%eax
80102a7e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a7f:	89 ca                	mov    %ecx,%edx
80102a81:	ec                   	in     (%dx),%al
80102a82:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a85:	89 da                	mov    %ebx,%edx
80102a87:	89 45 dc             	mov    %eax,-0x24(%ebp)
80102a8a:	b8 08 00 00 00       	mov    $0x8,%eax
80102a8f:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a90:	89 ca                	mov    %ecx,%edx
80102a92:	ec                   	in     (%dx),%al
80102a93:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a96:	89 da                	mov    %ebx,%edx
80102a98:	89 45 e0             	mov    %eax,-0x20(%ebp)
80102a9b:	b8 09 00 00 00       	mov    $0x9,%eax
80102aa0:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102aa1:	89 ca                	mov    %ecx,%edx
80102aa3:	ec                   	in     (%dx),%al
80102aa4:	0f b6 c0             	movzbl %al,%eax
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102aa7:	83 ec 04             	sub    $0x4,%esp
  return inb(CMOS_RETURN);
80102aaa:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102aad:	8d 45 d0             	lea    -0x30(%ebp),%eax
80102ab0:	6a 18                	push   $0x18
80102ab2:	50                   	push   %eax
80102ab3:	8d 45 b8             	lea    -0x48(%ebp),%eax
80102ab6:	50                   	push   %eax
80102ab7:	e8 84 1b 00 00       	call   80104640 <memcmp>
80102abc:	83 c4 10             	add    $0x10,%esp
80102abf:	85 c0                	test   %eax,%eax
80102ac1:	0f 85 f1 fe ff ff    	jne    801029b8 <cmostime+0x28>
      break;
  }

  // convert
  if(bcd) {
80102ac7:	80 7d b3 00          	cmpb   $0x0,-0x4d(%ebp)
80102acb:	75 78                	jne    80102b45 <cmostime+0x1b5>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
80102acd:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102ad0:	89 c2                	mov    %eax,%edx
80102ad2:	83 e0 0f             	and    $0xf,%eax
80102ad5:	c1 ea 04             	shr    $0x4,%edx
80102ad8:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102adb:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102ade:	89 45 b8             	mov    %eax,-0x48(%ebp)
    CONV(minute);
80102ae1:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102ae4:	89 c2                	mov    %eax,%edx
80102ae6:	83 e0 0f             	and    $0xf,%eax
80102ae9:	c1 ea 04             	shr    $0x4,%edx
80102aec:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102aef:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102af2:	89 45 bc             	mov    %eax,-0x44(%ebp)
    CONV(hour  );
80102af5:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102af8:	89 c2                	mov    %eax,%edx
80102afa:	83 e0 0f             	and    $0xf,%eax
80102afd:	c1 ea 04             	shr    $0x4,%edx
80102b00:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b03:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b06:	89 45 c0             	mov    %eax,-0x40(%ebp)
    CONV(day   );
80102b09:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102b0c:	89 c2                	mov    %eax,%edx
80102b0e:	83 e0 0f             	and    $0xf,%eax
80102b11:	c1 ea 04             	shr    $0x4,%edx
80102b14:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b17:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b1a:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    CONV(month );
80102b1d:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102b20:	89 c2                	mov    %eax,%edx
80102b22:	83 e0 0f             	and    $0xf,%eax
80102b25:	c1 ea 04             	shr    $0x4,%edx
80102b28:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b2b:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b2e:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(year  );
80102b31:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102b34:	89 c2                	mov    %eax,%edx
80102b36:	83 e0 0f             	and    $0xf,%eax
80102b39:	c1 ea 04             	shr    $0x4,%edx
80102b3c:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b3f:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b42:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef     CONV
  }

  *r = t1;
80102b45:	8b 75 08             	mov    0x8(%ebp),%esi
80102b48:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102b4b:	89 06                	mov    %eax,(%esi)
80102b4d:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102b50:	89 46 04             	mov    %eax,0x4(%esi)
80102b53:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102b56:	89 46 08             	mov    %eax,0x8(%esi)
80102b59:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102b5c:	89 46 0c             	mov    %eax,0xc(%esi)
80102b5f:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102b62:	89 46 10             	mov    %eax,0x10(%esi)
80102b65:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102b68:	89 46 14             	mov    %eax,0x14(%esi)
  r->year += 2000;
80102b6b:	81 46 14 d0 07 00 00 	addl   $0x7d0,0x14(%esi)
}
80102b72:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102b75:	5b                   	pop    %ebx
80102b76:	5e                   	pop    %esi
80102b77:	5f                   	pop    %edi
80102b78:	5d                   	pop    %ebp
80102b79:	c3                   	ret    
80102b7a:	66 90                	xchg   %ax,%ax
80102b7c:	66 90                	xchg   %ax,%ax
80102b7e:	66 90                	xchg   %ax,%ax

80102b80 <install_trans>:
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102b80:	8b 0d c8 26 11 80    	mov    0x801126c8,%ecx
80102b86:	85 c9                	test   %ecx,%ecx
80102b88:	0f 8e 8a 00 00 00    	jle    80102c18 <install_trans+0x98>
{
80102b8e:	55                   	push   %ebp
80102b8f:	89 e5                	mov    %esp,%ebp
80102b91:	57                   	push   %edi
80102b92:	56                   	push   %esi
80102b93:	53                   	push   %ebx
  for (tail = 0; tail < log.lh.n; tail++) {
80102b94:	31 db                	xor    %ebx,%ebx
{
80102b96:	83 ec 0c             	sub    $0xc,%esp
80102b99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80102ba0:	a1 b4 26 11 80       	mov    0x801126b4,%eax
80102ba5:	83 ec 08             	sub    $0x8,%esp
80102ba8:	01 d8                	add    %ebx,%eax
80102baa:	83 c0 01             	add    $0x1,%eax
80102bad:	50                   	push   %eax
80102bae:	ff 35 c4 26 11 80    	pushl  0x801126c4
80102bb4:	e8 17 d5 ff ff       	call   801000d0 <bread>
80102bb9:	89 c7                	mov    %eax,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102bbb:	58                   	pop    %eax
80102bbc:	5a                   	pop    %edx
80102bbd:	ff 34 9d cc 26 11 80 	pushl  -0x7feed934(,%ebx,4)
80102bc4:	ff 35 c4 26 11 80    	pushl  0x801126c4
  for (tail = 0; tail < log.lh.n; tail++) {
80102bca:	83 c3 01             	add    $0x1,%ebx
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102bcd:	e8 fe d4 ff ff       	call   801000d0 <bread>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102bd2:	83 c4 0c             	add    $0xc,%esp
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102bd5:	89 c6                	mov    %eax,%esi
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102bd7:	8d 47 5c             	lea    0x5c(%edi),%eax
80102bda:	68 00 02 00 00       	push   $0x200
80102bdf:	50                   	push   %eax
80102be0:	8d 46 5c             	lea    0x5c(%esi),%eax
80102be3:	50                   	push   %eax
80102be4:	e8 a7 1a 00 00       	call   80104690 <memmove>
    bwrite(dbuf);  // write dst to disk
80102be9:	89 34 24             	mov    %esi,(%esp)
80102bec:	e8 bf d5 ff ff       	call   801001b0 <bwrite>
    brelse(lbuf);
80102bf1:	89 3c 24             	mov    %edi,(%esp)
80102bf4:	e8 f7 d5 ff ff       	call   801001f0 <brelse>
    brelse(dbuf);
80102bf9:	89 34 24             	mov    %esi,(%esp)
80102bfc:	e8 ef d5 ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102c01:	83 c4 10             	add    $0x10,%esp
80102c04:	39 1d c8 26 11 80    	cmp    %ebx,0x801126c8
80102c0a:	7f 94                	jg     80102ba0 <install_trans+0x20>
  }
}
80102c0c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102c0f:	5b                   	pop    %ebx
80102c10:	5e                   	pop    %esi
80102c11:	5f                   	pop    %edi
80102c12:	5d                   	pop    %ebp
80102c13:	c3                   	ret    
80102c14:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102c18:	c3                   	ret    
80102c19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102c20 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80102c20:	55                   	push   %ebp
80102c21:	89 e5                	mov    %esp,%ebp
80102c23:	53                   	push   %ebx
80102c24:	83 ec 0c             	sub    $0xc,%esp
  struct buf *buf = bread(log.dev, log.start);
80102c27:	ff 35 b4 26 11 80    	pushl  0x801126b4
80102c2d:	ff 35 c4 26 11 80    	pushl  0x801126c4
80102c33:	e8 98 d4 ff ff       	call   801000d0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
80102c38:	83 c4 10             	add    $0x10,%esp
  struct buf *buf = bread(log.dev, log.start);
80102c3b:	89 c3                	mov    %eax,%ebx
  hb->n = log.lh.n;
80102c3d:	a1 c8 26 11 80       	mov    0x801126c8,%eax
80102c42:	89 43 5c             	mov    %eax,0x5c(%ebx)
  for (i = 0; i < log.lh.n; i++) {
80102c45:	85 c0                	test   %eax,%eax
80102c47:	7e 19                	jle    80102c62 <write_head+0x42>
80102c49:	31 d2                	xor    %edx,%edx
80102c4b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102c4f:	90                   	nop
    hb->block[i] = log.lh.block[i];
80102c50:	8b 0c 95 cc 26 11 80 	mov    -0x7feed934(,%edx,4),%ecx
80102c57:	89 4c 93 60          	mov    %ecx,0x60(%ebx,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
80102c5b:	83 c2 01             	add    $0x1,%edx
80102c5e:	39 d0                	cmp    %edx,%eax
80102c60:	75 ee                	jne    80102c50 <write_head+0x30>
  }
  bwrite(buf);
80102c62:	83 ec 0c             	sub    $0xc,%esp
80102c65:	53                   	push   %ebx
80102c66:	e8 45 d5 ff ff       	call   801001b0 <bwrite>
  brelse(buf);
80102c6b:	89 1c 24             	mov    %ebx,(%esp)
80102c6e:	e8 7d d5 ff ff       	call   801001f0 <brelse>
}
80102c73:	83 c4 10             	add    $0x10,%esp
80102c76:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102c79:	c9                   	leave  
80102c7a:	c3                   	ret    
80102c7b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102c7f:	90                   	nop

80102c80 <initlog>:
{
80102c80:	55                   	push   %ebp
80102c81:	89 e5                	mov    %esp,%ebp
80102c83:	53                   	push   %ebx
80102c84:	83 ec 2c             	sub    $0x2c,%esp
80102c87:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&log.lock, "log");
80102c8a:	68 a0 74 10 80       	push   $0x801074a0
80102c8f:	68 80 26 11 80       	push   $0x80112680
80102c94:	e8 e7 16 00 00       	call   80104380 <initlock>
  readsb(dev, &sb);
80102c99:	58                   	pop    %eax
80102c9a:	8d 45 dc             	lea    -0x24(%ebp),%eax
80102c9d:	5a                   	pop    %edx
80102c9e:	50                   	push   %eax
80102c9f:	53                   	push   %ebx
80102ca0:	e8 bb e7 ff ff       	call   80101460 <readsb>
  log.start = sb.logstart;
80102ca5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  struct buf *buf = bread(log.dev, log.start);
80102ca8:	59                   	pop    %ecx
  log.dev = dev;
80102ca9:	89 1d c4 26 11 80    	mov    %ebx,0x801126c4
  log.size = sb.nlog;
80102caf:	8b 55 e8             	mov    -0x18(%ebp),%edx
  log.start = sb.logstart;
80102cb2:	a3 b4 26 11 80       	mov    %eax,0x801126b4
  log.size = sb.nlog;
80102cb7:	89 15 b8 26 11 80    	mov    %edx,0x801126b8
  struct buf *buf = bread(log.dev, log.start);
80102cbd:	5a                   	pop    %edx
80102cbe:	50                   	push   %eax
80102cbf:	53                   	push   %ebx
80102cc0:	e8 0b d4 ff ff       	call   801000d0 <bread>
  for (i = 0; i < log.lh.n; i++) {
80102cc5:	83 c4 10             	add    $0x10,%esp
  log.lh.n = lh->n;
80102cc8:	8b 48 5c             	mov    0x5c(%eax),%ecx
80102ccb:	89 0d c8 26 11 80    	mov    %ecx,0x801126c8
  for (i = 0; i < log.lh.n; i++) {
80102cd1:	85 c9                	test   %ecx,%ecx
80102cd3:	7e 1d                	jle    80102cf2 <initlog+0x72>
80102cd5:	31 d2                	xor    %edx,%edx
80102cd7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102cde:	66 90                	xchg   %ax,%ax
    log.lh.block[i] = lh->block[i];
80102ce0:	8b 5c 90 60          	mov    0x60(%eax,%edx,4),%ebx
80102ce4:	89 1c 95 cc 26 11 80 	mov    %ebx,-0x7feed934(,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
80102ceb:	83 c2 01             	add    $0x1,%edx
80102cee:	39 d1                	cmp    %edx,%ecx
80102cf0:	75 ee                	jne    80102ce0 <initlog+0x60>
  brelse(buf);
80102cf2:	83 ec 0c             	sub    $0xc,%esp
80102cf5:	50                   	push   %eax
80102cf6:	e8 f5 d4 ff ff       	call   801001f0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
80102cfb:	e8 80 fe ff ff       	call   80102b80 <install_trans>
  log.lh.n = 0;
80102d00:	c7 05 c8 26 11 80 00 	movl   $0x0,0x801126c8
80102d07:	00 00 00 
  write_head(); // clear the log
80102d0a:	e8 11 ff ff ff       	call   80102c20 <write_head>
}
80102d0f:	83 c4 10             	add    $0x10,%esp
80102d12:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102d15:	c9                   	leave  
80102d16:	c3                   	ret    
80102d17:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102d1e:	66 90                	xchg   %ax,%ax

80102d20 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
80102d20:	55                   	push   %ebp
80102d21:	89 e5                	mov    %esp,%ebp
80102d23:	83 ec 14             	sub    $0x14,%esp
  acquire(&log.lock);
80102d26:	68 80 26 11 80       	push   $0x80112680
80102d2b:	e8 b0 17 00 00       	call   801044e0 <acquire>
80102d30:	83 c4 10             	add    $0x10,%esp
80102d33:	eb 18                	jmp    80102d4d <begin_op+0x2d>
80102d35:	8d 76 00             	lea    0x0(%esi),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80102d38:	83 ec 08             	sub    $0x8,%esp
80102d3b:	68 80 26 11 80       	push   $0x80112680
80102d40:	68 80 26 11 80       	push   $0x80112680
80102d45:	e8 b6 11 00 00       	call   80103f00 <sleep>
80102d4a:	83 c4 10             	add    $0x10,%esp
    if(log.committing){
80102d4d:	a1 c0 26 11 80       	mov    0x801126c0,%eax
80102d52:	85 c0                	test   %eax,%eax
80102d54:	75 e2                	jne    80102d38 <begin_op+0x18>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80102d56:	a1 bc 26 11 80       	mov    0x801126bc,%eax
80102d5b:	8b 15 c8 26 11 80    	mov    0x801126c8,%edx
80102d61:	83 c0 01             	add    $0x1,%eax
80102d64:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
80102d67:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
80102d6a:	83 fa 1e             	cmp    $0x1e,%edx
80102d6d:	7f c9                	jg     80102d38 <begin_op+0x18>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
      release(&log.lock);
80102d6f:	83 ec 0c             	sub    $0xc,%esp
      log.outstanding += 1;
80102d72:	a3 bc 26 11 80       	mov    %eax,0x801126bc
      release(&log.lock);
80102d77:	68 80 26 11 80       	push   $0x80112680
80102d7c:	e8 1f 18 00 00       	call   801045a0 <release>
      break;
    }
  }
}
80102d81:	83 c4 10             	add    $0x10,%esp
80102d84:	c9                   	leave  
80102d85:	c3                   	ret    
80102d86:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102d8d:	8d 76 00             	lea    0x0(%esi),%esi

80102d90 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80102d90:	55                   	push   %ebp
80102d91:	89 e5                	mov    %esp,%ebp
80102d93:	57                   	push   %edi
80102d94:	56                   	push   %esi
80102d95:	53                   	push   %ebx
80102d96:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;

  acquire(&log.lock);
80102d99:	68 80 26 11 80       	push   $0x80112680
80102d9e:	e8 3d 17 00 00       	call   801044e0 <acquire>
  log.outstanding -= 1;
80102da3:	a1 bc 26 11 80       	mov    0x801126bc,%eax
  if(log.committing)
80102da8:	8b 35 c0 26 11 80    	mov    0x801126c0,%esi
80102dae:	83 c4 10             	add    $0x10,%esp
  log.outstanding -= 1;
80102db1:	8d 58 ff             	lea    -0x1(%eax),%ebx
80102db4:	89 1d bc 26 11 80    	mov    %ebx,0x801126bc
  if(log.committing)
80102dba:	85 f6                	test   %esi,%esi
80102dbc:	0f 85 22 01 00 00    	jne    80102ee4 <end_op+0x154>
    panic("log.committing");
  if(log.outstanding == 0){
80102dc2:	85 db                	test   %ebx,%ebx
80102dc4:	0f 85 f6 00 00 00    	jne    80102ec0 <end_op+0x130>
    do_commit = 1;
    log.committing = 1;
80102dca:	c7 05 c0 26 11 80 01 	movl   $0x1,0x801126c0
80102dd1:	00 00 00 
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
80102dd4:	83 ec 0c             	sub    $0xc,%esp
80102dd7:	68 80 26 11 80       	push   $0x80112680
80102ddc:	e8 bf 17 00 00       	call   801045a0 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
80102de1:	8b 0d c8 26 11 80    	mov    0x801126c8,%ecx
80102de7:	83 c4 10             	add    $0x10,%esp
80102dea:	85 c9                	test   %ecx,%ecx
80102dec:	7f 42                	jg     80102e30 <end_op+0xa0>
    acquire(&log.lock);
80102dee:	83 ec 0c             	sub    $0xc,%esp
80102df1:	68 80 26 11 80       	push   $0x80112680
80102df6:	e8 e5 16 00 00       	call   801044e0 <acquire>
    wakeup(&log);
80102dfb:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
    log.committing = 0;
80102e02:	c7 05 c0 26 11 80 00 	movl   $0x0,0x801126c0
80102e09:	00 00 00 
    wakeup(&log);
80102e0c:	e8 9f 12 00 00       	call   801040b0 <wakeup>
    release(&log.lock);
80102e11:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
80102e18:	e8 83 17 00 00       	call   801045a0 <release>
80102e1d:	83 c4 10             	add    $0x10,%esp
}
80102e20:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102e23:	5b                   	pop    %ebx
80102e24:	5e                   	pop    %esi
80102e25:	5f                   	pop    %edi
80102e26:	5d                   	pop    %ebp
80102e27:	c3                   	ret    
80102e28:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102e2f:	90                   	nop
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80102e30:	a1 b4 26 11 80       	mov    0x801126b4,%eax
80102e35:	83 ec 08             	sub    $0x8,%esp
80102e38:	01 d8                	add    %ebx,%eax
80102e3a:	83 c0 01             	add    $0x1,%eax
80102e3d:	50                   	push   %eax
80102e3e:	ff 35 c4 26 11 80    	pushl  0x801126c4
80102e44:	e8 87 d2 ff ff       	call   801000d0 <bread>
80102e49:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102e4b:	58                   	pop    %eax
80102e4c:	5a                   	pop    %edx
80102e4d:	ff 34 9d cc 26 11 80 	pushl  -0x7feed934(,%ebx,4)
80102e54:	ff 35 c4 26 11 80    	pushl  0x801126c4
  for (tail = 0; tail < log.lh.n; tail++) {
80102e5a:	83 c3 01             	add    $0x1,%ebx
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102e5d:	e8 6e d2 ff ff       	call   801000d0 <bread>
    memmove(to->data, from->data, BSIZE);
80102e62:	83 c4 0c             	add    $0xc,%esp
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102e65:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
80102e67:	8d 40 5c             	lea    0x5c(%eax),%eax
80102e6a:	68 00 02 00 00       	push   $0x200
80102e6f:	50                   	push   %eax
80102e70:	8d 46 5c             	lea    0x5c(%esi),%eax
80102e73:	50                   	push   %eax
80102e74:	e8 17 18 00 00       	call   80104690 <memmove>
    bwrite(to);  // write the log
80102e79:	89 34 24             	mov    %esi,(%esp)
80102e7c:	e8 2f d3 ff ff       	call   801001b0 <bwrite>
    brelse(from);
80102e81:	89 3c 24             	mov    %edi,(%esp)
80102e84:	e8 67 d3 ff ff       	call   801001f0 <brelse>
    brelse(to);
80102e89:	89 34 24             	mov    %esi,(%esp)
80102e8c:	e8 5f d3 ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102e91:	83 c4 10             	add    $0x10,%esp
80102e94:	3b 1d c8 26 11 80    	cmp    0x801126c8,%ebx
80102e9a:	7c 94                	jl     80102e30 <end_op+0xa0>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
80102e9c:	e8 7f fd ff ff       	call   80102c20 <write_head>
    install_trans(); // Now install writes to home locations
80102ea1:	e8 da fc ff ff       	call   80102b80 <install_trans>
    log.lh.n = 0;
80102ea6:	c7 05 c8 26 11 80 00 	movl   $0x0,0x801126c8
80102ead:	00 00 00 
    write_head();    // Erase the transaction from the log
80102eb0:	e8 6b fd ff ff       	call   80102c20 <write_head>
80102eb5:	e9 34 ff ff ff       	jmp    80102dee <end_op+0x5e>
80102eba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    wakeup(&log);
80102ec0:	83 ec 0c             	sub    $0xc,%esp
80102ec3:	68 80 26 11 80       	push   $0x80112680
80102ec8:	e8 e3 11 00 00       	call   801040b0 <wakeup>
  release(&log.lock);
80102ecd:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
80102ed4:	e8 c7 16 00 00       	call   801045a0 <release>
80102ed9:	83 c4 10             	add    $0x10,%esp
}
80102edc:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102edf:	5b                   	pop    %ebx
80102ee0:	5e                   	pop    %esi
80102ee1:	5f                   	pop    %edi
80102ee2:	5d                   	pop    %ebp
80102ee3:	c3                   	ret    
    panic("log.committing");
80102ee4:	83 ec 0c             	sub    $0xc,%esp
80102ee7:	68 a4 74 10 80       	push   $0x801074a4
80102eec:	e8 9f d4 ff ff       	call   80100390 <panic>
80102ef1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102ef8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102eff:	90                   	nop

80102f00 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80102f00:	55                   	push   %ebp
80102f01:	89 e5                	mov    %esp,%ebp
80102f03:	53                   	push   %ebx
80102f04:	83 ec 04             	sub    $0x4,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102f07:	8b 15 c8 26 11 80    	mov    0x801126c8,%edx
{
80102f0d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102f10:	83 fa 1d             	cmp    $0x1d,%edx
80102f13:	0f 8f 94 00 00 00    	jg     80102fad <log_write+0xad>
80102f19:	a1 b8 26 11 80       	mov    0x801126b8,%eax
80102f1e:	83 e8 01             	sub    $0x1,%eax
80102f21:	39 c2                	cmp    %eax,%edx
80102f23:	0f 8d 84 00 00 00    	jge    80102fad <log_write+0xad>
    panic("too big a transaction");
  if (log.outstanding < 1)
80102f29:	a1 bc 26 11 80       	mov    0x801126bc,%eax
80102f2e:	85 c0                	test   %eax,%eax
80102f30:	0f 8e 84 00 00 00    	jle    80102fba <log_write+0xba>
    panic("log_write outside of trans");

  acquire(&log.lock);
80102f36:	83 ec 0c             	sub    $0xc,%esp
80102f39:	68 80 26 11 80       	push   $0x80112680
80102f3e:	e8 9d 15 00 00       	call   801044e0 <acquire>
  for (i = 0; i < log.lh.n; i++) {
80102f43:	8b 15 c8 26 11 80    	mov    0x801126c8,%edx
80102f49:	83 c4 10             	add    $0x10,%esp
80102f4c:	85 d2                	test   %edx,%edx
80102f4e:	7e 51                	jle    80102fa1 <log_write+0xa1>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102f50:	8b 4b 08             	mov    0x8(%ebx),%ecx
  for (i = 0; i < log.lh.n; i++) {
80102f53:	31 c0                	xor    %eax,%eax
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102f55:	3b 0d cc 26 11 80    	cmp    0x801126cc,%ecx
80102f5b:	75 0c                	jne    80102f69 <log_write+0x69>
80102f5d:	eb 39                	jmp    80102f98 <log_write+0x98>
80102f5f:	90                   	nop
80102f60:	39 0c 85 cc 26 11 80 	cmp    %ecx,-0x7feed934(,%eax,4)
80102f67:	74 2f                	je     80102f98 <log_write+0x98>
  for (i = 0; i < log.lh.n; i++) {
80102f69:	83 c0 01             	add    $0x1,%eax
80102f6c:	39 c2                	cmp    %eax,%edx
80102f6e:	75 f0                	jne    80102f60 <log_write+0x60>
      break;
  }
  log.lh.block[i] = b->blockno;
80102f70:	89 0c 95 cc 26 11 80 	mov    %ecx,-0x7feed934(,%edx,4)
  if (i == log.lh.n)
    log.lh.n++;
80102f77:	83 c2 01             	add    $0x1,%edx
80102f7a:	89 15 c8 26 11 80    	mov    %edx,0x801126c8
  b->flags |= B_DIRTY; // prevent eviction
80102f80:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
}
80102f83:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  release(&log.lock);
80102f86:	c7 45 08 80 26 11 80 	movl   $0x80112680,0x8(%ebp)
}
80102f8d:	c9                   	leave  
  release(&log.lock);
80102f8e:	e9 0d 16 00 00       	jmp    801045a0 <release>
80102f93:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102f97:	90                   	nop
  log.lh.block[i] = b->blockno;
80102f98:	89 0c 85 cc 26 11 80 	mov    %ecx,-0x7feed934(,%eax,4)
  if (i == log.lh.n)
80102f9f:	eb df                	jmp    80102f80 <log_write+0x80>
  log.lh.block[i] = b->blockno;
80102fa1:	8b 43 08             	mov    0x8(%ebx),%eax
80102fa4:	a3 cc 26 11 80       	mov    %eax,0x801126cc
  if (i == log.lh.n)
80102fa9:	75 d5                	jne    80102f80 <log_write+0x80>
80102fab:	eb ca                	jmp    80102f77 <log_write+0x77>
    panic("too big a transaction");
80102fad:	83 ec 0c             	sub    $0xc,%esp
80102fb0:	68 b3 74 10 80       	push   $0x801074b3
80102fb5:	e8 d6 d3 ff ff       	call   80100390 <panic>
    panic("log_write outside of trans");
80102fba:	83 ec 0c             	sub    $0xc,%esp
80102fbd:	68 c9 74 10 80       	push   $0x801074c9
80102fc2:	e8 c9 d3 ff ff       	call   80100390 <panic>
80102fc7:	66 90                	xchg   %ax,%ax
80102fc9:	66 90                	xchg   %ax,%ax
80102fcb:	66 90                	xchg   %ax,%ax
80102fcd:	66 90                	xchg   %ax,%ax
80102fcf:	90                   	nop

80102fd0 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
80102fd0:	55                   	push   %ebp
80102fd1:	89 e5                	mov    %esp,%ebp
80102fd3:	53                   	push   %ebx
80102fd4:	83 ec 04             	sub    $0x4,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
80102fd7:	e8 64 09 00 00       	call   80103940 <cpuid>
80102fdc:	89 c3                	mov    %eax,%ebx
80102fde:	e8 5d 09 00 00       	call   80103940 <cpuid>
80102fe3:	83 ec 04             	sub    $0x4,%esp
80102fe6:	53                   	push   %ebx
80102fe7:	50                   	push   %eax
80102fe8:	68 e4 74 10 80       	push   $0x801074e4
80102fed:	e8 be d6 ff ff       	call   801006b0 <cprintf>
  idtinit();       // load idt register
80102ff2:	e8 39 28 00 00       	call   80105830 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
80102ff7:	e8 c4 08 00 00       	call   801038c0 <mycpu>
80102ffc:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
80102ffe:	b8 01 00 00 00       	mov    $0x1,%eax
80103003:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
8010300a:	e8 11 0c 00 00       	call   80103c20 <scheduler>
8010300f:	90                   	nop

80103010 <mpenter>:
{
80103010:	55                   	push   %ebp
80103011:	89 e5                	mov    %esp,%ebp
80103013:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
80103016:	e8 15 39 00 00       	call   80106930 <switchkvm>
  seginit();
8010301b:	e8 80 38 00 00       	call   801068a0 <seginit>
  lapicinit();
80103020:	e8 8b f7 ff ff       	call   801027b0 <lapicinit>
  mpmain();
80103025:	e8 a6 ff ff ff       	call   80102fd0 <mpmain>
8010302a:	66 90                	xchg   %ax,%ax
8010302c:	66 90                	xchg   %ax,%ax
8010302e:	66 90                	xchg   %ax,%ax

80103030 <main>:
{
80103030:	8d 4c 24 04          	lea    0x4(%esp),%ecx
80103034:	83 e4 f0             	and    $0xfffffff0,%esp
80103037:	ff 71 fc             	pushl  -0x4(%ecx)
8010303a:	55                   	push   %ebp
8010303b:	89 e5                	mov    %esp,%ebp
8010303d:	53                   	push   %ebx
8010303e:	51                   	push   %ecx
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
8010303f:	83 ec 08             	sub    $0x8,%esp
80103042:	68 00 00 40 80       	push   $0x80400000
80103047:	68 a8 54 11 80       	push   $0x801154a8
8010304c:	e8 8f f4 ff ff       	call   801024e0 <kinit1>
  kvmalloc();      // kernel page table
80103051:	e8 9a 3d 00 00       	call   80106df0 <kvmalloc>
  mpinit();        // detect other processors
80103056:	e8 85 01 00 00       	call   801031e0 <mpinit>
  lapicinit();     // interrupt controller
8010305b:	e8 50 f7 ff ff       	call   801027b0 <lapicinit>
  seginit();       // segment descriptors
80103060:	e8 3b 38 00 00       	call   801068a0 <seginit>
  picinit();       // disable pic
80103065:	e8 46 03 00 00       	call   801033b0 <picinit>
  ioapicinit();    // another interrupt controller
8010306a:	e8 91 f2 ff ff       	call   80102300 <ioapicinit>
  consoleinit();   // console hardware
8010306f:	e8 bc d9 ff ff       	call   80100a30 <consoleinit>
  uartinit();      // serial port
80103074:	e8 e7 2a 00 00       	call   80105b60 <uartinit>
  pinit();         // process table
80103079:	e8 22 08 00 00       	call   801038a0 <pinit>
  tvinit();        // trap vectors
8010307e:	e8 2d 27 00 00       	call   801057b0 <tvinit>
  binit();         // buffer cache
80103083:	e8 b8 cf ff ff       	call   80100040 <binit>
  fileinit();      // file table
80103088:	e8 53 dd ff ff       	call   80100de0 <fileinit>
  ideinit();       // disk 
8010308d:	e8 4e f0 ff ff       	call   801020e0 <ideinit>

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
80103092:	83 c4 0c             	add    $0xc,%esp
80103095:	68 8a 00 00 00       	push   $0x8a
8010309a:	68 8c a4 10 80       	push   $0x8010a48c
8010309f:	68 00 70 00 80       	push   $0x80007000
801030a4:	e8 e7 15 00 00       	call   80104690 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
801030a9:	83 c4 10             	add    $0x10,%esp
801030ac:	69 05 00 2d 11 80 b0 	imul   $0xb0,0x80112d00,%eax
801030b3:	00 00 00 
801030b6:	05 80 27 11 80       	add    $0x80112780,%eax
801030bb:	3d 80 27 11 80       	cmp    $0x80112780,%eax
801030c0:	76 7e                	jbe    80103140 <main+0x110>
801030c2:	bb 80 27 11 80       	mov    $0x80112780,%ebx
801030c7:	eb 20                	jmp    801030e9 <main+0xb9>
801030c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801030d0:	69 05 00 2d 11 80 b0 	imul   $0xb0,0x80112d00,%eax
801030d7:	00 00 00 
801030da:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
801030e0:	05 80 27 11 80       	add    $0x80112780,%eax
801030e5:	39 c3                	cmp    %eax,%ebx
801030e7:	73 57                	jae    80103140 <main+0x110>
    if(c == mycpu())  // We've started already.
801030e9:	e8 d2 07 00 00       	call   801038c0 <mycpu>
801030ee:	39 d8                	cmp    %ebx,%eax
801030f0:	74 de                	je     801030d0 <main+0xa0>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
801030f2:	e8 b9 f4 ff ff       	call   801025b0 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
    *(void(**)(void))(code-8) = mpenter;
    *(int**)(code-12) = (void *) V2P(entrypgdir);

    lapicstartap(c->apicid, V2P(code));
801030f7:	83 ec 08             	sub    $0x8,%esp
    *(void(**)(void))(code-8) = mpenter;
801030fa:	c7 05 f8 6f 00 80 10 	movl   $0x80103010,0x80006ff8
80103101:	30 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
80103104:	c7 05 f4 6f 00 80 00 	movl   $0x109000,0x80006ff4
8010310b:	90 10 00 
    *(void**)(code-4) = stack + KSTACKSIZE;
8010310e:	05 00 10 00 00       	add    $0x1000,%eax
80103113:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc
    lapicstartap(c->apicid, V2P(code));
80103118:	0f b6 03             	movzbl (%ebx),%eax
8010311b:	68 00 70 00 00       	push   $0x7000
80103120:	50                   	push   %eax
80103121:	e8 da f7 ff ff       	call   80102900 <lapicstartap>
80103126:	83 c4 10             	add    $0x10,%esp
80103129:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

    // wait for cpu to finish mpmain()
    while(c->started == 0)
80103130:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
80103136:	85 c0                	test   %eax,%eax
80103138:	74 f6                	je     80103130 <main+0x100>
8010313a:	eb 94                	jmp    801030d0 <main+0xa0>
8010313c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
80103140:	83 ec 08             	sub    $0x8,%esp
80103143:	68 00 00 00 8e       	push   $0x8e000000
80103148:	68 00 00 40 80       	push   $0x80400000
8010314d:	e8 fe f3 ff ff       	call   80102550 <kinit2>
  userinit();      // first user process
80103152:	e8 39 08 00 00       	call   80103990 <userinit>
  mpmain();        // finish this processor's setup
80103157:	e8 74 fe ff ff       	call   80102fd0 <mpmain>
8010315c:	66 90                	xchg   %ax,%ax
8010315e:	66 90                	xchg   %ax,%ax

80103160 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80103160:	55                   	push   %ebp
80103161:	89 e5                	mov    %esp,%ebp
80103163:	57                   	push   %edi
80103164:	56                   	push   %esi
  uchar *e, *p, *addr;

  addr = P2V(a);
80103165:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
{
8010316b:	53                   	push   %ebx
  e = addr+len;
8010316c:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
{
8010316f:	83 ec 0c             	sub    $0xc,%esp
  for(p = addr; p < e; p += sizeof(struct mp))
80103172:	39 de                	cmp    %ebx,%esi
80103174:	72 10                	jb     80103186 <mpsearch1+0x26>
80103176:	eb 50                	jmp    801031c8 <mpsearch1+0x68>
80103178:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010317f:	90                   	nop
80103180:	89 fe                	mov    %edi,%esi
80103182:	39 fb                	cmp    %edi,%ebx
80103184:	76 42                	jbe    801031c8 <mpsearch1+0x68>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103186:	83 ec 04             	sub    $0x4,%esp
80103189:	8d 7e 10             	lea    0x10(%esi),%edi
8010318c:	6a 04                	push   $0x4
8010318e:	68 f8 74 10 80       	push   $0x801074f8
80103193:	56                   	push   %esi
80103194:	e8 a7 14 00 00       	call   80104640 <memcmp>
80103199:	83 c4 10             	add    $0x10,%esp
8010319c:	85 c0                	test   %eax,%eax
8010319e:	75 e0                	jne    80103180 <mpsearch1+0x20>
801031a0:	89 f1                	mov    %esi,%ecx
801031a2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    sum += addr[i];
801031a8:	0f b6 11             	movzbl (%ecx),%edx
801031ab:	83 c1 01             	add    $0x1,%ecx
801031ae:	01 d0                	add    %edx,%eax
  for(i=0; i<len; i++)
801031b0:	39 f9                	cmp    %edi,%ecx
801031b2:	75 f4                	jne    801031a8 <mpsearch1+0x48>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
801031b4:	84 c0                	test   %al,%al
801031b6:	75 c8                	jne    80103180 <mpsearch1+0x20>
      return (struct mp*)p;
  return 0;
}
801031b8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801031bb:	89 f0                	mov    %esi,%eax
801031bd:	5b                   	pop    %ebx
801031be:	5e                   	pop    %esi
801031bf:	5f                   	pop    %edi
801031c0:	5d                   	pop    %ebp
801031c1:	c3                   	ret    
801031c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801031c8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801031cb:	31 f6                	xor    %esi,%esi
}
801031cd:	5b                   	pop    %ebx
801031ce:	89 f0                	mov    %esi,%eax
801031d0:	5e                   	pop    %esi
801031d1:	5f                   	pop    %edi
801031d2:	5d                   	pop    %ebp
801031d3:	c3                   	ret    
801031d4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801031db:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801031df:	90                   	nop

801031e0 <mpinit>:
  return conf;
}

void
mpinit(void)
{
801031e0:	55                   	push   %ebp
801031e1:	89 e5                	mov    %esp,%ebp
801031e3:	57                   	push   %edi
801031e4:	56                   	push   %esi
801031e5:	53                   	push   %ebx
801031e6:	83 ec 1c             	sub    $0x1c,%esp
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
801031e9:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
801031f0:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
801031f7:	c1 e0 08             	shl    $0x8,%eax
801031fa:	09 d0                	or     %edx,%eax
801031fc:	c1 e0 04             	shl    $0x4,%eax
801031ff:	75 1b                	jne    8010321c <mpinit+0x3c>
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
80103201:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
80103208:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
8010320f:	c1 e0 08             	shl    $0x8,%eax
80103212:	09 d0                	or     %edx,%eax
80103214:	c1 e0 0a             	shl    $0xa,%eax
    if((mp = mpsearch1(p-1024, 1024)))
80103217:	2d 00 04 00 00       	sub    $0x400,%eax
    if((mp = mpsearch1(p, 1024)))
8010321c:	ba 00 04 00 00       	mov    $0x400,%edx
80103221:	e8 3a ff ff ff       	call   80103160 <mpsearch1>
80103226:	89 c7                	mov    %eax,%edi
80103228:	85 c0                	test   %eax,%eax
8010322a:	0f 84 c0 00 00 00    	je     801032f0 <mpinit+0x110>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103230:	8b 5f 04             	mov    0x4(%edi),%ebx
80103233:	85 db                	test   %ebx,%ebx
80103235:	0f 84 d5 00 00 00    	je     80103310 <mpinit+0x130>
  if(memcmp(conf, "PCMP", 4) != 0)
8010323b:	83 ec 04             	sub    $0x4,%esp
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
8010323e:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
  if(memcmp(conf, "PCMP", 4) != 0)
80103244:	6a 04                	push   $0x4
80103246:	68 15 75 10 80       	push   $0x80107515
8010324b:	50                   	push   %eax
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
8010324c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
8010324f:	e8 ec 13 00 00       	call   80104640 <memcmp>
80103254:	83 c4 10             	add    $0x10,%esp
80103257:	85 c0                	test   %eax,%eax
80103259:	0f 85 b1 00 00 00    	jne    80103310 <mpinit+0x130>
  if(conf->version != 1 && conf->version != 4)
8010325f:	0f b6 83 06 00 00 80 	movzbl -0x7ffffffa(%ebx),%eax
80103266:	3c 01                	cmp    $0x1,%al
80103268:	0f 95 c2             	setne  %dl
8010326b:	3c 04                	cmp    $0x4,%al
8010326d:	0f 95 c0             	setne  %al
80103270:	20 c2                	and    %al,%dl
80103272:	0f 85 98 00 00 00    	jne    80103310 <mpinit+0x130>
  if(sum((uchar*)conf, conf->length) != 0)
80103278:	0f b7 8b 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%ecx
  for(i=0; i<len; i++)
8010327f:	66 85 c9             	test   %cx,%cx
80103282:	74 21                	je     801032a5 <mpinit+0xc5>
80103284:	89 d8                	mov    %ebx,%eax
80103286:	8d 34 19             	lea    (%ecx,%ebx,1),%esi
  sum = 0;
80103289:	31 d2                	xor    %edx,%edx
8010328b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010328f:	90                   	nop
    sum += addr[i];
80103290:	0f b6 88 00 00 00 80 	movzbl -0x80000000(%eax),%ecx
80103297:	83 c0 01             	add    $0x1,%eax
8010329a:	01 ca                	add    %ecx,%edx
  for(i=0; i<len; i++)
8010329c:	39 c6                	cmp    %eax,%esi
8010329e:	75 f0                	jne    80103290 <mpinit+0xb0>
801032a0:	84 d2                	test   %dl,%dl
801032a2:	0f 95 c2             	setne  %dl
  struct mp *mp;
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
801032a5:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801032a8:	85 c9                	test   %ecx,%ecx
801032aa:	74 64                	je     80103310 <mpinit+0x130>
801032ac:	84 d2                	test   %dl,%dl
801032ae:	75 60                	jne    80103310 <mpinit+0x130>
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
801032b0:	8b 83 24 00 00 80    	mov    -0x7fffffdc(%ebx),%eax
801032b6:	a3 7c 26 11 80       	mov    %eax,0x8011267c
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801032bb:	0f b7 93 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edx
801032c2:	8d 83 2c 00 00 80    	lea    -0x7fffffd4(%ebx),%eax
  ismp = 1;
801032c8:	bb 01 00 00 00       	mov    $0x1,%ebx
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801032cd:	01 d1                	add    %edx,%ecx
801032cf:	89 ce                	mov    %ecx,%esi
801032d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801032d8:	39 c6                	cmp    %eax,%esi
801032da:	76 4b                	jbe    80103327 <mpinit+0x147>
    switch(*p){
801032dc:	0f b6 10             	movzbl (%eax),%edx
801032df:	80 fa 04             	cmp    $0x4,%dl
801032e2:	0f 87 bf 00 00 00    	ja     801033a7 <mpinit+0x1c7>
801032e8:	ff 24 95 3c 75 10 80 	jmp    *-0x7fef8ac4(,%edx,4)
801032ef:	90                   	nop
  return mpsearch1(0xF0000, 0x10000);
801032f0:	ba 00 00 01 00       	mov    $0x10000,%edx
801032f5:	b8 00 00 0f 00       	mov    $0xf0000,%eax
801032fa:	e8 61 fe ff ff       	call   80103160 <mpsearch1>
801032ff:	89 c7                	mov    %eax,%edi
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103301:	85 c0                	test   %eax,%eax
80103303:	0f 85 27 ff ff ff    	jne    80103230 <mpinit+0x50>
80103309:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    panic("Expect to run on an SMP");
80103310:	83 ec 0c             	sub    $0xc,%esp
80103313:	68 fd 74 10 80       	push   $0x801074fd
80103318:	e8 73 d0 ff ff       	call   80100390 <panic>
8010331d:	8d 76 00             	lea    0x0(%esi),%esi
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
80103320:	83 c0 08             	add    $0x8,%eax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103323:	39 c6                	cmp    %eax,%esi
80103325:	77 b5                	ja     801032dc <mpinit+0xfc>
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
80103327:	85 db                	test   %ebx,%ebx
80103329:	74 6f                	je     8010339a <mpinit+0x1ba>
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
8010332b:	80 7f 0c 00          	cmpb   $0x0,0xc(%edi)
8010332f:	74 15                	je     80103346 <mpinit+0x166>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103331:	b8 70 00 00 00       	mov    $0x70,%eax
80103336:	ba 22 00 00 00       	mov    $0x22,%edx
8010333b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010333c:	ba 23 00 00 00       	mov    $0x23,%edx
80103341:	ec                   	in     (%dx),%al
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
80103342:	83 c8 01             	or     $0x1,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103345:	ee                   	out    %al,(%dx)
  }
}
80103346:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103349:	5b                   	pop    %ebx
8010334a:	5e                   	pop    %esi
8010334b:	5f                   	pop    %edi
8010334c:	5d                   	pop    %ebp
8010334d:	c3                   	ret    
8010334e:	66 90                	xchg   %ax,%ax
      if(ncpu < NCPU) {
80103350:	8b 15 00 2d 11 80    	mov    0x80112d00,%edx
80103356:	83 fa 07             	cmp    $0x7,%edx
80103359:	7f 1f                	jg     8010337a <mpinit+0x19a>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
8010335b:	69 ca b0 00 00 00    	imul   $0xb0,%edx,%ecx
80103361:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80103364:	0f b6 50 01          	movzbl 0x1(%eax),%edx
80103368:	88 91 80 27 11 80    	mov    %dl,-0x7feed880(%ecx)
        ncpu++;
8010336e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103371:	83 c2 01             	add    $0x1,%edx
80103374:	89 15 00 2d 11 80    	mov    %edx,0x80112d00
      p += sizeof(struct mpproc);
8010337a:	83 c0 14             	add    $0x14,%eax
      continue;
8010337d:	e9 56 ff ff ff       	jmp    801032d8 <mpinit+0xf8>
80103382:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      ioapicid = ioapic->apicno;
80103388:	0f b6 50 01          	movzbl 0x1(%eax),%edx
      p += sizeof(struct mpioapic);
8010338c:	83 c0 08             	add    $0x8,%eax
      ioapicid = ioapic->apicno;
8010338f:	88 15 60 27 11 80    	mov    %dl,0x80112760
      continue;
80103395:	e9 3e ff ff ff       	jmp    801032d8 <mpinit+0xf8>
    panic("Didn't find a suitable machine");
8010339a:	83 ec 0c             	sub    $0xc,%esp
8010339d:	68 1c 75 10 80       	push   $0x8010751c
801033a2:	e8 e9 cf ff ff       	call   80100390 <panic>
      ismp = 0;
801033a7:	31 db                	xor    %ebx,%ebx
801033a9:	e9 31 ff ff ff       	jmp    801032df <mpinit+0xff>
801033ae:	66 90                	xchg   %ax,%ax

801033b0 <picinit>:
801033b0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801033b5:	ba 21 00 00 00       	mov    $0x21,%edx
801033ba:	ee                   	out    %al,(%dx)
801033bb:	ba a1 00 00 00       	mov    $0xa1,%edx
801033c0:	ee                   	out    %al,(%dx)
picinit(void)
{
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
801033c1:	c3                   	ret    
801033c2:	66 90                	xchg   %ax,%ax
801033c4:	66 90                	xchg   %ax,%ax
801033c6:	66 90                	xchg   %ax,%ax
801033c8:	66 90                	xchg   %ax,%ax
801033ca:	66 90                	xchg   %ax,%ax
801033cc:	66 90                	xchg   %ax,%ax
801033ce:	66 90                	xchg   %ax,%ax

801033d0 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
801033d0:	55                   	push   %ebp
801033d1:	89 e5                	mov    %esp,%ebp
801033d3:	57                   	push   %edi
801033d4:	56                   	push   %esi
801033d5:	53                   	push   %ebx
801033d6:	83 ec 0c             	sub    $0xc,%esp
801033d9:	8b 5d 08             	mov    0x8(%ebp),%ebx
801033dc:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
801033df:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
801033e5:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
801033eb:	e8 10 da ff ff       	call   80100e00 <filealloc>
801033f0:	89 03                	mov    %eax,(%ebx)
801033f2:	85 c0                	test   %eax,%eax
801033f4:	0f 84 a8 00 00 00    	je     801034a2 <pipealloc+0xd2>
801033fa:	e8 01 da ff ff       	call   80100e00 <filealloc>
801033ff:	89 06                	mov    %eax,(%esi)
80103401:	85 c0                	test   %eax,%eax
80103403:	0f 84 87 00 00 00    	je     80103490 <pipealloc+0xc0>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
80103409:	e8 a2 f1 ff ff       	call   801025b0 <kalloc>
8010340e:	89 c7                	mov    %eax,%edi
80103410:	85 c0                	test   %eax,%eax
80103412:	0f 84 b0 00 00 00    	je     801034c8 <pipealloc+0xf8>
    goto bad;
  p->readopen = 1;
80103418:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
8010341f:	00 00 00 
  p->writeopen = 1;
  p->nwrite = 0;
  p->nread = 0;
  initlock(&p->lock, "pipe");
80103422:	83 ec 08             	sub    $0x8,%esp
  p->writeopen = 1;
80103425:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
8010342c:	00 00 00 
  p->nwrite = 0;
8010342f:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
80103436:	00 00 00 
  p->nread = 0;
80103439:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
80103440:	00 00 00 
  initlock(&p->lock, "pipe");
80103443:	68 50 75 10 80       	push   $0x80107550
80103448:	50                   	push   %eax
80103449:	e8 32 0f 00 00       	call   80104380 <initlock>
  (*f0)->type = FD_PIPE;
8010344e:	8b 03                	mov    (%ebx),%eax
  (*f0)->pipe = p;
  (*f1)->type = FD_PIPE;
  (*f1)->readable = 0;
  (*f1)->writable = 1;
  (*f1)->pipe = p;
  return 0;
80103450:	83 c4 10             	add    $0x10,%esp
  (*f0)->type = FD_PIPE;
80103453:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
80103459:	8b 03                	mov    (%ebx),%eax
8010345b:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
8010345f:	8b 03                	mov    (%ebx),%eax
80103461:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
80103465:	8b 03                	mov    (%ebx),%eax
80103467:	89 78 0c             	mov    %edi,0xc(%eax)
  (*f1)->type = FD_PIPE;
8010346a:	8b 06                	mov    (%esi),%eax
8010346c:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
80103472:	8b 06                	mov    (%esi),%eax
80103474:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
80103478:	8b 06                	mov    (%esi),%eax
8010347a:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
8010347e:	8b 06                	mov    (%esi),%eax
80103480:	89 78 0c             	mov    %edi,0xc(%eax)
  if(*f0)
    fileclose(*f0);
  if(*f1)
    fileclose(*f1);
  return -1;
}
80103483:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80103486:	31 c0                	xor    %eax,%eax
}
80103488:	5b                   	pop    %ebx
80103489:	5e                   	pop    %esi
8010348a:	5f                   	pop    %edi
8010348b:	5d                   	pop    %ebp
8010348c:	c3                   	ret    
8010348d:	8d 76 00             	lea    0x0(%esi),%esi
  if(*f0)
80103490:	8b 03                	mov    (%ebx),%eax
80103492:	85 c0                	test   %eax,%eax
80103494:	74 1e                	je     801034b4 <pipealloc+0xe4>
    fileclose(*f0);
80103496:	83 ec 0c             	sub    $0xc,%esp
80103499:	50                   	push   %eax
8010349a:	e8 21 da ff ff       	call   80100ec0 <fileclose>
8010349f:	83 c4 10             	add    $0x10,%esp
  if(*f1)
801034a2:	8b 06                	mov    (%esi),%eax
801034a4:	85 c0                	test   %eax,%eax
801034a6:	74 0c                	je     801034b4 <pipealloc+0xe4>
    fileclose(*f1);
801034a8:	83 ec 0c             	sub    $0xc,%esp
801034ab:	50                   	push   %eax
801034ac:	e8 0f da ff ff       	call   80100ec0 <fileclose>
801034b1:	83 c4 10             	add    $0x10,%esp
}
801034b4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return -1;
801034b7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801034bc:	5b                   	pop    %ebx
801034bd:	5e                   	pop    %esi
801034be:	5f                   	pop    %edi
801034bf:	5d                   	pop    %ebp
801034c0:	c3                   	ret    
801034c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(*f0)
801034c8:	8b 03                	mov    (%ebx),%eax
801034ca:	85 c0                	test   %eax,%eax
801034cc:	75 c8                	jne    80103496 <pipealloc+0xc6>
801034ce:	eb d2                	jmp    801034a2 <pipealloc+0xd2>

801034d0 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
801034d0:	55                   	push   %ebp
801034d1:	89 e5                	mov    %esp,%ebp
801034d3:	56                   	push   %esi
801034d4:	53                   	push   %ebx
801034d5:	8b 5d 08             	mov    0x8(%ebp),%ebx
801034d8:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
801034db:	83 ec 0c             	sub    $0xc,%esp
801034de:	53                   	push   %ebx
801034df:	e8 fc 0f 00 00       	call   801044e0 <acquire>
  if(writable){
801034e4:	83 c4 10             	add    $0x10,%esp
801034e7:	85 f6                	test   %esi,%esi
801034e9:	74 65                	je     80103550 <pipeclose+0x80>
    p->writeopen = 0;
    wakeup(&p->nread);
801034eb:	83 ec 0c             	sub    $0xc,%esp
801034ee:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
    p->writeopen = 0;
801034f4:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
801034fb:	00 00 00 
    wakeup(&p->nread);
801034fe:	50                   	push   %eax
801034ff:	e8 ac 0b 00 00       	call   801040b0 <wakeup>
80103504:	83 c4 10             	add    $0x10,%esp
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
80103507:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
8010350d:	85 d2                	test   %edx,%edx
8010350f:	75 0a                	jne    8010351b <pipeclose+0x4b>
80103511:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
80103517:	85 c0                	test   %eax,%eax
80103519:	74 15                	je     80103530 <pipeclose+0x60>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
8010351b:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
8010351e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103521:	5b                   	pop    %ebx
80103522:	5e                   	pop    %esi
80103523:	5d                   	pop    %ebp
    release(&p->lock);
80103524:	e9 77 10 00 00       	jmp    801045a0 <release>
80103529:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    release(&p->lock);
80103530:	83 ec 0c             	sub    $0xc,%esp
80103533:	53                   	push   %ebx
80103534:	e8 67 10 00 00       	call   801045a0 <release>
    kfree((char*)p);
80103539:	89 5d 08             	mov    %ebx,0x8(%ebp)
8010353c:	83 c4 10             	add    $0x10,%esp
}
8010353f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103542:	5b                   	pop    %ebx
80103543:	5e                   	pop    %esi
80103544:	5d                   	pop    %ebp
    kfree((char*)p);
80103545:	e9 a6 ee ff ff       	jmp    801023f0 <kfree>
8010354a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    wakeup(&p->nwrite);
80103550:	83 ec 0c             	sub    $0xc,%esp
80103553:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
    p->readopen = 0;
80103559:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
80103560:	00 00 00 
    wakeup(&p->nwrite);
80103563:	50                   	push   %eax
80103564:	e8 47 0b 00 00       	call   801040b0 <wakeup>
80103569:	83 c4 10             	add    $0x10,%esp
8010356c:	eb 99                	jmp    80103507 <pipeclose+0x37>
8010356e:	66 90                	xchg   %ax,%ax

80103570 <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
80103570:	55                   	push   %ebp
80103571:	89 e5                	mov    %esp,%ebp
80103573:	57                   	push   %edi
80103574:	56                   	push   %esi
80103575:	53                   	push   %ebx
80103576:	83 ec 28             	sub    $0x28,%esp
80103579:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  acquire(&p->lock);
8010357c:	53                   	push   %ebx
8010357d:	e8 5e 0f 00 00       	call   801044e0 <acquire>
  for(i = 0; i < n; i++){
80103582:	8b 45 10             	mov    0x10(%ebp),%eax
80103585:	83 c4 10             	add    $0x10,%esp
80103588:	85 c0                	test   %eax,%eax
8010358a:	0f 8e c8 00 00 00    	jle    80103658 <pipewrite+0xe8>
80103590:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80103593:	8b 83 38 02 00 00    	mov    0x238(%ebx),%eax
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
      if(p->readopen == 0 || myproc()->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
80103599:	8d bb 34 02 00 00    	lea    0x234(%ebx),%edi
8010359f:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
801035a2:	03 4d 10             	add    0x10(%ebp),%ecx
801035a5:	89 4d e0             	mov    %ecx,-0x20(%ebp)
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801035a8:	8b 8b 34 02 00 00    	mov    0x234(%ebx),%ecx
801035ae:	8d 91 00 02 00 00    	lea    0x200(%ecx),%edx
801035b4:	39 d0                	cmp    %edx,%eax
801035b6:	75 71                	jne    80103629 <pipewrite+0xb9>
      if(p->readopen == 0 || myproc()->killed){
801035b8:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
801035be:	85 c0                	test   %eax,%eax
801035c0:	74 4e                	je     80103610 <pipewrite+0xa0>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
801035c2:	8d b3 38 02 00 00    	lea    0x238(%ebx),%esi
801035c8:	eb 3a                	jmp    80103604 <pipewrite+0x94>
801035ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      wakeup(&p->nread);
801035d0:	83 ec 0c             	sub    $0xc,%esp
801035d3:	57                   	push   %edi
801035d4:	e8 d7 0a 00 00       	call   801040b0 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
801035d9:	5a                   	pop    %edx
801035da:	59                   	pop    %ecx
801035db:	53                   	push   %ebx
801035dc:	56                   	push   %esi
801035dd:	e8 1e 09 00 00       	call   80103f00 <sleep>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801035e2:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
801035e8:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
801035ee:	83 c4 10             	add    $0x10,%esp
801035f1:	05 00 02 00 00       	add    $0x200,%eax
801035f6:	39 c2                	cmp    %eax,%edx
801035f8:	75 36                	jne    80103630 <pipewrite+0xc0>
      if(p->readopen == 0 || myproc()->killed){
801035fa:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
80103600:	85 c0                	test   %eax,%eax
80103602:	74 0c                	je     80103610 <pipewrite+0xa0>
80103604:	e8 57 03 00 00       	call   80103960 <myproc>
80103609:	8b 40 24             	mov    0x24(%eax),%eax
8010360c:	85 c0                	test   %eax,%eax
8010360e:	74 c0                	je     801035d0 <pipewrite+0x60>
        release(&p->lock);
80103610:	83 ec 0c             	sub    $0xc,%esp
80103613:	53                   	push   %ebx
80103614:	e8 87 0f 00 00       	call   801045a0 <release>
        return -1;
80103619:	83 c4 10             	add    $0x10,%esp
8010361c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
80103621:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103624:	5b                   	pop    %ebx
80103625:	5e                   	pop    %esi
80103626:	5f                   	pop    %edi
80103627:	5d                   	pop    %ebp
80103628:	c3                   	ret    
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103629:	89 c2                	mov    %eax,%edx
8010362b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010362f:	90                   	nop
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80103630:	8b 75 e4             	mov    -0x1c(%ebp),%esi
80103633:	8d 42 01             	lea    0x1(%edx),%eax
80103636:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
8010363c:	89 83 38 02 00 00    	mov    %eax,0x238(%ebx)
80103642:	0f b6 0e             	movzbl (%esi),%ecx
80103645:	83 c6 01             	add    $0x1,%esi
80103648:	89 75 e4             	mov    %esi,-0x1c(%ebp)
8010364b:	88 4c 13 34          	mov    %cl,0x34(%ebx,%edx,1)
  for(i = 0; i < n; i++){
8010364f:	3b 75 e0             	cmp    -0x20(%ebp),%esi
80103652:	0f 85 50 ff ff ff    	jne    801035a8 <pipewrite+0x38>
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
80103658:	83 ec 0c             	sub    $0xc,%esp
8010365b:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
80103661:	50                   	push   %eax
80103662:	e8 49 0a 00 00       	call   801040b0 <wakeup>
  release(&p->lock);
80103667:	89 1c 24             	mov    %ebx,(%esp)
8010366a:	e8 31 0f 00 00       	call   801045a0 <release>
  return n;
8010366f:	83 c4 10             	add    $0x10,%esp
80103672:	8b 45 10             	mov    0x10(%ebp),%eax
80103675:	eb aa                	jmp    80103621 <pipewrite+0xb1>
80103677:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010367e:	66 90                	xchg   %ax,%ax

80103680 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
80103680:	55                   	push   %ebp
80103681:	89 e5                	mov    %esp,%ebp
80103683:	57                   	push   %edi
80103684:	56                   	push   %esi
80103685:	53                   	push   %ebx
80103686:	83 ec 18             	sub    $0x18,%esp
80103689:	8b 75 08             	mov    0x8(%ebp),%esi
8010368c:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
8010368f:	56                   	push   %esi
80103690:	e8 4b 0e 00 00       	call   801044e0 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103695:	83 c4 10             	add    $0x10,%esp
80103698:	8b 8e 34 02 00 00    	mov    0x234(%esi),%ecx
8010369e:	3b 8e 38 02 00 00    	cmp    0x238(%esi),%ecx
801036a4:	75 6a                	jne    80103710 <piperead+0x90>
801036a6:	8b 9e 40 02 00 00    	mov    0x240(%esi),%ebx
801036ac:	85 db                	test   %ebx,%ebx
801036ae:	0f 84 c4 00 00 00    	je     80103778 <piperead+0xf8>
    if(myproc()->killed){
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
801036b4:	8d 9e 34 02 00 00    	lea    0x234(%esi),%ebx
801036ba:	eb 2d                	jmp    801036e9 <piperead+0x69>
801036bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801036c0:	83 ec 08             	sub    $0x8,%esp
801036c3:	56                   	push   %esi
801036c4:	53                   	push   %ebx
801036c5:	e8 36 08 00 00       	call   80103f00 <sleep>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
801036ca:	83 c4 10             	add    $0x10,%esp
801036cd:	8b 8e 34 02 00 00    	mov    0x234(%esi),%ecx
801036d3:	3b 8e 38 02 00 00    	cmp    0x238(%esi),%ecx
801036d9:	75 35                	jne    80103710 <piperead+0x90>
801036db:	8b 96 40 02 00 00    	mov    0x240(%esi),%edx
801036e1:	85 d2                	test   %edx,%edx
801036e3:	0f 84 8f 00 00 00    	je     80103778 <piperead+0xf8>
    if(myproc()->killed){
801036e9:	e8 72 02 00 00       	call   80103960 <myproc>
801036ee:	8b 48 24             	mov    0x24(%eax),%ecx
801036f1:	85 c9                	test   %ecx,%ecx
801036f3:	74 cb                	je     801036c0 <piperead+0x40>
      release(&p->lock);
801036f5:	83 ec 0c             	sub    $0xc,%esp
      return -1;
801036f8:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
      release(&p->lock);
801036fd:	56                   	push   %esi
801036fe:	e8 9d 0e 00 00       	call   801045a0 <release>
      return -1;
80103703:	83 c4 10             	add    $0x10,%esp
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
  release(&p->lock);
  return i;
}
80103706:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103709:	89 d8                	mov    %ebx,%eax
8010370b:	5b                   	pop    %ebx
8010370c:	5e                   	pop    %esi
8010370d:	5f                   	pop    %edi
8010370e:	5d                   	pop    %ebp
8010370f:	c3                   	ret    
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103710:	8b 45 10             	mov    0x10(%ebp),%eax
80103713:	85 c0                	test   %eax,%eax
80103715:	7e 61                	jle    80103778 <piperead+0xf8>
    if(p->nread == p->nwrite)
80103717:	31 db                	xor    %ebx,%ebx
80103719:	eb 13                	jmp    8010372e <piperead+0xae>
8010371b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010371f:	90                   	nop
80103720:	8b 8e 34 02 00 00    	mov    0x234(%esi),%ecx
80103726:	3b 8e 38 02 00 00    	cmp    0x238(%esi),%ecx
8010372c:	74 1f                	je     8010374d <piperead+0xcd>
    addr[i] = p->data[p->nread++ % PIPESIZE];
8010372e:	8d 41 01             	lea    0x1(%ecx),%eax
80103731:	81 e1 ff 01 00 00    	and    $0x1ff,%ecx
80103737:	89 86 34 02 00 00    	mov    %eax,0x234(%esi)
8010373d:	0f b6 44 0e 34       	movzbl 0x34(%esi,%ecx,1),%eax
80103742:	88 04 1f             	mov    %al,(%edi,%ebx,1)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103745:	83 c3 01             	add    $0x1,%ebx
80103748:	39 5d 10             	cmp    %ebx,0x10(%ebp)
8010374b:	75 d3                	jne    80103720 <piperead+0xa0>
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
8010374d:	83 ec 0c             	sub    $0xc,%esp
80103750:	8d 86 38 02 00 00    	lea    0x238(%esi),%eax
80103756:	50                   	push   %eax
80103757:	e8 54 09 00 00       	call   801040b0 <wakeup>
  release(&p->lock);
8010375c:	89 34 24             	mov    %esi,(%esp)
8010375f:	e8 3c 0e 00 00       	call   801045a0 <release>
  return i;
80103764:	83 c4 10             	add    $0x10,%esp
}
80103767:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010376a:	89 d8                	mov    %ebx,%eax
8010376c:	5b                   	pop    %ebx
8010376d:	5e                   	pop    %esi
8010376e:	5f                   	pop    %edi
8010376f:	5d                   	pop    %ebp
80103770:	c3                   	ret    
80103771:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(p->nread == p->nwrite)
80103778:	31 db                	xor    %ebx,%ebx
8010377a:	eb d1                	jmp    8010374d <piperead+0xcd>
8010377c:	66 90                	xchg   %ax,%ax
8010377e:	66 90                	xchg   %ax,%ax

80103780 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
80103780:	55                   	push   %ebp
80103781:	89 e5                	mov    %esp,%ebp
80103783:	53                   	push   %ebx
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103784:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
{
80103789:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);
8010378c:	68 20 2d 11 80       	push   $0x80112d20
80103791:	e8 4a 0d 00 00       	call   801044e0 <acquire>
80103796:	83 c4 10             	add    $0x10,%esp
80103799:	eb 10                	jmp    801037ab <allocproc+0x2b>
8010379b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010379f:	90                   	nop
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801037a0:	83 c3 7c             	add    $0x7c,%ebx
801037a3:	81 fb 54 4c 11 80    	cmp    $0x80114c54,%ebx
801037a9:	74 75                	je     80103820 <allocproc+0xa0>
    if(p->state == UNUSED)
801037ab:	8b 43 0c             	mov    0xc(%ebx),%eax
801037ae:	85 c0                	test   %eax,%eax
801037b0:	75 ee                	jne    801037a0 <allocproc+0x20>
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
801037b2:	a1 04 a0 10 80       	mov    0x8010a004,%eax

  release(&ptable.lock);
801037b7:	83 ec 0c             	sub    $0xc,%esp
  p->state = EMBRYO;
801037ba:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
  p->pid = nextpid++;
801037c1:	89 43 10             	mov    %eax,0x10(%ebx)
801037c4:	8d 50 01             	lea    0x1(%eax),%edx
  release(&ptable.lock);
801037c7:	68 20 2d 11 80       	push   $0x80112d20
  p->pid = nextpid++;
801037cc:	89 15 04 a0 10 80    	mov    %edx,0x8010a004
  release(&ptable.lock);
801037d2:	e8 c9 0d 00 00       	call   801045a0 <release>

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
801037d7:	e8 d4 ed ff ff       	call   801025b0 <kalloc>
801037dc:	83 c4 10             	add    $0x10,%esp
801037df:	89 43 08             	mov    %eax,0x8(%ebx)
801037e2:	85 c0                	test   %eax,%eax
801037e4:	74 53                	je     80103839 <allocproc+0xb9>
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
801037e6:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
801037ec:	83 ec 04             	sub    $0x4,%esp
  sp -= sizeof *p->context;
801037ef:	05 9c 0f 00 00       	add    $0xf9c,%eax
  sp -= sizeof *p->tf;
801037f4:	89 53 18             	mov    %edx,0x18(%ebx)
  *(uint*)sp = (uint)trapret;
801037f7:	c7 40 14 a2 57 10 80 	movl   $0x801057a2,0x14(%eax)
  p->context = (struct context*)sp;
801037fe:	89 43 1c             	mov    %eax,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
80103801:	6a 14                	push   $0x14
80103803:	6a 00                	push   $0x0
80103805:	50                   	push   %eax
80103806:	e8 e5 0d 00 00       	call   801045f0 <memset>
  p->context->eip = (uint)forkret;
8010380b:	8b 43 1c             	mov    0x1c(%ebx),%eax

  return p;
8010380e:	83 c4 10             	add    $0x10,%esp
  p->context->eip = (uint)forkret;
80103811:	c7 40 10 50 38 10 80 	movl   $0x80103850,0x10(%eax)
}
80103818:	89 d8                	mov    %ebx,%eax
8010381a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010381d:	c9                   	leave  
8010381e:	c3                   	ret    
8010381f:	90                   	nop
  release(&ptable.lock);
80103820:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80103823:	31 db                	xor    %ebx,%ebx
  release(&ptable.lock);
80103825:	68 20 2d 11 80       	push   $0x80112d20
8010382a:	e8 71 0d 00 00       	call   801045a0 <release>
}
8010382f:	89 d8                	mov    %ebx,%eax
  return 0;
80103831:	83 c4 10             	add    $0x10,%esp
}
80103834:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103837:	c9                   	leave  
80103838:	c3                   	ret    
    p->state = UNUSED;
80103839:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return 0;
80103840:	31 db                	xor    %ebx,%ebx
}
80103842:	89 d8                	mov    %ebx,%eax
80103844:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103847:	c9                   	leave  
80103848:	c3                   	ret    
80103849:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103850 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
80103850:	55                   	push   %ebp
80103851:	89 e5                	mov    %esp,%ebp
80103853:	83 ec 14             	sub    $0x14,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
80103856:	68 20 2d 11 80       	push   $0x80112d20
8010385b:	e8 40 0d 00 00       	call   801045a0 <release>

  if (first) {
80103860:	a1 00 a0 10 80       	mov    0x8010a000,%eax
80103865:	83 c4 10             	add    $0x10,%esp
80103868:	85 c0                	test   %eax,%eax
8010386a:	75 04                	jne    80103870 <forkret+0x20>
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}
8010386c:	c9                   	leave  
8010386d:	c3                   	ret    
8010386e:	66 90                	xchg   %ax,%ax
    first = 0;
80103870:	c7 05 00 a0 10 80 00 	movl   $0x0,0x8010a000
80103877:	00 00 00 
    iinit(ROOTDEV);
8010387a:	83 ec 0c             	sub    $0xc,%esp
8010387d:	6a 01                	push   $0x1
8010387f:	e8 9c dc ff ff       	call   80101520 <iinit>
    initlog(ROOTDEV);
80103884:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
8010388b:	e8 f0 f3 ff ff       	call   80102c80 <initlog>
80103890:	83 c4 10             	add    $0x10,%esp
}
80103893:	c9                   	leave  
80103894:	c3                   	ret    
80103895:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010389c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801038a0 <pinit>:
{
801038a0:	55                   	push   %ebp
801038a1:	89 e5                	mov    %esp,%ebp
801038a3:	83 ec 10             	sub    $0x10,%esp
  initlock(&ptable.lock, "ptable");
801038a6:	68 55 75 10 80       	push   $0x80107555
801038ab:	68 20 2d 11 80       	push   $0x80112d20
801038b0:	e8 cb 0a 00 00       	call   80104380 <initlock>
}
801038b5:	83 c4 10             	add    $0x10,%esp
801038b8:	c9                   	leave  
801038b9:	c3                   	ret    
801038ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801038c0 <mycpu>:
{
801038c0:	55                   	push   %ebp
801038c1:	89 e5                	mov    %esp,%ebp
801038c3:	56                   	push   %esi
801038c4:	53                   	push   %ebx
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801038c5:	9c                   	pushf  
801038c6:	58                   	pop    %eax
  if(readeflags()&FL_IF)
801038c7:	f6 c4 02             	test   $0x2,%ah
801038ca:	75 5d                	jne    80103929 <mycpu+0x69>
  apicid = lapicid();
801038cc:	e8 df ef ff ff       	call   801028b0 <lapicid>
  for (i = 0; i < ncpu; ++i) {
801038d1:	8b 35 00 2d 11 80    	mov    0x80112d00,%esi
801038d7:	85 f6                	test   %esi,%esi
801038d9:	7e 41                	jle    8010391c <mycpu+0x5c>
    if (cpus[i].apicid == apicid)
801038db:	0f b6 15 80 27 11 80 	movzbl 0x80112780,%edx
801038e2:	39 d0                	cmp    %edx,%eax
801038e4:	74 2f                	je     80103915 <mycpu+0x55>
  for (i = 0; i < ncpu; ++i) {
801038e6:	31 d2                	xor    %edx,%edx
801038e8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801038ef:	90                   	nop
801038f0:	83 c2 01             	add    $0x1,%edx
801038f3:	39 f2                	cmp    %esi,%edx
801038f5:	74 25                	je     8010391c <mycpu+0x5c>
    if (cpus[i].apicid == apicid)
801038f7:	69 ca b0 00 00 00    	imul   $0xb0,%edx,%ecx
801038fd:	0f b6 99 80 27 11 80 	movzbl -0x7feed880(%ecx),%ebx
80103904:	39 c3                	cmp    %eax,%ebx
80103906:	75 e8                	jne    801038f0 <mycpu+0x30>
80103908:	8d 81 80 27 11 80    	lea    -0x7feed880(%ecx),%eax
}
8010390e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103911:	5b                   	pop    %ebx
80103912:	5e                   	pop    %esi
80103913:	5d                   	pop    %ebp
80103914:	c3                   	ret    
    if (cpus[i].apicid == apicid)
80103915:	b8 80 27 11 80       	mov    $0x80112780,%eax
      return &cpus[i];
8010391a:	eb f2                	jmp    8010390e <mycpu+0x4e>
  panic("unknown apicid\n");
8010391c:	83 ec 0c             	sub    $0xc,%esp
8010391f:	68 5c 75 10 80       	push   $0x8010755c
80103924:	e8 67 ca ff ff       	call   80100390 <panic>
    panic("mycpu called with interrupts enabled\n");
80103929:	83 ec 0c             	sub    $0xc,%esp
8010392c:	68 38 76 10 80       	push   $0x80107638
80103931:	e8 5a ca ff ff       	call   80100390 <panic>
80103936:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010393d:	8d 76 00             	lea    0x0(%esi),%esi

80103940 <cpuid>:
cpuid() {
80103940:	55                   	push   %ebp
80103941:	89 e5                	mov    %esp,%ebp
80103943:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
80103946:	e8 75 ff ff ff       	call   801038c0 <mycpu>
}
8010394b:	c9                   	leave  
  return mycpu()-cpus;
8010394c:	2d 80 27 11 80       	sub    $0x80112780,%eax
80103951:	c1 f8 04             	sar    $0x4,%eax
80103954:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
8010395a:	c3                   	ret    
8010395b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010395f:	90                   	nop

80103960 <myproc>:
myproc(void) {
80103960:	55                   	push   %ebp
80103961:	89 e5                	mov    %esp,%ebp
80103963:	53                   	push   %ebx
80103964:	83 ec 04             	sub    $0x4,%esp
  pushcli();
80103967:	e8 84 0a 00 00       	call   801043f0 <pushcli>
  c = mycpu();
8010396c:	e8 4f ff ff ff       	call   801038c0 <mycpu>
  p = c->proc;
80103971:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103977:	e8 c4 0a 00 00       	call   80104440 <popcli>
}
8010397c:	83 c4 04             	add    $0x4,%esp
8010397f:	89 d8                	mov    %ebx,%eax
80103981:	5b                   	pop    %ebx
80103982:	5d                   	pop    %ebp
80103983:	c3                   	ret    
80103984:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010398b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010398f:	90                   	nop

80103990 <userinit>:
{
80103990:	55                   	push   %ebp
80103991:	89 e5                	mov    %esp,%ebp
80103993:	53                   	push   %ebx
80103994:	83 ec 04             	sub    $0x4,%esp
  p = allocproc();
80103997:	e8 e4 fd ff ff       	call   80103780 <allocproc>
8010399c:	89 c3                	mov    %eax,%ebx
  initproc = p;
8010399e:	a3 b8 a5 10 80       	mov    %eax,0x8010a5b8
  if((p->pgdir = setupkvm()) == 0)
801039a3:	e8 c8 33 00 00       	call   80106d70 <setupkvm>
801039a8:	89 43 04             	mov    %eax,0x4(%ebx)
801039ab:	85 c0                	test   %eax,%eax
801039ad:	0f 84 bd 00 00 00    	je     80103a70 <userinit+0xe0>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
801039b3:	83 ec 04             	sub    $0x4,%esp
801039b6:	68 2c 00 00 00       	push   $0x2c
801039bb:	68 60 a4 10 80       	push   $0x8010a460
801039c0:	50                   	push   %eax
801039c1:	e8 8a 30 00 00       	call   80106a50 <inituvm>
  memset(p->tf, 0, sizeof(*p->tf));
801039c6:	83 c4 0c             	add    $0xc,%esp
  p->sz = PGSIZE;
801039c9:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
801039cf:	6a 4c                	push   $0x4c
801039d1:	6a 00                	push   $0x0
801039d3:	ff 73 18             	pushl  0x18(%ebx)
801039d6:	e8 15 0c 00 00       	call   801045f0 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
801039db:	8b 43 18             	mov    0x18(%ebx),%eax
801039de:	ba 1b 00 00 00       	mov    $0x1b,%edx
  safestrcpy(p->name, "initcode", sizeof(p->name));
801039e3:	83 c4 0c             	add    $0xc,%esp
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
801039e6:	b9 23 00 00 00       	mov    $0x23,%ecx
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
801039eb:	66 89 50 3c          	mov    %dx,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
801039ef:	8b 43 18             	mov    0x18(%ebx),%eax
801039f2:	66 89 48 2c          	mov    %cx,0x2c(%eax)
  p->tf->es = p->tf->ds;
801039f6:	8b 43 18             	mov    0x18(%ebx),%eax
801039f9:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
801039fd:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
80103a01:	8b 43 18             	mov    0x18(%ebx),%eax
80103a04:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103a08:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
80103a0c:	8b 43 18             	mov    0x18(%ebx),%eax
80103a0f:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
80103a16:	8b 43 18             	mov    0x18(%ebx),%eax
80103a19:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
80103a20:	8b 43 18             	mov    0x18(%ebx),%eax
80103a23:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103a2a:	8d 43 6c             	lea    0x6c(%ebx),%eax
80103a2d:	6a 10                	push   $0x10
80103a2f:	68 85 75 10 80       	push   $0x80107585
80103a34:	50                   	push   %eax
80103a35:	e8 86 0d 00 00       	call   801047c0 <safestrcpy>
  p->cwd = namei("/");
80103a3a:	c7 04 24 8e 75 10 80 	movl   $0x8010758e,(%esp)
80103a41:	e8 7a e5 ff ff       	call   80101fc0 <namei>
80103a46:	89 43 68             	mov    %eax,0x68(%ebx)
  acquire(&ptable.lock);
80103a49:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103a50:	e8 8b 0a 00 00       	call   801044e0 <acquire>
  p->state = RUNNABLE;
80103a55:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  release(&ptable.lock);
80103a5c:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103a63:	e8 38 0b 00 00       	call   801045a0 <release>
}
80103a68:	83 c4 10             	add    $0x10,%esp
80103a6b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103a6e:	c9                   	leave  
80103a6f:	c3                   	ret    
    panic("userinit: out of memory?");
80103a70:	83 ec 0c             	sub    $0xc,%esp
80103a73:	68 6c 75 10 80       	push   $0x8010756c
80103a78:	e8 13 c9 ff ff       	call   80100390 <panic>
80103a7d:	8d 76 00             	lea    0x0(%esi),%esi

80103a80 <growproc>:
{
80103a80:	55                   	push   %ebp
80103a81:	89 e5                	mov    %esp,%ebp
80103a83:	56                   	push   %esi
80103a84:	53                   	push   %ebx
80103a85:	8b 75 08             	mov    0x8(%ebp),%esi
  pushcli();
80103a88:	e8 63 09 00 00       	call   801043f0 <pushcli>
  c = mycpu();
80103a8d:	e8 2e fe ff ff       	call   801038c0 <mycpu>
  p = c->proc;
80103a92:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103a98:	e8 a3 09 00 00       	call   80104440 <popcli>
  sz = curproc->sz;
80103a9d:	8b 03                	mov    (%ebx),%eax
  if(n > 0){
80103a9f:	85 f6                	test   %esi,%esi
80103aa1:	7f 1d                	jg     80103ac0 <growproc+0x40>
  } else if(n < 0){
80103aa3:	75 3b                	jne    80103ae0 <growproc+0x60>
  switchuvm(curproc);
80103aa5:	83 ec 0c             	sub    $0xc,%esp
  curproc->sz = sz;
80103aa8:	89 03                	mov    %eax,(%ebx)
  switchuvm(curproc);
80103aaa:	53                   	push   %ebx
80103aab:	e8 90 2e 00 00       	call   80106940 <switchuvm>
  return 0;
80103ab0:	83 c4 10             	add    $0x10,%esp
80103ab3:	31 c0                	xor    %eax,%eax
}
80103ab5:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103ab8:	5b                   	pop    %ebx
80103ab9:	5e                   	pop    %esi
80103aba:	5d                   	pop    %ebp
80103abb:	c3                   	ret    
80103abc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103ac0:	83 ec 04             	sub    $0x4,%esp
80103ac3:	01 c6                	add    %eax,%esi
80103ac5:	56                   	push   %esi
80103ac6:	50                   	push   %eax
80103ac7:	ff 73 04             	pushl  0x4(%ebx)
80103aca:	e8 c1 30 00 00       	call   80106b90 <allocuvm>
80103acf:	83 c4 10             	add    $0x10,%esp
80103ad2:	85 c0                	test   %eax,%eax
80103ad4:	75 cf                	jne    80103aa5 <growproc+0x25>
      return -1;
80103ad6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103adb:	eb d8                	jmp    80103ab5 <growproc+0x35>
80103add:	8d 76 00             	lea    0x0(%esi),%esi
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103ae0:	83 ec 04             	sub    $0x4,%esp
80103ae3:	01 c6                	add    %eax,%esi
80103ae5:	56                   	push   %esi
80103ae6:	50                   	push   %eax
80103ae7:	ff 73 04             	pushl  0x4(%ebx)
80103aea:	e8 d1 31 00 00       	call   80106cc0 <deallocuvm>
80103aef:	83 c4 10             	add    $0x10,%esp
80103af2:	85 c0                	test   %eax,%eax
80103af4:	75 af                	jne    80103aa5 <growproc+0x25>
80103af6:	eb de                	jmp    80103ad6 <growproc+0x56>
80103af8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103aff:	90                   	nop

80103b00 <fork>:
{
80103b00:	55                   	push   %ebp
80103b01:	89 e5                	mov    %esp,%ebp
80103b03:	57                   	push   %edi
80103b04:	56                   	push   %esi
80103b05:	53                   	push   %ebx
80103b06:	83 ec 1c             	sub    $0x1c,%esp
  pushcli();
80103b09:	e8 e2 08 00 00       	call   801043f0 <pushcli>
  c = mycpu();
80103b0e:	e8 ad fd ff ff       	call   801038c0 <mycpu>
  p = c->proc;
80103b13:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103b19:	e8 22 09 00 00       	call   80104440 <popcli>
  if((np = allocproc()) == 0){
80103b1e:	e8 5d fc ff ff       	call   80103780 <allocproc>
80103b23:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103b26:	85 c0                	test   %eax,%eax
80103b28:	0f 84 b7 00 00 00    	je     80103be5 <fork+0xe5>
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
80103b2e:	83 ec 08             	sub    $0x8,%esp
80103b31:	ff 33                	pushl  (%ebx)
80103b33:	89 c7                	mov    %eax,%edi
80103b35:	ff 73 04             	pushl  0x4(%ebx)
80103b38:	e8 03 33 00 00       	call   80106e40 <copyuvm>
80103b3d:	83 c4 10             	add    $0x10,%esp
80103b40:	89 47 04             	mov    %eax,0x4(%edi)
80103b43:	85 c0                	test   %eax,%eax
80103b45:	0f 84 a1 00 00 00    	je     80103bec <fork+0xec>
  np->sz = curproc->sz;
80103b4b:	8b 03                	mov    (%ebx),%eax
80103b4d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80103b50:	89 01                	mov    %eax,(%ecx)
  *np->tf = *curproc->tf;
80103b52:	8b 79 18             	mov    0x18(%ecx),%edi
  np->parent = curproc;
80103b55:	89 c8                	mov    %ecx,%eax
80103b57:	89 59 14             	mov    %ebx,0x14(%ecx)
  *np->tf = *curproc->tf;
80103b5a:	b9 13 00 00 00       	mov    $0x13,%ecx
80103b5f:	8b 73 18             	mov    0x18(%ebx),%esi
80103b62:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  for(i = 0; i < NOFILE; i++)
80103b64:	31 f6                	xor    %esi,%esi
  np->tf->eax = 0;
80103b66:	8b 40 18             	mov    0x18(%eax),%eax
80103b69:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
    if(curproc->ofile[i])
80103b70:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
80103b74:	85 c0                	test   %eax,%eax
80103b76:	74 13                	je     80103b8b <fork+0x8b>
      np->ofile[i] = filedup(curproc->ofile[i]);
80103b78:	83 ec 0c             	sub    $0xc,%esp
80103b7b:	50                   	push   %eax
80103b7c:	e8 ef d2 ff ff       	call   80100e70 <filedup>
80103b81:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103b84:	83 c4 10             	add    $0x10,%esp
80103b87:	89 44 b2 28          	mov    %eax,0x28(%edx,%esi,4)
  for(i = 0; i < NOFILE; i++)
80103b8b:	83 c6 01             	add    $0x1,%esi
80103b8e:	83 fe 10             	cmp    $0x10,%esi
80103b91:	75 dd                	jne    80103b70 <fork+0x70>
  np->cwd = idup(curproc->cwd);
80103b93:	83 ec 0c             	sub    $0xc,%esp
80103b96:	ff 73 68             	pushl  0x68(%ebx)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103b99:	83 c3 6c             	add    $0x6c,%ebx
  np->cwd = idup(curproc->cwd);
80103b9c:	e8 4f db ff ff       	call   801016f0 <idup>
80103ba1:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103ba4:	83 c4 0c             	add    $0xc,%esp
  np->cwd = idup(curproc->cwd);
80103ba7:	89 47 68             	mov    %eax,0x68(%edi)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103baa:	8d 47 6c             	lea    0x6c(%edi),%eax
80103bad:	6a 10                	push   $0x10
80103baf:	53                   	push   %ebx
80103bb0:	50                   	push   %eax
80103bb1:	e8 0a 0c 00 00       	call   801047c0 <safestrcpy>
  pid = np->pid;
80103bb6:	8b 5f 10             	mov    0x10(%edi),%ebx
  acquire(&ptable.lock);
80103bb9:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103bc0:	e8 1b 09 00 00       	call   801044e0 <acquire>
  np->state = RUNNABLE;
80103bc5:	c7 47 0c 03 00 00 00 	movl   $0x3,0xc(%edi)
  release(&ptable.lock);
80103bcc:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103bd3:	e8 c8 09 00 00       	call   801045a0 <release>
  return pid;
80103bd8:	83 c4 10             	add    $0x10,%esp
}
80103bdb:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103bde:	89 d8                	mov    %ebx,%eax
80103be0:	5b                   	pop    %ebx
80103be1:	5e                   	pop    %esi
80103be2:	5f                   	pop    %edi
80103be3:	5d                   	pop    %ebp
80103be4:	c3                   	ret    
    return -1;
80103be5:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80103bea:	eb ef                	jmp    80103bdb <fork+0xdb>
    kfree(np->kstack);
80103bec:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80103bef:	83 ec 0c             	sub    $0xc,%esp
80103bf2:	ff 73 08             	pushl  0x8(%ebx)
80103bf5:	e8 f6 e7 ff ff       	call   801023f0 <kfree>
    np->kstack = 0;
80103bfa:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
    return -1;
80103c01:	83 c4 10             	add    $0x10,%esp
    np->state = UNUSED;
80103c04:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return -1;
80103c0b:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80103c10:	eb c9                	jmp    80103bdb <fork+0xdb>
80103c12:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103c19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103c20 <scheduler>:
{
80103c20:	55                   	push   %ebp
80103c21:	89 e5                	mov    %esp,%ebp
80103c23:	57                   	push   %edi
80103c24:	56                   	push   %esi
80103c25:	53                   	push   %ebx
80103c26:	83 ec 0c             	sub    $0xc,%esp
  struct cpu *c = mycpu();
80103c29:	e8 92 fc ff ff       	call   801038c0 <mycpu>
  c->proc = 0;
80103c2e:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80103c35:	00 00 00 
  struct cpu *c = mycpu();
80103c38:	89 c6                	mov    %eax,%esi
  c->proc = 0;
80103c3a:	8d 78 04             	lea    0x4(%eax),%edi
80103c3d:	8d 76 00             	lea    0x0(%esi),%esi
  asm volatile("sti");
80103c40:	fb                   	sti    
    acquire(&ptable.lock);
80103c41:	83 ec 0c             	sub    $0xc,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103c44:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
    acquire(&ptable.lock);
80103c49:	68 20 2d 11 80       	push   $0x80112d20
80103c4e:	e8 8d 08 00 00       	call   801044e0 <acquire>
80103c53:	83 c4 10             	add    $0x10,%esp
80103c56:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103c5d:	8d 76 00             	lea    0x0(%esi),%esi
      if(p->state != RUNNABLE)
80103c60:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
80103c64:	75 33                	jne    80103c99 <scheduler+0x79>
      switchuvm(p);
80103c66:	83 ec 0c             	sub    $0xc,%esp
      c->proc = p;
80103c69:	89 9e ac 00 00 00    	mov    %ebx,0xac(%esi)
      switchuvm(p);
80103c6f:	53                   	push   %ebx
80103c70:	e8 cb 2c 00 00       	call   80106940 <switchuvm>
      swtch(&(c->scheduler), p->context);
80103c75:	58                   	pop    %eax
80103c76:	5a                   	pop    %edx
80103c77:	ff 73 1c             	pushl  0x1c(%ebx)
80103c7a:	57                   	push   %edi
      p->state = RUNNING;
80103c7b:	c7 43 0c 04 00 00 00 	movl   $0x4,0xc(%ebx)
      swtch(&(c->scheduler), p->context);
80103c82:	e8 94 0b 00 00       	call   8010481b <swtch>
      switchkvm();
80103c87:	e8 a4 2c 00 00       	call   80106930 <switchkvm>
      c->proc = 0;
80103c8c:	83 c4 10             	add    $0x10,%esp
80103c8f:	c7 86 ac 00 00 00 00 	movl   $0x0,0xac(%esi)
80103c96:	00 00 00 
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103c99:	83 c3 7c             	add    $0x7c,%ebx
80103c9c:	81 fb 54 4c 11 80    	cmp    $0x80114c54,%ebx
80103ca2:	75 bc                	jne    80103c60 <scheduler+0x40>
    release(&ptable.lock);
80103ca4:	83 ec 0c             	sub    $0xc,%esp
80103ca7:	68 20 2d 11 80       	push   $0x80112d20
80103cac:	e8 ef 08 00 00       	call   801045a0 <release>
    sti();
80103cb1:	83 c4 10             	add    $0x10,%esp
80103cb4:	eb 8a                	jmp    80103c40 <scheduler+0x20>
80103cb6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103cbd:	8d 76 00             	lea    0x0(%esi),%esi

80103cc0 <sched>:
{
80103cc0:	55                   	push   %ebp
80103cc1:	89 e5                	mov    %esp,%ebp
80103cc3:	56                   	push   %esi
80103cc4:	53                   	push   %ebx
  pushcli();
80103cc5:	e8 26 07 00 00       	call   801043f0 <pushcli>
  c = mycpu();
80103cca:	e8 f1 fb ff ff       	call   801038c0 <mycpu>
  p = c->proc;
80103ccf:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103cd5:	e8 66 07 00 00       	call   80104440 <popcli>
  if(!holding(&ptable.lock))
80103cda:	83 ec 0c             	sub    $0xc,%esp
80103cdd:	68 20 2d 11 80       	push   $0x80112d20
80103ce2:	e8 b9 07 00 00       	call   801044a0 <holding>
80103ce7:	83 c4 10             	add    $0x10,%esp
80103cea:	85 c0                	test   %eax,%eax
80103cec:	74 4f                	je     80103d3d <sched+0x7d>
  if(mycpu()->ncli != 1)
80103cee:	e8 cd fb ff ff       	call   801038c0 <mycpu>
80103cf3:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
80103cfa:	75 68                	jne    80103d64 <sched+0xa4>
  if(p->state == RUNNING)
80103cfc:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
80103d00:	74 55                	je     80103d57 <sched+0x97>
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103d02:	9c                   	pushf  
80103d03:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103d04:	f6 c4 02             	test   $0x2,%ah
80103d07:	75 41                	jne    80103d4a <sched+0x8a>
  intena = mycpu()->intena;
80103d09:	e8 b2 fb ff ff       	call   801038c0 <mycpu>
  swtch(&p->context, mycpu()->scheduler);
80103d0e:	83 c3 1c             	add    $0x1c,%ebx
  intena = mycpu()->intena;
80103d11:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
80103d17:	e8 a4 fb ff ff       	call   801038c0 <mycpu>
80103d1c:	83 ec 08             	sub    $0x8,%esp
80103d1f:	ff 70 04             	pushl  0x4(%eax)
80103d22:	53                   	push   %ebx
80103d23:	e8 f3 0a 00 00       	call   8010481b <swtch>
  mycpu()->intena = intena;
80103d28:	e8 93 fb ff ff       	call   801038c0 <mycpu>
}
80103d2d:	83 c4 10             	add    $0x10,%esp
  mycpu()->intena = intena;
80103d30:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
80103d36:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103d39:	5b                   	pop    %ebx
80103d3a:	5e                   	pop    %esi
80103d3b:	5d                   	pop    %ebp
80103d3c:	c3                   	ret    
    panic("sched ptable.lock");
80103d3d:	83 ec 0c             	sub    $0xc,%esp
80103d40:	68 90 75 10 80       	push   $0x80107590
80103d45:	e8 46 c6 ff ff       	call   80100390 <panic>
    panic("sched interruptible");
80103d4a:	83 ec 0c             	sub    $0xc,%esp
80103d4d:	68 bc 75 10 80       	push   $0x801075bc
80103d52:	e8 39 c6 ff ff       	call   80100390 <panic>
    panic("sched running");
80103d57:	83 ec 0c             	sub    $0xc,%esp
80103d5a:	68 ae 75 10 80       	push   $0x801075ae
80103d5f:	e8 2c c6 ff ff       	call   80100390 <panic>
    panic("sched locks");
80103d64:	83 ec 0c             	sub    $0xc,%esp
80103d67:	68 a2 75 10 80       	push   $0x801075a2
80103d6c:	e8 1f c6 ff ff       	call   80100390 <panic>
80103d71:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103d78:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103d7f:	90                   	nop

80103d80 <exit>:
{
80103d80:	55                   	push   %ebp
80103d81:	89 e5                	mov    %esp,%ebp
80103d83:	57                   	push   %edi
80103d84:	56                   	push   %esi
80103d85:	53                   	push   %ebx
80103d86:	83 ec 0c             	sub    $0xc,%esp
  pushcli();
80103d89:	e8 62 06 00 00       	call   801043f0 <pushcli>
  c = mycpu();
80103d8e:	e8 2d fb ff ff       	call   801038c0 <mycpu>
  p = c->proc;
80103d93:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80103d99:	e8 a2 06 00 00       	call   80104440 <popcli>
  if(curproc == initproc)
80103d9e:	8d 5e 28             	lea    0x28(%esi),%ebx
80103da1:	8d 7e 68             	lea    0x68(%esi),%edi
80103da4:	39 35 b8 a5 10 80    	cmp    %esi,0x8010a5b8
80103daa:	0f 84 e7 00 00 00    	je     80103e97 <exit+0x117>
    if(curproc->ofile[fd]){
80103db0:	8b 03                	mov    (%ebx),%eax
80103db2:	85 c0                	test   %eax,%eax
80103db4:	74 12                	je     80103dc8 <exit+0x48>
      fileclose(curproc->ofile[fd]);
80103db6:	83 ec 0c             	sub    $0xc,%esp
80103db9:	50                   	push   %eax
80103dba:	e8 01 d1 ff ff       	call   80100ec0 <fileclose>
      curproc->ofile[fd] = 0;
80103dbf:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
80103dc5:	83 c4 10             	add    $0x10,%esp
  for(fd = 0; fd < NOFILE; fd++){
80103dc8:	83 c3 04             	add    $0x4,%ebx
80103dcb:	39 df                	cmp    %ebx,%edi
80103dcd:	75 e1                	jne    80103db0 <exit+0x30>
  begin_op();
80103dcf:	e8 4c ef ff ff       	call   80102d20 <begin_op>
  iput(curproc->cwd);
80103dd4:	83 ec 0c             	sub    $0xc,%esp
80103dd7:	ff 76 68             	pushl  0x68(%esi)
80103dda:	e8 71 da ff ff       	call   80101850 <iput>
  end_op();
80103ddf:	e8 ac ef ff ff       	call   80102d90 <end_op>
  curproc->cwd = 0;
80103de4:	c7 46 68 00 00 00 00 	movl   $0x0,0x68(%esi)
  acquire(&ptable.lock);
80103deb:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103df2:	e8 e9 06 00 00       	call   801044e0 <acquire>
  wakeup1(curproc->parent);
80103df7:	8b 56 14             	mov    0x14(%esi),%edx
80103dfa:	83 c4 10             	add    $0x10,%esp
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103dfd:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
80103e02:	eb 0e                	jmp    80103e12 <exit+0x92>
80103e04:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103e08:	83 c0 7c             	add    $0x7c,%eax
80103e0b:	3d 54 4c 11 80       	cmp    $0x80114c54,%eax
80103e10:	74 1c                	je     80103e2e <exit+0xae>
    if(p->state == SLEEPING && p->chan == chan)
80103e12:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80103e16:	75 f0                	jne    80103e08 <exit+0x88>
80103e18:	3b 50 20             	cmp    0x20(%eax),%edx
80103e1b:	75 eb                	jne    80103e08 <exit+0x88>
      p->state = RUNNABLE;
80103e1d:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103e24:	83 c0 7c             	add    $0x7c,%eax
80103e27:	3d 54 4c 11 80       	cmp    $0x80114c54,%eax
80103e2c:	75 e4                	jne    80103e12 <exit+0x92>
      p->parent = initproc;
80103e2e:	8b 0d b8 a5 10 80    	mov    0x8010a5b8,%ecx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103e34:	ba 54 2d 11 80       	mov    $0x80112d54,%edx
80103e39:	eb 10                	jmp    80103e4b <exit+0xcb>
80103e3b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103e3f:	90                   	nop
80103e40:	83 c2 7c             	add    $0x7c,%edx
80103e43:	81 fa 54 4c 11 80    	cmp    $0x80114c54,%edx
80103e49:	74 33                	je     80103e7e <exit+0xfe>
    if(p->parent == curproc){
80103e4b:	39 72 14             	cmp    %esi,0x14(%edx)
80103e4e:	75 f0                	jne    80103e40 <exit+0xc0>
      if(p->state == ZOMBIE)
80103e50:	83 7a 0c 05          	cmpl   $0x5,0xc(%edx)
      p->parent = initproc;
80103e54:	89 4a 14             	mov    %ecx,0x14(%edx)
      if(p->state == ZOMBIE)
80103e57:	75 e7                	jne    80103e40 <exit+0xc0>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103e59:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
80103e5e:	eb 0a                	jmp    80103e6a <exit+0xea>
80103e60:	83 c0 7c             	add    $0x7c,%eax
80103e63:	3d 54 4c 11 80       	cmp    $0x80114c54,%eax
80103e68:	74 d6                	je     80103e40 <exit+0xc0>
    if(p->state == SLEEPING && p->chan == chan)
80103e6a:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80103e6e:	75 f0                	jne    80103e60 <exit+0xe0>
80103e70:	3b 48 20             	cmp    0x20(%eax),%ecx
80103e73:	75 eb                	jne    80103e60 <exit+0xe0>
      p->state = RUNNABLE;
80103e75:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
80103e7c:	eb e2                	jmp    80103e60 <exit+0xe0>
  curproc->state = ZOMBIE;
80103e7e:	c7 46 0c 05 00 00 00 	movl   $0x5,0xc(%esi)
  sched();
80103e85:	e8 36 fe ff ff       	call   80103cc0 <sched>
  panic("zombie exit");
80103e8a:	83 ec 0c             	sub    $0xc,%esp
80103e8d:	68 dd 75 10 80       	push   $0x801075dd
80103e92:	e8 f9 c4 ff ff       	call   80100390 <panic>
    panic("init exiting");
80103e97:	83 ec 0c             	sub    $0xc,%esp
80103e9a:	68 d0 75 10 80       	push   $0x801075d0
80103e9f:	e8 ec c4 ff ff       	call   80100390 <panic>
80103ea4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103eab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103eaf:	90                   	nop

80103eb0 <yield>:
{
80103eb0:	55                   	push   %ebp
80103eb1:	89 e5                	mov    %esp,%ebp
80103eb3:	53                   	push   %ebx
80103eb4:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
80103eb7:	68 20 2d 11 80       	push   $0x80112d20
80103ebc:	e8 1f 06 00 00       	call   801044e0 <acquire>
  pushcli();
80103ec1:	e8 2a 05 00 00       	call   801043f0 <pushcli>
  c = mycpu();
80103ec6:	e8 f5 f9 ff ff       	call   801038c0 <mycpu>
  p = c->proc;
80103ecb:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103ed1:	e8 6a 05 00 00       	call   80104440 <popcli>
  myproc()->state = RUNNABLE;
80103ed6:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  sched();
80103edd:	e8 de fd ff ff       	call   80103cc0 <sched>
  release(&ptable.lock);
80103ee2:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103ee9:	e8 b2 06 00 00       	call   801045a0 <release>
}
80103eee:	83 c4 10             	add    $0x10,%esp
80103ef1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103ef4:	c9                   	leave  
80103ef5:	c3                   	ret    
80103ef6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103efd:	8d 76 00             	lea    0x0(%esi),%esi

80103f00 <sleep>:
{
80103f00:	55                   	push   %ebp
80103f01:	89 e5                	mov    %esp,%ebp
80103f03:	57                   	push   %edi
80103f04:	56                   	push   %esi
80103f05:	53                   	push   %ebx
80103f06:	83 ec 0c             	sub    $0xc,%esp
80103f09:	8b 7d 08             	mov    0x8(%ebp),%edi
80103f0c:	8b 75 0c             	mov    0xc(%ebp),%esi
  pushcli();
80103f0f:	e8 dc 04 00 00       	call   801043f0 <pushcli>
  c = mycpu();
80103f14:	e8 a7 f9 ff ff       	call   801038c0 <mycpu>
  p = c->proc;
80103f19:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103f1f:	e8 1c 05 00 00       	call   80104440 <popcli>
  if(p == 0)
80103f24:	85 db                	test   %ebx,%ebx
80103f26:	0f 84 87 00 00 00    	je     80103fb3 <sleep+0xb3>
  if(lk == 0)
80103f2c:	85 f6                	test   %esi,%esi
80103f2e:	74 76                	je     80103fa6 <sleep+0xa6>
  if(lk != &ptable.lock){  //DOC: sleeplock0
80103f30:	81 fe 20 2d 11 80    	cmp    $0x80112d20,%esi
80103f36:	74 50                	je     80103f88 <sleep+0x88>
    acquire(&ptable.lock);  //DOC: sleeplock1
80103f38:	83 ec 0c             	sub    $0xc,%esp
80103f3b:	68 20 2d 11 80       	push   $0x80112d20
80103f40:	e8 9b 05 00 00       	call   801044e0 <acquire>
    release(lk);
80103f45:	89 34 24             	mov    %esi,(%esp)
80103f48:	e8 53 06 00 00       	call   801045a0 <release>
  p->chan = chan;
80103f4d:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
80103f50:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80103f57:	e8 64 fd ff ff       	call   80103cc0 <sched>
  p->chan = 0;
80103f5c:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
    release(&ptable.lock);
80103f63:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103f6a:	e8 31 06 00 00       	call   801045a0 <release>
    acquire(lk);
80103f6f:	89 75 08             	mov    %esi,0x8(%ebp)
80103f72:	83 c4 10             	add    $0x10,%esp
}
80103f75:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103f78:	5b                   	pop    %ebx
80103f79:	5e                   	pop    %esi
80103f7a:	5f                   	pop    %edi
80103f7b:	5d                   	pop    %ebp
    acquire(lk);
80103f7c:	e9 5f 05 00 00       	jmp    801044e0 <acquire>
80103f81:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  p->chan = chan;
80103f88:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
80103f8b:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80103f92:	e8 29 fd ff ff       	call   80103cc0 <sched>
  p->chan = 0;
80103f97:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
80103f9e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103fa1:	5b                   	pop    %ebx
80103fa2:	5e                   	pop    %esi
80103fa3:	5f                   	pop    %edi
80103fa4:	5d                   	pop    %ebp
80103fa5:	c3                   	ret    
    panic("sleep without lk");
80103fa6:	83 ec 0c             	sub    $0xc,%esp
80103fa9:	68 ef 75 10 80       	push   $0x801075ef
80103fae:	e8 dd c3 ff ff       	call   80100390 <panic>
    panic("sleep");
80103fb3:	83 ec 0c             	sub    $0xc,%esp
80103fb6:	68 e9 75 10 80       	push   $0x801075e9
80103fbb:	e8 d0 c3 ff ff       	call   80100390 <panic>

80103fc0 <wait>:
{
80103fc0:	55                   	push   %ebp
80103fc1:	89 e5                	mov    %esp,%ebp
80103fc3:	56                   	push   %esi
80103fc4:	53                   	push   %ebx
  pushcli();
80103fc5:	e8 26 04 00 00       	call   801043f0 <pushcli>
  c = mycpu();
80103fca:	e8 f1 f8 ff ff       	call   801038c0 <mycpu>
  p = c->proc;
80103fcf:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80103fd5:	e8 66 04 00 00       	call   80104440 <popcli>
  acquire(&ptable.lock);
80103fda:	83 ec 0c             	sub    $0xc,%esp
80103fdd:	68 20 2d 11 80       	push   $0x80112d20
80103fe2:	e8 f9 04 00 00       	call   801044e0 <acquire>
80103fe7:	83 c4 10             	add    $0x10,%esp
    havekids = 0;
80103fea:	31 c0                	xor    %eax,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103fec:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
80103ff1:	eb 10                	jmp    80104003 <wait+0x43>
80103ff3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103ff7:	90                   	nop
80103ff8:	83 c3 7c             	add    $0x7c,%ebx
80103ffb:	81 fb 54 4c 11 80    	cmp    $0x80114c54,%ebx
80104001:	74 1b                	je     8010401e <wait+0x5e>
      if(p->parent != curproc)
80104003:	39 73 14             	cmp    %esi,0x14(%ebx)
80104006:	75 f0                	jne    80103ff8 <wait+0x38>
      if(p->state == ZOMBIE){
80104008:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
8010400c:	74 32                	je     80104040 <wait+0x80>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010400e:	83 c3 7c             	add    $0x7c,%ebx
      havekids = 1;
80104011:	b8 01 00 00 00       	mov    $0x1,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104016:	81 fb 54 4c 11 80    	cmp    $0x80114c54,%ebx
8010401c:	75 e5                	jne    80104003 <wait+0x43>
    if(!havekids || curproc->killed){
8010401e:	85 c0                	test   %eax,%eax
80104020:	74 74                	je     80104096 <wait+0xd6>
80104022:	8b 46 24             	mov    0x24(%esi),%eax
80104025:	85 c0                	test   %eax,%eax
80104027:	75 6d                	jne    80104096 <wait+0xd6>
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
80104029:	83 ec 08             	sub    $0x8,%esp
8010402c:	68 20 2d 11 80       	push   $0x80112d20
80104031:	56                   	push   %esi
80104032:	e8 c9 fe ff ff       	call   80103f00 <sleep>
    havekids = 0;
80104037:	83 c4 10             	add    $0x10,%esp
8010403a:	eb ae                	jmp    80103fea <wait+0x2a>
8010403c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        kfree(p->kstack);
80104040:	83 ec 0c             	sub    $0xc,%esp
80104043:	ff 73 08             	pushl  0x8(%ebx)
        pid = p->pid;
80104046:	8b 73 10             	mov    0x10(%ebx),%esi
        kfree(p->kstack);
80104049:	e8 a2 e3 ff ff       	call   801023f0 <kfree>
        freevm(p->pgdir);
8010404e:	5a                   	pop    %edx
8010404f:	ff 73 04             	pushl  0x4(%ebx)
        p->kstack = 0;
80104052:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir);
80104059:	e8 92 2c 00 00       	call   80106cf0 <freevm>
        release(&ptable.lock);
8010405e:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
        p->pid = 0;
80104065:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->parent = 0;
8010406c:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
80104073:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->killed = 0;
80104077:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        p->state = UNUSED;
8010407e:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        release(&ptable.lock);
80104085:	e8 16 05 00 00       	call   801045a0 <release>
        return pid;
8010408a:	83 c4 10             	add    $0x10,%esp
}
8010408d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104090:	89 f0                	mov    %esi,%eax
80104092:	5b                   	pop    %ebx
80104093:	5e                   	pop    %esi
80104094:	5d                   	pop    %ebp
80104095:	c3                   	ret    
      release(&ptable.lock);
80104096:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80104099:	be ff ff ff ff       	mov    $0xffffffff,%esi
      release(&ptable.lock);
8010409e:	68 20 2d 11 80       	push   $0x80112d20
801040a3:	e8 f8 04 00 00       	call   801045a0 <release>
      return -1;
801040a8:	83 c4 10             	add    $0x10,%esp
801040ab:	eb e0                	jmp    8010408d <wait+0xcd>
801040ad:	8d 76 00             	lea    0x0(%esi),%esi

801040b0 <wakeup>:
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
801040b0:	55                   	push   %ebp
801040b1:	89 e5                	mov    %esp,%ebp
801040b3:	53                   	push   %ebx
801040b4:	83 ec 10             	sub    $0x10,%esp
801040b7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
801040ba:	68 20 2d 11 80       	push   $0x80112d20
801040bf:	e8 1c 04 00 00       	call   801044e0 <acquire>
801040c4:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801040c7:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
801040cc:	eb 0c                	jmp    801040da <wakeup+0x2a>
801040ce:	66 90                	xchg   %ax,%ax
801040d0:	83 c0 7c             	add    $0x7c,%eax
801040d3:	3d 54 4c 11 80       	cmp    $0x80114c54,%eax
801040d8:	74 1c                	je     801040f6 <wakeup+0x46>
    if(p->state == SLEEPING && p->chan == chan)
801040da:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
801040de:	75 f0                	jne    801040d0 <wakeup+0x20>
801040e0:	3b 58 20             	cmp    0x20(%eax),%ebx
801040e3:	75 eb                	jne    801040d0 <wakeup+0x20>
      p->state = RUNNABLE;
801040e5:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801040ec:	83 c0 7c             	add    $0x7c,%eax
801040ef:	3d 54 4c 11 80       	cmp    $0x80114c54,%eax
801040f4:	75 e4                	jne    801040da <wakeup+0x2a>
  wakeup1(chan);
  release(&ptable.lock);
801040f6:	c7 45 08 20 2d 11 80 	movl   $0x80112d20,0x8(%ebp)
}
801040fd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104100:	c9                   	leave  
  release(&ptable.lock);
80104101:	e9 9a 04 00 00       	jmp    801045a0 <release>
80104106:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010410d:	8d 76 00             	lea    0x0(%esi),%esi

80104110 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
80104110:	55                   	push   %ebp
80104111:	89 e5                	mov    %esp,%ebp
80104113:	53                   	push   %ebx
80104114:	83 ec 10             	sub    $0x10,%esp
80104117:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
8010411a:	68 20 2d 11 80       	push   $0x80112d20
8010411f:	e8 bc 03 00 00       	call   801044e0 <acquire>
80104124:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104127:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
8010412c:	eb 0c                	jmp    8010413a <kill+0x2a>
8010412e:	66 90                	xchg   %ax,%ax
80104130:	83 c0 7c             	add    $0x7c,%eax
80104133:	3d 54 4c 11 80       	cmp    $0x80114c54,%eax
80104138:	74 36                	je     80104170 <kill+0x60>
    if(p->pid == pid){
8010413a:	39 58 10             	cmp    %ebx,0x10(%eax)
8010413d:	75 f1                	jne    80104130 <kill+0x20>
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
8010413f:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
      p->killed = 1;
80104143:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      if(p->state == SLEEPING)
8010414a:	75 07                	jne    80104153 <kill+0x43>
        p->state = RUNNABLE;
8010414c:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
      release(&ptable.lock);
80104153:	83 ec 0c             	sub    $0xc,%esp
80104156:	68 20 2d 11 80       	push   $0x80112d20
8010415b:	e8 40 04 00 00       	call   801045a0 <release>
      return 0;
80104160:	83 c4 10             	add    $0x10,%esp
80104163:	31 c0                	xor    %eax,%eax
    }
  }
  release(&ptable.lock);
  return -1;
}
80104165:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104168:	c9                   	leave  
80104169:	c3                   	ret    
8010416a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  release(&ptable.lock);
80104170:	83 ec 0c             	sub    $0xc,%esp
80104173:	68 20 2d 11 80       	push   $0x80112d20
80104178:	e8 23 04 00 00       	call   801045a0 <release>
  return -1;
8010417d:	83 c4 10             	add    $0x10,%esp
80104180:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104185:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104188:	c9                   	leave  
80104189:	c3                   	ret    
8010418a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104190 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
80104190:	55                   	push   %ebp
80104191:	89 e5                	mov    %esp,%ebp
80104193:	57                   	push   %edi
80104194:	56                   	push   %esi
80104195:	8d 75 e8             	lea    -0x18(%ebp),%esi
80104198:	53                   	push   %ebx
80104199:	bb c0 2d 11 80       	mov    $0x80112dc0,%ebx
8010419e:	83 ec 3c             	sub    $0x3c,%esp
801041a1:	eb 24                	jmp    801041c7 <procdump+0x37>
801041a3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801041a7:	90                   	nop
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
801041a8:	83 ec 0c             	sub    $0xc,%esp
801041ab:	68 7b 79 10 80       	push   $0x8010797b
801041b0:	e8 fb c4 ff ff       	call   801006b0 <cprintf>
801041b5:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801041b8:	83 c3 7c             	add    $0x7c,%ebx
801041bb:	81 fb c0 4c 11 80    	cmp    $0x80114cc0,%ebx
801041c1:	0f 84 81 00 00 00    	je     80104248 <procdump+0xb8>
    if(p->state == UNUSED)
801041c7:	8b 43 a0             	mov    -0x60(%ebx),%eax
801041ca:	85 c0                	test   %eax,%eax
801041cc:	74 ea                	je     801041b8 <procdump+0x28>
      state = "???";
801041ce:	ba 00 76 10 80       	mov    $0x80107600,%edx
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
801041d3:	83 f8 05             	cmp    $0x5,%eax
801041d6:	77 11                	ja     801041e9 <procdump+0x59>
801041d8:	8b 14 85 60 76 10 80 	mov    -0x7fef89a0(,%eax,4),%edx
      state = "???";
801041df:	b8 00 76 10 80       	mov    $0x80107600,%eax
801041e4:	85 d2                	test   %edx,%edx
801041e6:	0f 44 d0             	cmove  %eax,%edx
    cprintf("%d %s %s", p->pid, state, p->name);
801041e9:	53                   	push   %ebx
801041ea:	52                   	push   %edx
801041eb:	ff 73 a4             	pushl  -0x5c(%ebx)
801041ee:	68 04 76 10 80       	push   $0x80107604
801041f3:	e8 b8 c4 ff ff       	call   801006b0 <cprintf>
    if(p->state == SLEEPING){
801041f8:	83 c4 10             	add    $0x10,%esp
801041fb:	83 7b a0 02          	cmpl   $0x2,-0x60(%ebx)
801041ff:	75 a7                	jne    801041a8 <procdump+0x18>
      getcallerpcs((uint*)p->context->ebp+2, pc);
80104201:	83 ec 08             	sub    $0x8,%esp
80104204:	8d 45 c0             	lea    -0x40(%ebp),%eax
80104207:	8d 7d c0             	lea    -0x40(%ebp),%edi
8010420a:	50                   	push   %eax
8010420b:	8b 43 b0             	mov    -0x50(%ebx),%eax
8010420e:	8b 40 0c             	mov    0xc(%eax),%eax
80104211:	83 c0 08             	add    $0x8,%eax
80104214:	50                   	push   %eax
80104215:	e8 86 01 00 00       	call   801043a0 <getcallerpcs>
      for(i=0; i<10 && pc[i] != 0; i++)
8010421a:	83 c4 10             	add    $0x10,%esp
8010421d:	8d 76 00             	lea    0x0(%esi),%esi
80104220:	8b 17                	mov    (%edi),%edx
80104222:	85 d2                	test   %edx,%edx
80104224:	74 82                	je     801041a8 <procdump+0x18>
        cprintf(" %p", pc[i]);
80104226:	83 ec 08             	sub    $0x8,%esp
80104229:	83 c7 04             	add    $0x4,%edi
8010422c:	52                   	push   %edx
8010422d:	68 41 70 10 80       	push   $0x80107041
80104232:	e8 79 c4 ff ff       	call   801006b0 <cprintf>
      for(i=0; i<10 && pc[i] != 0; i++)
80104237:	83 c4 10             	add    $0x10,%esp
8010423a:	39 fe                	cmp    %edi,%esi
8010423c:	75 e2                	jne    80104220 <procdump+0x90>
8010423e:	e9 65 ff ff ff       	jmp    801041a8 <procdump+0x18>
80104243:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104247:	90                   	nop
  }
}
80104248:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010424b:	5b                   	pop    %ebx
8010424c:	5e                   	pop    %esi
8010424d:	5f                   	pop    %edi
8010424e:	5d                   	pop    %ebp
8010424f:	c3                   	ret    

80104250 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
80104250:	55                   	push   %ebp
80104251:	89 e5                	mov    %esp,%ebp
80104253:	53                   	push   %ebx
80104254:	83 ec 0c             	sub    $0xc,%esp
80104257:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
8010425a:	68 78 76 10 80       	push   $0x80107678
8010425f:	8d 43 04             	lea    0x4(%ebx),%eax
80104262:	50                   	push   %eax
80104263:	e8 18 01 00 00       	call   80104380 <initlock>
  lk->name = name;
80104268:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
8010426b:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
}
80104271:	83 c4 10             	add    $0x10,%esp
  lk->pid = 0;
80104274:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  lk->name = name;
8010427b:	89 43 38             	mov    %eax,0x38(%ebx)
}
8010427e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104281:	c9                   	leave  
80104282:	c3                   	ret    
80104283:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010428a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104290 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
80104290:	55                   	push   %ebp
80104291:	89 e5                	mov    %esp,%ebp
80104293:	56                   	push   %esi
80104294:	53                   	push   %ebx
80104295:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104298:	8d 73 04             	lea    0x4(%ebx),%esi
8010429b:	83 ec 0c             	sub    $0xc,%esp
8010429e:	56                   	push   %esi
8010429f:	e8 3c 02 00 00       	call   801044e0 <acquire>
  while (lk->locked) {
801042a4:	8b 13                	mov    (%ebx),%edx
801042a6:	83 c4 10             	add    $0x10,%esp
801042a9:	85 d2                	test   %edx,%edx
801042ab:	74 16                	je     801042c3 <acquiresleep+0x33>
801042ad:	8d 76 00             	lea    0x0(%esi),%esi
    sleep(lk, &lk->lk);
801042b0:	83 ec 08             	sub    $0x8,%esp
801042b3:	56                   	push   %esi
801042b4:	53                   	push   %ebx
801042b5:	e8 46 fc ff ff       	call   80103f00 <sleep>
  while (lk->locked) {
801042ba:	8b 03                	mov    (%ebx),%eax
801042bc:	83 c4 10             	add    $0x10,%esp
801042bf:	85 c0                	test   %eax,%eax
801042c1:	75 ed                	jne    801042b0 <acquiresleep+0x20>
  }
  lk->locked = 1;
801042c3:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
801042c9:	e8 92 f6 ff ff       	call   80103960 <myproc>
801042ce:	8b 40 10             	mov    0x10(%eax),%eax
801042d1:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
801042d4:	89 75 08             	mov    %esi,0x8(%ebp)
}
801042d7:	8d 65 f8             	lea    -0x8(%ebp),%esp
801042da:	5b                   	pop    %ebx
801042db:	5e                   	pop    %esi
801042dc:	5d                   	pop    %ebp
  release(&lk->lk);
801042dd:	e9 be 02 00 00       	jmp    801045a0 <release>
801042e2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801042e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801042f0 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
801042f0:	55                   	push   %ebp
801042f1:	89 e5                	mov    %esp,%ebp
801042f3:	56                   	push   %esi
801042f4:	53                   	push   %ebx
801042f5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
801042f8:	8d 73 04             	lea    0x4(%ebx),%esi
801042fb:	83 ec 0c             	sub    $0xc,%esp
801042fe:	56                   	push   %esi
801042ff:	e8 dc 01 00 00       	call   801044e0 <acquire>
  lk->locked = 0;
80104304:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
8010430a:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
80104311:	89 1c 24             	mov    %ebx,(%esp)
80104314:	e8 97 fd ff ff       	call   801040b0 <wakeup>
  release(&lk->lk);
80104319:	89 75 08             	mov    %esi,0x8(%ebp)
8010431c:	83 c4 10             	add    $0x10,%esp
}
8010431f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104322:	5b                   	pop    %ebx
80104323:	5e                   	pop    %esi
80104324:	5d                   	pop    %ebp
  release(&lk->lk);
80104325:	e9 76 02 00 00       	jmp    801045a0 <release>
8010432a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104330 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
80104330:	55                   	push   %ebp
80104331:	89 e5                	mov    %esp,%ebp
80104333:	57                   	push   %edi
80104334:	31 ff                	xor    %edi,%edi
80104336:	56                   	push   %esi
80104337:	53                   	push   %ebx
80104338:	83 ec 18             	sub    $0x18,%esp
8010433b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;
  
  acquire(&lk->lk);
8010433e:	8d 73 04             	lea    0x4(%ebx),%esi
80104341:	56                   	push   %esi
80104342:	e8 99 01 00 00       	call   801044e0 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
80104347:	8b 03                	mov    (%ebx),%eax
80104349:	83 c4 10             	add    $0x10,%esp
8010434c:	85 c0                	test   %eax,%eax
8010434e:	75 18                	jne    80104368 <holdingsleep+0x38>
  release(&lk->lk);
80104350:	83 ec 0c             	sub    $0xc,%esp
80104353:	56                   	push   %esi
80104354:	e8 47 02 00 00       	call   801045a0 <release>
  return r;
}
80104359:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010435c:	89 f8                	mov    %edi,%eax
8010435e:	5b                   	pop    %ebx
8010435f:	5e                   	pop    %esi
80104360:	5f                   	pop    %edi
80104361:	5d                   	pop    %ebp
80104362:	c3                   	ret    
80104363:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104367:	90                   	nop
  r = lk->locked && (lk->pid == myproc()->pid);
80104368:	8b 5b 3c             	mov    0x3c(%ebx),%ebx
8010436b:	e8 f0 f5 ff ff       	call   80103960 <myproc>
80104370:	39 58 10             	cmp    %ebx,0x10(%eax)
80104373:	0f 94 c0             	sete   %al
80104376:	0f b6 c0             	movzbl %al,%eax
80104379:	89 c7                	mov    %eax,%edi
8010437b:	eb d3                	jmp    80104350 <holdingsleep+0x20>
8010437d:	66 90                	xchg   %ax,%ax
8010437f:	90                   	nop

80104380 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80104380:	55                   	push   %ebp
80104381:	89 e5                	mov    %esp,%ebp
80104383:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
80104386:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
80104389:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->name = name;
8010438f:	89 50 04             	mov    %edx,0x4(%eax)
  lk->cpu = 0;
80104392:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80104399:	5d                   	pop    %ebp
8010439a:	c3                   	ret    
8010439b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010439f:	90                   	nop

801043a0 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
801043a0:	55                   	push   %ebp
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
801043a1:	31 d2                	xor    %edx,%edx
{
801043a3:	89 e5                	mov    %esp,%ebp
801043a5:	53                   	push   %ebx
  ebp = (uint*)v - 2;
801043a6:	8b 45 08             	mov    0x8(%ebp),%eax
{
801043a9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  ebp = (uint*)v - 2;
801043ac:	83 e8 08             	sub    $0x8,%eax
  for(i = 0; i < 10; i++){
801043af:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
801043b0:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
801043b6:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
801043bc:	77 1a                	ja     801043d8 <getcallerpcs+0x38>
      break;
    pcs[i] = ebp[1];     // saved %eip
801043be:	8b 58 04             	mov    0x4(%eax),%ebx
801043c1:	89 1c 91             	mov    %ebx,(%ecx,%edx,4)
  for(i = 0; i < 10; i++){
801043c4:	83 c2 01             	add    $0x1,%edx
    ebp = (uint*)ebp[0]; // saved %ebp
801043c7:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
801043c9:	83 fa 0a             	cmp    $0xa,%edx
801043cc:	75 e2                	jne    801043b0 <getcallerpcs+0x10>
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
801043ce:	5b                   	pop    %ebx
801043cf:	5d                   	pop    %ebp
801043d0:	c3                   	ret    
801043d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(; i < 10; i++)
801043d8:	8d 04 91             	lea    (%ecx,%edx,4),%eax
801043db:	8d 51 28             	lea    0x28(%ecx),%edx
801043de:	66 90                	xchg   %ax,%ax
    pcs[i] = 0;
801043e0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
801043e6:	83 c0 04             	add    $0x4,%eax
801043e9:	39 d0                	cmp    %edx,%eax
801043eb:	75 f3                	jne    801043e0 <getcallerpcs+0x40>
}
801043ed:	5b                   	pop    %ebx
801043ee:	5d                   	pop    %ebp
801043ef:	c3                   	ret    

801043f0 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
801043f0:	55                   	push   %ebp
801043f1:	89 e5                	mov    %esp,%ebp
801043f3:	53                   	push   %ebx
801043f4:	83 ec 04             	sub    $0x4,%esp
801043f7:	9c                   	pushf  
801043f8:	5b                   	pop    %ebx
  asm volatile("cli");
801043f9:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
801043fa:	e8 c1 f4 ff ff       	call   801038c0 <mycpu>
801043ff:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80104405:	85 c0                	test   %eax,%eax
80104407:	74 17                	je     80104420 <pushcli+0x30>
    mycpu()->intena = eflags & FL_IF;
  mycpu()->ncli += 1;
80104409:	e8 b2 f4 ff ff       	call   801038c0 <mycpu>
8010440e:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
80104415:	83 c4 04             	add    $0x4,%esp
80104418:	5b                   	pop    %ebx
80104419:	5d                   	pop    %ebp
8010441a:	c3                   	ret    
8010441b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010441f:	90                   	nop
    mycpu()->intena = eflags & FL_IF;
80104420:	e8 9b f4 ff ff       	call   801038c0 <mycpu>
80104425:	81 e3 00 02 00 00    	and    $0x200,%ebx
8010442b:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
80104431:	eb d6                	jmp    80104409 <pushcli+0x19>
80104433:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010443a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104440 <popcli>:

void
popcli(void)
{
80104440:	55                   	push   %ebp
80104441:	89 e5                	mov    %esp,%ebp
80104443:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104446:	9c                   	pushf  
80104447:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80104448:	f6 c4 02             	test   $0x2,%ah
8010444b:	75 35                	jne    80104482 <popcli+0x42>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
8010444d:	e8 6e f4 ff ff       	call   801038c0 <mycpu>
80104452:	83 a8 a4 00 00 00 01 	subl   $0x1,0xa4(%eax)
80104459:	78 34                	js     8010448f <popcli+0x4f>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
8010445b:	e8 60 f4 ff ff       	call   801038c0 <mycpu>
80104460:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
80104466:	85 d2                	test   %edx,%edx
80104468:	74 06                	je     80104470 <popcli+0x30>
    sti();
}
8010446a:	c9                   	leave  
8010446b:	c3                   	ret    
8010446c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104470:	e8 4b f4 ff ff       	call   801038c0 <mycpu>
80104475:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
8010447b:	85 c0                	test   %eax,%eax
8010447d:	74 eb                	je     8010446a <popcli+0x2a>
  asm volatile("sti");
8010447f:	fb                   	sti    
}
80104480:	c9                   	leave  
80104481:	c3                   	ret    
    panic("popcli - interruptible");
80104482:	83 ec 0c             	sub    $0xc,%esp
80104485:	68 83 76 10 80       	push   $0x80107683
8010448a:	e8 01 bf ff ff       	call   80100390 <panic>
    panic("popcli");
8010448f:	83 ec 0c             	sub    $0xc,%esp
80104492:	68 9a 76 10 80       	push   $0x8010769a
80104497:	e8 f4 be ff ff       	call   80100390 <panic>
8010449c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801044a0 <holding>:
{
801044a0:	55                   	push   %ebp
801044a1:	89 e5                	mov    %esp,%ebp
801044a3:	56                   	push   %esi
801044a4:	53                   	push   %ebx
801044a5:	8b 75 08             	mov    0x8(%ebp),%esi
801044a8:	31 db                	xor    %ebx,%ebx
  pushcli();
801044aa:	e8 41 ff ff ff       	call   801043f0 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
801044af:	8b 06                	mov    (%esi),%eax
801044b1:	85 c0                	test   %eax,%eax
801044b3:	75 0b                	jne    801044c0 <holding+0x20>
  popcli();
801044b5:	e8 86 ff ff ff       	call   80104440 <popcli>
}
801044ba:	89 d8                	mov    %ebx,%eax
801044bc:	5b                   	pop    %ebx
801044bd:	5e                   	pop    %esi
801044be:	5d                   	pop    %ebp
801044bf:	c3                   	ret    
  r = lock->locked && lock->cpu == mycpu();
801044c0:	8b 5e 08             	mov    0x8(%esi),%ebx
801044c3:	e8 f8 f3 ff ff       	call   801038c0 <mycpu>
801044c8:	39 c3                	cmp    %eax,%ebx
801044ca:	0f 94 c3             	sete   %bl
  popcli();
801044cd:	e8 6e ff ff ff       	call   80104440 <popcli>
  r = lock->locked && lock->cpu == mycpu();
801044d2:	0f b6 db             	movzbl %bl,%ebx
}
801044d5:	89 d8                	mov    %ebx,%eax
801044d7:	5b                   	pop    %ebx
801044d8:	5e                   	pop    %esi
801044d9:	5d                   	pop    %ebp
801044da:	c3                   	ret    
801044db:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801044df:	90                   	nop

801044e0 <acquire>:
{
801044e0:	55                   	push   %ebp
801044e1:	89 e5                	mov    %esp,%ebp
801044e3:	56                   	push   %esi
801044e4:	53                   	push   %ebx
  pushcli(); // disable interrupts to avoid deadlock.
801044e5:	e8 06 ff ff ff       	call   801043f0 <pushcli>
  if(holding(lk))
801044ea:	8b 5d 08             	mov    0x8(%ebp),%ebx
801044ed:	83 ec 0c             	sub    $0xc,%esp
801044f0:	53                   	push   %ebx
801044f1:	e8 aa ff ff ff       	call   801044a0 <holding>
801044f6:	83 c4 10             	add    $0x10,%esp
801044f9:	85 c0                	test   %eax,%eax
801044fb:	0f 85 83 00 00 00    	jne    80104584 <acquire+0xa4>
80104501:	89 c6                	mov    %eax,%esi
  asm volatile("lock; xchgl %0, %1" :
80104503:	ba 01 00 00 00       	mov    $0x1,%edx
80104508:	eb 09                	jmp    80104513 <acquire+0x33>
8010450a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104510:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104513:	89 d0                	mov    %edx,%eax
80104515:	f0 87 03             	lock xchg %eax,(%ebx)
  while(xchg(&lk->locked, 1) != 0)
80104518:	85 c0                	test   %eax,%eax
8010451a:	75 f4                	jne    80104510 <acquire+0x30>
  __sync_synchronize();
8010451c:	0f ae f0             	mfence 
  lk->cpu = mycpu();
8010451f:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104522:	e8 99 f3 ff ff       	call   801038c0 <mycpu>
80104527:	89 43 08             	mov    %eax,0x8(%ebx)
  ebp = (uint*)v - 2;
8010452a:	89 e8                	mov    %ebp,%eax
8010452c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104530:	8d 90 00 00 00 80    	lea    -0x80000000(%eax),%edx
80104536:	81 fa fe ff ff 7f    	cmp    $0x7ffffffe,%edx
8010453c:	77 22                	ja     80104560 <acquire+0x80>
    pcs[i] = ebp[1];     // saved %eip
8010453e:	8b 50 04             	mov    0x4(%eax),%edx
80104541:	89 54 b3 0c          	mov    %edx,0xc(%ebx,%esi,4)
  for(i = 0; i < 10; i++){
80104545:	83 c6 01             	add    $0x1,%esi
    ebp = (uint*)ebp[0]; // saved %ebp
80104548:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
8010454a:	83 fe 0a             	cmp    $0xa,%esi
8010454d:	75 e1                	jne    80104530 <acquire+0x50>
}
8010454f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104552:	5b                   	pop    %ebx
80104553:	5e                   	pop    %esi
80104554:	5d                   	pop    %ebp
80104555:	c3                   	ret    
80104556:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010455d:	8d 76 00             	lea    0x0(%esi),%esi
  for(; i < 10; i++)
80104560:	8d 44 b3 0c          	lea    0xc(%ebx,%esi,4),%eax
80104564:	83 c3 34             	add    $0x34,%ebx
80104567:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010456e:	66 90                	xchg   %ax,%ax
    pcs[i] = 0;
80104570:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
80104576:	83 c0 04             	add    $0x4,%eax
80104579:	39 d8                	cmp    %ebx,%eax
8010457b:	75 f3                	jne    80104570 <acquire+0x90>
}
8010457d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104580:	5b                   	pop    %ebx
80104581:	5e                   	pop    %esi
80104582:	5d                   	pop    %ebp
80104583:	c3                   	ret    
    panic("acquire");
80104584:	83 ec 0c             	sub    $0xc,%esp
80104587:	68 a1 76 10 80       	push   $0x801076a1
8010458c:	e8 ff bd ff ff       	call   80100390 <panic>
80104591:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104598:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010459f:	90                   	nop

801045a0 <release>:
{
801045a0:	55                   	push   %ebp
801045a1:	89 e5                	mov    %esp,%ebp
801045a3:	53                   	push   %ebx
801045a4:	83 ec 10             	sub    $0x10,%esp
801045a7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holding(lk))
801045aa:	53                   	push   %ebx
801045ab:	e8 f0 fe ff ff       	call   801044a0 <holding>
801045b0:	83 c4 10             	add    $0x10,%esp
801045b3:	85 c0                	test   %eax,%eax
801045b5:	74 20                	je     801045d7 <release+0x37>
  lk->pcs[0] = 0;
801045b7:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
801045be:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
801045c5:	0f ae f0             	mfence 
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
801045c8:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
}
801045ce:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801045d1:	c9                   	leave  
  popcli();
801045d2:	e9 69 fe ff ff       	jmp    80104440 <popcli>
    panic("release");
801045d7:	83 ec 0c             	sub    $0xc,%esp
801045da:	68 a9 76 10 80       	push   $0x801076a9
801045df:	e8 ac bd ff ff       	call   80100390 <panic>
801045e4:	66 90                	xchg   %ax,%ax
801045e6:	66 90                	xchg   %ax,%ax
801045e8:	66 90                	xchg   %ax,%ax
801045ea:	66 90                	xchg   %ax,%ax
801045ec:	66 90                	xchg   %ax,%ax
801045ee:	66 90                	xchg   %ax,%ax

801045f0 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
801045f0:	55                   	push   %ebp
801045f1:	89 e5                	mov    %esp,%ebp
801045f3:	57                   	push   %edi
801045f4:	8b 55 08             	mov    0x8(%ebp),%edx
801045f7:	8b 4d 10             	mov    0x10(%ebp),%ecx
801045fa:	53                   	push   %ebx
  if ((int)dst%4 == 0 && n%4 == 0){
801045fb:	89 d0                	mov    %edx,%eax
801045fd:	09 c8                	or     %ecx,%eax
801045ff:	a8 03                	test   $0x3,%al
80104601:	75 2d                	jne    80104630 <memset+0x40>
    c &= 0xFF;
80104603:	0f b6 7d 0c          	movzbl 0xc(%ebp),%edi
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
80104607:	c1 e9 02             	shr    $0x2,%ecx
8010460a:	89 f8                	mov    %edi,%eax
8010460c:	89 fb                	mov    %edi,%ebx
8010460e:	c1 e0 18             	shl    $0x18,%eax
80104611:	c1 e3 10             	shl    $0x10,%ebx
80104614:	09 d8                	or     %ebx,%eax
80104616:	09 f8                	or     %edi,%eax
80104618:	c1 e7 08             	shl    $0x8,%edi
8010461b:	09 f8                	or     %edi,%eax
  asm volatile("cld; rep stosl" :
8010461d:	89 d7                	mov    %edx,%edi
8010461f:	fc                   	cld    
80104620:	f3 ab                	rep stos %eax,%es:(%edi)
  } else
    stosb(dst, c, n);
  return dst;
}
80104622:	5b                   	pop    %ebx
80104623:	89 d0                	mov    %edx,%eax
80104625:	5f                   	pop    %edi
80104626:	5d                   	pop    %ebp
80104627:	c3                   	ret    
80104628:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010462f:	90                   	nop
  asm volatile("cld; rep stosb" :
80104630:	89 d7                	mov    %edx,%edi
80104632:	8b 45 0c             	mov    0xc(%ebp),%eax
80104635:	fc                   	cld    
80104636:	f3 aa                	rep stos %al,%es:(%edi)
80104638:	5b                   	pop    %ebx
80104639:	89 d0                	mov    %edx,%eax
8010463b:	5f                   	pop    %edi
8010463c:	5d                   	pop    %ebp
8010463d:	c3                   	ret    
8010463e:	66 90                	xchg   %ax,%ax

80104640 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80104640:	55                   	push   %ebp
80104641:	89 e5                	mov    %esp,%ebp
80104643:	56                   	push   %esi
80104644:	8b 75 10             	mov    0x10(%ebp),%esi
80104647:	8b 45 08             	mov    0x8(%ebp),%eax
8010464a:	53                   	push   %ebx
8010464b:	8b 55 0c             	mov    0xc(%ebp),%edx
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
8010464e:	85 f6                	test   %esi,%esi
80104650:	74 22                	je     80104674 <memcmp+0x34>
    if(*s1 != *s2)
80104652:	0f b6 08             	movzbl (%eax),%ecx
80104655:	0f b6 1a             	movzbl (%edx),%ebx
80104658:	01 c6                	add    %eax,%esi
8010465a:	38 cb                	cmp    %cl,%bl
8010465c:	74 0c                	je     8010466a <memcmp+0x2a>
8010465e:	eb 20                	jmp    80104680 <memcmp+0x40>
80104660:	0f b6 08             	movzbl (%eax),%ecx
80104663:	0f b6 1a             	movzbl (%edx),%ebx
80104666:	38 d9                	cmp    %bl,%cl
80104668:	75 16                	jne    80104680 <memcmp+0x40>
      return *s1 - *s2;
    s1++, s2++;
8010466a:	83 c0 01             	add    $0x1,%eax
8010466d:	83 c2 01             	add    $0x1,%edx
  while(n-- > 0){
80104670:	39 c6                	cmp    %eax,%esi
80104672:	75 ec                	jne    80104660 <memcmp+0x20>
  }

  return 0;
}
80104674:	5b                   	pop    %ebx
  return 0;
80104675:	31 c0                	xor    %eax,%eax
}
80104677:	5e                   	pop    %esi
80104678:	5d                   	pop    %ebp
80104679:	c3                   	ret    
8010467a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      return *s1 - *s2;
80104680:	0f b6 c1             	movzbl %cl,%eax
80104683:	29 d8                	sub    %ebx,%eax
}
80104685:	5b                   	pop    %ebx
80104686:	5e                   	pop    %esi
80104687:	5d                   	pop    %ebp
80104688:	c3                   	ret    
80104689:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104690 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80104690:	55                   	push   %ebp
80104691:	89 e5                	mov    %esp,%ebp
80104693:	57                   	push   %edi
80104694:	8b 45 08             	mov    0x8(%ebp),%eax
80104697:	8b 4d 10             	mov    0x10(%ebp),%ecx
8010469a:	56                   	push   %esi
8010469b:	8b 75 0c             	mov    0xc(%ebp),%esi
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
8010469e:	39 c6                	cmp    %eax,%esi
801046a0:	73 26                	jae    801046c8 <memmove+0x38>
801046a2:	8d 3c 0e             	lea    (%esi,%ecx,1),%edi
801046a5:	39 f8                	cmp    %edi,%eax
801046a7:	73 1f                	jae    801046c8 <memmove+0x38>
801046a9:	8d 51 ff             	lea    -0x1(%ecx),%edx
    s += n;
    d += n;
    while(n-- > 0)
801046ac:	85 c9                	test   %ecx,%ecx
801046ae:	74 0f                	je     801046bf <memmove+0x2f>
      *--d = *--s;
801046b0:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
801046b4:	88 0c 10             	mov    %cl,(%eax,%edx,1)
    while(n-- > 0)
801046b7:	83 ea 01             	sub    $0x1,%edx
801046ba:	83 fa ff             	cmp    $0xffffffff,%edx
801046bd:	75 f1                	jne    801046b0 <memmove+0x20>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
801046bf:	5e                   	pop    %esi
801046c0:	5f                   	pop    %edi
801046c1:	5d                   	pop    %ebp
801046c2:	c3                   	ret    
801046c3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801046c7:	90                   	nop
    while(n-- > 0)
801046c8:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
801046cb:	89 c7                	mov    %eax,%edi
801046cd:	85 c9                	test   %ecx,%ecx
801046cf:	74 ee                	je     801046bf <memmove+0x2f>
801046d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      *d++ = *s++;
801046d8:	a4                   	movsb  %ds:(%esi),%es:(%edi)
    while(n-- > 0)
801046d9:	39 d6                	cmp    %edx,%esi
801046db:	75 fb                	jne    801046d8 <memmove+0x48>
}
801046dd:	5e                   	pop    %esi
801046de:	5f                   	pop    %edi
801046df:	5d                   	pop    %ebp
801046e0:	c3                   	ret    
801046e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801046e8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801046ef:	90                   	nop

801046f0 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
  return memmove(dst, src, n);
801046f0:	eb 9e                	jmp    80104690 <memmove>
801046f2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801046f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104700 <strncmp>:
}

int
strncmp(const char *p, const char *q, uint n)
{
80104700:	55                   	push   %ebp
80104701:	89 e5                	mov    %esp,%ebp
80104703:	57                   	push   %edi
80104704:	8b 7d 10             	mov    0x10(%ebp),%edi
80104707:	8b 4d 08             	mov    0x8(%ebp),%ecx
8010470a:	56                   	push   %esi
8010470b:	8b 75 0c             	mov    0xc(%ebp),%esi
8010470e:	53                   	push   %ebx
  while(n > 0 && *p && *p == *q)
8010470f:	85 ff                	test   %edi,%edi
80104711:	74 2f                	je     80104742 <strncmp+0x42>
80104713:	0f b6 11             	movzbl (%ecx),%edx
80104716:	0f b6 1e             	movzbl (%esi),%ebx
80104719:	84 d2                	test   %dl,%dl
8010471b:	74 37                	je     80104754 <strncmp+0x54>
8010471d:	38 da                	cmp    %bl,%dl
8010471f:	75 33                	jne    80104754 <strncmp+0x54>
80104721:	01 f7                	add    %esi,%edi
80104723:	eb 13                	jmp    80104738 <strncmp+0x38>
80104725:	8d 76 00             	lea    0x0(%esi),%esi
80104728:	0f b6 11             	movzbl (%ecx),%edx
8010472b:	84 d2                	test   %dl,%dl
8010472d:	74 21                	je     80104750 <strncmp+0x50>
8010472f:	0f b6 18             	movzbl (%eax),%ebx
80104732:	89 c6                	mov    %eax,%esi
80104734:	38 da                	cmp    %bl,%dl
80104736:	75 1c                	jne    80104754 <strncmp+0x54>
    n--, p++, q++;
80104738:	8d 46 01             	lea    0x1(%esi),%eax
8010473b:	83 c1 01             	add    $0x1,%ecx
  while(n > 0 && *p && *p == *q)
8010473e:	39 f8                	cmp    %edi,%eax
80104740:	75 e6                	jne    80104728 <strncmp+0x28>
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
}
80104742:	5b                   	pop    %ebx
    return 0;
80104743:	31 c0                	xor    %eax,%eax
}
80104745:	5e                   	pop    %esi
80104746:	5f                   	pop    %edi
80104747:	5d                   	pop    %ebp
80104748:	c3                   	ret    
80104749:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104750:	0f b6 5e 01          	movzbl 0x1(%esi),%ebx
  return (uchar)*p - (uchar)*q;
80104754:	0f b6 c2             	movzbl %dl,%eax
80104757:	29 d8                	sub    %ebx,%eax
}
80104759:	5b                   	pop    %ebx
8010475a:	5e                   	pop    %esi
8010475b:	5f                   	pop    %edi
8010475c:	5d                   	pop    %ebp
8010475d:	c3                   	ret    
8010475e:	66 90                	xchg   %ax,%ax

80104760 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80104760:	55                   	push   %ebp
80104761:	89 e5                	mov    %esp,%ebp
80104763:	57                   	push   %edi
80104764:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
80104767:	8b 4d 08             	mov    0x8(%ebp),%ecx
{
8010476a:	56                   	push   %esi
8010476b:	53                   	push   %ebx
8010476c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  while(n-- > 0 && (*s++ = *t++) != 0)
8010476f:	eb 1a                	jmp    8010478b <strncpy+0x2b>
80104771:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104778:	83 c2 01             	add    $0x1,%edx
8010477b:	0f b6 42 ff          	movzbl -0x1(%edx),%eax
8010477f:	83 c1 01             	add    $0x1,%ecx
80104782:	88 41 ff             	mov    %al,-0x1(%ecx)
80104785:	84 c0                	test   %al,%al
80104787:	74 09                	je     80104792 <strncpy+0x32>
80104789:	89 fb                	mov    %edi,%ebx
8010478b:	8d 7b ff             	lea    -0x1(%ebx),%edi
8010478e:	85 db                	test   %ebx,%ebx
80104790:	7f e6                	jg     80104778 <strncpy+0x18>
    ;
  while(n-- > 0)
80104792:	89 ce                	mov    %ecx,%esi
80104794:	85 ff                	test   %edi,%edi
80104796:	7e 1b                	jle    801047b3 <strncpy+0x53>
80104798:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010479f:	90                   	nop
    *s++ = 0;
801047a0:	83 c6 01             	add    $0x1,%esi
801047a3:	c6 46 ff 00          	movb   $0x0,-0x1(%esi)
  while(n-- > 0)
801047a7:	89 f2                	mov    %esi,%edx
801047a9:	f7 d2                	not    %edx
801047ab:	01 ca                	add    %ecx,%edx
801047ad:	01 da                	add    %ebx,%edx
801047af:	85 d2                	test   %edx,%edx
801047b1:	7f ed                	jg     801047a0 <strncpy+0x40>
  return os;
}
801047b3:	5b                   	pop    %ebx
801047b4:	8b 45 08             	mov    0x8(%ebp),%eax
801047b7:	5e                   	pop    %esi
801047b8:	5f                   	pop    %edi
801047b9:	5d                   	pop    %ebp
801047ba:	c3                   	ret    
801047bb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801047bf:	90                   	nop

801047c0 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
801047c0:	55                   	push   %ebp
801047c1:	89 e5                	mov    %esp,%ebp
801047c3:	56                   	push   %esi
801047c4:	8b 4d 10             	mov    0x10(%ebp),%ecx
801047c7:	8b 45 08             	mov    0x8(%ebp),%eax
801047ca:	53                   	push   %ebx
801047cb:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *os;

  os = s;
  if(n <= 0)
801047ce:	85 c9                	test   %ecx,%ecx
801047d0:	7e 26                	jle    801047f8 <safestrcpy+0x38>
801047d2:	8d 74 0a ff          	lea    -0x1(%edx,%ecx,1),%esi
801047d6:	89 c1                	mov    %eax,%ecx
801047d8:	eb 17                	jmp    801047f1 <safestrcpy+0x31>
801047da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
801047e0:	83 c2 01             	add    $0x1,%edx
801047e3:	0f b6 5a ff          	movzbl -0x1(%edx),%ebx
801047e7:	83 c1 01             	add    $0x1,%ecx
801047ea:	88 59 ff             	mov    %bl,-0x1(%ecx)
801047ed:	84 db                	test   %bl,%bl
801047ef:	74 04                	je     801047f5 <safestrcpy+0x35>
801047f1:	39 f2                	cmp    %esi,%edx
801047f3:	75 eb                	jne    801047e0 <safestrcpy+0x20>
    ;
  *s = 0;
801047f5:	c6 01 00             	movb   $0x0,(%ecx)
  return os;
}
801047f8:	5b                   	pop    %ebx
801047f9:	5e                   	pop    %esi
801047fa:	5d                   	pop    %ebp
801047fb:	c3                   	ret    
801047fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104800 <strlen>:

int
strlen(const char *s)
{
80104800:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
80104801:	31 c0                	xor    %eax,%eax
{
80104803:	89 e5                	mov    %esp,%ebp
80104805:	8b 55 08             	mov    0x8(%ebp),%edx
  for(n = 0; s[n]; n++)
80104808:	80 3a 00             	cmpb   $0x0,(%edx)
8010480b:	74 0c                	je     80104819 <strlen+0x19>
8010480d:	8d 76 00             	lea    0x0(%esi),%esi
80104810:	83 c0 01             	add    $0x1,%eax
80104813:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
80104817:	75 f7                	jne    80104810 <strlen+0x10>
    ;
  return n;
}
80104819:	5d                   	pop    %ebp
8010481a:	c3                   	ret    

8010481b <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
8010481b:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
8010481f:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-saved registers
  pushl %ebp
80104823:	55                   	push   %ebp
  pushl %ebx
80104824:	53                   	push   %ebx
  pushl %esi
80104825:	56                   	push   %esi
  pushl %edi
80104826:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80104827:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80104829:	89 d4                	mov    %edx,%esp

  # Load new callee-saved registers
  popl %edi
8010482b:	5f                   	pop    %edi
  popl %esi
8010482c:	5e                   	pop    %esi
  popl %ebx
8010482d:	5b                   	pop    %ebx
  popl %ebp
8010482e:	5d                   	pop    %ebp
  ret
8010482f:	c3                   	ret    

80104830 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80104830:	55                   	push   %ebp
80104831:	89 e5                	mov    %esp,%ebp
80104833:	53                   	push   %ebx
80104834:	83 ec 04             	sub    $0x4,%esp
80104837:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
8010483a:	e8 21 f1 ff ff       	call   80103960 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
8010483f:	8b 00                	mov    (%eax),%eax
80104841:	39 d8                	cmp    %ebx,%eax
80104843:	76 1b                	jbe    80104860 <fetchint+0x30>
80104845:	8d 53 04             	lea    0x4(%ebx),%edx
80104848:	39 d0                	cmp    %edx,%eax
8010484a:	72 14                	jb     80104860 <fetchint+0x30>
    return -1;
  *ip = *(int*)(addr);
8010484c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010484f:	8b 13                	mov    (%ebx),%edx
80104851:	89 10                	mov    %edx,(%eax)
  return 0;
80104853:	31 c0                	xor    %eax,%eax
}
80104855:	83 c4 04             	add    $0x4,%esp
80104858:	5b                   	pop    %ebx
80104859:	5d                   	pop    %ebp
8010485a:	c3                   	ret    
8010485b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010485f:	90                   	nop
    return -1;
80104860:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104865:	eb ee                	jmp    80104855 <fetchint+0x25>
80104867:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010486e:	66 90                	xchg   %ax,%ax

80104870 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80104870:	55                   	push   %ebp
80104871:	89 e5                	mov    %esp,%ebp
80104873:	53                   	push   %ebx
80104874:	83 ec 04             	sub    $0x4,%esp
80104877:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
8010487a:	e8 e1 f0 ff ff       	call   80103960 <myproc>

  if(addr >= curproc->sz)
8010487f:	39 18                	cmp    %ebx,(%eax)
80104881:	76 29                	jbe    801048ac <fetchstr+0x3c>
    return -1;
  *pp = (char*)addr;
80104883:	8b 55 0c             	mov    0xc(%ebp),%edx
80104886:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
80104888:	8b 10                	mov    (%eax),%edx
  for(s = *pp; s < ep; s++){
8010488a:	39 d3                	cmp    %edx,%ebx
8010488c:	73 1e                	jae    801048ac <fetchstr+0x3c>
    if(*s == 0)
8010488e:	80 3b 00             	cmpb   $0x0,(%ebx)
80104891:	74 35                	je     801048c8 <fetchstr+0x58>
80104893:	89 d8                	mov    %ebx,%eax
80104895:	eb 0e                	jmp    801048a5 <fetchstr+0x35>
80104897:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010489e:	66 90                	xchg   %ax,%ax
801048a0:	80 38 00             	cmpb   $0x0,(%eax)
801048a3:	74 1b                	je     801048c0 <fetchstr+0x50>
  for(s = *pp; s < ep; s++){
801048a5:	83 c0 01             	add    $0x1,%eax
801048a8:	39 c2                	cmp    %eax,%edx
801048aa:	77 f4                	ja     801048a0 <fetchstr+0x30>
    return -1;
801048ac:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
      return s - *pp;
  }
  return -1;
}
801048b1:	83 c4 04             	add    $0x4,%esp
801048b4:	5b                   	pop    %ebx
801048b5:	5d                   	pop    %ebp
801048b6:	c3                   	ret    
801048b7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801048be:	66 90                	xchg   %ax,%ax
801048c0:	83 c4 04             	add    $0x4,%esp
801048c3:	29 d8                	sub    %ebx,%eax
801048c5:	5b                   	pop    %ebx
801048c6:	5d                   	pop    %ebp
801048c7:	c3                   	ret    
    if(*s == 0)
801048c8:	31 c0                	xor    %eax,%eax
      return s - *pp;
801048ca:	eb e5                	jmp    801048b1 <fetchstr+0x41>
801048cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801048d0 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
801048d0:	55                   	push   %ebp
801048d1:	89 e5                	mov    %esp,%ebp
801048d3:	56                   	push   %esi
801048d4:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
801048d5:	e8 86 f0 ff ff       	call   80103960 <myproc>
801048da:	8b 55 08             	mov    0x8(%ebp),%edx
801048dd:	8b 40 18             	mov    0x18(%eax),%eax
801048e0:	8b 40 44             	mov    0x44(%eax),%eax
801048e3:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
801048e6:	e8 75 f0 ff ff       	call   80103960 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
801048eb:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
801048ee:	8b 00                	mov    (%eax),%eax
801048f0:	39 c6                	cmp    %eax,%esi
801048f2:	73 1c                	jae    80104910 <argint+0x40>
801048f4:	8d 53 08             	lea    0x8(%ebx),%edx
801048f7:	39 d0                	cmp    %edx,%eax
801048f9:	72 15                	jb     80104910 <argint+0x40>
  *ip = *(int*)(addr);
801048fb:	8b 45 0c             	mov    0xc(%ebp),%eax
801048fe:	8b 53 04             	mov    0x4(%ebx),%edx
80104901:	89 10                	mov    %edx,(%eax)
  return 0;
80104903:	31 c0                	xor    %eax,%eax
}
80104905:	5b                   	pop    %ebx
80104906:	5e                   	pop    %esi
80104907:	5d                   	pop    %ebp
80104908:	c3                   	ret    
80104909:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80104910:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104915:	eb ee                	jmp    80104905 <argint+0x35>
80104917:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010491e:	66 90                	xchg   %ax,%ax

80104920 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80104920:	55                   	push   %ebp
80104921:	89 e5                	mov    %esp,%ebp
80104923:	56                   	push   %esi
80104924:	53                   	push   %ebx
80104925:	83 ec 10             	sub    $0x10,%esp
80104928:	8b 5d 10             	mov    0x10(%ebp),%ebx
  int i;
  struct proc *curproc = myproc();
8010492b:	e8 30 f0 ff ff       	call   80103960 <myproc>
 
  if(argint(n, &i) < 0)
80104930:	83 ec 08             	sub    $0x8,%esp
  struct proc *curproc = myproc();
80104933:	89 c6                	mov    %eax,%esi
  if(argint(n, &i) < 0)
80104935:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104938:	50                   	push   %eax
80104939:	ff 75 08             	pushl  0x8(%ebp)
8010493c:	e8 8f ff ff ff       	call   801048d0 <argint>
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80104941:	83 c4 10             	add    $0x10,%esp
80104944:	85 c0                	test   %eax,%eax
80104946:	78 28                	js     80104970 <argptr+0x50>
80104948:	85 db                	test   %ebx,%ebx
8010494a:	78 24                	js     80104970 <argptr+0x50>
8010494c:	8b 16                	mov    (%esi),%edx
8010494e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104951:	39 c2                	cmp    %eax,%edx
80104953:	76 1b                	jbe    80104970 <argptr+0x50>
80104955:	01 c3                	add    %eax,%ebx
80104957:	39 da                	cmp    %ebx,%edx
80104959:	72 15                	jb     80104970 <argptr+0x50>
    return -1;
  *pp = (char*)i;
8010495b:	8b 55 0c             	mov    0xc(%ebp),%edx
8010495e:	89 02                	mov    %eax,(%edx)
  return 0;
80104960:	31 c0                	xor    %eax,%eax
}
80104962:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104965:	5b                   	pop    %ebx
80104966:	5e                   	pop    %esi
80104967:	5d                   	pop    %ebp
80104968:	c3                   	ret    
80104969:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80104970:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104975:	eb eb                	jmp    80104962 <argptr+0x42>
80104977:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010497e:	66 90                	xchg   %ax,%ax

80104980 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80104980:	55                   	push   %ebp
80104981:	89 e5                	mov    %esp,%ebp
80104983:	83 ec 20             	sub    $0x20,%esp
  int addr;
  if(argint(n, &addr) < 0)
80104986:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104989:	50                   	push   %eax
8010498a:	ff 75 08             	pushl  0x8(%ebp)
8010498d:	e8 3e ff ff ff       	call   801048d0 <argint>
80104992:	83 c4 10             	add    $0x10,%esp
80104995:	85 c0                	test   %eax,%eax
80104997:	78 17                	js     801049b0 <argstr+0x30>
    return -1;
  return fetchstr(addr, pp);
80104999:	83 ec 08             	sub    $0x8,%esp
8010499c:	ff 75 0c             	pushl  0xc(%ebp)
8010499f:	ff 75 f4             	pushl  -0xc(%ebp)
801049a2:	e8 c9 fe ff ff       	call   80104870 <fetchstr>
801049a7:	83 c4 10             	add    $0x10,%esp
}
801049aa:	c9                   	leave  
801049ab:	c3                   	ret    
801049ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801049b0:	c9                   	leave  
    return -1;
801049b1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801049b6:	c3                   	ret    
801049b7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801049be:	66 90                	xchg   %ax,%ax

801049c0 <syscall>:
[SYS_freemem] sys_freemem,
};

void
syscall(void)
{
801049c0:	55                   	push   %ebp
801049c1:	89 e5                	mov    %esp,%ebp
801049c3:	53                   	push   %ebx
801049c4:	83 ec 04             	sub    $0x4,%esp
  int num;
  struct proc *curproc = myproc();
801049c7:	e8 94 ef ff ff       	call   80103960 <myproc>
801049cc:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
801049ce:	8b 40 18             	mov    0x18(%eax),%eax
801049d1:	8b 40 1c             	mov    0x1c(%eax),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
801049d4:	8d 50 ff             	lea    -0x1(%eax),%edx
801049d7:	83 fa 15             	cmp    $0x15,%edx
801049da:	77 1c                	ja     801049f8 <syscall+0x38>
801049dc:	8b 14 85 e0 76 10 80 	mov    -0x7fef8920(,%eax,4),%edx
801049e3:	85 d2                	test   %edx,%edx
801049e5:	74 11                	je     801049f8 <syscall+0x38>
    curproc->tf->eax = syscalls[num]();
801049e7:	ff d2                	call   *%edx
801049e9:	8b 53 18             	mov    0x18(%ebx),%edx
801049ec:	89 42 1c             	mov    %eax,0x1c(%edx)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
801049ef:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801049f2:	c9                   	leave  
801049f3:	c3                   	ret    
801049f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    cprintf("%d %s: unknown sys call %d\n",
801049f8:	50                   	push   %eax
            curproc->pid, curproc->name, num);
801049f9:	8d 43 6c             	lea    0x6c(%ebx),%eax
    cprintf("%d %s: unknown sys call %d\n",
801049fc:	50                   	push   %eax
801049fd:	ff 73 10             	pushl  0x10(%ebx)
80104a00:	68 b1 76 10 80       	push   $0x801076b1
80104a05:	e8 a6 bc ff ff       	call   801006b0 <cprintf>
    curproc->tf->eax = -1;
80104a0a:	8b 43 18             	mov    0x18(%ebx),%eax
80104a0d:	83 c4 10             	add    $0x10,%esp
80104a10:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
}
80104a17:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104a1a:	c9                   	leave  
80104a1b:	c3                   	ret    
80104a1c:	66 90                	xchg   %ax,%ax
80104a1e:	66 90                	xchg   %ax,%ax

80104a20 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80104a20:	55                   	push   %ebp
80104a21:	89 e5                	mov    %esp,%ebp
80104a23:	57                   	push   %edi
80104a24:	56                   	push   %esi
80104a25:	53                   	push   %ebx
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80104a26:	8d 5d da             	lea    -0x26(%ebp),%ebx
{
80104a29:	83 ec 44             	sub    $0x44,%esp
80104a2c:	89 4d c0             	mov    %ecx,-0x40(%ebp)
80104a2f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  if((dp = nameiparent(path, name)) == 0)
80104a32:	53                   	push   %ebx
80104a33:	50                   	push   %eax
{
80104a34:	89 55 c4             	mov    %edx,-0x3c(%ebp)
80104a37:	89 4d bc             	mov    %ecx,-0x44(%ebp)
  if((dp = nameiparent(path, name)) == 0)
80104a3a:	e8 a1 d5 ff ff       	call   80101fe0 <nameiparent>
80104a3f:	83 c4 10             	add    $0x10,%esp
80104a42:	85 c0                	test   %eax,%eax
80104a44:	0f 84 46 01 00 00    	je     80104b90 <create+0x170>
    return 0;
  ilock(dp);
80104a4a:	83 ec 0c             	sub    $0xc,%esp
80104a4d:	89 c6                	mov    %eax,%esi
80104a4f:	50                   	push   %eax
80104a50:	e8 cb cc ff ff       	call   80101720 <ilock>

  if((ip = dirlookup(dp, name, &off)) != 0){
80104a55:	83 c4 0c             	add    $0xc,%esp
80104a58:	8d 45 d4             	lea    -0x2c(%ebp),%eax
80104a5b:	50                   	push   %eax
80104a5c:	53                   	push   %ebx
80104a5d:	56                   	push   %esi
80104a5e:	e8 ed d1 ff ff       	call   80101c50 <dirlookup>
80104a63:	83 c4 10             	add    $0x10,%esp
80104a66:	89 c7                	mov    %eax,%edi
80104a68:	85 c0                	test   %eax,%eax
80104a6a:	74 54                	je     80104ac0 <create+0xa0>
    iunlockput(dp);
80104a6c:	83 ec 0c             	sub    $0xc,%esp
80104a6f:	56                   	push   %esi
80104a70:	e8 3b cf ff ff       	call   801019b0 <iunlockput>
    ilock(ip);
80104a75:	89 3c 24             	mov    %edi,(%esp)
80104a78:	e8 a3 cc ff ff       	call   80101720 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
80104a7d:	83 c4 10             	add    $0x10,%esp
80104a80:	66 83 7d c4 02       	cmpw   $0x2,-0x3c(%ebp)
80104a85:	75 19                	jne    80104aa0 <create+0x80>
80104a87:	66 83 7f 50 02       	cmpw   $0x2,0x50(%edi)
80104a8c:	75 12                	jne    80104aa0 <create+0x80>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
80104a8e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104a91:	89 f8                	mov    %edi,%eax
80104a93:	5b                   	pop    %ebx
80104a94:	5e                   	pop    %esi
80104a95:	5f                   	pop    %edi
80104a96:	5d                   	pop    %ebp
80104a97:	c3                   	ret    
80104a98:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104a9f:	90                   	nop
    iunlockput(ip);
80104aa0:	83 ec 0c             	sub    $0xc,%esp
80104aa3:	57                   	push   %edi
    return 0;
80104aa4:	31 ff                	xor    %edi,%edi
    iunlockput(ip);
80104aa6:	e8 05 cf ff ff       	call   801019b0 <iunlockput>
    return 0;
80104aab:	83 c4 10             	add    $0x10,%esp
}
80104aae:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104ab1:	89 f8                	mov    %edi,%eax
80104ab3:	5b                   	pop    %ebx
80104ab4:	5e                   	pop    %esi
80104ab5:	5f                   	pop    %edi
80104ab6:	5d                   	pop    %ebp
80104ab7:	c3                   	ret    
80104ab8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104abf:	90                   	nop
  if((ip = ialloc(dp->dev, type)) == 0)
80104ac0:	0f bf 45 c4          	movswl -0x3c(%ebp),%eax
80104ac4:	83 ec 08             	sub    $0x8,%esp
80104ac7:	50                   	push   %eax
80104ac8:	ff 36                	pushl  (%esi)
80104aca:	e8 e1 ca ff ff       	call   801015b0 <ialloc>
80104acf:	83 c4 10             	add    $0x10,%esp
80104ad2:	89 c7                	mov    %eax,%edi
80104ad4:	85 c0                	test   %eax,%eax
80104ad6:	0f 84 cd 00 00 00    	je     80104ba9 <create+0x189>
  ilock(ip);
80104adc:	83 ec 0c             	sub    $0xc,%esp
80104adf:	50                   	push   %eax
80104ae0:	e8 3b cc ff ff       	call   80101720 <ilock>
  ip->major = major;
80104ae5:	0f b7 45 c0          	movzwl -0x40(%ebp),%eax
80104ae9:	66 89 47 52          	mov    %ax,0x52(%edi)
  ip->minor = minor;
80104aed:	0f b7 45 bc          	movzwl -0x44(%ebp),%eax
80104af1:	66 89 47 54          	mov    %ax,0x54(%edi)
  ip->nlink = 1;
80104af5:	b8 01 00 00 00       	mov    $0x1,%eax
80104afa:	66 89 47 56          	mov    %ax,0x56(%edi)
  iupdate(ip);
80104afe:	89 3c 24             	mov    %edi,(%esp)
80104b01:	e8 6a cb ff ff       	call   80101670 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
80104b06:	83 c4 10             	add    $0x10,%esp
80104b09:	66 83 7d c4 01       	cmpw   $0x1,-0x3c(%ebp)
80104b0e:	74 30                	je     80104b40 <create+0x120>
  if(dirlink(dp, name, ip->inum) < 0)
80104b10:	83 ec 04             	sub    $0x4,%esp
80104b13:	ff 77 04             	pushl  0x4(%edi)
80104b16:	53                   	push   %ebx
80104b17:	56                   	push   %esi
80104b18:	e8 e3 d3 ff ff       	call   80101f00 <dirlink>
80104b1d:	83 c4 10             	add    $0x10,%esp
80104b20:	85 c0                	test   %eax,%eax
80104b22:	78 78                	js     80104b9c <create+0x17c>
  iunlockput(dp);
80104b24:	83 ec 0c             	sub    $0xc,%esp
80104b27:	56                   	push   %esi
80104b28:	e8 83 ce ff ff       	call   801019b0 <iunlockput>
  return ip;
80104b2d:	83 c4 10             	add    $0x10,%esp
}
80104b30:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104b33:	89 f8                	mov    %edi,%eax
80104b35:	5b                   	pop    %ebx
80104b36:	5e                   	pop    %esi
80104b37:	5f                   	pop    %edi
80104b38:	5d                   	pop    %ebp
80104b39:	c3                   	ret    
80104b3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iupdate(dp);
80104b40:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink++;  // for ".."
80104b43:	66 83 46 56 01       	addw   $0x1,0x56(%esi)
    iupdate(dp);
80104b48:	56                   	push   %esi
80104b49:	e8 22 cb ff ff       	call   80101670 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
80104b4e:	83 c4 0c             	add    $0xc,%esp
80104b51:	ff 77 04             	pushl  0x4(%edi)
80104b54:	68 58 77 10 80       	push   $0x80107758
80104b59:	57                   	push   %edi
80104b5a:	e8 a1 d3 ff ff       	call   80101f00 <dirlink>
80104b5f:	83 c4 10             	add    $0x10,%esp
80104b62:	85 c0                	test   %eax,%eax
80104b64:	78 18                	js     80104b7e <create+0x15e>
80104b66:	83 ec 04             	sub    $0x4,%esp
80104b69:	ff 76 04             	pushl  0x4(%esi)
80104b6c:	68 57 77 10 80       	push   $0x80107757
80104b71:	57                   	push   %edi
80104b72:	e8 89 d3 ff ff       	call   80101f00 <dirlink>
80104b77:	83 c4 10             	add    $0x10,%esp
80104b7a:	85 c0                	test   %eax,%eax
80104b7c:	79 92                	jns    80104b10 <create+0xf0>
      panic("create dots");
80104b7e:	83 ec 0c             	sub    $0xc,%esp
80104b81:	68 4b 77 10 80       	push   $0x8010774b
80104b86:	e8 05 b8 ff ff       	call   80100390 <panic>
80104b8b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104b8f:	90                   	nop
}
80104b90:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
80104b93:	31 ff                	xor    %edi,%edi
}
80104b95:	5b                   	pop    %ebx
80104b96:	89 f8                	mov    %edi,%eax
80104b98:	5e                   	pop    %esi
80104b99:	5f                   	pop    %edi
80104b9a:	5d                   	pop    %ebp
80104b9b:	c3                   	ret    
    panic("create: dirlink");
80104b9c:	83 ec 0c             	sub    $0xc,%esp
80104b9f:	68 5a 77 10 80       	push   $0x8010775a
80104ba4:	e8 e7 b7 ff ff       	call   80100390 <panic>
    panic("create: ialloc");
80104ba9:	83 ec 0c             	sub    $0xc,%esp
80104bac:	68 3c 77 10 80       	push   $0x8010773c
80104bb1:	e8 da b7 ff ff       	call   80100390 <panic>
80104bb6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104bbd:	8d 76 00             	lea    0x0(%esi),%esi

80104bc0 <argfd.constprop.0>:
argfd(int n, int *pfd, struct file **pf)
80104bc0:	55                   	push   %ebp
80104bc1:	89 e5                	mov    %esp,%ebp
80104bc3:	56                   	push   %esi
80104bc4:	89 d6                	mov    %edx,%esi
80104bc6:	53                   	push   %ebx
80104bc7:	89 c3                	mov    %eax,%ebx
  if(argint(n, &fd) < 0)
80104bc9:	8d 45 f4             	lea    -0xc(%ebp),%eax
argfd(int n, int *pfd, struct file **pf)
80104bcc:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80104bcf:	50                   	push   %eax
80104bd0:	6a 00                	push   $0x0
80104bd2:	e8 f9 fc ff ff       	call   801048d0 <argint>
80104bd7:	83 c4 10             	add    $0x10,%esp
80104bda:	85 c0                	test   %eax,%eax
80104bdc:	78 2a                	js     80104c08 <argfd.constprop.0+0x48>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80104bde:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104be2:	77 24                	ja     80104c08 <argfd.constprop.0+0x48>
80104be4:	e8 77 ed ff ff       	call   80103960 <myproc>
80104be9:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104bec:	8b 44 90 28          	mov    0x28(%eax,%edx,4),%eax
80104bf0:	85 c0                	test   %eax,%eax
80104bf2:	74 14                	je     80104c08 <argfd.constprop.0+0x48>
  if(pfd)
80104bf4:	85 db                	test   %ebx,%ebx
80104bf6:	74 02                	je     80104bfa <argfd.constprop.0+0x3a>
    *pfd = fd;
80104bf8:	89 13                	mov    %edx,(%ebx)
    *pf = f;
80104bfa:	89 06                	mov    %eax,(%esi)
  return 0;
80104bfc:	31 c0                	xor    %eax,%eax
}
80104bfe:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104c01:	5b                   	pop    %ebx
80104c02:	5e                   	pop    %esi
80104c03:	5d                   	pop    %ebp
80104c04:	c3                   	ret    
80104c05:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80104c08:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104c0d:	eb ef                	jmp    80104bfe <argfd.constprop.0+0x3e>
80104c0f:	90                   	nop

80104c10 <sys_dup>:
{
80104c10:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0)
80104c11:	31 c0                	xor    %eax,%eax
{
80104c13:	89 e5                	mov    %esp,%ebp
80104c15:	56                   	push   %esi
80104c16:	53                   	push   %ebx
  if(argfd(0, 0, &f) < 0)
80104c17:	8d 55 f4             	lea    -0xc(%ebp),%edx
{
80104c1a:	83 ec 10             	sub    $0x10,%esp
  if(argfd(0, 0, &f) < 0)
80104c1d:	e8 9e ff ff ff       	call   80104bc0 <argfd.constprop.0>
80104c22:	85 c0                	test   %eax,%eax
80104c24:	78 1a                	js     80104c40 <sys_dup+0x30>
  if((fd=fdalloc(f)) < 0)
80104c26:	8b 75 f4             	mov    -0xc(%ebp),%esi
  for(fd = 0; fd < NOFILE; fd++){
80104c29:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
80104c2b:	e8 30 ed ff ff       	call   80103960 <myproc>
    if(curproc->ofile[fd] == 0){
80104c30:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80104c34:	85 d2                	test   %edx,%edx
80104c36:	74 18                	je     80104c50 <sys_dup+0x40>
  for(fd = 0; fd < NOFILE; fd++){
80104c38:	83 c3 01             	add    $0x1,%ebx
80104c3b:	83 fb 10             	cmp    $0x10,%ebx
80104c3e:	75 f0                	jne    80104c30 <sys_dup+0x20>
}
80104c40:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return -1;
80104c43:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
}
80104c48:	89 d8                	mov    %ebx,%eax
80104c4a:	5b                   	pop    %ebx
80104c4b:	5e                   	pop    %esi
80104c4c:	5d                   	pop    %ebp
80104c4d:	c3                   	ret    
80104c4e:	66 90                	xchg   %ax,%ax
      curproc->ofile[fd] = f;
80104c50:	89 74 98 28          	mov    %esi,0x28(%eax,%ebx,4)
  filedup(f);
80104c54:	83 ec 0c             	sub    $0xc,%esp
80104c57:	ff 75 f4             	pushl  -0xc(%ebp)
80104c5a:	e8 11 c2 ff ff       	call   80100e70 <filedup>
  return fd;
80104c5f:	83 c4 10             	add    $0x10,%esp
}
80104c62:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104c65:	89 d8                	mov    %ebx,%eax
80104c67:	5b                   	pop    %ebx
80104c68:	5e                   	pop    %esi
80104c69:	5d                   	pop    %ebp
80104c6a:	c3                   	ret    
80104c6b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104c6f:	90                   	nop

80104c70 <sys_read>:
{
80104c70:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104c71:	31 c0                	xor    %eax,%eax
{
80104c73:	89 e5                	mov    %esp,%ebp
80104c75:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104c78:	8d 55 ec             	lea    -0x14(%ebp),%edx
80104c7b:	e8 40 ff ff ff       	call   80104bc0 <argfd.constprop.0>
80104c80:	85 c0                	test   %eax,%eax
80104c82:	78 4c                	js     80104cd0 <sys_read+0x60>
80104c84:	83 ec 08             	sub    $0x8,%esp
80104c87:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104c8a:	50                   	push   %eax
80104c8b:	6a 02                	push   $0x2
80104c8d:	e8 3e fc ff ff       	call   801048d0 <argint>
80104c92:	83 c4 10             	add    $0x10,%esp
80104c95:	85 c0                	test   %eax,%eax
80104c97:	78 37                	js     80104cd0 <sys_read+0x60>
80104c99:	83 ec 04             	sub    $0x4,%esp
80104c9c:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104c9f:	ff 75 f0             	pushl  -0x10(%ebp)
80104ca2:	50                   	push   %eax
80104ca3:	6a 01                	push   $0x1
80104ca5:	e8 76 fc ff ff       	call   80104920 <argptr>
80104caa:	83 c4 10             	add    $0x10,%esp
80104cad:	85 c0                	test   %eax,%eax
80104caf:	78 1f                	js     80104cd0 <sys_read+0x60>
  return fileread(f, p, n);
80104cb1:	83 ec 04             	sub    $0x4,%esp
80104cb4:	ff 75 f0             	pushl  -0x10(%ebp)
80104cb7:	ff 75 f4             	pushl  -0xc(%ebp)
80104cba:	ff 75 ec             	pushl  -0x14(%ebp)
80104cbd:	e8 2e c3 ff ff       	call   80100ff0 <fileread>
80104cc2:	83 c4 10             	add    $0x10,%esp
}
80104cc5:	c9                   	leave  
80104cc6:	c3                   	ret    
80104cc7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104cce:	66 90                	xchg   %ax,%ax
80104cd0:	c9                   	leave  
    return -1;
80104cd1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104cd6:	c3                   	ret    
80104cd7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104cde:	66 90                	xchg   %ax,%ax

80104ce0 <sys_write>:
{
80104ce0:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104ce1:	31 c0                	xor    %eax,%eax
{
80104ce3:	89 e5                	mov    %esp,%ebp
80104ce5:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104ce8:	8d 55 ec             	lea    -0x14(%ebp),%edx
80104ceb:	e8 d0 fe ff ff       	call   80104bc0 <argfd.constprop.0>
80104cf0:	85 c0                	test   %eax,%eax
80104cf2:	78 4c                	js     80104d40 <sys_write+0x60>
80104cf4:	83 ec 08             	sub    $0x8,%esp
80104cf7:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104cfa:	50                   	push   %eax
80104cfb:	6a 02                	push   $0x2
80104cfd:	e8 ce fb ff ff       	call   801048d0 <argint>
80104d02:	83 c4 10             	add    $0x10,%esp
80104d05:	85 c0                	test   %eax,%eax
80104d07:	78 37                	js     80104d40 <sys_write+0x60>
80104d09:	83 ec 04             	sub    $0x4,%esp
80104d0c:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104d0f:	ff 75 f0             	pushl  -0x10(%ebp)
80104d12:	50                   	push   %eax
80104d13:	6a 01                	push   $0x1
80104d15:	e8 06 fc ff ff       	call   80104920 <argptr>
80104d1a:	83 c4 10             	add    $0x10,%esp
80104d1d:	85 c0                	test   %eax,%eax
80104d1f:	78 1f                	js     80104d40 <sys_write+0x60>
  return filewrite(f, p, n);
80104d21:	83 ec 04             	sub    $0x4,%esp
80104d24:	ff 75 f0             	pushl  -0x10(%ebp)
80104d27:	ff 75 f4             	pushl  -0xc(%ebp)
80104d2a:	ff 75 ec             	pushl  -0x14(%ebp)
80104d2d:	e8 4e c3 ff ff       	call   80101080 <filewrite>
80104d32:	83 c4 10             	add    $0x10,%esp
}
80104d35:	c9                   	leave  
80104d36:	c3                   	ret    
80104d37:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104d3e:	66 90                	xchg   %ax,%ax
80104d40:	c9                   	leave  
    return -1;
80104d41:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104d46:	c3                   	ret    
80104d47:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104d4e:	66 90                	xchg   %ax,%ax

80104d50 <sys_close>:
{
80104d50:	55                   	push   %ebp
80104d51:	89 e5                	mov    %esp,%ebp
80104d53:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, &fd, &f) < 0)
80104d56:	8d 55 f4             	lea    -0xc(%ebp),%edx
80104d59:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104d5c:	e8 5f fe ff ff       	call   80104bc0 <argfd.constprop.0>
80104d61:	85 c0                	test   %eax,%eax
80104d63:	78 2b                	js     80104d90 <sys_close+0x40>
  myproc()->ofile[fd] = 0;
80104d65:	e8 f6 eb ff ff       	call   80103960 <myproc>
80104d6a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  fileclose(f);
80104d6d:	83 ec 0c             	sub    $0xc,%esp
  myproc()->ofile[fd] = 0;
80104d70:	c7 44 90 28 00 00 00 	movl   $0x0,0x28(%eax,%edx,4)
80104d77:	00 
  fileclose(f);
80104d78:	ff 75 f4             	pushl  -0xc(%ebp)
80104d7b:	e8 40 c1 ff ff       	call   80100ec0 <fileclose>
  return 0;
80104d80:	83 c4 10             	add    $0x10,%esp
80104d83:	31 c0                	xor    %eax,%eax
}
80104d85:	c9                   	leave  
80104d86:	c3                   	ret    
80104d87:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104d8e:	66 90                	xchg   %ax,%ax
80104d90:	c9                   	leave  
    return -1;
80104d91:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104d96:	c3                   	ret    
80104d97:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104d9e:	66 90                	xchg   %ax,%ax

80104da0 <sys_fstat>:
{
80104da0:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80104da1:	31 c0                	xor    %eax,%eax
{
80104da3:	89 e5                	mov    %esp,%ebp
80104da5:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80104da8:	8d 55 f0             	lea    -0x10(%ebp),%edx
80104dab:	e8 10 fe ff ff       	call   80104bc0 <argfd.constprop.0>
80104db0:	85 c0                	test   %eax,%eax
80104db2:	78 2c                	js     80104de0 <sys_fstat+0x40>
80104db4:	83 ec 04             	sub    $0x4,%esp
80104db7:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104dba:	6a 14                	push   $0x14
80104dbc:	50                   	push   %eax
80104dbd:	6a 01                	push   $0x1
80104dbf:	e8 5c fb ff ff       	call   80104920 <argptr>
80104dc4:	83 c4 10             	add    $0x10,%esp
80104dc7:	85 c0                	test   %eax,%eax
80104dc9:	78 15                	js     80104de0 <sys_fstat+0x40>
  return filestat(f, st);
80104dcb:	83 ec 08             	sub    $0x8,%esp
80104dce:	ff 75 f4             	pushl  -0xc(%ebp)
80104dd1:	ff 75 f0             	pushl  -0x10(%ebp)
80104dd4:	e8 c7 c1 ff ff       	call   80100fa0 <filestat>
80104dd9:	83 c4 10             	add    $0x10,%esp
}
80104ddc:	c9                   	leave  
80104ddd:	c3                   	ret    
80104dde:	66 90                	xchg   %ax,%ax
80104de0:	c9                   	leave  
    return -1;
80104de1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104de6:	c3                   	ret    
80104de7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104dee:	66 90                	xchg   %ax,%ax

80104df0 <sys_link>:
{
80104df0:	55                   	push   %ebp
80104df1:	89 e5                	mov    %esp,%ebp
80104df3:	57                   	push   %edi
80104df4:	56                   	push   %esi
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80104df5:	8d 45 d4             	lea    -0x2c(%ebp),%eax
{
80104df8:	53                   	push   %ebx
80104df9:	83 ec 34             	sub    $0x34,%esp
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80104dfc:	50                   	push   %eax
80104dfd:	6a 00                	push   $0x0
80104dff:	e8 7c fb ff ff       	call   80104980 <argstr>
80104e04:	83 c4 10             	add    $0x10,%esp
80104e07:	85 c0                	test   %eax,%eax
80104e09:	0f 88 fb 00 00 00    	js     80104f0a <sys_link+0x11a>
80104e0f:	83 ec 08             	sub    $0x8,%esp
80104e12:	8d 45 d0             	lea    -0x30(%ebp),%eax
80104e15:	50                   	push   %eax
80104e16:	6a 01                	push   $0x1
80104e18:	e8 63 fb ff ff       	call   80104980 <argstr>
80104e1d:	83 c4 10             	add    $0x10,%esp
80104e20:	85 c0                	test   %eax,%eax
80104e22:	0f 88 e2 00 00 00    	js     80104f0a <sys_link+0x11a>
  begin_op();
80104e28:	e8 f3 de ff ff       	call   80102d20 <begin_op>
  if((ip = namei(old)) == 0){
80104e2d:	83 ec 0c             	sub    $0xc,%esp
80104e30:	ff 75 d4             	pushl  -0x2c(%ebp)
80104e33:	e8 88 d1 ff ff       	call   80101fc0 <namei>
80104e38:	83 c4 10             	add    $0x10,%esp
80104e3b:	89 c3                	mov    %eax,%ebx
80104e3d:	85 c0                	test   %eax,%eax
80104e3f:	0f 84 e4 00 00 00    	je     80104f29 <sys_link+0x139>
  ilock(ip);
80104e45:	83 ec 0c             	sub    $0xc,%esp
80104e48:	50                   	push   %eax
80104e49:	e8 d2 c8 ff ff       	call   80101720 <ilock>
  if(ip->type == T_DIR){
80104e4e:	83 c4 10             	add    $0x10,%esp
80104e51:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80104e56:	0f 84 b5 00 00 00    	je     80104f11 <sys_link+0x121>
  iupdate(ip);
80104e5c:	83 ec 0c             	sub    $0xc,%esp
  ip->nlink++;
80104e5f:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  if((dp = nameiparent(new, name)) == 0)
80104e64:	8d 7d da             	lea    -0x26(%ebp),%edi
  iupdate(ip);
80104e67:	53                   	push   %ebx
80104e68:	e8 03 c8 ff ff       	call   80101670 <iupdate>
  iunlock(ip);
80104e6d:	89 1c 24             	mov    %ebx,(%esp)
80104e70:	e8 8b c9 ff ff       	call   80101800 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
80104e75:	58                   	pop    %eax
80104e76:	5a                   	pop    %edx
80104e77:	57                   	push   %edi
80104e78:	ff 75 d0             	pushl  -0x30(%ebp)
80104e7b:	e8 60 d1 ff ff       	call   80101fe0 <nameiparent>
80104e80:	83 c4 10             	add    $0x10,%esp
80104e83:	89 c6                	mov    %eax,%esi
80104e85:	85 c0                	test   %eax,%eax
80104e87:	74 5b                	je     80104ee4 <sys_link+0xf4>
  ilock(dp);
80104e89:	83 ec 0c             	sub    $0xc,%esp
80104e8c:	50                   	push   %eax
80104e8d:	e8 8e c8 ff ff       	call   80101720 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80104e92:	83 c4 10             	add    $0x10,%esp
80104e95:	8b 03                	mov    (%ebx),%eax
80104e97:	39 06                	cmp    %eax,(%esi)
80104e99:	75 3d                	jne    80104ed8 <sys_link+0xe8>
80104e9b:	83 ec 04             	sub    $0x4,%esp
80104e9e:	ff 73 04             	pushl  0x4(%ebx)
80104ea1:	57                   	push   %edi
80104ea2:	56                   	push   %esi
80104ea3:	e8 58 d0 ff ff       	call   80101f00 <dirlink>
80104ea8:	83 c4 10             	add    $0x10,%esp
80104eab:	85 c0                	test   %eax,%eax
80104ead:	78 29                	js     80104ed8 <sys_link+0xe8>
  iunlockput(dp);
80104eaf:	83 ec 0c             	sub    $0xc,%esp
80104eb2:	56                   	push   %esi
80104eb3:	e8 f8 ca ff ff       	call   801019b0 <iunlockput>
  iput(ip);
80104eb8:	89 1c 24             	mov    %ebx,(%esp)
80104ebb:	e8 90 c9 ff ff       	call   80101850 <iput>
  end_op();
80104ec0:	e8 cb de ff ff       	call   80102d90 <end_op>
  return 0;
80104ec5:	83 c4 10             	add    $0x10,%esp
80104ec8:	31 c0                	xor    %eax,%eax
}
80104eca:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104ecd:	5b                   	pop    %ebx
80104ece:	5e                   	pop    %esi
80104ecf:	5f                   	pop    %edi
80104ed0:	5d                   	pop    %ebp
80104ed1:	c3                   	ret    
80104ed2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(dp);
80104ed8:	83 ec 0c             	sub    $0xc,%esp
80104edb:	56                   	push   %esi
80104edc:	e8 cf ca ff ff       	call   801019b0 <iunlockput>
    goto bad;
80104ee1:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
80104ee4:	83 ec 0c             	sub    $0xc,%esp
80104ee7:	53                   	push   %ebx
80104ee8:	e8 33 c8 ff ff       	call   80101720 <ilock>
  ip->nlink--;
80104eed:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80104ef2:	89 1c 24             	mov    %ebx,(%esp)
80104ef5:	e8 76 c7 ff ff       	call   80101670 <iupdate>
  iunlockput(ip);
80104efa:	89 1c 24             	mov    %ebx,(%esp)
80104efd:	e8 ae ca ff ff       	call   801019b0 <iunlockput>
  end_op();
80104f02:	e8 89 de ff ff       	call   80102d90 <end_op>
  return -1;
80104f07:	83 c4 10             	add    $0x10,%esp
80104f0a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104f0f:	eb b9                	jmp    80104eca <sys_link+0xda>
    iunlockput(ip);
80104f11:	83 ec 0c             	sub    $0xc,%esp
80104f14:	53                   	push   %ebx
80104f15:	e8 96 ca ff ff       	call   801019b0 <iunlockput>
    end_op();
80104f1a:	e8 71 de ff ff       	call   80102d90 <end_op>
    return -1;
80104f1f:	83 c4 10             	add    $0x10,%esp
80104f22:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104f27:	eb a1                	jmp    80104eca <sys_link+0xda>
    end_op();
80104f29:	e8 62 de ff ff       	call   80102d90 <end_op>
    return -1;
80104f2e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104f33:	eb 95                	jmp    80104eca <sys_link+0xda>
80104f35:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104f3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104f40 <sys_unlink>:
{
80104f40:	55                   	push   %ebp
80104f41:	89 e5                	mov    %esp,%ebp
80104f43:	57                   	push   %edi
80104f44:	56                   	push   %esi
  if(argstr(0, &path) < 0)
80104f45:	8d 45 c0             	lea    -0x40(%ebp),%eax
{
80104f48:	53                   	push   %ebx
80104f49:	83 ec 54             	sub    $0x54,%esp
  if(argstr(0, &path) < 0)
80104f4c:	50                   	push   %eax
80104f4d:	6a 00                	push   $0x0
80104f4f:	e8 2c fa ff ff       	call   80104980 <argstr>
80104f54:	83 c4 10             	add    $0x10,%esp
80104f57:	85 c0                	test   %eax,%eax
80104f59:	0f 88 91 01 00 00    	js     801050f0 <sys_unlink+0x1b0>
  begin_op();
80104f5f:	e8 bc dd ff ff       	call   80102d20 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80104f64:	8d 5d ca             	lea    -0x36(%ebp),%ebx
80104f67:	83 ec 08             	sub    $0x8,%esp
80104f6a:	53                   	push   %ebx
80104f6b:	ff 75 c0             	pushl  -0x40(%ebp)
80104f6e:	e8 6d d0 ff ff       	call   80101fe0 <nameiparent>
80104f73:	83 c4 10             	add    $0x10,%esp
80104f76:	89 c6                	mov    %eax,%esi
80104f78:	85 c0                	test   %eax,%eax
80104f7a:	0f 84 7a 01 00 00    	je     801050fa <sys_unlink+0x1ba>
  ilock(dp);
80104f80:	83 ec 0c             	sub    $0xc,%esp
80104f83:	50                   	push   %eax
80104f84:	e8 97 c7 ff ff       	call   80101720 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
80104f89:	58                   	pop    %eax
80104f8a:	5a                   	pop    %edx
80104f8b:	68 58 77 10 80       	push   $0x80107758
80104f90:	53                   	push   %ebx
80104f91:	e8 9a cc ff ff       	call   80101c30 <namecmp>
80104f96:	83 c4 10             	add    $0x10,%esp
80104f99:	85 c0                	test   %eax,%eax
80104f9b:	0f 84 0f 01 00 00    	je     801050b0 <sys_unlink+0x170>
80104fa1:	83 ec 08             	sub    $0x8,%esp
80104fa4:	68 57 77 10 80       	push   $0x80107757
80104fa9:	53                   	push   %ebx
80104faa:	e8 81 cc ff ff       	call   80101c30 <namecmp>
80104faf:	83 c4 10             	add    $0x10,%esp
80104fb2:	85 c0                	test   %eax,%eax
80104fb4:	0f 84 f6 00 00 00    	je     801050b0 <sys_unlink+0x170>
  if((ip = dirlookup(dp, name, &off)) == 0)
80104fba:	83 ec 04             	sub    $0x4,%esp
80104fbd:	8d 45 c4             	lea    -0x3c(%ebp),%eax
80104fc0:	50                   	push   %eax
80104fc1:	53                   	push   %ebx
80104fc2:	56                   	push   %esi
80104fc3:	e8 88 cc ff ff       	call   80101c50 <dirlookup>
80104fc8:	83 c4 10             	add    $0x10,%esp
80104fcb:	89 c3                	mov    %eax,%ebx
80104fcd:	85 c0                	test   %eax,%eax
80104fcf:	0f 84 db 00 00 00    	je     801050b0 <sys_unlink+0x170>
  ilock(ip);
80104fd5:	83 ec 0c             	sub    $0xc,%esp
80104fd8:	50                   	push   %eax
80104fd9:	e8 42 c7 ff ff       	call   80101720 <ilock>
  if(ip->nlink < 1)
80104fde:	83 c4 10             	add    $0x10,%esp
80104fe1:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
80104fe6:	0f 8e 37 01 00 00    	jle    80105123 <sys_unlink+0x1e3>
  if(ip->type == T_DIR && !isdirempty(ip)){
80104fec:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80104ff1:	8d 7d d8             	lea    -0x28(%ebp),%edi
80104ff4:	74 6a                	je     80105060 <sys_unlink+0x120>
  memset(&de, 0, sizeof(de));
80104ff6:	83 ec 04             	sub    $0x4,%esp
80104ff9:	6a 10                	push   $0x10
80104ffb:	6a 00                	push   $0x0
80104ffd:	57                   	push   %edi
80104ffe:	e8 ed f5 ff ff       	call   801045f0 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105003:	6a 10                	push   $0x10
80105005:	ff 75 c4             	pushl  -0x3c(%ebp)
80105008:	57                   	push   %edi
80105009:	56                   	push   %esi
8010500a:	e8 f1 ca ff ff       	call   80101b00 <writei>
8010500f:	83 c4 20             	add    $0x20,%esp
80105012:	83 f8 10             	cmp    $0x10,%eax
80105015:	0f 85 fb 00 00 00    	jne    80105116 <sys_unlink+0x1d6>
  if(ip->type == T_DIR){
8010501b:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105020:	0f 84 aa 00 00 00    	je     801050d0 <sys_unlink+0x190>
  iunlockput(dp);
80105026:	83 ec 0c             	sub    $0xc,%esp
80105029:	56                   	push   %esi
8010502a:	e8 81 c9 ff ff       	call   801019b0 <iunlockput>
  ip->nlink--;
8010502f:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80105034:	89 1c 24             	mov    %ebx,(%esp)
80105037:	e8 34 c6 ff ff       	call   80101670 <iupdate>
  iunlockput(ip);
8010503c:	89 1c 24             	mov    %ebx,(%esp)
8010503f:	e8 6c c9 ff ff       	call   801019b0 <iunlockput>
  end_op();
80105044:	e8 47 dd ff ff       	call   80102d90 <end_op>
  return 0;
80105049:	83 c4 10             	add    $0x10,%esp
8010504c:	31 c0                	xor    %eax,%eax
}
8010504e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105051:	5b                   	pop    %ebx
80105052:	5e                   	pop    %esi
80105053:	5f                   	pop    %edi
80105054:	5d                   	pop    %ebp
80105055:	c3                   	ret    
80105056:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010505d:	8d 76 00             	lea    0x0(%esi),%esi
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80105060:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
80105064:	76 90                	jbe    80104ff6 <sys_unlink+0xb6>
80105066:	ba 20 00 00 00       	mov    $0x20,%edx
8010506b:	eb 0f                	jmp    8010507c <sys_unlink+0x13c>
8010506d:	8d 76 00             	lea    0x0(%esi),%esi
80105070:	83 c2 10             	add    $0x10,%edx
80105073:	39 53 58             	cmp    %edx,0x58(%ebx)
80105076:	0f 86 7a ff ff ff    	jbe    80104ff6 <sys_unlink+0xb6>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
8010507c:	6a 10                	push   $0x10
8010507e:	52                   	push   %edx
8010507f:	57                   	push   %edi
80105080:	53                   	push   %ebx
80105081:	89 55 b4             	mov    %edx,-0x4c(%ebp)
80105084:	e8 77 c9 ff ff       	call   80101a00 <readi>
80105089:	83 c4 10             	add    $0x10,%esp
8010508c:	8b 55 b4             	mov    -0x4c(%ebp),%edx
8010508f:	83 f8 10             	cmp    $0x10,%eax
80105092:	75 75                	jne    80105109 <sys_unlink+0x1c9>
    if(de.inum != 0)
80105094:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80105099:	74 d5                	je     80105070 <sys_unlink+0x130>
    iunlockput(ip);
8010509b:	83 ec 0c             	sub    $0xc,%esp
8010509e:	53                   	push   %ebx
8010509f:	e8 0c c9 ff ff       	call   801019b0 <iunlockput>
    goto bad;
801050a4:	83 c4 10             	add    $0x10,%esp
801050a7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801050ae:	66 90                	xchg   %ax,%ax
  iunlockput(dp);
801050b0:	83 ec 0c             	sub    $0xc,%esp
801050b3:	56                   	push   %esi
801050b4:	e8 f7 c8 ff ff       	call   801019b0 <iunlockput>
  end_op();
801050b9:	e8 d2 dc ff ff       	call   80102d90 <end_op>
  return -1;
801050be:	83 c4 10             	add    $0x10,%esp
801050c1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801050c6:	eb 86                	jmp    8010504e <sys_unlink+0x10e>
801050c8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801050cf:	90                   	nop
    iupdate(dp);
801050d0:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink--;
801050d3:	66 83 6e 56 01       	subw   $0x1,0x56(%esi)
    iupdate(dp);
801050d8:	56                   	push   %esi
801050d9:	e8 92 c5 ff ff       	call   80101670 <iupdate>
801050de:	83 c4 10             	add    $0x10,%esp
801050e1:	e9 40 ff ff ff       	jmp    80105026 <sys_unlink+0xe6>
801050e6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801050ed:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
801050f0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801050f5:	e9 54 ff ff ff       	jmp    8010504e <sys_unlink+0x10e>
    end_op();
801050fa:	e8 91 dc ff ff       	call   80102d90 <end_op>
    return -1;
801050ff:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105104:	e9 45 ff ff ff       	jmp    8010504e <sys_unlink+0x10e>
      panic("isdirempty: readi");
80105109:	83 ec 0c             	sub    $0xc,%esp
8010510c:	68 7c 77 10 80       	push   $0x8010777c
80105111:	e8 7a b2 ff ff       	call   80100390 <panic>
    panic("unlink: writei");
80105116:	83 ec 0c             	sub    $0xc,%esp
80105119:	68 8e 77 10 80       	push   $0x8010778e
8010511e:	e8 6d b2 ff ff       	call   80100390 <panic>
    panic("unlink: nlink < 1");
80105123:	83 ec 0c             	sub    $0xc,%esp
80105126:	68 6a 77 10 80       	push   $0x8010776a
8010512b:	e8 60 b2 ff ff       	call   80100390 <panic>

80105130 <sys_open>:

int
sys_open(void)
{
80105130:	55                   	push   %ebp
80105131:	89 e5                	mov    %esp,%ebp
80105133:	57                   	push   %edi
80105134:	56                   	push   %esi
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105135:	8d 45 e0             	lea    -0x20(%ebp),%eax
{
80105138:	53                   	push   %ebx
80105139:	83 ec 24             	sub    $0x24,%esp
  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
8010513c:	50                   	push   %eax
8010513d:	6a 00                	push   $0x0
8010513f:	e8 3c f8 ff ff       	call   80104980 <argstr>
80105144:	83 c4 10             	add    $0x10,%esp
80105147:	85 c0                	test   %eax,%eax
80105149:	0f 88 8e 00 00 00    	js     801051dd <sys_open+0xad>
8010514f:	83 ec 08             	sub    $0x8,%esp
80105152:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105155:	50                   	push   %eax
80105156:	6a 01                	push   $0x1
80105158:	e8 73 f7 ff ff       	call   801048d0 <argint>
8010515d:	83 c4 10             	add    $0x10,%esp
80105160:	85 c0                	test   %eax,%eax
80105162:	78 79                	js     801051dd <sys_open+0xad>
    return -1;

  begin_op();
80105164:	e8 b7 db ff ff       	call   80102d20 <begin_op>

  if(omode & O_CREATE){
80105169:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
8010516d:	75 79                	jne    801051e8 <sys_open+0xb8>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
8010516f:	83 ec 0c             	sub    $0xc,%esp
80105172:	ff 75 e0             	pushl  -0x20(%ebp)
80105175:	e8 46 ce ff ff       	call   80101fc0 <namei>
8010517a:	83 c4 10             	add    $0x10,%esp
8010517d:	89 c6                	mov    %eax,%esi
8010517f:	85 c0                	test   %eax,%eax
80105181:	0f 84 7e 00 00 00    	je     80105205 <sys_open+0xd5>
      end_op();
      return -1;
    }
    ilock(ip);
80105187:	83 ec 0c             	sub    $0xc,%esp
8010518a:	50                   	push   %eax
8010518b:	e8 90 c5 ff ff       	call   80101720 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
80105190:	83 c4 10             	add    $0x10,%esp
80105193:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80105198:	0f 84 c2 00 00 00    	je     80105260 <sys_open+0x130>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
8010519e:	e8 5d bc ff ff       	call   80100e00 <filealloc>
801051a3:	89 c7                	mov    %eax,%edi
801051a5:	85 c0                	test   %eax,%eax
801051a7:	74 23                	je     801051cc <sys_open+0x9c>
  struct proc *curproc = myproc();
801051a9:	e8 b2 e7 ff ff       	call   80103960 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
801051ae:	31 db                	xor    %ebx,%ebx
    if(curproc->ofile[fd] == 0){
801051b0:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
801051b4:	85 d2                	test   %edx,%edx
801051b6:	74 60                	je     80105218 <sys_open+0xe8>
  for(fd = 0; fd < NOFILE; fd++){
801051b8:	83 c3 01             	add    $0x1,%ebx
801051bb:	83 fb 10             	cmp    $0x10,%ebx
801051be:	75 f0                	jne    801051b0 <sys_open+0x80>
    if(f)
      fileclose(f);
801051c0:	83 ec 0c             	sub    $0xc,%esp
801051c3:	57                   	push   %edi
801051c4:	e8 f7 bc ff ff       	call   80100ec0 <fileclose>
801051c9:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
801051cc:	83 ec 0c             	sub    $0xc,%esp
801051cf:	56                   	push   %esi
801051d0:	e8 db c7 ff ff       	call   801019b0 <iunlockput>
    end_op();
801051d5:	e8 b6 db ff ff       	call   80102d90 <end_op>
    return -1;
801051da:	83 c4 10             	add    $0x10,%esp
801051dd:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801051e2:	eb 6d                	jmp    80105251 <sys_open+0x121>
801051e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    ip = create(path, T_FILE, 0, 0);
801051e8:	83 ec 0c             	sub    $0xc,%esp
801051eb:	8b 45 e0             	mov    -0x20(%ebp),%eax
801051ee:	31 c9                	xor    %ecx,%ecx
801051f0:	ba 02 00 00 00       	mov    $0x2,%edx
801051f5:	6a 00                	push   $0x0
801051f7:	e8 24 f8 ff ff       	call   80104a20 <create>
    if(ip == 0){
801051fc:	83 c4 10             	add    $0x10,%esp
    ip = create(path, T_FILE, 0, 0);
801051ff:	89 c6                	mov    %eax,%esi
    if(ip == 0){
80105201:	85 c0                	test   %eax,%eax
80105203:	75 99                	jne    8010519e <sys_open+0x6e>
      end_op();
80105205:	e8 86 db ff ff       	call   80102d90 <end_op>
      return -1;
8010520a:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
8010520f:	eb 40                	jmp    80105251 <sys_open+0x121>
80105211:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  }
  iunlock(ip);
80105218:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
8010521b:	89 7c 98 28          	mov    %edi,0x28(%eax,%ebx,4)
  iunlock(ip);
8010521f:	56                   	push   %esi
80105220:	e8 db c5 ff ff       	call   80101800 <iunlock>
  end_op();
80105225:	e8 66 db ff ff       	call   80102d90 <end_op>

  f->type = FD_INODE;
8010522a:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
80105230:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105233:	83 c4 10             	add    $0x10,%esp
  f->ip = ip;
80105236:	89 77 10             	mov    %esi,0x10(%edi)
  f->readable = !(omode & O_WRONLY);
80105239:	89 d0                	mov    %edx,%eax
  f->off = 0;
8010523b:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(omode & O_WRONLY);
80105242:	f7 d0                	not    %eax
80105244:	83 e0 01             	and    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105247:	83 e2 03             	and    $0x3,%edx
  f->readable = !(omode & O_WRONLY);
8010524a:	88 47 08             	mov    %al,0x8(%edi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
8010524d:	0f 95 47 09          	setne  0x9(%edi)
  return fd;
}
80105251:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105254:	89 d8                	mov    %ebx,%eax
80105256:	5b                   	pop    %ebx
80105257:	5e                   	pop    %esi
80105258:	5f                   	pop    %edi
80105259:	5d                   	pop    %ebp
8010525a:	c3                   	ret    
8010525b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010525f:	90                   	nop
    if(ip->type == T_DIR && omode != O_RDONLY){
80105260:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80105263:	85 c9                	test   %ecx,%ecx
80105265:	0f 84 33 ff ff ff    	je     8010519e <sys_open+0x6e>
8010526b:	e9 5c ff ff ff       	jmp    801051cc <sys_open+0x9c>

80105270 <sys_mkdir>:

int
sys_mkdir(void)
{
80105270:	55                   	push   %ebp
80105271:	89 e5                	mov    %esp,%ebp
80105273:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
80105276:	e8 a5 da ff ff       	call   80102d20 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
8010527b:	83 ec 08             	sub    $0x8,%esp
8010527e:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105281:	50                   	push   %eax
80105282:	6a 00                	push   $0x0
80105284:	e8 f7 f6 ff ff       	call   80104980 <argstr>
80105289:	83 c4 10             	add    $0x10,%esp
8010528c:	85 c0                	test   %eax,%eax
8010528e:	78 30                	js     801052c0 <sys_mkdir+0x50>
80105290:	83 ec 0c             	sub    $0xc,%esp
80105293:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105296:	31 c9                	xor    %ecx,%ecx
80105298:	ba 01 00 00 00       	mov    $0x1,%edx
8010529d:	6a 00                	push   $0x0
8010529f:	e8 7c f7 ff ff       	call   80104a20 <create>
801052a4:	83 c4 10             	add    $0x10,%esp
801052a7:	85 c0                	test   %eax,%eax
801052a9:	74 15                	je     801052c0 <sys_mkdir+0x50>
    end_op();
    return -1;
  }
  iunlockput(ip);
801052ab:	83 ec 0c             	sub    $0xc,%esp
801052ae:	50                   	push   %eax
801052af:	e8 fc c6 ff ff       	call   801019b0 <iunlockput>
  end_op();
801052b4:	e8 d7 da ff ff       	call   80102d90 <end_op>
  return 0;
801052b9:	83 c4 10             	add    $0x10,%esp
801052bc:	31 c0                	xor    %eax,%eax
}
801052be:	c9                   	leave  
801052bf:	c3                   	ret    
    end_op();
801052c0:	e8 cb da ff ff       	call   80102d90 <end_op>
    return -1;
801052c5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801052ca:	c9                   	leave  
801052cb:	c3                   	ret    
801052cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801052d0 <sys_mknod>:

int
sys_mknod(void)
{
801052d0:	55                   	push   %ebp
801052d1:	89 e5                	mov    %esp,%ebp
801052d3:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
801052d6:	e8 45 da ff ff       	call   80102d20 <begin_op>
  if((argstr(0, &path)) < 0 ||
801052db:	83 ec 08             	sub    $0x8,%esp
801052de:	8d 45 ec             	lea    -0x14(%ebp),%eax
801052e1:	50                   	push   %eax
801052e2:	6a 00                	push   $0x0
801052e4:	e8 97 f6 ff ff       	call   80104980 <argstr>
801052e9:	83 c4 10             	add    $0x10,%esp
801052ec:	85 c0                	test   %eax,%eax
801052ee:	78 60                	js     80105350 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
801052f0:	83 ec 08             	sub    $0x8,%esp
801052f3:	8d 45 f0             	lea    -0x10(%ebp),%eax
801052f6:	50                   	push   %eax
801052f7:	6a 01                	push   $0x1
801052f9:	e8 d2 f5 ff ff       	call   801048d0 <argint>
  if((argstr(0, &path)) < 0 ||
801052fe:	83 c4 10             	add    $0x10,%esp
80105301:	85 c0                	test   %eax,%eax
80105303:	78 4b                	js     80105350 <sys_mknod+0x80>
     argint(2, &minor) < 0 ||
80105305:	83 ec 08             	sub    $0x8,%esp
80105308:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010530b:	50                   	push   %eax
8010530c:	6a 02                	push   $0x2
8010530e:	e8 bd f5 ff ff       	call   801048d0 <argint>
     argint(1, &major) < 0 ||
80105313:	83 c4 10             	add    $0x10,%esp
80105316:	85 c0                	test   %eax,%eax
80105318:	78 36                	js     80105350 <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
8010531a:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
8010531e:	83 ec 0c             	sub    $0xc,%esp
80105321:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
80105325:	ba 03 00 00 00       	mov    $0x3,%edx
8010532a:	50                   	push   %eax
8010532b:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010532e:	e8 ed f6 ff ff       	call   80104a20 <create>
     argint(2, &minor) < 0 ||
80105333:	83 c4 10             	add    $0x10,%esp
80105336:	85 c0                	test   %eax,%eax
80105338:	74 16                	je     80105350 <sys_mknod+0x80>
    end_op();
    return -1;
  }
  iunlockput(ip);
8010533a:	83 ec 0c             	sub    $0xc,%esp
8010533d:	50                   	push   %eax
8010533e:	e8 6d c6 ff ff       	call   801019b0 <iunlockput>
  end_op();
80105343:	e8 48 da ff ff       	call   80102d90 <end_op>
  return 0;
80105348:	83 c4 10             	add    $0x10,%esp
8010534b:	31 c0                	xor    %eax,%eax
}
8010534d:	c9                   	leave  
8010534e:	c3                   	ret    
8010534f:	90                   	nop
    end_op();
80105350:	e8 3b da ff ff       	call   80102d90 <end_op>
    return -1;
80105355:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010535a:	c9                   	leave  
8010535b:	c3                   	ret    
8010535c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105360 <sys_chdir>:

int
sys_chdir(void)
{
80105360:	55                   	push   %ebp
80105361:	89 e5                	mov    %esp,%ebp
80105363:	56                   	push   %esi
80105364:	53                   	push   %ebx
80105365:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
80105368:	e8 f3 e5 ff ff       	call   80103960 <myproc>
8010536d:	89 c6                	mov    %eax,%esi
  
  begin_op();
8010536f:	e8 ac d9 ff ff       	call   80102d20 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
80105374:	83 ec 08             	sub    $0x8,%esp
80105377:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010537a:	50                   	push   %eax
8010537b:	6a 00                	push   $0x0
8010537d:	e8 fe f5 ff ff       	call   80104980 <argstr>
80105382:	83 c4 10             	add    $0x10,%esp
80105385:	85 c0                	test   %eax,%eax
80105387:	78 77                	js     80105400 <sys_chdir+0xa0>
80105389:	83 ec 0c             	sub    $0xc,%esp
8010538c:	ff 75 f4             	pushl  -0xc(%ebp)
8010538f:	e8 2c cc ff ff       	call   80101fc0 <namei>
80105394:	83 c4 10             	add    $0x10,%esp
80105397:	89 c3                	mov    %eax,%ebx
80105399:	85 c0                	test   %eax,%eax
8010539b:	74 63                	je     80105400 <sys_chdir+0xa0>
    end_op();
    return -1;
  }
  ilock(ip);
8010539d:	83 ec 0c             	sub    $0xc,%esp
801053a0:	50                   	push   %eax
801053a1:	e8 7a c3 ff ff       	call   80101720 <ilock>
  if(ip->type != T_DIR){
801053a6:	83 c4 10             	add    $0x10,%esp
801053a9:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801053ae:	75 30                	jne    801053e0 <sys_chdir+0x80>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
801053b0:	83 ec 0c             	sub    $0xc,%esp
801053b3:	53                   	push   %ebx
801053b4:	e8 47 c4 ff ff       	call   80101800 <iunlock>
  iput(curproc->cwd);
801053b9:	58                   	pop    %eax
801053ba:	ff 76 68             	pushl  0x68(%esi)
801053bd:	e8 8e c4 ff ff       	call   80101850 <iput>
  end_op();
801053c2:	e8 c9 d9 ff ff       	call   80102d90 <end_op>
  curproc->cwd = ip;
801053c7:	89 5e 68             	mov    %ebx,0x68(%esi)
  return 0;
801053ca:	83 c4 10             	add    $0x10,%esp
801053cd:	31 c0                	xor    %eax,%eax
}
801053cf:	8d 65 f8             	lea    -0x8(%ebp),%esp
801053d2:	5b                   	pop    %ebx
801053d3:	5e                   	pop    %esi
801053d4:	5d                   	pop    %ebp
801053d5:	c3                   	ret    
801053d6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801053dd:	8d 76 00             	lea    0x0(%esi),%esi
    iunlockput(ip);
801053e0:	83 ec 0c             	sub    $0xc,%esp
801053e3:	53                   	push   %ebx
801053e4:	e8 c7 c5 ff ff       	call   801019b0 <iunlockput>
    end_op();
801053e9:	e8 a2 d9 ff ff       	call   80102d90 <end_op>
    return -1;
801053ee:	83 c4 10             	add    $0x10,%esp
801053f1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801053f6:	eb d7                	jmp    801053cf <sys_chdir+0x6f>
801053f8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801053ff:	90                   	nop
    end_op();
80105400:	e8 8b d9 ff ff       	call   80102d90 <end_op>
    return -1;
80105405:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010540a:	eb c3                	jmp    801053cf <sys_chdir+0x6f>
8010540c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105410 <sys_exec>:

int
sys_exec(void)
{
80105410:	55                   	push   %ebp
80105411:	89 e5                	mov    %esp,%ebp
80105413:	57                   	push   %edi
80105414:	56                   	push   %esi
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105415:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
{
8010541b:	53                   	push   %ebx
8010541c:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105422:	50                   	push   %eax
80105423:	6a 00                	push   $0x0
80105425:	e8 56 f5 ff ff       	call   80104980 <argstr>
8010542a:	83 c4 10             	add    $0x10,%esp
8010542d:	85 c0                	test   %eax,%eax
8010542f:	0f 88 87 00 00 00    	js     801054bc <sys_exec+0xac>
80105435:	83 ec 08             	sub    $0x8,%esp
80105438:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
8010543e:	50                   	push   %eax
8010543f:	6a 01                	push   $0x1
80105441:	e8 8a f4 ff ff       	call   801048d0 <argint>
80105446:	83 c4 10             	add    $0x10,%esp
80105449:	85 c0                	test   %eax,%eax
8010544b:	78 6f                	js     801054bc <sys_exec+0xac>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
8010544d:	83 ec 04             	sub    $0x4,%esp
80105450:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
  for(i=0;; i++){
80105456:	31 db                	xor    %ebx,%ebx
  memset(argv, 0, sizeof(argv));
80105458:	68 80 00 00 00       	push   $0x80
8010545d:	8d bd 64 ff ff ff    	lea    -0x9c(%ebp),%edi
80105463:	6a 00                	push   $0x0
80105465:	50                   	push   %eax
80105466:	e8 85 f1 ff ff       	call   801045f0 <memset>
8010546b:	83 c4 10             	add    $0x10,%esp
8010546e:	66 90                	xchg   %ax,%ax
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
80105470:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
80105476:	8d 34 9d 00 00 00 00 	lea    0x0(,%ebx,4),%esi
8010547d:	83 ec 08             	sub    $0x8,%esp
80105480:	57                   	push   %edi
80105481:	01 f0                	add    %esi,%eax
80105483:	50                   	push   %eax
80105484:	e8 a7 f3 ff ff       	call   80104830 <fetchint>
80105489:	83 c4 10             	add    $0x10,%esp
8010548c:	85 c0                	test   %eax,%eax
8010548e:	78 2c                	js     801054bc <sys_exec+0xac>
      return -1;
    if(uarg == 0){
80105490:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
80105496:	85 c0                	test   %eax,%eax
80105498:	74 36                	je     801054d0 <sys_exec+0xc0>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
8010549a:	8d 8d 68 ff ff ff    	lea    -0x98(%ebp),%ecx
801054a0:	83 ec 08             	sub    $0x8,%esp
801054a3:	8d 14 31             	lea    (%ecx,%esi,1),%edx
801054a6:	52                   	push   %edx
801054a7:	50                   	push   %eax
801054a8:	e8 c3 f3 ff ff       	call   80104870 <fetchstr>
801054ad:	83 c4 10             	add    $0x10,%esp
801054b0:	85 c0                	test   %eax,%eax
801054b2:	78 08                	js     801054bc <sys_exec+0xac>
  for(i=0;; i++){
801054b4:	83 c3 01             	add    $0x1,%ebx
    if(i >= NELEM(argv))
801054b7:	83 fb 20             	cmp    $0x20,%ebx
801054ba:	75 b4                	jne    80105470 <sys_exec+0x60>
      return -1;
  }
  return exec(path, argv);
}
801054bc:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
801054bf:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801054c4:	5b                   	pop    %ebx
801054c5:	5e                   	pop    %esi
801054c6:	5f                   	pop    %edi
801054c7:	5d                   	pop    %ebp
801054c8:	c3                   	ret    
801054c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return exec(path, argv);
801054d0:	83 ec 08             	sub    $0x8,%esp
801054d3:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
      argv[i] = 0;
801054d9:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
801054e0:	00 00 00 00 
  return exec(path, argv);
801054e4:	50                   	push   %eax
801054e5:	ff b5 5c ff ff ff    	pushl  -0xa4(%ebp)
801054eb:	e8 90 b5 ff ff       	call   80100a80 <exec>
801054f0:	83 c4 10             	add    $0x10,%esp
}
801054f3:	8d 65 f4             	lea    -0xc(%ebp),%esp
801054f6:	5b                   	pop    %ebx
801054f7:	5e                   	pop    %esi
801054f8:	5f                   	pop    %edi
801054f9:	5d                   	pop    %ebp
801054fa:	c3                   	ret    
801054fb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801054ff:	90                   	nop

80105500 <sys_pipe>:

int
sys_pipe(void)
{
80105500:	55                   	push   %ebp
80105501:	89 e5                	mov    %esp,%ebp
80105503:	57                   	push   %edi
80105504:	56                   	push   %esi
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105505:	8d 45 dc             	lea    -0x24(%ebp),%eax
{
80105508:	53                   	push   %ebx
80105509:	83 ec 20             	sub    $0x20,%esp
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
8010550c:	6a 08                	push   $0x8
8010550e:	50                   	push   %eax
8010550f:	6a 00                	push   $0x0
80105511:	e8 0a f4 ff ff       	call   80104920 <argptr>
80105516:	83 c4 10             	add    $0x10,%esp
80105519:	85 c0                	test   %eax,%eax
8010551b:	78 4a                	js     80105567 <sys_pipe+0x67>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
8010551d:	83 ec 08             	sub    $0x8,%esp
80105520:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105523:	50                   	push   %eax
80105524:	8d 45 e0             	lea    -0x20(%ebp),%eax
80105527:	50                   	push   %eax
80105528:	e8 a3 de ff ff       	call   801033d0 <pipealloc>
8010552d:	83 c4 10             	add    $0x10,%esp
80105530:	85 c0                	test   %eax,%eax
80105532:	78 33                	js     80105567 <sys_pipe+0x67>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105534:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(fd = 0; fd < NOFILE; fd++){
80105537:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
80105539:	e8 22 e4 ff ff       	call   80103960 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
8010553e:	66 90                	xchg   %ax,%ax
    if(curproc->ofile[fd] == 0){
80105540:	8b 74 98 28          	mov    0x28(%eax,%ebx,4),%esi
80105544:	85 f6                	test   %esi,%esi
80105546:	74 28                	je     80105570 <sys_pipe+0x70>
  for(fd = 0; fd < NOFILE; fd++){
80105548:	83 c3 01             	add    $0x1,%ebx
8010554b:	83 fb 10             	cmp    $0x10,%ebx
8010554e:	75 f0                	jne    80105540 <sys_pipe+0x40>
    if(fd0 >= 0)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
80105550:	83 ec 0c             	sub    $0xc,%esp
80105553:	ff 75 e0             	pushl  -0x20(%ebp)
80105556:	e8 65 b9 ff ff       	call   80100ec0 <fileclose>
    fileclose(wf);
8010555b:	58                   	pop    %eax
8010555c:	ff 75 e4             	pushl  -0x1c(%ebp)
8010555f:	e8 5c b9 ff ff       	call   80100ec0 <fileclose>
    return -1;
80105564:	83 c4 10             	add    $0x10,%esp
80105567:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010556c:	eb 53                	jmp    801055c1 <sys_pipe+0xc1>
8010556e:	66 90                	xchg   %ax,%ax
      curproc->ofile[fd] = f;
80105570:	8d 73 08             	lea    0x8(%ebx),%esi
80105573:	89 7c b0 08          	mov    %edi,0x8(%eax,%esi,4)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105577:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  struct proc *curproc = myproc();
8010557a:	e8 e1 e3 ff ff       	call   80103960 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
8010557f:	31 d2                	xor    %edx,%edx
80105581:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd] == 0){
80105588:	8b 4c 90 28          	mov    0x28(%eax,%edx,4),%ecx
8010558c:	85 c9                	test   %ecx,%ecx
8010558e:	74 20                	je     801055b0 <sys_pipe+0xb0>
  for(fd = 0; fd < NOFILE; fd++){
80105590:	83 c2 01             	add    $0x1,%edx
80105593:	83 fa 10             	cmp    $0x10,%edx
80105596:	75 f0                	jne    80105588 <sys_pipe+0x88>
      myproc()->ofile[fd0] = 0;
80105598:	e8 c3 e3 ff ff       	call   80103960 <myproc>
8010559d:	c7 44 b0 08 00 00 00 	movl   $0x0,0x8(%eax,%esi,4)
801055a4:	00 
801055a5:	eb a9                	jmp    80105550 <sys_pipe+0x50>
801055a7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801055ae:	66 90                	xchg   %ax,%ax
      curproc->ofile[fd] = f;
801055b0:	89 7c 90 28          	mov    %edi,0x28(%eax,%edx,4)
  }
  fd[0] = fd0;
801055b4:	8b 45 dc             	mov    -0x24(%ebp),%eax
801055b7:	89 18                	mov    %ebx,(%eax)
  fd[1] = fd1;
801055b9:	8b 45 dc             	mov    -0x24(%ebp),%eax
801055bc:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
801055bf:	31 c0                	xor    %eax,%eax
}
801055c1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801055c4:	5b                   	pop    %ebx
801055c5:	5e                   	pop    %esi
801055c6:	5f                   	pop    %edi
801055c7:	5d                   	pop    %ebp
801055c8:	c3                   	ret    
801055c9:	66 90                	xchg   %ax,%ax
801055cb:	66 90                	xchg   %ax,%ax
801055cd:	66 90                	xchg   %ax,%ax
801055cf:	90                   	nop

801055d0 <sys_fork>:
#include "proc.h"

int
sys_fork(void)
{
  return fork();
801055d0:	e9 2b e5 ff ff       	jmp    80103b00 <fork>
801055d5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801055dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801055e0 <sys_exit>:
}

int
sys_exit(void)
{
801055e0:	55                   	push   %ebp
801055e1:	89 e5                	mov    %esp,%ebp
801055e3:	83 ec 08             	sub    $0x8,%esp
  exit();
801055e6:	e8 95 e7 ff ff       	call   80103d80 <exit>
  return 0;  // not reached
}
801055eb:	31 c0                	xor    %eax,%eax
801055ed:	c9                   	leave  
801055ee:	c3                   	ret    
801055ef:	90                   	nop

801055f0 <sys_wait>:

int
sys_wait(void)
{
  return wait();
801055f0:	e9 cb e9 ff ff       	jmp    80103fc0 <wait>
801055f5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801055fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105600 <sys_kill>:
}

int
sys_kill(void)
{
80105600:	55                   	push   %ebp
80105601:	89 e5                	mov    %esp,%ebp
80105603:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if(argint(0, &pid) < 0)
80105606:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105609:	50                   	push   %eax
8010560a:	6a 00                	push   $0x0
8010560c:	e8 bf f2 ff ff       	call   801048d0 <argint>
80105611:	83 c4 10             	add    $0x10,%esp
80105614:	85 c0                	test   %eax,%eax
80105616:	78 18                	js     80105630 <sys_kill+0x30>
    return -1;
  return kill(pid);
80105618:	83 ec 0c             	sub    $0xc,%esp
8010561b:	ff 75 f4             	pushl  -0xc(%ebp)
8010561e:	e8 ed ea ff ff       	call   80104110 <kill>
80105623:	83 c4 10             	add    $0x10,%esp
}
80105626:	c9                   	leave  
80105627:	c3                   	ret    
80105628:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010562f:	90                   	nop
80105630:	c9                   	leave  
    return -1;
80105631:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105636:	c3                   	ret    
80105637:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010563e:	66 90                	xchg   %ax,%ax

80105640 <sys_getpid>:

int
sys_getpid(void)
{
80105640:	55                   	push   %ebp
80105641:	89 e5                	mov    %esp,%ebp
80105643:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
80105646:	e8 15 e3 ff ff       	call   80103960 <myproc>
8010564b:	8b 40 10             	mov    0x10(%eax),%eax
}
8010564e:	c9                   	leave  
8010564f:	c3                   	ret    

80105650 <sys_freemem>:

int
sys_freemem(void)
{  
  return freemem();
80105650:	e9 db cf ff ff       	jmp    80102630 <freemem>
80105655:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010565c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105660 <sys_sbrk>:
}

int
sys_sbrk(void)
{
80105660:	55                   	push   %ebp
80105661:	89 e5                	mov    %esp,%ebp
80105663:	53                   	push   %ebx
  int addr;
  int n;

  if(argint(0, &n) < 0)
80105664:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105667:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
8010566a:	50                   	push   %eax
8010566b:	6a 00                	push   $0x0
8010566d:	e8 5e f2 ff ff       	call   801048d0 <argint>
80105672:	83 c4 10             	add    $0x10,%esp
80105675:	85 c0                	test   %eax,%eax
80105677:	78 27                	js     801056a0 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->sz;
80105679:	e8 e2 e2 ff ff       	call   80103960 <myproc>
  if(growproc(n) < 0)
8010567e:	83 ec 0c             	sub    $0xc,%esp
  addr = myproc()->sz;
80105681:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
80105683:	ff 75 f4             	pushl  -0xc(%ebp)
80105686:	e8 f5 e3 ff ff       	call   80103a80 <growproc>
8010568b:	83 c4 10             	add    $0x10,%esp
8010568e:	85 c0                	test   %eax,%eax
80105690:	78 0e                	js     801056a0 <sys_sbrk+0x40>
    return -1;
  return addr;
}
80105692:	89 d8                	mov    %ebx,%eax
80105694:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105697:	c9                   	leave  
80105698:	c3                   	ret    
80105699:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
801056a0:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801056a5:	eb eb                	jmp    80105692 <sys_sbrk+0x32>
801056a7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801056ae:	66 90                	xchg   %ax,%ax

801056b0 <sys_sleep>:

int
sys_sleep(void)
{
801056b0:	55                   	push   %ebp
801056b1:	89 e5                	mov    %esp,%ebp
801056b3:	53                   	push   %ebx
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
801056b4:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
801056b7:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
801056ba:	50                   	push   %eax
801056bb:	6a 00                	push   $0x0
801056bd:	e8 0e f2 ff ff       	call   801048d0 <argint>
801056c2:	83 c4 10             	add    $0x10,%esp
801056c5:	85 c0                	test   %eax,%eax
801056c7:	0f 88 8a 00 00 00    	js     80105757 <sys_sleep+0xa7>
    return -1;
  acquire(&tickslock);
801056cd:	83 ec 0c             	sub    $0xc,%esp
801056d0:	68 60 4c 11 80       	push   $0x80114c60
801056d5:	e8 06 ee ff ff       	call   801044e0 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
801056da:	8b 55 f4             	mov    -0xc(%ebp),%edx
  ticks0 = ticks;
801056dd:	8b 1d a0 54 11 80    	mov    0x801154a0,%ebx
  while(ticks - ticks0 < n){
801056e3:	83 c4 10             	add    $0x10,%esp
801056e6:	85 d2                	test   %edx,%edx
801056e8:	75 27                	jne    80105711 <sys_sleep+0x61>
801056ea:	eb 54                	jmp    80105740 <sys_sleep+0x90>
801056ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
801056f0:	83 ec 08             	sub    $0x8,%esp
801056f3:	68 60 4c 11 80       	push   $0x80114c60
801056f8:	68 a0 54 11 80       	push   $0x801154a0
801056fd:	e8 fe e7 ff ff       	call   80103f00 <sleep>
  while(ticks - ticks0 < n){
80105702:	a1 a0 54 11 80       	mov    0x801154a0,%eax
80105707:	83 c4 10             	add    $0x10,%esp
8010570a:	29 d8                	sub    %ebx,%eax
8010570c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
8010570f:	73 2f                	jae    80105740 <sys_sleep+0x90>
    if(myproc()->killed){
80105711:	e8 4a e2 ff ff       	call   80103960 <myproc>
80105716:	8b 40 24             	mov    0x24(%eax),%eax
80105719:	85 c0                	test   %eax,%eax
8010571b:	74 d3                	je     801056f0 <sys_sleep+0x40>
      release(&tickslock);
8010571d:	83 ec 0c             	sub    $0xc,%esp
80105720:	68 60 4c 11 80       	push   $0x80114c60
80105725:	e8 76 ee ff ff       	call   801045a0 <release>
      return -1;
8010572a:	83 c4 10             	add    $0x10,%esp
8010572d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  release(&tickslock);
  return 0;
}
80105732:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105735:	c9                   	leave  
80105736:	c3                   	ret    
80105737:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010573e:	66 90                	xchg   %ax,%ax
  release(&tickslock);
80105740:	83 ec 0c             	sub    $0xc,%esp
80105743:	68 60 4c 11 80       	push   $0x80114c60
80105748:	e8 53 ee ff ff       	call   801045a0 <release>
  return 0;
8010574d:	83 c4 10             	add    $0x10,%esp
80105750:	31 c0                	xor    %eax,%eax
}
80105752:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105755:	c9                   	leave  
80105756:	c3                   	ret    
    return -1;
80105757:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010575c:	eb f4                	jmp    80105752 <sys_sleep+0xa2>
8010575e:	66 90                	xchg   %ax,%ax

80105760 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80105760:	55                   	push   %ebp
80105761:	89 e5                	mov    %esp,%ebp
80105763:	53                   	push   %ebx
80105764:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
80105767:	68 60 4c 11 80       	push   $0x80114c60
8010576c:	e8 6f ed ff ff       	call   801044e0 <acquire>
  xticks = ticks;
80105771:	8b 1d a0 54 11 80    	mov    0x801154a0,%ebx
  release(&tickslock);
80105777:	c7 04 24 60 4c 11 80 	movl   $0x80114c60,(%esp)
8010577e:	e8 1d ee ff ff       	call   801045a0 <release>
  return xticks;
}
80105783:	89 d8                	mov    %ebx,%eax
80105785:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105788:	c9                   	leave  
80105789:	c3                   	ret    

8010578a <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
8010578a:	1e                   	push   %ds
  pushl %es
8010578b:	06                   	push   %es
  pushl %fs
8010578c:	0f a0                	push   %fs
  pushl %gs
8010578e:	0f a8                	push   %gs
  pushal
80105790:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
80105791:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80105795:	8e d8                	mov    %eax,%ds
  movw %ax, %es
80105797:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
80105799:	54                   	push   %esp
  call trap
8010579a:	e8 c1 00 00 00       	call   80105860 <trap>
  addl $4, %esp
8010579f:	83 c4 04             	add    $0x4,%esp

801057a2 <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
801057a2:	61                   	popa   
  popl %gs
801057a3:	0f a9                	pop    %gs
  popl %fs
801057a5:	0f a1                	pop    %fs
  popl %es
801057a7:	07                   	pop    %es
  popl %ds
801057a8:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
801057a9:	83 c4 08             	add    $0x8,%esp
  iret
801057ac:	cf                   	iret   
801057ad:	66 90                	xchg   %ax,%ax
801057af:	90                   	nop

801057b0 <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
801057b0:	55                   	push   %ebp
  int i;

  for(i = 0; i < 256; i++)
801057b1:	31 c0                	xor    %eax,%eax
{
801057b3:	89 e5                	mov    %esp,%ebp
801057b5:	83 ec 08             	sub    $0x8,%esp
801057b8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801057bf:	90                   	nop
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
801057c0:	8b 14 85 08 a0 10 80 	mov    -0x7fef5ff8(,%eax,4),%edx
801057c7:	c7 04 c5 a2 4c 11 80 	movl   $0x8e000008,-0x7feeb35e(,%eax,8)
801057ce:	08 00 00 8e 
801057d2:	66 89 14 c5 a0 4c 11 	mov    %dx,-0x7feeb360(,%eax,8)
801057d9:	80 
801057da:	c1 ea 10             	shr    $0x10,%edx
801057dd:	66 89 14 c5 a6 4c 11 	mov    %dx,-0x7feeb35a(,%eax,8)
801057e4:	80 
  for(i = 0; i < 256; i++)
801057e5:	83 c0 01             	add    $0x1,%eax
801057e8:	3d 00 01 00 00       	cmp    $0x100,%eax
801057ed:	75 d1                	jne    801057c0 <tvinit+0x10>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);

  initlock(&tickslock, "time");
801057ef:	83 ec 08             	sub    $0x8,%esp
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
801057f2:	a1 08 a1 10 80       	mov    0x8010a108,%eax
801057f7:	c7 05 a2 4e 11 80 08 	movl   $0xef000008,0x80114ea2
801057fe:	00 00 ef 
  initlock(&tickslock, "time");
80105801:	68 9d 77 10 80       	push   $0x8010779d
80105806:	68 60 4c 11 80       	push   $0x80114c60
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
8010580b:	66 a3 a0 4e 11 80    	mov    %ax,0x80114ea0
80105811:	c1 e8 10             	shr    $0x10,%eax
80105814:	66 a3 a6 4e 11 80    	mov    %ax,0x80114ea6
  initlock(&tickslock, "time");
8010581a:	e8 61 eb ff ff       	call   80104380 <initlock>
}
8010581f:	83 c4 10             	add    $0x10,%esp
80105822:	c9                   	leave  
80105823:	c3                   	ret    
80105824:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010582b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010582f:	90                   	nop

80105830 <idtinit>:

void
idtinit(void)
{
80105830:	55                   	push   %ebp
  pd[0] = size-1;
80105831:	b8 ff 07 00 00       	mov    $0x7ff,%eax
80105836:	89 e5                	mov    %esp,%ebp
80105838:	83 ec 10             	sub    $0x10,%esp
8010583b:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
8010583f:	b8 a0 4c 11 80       	mov    $0x80114ca0,%eax
80105844:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80105848:	c1 e8 10             	shr    $0x10,%eax
8010584b:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
8010584f:	8d 45 fa             	lea    -0x6(%ebp),%eax
80105852:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
80105855:	c9                   	leave  
80105856:	c3                   	ret    
80105857:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010585e:	66 90                	xchg   %ax,%ax

80105860 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80105860:	55                   	push   %ebp
80105861:	89 e5                	mov    %esp,%ebp
80105863:	57                   	push   %edi
80105864:	56                   	push   %esi
80105865:	53                   	push   %ebx
80105866:	83 ec 1c             	sub    $0x1c,%esp
80105869:	8b 7d 08             	mov    0x8(%ebp),%edi
  if(tf->trapno == T_SYSCALL){
8010586c:	8b 47 30             	mov    0x30(%edi),%eax
8010586f:	83 f8 40             	cmp    $0x40,%eax
80105872:	0f 84 b8 01 00 00    	je     80105a30 <trap+0x1d0>
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
80105878:	83 e8 20             	sub    $0x20,%eax
8010587b:	83 f8 1f             	cmp    $0x1f,%eax
8010587e:	77 10                	ja     80105890 <trap+0x30>
80105880:	ff 24 85 44 78 10 80 	jmp    *-0x7fef87bc(,%eax,4)
80105887:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010588e:	66 90                	xchg   %ax,%ax
    lapiceoi();
    break;

  //PAGEBREAK: 13
  default:
    if(myproc() == 0 || (tf->cs&3) == 0){
80105890:	e8 cb e0 ff ff       	call   80103960 <myproc>
80105895:	8b 5f 38             	mov    0x38(%edi),%ebx
80105898:	85 c0                	test   %eax,%eax
8010589a:	0f 84 17 02 00 00    	je     80105ab7 <trap+0x257>
801058a0:	f6 47 3c 03          	testb  $0x3,0x3c(%edi)
801058a4:	0f 84 0d 02 00 00    	je     80105ab7 <trap+0x257>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
801058aa:	0f 20 d1             	mov    %cr2,%ecx
801058ad:	89 4d d8             	mov    %ecx,-0x28(%ebp)
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801058b0:	e8 8b e0 ff ff       	call   80103940 <cpuid>
801058b5:	8b 77 30             	mov    0x30(%edi),%esi
801058b8:	89 45 dc             	mov    %eax,-0x24(%ebp)
801058bb:	8b 47 34             	mov    0x34(%edi),%eax
801058be:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
801058c1:	e8 9a e0 ff ff       	call   80103960 <myproc>
801058c6:	89 45 e0             	mov    %eax,-0x20(%ebp)
801058c9:	e8 92 e0 ff ff       	call   80103960 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801058ce:	8b 4d d8             	mov    -0x28(%ebp),%ecx
801058d1:	8b 55 dc             	mov    -0x24(%ebp),%edx
801058d4:	51                   	push   %ecx
801058d5:	53                   	push   %ebx
801058d6:	52                   	push   %edx
            myproc()->pid, myproc()->name, tf->trapno,
801058d7:	8b 55 e0             	mov    -0x20(%ebp),%edx
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801058da:	ff 75 e4             	pushl  -0x1c(%ebp)
            myproc()->pid, myproc()->name, tf->trapno,
801058dd:	83 c2 6c             	add    $0x6c,%edx
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801058e0:	56                   	push   %esi
801058e1:	52                   	push   %edx
801058e2:	ff 70 10             	pushl  0x10(%eax)
801058e5:	68 00 78 10 80       	push   $0x80107800
801058ea:	e8 c1 ad ff ff       	call   801006b0 <cprintf>
            tf->err, cpuid(), tf->eip, rcr2());
    myproc()->killed = 1;
801058ef:	83 c4 20             	add    $0x20,%esp
801058f2:	e8 69 e0 ff ff       	call   80103960 <myproc>
801058f7:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801058fe:	e8 5d e0 ff ff       	call   80103960 <myproc>
80105903:	85 c0                	test   %eax,%eax
80105905:	74 1d                	je     80105924 <trap+0xc4>
80105907:	e8 54 e0 ff ff       	call   80103960 <myproc>
8010590c:	8b 50 24             	mov    0x24(%eax),%edx
8010590f:	85 d2                	test   %edx,%edx
80105911:	74 11                	je     80105924 <trap+0xc4>
80105913:	0f b7 47 3c          	movzwl 0x3c(%edi),%eax
80105917:	83 e0 03             	and    $0x3,%eax
8010591a:	66 83 f8 03          	cmp    $0x3,%ax
8010591e:	0f 84 44 01 00 00    	je     80105a68 <trap+0x208>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
80105924:	e8 37 e0 ff ff       	call   80103960 <myproc>
80105929:	85 c0                	test   %eax,%eax
8010592b:	74 0b                	je     80105938 <trap+0xd8>
8010592d:	e8 2e e0 ff ff       	call   80103960 <myproc>
80105932:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
80105936:	74 38                	je     80105970 <trap+0x110>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105938:	e8 23 e0 ff ff       	call   80103960 <myproc>
8010593d:	85 c0                	test   %eax,%eax
8010593f:	74 1d                	je     8010595e <trap+0xfe>
80105941:	e8 1a e0 ff ff       	call   80103960 <myproc>
80105946:	8b 40 24             	mov    0x24(%eax),%eax
80105949:	85 c0                	test   %eax,%eax
8010594b:	74 11                	je     8010595e <trap+0xfe>
8010594d:	0f b7 47 3c          	movzwl 0x3c(%edi),%eax
80105951:	83 e0 03             	and    $0x3,%eax
80105954:	66 83 f8 03          	cmp    $0x3,%ax
80105958:	0f 84 fb 00 00 00    	je     80105a59 <trap+0x1f9>
    exit();
}
8010595e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105961:	5b                   	pop    %ebx
80105962:	5e                   	pop    %esi
80105963:	5f                   	pop    %edi
80105964:	5d                   	pop    %ebp
80105965:	c3                   	ret    
80105966:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010596d:	8d 76 00             	lea    0x0(%esi),%esi
  if(myproc() && myproc()->state == RUNNING &&
80105970:	83 7f 30 20          	cmpl   $0x20,0x30(%edi)
80105974:	75 c2                	jne    80105938 <trap+0xd8>
    yield();
80105976:	e8 35 e5 ff ff       	call   80103eb0 <yield>
8010597b:	eb bb                	jmp    80105938 <trap+0xd8>
8010597d:	8d 76 00             	lea    0x0(%esi),%esi
    if(cpuid() == 0){
80105980:	e8 bb df ff ff       	call   80103940 <cpuid>
80105985:	85 c0                	test   %eax,%eax
80105987:	0f 84 eb 00 00 00    	je     80105a78 <trap+0x218>
    lapiceoi();
8010598d:	e8 3e cf ff ff       	call   801028d0 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105992:	e8 c9 df ff ff       	call   80103960 <myproc>
80105997:	85 c0                	test   %eax,%eax
80105999:	0f 85 68 ff ff ff    	jne    80105907 <trap+0xa7>
8010599f:	eb 83                	jmp    80105924 <trap+0xc4>
801059a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kbdintr();
801059a8:	e8 e3 cd ff ff       	call   80102790 <kbdintr>
    lapiceoi();
801059ad:	e8 1e cf ff ff       	call   801028d0 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801059b2:	e8 a9 df ff ff       	call   80103960 <myproc>
801059b7:	85 c0                	test   %eax,%eax
801059b9:	0f 85 48 ff ff ff    	jne    80105907 <trap+0xa7>
801059bf:	e9 60 ff ff ff       	jmp    80105924 <trap+0xc4>
801059c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    uartintr();
801059c8:	e8 83 02 00 00       	call   80105c50 <uartintr>
    lapiceoi();
801059cd:	e8 fe ce ff ff       	call   801028d0 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801059d2:	e8 89 df ff ff       	call   80103960 <myproc>
801059d7:	85 c0                	test   %eax,%eax
801059d9:	0f 85 28 ff ff ff    	jne    80105907 <trap+0xa7>
801059df:	e9 40 ff ff ff       	jmp    80105924 <trap+0xc4>
801059e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
801059e8:	8b 77 38             	mov    0x38(%edi),%esi
801059eb:	0f b7 5f 3c          	movzwl 0x3c(%edi),%ebx
801059ef:	e8 4c df ff ff       	call   80103940 <cpuid>
801059f4:	56                   	push   %esi
801059f5:	53                   	push   %ebx
801059f6:	50                   	push   %eax
801059f7:	68 a8 77 10 80       	push   $0x801077a8
801059fc:	e8 af ac ff ff       	call   801006b0 <cprintf>
    lapiceoi();
80105a01:	e8 ca ce ff ff       	call   801028d0 <lapiceoi>
    break;
80105a06:	83 c4 10             	add    $0x10,%esp
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105a09:	e8 52 df ff ff       	call   80103960 <myproc>
80105a0e:	85 c0                	test   %eax,%eax
80105a10:	0f 85 f1 fe ff ff    	jne    80105907 <trap+0xa7>
80105a16:	e9 09 ff ff ff       	jmp    80105924 <trap+0xc4>
80105a1b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105a1f:	90                   	nop
    ideintr();
80105a20:	e8 3b c7 ff ff       	call   80102160 <ideintr>
80105a25:	e9 63 ff ff ff       	jmp    8010598d <trap+0x12d>
80105a2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(myproc()->killed)
80105a30:	e8 2b df ff ff       	call   80103960 <myproc>
80105a35:	8b 58 24             	mov    0x24(%eax),%ebx
80105a38:	85 db                	test   %ebx,%ebx
80105a3a:	75 74                	jne    80105ab0 <trap+0x250>
    myproc()->tf = tf;
80105a3c:	e8 1f df ff ff       	call   80103960 <myproc>
80105a41:	89 78 18             	mov    %edi,0x18(%eax)
    syscall();
80105a44:	e8 77 ef ff ff       	call   801049c0 <syscall>
    if(myproc()->killed)
80105a49:	e8 12 df ff ff       	call   80103960 <myproc>
80105a4e:	8b 48 24             	mov    0x24(%eax),%ecx
80105a51:	85 c9                	test   %ecx,%ecx
80105a53:	0f 84 05 ff ff ff    	je     8010595e <trap+0xfe>
}
80105a59:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105a5c:	5b                   	pop    %ebx
80105a5d:	5e                   	pop    %esi
80105a5e:	5f                   	pop    %edi
80105a5f:	5d                   	pop    %ebp
      exit();
80105a60:	e9 1b e3 ff ff       	jmp    80103d80 <exit>
80105a65:	8d 76 00             	lea    0x0(%esi),%esi
    exit();
80105a68:	e8 13 e3 ff ff       	call   80103d80 <exit>
80105a6d:	e9 b2 fe ff ff       	jmp    80105924 <trap+0xc4>
80105a72:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      acquire(&tickslock);
80105a78:	83 ec 0c             	sub    $0xc,%esp
80105a7b:	68 60 4c 11 80       	push   $0x80114c60
80105a80:	e8 5b ea ff ff       	call   801044e0 <acquire>
      wakeup(&ticks);
80105a85:	c7 04 24 a0 54 11 80 	movl   $0x801154a0,(%esp)
      ticks++;
80105a8c:	83 05 a0 54 11 80 01 	addl   $0x1,0x801154a0
      wakeup(&ticks);
80105a93:	e8 18 e6 ff ff       	call   801040b0 <wakeup>
      release(&tickslock);
80105a98:	c7 04 24 60 4c 11 80 	movl   $0x80114c60,(%esp)
80105a9f:	e8 fc ea ff ff       	call   801045a0 <release>
80105aa4:	83 c4 10             	add    $0x10,%esp
    lapiceoi();
80105aa7:	e9 e1 fe ff ff       	jmp    8010598d <trap+0x12d>
80105aac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      exit();
80105ab0:	e8 cb e2 ff ff       	call   80103d80 <exit>
80105ab5:	eb 85                	jmp    80105a3c <trap+0x1dc>
80105ab7:	0f 20 d6             	mov    %cr2,%esi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80105aba:	e8 81 de ff ff       	call   80103940 <cpuid>
80105abf:	83 ec 0c             	sub    $0xc,%esp
80105ac2:	56                   	push   %esi
80105ac3:	53                   	push   %ebx
80105ac4:	50                   	push   %eax
80105ac5:	ff 77 30             	pushl  0x30(%edi)
80105ac8:	68 cc 77 10 80       	push   $0x801077cc
80105acd:	e8 de ab ff ff       	call   801006b0 <cprintf>
      panic("trap");
80105ad2:	83 c4 14             	add    $0x14,%esp
80105ad5:	68 a2 77 10 80       	push   $0x801077a2
80105ada:	e8 b1 a8 ff ff       	call   80100390 <panic>
80105adf:	90                   	nop

80105ae0 <uartgetc>:
}

static int
uartgetc(void)
{
  if(!uart)
80105ae0:	a1 bc a5 10 80       	mov    0x8010a5bc,%eax
80105ae5:	85 c0                	test   %eax,%eax
80105ae7:	74 17                	je     80105b00 <uartgetc+0x20>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105ae9:	ba fd 03 00 00       	mov    $0x3fd,%edx
80105aee:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
80105aef:	a8 01                	test   $0x1,%al
80105af1:	74 0d                	je     80105b00 <uartgetc+0x20>
80105af3:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105af8:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
80105af9:	0f b6 c0             	movzbl %al,%eax
80105afc:	c3                   	ret    
80105afd:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80105b00:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105b05:	c3                   	ret    
80105b06:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105b0d:	8d 76 00             	lea    0x0(%esi),%esi

80105b10 <uartputc.part.0>:
uartputc(int c)
80105b10:	55                   	push   %ebp
80105b11:	89 e5                	mov    %esp,%ebp
80105b13:	57                   	push   %edi
80105b14:	89 c7                	mov    %eax,%edi
80105b16:	56                   	push   %esi
80105b17:	be fd 03 00 00       	mov    $0x3fd,%esi
80105b1c:	53                   	push   %ebx
80105b1d:	bb 80 00 00 00       	mov    $0x80,%ebx
80105b22:	83 ec 0c             	sub    $0xc,%esp
80105b25:	eb 1b                	jmp    80105b42 <uartputc.part.0+0x32>
80105b27:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105b2e:	66 90                	xchg   %ax,%ax
    microdelay(10);
80105b30:	83 ec 0c             	sub    $0xc,%esp
80105b33:	6a 0a                	push   $0xa
80105b35:	e8 b6 cd ff ff       	call   801028f0 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80105b3a:	83 c4 10             	add    $0x10,%esp
80105b3d:	83 eb 01             	sub    $0x1,%ebx
80105b40:	74 07                	je     80105b49 <uartputc.part.0+0x39>
80105b42:	89 f2                	mov    %esi,%edx
80105b44:	ec                   	in     (%dx),%al
80105b45:	a8 20                	test   $0x20,%al
80105b47:	74 e7                	je     80105b30 <uartputc.part.0+0x20>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80105b49:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105b4e:	89 f8                	mov    %edi,%eax
80105b50:	ee                   	out    %al,(%dx)
}
80105b51:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105b54:	5b                   	pop    %ebx
80105b55:	5e                   	pop    %esi
80105b56:	5f                   	pop    %edi
80105b57:	5d                   	pop    %ebp
80105b58:	c3                   	ret    
80105b59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105b60 <uartinit>:
{
80105b60:	55                   	push   %ebp
80105b61:	31 c9                	xor    %ecx,%ecx
80105b63:	89 c8                	mov    %ecx,%eax
80105b65:	89 e5                	mov    %esp,%ebp
80105b67:	57                   	push   %edi
80105b68:	56                   	push   %esi
80105b69:	53                   	push   %ebx
80105b6a:	bb fa 03 00 00       	mov    $0x3fa,%ebx
80105b6f:	89 da                	mov    %ebx,%edx
80105b71:	83 ec 0c             	sub    $0xc,%esp
80105b74:	ee                   	out    %al,(%dx)
80105b75:	bf fb 03 00 00       	mov    $0x3fb,%edi
80105b7a:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
80105b7f:	89 fa                	mov    %edi,%edx
80105b81:	ee                   	out    %al,(%dx)
80105b82:	b8 0c 00 00 00       	mov    $0xc,%eax
80105b87:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105b8c:	ee                   	out    %al,(%dx)
80105b8d:	be f9 03 00 00       	mov    $0x3f9,%esi
80105b92:	89 c8                	mov    %ecx,%eax
80105b94:	89 f2                	mov    %esi,%edx
80105b96:	ee                   	out    %al,(%dx)
80105b97:	b8 03 00 00 00       	mov    $0x3,%eax
80105b9c:	89 fa                	mov    %edi,%edx
80105b9e:	ee                   	out    %al,(%dx)
80105b9f:	ba fc 03 00 00       	mov    $0x3fc,%edx
80105ba4:	89 c8                	mov    %ecx,%eax
80105ba6:	ee                   	out    %al,(%dx)
80105ba7:	b8 01 00 00 00       	mov    $0x1,%eax
80105bac:	89 f2                	mov    %esi,%edx
80105bae:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105baf:	ba fd 03 00 00       	mov    $0x3fd,%edx
80105bb4:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
80105bb5:	3c ff                	cmp    $0xff,%al
80105bb7:	74 56                	je     80105c0f <uartinit+0xaf>
  uart = 1;
80105bb9:	c7 05 bc a5 10 80 01 	movl   $0x1,0x8010a5bc
80105bc0:	00 00 00 
80105bc3:	89 da                	mov    %ebx,%edx
80105bc5:	ec                   	in     (%dx),%al
80105bc6:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105bcb:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
80105bcc:	83 ec 08             	sub    $0x8,%esp
80105bcf:	be 76 00 00 00       	mov    $0x76,%esi
  for(p="xv6...\n"; *p; p++)
80105bd4:	bb c4 78 10 80       	mov    $0x801078c4,%ebx
  ioapicenable(IRQ_COM1, 0);
80105bd9:	6a 00                	push   $0x0
80105bdb:	6a 04                	push   $0x4
80105bdd:	e8 ce c7 ff ff       	call   801023b0 <ioapicenable>
80105be2:	83 c4 10             	add    $0x10,%esp
  for(p="xv6...\n"; *p; p++)
80105be5:	b8 78 00 00 00       	mov    $0x78,%eax
80105bea:	eb 08                	jmp    80105bf4 <uartinit+0x94>
80105bec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105bf0:	0f b6 73 01          	movzbl 0x1(%ebx),%esi
  if(!uart)
80105bf4:	8b 15 bc a5 10 80    	mov    0x8010a5bc,%edx
80105bfa:	85 d2                	test   %edx,%edx
80105bfc:	74 08                	je     80105c06 <uartinit+0xa6>
    uartputc(*p);
80105bfe:	0f be c0             	movsbl %al,%eax
80105c01:	e8 0a ff ff ff       	call   80105b10 <uartputc.part.0>
  for(p="xv6...\n"; *p; p++)
80105c06:	89 f0                	mov    %esi,%eax
80105c08:	83 c3 01             	add    $0x1,%ebx
80105c0b:	84 c0                	test   %al,%al
80105c0d:	75 e1                	jne    80105bf0 <uartinit+0x90>
}
80105c0f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105c12:	5b                   	pop    %ebx
80105c13:	5e                   	pop    %esi
80105c14:	5f                   	pop    %edi
80105c15:	5d                   	pop    %ebp
80105c16:	c3                   	ret    
80105c17:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105c1e:	66 90                	xchg   %ax,%ax

80105c20 <uartputc>:
{
80105c20:	55                   	push   %ebp
  if(!uart)
80105c21:	8b 15 bc a5 10 80    	mov    0x8010a5bc,%edx
{
80105c27:	89 e5                	mov    %esp,%ebp
80105c29:	8b 45 08             	mov    0x8(%ebp),%eax
  if(!uart)
80105c2c:	85 d2                	test   %edx,%edx
80105c2e:	74 10                	je     80105c40 <uartputc+0x20>
}
80105c30:	5d                   	pop    %ebp
80105c31:	e9 da fe ff ff       	jmp    80105b10 <uartputc.part.0>
80105c36:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105c3d:	8d 76 00             	lea    0x0(%esi),%esi
80105c40:	5d                   	pop    %ebp
80105c41:	c3                   	ret    
80105c42:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105c49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105c50 <uartintr>:

void
uartintr(void)
{
80105c50:	55                   	push   %ebp
80105c51:	89 e5                	mov    %esp,%ebp
80105c53:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
80105c56:	68 e0 5a 10 80       	push   $0x80105ae0
80105c5b:	e8 00 ac ff ff       	call   80100860 <consoleintr>
}
80105c60:	83 c4 10             	add    $0x10,%esp
80105c63:	c9                   	leave  
80105c64:	c3                   	ret    

80105c65 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80105c65:	6a 00                	push   $0x0
  pushl $0
80105c67:	6a 00                	push   $0x0
  jmp alltraps
80105c69:	e9 1c fb ff ff       	jmp    8010578a <alltraps>

80105c6e <vector1>:
.globl vector1
vector1:
  pushl $0
80105c6e:	6a 00                	push   $0x0
  pushl $1
80105c70:	6a 01                	push   $0x1
  jmp alltraps
80105c72:	e9 13 fb ff ff       	jmp    8010578a <alltraps>

80105c77 <vector2>:
.globl vector2
vector2:
  pushl $0
80105c77:	6a 00                	push   $0x0
  pushl $2
80105c79:	6a 02                	push   $0x2
  jmp alltraps
80105c7b:	e9 0a fb ff ff       	jmp    8010578a <alltraps>

80105c80 <vector3>:
.globl vector3
vector3:
  pushl $0
80105c80:	6a 00                	push   $0x0
  pushl $3
80105c82:	6a 03                	push   $0x3
  jmp alltraps
80105c84:	e9 01 fb ff ff       	jmp    8010578a <alltraps>

80105c89 <vector4>:
.globl vector4
vector4:
  pushl $0
80105c89:	6a 00                	push   $0x0
  pushl $4
80105c8b:	6a 04                	push   $0x4
  jmp alltraps
80105c8d:	e9 f8 fa ff ff       	jmp    8010578a <alltraps>

80105c92 <vector5>:
.globl vector5
vector5:
  pushl $0
80105c92:	6a 00                	push   $0x0
  pushl $5
80105c94:	6a 05                	push   $0x5
  jmp alltraps
80105c96:	e9 ef fa ff ff       	jmp    8010578a <alltraps>

80105c9b <vector6>:
.globl vector6
vector6:
  pushl $0
80105c9b:	6a 00                	push   $0x0
  pushl $6
80105c9d:	6a 06                	push   $0x6
  jmp alltraps
80105c9f:	e9 e6 fa ff ff       	jmp    8010578a <alltraps>

80105ca4 <vector7>:
.globl vector7
vector7:
  pushl $0
80105ca4:	6a 00                	push   $0x0
  pushl $7
80105ca6:	6a 07                	push   $0x7
  jmp alltraps
80105ca8:	e9 dd fa ff ff       	jmp    8010578a <alltraps>

80105cad <vector8>:
.globl vector8
vector8:
  pushl $8
80105cad:	6a 08                	push   $0x8
  jmp alltraps
80105caf:	e9 d6 fa ff ff       	jmp    8010578a <alltraps>

80105cb4 <vector9>:
.globl vector9
vector9:
  pushl $0
80105cb4:	6a 00                	push   $0x0
  pushl $9
80105cb6:	6a 09                	push   $0x9
  jmp alltraps
80105cb8:	e9 cd fa ff ff       	jmp    8010578a <alltraps>

80105cbd <vector10>:
.globl vector10
vector10:
  pushl $10
80105cbd:	6a 0a                	push   $0xa
  jmp alltraps
80105cbf:	e9 c6 fa ff ff       	jmp    8010578a <alltraps>

80105cc4 <vector11>:
.globl vector11
vector11:
  pushl $11
80105cc4:	6a 0b                	push   $0xb
  jmp alltraps
80105cc6:	e9 bf fa ff ff       	jmp    8010578a <alltraps>

80105ccb <vector12>:
.globl vector12
vector12:
  pushl $12
80105ccb:	6a 0c                	push   $0xc
  jmp alltraps
80105ccd:	e9 b8 fa ff ff       	jmp    8010578a <alltraps>

80105cd2 <vector13>:
.globl vector13
vector13:
  pushl $13
80105cd2:	6a 0d                	push   $0xd
  jmp alltraps
80105cd4:	e9 b1 fa ff ff       	jmp    8010578a <alltraps>

80105cd9 <vector14>:
.globl vector14
vector14:
  pushl $14
80105cd9:	6a 0e                	push   $0xe
  jmp alltraps
80105cdb:	e9 aa fa ff ff       	jmp    8010578a <alltraps>

80105ce0 <vector15>:
.globl vector15
vector15:
  pushl $0
80105ce0:	6a 00                	push   $0x0
  pushl $15
80105ce2:	6a 0f                	push   $0xf
  jmp alltraps
80105ce4:	e9 a1 fa ff ff       	jmp    8010578a <alltraps>

80105ce9 <vector16>:
.globl vector16
vector16:
  pushl $0
80105ce9:	6a 00                	push   $0x0
  pushl $16
80105ceb:	6a 10                	push   $0x10
  jmp alltraps
80105ced:	e9 98 fa ff ff       	jmp    8010578a <alltraps>

80105cf2 <vector17>:
.globl vector17
vector17:
  pushl $17
80105cf2:	6a 11                	push   $0x11
  jmp alltraps
80105cf4:	e9 91 fa ff ff       	jmp    8010578a <alltraps>

80105cf9 <vector18>:
.globl vector18
vector18:
  pushl $0
80105cf9:	6a 00                	push   $0x0
  pushl $18
80105cfb:	6a 12                	push   $0x12
  jmp alltraps
80105cfd:	e9 88 fa ff ff       	jmp    8010578a <alltraps>

80105d02 <vector19>:
.globl vector19
vector19:
  pushl $0
80105d02:	6a 00                	push   $0x0
  pushl $19
80105d04:	6a 13                	push   $0x13
  jmp alltraps
80105d06:	e9 7f fa ff ff       	jmp    8010578a <alltraps>

80105d0b <vector20>:
.globl vector20
vector20:
  pushl $0
80105d0b:	6a 00                	push   $0x0
  pushl $20
80105d0d:	6a 14                	push   $0x14
  jmp alltraps
80105d0f:	e9 76 fa ff ff       	jmp    8010578a <alltraps>

80105d14 <vector21>:
.globl vector21
vector21:
  pushl $0
80105d14:	6a 00                	push   $0x0
  pushl $21
80105d16:	6a 15                	push   $0x15
  jmp alltraps
80105d18:	e9 6d fa ff ff       	jmp    8010578a <alltraps>

80105d1d <vector22>:
.globl vector22
vector22:
  pushl $0
80105d1d:	6a 00                	push   $0x0
  pushl $22
80105d1f:	6a 16                	push   $0x16
  jmp alltraps
80105d21:	e9 64 fa ff ff       	jmp    8010578a <alltraps>

80105d26 <vector23>:
.globl vector23
vector23:
  pushl $0
80105d26:	6a 00                	push   $0x0
  pushl $23
80105d28:	6a 17                	push   $0x17
  jmp alltraps
80105d2a:	e9 5b fa ff ff       	jmp    8010578a <alltraps>

80105d2f <vector24>:
.globl vector24
vector24:
  pushl $0
80105d2f:	6a 00                	push   $0x0
  pushl $24
80105d31:	6a 18                	push   $0x18
  jmp alltraps
80105d33:	e9 52 fa ff ff       	jmp    8010578a <alltraps>

80105d38 <vector25>:
.globl vector25
vector25:
  pushl $0
80105d38:	6a 00                	push   $0x0
  pushl $25
80105d3a:	6a 19                	push   $0x19
  jmp alltraps
80105d3c:	e9 49 fa ff ff       	jmp    8010578a <alltraps>

80105d41 <vector26>:
.globl vector26
vector26:
  pushl $0
80105d41:	6a 00                	push   $0x0
  pushl $26
80105d43:	6a 1a                	push   $0x1a
  jmp alltraps
80105d45:	e9 40 fa ff ff       	jmp    8010578a <alltraps>

80105d4a <vector27>:
.globl vector27
vector27:
  pushl $0
80105d4a:	6a 00                	push   $0x0
  pushl $27
80105d4c:	6a 1b                	push   $0x1b
  jmp alltraps
80105d4e:	e9 37 fa ff ff       	jmp    8010578a <alltraps>

80105d53 <vector28>:
.globl vector28
vector28:
  pushl $0
80105d53:	6a 00                	push   $0x0
  pushl $28
80105d55:	6a 1c                	push   $0x1c
  jmp alltraps
80105d57:	e9 2e fa ff ff       	jmp    8010578a <alltraps>

80105d5c <vector29>:
.globl vector29
vector29:
  pushl $0
80105d5c:	6a 00                	push   $0x0
  pushl $29
80105d5e:	6a 1d                	push   $0x1d
  jmp alltraps
80105d60:	e9 25 fa ff ff       	jmp    8010578a <alltraps>

80105d65 <vector30>:
.globl vector30
vector30:
  pushl $0
80105d65:	6a 00                	push   $0x0
  pushl $30
80105d67:	6a 1e                	push   $0x1e
  jmp alltraps
80105d69:	e9 1c fa ff ff       	jmp    8010578a <alltraps>

80105d6e <vector31>:
.globl vector31
vector31:
  pushl $0
80105d6e:	6a 00                	push   $0x0
  pushl $31
80105d70:	6a 1f                	push   $0x1f
  jmp alltraps
80105d72:	e9 13 fa ff ff       	jmp    8010578a <alltraps>

80105d77 <vector32>:
.globl vector32
vector32:
  pushl $0
80105d77:	6a 00                	push   $0x0
  pushl $32
80105d79:	6a 20                	push   $0x20
  jmp alltraps
80105d7b:	e9 0a fa ff ff       	jmp    8010578a <alltraps>

80105d80 <vector33>:
.globl vector33
vector33:
  pushl $0
80105d80:	6a 00                	push   $0x0
  pushl $33
80105d82:	6a 21                	push   $0x21
  jmp alltraps
80105d84:	e9 01 fa ff ff       	jmp    8010578a <alltraps>

80105d89 <vector34>:
.globl vector34
vector34:
  pushl $0
80105d89:	6a 00                	push   $0x0
  pushl $34
80105d8b:	6a 22                	push   $0x22
  jmp alltraps
80105d8d:	e9 f8 f9 ff ff       	jmp    8010578a <alltraps>

80105d92 <vector35>:
.globl vector35
vector35:
  pushl $0
80105d92:	6a 00                	push   $0x0
  pushl $35
80105d94:	6a 23                	push   $0x23
  jmp alltraps
80105d96:	e9 ef f9 ff ff       	jmp    8010578a <alltraps>

80105d9b <vector36>:
.globl vector36
vector36:
  pushl $0
80105d9b:	6a 00                	push   $0x0
  pushl $36
80105d9d:	6a 24                	push   $0x24
  jmp alltraps
80105d9f:	e9 e6 f9 ff ff       	jmp    8010578a <alltraps>

80105da4 <vector37>:
.globl vector37
vector37:
  pushl $0
80105da4:	6a 00                	push   $0x0
  pushl $37
80105da6:	6a 25                	push   $0x25
  jmp alltraps
80105da8:	e9 dd f9 ff ff       	jmp    8010578a <alltraps>

80105dad <vector38>:
.globl vector38
vector38:
  pushl $0
80105dad:	6a 00                	push   $0x0
  pushl $38
80105daf:	6a 26                	push   $0x26
  jmp alltraps
80105db1:	e9 d4 f9 ff ff       	jmp    8010578a <alltraps>

80105db6 <vector39>:
.globl vector39
vector39:
  pushl $0
80105db6:	6a 00                	push   $0x0
  pushl $39
80105db8:	6a 27                	push   $0x27
  jmp alltraps
80105dba:	e9 cb f9 ff ff       	jmp    8010578a <alltraps>

80105dbf <vector40>:
.globl vector40
vector40:
  pushl $0
80105dbf:	6a 00                	push   $0x0
  pushl $40
80105dc1:	6a 28                	push   $0x28
  jmp alltraps
80105dc3:	e9 c2 f9 ff ff       	jmp    8010578a <alltraps>

80105dc8 <vector41>:
.globl vector41
vector41:
  pushl $0
80105dc8:	6a 00                	push   $0x0
  pushl $41
80105dca:	6a 29                	push   $0x29
  jmp alltraps
80105dcc:	e9 b9 f9 ff ff       	jmp    8010578a <alltraps>

80105dd1 <vector42>:
.globl vector42
vector42:
  pushl $0
80105dd1:	6a 00                	push   $0x0
  pushl $42
80105dd3:	6a 2a                	push   $0x2a
  jmp alltraps
80105dd5:	e9 b0 f9 ff ff       	jmp    8010578a <alltraps>

80105dda <vector43>:
.globl vector43
vector43:
  pushl $0
80105dda:	6a 00                	push   $0x0
  pushl $43
80105ddc:	6a 2b                	push   $0x2b
  jmp alltraps
80105dde:	e9 a7 f9 ff ff       	jmp    8010578a <alltraps>

80105de3 <vector44>:
.globl vector44
vector44:
  pushl $0
80105de3:	6a 00                	push   $0x0
  pushl $44
80105de5:	6a 2c                	push   $0x2c
  jmp alltraps
80105de7:	e9 9e f9 ff ff       	jmp    8010578a <alltraps>

80105dec <vector45>:
.globl vector45
vector45:
  pushl $0
80105dec:	6a 00                	push   $0x0
  pushl $45
80105dee:	6a 2d                	push   $0x2d
  jmp alltraps
80105df0:	e9 95 f9 ff ff       	jmp    8010578a <alltraps>

80105df5 <vector46>:
.globl vector46
vector46:
  pushl $0
80105df5:	6a 00                	push   $0x0
  pushl $46
80105df7:	6a 2e                	push   $0x2e
  jmp alltraps
80105df9:	e9 8c f9 ff ff       	jmp    8010578a <alltraps>

80105dfe <vector47>:
.globl vector47
vector47:
  pushl $0
80105dfe:	6a 00                	push   $0x0
  pushl $47
80105e00:	6a 2f                	push   $0x2f
  jmp alltraps
80105e02:	e9 83 f9 ff ff       	jmp    8010578a <alltraps>

80105e07 <vector48>:
.globl vector48
vector48:
  pushl $0
80105e07:	6a 00                	push   $0x0
  pushl $48
80105e09:	6a 30                	push   $0x30
  jmp alltraps
80105e0b:	e9 7a f9 ff ff       	jmp    8010578a <alltraps>

80105e10 <vector49>:
.globl vector49
vector49:
  pushl $0
80105e10:	6a 00                	push   $0x0
  pushl $49
80105e12:	6a 31                	push   $0x31
  jmp alltraps
80105e14:	e9 71 f9 ff ff       	jmp    8010578a <alltraps>

80105e19 <vector50>:
.globl vector50
vector50:
  pushl $0
80105e19:	6a 00                	push   $0x0
  pushl $50
80105e1b:	6a 32                	push   $0x32
  jmp alltraps
80105e1d:	e9 68 f9 ff ff       	jmp    8010578a <alltraps>

80105e22 <vector51>:
.globl vector51
vector51:
  pushl $0
80105e22:	6a 00                	push   $0x0
  pushl $51
80105e24:	6a 33                	push   $0x33
  jmp alltraps
80105e26:	e9 5f f9 ff ff       	jmp    8010578a <alltraps>

80105e2b <vector52>:
.globl vector52
vector52:
  pushl $0
80105e2b:	6a 00                	push   $0x0
  pushl $52
80105e2d:	6a 34                	push   $0x34
  jmp alltraps
80105e2f:	e9 56 f9 ff ff       	jmp    8010578a <alltraps>

80105e34 <vector53>:
.globl vector53
vector53:
  pushl $0
80105e34:	6a 00                	push   $0x0
  pushl $53
80105e36:	6a 35                	push   $0x35
  jmp alltraps
80105e38:	e9 4d f9 ff ff       	jmp    8010578a <alltraps>

80105e3d <vector54>:
.globl vector54
vector54:
  pushl $0
80105e3d:	6a 00                	push   $0x0
  pushl $54
80105e3f:	6a 36                	push   $0x36
  jmp alltraps
80105e41:	e9 44 f9 ff ff       	jmp    8010578a <alltraps>

80105e46 <vector55>:
.globl vector55
vector55:
  pushl $0
80105e46:	6a 00                	push   $0x0
  pushl $55
80105e48:	6a 37                	push   $0x37
  jmp alltraps
80105e4a:	e9 3b f9 ff ff       	jmp    8010578a <alltraps>

80105e4f <vector56>:
.globl vector56
vector56:
  pushl $0
80105e4f:	6a 00                	push   $0x0
  pushl $56
80105e51:	6a 38                	push   $0x38
  jmp alltraps
80105e53:	e9 32 f9 ff ff       	jmp    8010578a <alltraps>

80105e58 <vector57>:
.globl vector57
vector57:
  pushl $0
80105e58:	6a 00                	push   $0x0
  pushl $57
80105e5a:	6a 39                	push   $0x39
  jmp alltraps
80105e5c:	e9 29 f9 ff ff       	jmp    8010578a <alltraps>

80105e61 <vector58>:
.globl vector58
vector58:
  pushl $0
80105e61:	6a 00                	push   $0x0
  pushl $58
80105e63:	6a 3a                	push   $0x3a
  jmp alltraps
80105e65:	e9 20 f9 ff ff       	jmp    8010578a <alltraps>

80105e6a <vector59>:
.globl vector59
vector59:
  pushl $0
80105e6a:	6a 00                	push   $0x0
  pushl $59
80105e6c:	6a 3b                	push   $0x3b
  jmp alltraps
80105e6e:	e9 17 f9 ff ff       	jmp    8010578a <alltraps>

80105e73 <vector60>:
.globl vector60
vector60:
  pushl $0
80105e73:	6a 00                	push   $0x0
  pushl $60
80105e75:	6a 3c                	push   $0x3c
  jmp alltraps
80105e77:	e9 0e f9 ff ff       	jmp    8010578a <alltraps>

80105e7c <vector61>:
.globl vector61
vector61:
  pushl $0
80105e7c:	6a 00                	push   $0x0
  pushl $61
80105e7e:	6a 3d                	push   $0x3d
  jmp alltraps
80105e80:	e9 05 f9 ff ff       	jmp    8010578a <alltraps>

80105e85 <vector62>:
.globl vector62
vector62:
  pushl $0
80105e85:	6a 00                	push   $0x0
  pushl $62
80105e87:	6a 3e                	push   $0x3e
  jmp alltraps
80105e89:	e9 fc f8 ff ff       	jmp    8010578a <alltraps>

80105e8e <vector63>:
.globl vector63
vector63:
  pushl $0
80105e8e:	6a 00                	push   $0x0
  pushl $63
80105e90:	6a 3f                	push   $0x3f
  jmp alltraps
80105e92:	e9 f3 f8 ff ff       	jmp    8010578a <alltraps>

80105e97 <vector64>:
.globl vector64
vector64:
  pushl $0
80105e97:	6a 00                	push   $0x0
  pushl $64
80105e99:	6a 40                	push   $0x40
  jmp alltraps
80105e9b:	e9 ea f8 ff ff       	jmp    8010578a <alltraps>

80105ea0 <vector65>:
.globl vector65
vector65:
  pushl $0
80105ea0:	6a 00                	push   $0x0
  pushl $65
80105ea2:	6a 41                	push   $0x41
  jmp alltraps
80105ea4:	e9 e1 f8 ff ff       	jmp    8010578a <alltraps>

80105ea9 <vector66>:
.globl vector66
vector66:
  pushl $0
80105ea9:	6a 00                	push   $0x0
  pushl $66
80105eab:	6a 42                	push   $0x42
  jmp alltraps
80105ead:	e9 d8 f8 ff ff       	jmp    8010578a <alltraps>

80105eb2 <vector67>:
.globl vector67
vector67:
  pushl $0
80105eb2:	6a 00                	push   $0x0
  pushl $67
80105eb4:	6a 43                	push   $0x43
  jmp alltraps
80105eb6:	e9 cf f8 ff ff       	jmp    8010578a <alltraps>

80105ebb <vector68>:
.globl vector68
vector68:
  pushl $0
80105ebb:	6a 00                	push   $0x0
  pushl $68
80105ebd:	6a 44                	push   $0x44
  jmp alltraps
80105ebf:	e9 c6 f8 ff ff       	jmp    8010578a <alltraps>

80105ec4 <vector69>:
.globl vector69
vector69:
  pushl $0
80105ec4:	6a 00                	push   $0x0
  pushl $69
80105ec6:	6a 45                	push   $0x45
  jmp alltraps
80105ec8:	e9 bd f8 ff ff       	jmp    8010578a <alltraps>

80105ecd <vector70>:
.globl vector70
vector70:
  pushl $0
80105ecd:	6a 00                	push   $0x0
  pushl $70
80105ecf:	6a 46                	push   $0x46
  jmp alltraps
80105ed1:	e9 b4 f8 ff ff       	jmp    8010578a <alltraps>

80105ed6 <vector71>:
.globl vector71
vector71:
  pushl $0
80105ed6:	6a 00                	push   $0x0
  pushl $71
80105ed8:	6a 47                	push   $0x47
  jmp alltraps
80105eda:	e9 ab f8 ff ff       	jmp    8010578a <alltraps>

80105edf <vector72>:
.globl vector72
vector72:
  pushl $0
80105edf:	6a 00                	push   $0x0
  pushl $72
80105ee1:	6a 48                	push   $0x48
  jmp alltraps
80105ee3:	e9 a2 f8 ff ff       	jmp    8010578a <alltraps>

80105ee8 <vector73>:
.globl vector73
vector73:
  pushl $0
80105ee8:	6a 00                	push   $0x0
  pushl $73
80105eea:	6a 49                	push   $0x49
  jmp alltraps
80105eec:	e9 99 f8 ff ff       	jmp    8010578a <alltraps>

80105ef1 <vector74>:
.globl vector74
vector74:
  pushl $0
80105ef1:	6a 00                	push   $0x0
  pushl $74
80105ef3:	6a 4a                	push   $0x4a
  jmp alltraps
80105ef5:	e9 90 f8 ff ff       	jmp    8010578a <alltraps>

80105efa <vector75>:
.globl vector75
vector75:
  pushl $0
80105efa:	6a 00                	push   $0x0
  pushl $75
80105efc:	6a 4b                	push   $0x4b
  jmp alltraps
80105efe:	e9 87 f8 ff ff       	jmp    8010578a <alltraps>

80105f03 <vector76>:
.globl vector76
vector76:
  pushl $0
80105f03:	6a 00                	push   $0x0
  pushl $76
80105f05:	6a 4c                	push   $0x4c
  jmp alltraps
80105f07:	e9 7e f8 ff ff       	jmp    8010578a <alltraps>

80105f0c <vector77>:
.globl vector77
vector77:
  pushl $0
80105f0c:	6a 00                	push   $0x0
  pushl $77
80105f0e:	6a 4d                	push   $0x4d
  jmp alltraps
80105f10:	e9 75 f8 ff ff       	jmp    8010578a <alltraps>

80105f15 <vector78>:
.globl vector78
vector78:
  pushl $0
80105f15:	6a 00                	push   $0x0
  pushl $78
80105f17:	6a 4e                	push   $0x4e
  jmp alltraps
80105f19:	e9 6c f8 ff ff       	jmp    8010578a <alltraps>

80105f1e <vector79>:
.globl vector79
vector79:
  pushl $0
80105f1e:	6a 00                	push   $0x0
  pushl $79
80105f20:	6a 4f                	push   $0x4f
  jmp alltraps
80105f22:	e9 63 f8 ff ff       	jmp    8010578a <alltraps>

80105f27 <vector80>:
.globl vector80
vector80:
  pushl $0
80105f27:	6a 00                	push   $0x0
  pushl $80
80105f29:	6a 50                	push   $0x50
  jmp alltraps
80105f2b:	e9 5a f8 ff ff       	jmp    8010578a <alltraps>

80105f30 <vector81>:
.globl vector81
vector81:
  pushl $0
80105f30:	6a 00                	push   $0x0
  pushl $81
80105f32:	6a 51                	push   $0x51
  jmp alltraps
80105f34:	e9 51 f8 ff ff       	jmp    8010578a <alltraps>

80105f39 <vector82>:
.globl vector82
vector82:
  pushl $0
80105f39:	6a 00                	push   $0x0
  pushl $82
80105f3b:	6a 52                	push   $0x52
  jmp alltraps
80105f3d:	e9 48 f8 ff ff       	jmp    8010578a <alltraps>

80105f42 <vector83>:
.globl vector83
vector83:
  pushl $0
80105f42:	6a 00                	push   $0x0
  pushl $83
80105f44:	6a 53                	push   $0x53
  jmp alltraps
80105f46:	e9 3f f8 ff ff       	jmp    8010578a <alltraps>

80105f4b <vector84>:
.globl vector84
vector84:
  pushl $0
80105f4b:	6a 00                	push   $0x0
  pushl $84
80105f4d:	6a 54                	push   $0x54
  jmp alltraps
80105f4f:	e9 36 f8 ff ff       	jmp    8010578a <alltraps>

80105f54 <vector85>:
.globl vector85
vector85:
  pushl $0
80105f54:	6a 00                	push   $0x0
  pushl $85
80105f56:	6a 55                	push   $0x55
  jmp alltraps
80105f58:	e9 2d f8 ff ff       	jmp    8010578a <alltraps>

80105f5d <vector86>:
.globl vector86
vector86:
  pushl $0
80105f5d:	6a 00                	push   $0x0
  pushl $86
80105f5f:	6a 56                	push   $0x56
  jmp alltraps
80105f61:	e9 24 f8 ff ff       	jmp    8010578a <alltraps>

80105f66 <vector87>:
.globl vector87
vector87:
  pushl $0
80105f66:	6a 00                	push   $0x0
  pushl $87
80105f68:	6a 57                	push   $0x57
  jmp alltraps
80105f6a:	e9 1b f8 ff ff       	jmp    8010578a <alltraps>

80105f6f <vector88>:
.globl vector88
vector88:
  pushl $0
80105f6f:	6a 00                	push   $0x0
  pushl $88
80105f71:	6a 58                	push   $0x58
  jmp alltraps
80105f73:	e9 12 f8 ff ff       	jmp    8010578a <alltraps>

80105f78 <vector89>:
.globl vector89
vector89:
  pushl $0
80105f78:	6a 00                	push   $0x0
  pushl $89
80105f7a:	6a 59                	push   $0x59
  jmp alltraps
80105f7c:	e9 09 f8 ff ff       	jmp    8010578a <alltraps>

80105f81 <vector90>:
.globl vector90
vector90:
  pushl $0
80105f81:	6a 00                	push   $0x0
  pushl $90
80105f83:	6a 5a                	push   $0x5a
  jmp alltraps
80105f85:	e9 00 f8 ff ff       	jmp    8010578a <alltraps>

80105f8a <vector91>:
.globl vector91
vector91:
  pushl $0
80105f8a:	6a 00                	push   $0x0
  pushl $91
80105f8c:	6a 5b                	push   $0x5b
  jmp alltraps
80105f8e:	e9 f7 f7 ff ff       	jmp    8010578a <alltraps>

80105f93 <vector92>:
.globl vector92
vector92:
  pushl $0
80105f93:	6a 00                	push   $0x0
  pushl $92
80105f95:	6a 5c                	push   $0x5c
  jmp alltraps
80105f97:	e9 ee f7 ff ff       	jmp    8010578a <alltraps>

80105f9c <vector93>:
.globl vector93
vector93:
  pushl $0
80105f9c:	6a 00                	push   $0x0
  pushl $93
80105f9e:	6a 5d                	push   $0x5d
  jmp alltraps
80105fa0:	e9 e5 f7 ff ff       	jmp    8010578a <alltraps>

80105fa5 <vector94>:
.globl vector94
vector94:
  pushl $0
80105fa5:	6a 00                	push   $0x0
  pushl $94
80105fa7:	6a 5e                	push   $0x5e
  jmp alltraps
80105fa9:	e9 dc f7 ff ff       	jmp    8010578a <alltraps>

80105fae <vector95>:
.globl vector95
vector95:
  pushl $0
80105fae:	6a 00                	push   $0x0
  pushl $95
80105fb0:	6a 5f                	push   $0x5f
  jmp alltraps
80105fb2:	e9 d3 f7 ff ff       	jmp    8010578a <alltraps>

80105fb7 <vector96>:
.globl vector96
vector96:
  pushl $0
80105fb7:	6a 00                	push   $0x0
  pushl $96
80105fb9:	6a 60                	push   $0x60
  jmp alltraps
80105fbb:	e9 ca f7 ff ff       	jmp    8010578a <alltraps>

80105fc0 <vector97>:
.globl vector97
vector97:
  pushl $0
80105fc0:	6a 00                	push   $0x0
  pushl $97
80105fc2:	6a 61                	push   $0x61
  jmp alltraps
80105fc4:	e9 c1 f7 ff ff       	jmp    8010578a <alltraps>

80105fc9 <vector98>:
.globl vector98
vector98:
  pushl $0
80105fc9:	6a 00                	push   $0x0
  pushl $98
80105fcb:	6a 62                	push   $0x62
  jmp alltraps
80105fcd:	e9 b8 f7 ff ff       	jmp    8010578a <alltraps>

80105fd2 <vector99>:
.globl vector99
vector99:
  pushl $0
80105fd2:	6a 00                	push   $0x0
  pushl $99
80105fd4:	6a 63                	push   $0x63
  jmp alltraps
80105fd6:	e9 af f7 ff ff       	jmp    8010578a <alltraps>

80105fdb <vector100>:
.globl vector100
vector100:
  pushl $0
80105fdb:	6a 00                	push   $0x0
  pushl $100
80105fdd:	6a 64                	push   $0x64
  jmp alltraps
80105fdf:	e9 a6 f7 ff ff       	jmp    8010578a <alltraps>

80105fe4 <vector101>:
.globl vector101
vector101:
  pushl $0
80105fe4:	6a 00                	push   $0x0
  pushl $101
80105fe6:	6a 65                	push   $0x65
  jmp alltraps
80105fe8:	e9 9d f7 ff ff       	jmp    8010578a <alltraps>

80105fed <vector102>:
.globl vector102
vector102:
  pushl $0
80105fed:	6a 00                	push   $0x0
  pushl $102
80105fef:	6a 66                	push   $0x66
  jmp alltraps
80105ff1:	e9 94 f7 ff ff       	jmp    8010578a <alltraps>

80105ff6 <vector103>:
.globl vector103
vector103:
  pushl $0
80105ff6:	6a 00                	push   $0x0
  pushl $103
80105ff8:	6a 67                	push   $0x67
  jmp alltraps
80105ffa:	e9 8b f7 ff ff       	jmp    8010578a <alltraps>

80105fff <vector104>:
.globl vector104
vector104:
  pushl $0
80105fff:	6a 00                	push   $0x0
  pushl $104
80106001:	6a 68                	push   $0x68
  jmp alltraps
80106003:	e9 82 f7 ff ff       	jmp    8010578a <alltraps>

80106008 <vector105>:
.globl vector105
vector105:
  pushl $0
80106008:	6a 00                	push   $0x0
  pushl $105
8010600a:	6a 69                	push   $0x69
  jmp alltraps
8010600c:	e9 79 f7 ff ff       	jmp    8010578a <alltraps>

80106011 <vector106>:
.globl vector106
vector106:
  pushl $0
80106011:	6a 00                	push   $0x0
  pushl $106
80106013:	6a 6a                	push   $0x6a
  jmp alltraps
80106015:	e9 70 f7 ff ff       	jmp    8010578a <alltraps>

8010601a <vector107>:
.globl vector107
vector107:
  pushl $0
8010601a:	6a 00                	push   $0x0
  pushl $107
8010601c:	6a 6b                	push   $0x6b
  jmp alltraps
8010601e:	e9 67 f7 ff ff       	jmp    8010578a <alltraps>

80106023 <vector108>:
.globl vector108
vector108:
  pushl $0
80106023:	6a 00                	push   $0x0
  pushl $108
80106025:	6a 6c                	push   $0x6c
  jmp alltraps
80106027:	e9 5e f7 ff ff       	jmp    8010578a <alltraps>

8010602c <vector109>:
.globl vector109
vector109:
  pushl $0
8010602c:	6a 00                	push   $0x0
  pushl $109
8010602e:	6a 6d                	push   $0x6d
  jmp alltraps
80106030:	e9 55 f7 ff ff       	jmp    8010578a <alltraps>

80106035 <vector110>:
.globl vector110
vector110:
  pushl $0
80106035:	6a 00                	push   $0x0
  pushl $110
80106037:	6a 6e                	push   $0x6e
  jmp alltraps
80106039:	e9 4c f7 ff ff       	jmp    8010578a <alltraps>

8010603e <vector111>:
.globl vector111
vector111:
  pushl $0
8010603e:	6a 00                	push   $0x0
  pushl $111
80106040:	6a 6f                	push   $0x6f
  jmp alltraps
80106042:	e9 43 f7 ff ff       	jmp    8010578a <alltraps>

80106047 <vector112>:
.globl vector112
vector112:
  pushl $0
80106047:	6a 00                	push   $0x0
  pushl $112
80106049:	6a 70                	push   $0x70
  jmp alltraps
8010604b:	e9 3a f7 ff ff       	jmp    8010578a <alltraps>

80106050 <vector113>:
.globl vector113
vector113:
  pushl $0
80106050:	6a 00                	push   $0x0
  pushl $113
80106052:	6a 71                	push   $0x71
  jmp alltraps
80106054:	e9 31 f7 ff ff       	jmp    8010578a <alltraps>

80106059 <vector114>:
.globl vector114
vector114:
  pushl $0
80106059:	6a 00                	push   $0x0
  pushl $114
8010605b:	6a 72                	push   $0x72
  jmp alltraps
8010605d:	e9 28 f7 ff ff       	jmp    8010578a <alltraps>

80106062 <vector115>:
.globl vector115
vector115:
  pushl $0
80106062:	6a 00                	push   $0x0
  pushl $115
80106064:	6a 73                	push   $0x73
  jmp alltraps
80106066:	e9 1f f7 ff ff       	jmp    8010578a <alltraps>

8010606b <vector116>:
.globl vector116
vector116:
  pushl $0
8010606b:	6a 00                	push   $0x0
  pushl $116
8010606d:	6a 74                	push   $0x74
  jmp alltraps
8010606f:	e9 16 f7 ff ff       	jmp    8010578a <alltraps>

80106074 <vector117>:
.globl vector117
vector117:
  pushl $0
80106074:	6a 00                	push   $0x0
  pushl $117
80106076:	6a 75                	push   $0x75
  jmp alltraps
80106078:	e9 0d f7 ff ff       	jmp    8010578a <alltraps>

8010607d <vector118>:
.globl vector118
vector118:
  pushl $0
8010607d:	6a 00                	push   $0x0
  pushl $118
8010607f:	6a 76                	push   $0x76
  jmp alltraps
80106081:	e9 04 f7 ff ff       	jmp    8010578a <alltraps>

80106086 <vector119>:
.globl vector119
vector119:
  pushl $0
80106086:	6a 00                	push   $0x0
  pushl $119
80106088:	6a 77                	push   $0x77
  jmp alltraps
8010608a:	e9 fb f6 ff ff       	jmp    8010578a <alltraps>

8010608f <vector120>:
.globl vector120
vector120:
  pushl $0
8010608f:	6a 00                	push   $0x0
  pushl $120
80106091:	6a 78                	push   $0x78
  jmp alltraps
80106093:	e9 f2 f6 ff ff       	jmp    8010578a <alltraps>

80106098 <vector121>:
.globl vector121
vector121:
  pushl $0
80106098:	6a 00                	push   $0x0
  pushl $121
8010609a:	6a 79                	push   $0x79
  jmp alltraps
8010609c:	e9 e9 f6 ff ff       	jmp    8010578a <alltraps>

801060a1 <vector122>:
.globl vector122
vector122:
  pushl $0
801060a1:	6a 00                	push   $0x0
  pushl $122
801060a3:	6a 7a                	push   $0x7a
  jmp alltraps
801060a5:	e9 e0 f6 ff ff       	jmp    8010578a <alltraps>

801060aa <vector123>:
.globl vector123
vector123:
  pushl $0
801060aa:	6a 00                	push   $0x0
  pushl $123
801060ac:	6a 7b                	push   $0x7b
  jmp alltraps
801060ae:	e9 d7 f6 ff ff       	jmp    8010578a <alltraps>

801060b3 <vector124>:
.globl vector124
vector124:
  pushl $0
801060b3:	6a 00                	push   $0x0
  pushl $124
801060b5:	6a 7c                	push   $0x7c
  jmp alltraps
801060b7:	e9 ce f6 ff ff       	jmp    8010578a <alltraps>

801060bc <vector125>:
.globl vector125
vector125:
  pushl $0
801060bc:	6a 00                	push   $0x0
  pushl $125
801060be:	6a 7d                	push   $0x7d
  jmp alltraps
801060c0:	e9 c5 f6 ff ff       	jmp    8010578a <alltraps>

801060c5 <vector126>:
.globl vector126
vector126:
  pushl $0
801060c5:	6a 00                	push   $0x0
  pushl $126
801060c7:	6a 7e                	push   $0x7e
  jmp alltraps
801060c9:	e9 bc f6 ff ff       	jmp    8010578a <alltraps>

801060ce <vector127>:
.globl vector127
vector127:
  pushl $0
801060ce:	6a 00                	push   $0x0
  pushl $127
801060d0:	6a 7f                	push   $0x7f
  jmp alltraps
801060d2:	e9 b3 f6 ff ff       	jmp    8010578a <alltraps>

801060d7 <vector128>:
.globl vector128
vector128:
  pushl $0
801060d7:	6a 00                	push   $0x0
  pushl $128
801060d9:	68 80 00 00 00       	push   $0x80
  jmp alltraps
801060de:	e9 a7 f6 ff ff       	jmp    8010578a <alltraps>

801060e3 <vector129>:
.globl vector129
vector129:
  pushl $0
801060e3:	6a 00                	push   $0x0
  pushl $129
801060e5:	68 81 00 00 00       	push   $0x81
  jmp alltraps
801060ea:	e9 9b f6 ff ff       	jmp    8010578a <alltraps>

801060ef <vector130>:
.globl vector130
vector130:
  pushl $0
801060ef:	6a 00                	push   $0x0
  pushl $130
801060f1:	68 82 00 00 00       	push   $0x82
  jmp alltraps
801060f6:	e9 8f f6 ff ff       	jmp    8010578a <alltraps>

801060fb <vector131>:
.globl vector131
vector131:
  pushl $0
801060fb:	6a 00                	push   $0x0
  pushl $131
801060fd:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80106102:	e9 83 f6 ff ff       	jmp    8010578a <alltraps>

80106107 <vector132>:
.globl vector132
vector132:
  pushl $0
80106107:	6a 00                	push   $0x0
  pushl $132
80106109:	68 84 00 00 00       	push   $0x84
  jmp alltraps
8010610e:	e9 77 f6 ff ff       	jmp    8010578a <alltraps>

80106113 <vector133>:
.globl vector133
vector133:
  pushl $0
80106113:	6a 00                	push   $0x0
  pushl $133
80106115:	68 85 00 00 00       	push   $0x85
  jmp alltraps
8010611a:	e9 6b f6 ff ff       	jmp    8010578a <alltraps>

8010611f <vector134>:
.globl vector134
vector134:
  pushl $0
8010611f:	6a 00                	push   $0x0
  pushl $134
80106121:	68 86 00 00 00       	push   $0x86
  jmp alltraps
80106126:	e9 5f f6 ff ff       	jmp    8010578a <alltraps>

8010612b <vector135>:
.globl vector135
vector135:
  pushl $0
8010612b:	6a 00                	push   $0x0
  pushl $135
8010612d:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80106132:	e9 53 f6 ff ff       	jmp    8010578a <alltraps>

80106137 <vector136>:
.globl vector136
vector136:
  pushl $0
80106137:	6a 00                	push   $0x0
  pushl $136
80106139:	68 88 00 00 00       	push   $0x88
  jmp alltraps
8010613e:	e9 47 f6 ff ff       	jmp    8010578a <alltraps>

80106143 <vector137>:
.globl vector137
vector137:
  pushl $0
80106143:	6a 00                	push   $0x0
  pushl $137
80106145:	68 89 00 00 00       	push   $0x89
  jmp alltraps
8010614a:	e9 3b f6 ff ff       	jmp    8010578a <alltraps>

8010614f <vector138>:
.globl vector138
vector138:
  pushl $0
8010614f:	6a 00                	push   $0x0
  pushl $138
80106151:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
80106156:	e9 2f f6 ff ff       	jmp    8010578a <alltraps>

8010615b <vector139>:
.globl vector139
vector139:
  pushl $0
8010615b:	6a 00                	push   $0x0
  pushl $139
8010615d:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80106162:	e9 23 f6 ff ff       	jmp    8010578a <alltraps>

80106167 <vector140>:
.globl vector140
vector140:
  pushl $0
80106167:	6a 00                	push   $0x0
  pushl $140
80106169:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
8010616e:	e9 17 f6 ff ff       	jmp    8010578a <alltraps>

80106173 <vector141>:
.globl vector141
vector141:
  pushl $0
80106173:	6a 00                	push   $0x0
  pushl $141
80106175:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
8010617a:	e9 0b f6 ff ff       	jmp    8010578a <alltraps>

8010617f <vector142>:
.globl vector142
vector142:
  pushl $0
8010617f:	6a 00                	push   $0x0
  pushl $142
80106181:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80106186:	e9 ff f5 ff ff       	jmp    8010578a <alltraps>

8010618b <vector143>:
.globl vector143
vector143:
  pushl $0
8010618b:	6a 00                	push   $0x0
  pushl $143
8010618d:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80106192:	e9 f3 f5 ff ff       	jmp    8010578a <alltraps>

80106197 <vector144>:
.globl vector144
vector144:
  pushl $0
80106197:	6a 00                	push   $0x0
  pushl $144
80106199:	68 90 00 00 00       	push   $0x90
  jmp alltraps
8010619e:	e9 e7 f5 ff ff       	jmp    8010578a <alltraps>

801061a3 <vector145>:
.globl vector145
vector145:
  pushl $0
801061a3:	6a 00                	push   $0x0
  pushl $145
801061a5:	68 91 00 00 00       	push   $0x91
  jmp alltraps
801061aa:	e9 db f5 ff ff       	jmp    8010578a <alltraps>

801061af <vector146>:
.globl vector146
vector146:
  pushl $0
801061af:	6a 00                	push   $0x0
  pushl $146
801061b1:	68 92 00 00 00       	push   $0x92
  jmp alltraps
801061b6:	e9 cf f5 ff ff       	jmp    8010578a <alltraps>

801061bb <vector147>:
.globl vector147
vector147:
  pushl $0
801061bb:	6a 00                	push   $0x0
  pushl $147
801061bd:	68 93 00 00 00       	push   $0x93
  jmp alltraps
801061c2:	e9 c3 f5 ff ff       	jmp    8010578a <alltraps>

801061c7 <vector148>:
.globl vector148
vector148:
  pushl $0
801061c7:	6a 00                	push   $0x0
  pushl $148
801061c9:	68 94 00 00 00       	push   $0x94
  jmp alltraps
801061ce:	e9 b7 f5 ff ff       	jmp    8010578a <alltraps>

801061d3 <vector149>:
.globl vector149
vector149:
  pushl $0
801061d3:	6a 00                	push   $0x0
  pushl $149
801061d5:	68 95 00 00 00       	push   $0x95
  jmp alltraps
801061da:	e9 ab f5 ff ff       	jmp    8010578a <alltraps>

801061df <vector150>:
.globl vector150
vector150:
  pushl $0
801061df:	6a 00                	push   $0x0
  pushl $150
801061e1:	68 96 00 00 00       	push   $0x96
  jmp alltraps
801061e6:	e9 9f f5 ff ff       	jmp    8010578a <alltraps>

801061eb <vector151>:
.globl vector151
vector151:
  pushl $0
801061eb:	6a 00                	push   $0x0
  pushl $151
801061ed:	68 97 00 00 00       	push   $0x97
  jmp alltraps
801061f2:	e9 93 f5 ff ff       	jmp    8010578a <alltraps>

801061f7 <vector152>:
.globl vector152
vector152:
  pushl $0
801061f7:	6a 00                	push   $0x0
  pushl $152
801061f9:	68 98 00 00 00       	push   $0x98
  jmp alltraps
801061fe:	e9 87 f5 ff ff       	jmp    8010578a <alltraps>

80106203 <vector153>:
.globl vector153
vector153:
  pushl $0
80106203:	6a 00                	push   $0x0
  pushl $153
80106205:	68 99 00 00 00       	push   $0x99
  jmp alltraps
8010620a:	e9 7b f5 ff ff       	jmp    8010578a <alltraps>

8010620f <vector154>:
.globl vector154
vector154:
  pushl $0
8010620f:	6a 00                	push   $0x0
  pushl $154
80106211:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
80106216:	e9 6f f5 ff ff       	jmp    8010578a <alltraps>

8010621b <vector155>:
.globl vector155
vector155:
  pushl $0
8010621b:	6a 00                	push   $0x0
  pushl $155
8010621d:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80106222:	e9 63 f5 ff ff       	jmp    8010578a <alltraps>

80106227 <vector156>:
.globl vector156
vector156:
  pushl $0
80106227:	6a 00                	push   $0x0
  pushl $156
80106229:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
8010622e:	e9 57 f5 ff ff       	jmp    8010578a <alltraps>

80106233 <vector157>:
.globl vector157
vector157:
  pushl $0
80106233:	6a 00                	push   $0x0
  pushl $157
80106235:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
8010623a:	e9 4b f5 ff ff       	jmp    8010578a <alltraps>

8010623f <vector158>:
.globl vector158
vector158:
  pushl $0
8010623f:	6a 00                	push   $0x0
  pushl $158
80106241:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80106246:	e9 3f f5 ff ff       	jmp    8010578a <alltraps>

8010624b <vector159>:
.globl vector159
vector159:
  pushl $0
8010624b:	6a 00                	push   $0x0
  pushl $159
8010624d:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80106252:	e9 33 f5 ff ff       	jmp    8010578a <alltraps>

80106257 <vector160>:
.globl vector160
vector160:
  pushl $0
80106257:	6a 00                	push   $0x0
  pushl $160
80106259:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
8010625e:	e9 27 f5 ff ff       	jmp    8010578a <alltraps>

80106263 <vector161>:
.globl vector161
vector161:
  pushl $0
80106263:	6a 00                	push   $0x0
  pushl $161
80106265:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
8010626a:	e9 1b f5 ff ff       	jmp    8010578a <alltraps>

8010626f <vector162>:
.globl vector162
vector162:
  pushl $0
8010626f:	6a 00                	push   $0x0
  pushl $162
80106271:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80106276:	e9 0f f5 ff ff       	jmp    8010578a <alltraps>

8010627b <vector163>:
.globl vector163
vector163:
  pushl $0
8010627b:	6a 00                	push   $0x0
  pushl $163
8010627d:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80106282:	e9 03 f5 ff ff       	jmp    8010578a <alltraps>

80106287 <vector164>:
.globl vector164
vector164:
  pushl $0
80106287:	6a 00                	push   $0x0
  pushl $164
80106289:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
8010628e:	e9 f7 f4 ff ff       	jmp    8010578a <alltraps>

80106293 <vector165>:
.globl vector165
vector165:
  pushl $0
80106293:	6a 00                	push   $0x0
  pushl $165
80106295:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
8010629a:	e9 eb f4 ff ff       	jmp    8010578a <alltraps>

8010629f <vector166>:
.globl vector166
vector166:
  pushl $0
8010629f:	6a 00                	push   $0x0
  pushl $166
801062a1:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
801062a6:	e9 df f4 ff ff       	jmp    8010578a <alltraps>

801062ab <vector167>:
.globl vector167
vector167:
  pushl $0
801062ab:	6a 00                	push   $0x0
  pushl $167
801062ad:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
801062b2:	e9 d3 f4 ff ff       	jmp    8010578a <alltraps>

801062b7 <vector168>:
.globl vector168
vector168:
  pushl $0
801062b7:	6a 00                	push   $0x0
  pushl $168
801062b9:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
801062be:	e9 c7 f4 ff ff       	jmp    8010578a <alltraps>

801062c3 <vector169>:
.globl vector169
vector169:
  pushl $0
801062c3:	6a 00                	push   $0x0
  pushl $169
801062c5:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
801062ca:	e9 bb f4 ff ff       	jmp    8010578a <alltraps>

801062cf <vector170>:
.globl vector170
vector170:
  pushl $0
801062cf:	6a 00                	push   $0x0
  pushl $170
801062d1:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
801062d6:	e9 af f4 ff ff       	jmp    8010578a <alltraps>

801062db <vector171>:
.globl vector171
vector171:
  pushl $0
801062db:	6a 00                	push   $0x0
  pushl $171
801062dd:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
801062e2:	e9 a3 f4 ff ff       	jmp    8010578a <alltraps>

801062e7 <vector172>:
.globl vector172
vector172:
  pushl $0
801062e7:	6a 00                	push   $0x0
  pushl $172
801062e9:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
801062ee:	e9 97 f4 ff ff       	jmp    8010578a <alltraps>

801062f3 <vector173>:
.globl vector173
vector173:
  pushl $0
801062f3:	6a 00                	push   $0x0
  pushl $173
801062f5:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
801062fa:	e9 8b f4 ff ff       	jmp    8010578a <alltraps>

801062ff <vector174>:
.globl vector174
vector174:
  pushl $0
801062ff:	6a 00                	push   $0x0
  pushl $174
80106301:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80106306:	e9 7f f4 ff ff       	jmp    8010578a <alltraps>

8010630b <vector175>:
.globl vector175
vector175:
  pushl $0
8010630b:	6a 00                	push   $0x0
  pushl $175
8010630d:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80106312:	e9 73 f4 ff ff       	jmp    8010578a <alltraps>

80106317 <vector176>:
.globl vector176
vector176:
  pushl $0
80106317:	6a 00                	push   $0x0
  pushl $176
80106319:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
8010631e:	e9 67 f4 ff ff       	jmp    8010578a <alltraps>

80106323 <vector177>:
.globl vector177
vector177:
  pushl $0
80106323:	6a 00                	push   $0x0
  pushl $177
80106325:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
8010632a:	e9 5b f4 ff ff       	jmp    8010578a <alltraps>

8010632f <vector178>:
.globl vector178
vector178:
  pushl $0
8010632f:	6a 00                	push   $0x0
  pushl $178
80106331:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80106336:	e9 4f f4 ff ff       	jmp    8010578a <alltraps>

8010633b <vector179>:
.globl vector179
vector179:
  pushl $0
8010633b:	6a 00                	push   $0x0
  pushl $179
8010633d:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80106342:	e9 43 f4 ff ff       	jmp    8010578a <alltraps>

80106347 <vector180>:
.globl vector180
vector180:
  pushl $0
80106347:	6a 00                	push   $0x0
  pushl $180
80106349:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
8010634e:	e9 37 f4 ff ff       	jmp    8010578a <alltraps>

80106353 <vector181>:
.globl vector181
vector181:
  pushl $0
80106353:	6a 00                	push   $0x0
  pushl $181
80106355:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
8010635a:	e9 2b f4 ff ff       	jmp    8010578a <alltraps>

8010635f <vector182>:
.globl vector182
vector182:
  pushl $0
8010635f:	6a 00                	push   $0x0
  pushl $182
80106361:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80106366:	e9 1f f4 ff ff       	jmp    8010578a <alltraps>

8010636b <vector183>:
.globl vector183
vector183:
  pushl $0
8010636b:	6a 00                	push   $0x0
  pushl $183
8010636d:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80106372:	e9 13 f4 ff ff       	jmp    8010578a <alltraps>

80106377 <vector184>:
.globl vector184
vector184:
  pushl $0
80106377:	6a 00                	push   $0x0
  pushl $184
80106379:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
8010637e:	e9 07 f4 ff ff       	jmp    8010578a <alltraps>

80106383 <vector185>:
.globl vector185
vector185:
  pushl $0
80106383:	6a 00                	push   $0x0
  pushl $185
80106385:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
8010638a:	e9 fb f3 ff ff       	jmp    8010578a <alltraps>

8010638f <vector186>:
.globl vector186
vector186:
  pushl $0
8010638f:	6a 00                	push   $0x0
  pushl $186
80106391:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80106396:	e9 ef f3 ff ff       	jmp    8010578a <alltraps>

8010639b <vector187>:
.globl vector187
vector187:
  pushl $0
8010639b:	6a 00                	push   $0x0
  pushl $187
8010639d:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
801063a2:	e9 e3 f3 ff ff       	jmp    8010578a <alltraps>

801063a7 <vector188>:
.globl vector188
vector188:
  pushl $0
801063a7:	6a 00                	push   $0x0
  pushl $188
801063a9:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
801063ae:	e9 d7 f3 ff ff       	jmp    8010578a <alltraps>

801063b3 <vector189>:
.globl vector189
vector189:
  pushl $0
801063b3:	6a 00                	push   $0x0
  pushl $189
801063b5:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
801063ba:	e9 cb f3 ff ff       	jmp    8010578a <alltraps>

801063bf <vector190>:
.globl vector190
vector190:
  pushl $0
801063bf:	6a 00                	push   $0x0
  pushl $190
801063c1:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
801063c6:	e9 bf f3 ff ff       	jmp    8010578a <alltraps>

801063cb <vector191>:
.globl vector191
vector191:
  pushl $0
801063cb:	6a 00                	push   $0x0
  pushl $191
801063cd:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
801063d2:	e9 b3 f3 ff ff       	jmp    8010578a <alltraps>

801063d7 <vector192>:
.globl vector192
vector192:
  pushl $0
801063d7:	6a 00                	push   $0x0
  pushl $192
801063d9:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
801063de:	e9 a7 f3 ff ff       	jmp    8010578a <alltraps>

801063e3 <vector193>:
.globl vector193
vector193:
  pushl $0
801063e3:	6a 00                	push   $0x0
  pushl $193
801063e5:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
801063ea:	e9 9b f3 ff ff       	jmp    8010578a <alltraps>

801063ef <vector194>:
.globl vector194
vector194:
  pushl $0
801063ef:	6a 00                	push   $0x0
  pushl $194
801063f1:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
801063f6:	e9 8f f3 ff ff       	jmp    8010578a <alltraps>

801063fb <vector195>:
.globl vector195
vector195:
  pushl $0
801063fb:	6a 00                	push   $0x0
  pushl $195
801063fd:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80106402:	e9 83 f3 ff ff       	jmp    8010578a <alltraps>

80106407 <vector196>:
.globl vector196
vector196:
  pushl $0
80106407:	6a 00                	push   $0x0
  pushl $196
80106409:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
8010640e:	e9 77 f3 ff ff       	jmp    8010578a <alltraps>

80106413 <vector197>:
.globl vector197
vector197:
  pushl $0
80106413:	6a 00                	push   $0x0
  pushl $197
80106415:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
8010641a:	e9 6b f3 ff ff       	jmp    8010578a <alltraps>

8010641f <vector198>:
.globl vector198
vector198:
  pushl $0
8010641f:	6a 00                	push   $0x0
  pushl $198
80106421:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80106426:	e9 5f f3 ff ff       	jmp    8010578a <alltraps>

8010642b <vector199>:
.globl vector199
vector199:
  pushl $0
8010642b:	6a 00                	push   $0x0
  pushl $199
8010642d:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80106432:	e9 53 f3 ff ff       	jmp    8010578a <alltraps>

80106437 <vector200>:
.globl vector200
vector200:
  pushl $0
80106437:	6a 00                	push   $0x0
  pushl $200
80106439:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
8010643e:	e9 47 f3 ff ff       	jmp    8010578a <alltraps>

80106443 <vector201>:
.globl vector201
vector201:
  pushl $0
80106443:	6a 00                	push   $0x0
  pushl $201
80106445:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
8010644a:	e9 3b f3 ff ff       	jmp    8010578a <alltraps>

8010644f <vector202>:
.globl vector202
vector202:
  pushl $0
8010644f:	6a 00                	push   $0x0
  pushl $202
80106451:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80106456:	e9 2f f3 ff ff       	jmp    8010578a <alltraps>

8010645b <vector203>:
.globl vector203
vector203:
  pushl $0
8010645b:	6a 00                	push   $0x0
  pushl $203
8010645d:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80106462:	e9 23 f3 ff ff       	jmp    8010578a <alltraps>

80106467 <vector204>:
.globl vector204
vector204:
  pushl $0
80106467:	6a 00                	push   $0x0
  pushl $204
80106469:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
8010646e:	e9 17 f3 ff ff       	jmp    8010578a <alltraps>

80106473 <vector205>:
.globl vector205
vector205:
  pushl $0
80106473:	6a 00                	push   $0x0
  pushl $205
80106475:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
8010647a:	e9 0b f3 ff ff       	jmp    8010578a <alltraps>

8010647f <vector206>:
.globl vector206
vector206:
  pushl $0
8010647f:	6a 00                	push   $0x0
  pushl $206
80106481:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80106486:	e9 ff f2 ff ff       	jmp    8010578a <alltraps>

8010648b <vector207>:
.globl vector207
vector207:
  pushl $0
8010648b:	6a 00                	push   $0x0
  pushl $207
8010648d:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80106492:	e9 f3 f2 ff ff       	jmp    8010578a <alltraps>

80106497 <vector208>:
.globl vector208
vector208:
  pushl $0
80106497:	6a 00                	push   $0x0
  pushl $208
80106499:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
8010649e:	e9 e7 f2 ff ff       	jmp    8010578a <alltraps>

801064a3 <vector209>:
.globl vector209
vector209:
  pushl $0
801064a3:	6a 00                	push   $0x0
  pushl $209
801064a5:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
801064aa:	e9 db f2 ff ff       	jmp    8010578a <alltraps>

801064af <vector210>:
.globl vector210
vector210:
  pushl $0
801064af:	6a 00                	push   $0x0
  pushl $210
801064b1:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
801064b6:	e9 cf f2 ff ff       	jmp    8010578a <alltraps>

801064bb <vector211>:
.globl vector211
vector211:
  pushl $0
801064bb:	6a 00                	push   $0x0
  pushl $211
801064bd:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
801064c2:	e9 c3 f2 ff ff       	jmp    8010578a <alltraps>

801064c7 <vector212>:
.globl vector212
vector212:
  pushl $0
801064c7:	6a 00                	push   $0x0
  pushl $212
801064c9:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
801064ce:	e9 b7 f2 ff ff       	jmp    8010578a <alltraps>

801064d3 <vector213>:
.globl vector213
vector213:
  pushl $0
801064d3:	6a 00                	push   $0x0
  pushl $213
801064d5:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
801064da:	e9 ab f2 ff ff       	jmp    8010578a <alltraps>

801064df <vector214>:
.globl vector214
vector214:
  pushl $0
801064df:	6a 00                	push   $0x0
  pushl $214
801064e1:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
801064e6:	e9 9f f2 ff ff       	jmp    8010578a <alltraps>

801064eb <vector215>:
.globl vector215
vector215:
  pushl $0
801064eb:	6a 00                	push   $0x0
  pushl $215
801064ed:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
801064f2:	e9 93 f2 ff ff       	jmp    8010578a <alltraps>

801064f7 <vector216>:
.globl vector216
vector216:
  pushl $0
801064f7:	6a 00                	push   $0x0
  pushl $216
801064f9:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
801064fe:	e9 87 f2 ff ff       	jmp    8010578a <alltraps>

80106503 <vector217>:
.globl vector217
vector217:
  pushl $0
80106503:	6a 00                	push   $0x0
  pushl $217
80106505:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
8010650a:	e9 7b f2 ff ff       	jmp    8010578a <alltraps>

8010650f <vector218>:
.globl vector218
vector218:
  pushl $0
8010650f:	6a 00                	push   $0x0
  pushl $218
80106511:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80106516:	e9 6f f2 ff ff       	jmp    8010578a <alltraps>

8010651b <vector219>:
.globl vector219
vector219:
  pushl $0
8010651b:	6a 00                	push   $0x0
  pushl $219
8010651d:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80106522:	e9 63 f2 ff ff       	jmp    8010578a <alltraps>

80106527 <vector220>:
.globl vector220
vector220:
  pushl $0
80106527:	6a 00                	push   $0x0
  pushl $220
80106529:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
8010652e:	e9 57 f2 ff ff       	jmp    8010578a <alltraps>

80106533 <vector221>:
.globl vector221
vector221:
  pushl $0
80106533:	6a 00                	push   $0x0
  pushl $221
80106535:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
8010653a:	e9 4b f2 ff ff       	jmp    8010578a <alltraps>

8010653f <vector222>:
.globl vector222
vector222:
  pushl $0
8010653f:	6a 00                	push   $0x0
  pushl $222
80106541:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80106546:	e9 3f f2 ff ff       	jmp    8010578a <alltraps>

8010654b <vector223>:
.globl vector223
vector223:
  pushl $0
8010654b:	6a 00                	push   $0x0
  pushl $223
8010654d:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80106552:	e9 33 f2 ff ff       	jmp    8010578a <alltraps>

80106557 <vector224>:
.globl vector224
vector224:
  pushl $0
80106557:	6a 00                	push   $0x0
  pushl $224
80106559:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
8010655e:	e9 27 f2 ff ff       	jmp    8010578a <alltraps>

80106563 <vector225>:
.globl vector225
vector225:
  pushl $0
80106563:	6a 00                	push   $0x0
  pushl $225
80106565:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
8010656a:	e9 1b f2 ff ff       	jmp    8010578a <alltraps>

8010656f <vector226>:
.globl vector226
vector226:
  pushl $0
8010656f:	6a 00                	push   $0x0
  pushl $226
80106571:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80106576:	e9 0f f2 ff ff       	jmp    8010578a <alltraps>

8010657b <vector227>:
.globl vector227
vector227:
  pushl $0
8010657b:	6a 00                	push   $0x0
  pushl $227
8010657d:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80106582:	e9 03 f2 ff ff       	jmp    8010578a <alltraps>

80106587 <vector228>:
.globl vector228
vector228:
  pushl $0
80106587:	6a 00                	push   $0x0
  pushl $228
80106589:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
8010658e:	e9 f7 f1 ff ff       	jmp    8010578a <alltraps>

80106593 <vector229>:
.globl vector229
vector229:
  pushl $0
80106593:	6a 00                	push   $0x0
  pushl $229
80106595:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
8010659a:	e9 eb f1 ff ff       	jmp    8010578a <alltraps>

8010659f <vector230>:
.globl vector230
vector230:
  pushl $0
8010659f:	6a 00                	push   $0x0
  pushl $230
801065a1:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
801065a6:	e9 df f1 ff ff       	jmp    8010578a <alltraps>

801065ab <vector231>:
.globl vector231
vector231:
  pushl $0
801065ab:	6a 00                	push   $0x0
  pushl $231
801065ad:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
801065b2:	e9 d3 f1 ff ff       	jmp    8010578a <alltraps>

801065b7 <vector232>:
.globl vector232
vector232:
  pushl $0
801065b7:	6a 00                	push   $0x0
  pushl $232
801065b9:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
801065be:	e9 c7 f1 ff ff       	jmp    8010578a <alltraps>

801065c3 <vector233>:
.globl vector233
vector233:
  pushl $0
801065c3:	6a 00                	push   $0x0
  pushl $233
801065c5:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
801065ca:	e9 bb f1 ff ff       	jmp    8010578a <alltraps>

801065cf <vector234>:
.globl vector234
vector234:
  pushl $0
801065cf:	6a 00                	push   $0x0
  pushl $234
801065d1:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
801065d6:	e9 af f1 ff ff       	jmp    8010578a <alltraps>

801065db <vector235>:
.globl vector235
vector235:
  pushl $0
801065db:	6a 00                	push   $0x0
  pushl $235
801065dd:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
801065e2:	e9 a3 f1 ff ff       	jmp    8010578a <alltraps>

801065e7 <vector236>:
.globl vector236
vector236:
  pushl $0
801065e7:	6a 00                	push   $0x0
  pushl $236
801065e9:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
801065ee:	e9 97 f1 ff ff       	jmp    8010578a <alltraps>

801065f3 <vector237>:
.globl vector237
vector237:
  pushl $0
801065f3:	6a 00                	push   $0x0
  pushl $237
801065f5:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
801065fa:	e9 8b f1 ff ff       	jmp    8010578a <alltraps>

801065ff <vector238>:
.globl vector238
vector238:
  pushl $0
801065ff:	6a 00                	push   $0x0
  pushl $238
80106601:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80106606:	e9 7f f1 ff ff       	jmp    8010578a <alltraps>

8010660b <vector239>:
.globl vector239
vector239:
  pushl $0
8010660b:	6a 00                	push   $0x0
  pushl $239
8010660d:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80106612:	e9 73 f1 ff ff       	jmp    8010578a <alltraps>

80106617 <vector240>:
.globl vector240
vector240:
  pushl $0
80106617:	6a 00                	push   $0x0
  pushl $240
80106619:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
8010661e:	e9 67 f1 ff ff       	jmp    8010578a <alltraps>

80106623 <vector241>:
.globl vector241
vector241:
  pushl $0
80106623:	6a 00                	push   $0x0
  pushl $241
80106625:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
8010662a:	e9 5b f1 ff ff       	jmp    8010578a <alltraps>

8010662f <vector242>:
.globl vector242
vector242:
  pushl $0
8010662f:	6a 00                	push   $0x0
  pushl $242
80106631:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80106636:	e9 4f f1 ff ff       	jmp    8010578a <alltraps>

8010663b <vector243>:
.globl vector243
vector243:
  pushl $0
8010663b:	6a 00                	push   $0x0
  pushl $243
8010663d:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80106642:	e9 43 f1 ff ff       	jmp    8010578a <alltraps>

80106647 <vector244>:
.globl vector244
vector244:
  pushl $0
80106647:	6a 00                	push   $0x0
  pushl $244
80106649:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
8010664e:	e9 37 f1 ff ff       	jmp    8010578a <alltraps>

80106653 <vector245>:
.globl vector245
vector245:
  pushl $0
80106653:	6a 00                	push   $0x0
  pushl $245
80106655:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
8010665a:	e9 2b f1 ff ff       	jmp    8010578a <alltraps>

8010665f <vector246>:
.globl vector246
vector246:
  pushl $0
8010665f:	6a 00                	push   $0x0
  pushl $246
80106661:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80106666:	e9 1f f1 ff ff       	jmp    8010578a <alltraps>

8010666b <vector247>:
.globl vector247
vector247:
  pushl $0
8010666b:	6a 00                	push   $0x0
  pushl $247
8010666d:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80106672:	e9 13 f1 ff ff       	jmp    8010578a <alltraps>

80106677 <vector248>:
.globl vector248
vector248:
  pushl $0
80106677:	6a 00                	push   $0x0
  pushl $248
80106679:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
8010667e:	e9 07 f1 ff ff       	jmp    8010578a <alltraps>

80106683 <vector249>:
.globl vector249
vector249:
  pushl $0
80106683:	6a 00                	push   $0x0
  pushl $249
80106685:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
8010668a:	e9 fb f0 ff ff       	jmp    8010578a <alltraps>

8010668f <vector250>:
.globl vector250
vector250:
  pushl $0
8010668f:	6a 00                	push   $0x0
  pushl $250
80106691:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80106696:	e9 ef f0 ff ff       	jmp    8010578a <alltraps>

8010669b <vector251>:
.globl vector251
vector251:
  pushl $0
8010669b:	6a 00                	push   $0x0
  pushl $251
8010669d:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
801066a2:	e9 e3 f0 ff ff       	jmp    8010578a <alltraps>

801066a7 <vector252>:
.globl vector252
vector252:
  pushl $0
801066a7:	6a 00                	push   $0x0
  pushl $252
801066a9:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
801066ae:	e9 d7 f0 ff ff       	jmp    8010578a <alltraps>

801066b3 <vector253>:
.globl vector253
vector253:
  pushl $0
801066b3:	6a 00                	push   $0x0
  pushl $253
801066b5:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
801066ba:	e9 cb f0 ff ff       	jmp    8010578a <alltraps>

801066bf <vector254>:
.globl vector254
vector254:
  pushl $0
801066bf:	6a 00                	push   $0x0
  pushl $254
801066c1:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
801066c6:	e9 bf f0 ff ff       	jmp    8010578a <alltraps>

801066cb <vector255>:
.globl vector255
vector255:
  pushl $0
801066cb:	6a 00                	push   $0x0
  pushl $255
801066cd:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
801066d2:	e9 b3 f0 ff ff       	jmp    8010578a <alltraps>
801066d7:	66 90                	xchg   %ax,%ax
801066d9:	66 90                	xchg   %ax,%ax
801066db:	66 90                	xchg   %ax,%ax
801066dd:	66 90                	xchg   %ax,%ax
801066df:	90                   	nop

801066e0 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
801066e0:	55                   	push   %ebp
801066e1:	89 e5                	mov    %esp,%ebp
801066e3:	57                   	push   %edi
801066e4:	56                   	push   %esi
801066e5:	89 d6                	mov    %edx,%esi
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
801066e7:	c1 ea 16             	shr    $0x16,%edx
{
801066ea:	53                   	push   %ebx
  pde = &pgdir[PDX(va)];
801066eb:	8d 3c 90             	lea    (%eax,%edx,4),%edi
{
801066ee:	83 ec 0c             	sub    $0xc,%esp
  if(*pde & PTE_P){
801066f1:	8b 07                	mov    (%edi),%eax
801066f3:	a8 01                	test   $0x1,%al
801066f5:	74 29                	je     80106720 <walkpgdir+0x40>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
801066f7:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801066fc:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
80106702:	c1 ee 0a             	shr    $0xa,%esi
}
80106705:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return &pgtab[PTX(va)];
80106708:	89 f2                	mov    %esi,%edx
8010670a:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
80106710:	8d 04 13             	lea    (%ebx,%edx,1),%eax
}
80106713:	5b                   	pop    %ebx
80106714:	5e                   	pop    %esi
80106715:	5f                   	pop    %edi
80106716:	5d                   	pop    %ebp
80106717:	c3                   	ret    
80106718:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010671f:	90                   	nop
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80106720:	85 c9                	test   %ecx,%ecx
80106722:	74 2c                	je     80106750 <walkpgdir+0x70>
80106724:	e8 87 be ff ff       	call   801025b0 <kalloc>
80106729:	89 c3                	mov    %eax,%ebx
8010672b:	85 c0                	test   %eax,%eax
8010672d:	74 21                	je     80106750 <walkpgdir+0x70>
    memset(pgtab, 0, PGSIZE);
8010672f:	83 ec 04             	sub    $0x4,%esp
80106732:	68 00 10 00 00       	push   $0x1000
80106737:	6a 00                	push   $0x0
80106739:	50                   	push   %eax
8010673a:	e8 b1 de ff ff       	call   801045f0 <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
8010673f:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106745:	83 c4 10             	add    $0x10,%esp
80106748:	83 c8 07             	or     $0x7,%eax
8010674b:	89 07                	mov    %eax,(%edi)
8010674d:	eb b3                	jmp    80106702 <walkpgdir+0x22>
8010674f:	90                   	nop
}
80106750:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return 0;
80106753:	31 c0                	xor    %eax,%eax
}
80106755:	5b                   	pop    %ebx
80106756:	5e                   	pop    %esi
80106757:	5f                   	pop    %edi
80106758:	5d                   	pop    %ebp
80106759:	c3                   	ret    
8010675a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106760 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
80106760:	55                   	push   %ebp
80106761:	89 e5                	mov    %esp,%ebp
80106763:	57                   	push   %edi
80106764:	56                   	push   %esi
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
80106765:	89 d6                	mov    %edx,%esi
{
80106767:	53                   	push   %ebx
  a = (char*)PGROUNDDOWN((uint)va);
80106768:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
{
8010676e:	83 ec 1c             	sub    $0x1c,%esp
80106771:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80106774:	8b 7d 08             	mov    0x8(%ebp),%edi
80106777:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
8010677b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106780:	89 45 e0             	mov    %eax,-0x20(%ebp)
80106783:	29 f7                	sub    %esi,%edi
80106785:	eb 21                	jmp    801067a8 <mappages+0x48>
80106787:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010678e:	66 90                	xchg   %ax,%ax
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
80106790:	f6 00 01             	testb  $0x1,(%eax)
80106793:	75 45                	jne    801067da <mappages+0x7a>
      panic("remap");
    *pte = pa | perm | PTE_P;
80106795:	0b 5d 0c             	or     0xc(%ebp),%ebx
80106798:	83 cb 01             	or     $0x1,%ebx
8010679b:	89 18                	mov    %ebx,(%eax)
    if(a == last)
8010679d:	3b 75 e0             	cmp    -0x20(%ebp),%esi
801067a0:	74 2e                	je     801067d0 <mappages+0x70>
      break;
    a += PGSIZE;
801067a2:	81 c6 00 10 00 00    	add    $0x1000,%esi
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
801067a8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801067ab:	b9 01 00 00 00       	mov    $0x1,%ecx
801067b0:	89 f2                	mov    %esi,%edx
801067b2:	8d 1c 3e             	lea    (%esi,%edi,1),%ebx
801067b5:	e8 26 ff ff ff       	call   801066e0 <walkpgdir>
801067ba:	85 c0                	test   %eax,%eax
801067bc:	75 d2                	jne    80106790 <mappages+0x30>
    pa += PGSIZE;
  }
  return 0;
}
801067be:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
801067c1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801067c6:	5b                   	pop    %ebx
801067c7:	5e                   	pop    %esi
801067c8:	5f                   	pop    %edi
801067c9:	5d                   	pop    %ebp
801067ca:	c3                   	ret    
801067cb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801067cf:	90                   	nop
801067d0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801067d3:	31 c0                	xor    %eax,%eax
}
801067d5:	5b                   	pop    %ebx
801067d6:	5e                   	pop    %esi
801067d7:	5f                   	pop    %edi
801067d8:	5d                   	pop    %ebp
801067d9:	c3                   	ret    
      panic("remap");
801067da:	83 ec 0c             	sub    $0xc,%esp
801067dd:	68 cc 78 10 80       	push   $0x801078cc
801067e2:	e8 a9 9b ff ff       	call   80100390 <panic>
801067e7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801067ee:	66 90                	xchg   %ax,%ax

801067f0 <deallocuvm.part.0>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
801067f0:	55                   	push   %ebp
801067f1:	89 e5                	mov    %esp,%ebp
801067f3:	57                   	push   %edi
801067f4:	89 c7                	mov    %eax,%edi
801067f6:	56                   	push   %esi
801067f7:	53                   	push   %ebx
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
801067f8:	8d 99 ff 0f 00 00    	lea    0xfff(%ecx),%ebx
801067fe:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106804:	83 ec 1c             	sub    $0x1c,%esp
80106807:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  for(; a  < oldsz; a += PGSIZE){
8010680a:	39 d3                	cmp    %edx,%ebx
8010680c:	73 5a                	jae    80106868 <deallocuvm.part.0+0x78>
8010680e:	89 d6                	mov    %edx,%esi
80106810:	eb 10                	jmp    80106822 <deallocuvm.part.0+0x32>
80106812:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106818:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010681e:	39 de                	cmp    %ebx,%esi
80106820:	76 46                	jbe    80106868 <deallocuvm.part.0+0x78>
    pte = walkpgdir(pgdir, (char*)a, 0);
80106822:	31 c9                	xor    %ecx,%ecx
80106824:	89 da                	mov    %ebx,%edx
80106826:	89 f8                	mov    %edi,%eax
80106828:	e8 b3 fe ff ff       	call   801066e0 <walkpgdir>
    if(!pte)
8010682d:	85 c0                	test   %eax,%eax
8010682f:	74 47                	je     80106878 <deallocuvm.part.0+0x88>
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
    else if((*pte & PTE_P) != 0){
80106831:	8b 10                	mov    (%eax),%edx
80106833:	f6 c2 01             	test   $0x1,%dl
80106836:	74 e0                	je     80106818 <deallocuvm.part.0+0x28>
      pa = PTE_ADDR(*pte);
      if(pa == 0)
80106838:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
8010683e:	74 46                	je     80106886 <deallocuvm.part.0+0x96>
        panic("kfree");
      char *v = P2V(pa);
      kfree(v);
80106840:	83 ec 0c             	sub    $0xc,%esp
      char *v = P2V(pa);
80106843:	81 c2 00 00 00 80    	add    $0x80000000,%edx
80106849:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      kfree(v);
8010684c:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106852:	52                   	push   %edx
80106853:	e8 98 bb ff ff       	call   801023f0 <kfree>
      *pte = 0;
80106858:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010685b:	83 c4 10             	add    $0x10,%esp
8010685e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; a  < oldsz; a += PGSIZE){
80106864:	39 de                	cmp    %ebx,%esi
80106866:	77 ba                	ja     80106822 <deallocuvm.part.0+0x32>
    }
  }
  return newsz;
}
80106868:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010686b:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010686e:	5b                   	pop    %ebx
8010686f:	5e                   	pop    %esi
80106870:	5f                   	pop    %edi
80106871:	5d                   	pop    %ebp
80106872:	c3                   	ret    
80106873:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106877:	90                   	nop
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
80106878:	81 e3 00 00 c0 ff    	and    $0xffc00000,%ebx
8010687e:	81 c3 00 00 40 00    	add    $0x400000,%ebx
80106884:	eb 98                	jmp    8010681e <deallocuvm.part.0+0x2e>
        panic("kfree");
80106886:	83 ec 0c             	sub    $0xc,%esp
80106889:	68 66 72 10 80       	push   $0x80107266
8010688e:	e8 fd 9a ff ff       	call   80100390 <panic>
80106893:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010689a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801068a0 <seginit>:
{
801068a0:	55                   	push   %ebp
801068a1:	89 e5                	mov    %esp,%ebp
801068a3:	83 ec 18             	sub    $0x18,%esp
  c = &cpus[cpuid()];
801068a6:	e8 95 d0 ff ff       	call   80103940 <cpuid>
  pd[0] = size-1;
801068ab:	ba 2f 00 00 00       	mov    $0x2f,%edx
801068b0:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
801068b6:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
801068ba:	c7 80 f8 27 11 80 ff 	movl   $0xffff,-0x7feed808(%eax)
801068c1:	ff 00 00 
801068c4:	c7 80 fc 27 11 80 00 	movl   $0xcf9a00,-0x7feed804(%eax)
801068cb:	9a cf 00 
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
801068ce:	c7 80 00 28 11 80 ff 	movl   $0xffff,-0x7feed800(%eax)
801068d5:	ff 00 00 
801068d8:	c7 80 04 28 11 80 00 	movl   $0xcf9200,-0x7feed7fc(%eax)
801068df:	92 cf 00 
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
801068e2:	c7 80 08 28 11 80 ff 	movl   $0xffff,-0x7feed7f8(%eax)
801068e9:	ff 00 00 
801068ec:	c7 80 0c 28 11 80 00 	movl   $0xcffa00,-0x7feed7f4(%eax)
801068f3:	fa cf 00 
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
801068f6:	c7 80 10 28 11 80 ff 	movl   $0xffff,-0x7feed7f0(%eax)
801068fd:	ff 00 00 
80106900:	c7 80 14 28 11 80 00 	movl   $0xcff200,-0x7feed7ec(%eax)
80106907:	f2 cf 00 
  lgdt(c->gdt, sizeof(c->gdt));
8010690a:	05 f0 27 11 80       	add    $0x801127f0,%eax
  pd[1] = (uint)p;
8010690f:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
80106913:	c1 e8 10             	shr    $0x10,%eax
80106916:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
8010691a:	8d 45 f2             	lea    -0xe(%ebp),%eax
8010691d:	0f 01 10             	lgdtl  (%eax)
}
80106920:	c9                   	leave  
80106921:	c3                   	ret    
80106922:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106929:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106930 <switchkvm>:
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80106930:	a1 a4 54 11 80       	mov    0x801154a4,%eax
80106935:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
8010693a:	0f 22 d8             	mov    %eax,%cr3
}
8010693d:	c3                   	ret    
8010693e:	66 90                	xchg   %ax,%ax

80106940 <switchuvm>:
{
80106940:	55                   	push   %ebp
80106941:	89 e5                	mov    %esp,%ebp
80106943:	57                   	push   %edi
80106944:	56                   	push   %esi
80106945:	53                   	push   %ebx
80106946:	83 ec 1c             	sub    $0x1c,%esp
80106949:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(p == 0)
8010694c:	85 db                	test   %ebx,%ebx
8010694e:	0f 84 cb 00 00 00    	je     80106a1f <switchuvm+0xdf>
  if(p->kstack == 0)
80106954:	8b 43 08             	mov    0x8(%ebx),%eax
80106957:	85 c0                	test   %eax,%eax
80106959:	0f 84 da 00 00 00    	je     80106a39 <switchuvm+0xf9>
  if(p->pgdir == 0)
8010695f:	8b 43 04             	mov    0x4(%ebx),%eax
80106962:	85 c0                	test   %eax,%eax
80106964:	0f 84 c2 00 00 00    	je     80106a2c <switchuvm+0xec>
  pushcli();
8010696a:	e8 81 da ff ff       	call   801043f0 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
8010696f:	e8 4c cf ff ff       	call   801038c0 <mycpu>
80106974:	89 c6                	mov    %eax,%esi
80106976:	e8 45 cf ff ff       	call   801038c0 <mycpu>
8010697b:	89 c7                	mov    %eax,%edi
8010697d:	e8 3e cf ff ff       	call   801038c0 <mycpu>
80106982:	83 c7 08             	add    $0x8,%edi
80106985:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106988:	e8 33 cf ff ff       	call   801038c0 <mycpu>
8010698d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80106990:	ba 67 00 00 00       	mov    $0x67,%edx
80106995:	66 89 be 9a 00 00 00 	mov    %di,0x9a(%esi)
8010699c:	83 c0 08             	add    $0x8,%eax
8010699f:	66 89 96 98 00 00 00 	mov    %dx,0x98(%esi)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
801069a6:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
801069ab:	83 c1 08             	add    $0x8,%ecx
801069ae:	c1 e8 18             	shr    $0x18,%eax
801069b1:	c1 e9 10             	shr    $0x10,%ecx
801069b4:	88 86 9f 00 00 00    	mov    %al,0x9f(%esi)
801069ba:	88 8e 9c 00 00 00    	mov    %cl,0x9c(%esi)
801069c0:	b9 99 40 00 00       	mov    $0x4099,%ecx
801069c5:	66 89 8e 9d 00 00 00 	mov    %cx,0x9d(%esi)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
801069cc:	be 10 00 00 00       	mov    $0x10,%esi
  mycpu()->gdt[SEG_TSS].s = 0;
801069d1:	e8 ea ce ff ff       	call   801038c0 <mycpu>
801069d6:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
801069dd:	e8 de ce ff ff       	call   801038c0 <mycpu>
801069e2:	66 89 70 10          	mov    %si,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
801069e6:	8b 73 08             	mov    0x8(%ebx),%esi
801069e9:	81 c6 00 10 00 00    	add    $0x1000,%esi
801069ef:	e8 cc ce ff ff       	call   801038c0 <mycpu>
801069f4:	89 70 0c             	mov    %esi,0xc(%eax)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
801069f7:	e8 c4 ce ff ff       	call   801038c0 <mycpu>
801069fc:	66 89 78 6e          	mov    %di,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
80106a00:	b8 28 00 00 00       	mov    $0x28,%eax
80106a05:	0f 00 d8             	ltr    %ax
  lcr3(V2P(p->pgdir));  // switch to process's address space
80106a08:	8b 43 04             	mov    0x4(%ebx),%eax
80106a0b:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
80106a10:	0f 22 d8             	mov    %eax,%cr3
}
80106a13:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106a16:	5b                   	pop    %ebx
80106a17:	5e                   	pop    %esi
80106a18:	5f                   	pop    %edi
80106a19:	5d                   	pop    %ebp
  popcli();
80106a1a:	e9 21 da ff ff       	jmp    80104440 <popcli>
    panic("switchuvm: no process");
80106a1f:	83 ec 0c             	sub    $0xc,%esp
80106a22:	68 d2 78 10 80       	push   $0x801078d2
80106a27:	e8 64 99 ff ff       	call   80100390 <panic>
    panic("switchuvm: no pgdir");
80106a2c:	83 ec 0c             	sub    $0xc,%esp
80106a2f:	68 fd 78 10 80       	push   $0x801078fd
80106a34:	e8 57 99 ff ff       	call   80100390 <panic>
    panic("switchuvm: no kstack");
80106a39:	83 ec 0c             	sub    $0xc,%esp
80106a3c:	68 e8 78 10 80       	push   $0x801078e8
80106a41:	e8 4a 99 ff ff       	call   80100390 <panic>
80106a46:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106a4d:	8d 76 00             	lea    0x0(%esi),%esi

80106a50 <inituvm>:
{
80106a50:	55                   	push   %ebp
80106a51:	89 e5                	mov    %esp,%ebp
80106a53:	57                   	push   %edi
80106a54:	56                   	push   %esi
80106a55:	53                   	push   %ebx
80106a56:	83 ec 1c             	sub    $0x1c,%esp
80106a59:	8b 45 08             	mov    0x8(%ebp),%eax
80106a5c:	8b 75 10             	mov    0x10(%ebp),%esi
80106a5f:	8b 7d 0c             	mov    0xc(%ebp),%edi
80106a62:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(sz >= PGSIZE)
80106a65:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
80106a6b:	77 49                	ja     80106ab6 <inituvm+0x66>
  mem = kalloc();
80106a6d:	e8 3e bb ff ff       	call   801025b0 <kalloc>
  memset(mem, 0, PGSIZE);
80106a72:	83 ec 04             	sub    $0x4,%esp
80106a75:	68 00 10 00 00       	push   $0x1000
  mem = kalloc();
80106a7a:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
80106a7c:	6a 00                	push   $0x0
80106a7e:	50                   	push   %eax
80106a7f:	e8 6c db ff ff       	call   801045f0 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
80106a84:	58                   	pop    %eax
80106a85:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106a8b:	5a                   	pop    %edx
80106a8c:	6a 06                	push   $0x6
80106a8e:	b9 00 10 00 00       	mov    $0x1000,%ecx
80106a93:	31 d2                	xor    %edx,%edx
80106a95:	50                   	push   %eax
80106a96:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106a99:	e8 c2 fc ff ff       	call   80106760 <mappages>
  memmove(mem, init, sz);
80106a9e:	89 75 10             	mov    %esi,0x10(%ebp)
80106aa1:	83 c4 10             	add    $0x10,%esp
80106aa4:	89 7d 0c             	mov    %edi,0xc(%ebp)
80106aa7:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
80106aaa:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106aad:	5b                   	pop    %ebx
80106aae:	5e                   	pop    %esi
80106aaf:	5f                   	pop    %edi
80106ab0:	5d                   	pop    %ebp
  memmove(mem, init, sz);
80106ab1:	e9 da db ff ff       	jmp    80104690 <memmove>
    panic("inituvm: more than a page");
80106ab6:	83 ec 0c             	sub    $0xc,%esp
80106ab9:	68 11 79 10 80       	push   $0x80107911
80106abe:	e8 cd 98 ff ff       	call   80100390 <panic>
80106ac3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106aca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106ad0 <loaduvm>:
{
80106ad0:	55                   	push   %ebp
80106ad1:	89 e5                	mov    %esp,%ebp
80106ad3:	57                   	push   %edi
80106ad4:	56                   	push   %esi
80106ad5:	53                   	push   %ebx
80106ad6:	83 ec 1c             	sub    $0x1c,%esp
80106ad9:	8b 45 0c             	mov    0xc(%ebp),%eax
80106adc:	8b 75 18             	mov    0x18(%ebp),%esi
  if((uint) addr % PGSIZE != 0)
80106adf:	a9 ff 0f 00 00       	test   $0xfff,%eax
80106ae4:	0f 85 8d 00 00 00    	jne    80106b77 <loaduvm+0xa7>
  for(i = 0; i < sz; i += PGSIZE){
80106aea:	01 f0                	add    %esi,%eax
80106aec:	89 f3                	mov    %esi,%ebx
80106aee:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(readi(ip, P2V(pa), offset+i, n) != n)
80106af1:	8b 45 14             	mov    0x14(%ebp),%eax
80106af4:	01 f0                	add    %esi,%eax
80106af6:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(i = 0; i < sz; i += PGSIZE){
80106af9:	85 f6                	test   %esi,%esi
80106afb:	75 11                	jne    80106b0e <loaduvm+0x3e>
80106afd:	eb 61                	jmp    80106b60 <loaduvm+0x90>
80106aff:	90                   	nop
80106b00:	81 eb 00 10 00 00    	sub    $0x1000,%ebx
80106b06:	89 f0                	mov    %esi,%eax
80106b08:	29 d8                	sub    %ebx,%eax
80106b0a:	39 c6                	cmp    %eax,%esi
80106b0c:	76 52                	jbe    80106b60 <loaduvm+0x90>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80106b0e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80106b11:	8b 45 08             	mov    0x8(%ebp),%eax
80106b14:	31 c9                	xor    %ecx,%ecx
80106b16:	29 da                	sub    %ebx,%edx
80106b18:	e8 c3 fb ff ff       	call   801066e0 <walkpgdir>
80106b1d:	85 c0                	test   %eax,%eax
80106b1f:	74 49                	je     80106b6a <loaduvm+0x9a>
    pa = PTE_ADDR(*pte);
80106b21:	8b 00                	mov    (%eax),%eax
    if(readi(ip, P2V(pa), offset+i, n) != n)
80106b23:	8b 4d e0             	mov    -0x20(%ebp),%ecx
    if(sz - i < PGSIZE)
80106b26:	bf 00 10 00 00       	mov    $0x1000,%edi
    pa = PTE_ADDR(*pte);
80106b2b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(sz - i < PGSIZE)
80106b30:	81 fb ff 0f 00 00    	cmp    $0xfff,%ebx
80106b36:	0f 46 fb             	cmovbe %ebx,%edi
    if(readi(ip, P2V(pa), offset+i, n) != n)
80106b39:	29 d9                	sub    %ebx,%ecx
80106b3b:	05 00 00 00 80       	add    $0x80000000,%eax
80106b40:	57                   	push   %edi
80106b41:	51                   	push   %ecx
80106b42:	50                   	push   %eax
80106b43:	ff 75 10             	pushl  0x10(%ebp)
80106b46:	e8 b5 ae ff ff       	call   80101a00 <readi>
80106b4b:	83 c4 10             	add    $0x10,%esp
80106b4e:	39 f8                	cmp    %edi,%eax
80106b50:	74 ae                	je     80106b00 <loaduvm+0x30>
}
80106b52:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80106b55:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106b5a:	5b                   	pop    %ebx
80106b5b:	5e                   	pop    %esi
80106b5c:	5f                   	pop    %edi
80106b5d:	5d                   	pop    %ebp
80106b5e:	c3                   	ret    
80106b5f:	90                   	nop
80106b60:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80106b63:	31 c0                	xor    %eax,%eax
}
80106b65:	5b                   	pop    %ebx
80106b66:	5e                   	pop    %esi
80106b67:	5f                   	pop    %edi
80106b68:	5d                   	pop    %ebp
80106b69:	c3                   	ret    
      panic("loaduvm: address should exist");
80106b6a:	83 ec 0c             	sub    $0xc,%esp
80106b6d:	68 2b 79 10 80       	push   $0x8010792b
80106b72:	e8 19 98 ff ff       	call   80100390 <panic>
    panic("loaduvm: addr must be page aligned");
80106b77:	83 ec 0c             	sub    $0xc,%esp
80106b7a:	68 cc 79 10 80       	push   $0x801079cc
80106b7f:	e8 0c 98 ff ff       	call   80100390 <panic>
80106b84:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106b8b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106b8f:	90                   	nop

80106b90 <allocuvm>:
{
80106b90:	55                   	push   %ebp
80106b91:	89 e5                	mov    %esp,%ebp
80106b93:	57                   	push   %edi
80106b94:	56                   	push   %esi
80106b95:	53                   	push   %ebx
80106b96:	83 ec 1c             	sub    $0x1c,%esp
  if(newsz >= KERNBASE)
80106b99:	8b 7d 10             	mov    0x10(%ebp),%edi
80106b9c:	85 ff                	test   %edi,%edi
80106b9e:	0f 88 bc 00 00 00    	js     80106c60 <allocuvm+0xd0>
  if(newsz < oldsz)
80106ba4:	3b 7d 0c             	cmp    0xc(%ebp),%edi
80106ba7:	0f 82 a3 00 00 00    	jb     80106c50 <allocuvm+0xc0>
  a = PGROUNDUP(oldsz);
80106bad:	8b 45 0c             	mov    0xc(%ebp),%eax
80106bb0:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80106bb6:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; a < newsz; a += PGSIZE){
80106bbc:	39 5d 10             	cmp    %ebx,0x10(%ebp)
80106bbf:	0f 86 8e 00 00 00    	jbe    80106c53 <allocuvm+0xc3>
80106bc5:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80106bc8:	8b 7d 08             	mov    0x8(%ebp),%edi
80106bcb:	eb 42                	jmp    80106c0f <allocuvm+0x7f>
80106bcd:	8d 76 00             	lea    0x0(%esi),%esi
    memset(mem, 0, PGSIZE);
80106bd0:	83 ec 04             	sub    $0x4,%esp
80106bd3:	68 00 10 00 00       	push   $0x1000
80106bd8:	6a 00                	push   $0x0
80106bda:	50                   	push   %eax
80106bdb:	e8 10 da ff ff       	call   801045f0 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
80106be0:	58                   	pop    %eax
80106be1:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
80106be7:	5a                   	pop    %edx
80106be8:	6a 06                	push   $0x6
80106bea:	b9 00 10 00 00       	mov    $0x1000,%ecx
80106bef:	89 da                	mov    %ebx,%edx
80106bf1:	50                   	push   %eax
80106bf2:	89 f8                	mov    %edi,%eax
80106bf4:	e8 67 fb ff ff       	call   80106760 <mappages>
80106bf9:	83 c4 10             	add    $0x10,%esp
80106bfc:	85 c0                	test   %eax,%eax
80106bfe:	78 70                	js     80106c70 <allocuvm+0xe0>
  for(; a < newsz; a += PGSIZE){
80106c00:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106c06:	39 5d 10             	cmp    %ebx,0x10(%ebp)
80106c09:	0f 86 a1 00 00 00    	jbe    80106cb0 <allocuvm+0x120>
    mem = kalloc();
80106c0f:	e8 9c b9 ff ff       	call   801025b0 <kalloc>
80106c14:	89 c6                	mov    %eax,%esi
    if(mem == 0){
80106c16:	85 c0                	test   %eax,%eax
80106c18:	75 b6                	jne    80106bd0 <allocuvm+0x40>
      cprintf("allocuvm out of memory\n");
80106c1a:	83 ec 0c             	sub    $0xc,%esp
80106c1d:	68 49 79 10 80       	push   $0x80107949
80106c22:	e8 89 9a ff ff       	call   801006b0 <cprintf>
  if(newsz >= oldsz)
80106c27:	83 c4 10             	add    $0x10,%esp
80106c2a:	8b 45 0c             	mov    0xc(%ebp),%eax
80106c2d:	39 45 10             	cmp    %eax,0x10(%ebp)
80106c30:	74 2e                	je     80106c60 <allocuvm+0xd0>
80106c32:	89 c1                	mov    %eax,%ecx
80106c34:	8b 55 10             	mov    0x10(%ebp),%edx
80106c37:	8b 45 08             	mov    0x8(%ebp),%eax
      return 0;
80106c3a:	31 ff                	xor    %edi,%edi
80106c3c:	e8 af fb ff ff       	call   801067f0 <deallocuvm.part.0>
}
80106c41:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106c44:	89 f8                	mov    %edi,%eax
80106c46:	5b                   	pop    %ebx
80106c47:	5e                   	pop    %esi
80106c48:	5f                   	pop    %edi
80106c49:	5d                   	pop    %ebp
80106c4a:	c3                   	ret    
80106c4b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106c4f:	90                   	nop
    return oldsz;
80106c50:	8b 7d 0c             	mov    0xc(%ebp),%edi
}
80106c53:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106c56:	89 f8                	mov    %edi,%eax
80106c58:	5b                   	pop    %ebx
80106c59:	5e                   	pop    %esi
80106c5a:	5f                   	pop    %edi
80106c5b:	5d                   	pop    %ebp
80106c5c:	c3                   	ret    
80106c5d:	8d 76 00             	lea    0x0(%esi),%esi
80106c60:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
80106c63:	31 ff                	xor    %edi,%edi
}
80106c65:	5b                   	pop    %ebx
80106c66:	89 f8                	mov    %edi,%eax
80106c68:	5e                   	pop    %esi
80106c69:	5f                   	pop    %edi
80106c6a:	5d                   	pop    %ebp
80106c6b:	c3                   	ret    
80106c6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      cprintf("allocuvm out of memory (2)\n");
80106c70:	83 ec 0c             	sub    $0xc,%esp
80106c73:	68 61 79 10 80       	push   $0x80107961
80106c78:	e8 33 9a ff ff       	call   801006b0 <cprintf>
  if(newsz >= oldsz)
80106c7d:	83 c4 10             	add    $0x10,%esp
80106c80:	8b 45 0c             	mov    0xc(%ebp),%eax
80106c83:	39 45 10             	cmp    %eax,0x10(%ebp)
80106c86:	74 0d                	je     80106c95 <allocuvm+0x105>
80106c88:	89 c1                	mov    %eax,%ecx
80106c8a:	8b 55 10             	mov    0x10(%ebp),%edx
80106c8d:	8b 45 08             	mov    0x8(%ebp),%eax
80106c90:	e8 5b fb ff ff       	call   801067f0 <deallocuvm.part.0>
      kfree(mem);
80106c95:	83 ec 0c             	sub    $0xc,%esp
      return 0;
80106c98:	31 ff                	xor    %edi,%edi
      kfree(mem);
80106c9a:	56                   	push   %esi
80106c9b:	e8 50 b7 ff ff       	call   801023f0 <kfree>
      return 0;
80106ca0:	83 c4 10             	add    $0x10,%esp
}
80106ca3:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106ca6:	89 f8                	mov    %edi,%eax
80106ca8:	5b                   	pop    %ebx
80106ca9:	5e                   	pop    %esi
80106caa:	5f                   	pop    %edi
80106cab:	5d                   	pop    %ebp
80106cac:	c3                   	ret    
80106cad:	8d 76 00             	lea    0x0(%esi),%esi
80106cb0:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80106cb3:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106cb6:	5b                   	pop    %ebx
80106cb7:	5e                   	pop    %esi
80106cb8:	89 f8                	mov    %edi,%eax
80106cba:	5f                   	pop    %edi
80106cbb:	5d                   	pop    %ebp
80106cbc:	c3                   	ret    
80106cbd:	8d 76 00             	lea    0x0(%esi),%esi

80106cc0 <deallocuvm>:
{
80106cc0:	55                   	push   %ebp
80106cc1:	89 e5                	mov    %esp,%ebp
80106cc3:	8b 55 0c             	mov    0xc(%ebp),%edx
80106cc6:	8b 4d 10             	mov    0x10(%ebp),%ecx
80106cc9:	8b 45 08             	mov    0x8(%ebp),%eax
  if(newsz >= oldsz)
80106ccc:	39 d1                	cmp    %edx,%ecx
80106cce:	73 10                	jae    80106ce0 <deallocuvm+0x20>
}
80106cd0:	5d                   	pop    %ebp
80106cd1:	e9 1a fb ff ff       	jmp    801067f0 <deallocuvm.part.0>
80106cd6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106cdd:	8d 76 00             	lea    0x0(%esi),%esi
80106ce0:	89 d0                	mov    %edx,%eax
80106ce2:	5d                   	pop    %ebp
80106ce3:	c3                   	ret    
80106ce4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106ceb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106cef:	90                   	nop

80106cf0 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80106cf0:	55                   	push   %ebp
80106cf1:	89 e5                	mov    %esp,%ebp
80106cf3:	57                   	push   %edi
80106cf4:	56                   	push   %esi
80106cf5:	53                   	push   %ebx
80106cf6:	83 ec 0c             	sub    $0xc,%esp
80106cf9:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
80106cfc:	85 f6                	test   %esi,%esi
80106cfe:	74 59                	je     80106d59 <freevm+0x69>
  if(newsz >= oldsz)
80106d00:	31 c9                	xor    %ecx,%ecx
80106d02:	ba 00 00 00 80       	mov    $0x80000000,%edx
80106d07:	89 f0                	mov    %esi,%eax
80106d09:	89 f3                	mov    %esi,%ebx
80106d0b:	e8 e0 fa ff ff       	call   801067f0 <deallocuvm.part.0>
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80106d10:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
80106d16:	eb 0f                	jmp    80106d27 <freevm+0x37>
80106d18:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106d1f:	90                   	nop
80106d20:	83 c3 04             	add    $0x4,%ebx
80106d23:	39 df                	cmp    %ebx,%edi
80106d25:	74 23                	je     80106d4a <freevm+0x5a>
    if(pgdir[i] & PTE_P){
80106d27:	8b 03                	mov    (%ebx),%eax
80106d29:	a8 01                	test   $0x1,%al
80106d2b:	74 f3                	je     80106d20 <freevm+0x30>
      char * v = P2V(PTE_ADDR(pgdir[i]));
80106d2d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
      kfree(v);
80106d32:	83 ec 0c             	sub    $0xc,%esp
80106d35:	83 c3 04             	add    $0x4,%ebx
      char * v = P2V(PTE_ADDR(pgdir[i]));
80106d38:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
80106d3d:	50                   	push   %eax
80106d3e:	e8 ad b6 ff ff       	call   801023f0 <kfree>
80106d43:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
80106d46:	39 df                	cmp    %ebx,%edi
80106d48:	75 dd                	jne    80106d27 <freevm+0x37>
    }
  }
  kfree((char*)pgdir);
80106d4a:	89 75 08             	mov    %esi,0x8(%ebp)
}
80106d4d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106d50:	5b                   	pop    %ebx
80106d51:	5e                   	pop    %esi
80106d52:	5f                   	pop    %edi
80106d53:	5d                   	pop    %ebp
  kfree((char*)pgdir);
80106d54:	e9 97 b6 ff ff       	jmp    801023f0 <kfree>
    panic("freevm: no pgdir");
80106d59:	83 ec 0c             	sub    $0xc,%esp
80106d5c:	68 7d 79 10 80       	push   $0x8010797d
80106d61:	e8 2a 96 ff ff       	call   80100390 <panic>
80106d66:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106d6d:	8d 76 00             	lea    0x0(%esi),%esi

80106d70 <setupkvm>:
{
80106d70:	55                   	push   %ebp
80106d71:	89 e5                	mov    %esp,%ebp
80106d73:	56                   	push   %esi
80106d74:	53                   	push   %ebx
  if((pgdir = (pde_t*)kalloc()) == 0)
80106d75:	e8 36 b8 ff ff       	call   801025b0 <kalloc>
80106d7a:	89 c6                	mov    %eax,%esi
80106d7c:	85 c0                	test   %eax,%eax
80106d7e:	74 42                	je     80106dc2 <setupkvm+0x52>
  memset(pgdir, 0, PGSIZE);
80106d80:	83 ec 04             	sub    $0x4,%esp
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80106d83:	bb 20 a4 10 80       	mov    $0x8010a420,%ebx
  memset(pgdir, 0, PGSIZE);
80106d88:	68 00 10 00 00       	push   $0x1000
80106d8d:	6a 00                	push   $0x0
80106d8f:	50                   	push   %eax
80106d90:	e8 5b d8 ff ff       	call   801045f0 <memset>
80106d95:	83 c4 10             	add    $0x10,%esp
                (uint)k->phys_start, k->perm) < 0) {
80106d98:	8b 43 04             	mov    0x4(%ebx),%eax
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
80106d9b:	83 ec 08             	sub    $0x8,%esp
80106d9e:	8b 4b 08             	mov    0x8(%ebx),%ecx
80106da1:	ff 73 0c             	pushl  0xc(%ebx)
80106da4:	8b 13                	mov    (%ebx),%edx
80106da6:	50                   	push   %eax
80106da7:	29 c1                	sub    %eax,%ecx
80106da9:	89 f0                	mov    %esi,%eax
80106dab:	e8 b0 f9 ff ff       	call   80106760 <mappages>
80106db0:	83 c4 10             	add    $0x10,%esp
80106db3:	85 c0                	test   %eax,%eax
80106db5:	78 19                	js     80106dd0 <setupkvm+0x60>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80106db7:	83 c3 10             	add    $0x10,%ebx
80106dba:	81 fb 60 a4 10 80    	cmp    $0x8010a460,%ebx
80106dc0:	75 d6                	jne    80106d98 <setupkvm+0x28>
}
80106dc2:	8d 65 f8             	lea    -0x8(%ebp),%esp
80106dc5:	89 f0                	mov    %esi,%eax
80106dc7:	5b                   	pop    %ebx
80106dc8:	5e                   	pop    %esi
80106dc9:	5d                   	pop    %ebp
80106dca:	c3                   	ret    
80106dcb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106dcf:	90                   	nop
      freevm(pgdir);
80106dd0:	83 ec 0c             	sub    $0xc,%esp
80106dd3:	56                   	push   %esi
      return 0;
80106dd4:	31 f6                	xor    %esi,%esi
      freevm(pgdir);
80106dd6:	e8 15 ff ff ff       	call   80106cf0 <freevm>
      return 0;
80106ddb:	83 c4 10             	add    $0x10,%esp
}
80106dde:	8d 65 f8             	lea    -0x8(%ebp),%esp
80106de1:	89 f0                	mov    %esi,%eax
80106de3:	5b                   	pop    %ebx
80106de4:	5e                   	pop    %esi
80106de5:	5d                   	pop    %ebp
80106de6:	c3                   	ret    
80106de7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106dee:	66 90                	xchg   %ax,%ax

80106df0 <kvmalloc>:
{
80106df0:	55                   	push   %ebp
80106df1:	89 e5                	mov    %esp,%ebp
80106df3:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80106df6:	e8 75 ff ff ff       	call   80106d70 <setupkvm>
80106dfb:	a3 a4 54 11 80       	mov    %eax,0x801154a4
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80106e00:	05 00 00 00 80       	add    $0x80000000,%eax
80106e05:	0f 22 d8             	mov    %eax,%cr3
}
80106e08:	c9                   	leave  
80106e09:	c3                   	ret    
80106e0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106e10 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80106e10:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80106e11:	31 c9                	xor    %ecx,%ecx
{
80106e13:	89 e5                	mov    %esp,%ebp
80106e15:	83 ec 08             	sub    $0x8,%esp
  pte = walkpgdir(pgdir, uva, 0);
80106e18:	8b 55 0c             	mov    0xc(%ebp),%edx
80106e1b:	8b 45 08             	mov    0x8(%ebp),%eax
80106e1e:	e8 bd f8 ff ff       	call   801066e0 <walkpgdir>
  if(pte == 0)
80106e23:	85 c0                	test   %eax,%eax
80106e25:	74 05                	je     80106e2c <clearpteu+0x1c>
    panic("clearpteu");
  *pte &= ~PTE_U;
80106e27:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
80106e2a:	c9                   	leave  
80106e2b:	c3                   	ret    
    panic("clearpteu");
80106e2c:	83 ec 0c             	sub    $0xc,%esp
80106e2f:	68 8e 79 10 80       	push   $0x8010798e
80106e34:	e8 57 95 ff ff       	call   80100390 <panic>
80106e39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106e40 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80106e40:	55                   	push   %ebp
80106e41:	89 e5                	mov    %esp,%ebp
80106e43:	57                   	push   %edi
80106e44:	56                   	push   %esi
80106e45:	53                   	push   %ebx
80106e46:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
80106e49:	e8 22 ff ff ff       	call   80106d70 <setupkvm>
80106e4e:	89 45 e0             	mov    %eax,-0x20(%ebp)
80106e51:	85 c0                	test   %eax,%eax
80106e53:	0f 84 9f 00 00 00    	je     80106ef8 <copyuvm+0xb8>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80106e59:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80106e5c:	85 c9                	test   %ecx,%ecx
80106e5e:	0f 84 94 00 00 00    	je     80106ef8 <copyuvm+0xb8>
80106e64:	31 ff                	xor    %edi,%edi
80106e66:	eb 4a                	jmp    80106eb2 <copyuvm+0x72>
80106e68:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106e6f:	90                   	nop
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
80106e70:	83 ec 04             	sub    $0x4,%esp
80106e73:	81 c3 00 00 00 80    	add    $0x80000000,%ebx
80106e79:	68 00 10 00 00       	push   $0x1000
80106e7e:	53                   	push   %ebx
80106e7f:	50                   	push   %eax
80106e80:	e8 0b d8 ff ff       	call   80104690 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
80106e85:	58                   	pop    %eax
80106e86:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
80106e8c:	5a                   	pop    %edx
80106e8d:	ff 75 e4             	pushl  -0x1c(%ebp)
80106e90:	b9 00 10 00 00       	mov    $0x1000,%ecx
80106e95:	89 fa                	mov    %edi,%edx
80106e97:	50                   	push   %eax
80106e98:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106e9b:	e8 c0 f8 ff ff       	call   80106760 <mappages>
80106ea0:	83 c4 10             	add    $0x10,%esp
80106ea3:	85 c0                	test   %eax,%eax
80106ea5:	78 61                	js     80106f08 <copyuvm+0xc8>
  for(i = 0; i < sz; i += PGSIZE){
80106ea7:	81 c7 00 10 00 00    	add    $0x1000,%edi
80106ead:	39 7d 0c             	cmp    %edi,0xc(%ebp)
80106eb0:	76 46                	jbe    80106ef8 <copyuvm+0xb8>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80106eb2:	8b 45 08             	mov    0x8(%ebp),%eax
80106eb5:	31 c9                	xor    %ecx,%ecx
80106eb7:	89 fa                	mov    %edi,%edx
80106eb9:	e8 22 f8 ff ff       	call   801066e0 <walkpgdir>
80106ebe:	85 c0                	test   %eax,%eax
80106ec0:	74 61                	je     80106f23 <copyuvm+0xe3>
    if(!(*pte & PTE_P))
80106ec2:	8b 00                	mov    (%eax),%eax
80106ec4:	a8 01                	test   $0x1,%al
80106ec6:	74 4e                	je     80106f16 <copyuvm+0xd6>
    pa = PTE_ADDR(*pte);
80106ec8:	89 c3                	mov    %eax,%ebx
    flags = PTE_FLAGS(*pte);
80106eca:	25 ff 0f 00 00       	and    $0xfff,%eax
80106ecf:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    pa = PTE_ADDR(*pte);
80106ed2:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
    if((mem = kalloc()) == 0)
80106ed8:	e8 d3 b6 ff ff       	call   801025b0 <kalloc>
80106edd:	89 c6                	mov    %eax,%esi
80106edf:	85 c0                	test   %eax,%eax
80106ee1:	75 8d                	jne    80106e70 <copyuvm+0x30>
    }
  }
  return d;

bad:
  freevm(d);
80106ee3:	83 ec 0c             	sub    $0xc,%esp
80106ee6:	ff 75 e0             	pushl  -0x20(%ebp)
80106ee9:	e8 02 fe ff ff       	call   80106cf0 <freevm>
  return 0;
80106eee:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
80106ef5:	83 c4 10             	add    $0x10,%esp
}
80106ef8:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106efb:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106efe:	5b                   	pop    %ebx
80106eff:	5e                   	pop    %esi
80106f00:	5f                   	pop    %edi
80106f01:	5d                   	pop    %ebp
80106f02:	c3                   	ret    
80106f03:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106f07:	90                   	nop
      kfree(mem);
80106f08:	83 ec 0c             	sub    $0xc,%esp
80106f0b:	56                   	push   %esi
80106f0c:	e8 df b4 ff ff       	call   801023f0 <kfree>
      goto bad;
80106f11:	83 c4 10             	add    $0x10,%esp
80106f14:	eb cd                	jmp    80106ee3 <copyuvm+0xa3>
      panic("copyuvm: page not present");
80106f16:	83 ec 0c             	sub    $0xc,%esp
80106f19:	68 b2 79 10 80       	push   $0x801079b2
80106f1e:	e8 6d 94 ff ff       	call   80100390 <panic>
      panic("copyuvm: pte should exist");
80106f23:	83 ec 0c             	sub    $0xc,%esp
80106f26:	68 98 79 10 80       	push   $0x80107998
80106f2b:	e8 60 94 ff ff       	call   80100390 <panic>

80106f30 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80106f30:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80106f31:	31 c9                	xor    %ecx,%ecx
{
80106f33:	89 e5                	mov    %esp,%ebp
80106f35:	83 ec 08             	sub    $0x8,%esp
  pte = walkpgdir(pgdir, uva, 0);
80106f38:	8b 55 0c             	mov    0xc(%ebp),%edx
80106f3b:	8b 45 08             	mov    0x8(%ebp),%eax
80106f3e:	e8 9d f7 ff ff       	call   801066e0 <walkpgdir>
  if((*pte & PTE_P) == 0)
80106f43:	8b 00                	mov    (%eax),%eax
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
}
80106f45:	c9                   	leave  
  if((*pte & PTE_U) == 0)
80106f46:	89 c2                	mov    %eax,%edx
  return (char*)P2V(PTE_ADDR(*pte));
80106f48:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  if((*pte & PTE_U) == 0)
80106f4d:	83 e2 05             	and    $0x5,%edx
  return (char*)P2V(PTE_ADDR(*pte));
80106f50:	05 00 00 00 80       	add    $0x80000000,%eax
80106f55:	83 fa 05             	cmp    $0x5,%edx
80106f58:	ba 00 00 00 00       	mov    $0x0,%edx
80106f5d:	0f 45 c2             	cmovne %edx,%eax
}
80106f60:	c3                   	ret    
80106f61:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106f68:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106f6f:	90                   	nop

80106f70 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80106f70:	55                   	push   %ebp
80106f71:	89 e5                	mov    %esp,%ebp
80106f73:	57                   	push   %edi
80106f74:	56                   	push   %esi
80106f75:	53                   	push   %ebx
80106f76:	83 ec 0c             	sub    $0xc,%esp
80106f79:	8b 75 14             	mov    0x14(%ebp),%esi
80106f7c:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80106f7f:	85 f6                	test   %esi,%esi
80106f81:	75 38                	jne    80106fbb <copyout+0x4b>
80106f83:	eb 6b                	jmp    80106ff0 <copyout+0x80>
80106f85:	8d 76 00             	lea    0x0(%esi),%esi
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (va - va0);
80106f88:	8b 55 0c             	mov    0xc(%ebp),%edx
80106f8b:	89 fb                	mov    %edi,%ebx
80106f8d:	29 d3                	sub    %edx,%ebx
80106f8f:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    if(n > len)
80106f95:	39 f3                	cmp    %esi,%ebx
80106f97:	0f 47 de             	cmova  %esi,%ebx
      n = len;
    memmove(pa0 + (va - va0), buf, n);
80106f9a:	29 fa                	sub    %edi,%edx
80106f9c:	83 ec 04             	sub    $0x4,%esp
80106f9f:	01 c2                	add    %eax,%edx
80106fa1:	53                   	push   %ebx
80106fa2:	ff 75 10             	pushl  0x10(%ebp)
80106fa5:	52                   	push   %edx
80106fa6:	e8 e5 d6 ff ff       	call   80104690 <memmove>
    len -= n;
    buf += n;
80106fab:	01 5d 10             	add    %ebx,0x10(%ebp)
    va = va0 + PGSIZE;
80106fae:	8d 97 00 10 00 00    	lea    0x1000(%edi),%edx
  while(len > 0){
80106fb4:	83 c4 10             	add    $0x10,%esp
80106fb7:	29 de                	sub    %ebx,%esi
80106fb9:	74 35                	je     80106ff0 <copyout+0x80>
    va0 = (uint)PGROUNDDOWN(va);
80106fbb:	89 d7                	mov    %edx,%edi
    pa0 = uva2ka(pgdir, (char*)va0);
80106fbd:	83 ec 08             	sub    $0x8,%esp
    va0 = (uint)PGROUNDDOWN(va);
80106fc0:	89 55 0c             	mov    %edx,0xc(%ebp)
80106fc3:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    pa0 = uva2ka(pgdir, (char*)va0);
80106fc9:	57                   	push   %edi
80106fca:	ff 75 08             	pushl  0x8(%ebp)
80106fcd:	e8 5e ff ff ff       	call   80106f30 <uva2ka>
    if(pa0 == 0)
80106fd2:	83 c4 10             	add    $0x10,%esp
80106fd5:	85 c0                	test   %eax,%eax
80106fd7:	75 af                	jne    80106f88 <copyout+0x18>
  }
  return 0;
}
80106fd9:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80106fdc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106fe1:	5b                   	pop    %ebx
80106fe2:	5e                   	pop    %esi
80106fe3:	5f                   	pop    %edi
80106fe4:	5d                   	pop    %ebp
80106fe5:	c3                   	ret    
80106fe6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106fed:	8d 76 00             	lea    0x0(%esi),%esi
80106ff0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80106ff3:	31 c0                	xor    %eax,%eax
}
80106ff5:	5b                   	pop    %ebx
80106ff6:	5e                   	pop    %esi
80106ff7:	5f                   	pop    %edi
80106ff8:	5d                   	pop    %ebp
80106ff9:	c3                   	ret    
