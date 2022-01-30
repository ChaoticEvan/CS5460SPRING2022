
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
8010002d:	b8 00 30 10 80       	mov    $0x80103000,%eax
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
8010004c:	68 e0 6f 10 80       	push   $0x80106fe0
80100051:	68 c0 b5 10 80       	push   $0x8010b5c0
80100056:	e8 f5 42 00 00       	call   80104350 <initlock>
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
80100092:	68 e7 6f 10 80       	push   $0x80106fe7
80100097:	50                   	push   %eax
80100098:	e8 83 41 00 00       	call   80104220 <initsleeplock>
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
801000e4:	e8 c7 43 00 00       	call   801044b0 <acquire>
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
80100162:	e8 09 44 00 00       	call   80104570 <release>
      acquiresleep(&b->lock);
80100167:	8d 43 0c             	lea    0xc(%ebx),%eax
8010016a:	89 04 24             	mov    %eax,(%esp)
8010016d:	e8 ee 40 00 00       	call   80104260 <acquiresleep>
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
801001a3:	68 ee 6f 10 80       	push   $0x80106fee
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
801001be:	e8 3d 41 00 00       	call   80104300 <holdingsleep>
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
801001dc:	68 ff 6f 10 80       	push   $0x80106fff
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
801001ff:	e8 fc 40 00 00       	call   80104300 <holdingsleep>
80100204:	83 c4 10             	add    $0x10,%esp
80100207:	85 c0                	test   %eax,%eax
80100209:	74 66                	je     80100271 <brelse+0x81>
    panic("brelse");

  releasesleep(&b->lock);
8010020b:	83 ec 0c             	sub    $0xc,%esp
8010020e:	56                   	push   %esi
8010020f:	e8 ac 40 00 00       	call   801042c0 <releasesleep>

  acquire(&bcache.lock);
80100214:	c7 04 24 c0 b5 10 80 	movl   $0x8010b5c0,(%esp)
8010021b:	e8 90 42 00 00       	call   801044b0 <acquire>
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
8010026c:	e9 ff 42 00 00       	jmp    80104570 <release>
    panic("brelse");
80100271:	83 ec 0c             	sub    $0xc,%esp
80100274:	68 06 70 10 80       	push   $0x80107006
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
8010029b:	e8 10 42 00 00       	call   801044b0 <acquire>
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
801002d5:	e8 f6 3b 00 00       	call   80103ed0 <sleep>
    while(input.r == input.w){
801002da:	8b 15 a0 ff 10 80    	mov    0x8010ffa0,%edx
801002e0:	83 c4 10             	add    $0x10,%esp
801002e3:	3b 15 a4 ff 10 80    	cmp    0x8010ffa4,%edx
801002e9:	75 35                	jne    80100320 <consoleread+0xa0>
      if(myproc()->killed){
801002eb:	e8 40 36 00 00       	call   80103930 <myproc>
801002f0:	8b 48 24             	mov    0x24(%eax),%ecx
801002f3:	85 c9                	test   %ecx,%ecx
801002f5:	74 d1                	je     801002c8 <consoleread+0x48>
        release(&cons.lock);
801002f7:	83 ec 0c             	sub    $0xc,%esp
801002fa:	68 20 a5 10 80       	push   $0x8010a520
801002ff:	e8 6c 42 00 00       	call   80104570 <release>
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
8010035d:	e8 0e 42 00 00       	call   80104570 <release>
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
801003a9:	e8 d2 24 00 00       	call   80102880 <lapicid>
801003ae:	83 ec 08             	sub    $0x8,%esp
801003b1:	50                   	push   %eax
801003b2:	68 0d 70 10 80       	push   $0x8010700d
801003b7:	e8 f4 02 00 00       	call   801006b0 <cprintf>
  cprintf(s);
801003bc:	58                   	pop    %eax
801003bd:	ff 75 08             	pushl  0x8(%ebp)
801003c0:	e8 eb 02 00 00       	call   801006b0 <cprintf>
  cprintf("\n");
801003c5:	c7 04 24 5b 79 10 80 	movl   $0x8010795b,(%esp)
801003cc:	e8 df 02 00 00       	call   801006b0 <cprintf>
  getcallerpcs(&s, pcs);
801003d1:	8d 45 08             	lea    0x8(%ebp),%eax
801003d4:	5a                   	pop    %edx
801003d5:	59                   	pop    %ecx
801003d6:	53                   	push   %ebx
801003d7:	50                   	push   %eax
801003d8:	e8 93 3f 00 00       	call   80104370 <getcallerpcs>
  for(i=0; i<10; i++)
801003dd:	83 c4 10             	add    $0x10,%esp
    cprintf(" %p", pcs[i]);
801003e0:	83 ec 08             	sub    $0x8,%esp
801003e3:	ff 33                	pushl  (%ebx)
801003e5:	83 c3 04             	add    $0x4,%ebx
801003e8:	68 21 70 10 80       	push   $0x80107021
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
8010042a:	e8 c1 57 00 00       	call   80105bf0 <uartputc>
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
80100515:	e8 d6 56 00 00       	call   80105bf0 <uartputc>
8010051a:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80100521:	e8 ca 56 00 00       	call   80105bf0 <uartputc>
80100526:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
8010052d:	e8 be 56 00 00       	call   80105bf0 <uartputc>
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
80100561:	e8 fa 40 00 00       	call   80104660 <memmove>
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100566:	b8 80 07 00 00       	mov    $0x780,%eax
8010056b:	83 c4 0c             	add    $0xc,%esp
8010056e:	29 d8                	sub    %ebx,%eax
80100570:	01 c0                	add    %eax,%eax
80100572:	50                   	push   %eax
80100573:	6a 00                	push   $0x0
80100575:	56                   	push   %esi
80100576:	e8 45 40 00 00       	call   801045c0 <memset>
8010057b:	88 5d e7             	mov    %bl,-0x19(%ebp)
8010057e:	83 c4 10             	add    $0x10,%esp
80100581:	e9 22 ff ff ff       	jmp    801004a8 <consputc.part.0+0x98>
    panic("pos under/overflow");
80100586:	83 ec 0c             	sub    $0xc,%esp
80100589:	68 25 70 10 80       	push   $0x80107025
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
801005ca:	0f b6 92 50 70 10 80 	movzbl -0x7fef8fb0(%edx),%edx
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
8010064e:	e8 5d 3e 00 00       	call   801044b0 <acquire>
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
80100698:	e8 d3 3e 00 00       	call   80104570 <release>
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
8010077a:	bb 38 70 10 80       	mov    $0x80107038,%ebx
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
801007b0:	e8 fb 3c 00 00       	call   801044b0 <acquire>
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
80100828:	e8 43 3d 00 00       	call   80104570 <release>
8010082d:	83 c4 10             	add    $0x10,%esp
}
80100830:	e9 e6 fe ff ff       	jmp    8010071b <cprintf+0x6b>
    panic("null fmt");
80100835:	83 ec 0c             	sub    $0xc,%esp
80100838:	68 3f 70 10 80       	push   $0x8010703f
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
80100873:	e8 38 3c 00 00       	call   801044b0 <acquire>
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
801009c7:	e8 a4 3b 00 00       	call   80104570 <release>
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
80100a0c:	e8 6f 36 00 00       	call   80104080 <wakeup>
80100a11:	83 c4 10             	add    $0x10,%esp
80100a14:	e9 62 fe ff ff       	jmp    8010087b <consoleintr+0x1b>
}
80100a19:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100a1c:	5b                   	pop    %ebx
80100a1d:	5e                   	pop    %esi
80100a1e:	5f                   	pop    %edi
80100a1f:	5d                   	pop    %ebp
    procdump();  // now call procdump() wo. cons.lock held
80100a20:	e9 3b 37 00 00       	jmp    80104160 <procdump>
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
80100a36:	68 48 70 10 80       	push   $0x80107048
80100a3b:	68 20 a5 10 80       	push   $0x8010a520
80100a40:	e8 0b 39 00 00       	call   80104350 <initlock>

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
80100a8c:	e8 9f 2e 00 00       	call   80103930 <myproc>
80100a91:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)

  begin_op();
80100a97:	e8 54 22 00 00       	call   80102cf0 <begin_op>

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
80100adf:	e8 7c 22 00 00       	call   80102d60 <end_op>
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
80100b04:	e8 37 62 00 00       	call   80106d40 <setupkvm>
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
80100b73:	e8 e8 5f 00 00       	call   80106b60 <allocuvm>
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
80100ba9:	e8 f2 5e 00 00       	call   80106aa0 <loaduvm>
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
80100beb:	e8 d0 60 00 00       	call   80106cc0 <freevm>
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
80100c21:	e8 3a 21 00 00       	call   80102d60 <end_op>
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100c26:	83 c4 0c             	add    $0xc,%esp
80100c29:	56                   	push   %esi
80100c2a:	57                   	push   %edi
80100c2b:	8b bd f4 fe ff ff    	mov    -0x10c(%ebp),%edi
80100c31:	57                   	push   %edi
80100c32:	e8 29 5f 00 00       	call   80106b60 <allocuvm>
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
80100c53:	e8 88 61 00 00       	call   80106de0 <clearpteu>
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
80100ca3:	e8 28 3b 00 00       	call   801047d0 <strlen>
80100ca8:	f7 d0                	not    %eax
80100caa:	01 c3                	add    %eax,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100cac:	58                   	pop    %eax
80100cad:	8b 45 0c             	mov    0xc(%ebp),%eax
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100cb0:	83 e3 fc             	and    $0xfffffffc,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100cb3:	ff 34 b8             	pushl  (%eax,%edi,4)
80100cb6:	e8 15 3b 00 00       	call   801047d0 <strlen>
80100cbb:	83 c0 01             	add    $0x1,%eax
80100cbe:	50                   	push   %eax
80100cbf:	8b 45 0c             	mov    0xc(%ebp),%eax
80100cc2:	ff 34 b8             	pushl  (%eax,%edi,4)
80100cc5:	53                   	push   %ebx
80100cc6:	56                   	push   %esi
80100cc7:	e8 74 62 00 00       	call   80106f40 <copyout>
80100ccc:	83 c4 20             	add    $0x20,%esp
80100ccf:	85 c0                	test   %eax,%eax
80100cd1:	79 ad                	jns    80100c80 <exec+0x200>
80100cd3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100cd7:	90                   	nop
    freevm(pgdir);
80100cd8:	83 ec 0c             	sub    $0xc,%esp
80100cdb:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100ce1:	e8 da 5f 00 00       	call   80106cc0 <freevm>
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
80100d33:	e8 08 62 00 00       	call   80106f40 <copyout>
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
80100d71:	e8 1a 3a 00 00       	call   80104790 <safestrcpy>
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
80100d9d:	e8 6e 5b 00 00       	call   80106910 <switchuvm>
  freevm(oldpgdir);
80100da2:	89 3c 24             	mov    %edi,(%esp)
80100da5:	e8 16 5f 00 00       	call   80106cc0 <freevm>
  return 0;
80100daa:	83 c4 10             	add    $0x10,%esp
80100dad:	31 c0                	xor    %eax,%eax
80100daf:	e9 38 fd ff ff       	jmp    80100aec <exec+0x6c>
    end_op();
80100db4:	e8 a7 1f 00 00       	call   80102d60 <end_op>
    cprintf("exec: fail\n");
80100db9:	83 ec 0c             	sub    $0xc,%esp
80100dbc:	68 61 70 10 80       	push   $0x80107061
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
80100de6:	68 6d 70 10 80       	push   $0x8010706d
80100deb:	68 c0 ff 10 80       	push   $0x8010ffc0
80100df0:	e8 5b 35 00 00       	call   80104350 <initlock>
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
80100e11:	e8 9a 36 00 00       	call   801044b0 <acquire>
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
80100e41:	e8 2a 37 00 00       	call   80104570 <release>
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
80100e5a:	e8 11 37 00 00       	call   80104570 <release>
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
80100e7f:	e8 2c 36 00 00       	call   801044b0 <acquire>
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
80100e9c:	e8 cf 36 00 00       	call   80104570 <release>
  return f;
}
80100ea1:	89 d8                	mov    %ebx,%eax
80100ea3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100ea6:	c9                   	leave  
80100ea7:	c3                   	ret    
    panic("filedup");
80100ea8:	83 ec 0c             	sub    $0xc,%esp
80100eab:	68 74 70 10 80       	push   $0x80107074
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
80100ed1:	e8 da 35 00 00       	call   801044b0 <acquire>
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
80100f0c:	e8 5f 36 00 00       	call   80104570 <release>

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
80100f3e:	e9 2d 36 00 00       	jmp    80104570 <release>
80100f43:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100f47:	90                   	nop
    pipeclose(ff.pipe, ff.writable);
80100f48:	0f be 5d e7          	movsbl -0x19(%ebp),%ebx
80100f4c:	83 ec 08             	sub    $0x8,%esp
80100f4f:	53                   	push   %ebx
80100f50:	56                   	push   %esi
80100f51:	e8 4a 25 00 00       	call   801034a0 <pipeclose>
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
80100f68:	e8 83 1d 00 00       	call   80102cf0 <begin_op>
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
80100f82:	e9 d9 1d 00 00       	jmp    80102d60 <end_op>
    panic("fileclose");
80100f87:	83 ec 0c             	sub    $0xc,%esp
80100f8a:	68 7c 70 10 80       	push   $0x8010707c
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
8010105d:	e9 ee 25 00 00       	jmp    80103650 <piperead>
80101062:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80101068:	be ff ff ff ff       	mov    $0xffffffff,%esi
8010106d:	eb d7                	jmp    80101046 <fileread+0x56>
  panic("fileread");
8010106f:	83 ec 0c             	sub    $0xc,%esp
80101072:	68 86 70 10 80       	push   $0x80107086
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
801010d9:	e8 82 1c 00 00       	call   80102d60 <end_op>

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
80101102:	e8 e9 1b 00 00       	call   80102cf0 <begin_op>
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
80101139:	e8 22 1c 00 00       	call   80102d60 <end_op>
      if(r < 0)
8010113e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101141:	83 c4 10             	add    $0x10,%esp
80101144:	85 c0                	test   %eax,%eax
80101146:	75 15                	jne    8010115d <filewrite+0xdd>
        panic("short filewrite");
80101148:	83 ec 0c             	sub    $0xc,%esp
8010114b:	68 8f 70 10 80       	push   $0x8010708f
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
80101179:	e9 c2 23 00 00       	jmp    80103540 <pipewrite>
  panic("filewrite");
8010117e:	83 ec 0c             	sub    $0xc,%esp
80101181:	68 95 70 10 80       	push   $0x80107095
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
80101234:	68 9f 70 10 80       	push   $0x8010709f
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
8010124d:	e8 7e 1c 00 00       	call   80102ed0 <log_write>
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
80101275:	e8 46 33 00 00       	call   801045c0 <memset>
  log_write(bp);
8010127a:	89 1c 24             	mov    %ebx,(%esp)
8010127d:	e8 4e 1c 00 00       	call   80102ed0 <log_write>
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
801012ba:	e8 f1 31 00 00       	call   801044b0 <acquire>
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
80101327:	e8 44 32 00 00       	call   80104570 <release>

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
80101355:	e8 16 32 00 00       	call   80104570 <release>
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
80101383:	68 b5 70 10 80       	push   $0x801070b5
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
80101405:	e8 c6 1a 00 00       	call   80102ed0 <log_write>
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
8010144b:	68 c5 70 10 80       	push   $0x801070c5
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
80101481:	e8 da 31 00 00       	call   80104660 <memmove>
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
801014fa:	e8 d1 19 00 00       	call   80102ed0 <log_write>
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
80101514:	68 d8 70 10 80       	push   $0x801070d8
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
8010152c:	68 eb 70 10 80       	push   $0x801070eb
80101531:	68 e0 09 11 80       	push   $0x801109e0
80101536:	e8 15 2e 00 00       	call   80104350 <initlock>
  for(i = 0; i < NINODE; i++) {
8010153b:	83 c4 10             	add    $0x10,%esp
8010153e:	66 90                	xchg   %ax,%ax
    initsleeplock(&icache.inode[i].lock, "inode");
80101540:	83 ec 08             	sub    $0x8,%esp
80101543:	68 f2 70 10 80       	push   $0x801070f2
80101548:	53                   	push   %ebx
80101549:	81 c3 90 00 00 00    	add    $0x90,%ebx
8010154f:	e8 cc 2c 00 00       	call   80104220 <initsleeplock>
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
80101599:	68 58 71 10 80       	push   $0x80107158
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
8010162e:	e8 8d 2f 00 00       	call   801045c0 <memset>
      dip->type = type;
80101633:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
80101637:	8b 4d e0             	mov    -0x20(%ebp),%ecx
8010163a:	66 89 01             	mov    %ax,(%ecx)
      log_write(bp);   // mark it allocated on the disk
8010163d:	89 3c 24             	mov    %edi,(%esp)
80101640:	e8 8b 18 00 00       	call   80102ed0 <log_write>
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
80101663:	68 f8 70 10 80       	push   $0x801070f8
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
801016d1:	e8 8a 2f 00 00       	call   80104660 <memmove>
  log_write(bp);
801016d6:	89 34 24             	mov    %esi,(%esp)
801016d9:	e8 f2 17 00 00       	call   80102ed0 <log_write>
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
801016ff:	e8 ac 2d 00 00       	call   801044b0 <acquire>
  ip->ref++;
80101704:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
80101708:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
8010170f:	e8 5c 2e 00 00       	call   80104570 <release>
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
80101742:	e8 19 2b 00 00       	call   80104260 <acquiresleep>
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
801017b8:	e8 a3 2e 00 00       	call   80104660 <memmove>
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
801017dd:	68 10 71 10 80       	push   $0x80107110
801017e2:	e8 a9 eb ff ff       	call   80100390 <panic>
    panic("ilock");
801017e7:	83 ec 0c             	sub    $0xc,%esp
801017ea:	68 0a 71 10 80       	push   $0x8010710a
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
80101813:	e8 e8 2a 00 00       	call   80104300 <holdingsleep>
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
8010182f:	e9 8c 2a 00 00       	jmp    801042c0 <releasesleep>
    panic("iunlock");
80101834:	83 ec 0c             	sub    $0xc,%esp
80101837:	68 1f 71 10 80       	push   $0x8010711f
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
80101860:	e8 fb 29 00 00       	call   80104260 <acquiresleep>
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
8010187a:	e8 41 2a 00 00       	call   801042c0 <releasesleep>
  acquire(&icache.lock);
8010187f:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
80101886:	e8 25 2c 00 00       	call   801044b0 <acquire>
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
801018a0:	e9 cb 2c 00 00       	jmp    80104570 <release>
801018a5:	8d 76 00             	lea    0x0(%esi),%esi
    acquire(&icache.lock);
801018a8:	83 ec 0c             	sub    $0xc,%esp
801018ab:	68 e0 09 11 80       	push   $0x801109e0
801018b0:	e8 fb 2b 00 00       	call   801044b0 <acquire>
    int r = ip->ref;
801018b5:	8b 73 08             	mov    0x8(%ebx),%esi
    release(&icache.lock);
801018b8:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
801018bf:	e8 ac 2c 00 00       	call   80104570 <release>
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
80101aa7:	e8 b4 2b 00 00       	call   80104660 <memmove>
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
80101ba3:	e8 b8 2a 00 00       	call   80104660 <memmove>
    log_write(bp);
80101ba8:	89 3c 24             	mov    %edi,(%esp)
80101bab:	e8 20 13 00 00       	call   80102ed0 <log_write>
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
80101c3e:	e8 8d 2a 00 00       	call   801046d0 <strncmp>
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
80101c9d:	e8 2e 2a 00 00       	call   801046d0 <strncmp>
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
80101ce2:	68 39 71 10 80       	push   $0x80107139
80101ce7:	e8 a4 e6 ff ff       	call   80100390 <panic>
    panic("dirlookup not DIR");
80101cec:	83 ec 0c             	sub    $0xc,%esp
80101cef:	68 27 71 10 80       	push   $0x80107127
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
80101d1a:	e8 11 1c 00 00       	call   80103930 <myproc>
  acquire(&icache.lock);
80101d1f:	83 ec 0c             	sub    $0xc,%esp
80101d22:	89 df                	mov    %ebx,%edi
    ip = idup(myproc()->cwd);
80101d24:	8b 70 68             	mov    0x68(%eax),%esi
  acquire(&icache.lock);
80101d27:	68 e0 09 11 80       	push   $0x801109e0
80101d2c:	e8 7f 27 00 00       	call   801044b0 <acquire>
  ip->ref++;
80101d31:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80101d35:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
80101d3c:	e8 2f 28 00 00       	call   80104570 <release>
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
80101da6:	e8 b5 28 00 00       	call   80104660 <memmove>
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
80101e33:	e8 28 28 00 00       	call   80104660 <memmove>
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
80101f5d:	e8 ce 27 00 00       	call   80104730 <strncpy>
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
80101f9b:	68 48 71 10 80       	push   $0x80107148
80101fa0:	e8 eb e3 ff ff       	call   80100390 <panic>
    panic("dirlink");
80101fa5:	83 ec 0c             	sub    $0xc,%esp
80101fa8:	68 42 77 10 80       	push   $0x80107742
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
801020bb:	68 b4 71 10 80       	push   $0x801071b4
801020c0:	e8 cb e2 ff ff       	call   80100390 <panic>
    panic("idestart");
801020c5:	83 ec 0c             	sub    $0xc,%esp
801020c8:	68 ab 71 10 80       	push   $0x801071ab
801020cd:	e8 be e2 ff ff       	call   80100390 <panic>
801020d2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801020d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801020e0 <ideinit>:
{
801020e0:	55                   	push   %ebp
801020e1:	89 e5                	mov    %esp,%ebp
801020e3:	83 ec 10             	sub    $0x10,%esp
  initlock(&idelock, "ide");
801020e6:	68 c6 71 10 80       	push   $0x801071c6
801020eb:	68 80 a5 10 80       	push   $0x8010a580
801020f0:	e8 5b 22 00 00       	call   80104350 <initlock>
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
8010216e:	e8 3d 23 00 00       	call   801044b0 <acquire>

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
801021cd:	e8 ae 1e 00 00       	call   80104080 <wakeup>

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
801021eb:	e8 80 23 00 00       	call   80104570 <release>

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
8010220e:	e8 ed 20 00 00       	call   80104300 <holdingsleep>
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
80102248:	e8 63 22 00 00       	call   801044b0 <acquire>

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
80102299:	e8 32 1c 00 00       	call   80103ed0 <sleep>
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
801022b6:	e9 b5 22 00 00       	jmp    80104570 <release>
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
801022da:	68 f5 71 10 80       	push   $0x801071f5
801022df:	e8 ac e0 ff ff       	call   80100390 <panic>
    panic("iderw: nothing to do");
801022e4:	83 ec 0c             	sub    $0xc,%esp
801022e7:	68 e0 71 10 80       	push   $0x801071e0
801022ec:	e8 9f e0 ff ff       	call   80100390 <panic>
    panic("iderw: buf not locked");
801022f1:	83 ec 0c             	sub    $0xc,%esp
801022f4:	68 ca 71 10 80       	push   $0x801071ca
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
8010234a:	68 14 72 10 80       	push   $0x80107214
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
80102422:	e8 99 21 00 00       	call   801045c0 <memset>

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
80102458:	e8 53 20 00 00       	call   801044b0 <acquire>
8010245d:	83 c4 10             	add    $0x10,%esp
80102460:	eb d2                	jmp    80102434 <kfree+0x44>
80102462:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    release(&kmem.lock);
80102468:	c7 45 08 40 26 11 80 	movl   $0x80112640,0x8(%ebp)
}
8010246f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102472:	c9                   	leave  
    release(&kmem.lock);
80102473:	e9 f8 20 00 00       	jmp    80104570 <release>
    panic("kfree");
80102478:	83 ec 0c             	sub    $0xc,%esp
8010247b:	68 46 72 10 80       	push   $0x80107246
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
801024eb:	68 4c 72 10 80       	push   $0x8010724c
801024f0:	68 40 26 11 80       	push   $0x80112640
801024f5:	e8 56 1e 00 00       	call   80104350 <initlock>
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
801025e8:	e8 c3 1e 00 00       	call   801044b0 <acquire>
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
80102613:	e8 58 1f 00 00       	call   80104570 <release>
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
  int freeMemBytes = 0;
  // Acquire lock to avoid race conditions
  if(kmem.use_lock)
80102630:	8b 15 74 26 11 80    	mov    0x80112674,%edx
80102636:	85 d2                	test   %edx,%edx
80102638:	75 06                	jne    80102640 <freemem+0x10>
  {
    release(&kmem.lock);
  }
  
  return freeMemBytes;
}
8010263a:	b8 04 00 00 00       	mov    $0x4,%eax
8010263f:	c3                   	ret    
{
80102640:	55                   	push   %ebp
80102641:	89 e5                	mov    %esp,%ebp
80102643:	83 ec 14             	sub    $0x14,%esp
    acquire(&kmem.lock);
80102646:	68 40 26 11 80       	push   $0x80112640
8010264b:	e8 60 1e 00 00       	call   801044b0 <acquire>
  if(kmem.use_lock)
80102650:	a1 74 26 11 80       	mov    0x80112674,%eax
80102655:	83 c4 10             	add    $0x10,%esp
80102658:	85 c0                	test   %eax,%eax
8010265a:	74 10                	je     8010266c <freemem+0x3c>
    release(&kmem.lock);
8010265c:	83 ec 0c             	sub    $0xc,%esp
8010265f:	68 40 26 11 80       	push   $0x80112640
80102664:	e8 07 1f 00 00       	call   80104570 <release>
80102669:	83 c4 10             	add    $0x10,%esp
}
8010266c:	c9                   	leave  
8010266d:	b8 04 00 00 00       	mov    $0x4,%eax
80102672:	c3                   	ret    
80102673:	66 90                	xchg   %ax,%ax
80102675:	66 90                	xchg   %ax,%ax
80102677:	66 90                	xchg   %ax,%ax
80102679:	66 90                	xchg   %ax,%ax
8010267b:	66 90                	xchg   %ax,%ax
8010267d:	66 90                	xchg   %ax,%ax
8010267f:	90                   	nop

80102680 <kbdgetc>:
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102680:	ba 64 00 00 00       	mov    $0x64,%edx
80102685:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
80102686:	a8 01                	test   $0x1,%al
80102688:	0f 84 c2 00 00 00    	je     80102750 <kbdgetc+0xd0>
{
8010268e:	55                   	push   %ebp
8010268f:	ba 60 00 00 00       	mov    $0x60,%edx
80102694:	89 e5                	mov    %esp,%ebp
80102696:	53                   	push   %ebx
80102697:	ec                   	in     (%dx),%al
    return -1;
  data = inb(KBDATAP);
80102698:	0f b6 d0             	movzbl %al,%edx

  if(data == 0xE0){
8010269b:	8b 1d b4 a5 10 80    	mov    0x8010a5b4,%ebx
801026a1:	81 fa e0 00 00 00    	cmp    $0xe0,%edx
801026a7:	74 57                	je     80102700 <kbdgetc+0x80>
    shift |= E0ESC;
    return 0;
  } else if(data & 0x80){
801026a9:	89 d9                	mov    %ebx,%ecx
801026ab:	83 e1 40             	and    $0x40,%ecx
801026ae:	84 c0                	test   %al,%al
801026b0:	78 5e                	js     80102710 <kbdgetc+0x90>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
801026b2:	85 c9                	test   %ecx,%ecx
801026b4:	74 09                	je     801026bf <kbdgetc+0x3f>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
801026b6:	83 c8 80             	or     $0xffffff80,%eax
    shift &= ~E0ESC;
801026b9:	83 e3 bf             	and    $0xffffffbf,%ebx
    data |= 0x80;
801026bc:	0f b6 d0             	movzbl %al,%edx
  }

  shift |= shiftcode[data];
801026bf:	0f b6 8a 80 73 10 80 	movzbl -0x7fef8c80(%edx),%ecx
  shift ^= togglecode[data];
801026c6:	0f b6 82 80 72 10 80 	movzbl -0x7fef8d80(%edx),%eax
  shift |= shiftcode[data];
801026cd:	09 d9                	or     %ebx,%ecx
  shift ^= togglecode[data];
801026cf:	31 c1                	xor    %eax,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
801026d1:	89 c8                	mov    %ecx,%eax
  shift ^= togglecode[data];
801026d3:	89 0d b4 a5 10 80    	mov    %ecx,0x8010a5b4
  c = charcode[shift & (CTL | SHIFT)][data];
801026d9:	83 e0 03             	and    $0x3,%eax
  if(shift & CAPSLOCK){
801026dc:	83 e1 08             	and    $0x8,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
801026df:	8b 04 85 60 72 10 80 	mov    -0x7fef8da0(,%eax,4),%eax
801026e6:	0f b6 04 10          	movzbl (%eax,%edx,1),%eax
  if(shift & CAPSLOCK){
801026ea:	74 0b                	je     801026f7 <kbdgetc+0x77>
    if('a' <= c && c <= 'z')
801026ec:	8d 50 9f             	lea    -0x61(%eax),%edx
801026ef:	83 fa 19             	cmp    $0x19,%edx
801026f2:	77 44                	ja     80102738 <kbdgetc+0xb8>
      c += 'A' - 'a';
801026f4:	83 e8 20             	sub    $0x20,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
801026f7:	5b                   	pop    %ebx
801026f8:	5d                   	pop    %ebp
801026f9:	c3                   	ret    
801026fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    shift |= E0ESC;
80102700:	83 cb 40             	or     $0x40,%ebx
    return 0;
80102703:	31 c0                	xor    %eax,%eax
    shift |= E0ESC;
80102705:	89 1d b4 a5 10 80    	mov    %ebx,0x8010a5b4
}
8010270b:	5b                   	pop    %ebx
8010270c:	5d                   	pop    %ebp
8010270d:	c3                   	ret    
8010270e:	66 90                	xchg   %ax,%ax
    data = (shift & E0ESC ? data : data & 0x7F);
80102710:	83 e0 7f             	and    $0x7f,%eax
80102713:	85 c9                	test   %ecx,%ecx
80102715:	0f 44 d0             	cmove  %eax,%edx
    return 0;
80102718:	31 c0                	xor    %eax,%eax
    shift &= ~(shiftcode[data] | E0ESC);
8010271a:	0f b6 8a 80 73 10 80 	movzbl -0x7fef8c80(%edx),%ecx
80102721:	83 c9 40             	or     $0x40,%ecx
80102724:	0f b6 c9             	movzbl %cl,%ecx
80102727:	f7 d1                	not    %ecx
80102729:	21 d9                	and    %ebx,%ecx
}
8010272b:	5b                   	pop    %ebx
8010272c:	5d                   	pop    %ebp
    shift &= ~(shiftcode[data] | E0ESC);
8010272d:	89 0d b4 a5 10 80    	mov    %ecx,0x8010a5b4
}
80102733:	c3                   	ret    
80102734:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    else if('A' <= c && c <= 'Z')
80102738:	8d 48 bf             	lea    -0x41(%eax),%ecx
      c += 'a' - 'A';
8010273b:	8d 50 20             	lea    0x20(%eax),%edx
}
8010273e:	5b                   	pop    %ebx
8010273f:	5d                   	pop    %ebp
      c += 'a' - 'A';
80102740:	83 f9 1a             	cmp    $0x1a,%ecx
80102743:	0f 42 c2             	cmovb  %edx,%eax
}
80102746:	c3                   	ret    
80102747:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010274e:	66 90                	xchg   %ax,%ax
    return -1;
80102750:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80102755:	c3                   	ret    
80102756:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010275d:	8d 76 00             	lea    0x0(%esi),%esi

80102760 <kbdintr>:

void
kbdintr(void)
{
80102760:	55                   	push   %ebp
80102761:	89 e5                	mov    %esp,%ebp
80102763:	83 ec 14             	sub    $0x14,%esp
  consoleintr(kbdgetc);
80102766:	68 80 26 10 80       	push   $0x80102680
8010276b:	e8 f0 e0 ff ff       	call   80100860 <consoleintr>
}
80102770:	83 c4 10             	add    $0x10,%esp
80102773:	c9                   	leave  
80102774:	c3                   	ret    
80102775:	66 90                	xchg   %ax,%ax
80102777:	66 90                	xchg   %ax,%ax
80102779:	66 90                	xchg   %ax,%ax
8010277b:	66 90                	xchg   %ax,%ax
8010277d:	66 90                	xchg   %ax,%ax
8010277f:	90                   	nop

80102780 <lapicinit>:
}

void
lapicinit(void)
{
  if(!lapic)
80102780:	a1 7c 26 11 80       	mov    0x8011267c,%eax
80102785:	85 c0                	test   %eax,%eax
80102787:	0f 84 cb 00 00 00    	je     80102858 <lapicinit+0xd8>
  lapic[index] = value;
8010278d:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
80102794:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102797:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010279a:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
801027a1:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801027a4:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801027a7:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
801027ae:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
801027b1:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801027b4:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
801027bb:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
801027be:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801027c1:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
801027c8:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
801027cb:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801027ce:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
801027d5:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
801027d8:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(LINT0, MASKED);
  lapicw(LINT1, MASKED);

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
801027db:	8b 50 30             	mov    0x30(%eax),%edx
801027de:	c1 ea 10             	shr    $0x10,%edx
801027e1:	81 e2 fc 00 00 00    	and    $0xfc,%edx
801027e7:	75 77                	jne    80102860 <lapicinit+0xe0>
  lapic[index] = value;
801027e9:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
801027f0:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801027f3:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801027f6:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
801027fd:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102800:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102803:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
8010280a:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010280d:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102810:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102817:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010281a:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010281d:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
80102824:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102827:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010282a:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
80102831:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
80102834:	8b 50 20             	mov    0x20(%eax),%edx
80102837:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010283e:	66 90                	xchg   %ax,%ax
  lapicw(EOI, 0);

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  while(lapic[ICRLO] & DELIVS)
80102840:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
80102846:	80 e6 10             	and    $0x10,%dh
80102849:	75 f5                	jne    80102840 <lapicinit+0xc0>
  lapic[index] = value;
8010284b:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
80102852:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102855:	8b 40 20             	mov    0x20(%eax),%eax
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
80102858:	c3                   	ret    
80102859:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  lapic[index] = value;
80102860:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
80102867:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
8010286a:	8b 50 20             	mov    0x20(%eax),%edx
8010286d:	e9 77 ff ff ff       	jmp    801027e9 <lapicinit+0x69>
80102872:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102879:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102880 <lapicid>:

int
lapicid(void)
{
  if (!lapic)
80102880:	a1 7c 26 11 80       	mov    0x8011267c,%eax
80102885:	85 c0                	test   %eax,%eax
80102887:	74 07                	je     80102890 <lapicid+0x10>
    return 0;
  return lapic[ID] >> 24;
80102889:	8b 40 20             	mov    0x20(%eax),%eax
8010288c:	c1 e8 18             	shr    $0x18,%eax
8010288f:	c3                   	ret    
    return 0;
80102890:	31 c0                	xor    %eax,%eax
}
80102892:	c3                   	ret    
80102893:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010289a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801028a0 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
  if(lapic)
801028a0:	a1 7c 26 11 80       	mov    0x8011267c,%eax
801028a5:	85 c0                	test   %eax,%eax
801028a7:	74 0d                	je     801028b6 <lapiceoi+0x16>
  lapic[index] = value;
801028a9:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
801028b0:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801028b3:	8b 40 20             	mov    0x20(%eax),%eax
    lapicw(EOI, 0);
}
801028b6:	c3                   	ret    
801028b7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801028be:	66 90                	xchg   %ax,%ax

801028c0 <microdelay>:
// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
}
801028c0:	c3                   	ret    
801028c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801028c8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801028cf:	90                   	nop

801028d0 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
801028d0:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801028d1:	b8 0f 00 00 00       	mov    $0xf,%eax
801028d6:	ba 70 00 00 00       	mov    $0x70,%edx
801028db:	89 e5                	mov    %esp,%ebp
801028dd:	53                   	push   %ebx
801028de:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801028e1:	8b 5d 08             	mov    0x8(%ebp),%ebx
801028e4:	ee                   	out    %al,(%dx)
801028e5:	b8 0a 00 00 00       	mov    $0xa,%eax
801028ea:	ba 71 00 00 00       	mov    $0x71,%edx
801028ef:	ee                   	out    %al,(%dx)
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
801028f0:	31 c0                	xor    %eax,%eax
  wrv[1] = addr >> 4;

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
801028f2:	c1 e3 18             	shl    $0x18,%ebx
  wrv[0] = 0;
801028f5:	66 a3 67 04 00 80    	mov    %ax,0x80000467
  wrv[1] = addr >> 4;
801028fb:	89 c8                	mov    %ecx,%eax
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
801028fd:	c1 e9 0c             	shr    $0xc,%ecx
  lapicw(ICRHI, apicid<<24);
80102900:	89 da                	mov    %ebx,%edx
  wrv[1] = addr >> 4;
80102902:	c1 e8 04             	shr    $0x4,%eax
    lapicw(ICRLO, STARTUP | (addr>>12));
80102905:	80 cd 06             	or     $0x6,%ch
  wrv[1] = addr >> 4;
80102908:	66 a3 69 04 00 80    	mov    %ax,0x80000469
  lapic[index] = value;
8010290e:	a1 7c 26 11 80       	mov    0x8011267c,%eax
80102913:	89 98 10 03 00 00    	mov    %ebx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102919:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
8010291c:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
80102923:	c5 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102926:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102929:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
80102930:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102933:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102936:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
8010293c:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
8010293f:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102945:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102948:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
8010294e:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102951:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
    microdelay(200);
  }
}
80102957:	5b                   	pop    %ebx
  lapic[ID];  // wait for write to finish, by reading
80102958:	8b 40 20             	mov    0x20(%eax),%eax
}
8010295b:	5d                   	pop    %ebp
8010295c:	c3                   	ret    
8010295d:	8d 76 00             	lea    0x0(%esi),%esi

80102960 <cmostime>:
}

// qemu seems to use 24-hour GWT and the values are BCD encoded
void
cmostime(struct rtcdate *r)
{
80102960:	55                   	push   %ebp
80102961:	b8 0b 00 00 00       	mov    $0xb,%eax
80102966:	ba 70 00 00 00       	mov    $0x70,%edx
8010296b:	89 e5                	mov    %esp,%ebp
8010296d:	57                   	push   %edi
8010296e:	56                   	push   %esi
8010296f:	53                   	push   %ebx
80102970:	83 ec 4c             	sub    $0x4c,%esp
80102973:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102974:	ba 71 00 00 00       	mov    $0x71,%edx
80102979:	ec                   	in     (%dx),%al
  struct rtcdate t1, t2;
  int sb, bcd;

  sb = cmos_read(CMOS_STATB);

  bcd = (sb & (1 << 2)) == 0;
8010297a:	83 e0 04             	and    $0x4,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010297d:	bb 70 00 00 00       	mov    $0x70,%ebx
80102982:	88 45 b3             	mov    %al,-0x4d(%ebp)
80102985:	8d 76 00             	lea    0x0(%esi),%esi
80102988:	31 c0                	xor    %eax,%eax
8010298a:	89 da                	mov    %ebx,%edx
8010298c:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010298d:	b9 71 00 00 00       	mov    $0x71,%ecx
80102992:	89 ca                	mov    %ecx,%edx
80102994:	ec                   	in     (%dx),%al
80102995:	88 45 b7             	mov    %al,-0x49(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102998:	89 da                	mov    %ebx,%edx
8010299a:	b8 02 00 00 00       	mov    $0x2,%eax
8010299f:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801029a0:	89 ca                	mov    %ecx,%edx
801029a2:	ec                   	in     (%dx),%al
801029a3:	88 45 b6             	mov    %al,-0x4a(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801029a6:	89 da                	mov    %ebx,%edx
801029a8:	b8 04 00 00 00       	mov    $0x4,%eax
801029ad:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801029ae:	89 ca                	mov    %ecx,%edx
801029b0:	ec                   	in     (%dx),%al
801029b1:	88 45 b5             	mov    %al,-0x4b(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801029b4:	89 da                	mov    %ebx,%edx
801029b6:	b8 07 00 00 00       	mov    $0x7,%eax
801029bb:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801029bc:	89 ca                	mov    %ecx,%edx
801029be:	ec                   	in     (%dx),%al
801029bf:	88 45 b4             	mov    %al,-0x4c(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801029c2:	89 da                	mov    %ebx,%edx
801029c4:	b8 08 00 00 00       	mov    $0x8,%eax
801029c9:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801029ca:	89 ca                	mov    %ecx,%edx
801029cc:	ec                   	in     (%dx),%al
801029cd:	89 c7                	mov    %eax,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801029cf:	89 da                	mov    %ebx,%edx
801029d1:	b8 09 00 00 00       	mov    $0x9,%eax
801029d6:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801029d7:	89 ca                	mov    %ecx,%edx
801029d9:	ec                   	in     (%dx),%al
801029da:	89 c6                	mov    %eax,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801029dc:	89 da                	mov    %ebx,%edx
801029de:	b8 0a 00 00 00       	mov    $0xa,%eax
801029e3:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801029e4:	89 ca                	mov    %ecx,%edx
801029e6:	ec                   	in     (%dx),%al

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
801029e7:	84 c0                	test   %al,%al
801029e9:	78 9d                	js     80102988 <cmostime+0x28>
  return inb(CMOS_RETURN);
801029eb:	0f b6 45 b7          	movzbl -0x49(%ebp),%eax
801029ef:	89 fa                	mov    %edi,%edx
801029f1:	0f b6 fa             	movzbl %dl,%edi
801029f4:	89 f2                	mov    %esi,%edx
801029f6:	89 45 b8             	mov    %eax,-0x48(%ebp)
801029f9:	0f b6 45 b6          	movzbl -0x4a(%ebp),%eax
801029fd:	0f b6 f2             	movzbl %dl,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a00:	89 da                	mov    %ebx,%edx
80102a02:	89 7d c8             	mov    %edi,-0x38(%ebp)
80102a05:	89 45 bc             	mov    %eax,-0x44(%ebp)
80102a08:	0f b6 45 b5          	movzbl -0x4b(%ebp),%eax
80102a0c:	89 75 cc             	mov    %esi,-0x34(%ebp)
80102a0f:	89 45 c0             	mov    %eax,-0x40(%ebp)
80102a12:	0f b6 45 b4          	movzbl -0x4c(%ebp),%eax
80102a16:	89 45 c4             	mov    %eax,-0x3c(%ebp)
80102a19:	31 c0                	xor    %eax,%eax
80102a1b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a1c:	89 ca                	mov    %ecx,%edx
80102a1e:	ec                   	in     (%dx),%al
80102a1f:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a22:	89 da                	mov    %ebx,%edx
80102a24:	89 45 d0             	mov    %eax,-0x30(%ebp)
80102a27:	b8 02 00 00 00       	mov    $0x2,%eax
80102a2c:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a2d:	89 ca                	mov    %ecx,%edx
80102a2f:	ec                   	in     (%dx),%al
80102a30:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a33:	89 da                	mov    %ebx,%edx
80102a35:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80102a38:	b8 04 00 00 00       	mov    $0x4,%eax
80102a3d:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a3e:	89 ca                	mov    %ecx,%edx
80102a40:	ec                   	in     (%dx),%al
80102a41:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a44:	89 da                	mov    %ebx,%edx
80102a46:	89 45 d8             	mov    %eax,-0x28(%ebp)
80102a49:	b8 07 00 00 00       	mov    $0x7,%eax
80102a4e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a4f:	89 ca                	mov    %ecx,%edx
80102a51:	ec                   	in     (%dx),%al
80102a52:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a55:	89 da                	mov    %ebx,%edx
80102a57:	89 45 dc             	mov    %eax,-0x24(%ebp)
80102a5a:	b8 08 00 00 00       	mov    $0x8,%eax
80102a5f:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a60:	89 ca                	mov    %ecx,%edx
80102a62:	ec                   	in     (%dx),%al
80102a63:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a66:	89 da                	mov    %ebx,%edx
80102a68:	89 45 e0             	mov    %eax,-0x20(%ebp)
80102a6b:	b8 09 00 00 00       	mov    $0x9,%eax
80102a70:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a71:	89 ca                	mov    %ecx,%edx
80102a73:	ec                   	in     (%dx),%al
80102a74:	0f b6 c0             	movzbl %al,%eax
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102a77:	83 ec 04             	sub    $0x4,%esp
  return inb(CMOS_RETURN);
80102a7a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102a7d:	8d 45 d0             	lea    -0x30(%ebp),%eax
80102a80:	6a 18                	push   $0x18
80102a82:	50                   	push   %eax
80102a83:	8d 45 b8             	lea    -0x48(%ebp),%eax
80102a86:	50                   	push   %eax
80102a87:	e8 84 1b 00 00       	call   80104610 <memcmp>
80102a8c:	83 c4 10             	add    $0x10,%esp
80102a8f:	85 c0                	test   %eax,%eax
80102a91:	0f 85 f1 fe ff ff    	jne    80102988 <cmostime+0x28>
      break;
  }

  // convert
  if(bcd) {
80102a97:	80 7d b3 00          	cmpb   $0x0,-0x4d(%ebp)
80102a9b:	75 78                	jne    80102b15 <cmostime+0x1b5>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
80102a9d:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102aa0:	89 c2                	mov    %eax,%edx
80102aa2:	83 e0 0f             	and    $0xf,%eax
80102aa5:	c1 ea 04             	shr    $0x4,%edx
80102aa8:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102aab:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102aae:	89 45 b8             	mov    %eax,-0x48(%ebp)
    CONV(minute);
80102ab1:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102ab4:	89 c2                	mov    %eax,%edx
80102ab6:	83 e0 0f             	and    $0xf,%eax
80102ab9:	c1 ea 04             	shr    $0x4,%edx
80102abc:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102abf:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102ac2:	89 45 bc             	mov    %eax,-0x44(%ebp)
    CONV(hour  );
80102ac5:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102ac8:	89 c2                	mov    %eax,%edx
80102aca:	83 e0 0f             	and    $0xf,%eax
80102acd:	c1 ea 04             	shr    $0x4,%edx
80102ad0:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102ad3:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102ad6:	89 45 c0             	mov    %eax,-0x40(%ebp)
    CONV(day   );
80102ad9:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102adc:	89 c2                	mov    %eax,%edx
80102ade:	83 e0 0f             	and    $0xf,%eax
80102ae1:	c1 ea 04             	shr    $0x4,%edx
80102ae4:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102ae7:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102aea:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    CONV(month );
80102aed:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102af0:	89 c2                	mov    %eax,%edx
80102af2:	83 e0 0f             	and    $0xf,%eax
80102af5:	c1 ea 04             	shr    $0x4,%edx
80102af8:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102afb:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102afe:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(year  );
80102b01:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102b04:	89 c2                	mov    %eax,%edx
80102b06:	83 e0 0f             	and    $0xf,%eax
80102b09:	c1 ea 04             	shr    $0x4,%edx
80102b0c:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b0f:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b12:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef     CONV
  }

  *r = t1;
80102b15:	8b 75 08             	mov    0x8(%ebp),%esi
80102b18:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102b1b:	89 06                	mov    %eax,(%esi)
80102b1d:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102b20:	89 46 04             	mov    %eax,0x4(%esi)
80102b23:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102b26:	89 46 08             	mov    %eax,0x8(%esi)
80102b29:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102b2c:	89 46 0c             	mov    %eax,0xc(%esi)
80102b2f:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102b32:	89 46 10             	mov    %eax,0x10(%esi)
80102b35:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102b38:	89 46 14             	mov    %eax,0x14(%esi)
  r->year += 2000;
80102b3b:	81 46 14 d0 07 00 00 	addl   $0x7d0,0x14(%esi)
}
80102b42:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102b45:	5b                   	pop    %ebx
80102b46:	5e                   	pop    %esi
80102b47:	5f                   	pop    %edi
80102b48:	5d                   	pop    %ebp
80102b49:	c3                   	ret    
80102b4a:	66 90                	xchg   %ax,%ax
80102b4c:	66 90                	xchg   %ax,%ax
80102b4e:	66 90                	xchg   %ax,%ax

80102b50 <install_trans>:
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102b50:	8b 0d c8 26 11 80    	mov    0x801126c8,%ecx
80102b56:	85 c9                	test   %ecx,%ecx
80102b58:	0f 8e 8a 00 00 00    	jle    80102be8 <install_trans+0x98>
{
80102b5e:	55                   	push   %ebp
80102b5f:	89 e5                	mov    %esp,%ebp
80102b61:	57                   	push   %edi
80102b62:	56                   	push   %esi
80102b63:	53                   	push   %ebx
  for (tail = 0; tail < log.lh.n; tail++) {
80102b64:	31 db                	xor    %ebx,%ebx
{
80102b66:	83 ec 0c             	sub    $0xc,%esp
80102b69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80102b70:	a1 b4 26 11 80       	mov    0x801126b4,%eax
80102b75:	83 ec 08             	sub    $0x8,%esp
80102b78:	01 d8                	add    %ebx,%eax
80102b7a:	83 c0 01             	add    $0x1,%eax
80102b7d:	50                   	push   %eax
80102b7e:	ff 35 c4 26 11 80    	pushl  0x801126c4
80102b84:	e8 47 d5 ff ff       	call   801000d0 <bread>
80102b89:	89 c7                	mov    %eax,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102b8b:	58                   	pop    %eax
80102b8c:	5a                   	pop    %edx
80102b8d:	ff 34 9d cc 26 11 80 	pushl  -0x7feed934(,%ebx,4)
80102b94:	ff 35 c4 26 11 80    	pushl  0x801126c4
  for (tail = 0; tail < log.lh.n; tail++) {
80102b9a:	83 c3 01             	add    $0x1,%ebx
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102b9d:	e8 2e d5 ff ff       	call   801000d0 <bread>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102ba2:	83 c4 0c             	add    $0xc,%esp
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102ba5:	89 c6                	mov    %eax,%esi
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102ba7:	8d 47 5c             	lea    0x5c(%edi),%eax
80102baa:	68 00 02 00 00       	push   $0x200
80102baf:	50                   	push   %eax
80102bb0:	8d 46 5c             	lea    0x5c(%esi),%eax
80102bb3:	50                   	push   %eax
80102bb4:	e8 a7 1a 00 00       	call   80104660 <memmove>
    bwrite(dbuf);  // write dst to disk
80102bb9:	89 34 24             	mov    %esi,(%esp)
80102bbc:	e8 ef d5 ff ff       	call   801001b0 <bwrite>
    brelse(lbuf);
80102bc1:	89 3c 24             	mov    %edi,(%esp)
80102bc4:	e8 27 d6 ff ff       	call   801001f0 <brelse>
    brelse(dbuf);
80102bc9:	89 34 24             	mov    %esi,(%esp)
80102bcc:	e8 1f d6 ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102bd1:	83 c4 10             	add    $0x10,%esp
80102bd4:	39 1d c8 26 11 80    	cmp    %ebx,0x801126c8
80102bda:	7f 94                	jg     80102b70 <install_trans+0x20>
  }
}
80102bdc:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102bdf:	5b                   	pop    %ebx
80102be0:	5e                   	pop    %esi
80102be1:	5f                   	pop    %edi
80102be2:	5d                   	pop    %ebp
80102be3:	c3                   	ret    
80102be4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102be8:	c3                   	ret    
80102be9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102bf0 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80102bf0:	55                   	push   %ebp
80102bf1:	89 e5                	mov    %esp,%ebp
80102bf3:	53                   	push   %ebx
80102bf4:	83 ec 0c             	sub    $0xc,%esp
  struct buf *buf = bread(log.dev, log.start);
80102bf7:	ff 35 b4 26 11 80    	pushl  0x801126b4
80102bfd:	ff 35 c4 26 11 80    	pushl  0x801126c4
80102c03:	e8 c8 d4 ff ff       	call   801000d0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
80102c08:	83 c4 10             	add    $0x10,%esp
  struct buf *buf = bread(log.dev, log.start);
80102c0b:	89 c3                	mov    %eax,%ebx
  hb->n = log.lh.n;
80102c0d:	a1 c8 26 11 80       	mov    0x801126c8,%eax
80102c12:	89 43 5c             	mov    %eax,0x5c(%ebx)
  for (i = 0; i < log.lh.n; i++) {
80102c15:	85 c0                	test   %eax,%eax
80102c17:	7e 19                	jle    80102c32 <write_head+0x42>
80102c19:	31 d2                	xor    %edx,%edx
80102c1b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102c1f:	90                   	nop
    hb->block[i] = log.lh.block[i];
80102c20:	8b 0c 95 cc 26 11 80 	mov    -0x7feed934(,%edx,4),%ecx
80102c27:	89 4c 93 60          	mov    %ecx,0x60(%ebx,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
80102c2b:	83 c2 01             	add    $0x1,%edx
80102c2e:	39 d0                	cmp    %edx,%eax
80102c30:	75 ee                	jne    80102c20 <write_head+0x30>
  }
  bwrite(buf);
80102c32:	83 ec 0c             	sub    $0xc,%esp
80102c35:	53                   	push   %ebx
80102c36:	e8 75 d5 ff ff       	call   801001b0 <bwrite>
  brelse(buf);
80102c3b:	89 1c 24             	mov    %ebx,(%esp)
80102c3e:	e8 ad d5 ff ff       	call   801001f0 <brelse>
}
80102c43:	83 c4 10             	add    $0x10,%esp
80102c46:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102c49:	c9                   	leave  
80102c4a:	c3                   	ret    
80102c4b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102c4f:	90                   	nop

80102c50 <initlog>:
{
80102c50:	55                   	push   %ebp
80102c51:	89 e5                	mov    %esp,%ebp
80102c53:	53                   	push   %ebx
80102c54:	83 ec 2c             	sub    $0x2c,%esp
80102c57:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&log.lock, "log");
80102c5a:	68 80 74 10 80       	push   $0x80107480
80102c5f:	68 80 26 11 80       	push   $0x80112680
80102c64:	e8 e7 16 00 00       	call   80104350 <initlock>
  readsb(dev, &sb);
80102c69:	58                   	pop    %eax
80102c6a:	8d 45 dc             	lea    -0x24(%ebp),%eax
80102c6d:	5a                   	pop    %edx
80102c6e:	50                   	push   %eax
80102c6f:	53                   	push   %ebx
80102c70:	e8 eb e7 ff ff       	call   80101460 <readsb>
  log.start = sb.logstart;
80102c75:	8b 45 ec             	mov    -0x14(%ebp),%eax
  struct buf *buf = bread(log.dev, log.start);
80102c78:	59                   	pop    %ecx
  log.dev = dev;
80102c79:	89 1d c4 26 11 80    	mov    %ebx,0x801126c4
  log.size = sb.nlog;
80102c7f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  log.start = sb.logstart;
80102c82:	a3 b4 26 11 80       	mov    %eax,0x801126b4
  log.size = sb.nlog;
80102c87:	89 15 b8 26 11 80    	mov    %edx,0x801126b8
  struct buf *buf = bread(log.dev, log.start);
80102c8d:	5a                   	pop    %edx
80102c8e:	50                   	push   %eax
80102c8f:	53                   	push   %ebx
80102c90:	e8 3b d4 ff ff       	call   801000d0 <bread>
  for (i = 0; i < log.lh.n; i++) {
80102c95:	83 c4 10             	add    $0x10,%esp
  log.lh.n = lh->n;
80102c98:	8b 48 5c             	mov    0x5c(%eax),%ecx
80102c9b:	89 0d c8 26 11 80    	mov    %ecx,0x801126c8
  for (i = 0; i < log.lh.n; i++) {
80102ca1:	85 c9                	test   %ecx,%ecx
80102ca3:	7e 1d                	jle    80102cc2 <initlog+0x72>
80102ca5:	31 d2                	xor    %edx,%edx
80102ca7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102cae:	66 90                	xchg   %ax,%ax
    log.lh.block[i] = lh->block[i];
80102cb0:	8b 5c 90 60          	mov    0x60(%eax,%edx,4),%ebx
80102cb4:	89 1c 95 cc 26 11 80 	mov    %ebx,-0x7feed934(,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
80102cbb:	83 c2 01             	add    $0x1,%edx
80102cbe:	39 d1                	cmp    %edx,%ecx
80102cc0:	75 ee                	jne    80102cb0 <initlog+0x60>
  brelse(buf);
80102cc2:	83 ec 0c             	sub    $0xc,%esp
80102cc5:	50                   	push   %eax
80102cc6:	e8 25 d5 ff ff       	call   801001f0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
80102ccb:	e8 80 fe ff ff       	call   80102b50 <install_trans>
  log.lh.n = 0;
80102cd0:	c7 05 c8 26 11 80 00 	movl   $0x0,0x801126c8
80102cd7:	00 00 00 
  write_head(); // clear the log
80102cda:	e8 11 ff ff ff       	call   80102bf0 <write_head>
}
80102cdf:	83 c4 10             	add    $0x10,%esp
80102ce2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102ce5:	c9                   	leave  
80102ce6:	c3                   	ret    
80102ce7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102cee:	66 90                	xchg   %ax,%ax

80102cf0 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
80102cf0:	55                   	push   %ebp
80102cf1:	89 e5                	mov    %esp,%ebp
80102cf3:	83 ec 14             	sub    $0x14,%esp
  acquire(&log.lock);
80102cf6:	68 80 26 11 80       	push   $0x80112680
80102cfb:	e8 b0 17 00 00       	call   801044b0 <acquire>
80102d00:	83 c4 10             	add    $0x10,%esp
80102d03:	eb 18                	jmp    80102d1d <begin_op+0x2d>
80102d05:	8d 76 00             	lea    0x0(%esi),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80102d08:	83 ec 08             	sub    $0x8,%esp
80102d0b:	68 80 26 11 80       	push   $0x80112680
80102d10:	68 80 26 11 80       	push   $0x80112680
80102d15:	e8 b6 11 00 00       	call   80103ed0 <sleep>
80102d1a:	83 c4 10             	add    $0x10,%esp
    if(log.committing){
80102d1d:	a1 c0 26 11 80       	mov    0x801126c0,%eax
80102d22:	85 c0                	test   %eax,%eax
80102d24:	75 e2                	jne    80102d08 <begin_op+0x18>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80102d26:	a1 bc 26 11 80       	mov    0x801126bc,%eax
80102d2b:	8b 15 c8 26 11 80    	mov    0x801126c8,%edx
80102d31:	83 c0 01             	add    $0x1,%eax
80102d34:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
80102d37:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
80102d3a:	83 fa 1e             	cmp    $0x1e,%edx
80102d3d:	7f c9                	jg     80102d08 <begin_op+0x18>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
      release(&log.lock);
80102d3f:	83 ec 0c             	sub    $0xc,%esp
      log.outstanding += 1;
80102d42:	a3 bc 26 11 80       	mov    %eax,0x801126bc
      release(&log.lock);
80102d47:	68 80 26 11 80       	push   $0x80112680
80102d4c:	e8 1f 18 00 00       	call   80104570 <release>
      break;
    }
  }
}
80102d51:	83 c4 10             	add    $0x10,%esp
80102d54:	c9                   	leave  
80102d55:	c3                   	ret    
80102d56:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102d5d:	8d 76 00             	lea    0x0(%esi),%esi

80102d60 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80102d60:	55                   	push   %ebp
80102d61:	89 e5                	mov    %esp,%ebp
80102d63:	57                   	push   %edi
80102d64:	56                   	push   %esi
80102d65:	53                   	push   %ebx
80102d66:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;

  acquire(&log.lock);
80102d69:	68 80 26 11 80       	push   $0x80112680
80102d6e:	e8 3d 17 00 00       	call   801044b0 <acquire>
  log.outstanding -= 1;
80102d73:	a1 bc 26 11 80       	mov    0x801126bc,%eax
  if(log.committing)
80102d78:	8b 35 c0 26 11 80    	mov    0x801126c0,%esi
80102d7e:	83 c4 10             	add    $0x10,%esp
  log.outstanding -= 1;
80102d81:	8d 58 ff             	lea    -0x1(%eax),%ebx
80102d84:	89 1d bc 26 11 80    	mov    %ebx,0x801126bc
  if(log.committing)
80102d8a:	85 f6                	test   %esi,%esi
80102d8c:	0f 85 22 01 00 00    	jne    80102eb4 <end_op+0x154>
    panic("log.committing");
  if(log.outstanding == 0){
80102d92:	85 db                	test   %ebx,%ebx
80102d94:	0f 85 f6 00 00 00    	jne    80102e90 <end_op+0x130>
    do_commit = 1;
    log.committing = 1;
80102d9a:	c7 05 c0 26 11 80 01 	movl   $0x1,0x801126c0
80102da1:	00 00 00 
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
80102da4:	83 ec 0c             	sub    $0xc,%esp
80102da7:	68 80 26 11 80       	push   $0x80112680
80102dac:	e8 bf 17 00 00       	call   80104570 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
80102db1:	8b 0d c8 26 11 80    	mov    0x801126c8,%ecx
80102db7:	83 c4 10             	add    $0x10,%esp
80102dba:	85 c9                	test   %ecx,%ecx
80102dbc:	7f 42                	jg     80102e00 <end_op+0xa0>
    acquire(&log.lock);
80102dbe:	83 ec 0c             	sub    $0xc,%esp
80102dc1:	68 80 26 11 80       	push   $0x80112680
80102dc6:	e8 e5 16 00 00       	call   801044b0 <acquire>
    wakeup(&log);
80102dcb:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
    log.committing = 0;
80102dd2:	c7 05 c0 26 11 80 00 	movl   $0x0,0x801126c0
80102dd9:	00 00 00 
    wakeup(&log);
80102ddc:	e8 9f 12 00 00       	call   80104080 <wakeup>
    release(&log.lock);
80102de1:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
80102de8:	e8 83 17 00 00       	call   80104570 <release>
80102ded:	83 c4 10             	add    $0x10,%esp
}
80102df0:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102df3:	5b                   	pop    %ebx
80102df4:	5e                   	pop    %esi
80102df5:	5f                   	pop    %edi
80102df6:	5d                   	pop    %ebp
80102df7:	c3                   	ret    
80102df8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102dff:	90                   	nop
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80102e00:	a1 b4 26 11 80       	mov    0x801126b4,%eax
80102e05:	83 ec 08             	sub    $0x8,%esp
80102e08:	01 d8                	add    %ebx,%eax
80102e0a:	83 c0 01             	add    $0x1,%eax
80102e0d:	50                   	push   %eax
80102e0e:	ff 35 c4 26 11 80    	pushl  0x801126c4
80102e14:	e8 b7 d2 ff ff       	call   801000d0 <bread>
80102e19:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102e1b:	58                   	pop    %eax
80102e1c:	5a                   	pop    %edx
80102e1d:	ff 34 9d cc 26 11 80 	pushl  -0x7feed934(,%ebx,4)
80102e24:	ff 35 c4 26 11 80    	pushl  0x801126c4
  for (tail = 0; tail < log.lh.n; tail++) {
80102e2a:	83 c3 01             	add    $0x1,%ebx
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102e2d:	e8 9e d2 ff ff       	call   801000d0 <bread>
    memmove(to->data, from->data, BSIZE);
80102e32:	83 c4 0c             	add    $0xc,%esp
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102e35:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
80102e37:	8d 40 5c             	lea    0x5c(%eax),%eax
80102e3a:	68 00 02 00 00       	push   $0x200
80102e3f:	50                   	push   %eax
80102e40:	8d 46 5c             	lea    0x5c(%esi),%eax
80102e43:	50                   	push   %eax
80102e44:	e8 17 18 00 00       	call   80104660 <memmove>
    bwrite(to);  // write the log
80102e49:	89 34 24             	mov    %esi,(%esp)
80102e4c:	e8 5f d3 ff ff       	call   801001b0 <bwrite>
    brelse(from);
80102e51:	89 3c 24             	mov    %edi,(%esp)
80102e54:	e8 97 d3 ff ff       	call   801001f0 <brelse>
    brelse(to);
80102e59:	89 34 24             	mov    %esi,(%esp)
80102e5c:	e8 8f d3 ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102e61:	83 c4 10             	add    $0x10,%esp
80102e64:	3b 1d c8 26 11 80    	cmp    0x801126c8,%ebx
80102e6a:	7c 94                	jl     80102e00 <end_op+0xa0>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
80102e6c:	e8 7f fd ff ff       	call   80102bf0 <write_head>
    install_trans(); // Now install writes to home locations
80102e71:	e8 da fc ff ff       	call   80102b50 <install_trans>
    log.lh.n = 0;
80102e76:	c7 05 c8 26 11 80 00 	movl   $0x0,0x801126c8
80102e7d:	00 00 00 
    write_head();    // Erase the transaction from the log
80102e80:	e8 6b fd ff ff       	call   80102bf0 <write_head>
80102e85:	e9 34 ff ff ff       	jmp    80102dbe <end_op+0x5e>
80102e8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    wakeup(&log);
80102e90:	83 ec 0c             	sub    $0xc,%esp
80102e93:	68 80 26 11 80       	push   $0x80112680
80102e98:	e8 e3 11 00 00       	call   80104080 <wakeup>
  release(&log.lock);
80102e9d:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
80102ea4:	e8 c7 16 00 00       	call   80104570 <release>
80102ea9:	83 c4 10             	add    $0x10,%esp
}
80102eac:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102eaf:	5b                   	pop    %ebx
80102eb0:	5e                   	pop    %esi
80102eb1:	5f                   	pop    %edi
80102eb2:	5d                   	pop    %ebp
80102eb3:	c3                   	ret    
    panic("log.committing");
80102eb4:	83 ec 0c             	sub    $0xc,%esp
80102eb7:	68 84 74 10 80       	push   $0x80107484
80102ebc:	e8 cf d4 ff ff       	call   80100390 <panic>
80102ec1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102ec8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102ecf:	90                   	nop

80102ed0 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80102ed0:	55                   	push   %ebp
80102ed1:	89 e5                	mov    %esp,%ebp
80102ed3:	53                   	push   %ebx
80102ed4:	83 ec 04             	sub    $0x4,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102ed7:	8b 15 c8 26 11 80    	mov    0x801126c8,%edx
{
80102edd:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102ee0:	83 fa 1d             	cmp    $0x1d,%edx
80102ee3:	0f 8f 94 00 00 00    	jg     80102f7d <log_write+0xad>
80102ee9:	a1 b8 26 11 80       	mov    0x801126b8,%eax
80102eee:	83 e8 01             	sub    $0x1,%eax
80102ef1:	39 c2                	cmp    %eax,%edx
80102ef3:	0f 8d 84 00 00 00    	jge    80102f7d <log_write+0xad>
    panic("too big a transaction");
  if (log.outstanding < 1)
80102ef9:	a1 bc 26 11 80       	mov    0x801126bc,%eax
80102efe:	85 c0                	test   %eax,%eax
80102f00:	0f 8e 84 00 00 00    	jle    80102f8a <log_write+0xba>
    panic("log_write outside of trans");

  acquire(&log.lock);
80102f06:	83 ec 0c             	sub    $0xc,%esp
80102f09:	68 80 26 11 80       	push   $0x80112680
80102f0e:	e8 9d 15 00 00       	call   801044b0 <acquire>
  for (i = 0; i < log.lh.n; i++) {
80102f13:	8b 15 c8 26 11 80    	mov    0x801126c8,%edx
80102f19:	83 c4 10             	add    $0x10,%esp
80102f1c:	85 d2                	test   %edx,%edx
80102f1e:	7e 51                	jle    80102f71 <log_write+0xa1>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102f20:	8b 4b 08             	mov    0x8(%ebx),%ecx
  for (i = 0; i < log.lh.n; i++) {
80102f23:	31 c0                	xor    %eax,%eax
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102f25:	3b 0d cc 26 11 80    	cmp    0x801126cc,%ecx
80102f2b:	75 0c                	jne    80102f39 <log_write+0x69>
80102f2d:	eb 39                	jmp    80102f68 <log_write+0x98>
80102f2f:	90                   	nop
80102f30:	39 0c 85 cc 26 11 80 	cmp    %ecx,-0x7feed934(,%eax,4)
80102f37:	74 2f                	je     80102f68 <log_write+0x98>
  for (i = 0; i < log.lh.n; i++) {
80102f39:	83 c0 01             	add    $0x1,%eax
80102f3c:	39 c2                	cmp    %eax,%edx
80102f3e:	75 f0                	jne    80102f30 <log_write+0x60>
      break;
  }
  log.lh.block[i] = b->blockno;
80102f40:	89 0c 95 cc 26 11 80 	mov    %ecx,-0x7feed934(,%edx,4)
  if (i == log.lh.n)
    log.lh.n++;
80102f47:	83 c2 01             	add    $0x1,%edx
80102f4a:	89 15 c8 26 11 80    	mov    %edx,0x801126c8
  b->flags |= B_DIRTY; // prevent eviction
80102f50:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
}
80102f53:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  release(&log.lock);
80102f56:	c7 45 08 80 26 11 80 	movl   $0x80112680,0x8(%ebp)
}
80102f5d:	c9                   	leave  
  release(&log.lock);
80102f5e:	e9 0d 16 00 00       	jmp    80104570 <release>
80102f63:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102f67:	90                   	nop
  log.lh.block[i] = b->blockno;
80102f68:	89 0c 85 cc 26 11 80 	mov    %ecx,-0x7feed934(,%eax,4)
  if (i == log.lh.n)
80102f6f:	eb df                	jmp    80102f50 <log_write+0x80>
  log.lh.block[i] = b->blockno;
80102f71:	8b 43 08             	mov    0x8(%ebx),%eax
80102f74:	a3 cc 26 11 80       	mov    %eax,0x801126cc
  if (i == log.lh.n)
80102f79:	75 d5                	jne    80102f50 <log_write+0x80>
80102f7b:	eb ca                	jmp    80102f47 <log_write+0x77>
    panic("too big a transaction");
80102f7d:	83 ec 0c             	sub    $0xc,%esp
80102f80:	68 93 74 10 80       	push   $0x80107493
80102f85:	e8 06 d4 ff ff       	call   80100390 <panic>
    panic("log_write outside of trans");
80102f8a:	83 ec 0c             	sub    $0xc,%esp
80102f8d:	68 a9 74 10 80       	push   $0x801074a9
80102f92:	e8 f9 d3 ff ff       	call   80100390 <panic>
80102f97:	66 90                	xchg   %ax,%ax
80102f99:	66 90                	xchg   %ax,%ax
80102f9b:	66 90                	xchg   %ax,%ax
80102f9d:	66 90                	xchg   %ax,%ax
80102f9f:	90                   	nop

80102fa0 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
80102fa0:	55                   	push   %ebp
80102fa1:	89 e5                	mov    %esp,%ebp
80102fa3:	53                   	push   %ebx
80102fa4:	83 ec 04             	sub    $0x4,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
80102fa7:	e8 64 09 00 00       	call   80103910 <cpuid>
80102fac:	89 c3                	mov    %eax,%ebx
80102fae:	e8 5d 09 00 00       	call   80103910 <cpuid>
80102fb3:	83 ec 04             	sub    $0x4,%esp
80102fb6:	53                   	push   %ebx
80102fb7:	50                   	push   %eax
80102fb8:	68 c4 74 10 80       	push   $0x801074c4
80102fbd:	e8 ee d6 ff ff       	call   801006b0 <cprintf>
  idtinit();       // load idt register
80102fc2:	e8 39 28 00 00       	call   80105800 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
80102fc7:	e8 c4 08 00 00       	call   80103890 <mycpu>
80102fcc:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
80102fce:	b8 01 00 00 00       	mov    $0x1,%eax
80102fd3:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
80102fda:	e8 11 0c 00 00       	call   80103bf0 <scheduler>
80102fdf:	90                   	nop

80102fe0 <mpenter>:
{
80102fe0:	55                   	push   %ebp
80102fe1:	89 e5                	mov    %esp,%ebp
80102fe3:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
80102fe6:	e8 15 39 00 00       	call   80106900 <switchkvm>
  seginit();
80102feb:	e8 80 38 00 00       	call   80106870 <seginit>
  lapicinit();
80102ff0:	e8 8b f7 ff ff       	call   80102780 <lapicinit>
  mpmain();
80102ff5:	e8 a6 ff ff ff       	call   80102fa0 <mpmain>
80102ffa:	66 90                	xchg   %ax,%ax
80102ffc:	66 90                	xchg   %ax,%ax
80102ffe:	66 90                	xchg   %ax,%ax

80103000 <main>:
{
80103000:	8d 4c 24 04          	lea    0x4(%esp),%ecx
80103004:	83 e4 f0             	and    $0xfffffff0,%esp
80103007:	ff 71 fc             	pushl  -0x4(%ecx)
8010300a:	55                   	push   %ebp
8010300b:	89 e5                	mov    %esp,%ebp
8010300d:	53                   	push   %ebx
8010300e:	51                   	push   %ecx
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
8010300f:	83 ec 08             	sub    $0x8,%esp
80103012:	68 00 00 40 80       	push   $0x80400000
80103017:	68 a8 54 11 80       	push   $0x801154a8
8010301c:	e8 bf f4 ff ff       	call   801024e0 <kinit1>
  kvmalloc();      // kernel page table
80103021:	e8 9a 3d 00 00       	call   80106dc0 <kvmalloc>
  mpinit();        // detect other processors
80103026:	e8 85 01 00 00       	call   801031b0 <mpinit>
  lapicinit();     // interrupt controller
8010302b:	e8 50 f7 ff ff       	call   80102780 <lapicinit>
  seginit();       // segment descriptors
80103030:	e8 3b 38 00 00       	call   80106870 <seginit>
  picinit();       // disable pic
80103035:	e8 46 03 00 00       	call   80103380 <picinit>
  ioapicinit();    // another interrupt controller
8010303a:	e8 c1 f2 ff ff       	call   80102300 <ioapicinit>
  consoleinit();   // console hardware
8010303f:	e8 ec d9 ff ff       	call   80100a30 <consoleinit>
  uartinit();      // serial port
80103044:	e8 e7 2a 00 00       	call   80105b30 <uartinit>
  pinit();         // process table
80103049:	e8 22 08 00 00       	call   80103870 <pinit>
  tvinit();        // trap vectors
8010304e:	e8 2d 27 00 00       	call   80105780 <tvinit>
  binit();         // buffer cache
80103053:	e8 e8 cf ff ff       	call   80100040 <binit>
  fileinit();      // file table
80103058:	e8 83 dd ff ff       	call   80100de0 <fileinit>
  ideinit();       // disk 
8010305d:	e8 7e f0 ff ff       	call   801020e0 <ideinit>

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
80103062:	83 c4 0c             	add    $0xc,%esp
80103065:	68 8a 00 00 00       	push   $0x8a
8010306a:	68 8c a4 10 80       	push   $0x8010a48c
8010306f:	68 00 70 00 80       	push   $0x80007000
80103074:	e8 e7 15 00 00       	call   80104660 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
80103079:	83 c4 10             	add    $0x10,%esp
8010307c:	69 05 00 2d 11 80 b0 	imul   $0xb0,0x80112d00,%eax
80103083:	00 00 00 
80103086:	05 80 27 11 80       	add    $0x80112780,%eax
8010308b:	3d 80 27 11 80       	cmp    $0x80112780,%eax
80103090:	76 7e                	jbe    80103110 <main+0x110>
80103092:	bb 80 27 11 80       	mov    $0x80112780,%ebx
80103097:	eb 20                	jmp    801030b9 <main+0xb9>
80103099:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801030a0:	69 05 00 2d 11 80 b0 	imul   $0xb0,0x80112d00,%eax
801030a7:	00 00 00 
801030aa:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
801030b0:	05 80 27 11 80       	add    $0x80112780,%eax
801030b5:	39 c3                	cmp    %eax,%ebx
801030b7:	73 57                	jae    80103110 <main+0x110>
    if(c == mycpu())  // We've started already.
801030b9:	e8 d2 07 00 00       	call   80103890 <mycpu>
801030be:	39 d8                	cmp    %ebx,%eax
801030c0:	74 de                	je     801030a0 <main+0xa0>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
801030c2:	e8 e9 f4 ff ff       	call   801025b0 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
    *(void(**)(void))(code-8) = mpenter;
    *(int**)(code-12) = (void *) V2P(entrypgdir);

    lapicstartap(c->apicid, V2P(code));
801030c7:	83 ec 08             	sub    $0x8,%esp
    *(void(**)(void))(code-8) = mpenter;
801030ca:	c7 05 f8 6f 00 80 e0 	movl   $0x80102fe0,0x80006ff8
801030d1:	2f 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
801030d4:	c7 05 f4 6f 00 80 00 	movl   $0x109000,0x80006ff4
801030db:	90 10 00 
    *(void**)(code-4) = stack + KSTACKSIZE;
801030de:	05 00 10 00 00       	add    $0x1000,%eax
801030e3:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc
    lapicstartap(c->apicid, V2P(code));
801030e8:	0f b6 03             	movzbl (%ebx),%eax
801030eb:	68 00 70 00 00       	push   $0x7000
801030f0:	50                   	push   %eax
801030f1:	e8 da f7 ff ff       	call   801028d0 <lapicstartap>
801030f6:	83 c4 10             	add    $0x10,%esp
801030f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

    // wait for cpu to finish mpmain()
    while(c->started == 0)
80103100:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
80103106:	85 c0                	test   %eax,%eax
80103108:	74 f6                	je     80103100 <main+0x100>
8010310a:	eb 94                	jmp    801030a0 <main+0xa0>
8010310c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
80103110:	83 ec 08             	sub    $0x8,%esp
80103113:	68 00 00 00 8e       	push   $0x8e000000
80103118:	68 00 00 40 80       	push   $0x80400000
8010311d:	e8 2e f4 ff ff       	call   80102550 <kinit2>
  userinit();      // first user process
80103122:	e8 39 08 00 00       	call   80103960 <userinit>
  mpmain();        // finish this processor's setup
80103127:	e8 74 fe ff ff       	call   80102fa0 <mpmain>
8010312c:	66 90                	xchg   %ax,%ax
8010312e:	66 90                	xchg   %ax,%ax

80103130 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80103130:	55                   	push   %ebp
80103131:	89 e5                	mov    %esp,%ebp
80103133:	57                   	push   %edi
80103134:	56                   	push   %esi
  uchar *e, *p, *addr;

  addr = P2V(a);
80103135:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
{
8010313b:	53                   	push   %ebx
  e = addr+len;
8010313c:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
{
8010313f:	83 ec 0c             	sub    $0xc,%esp
  for(p = addr; p < e; p += sizeof(struct mp))
80103142:	39 de                	cmp    %ebx,%esi
80103144:	72 10                	jb     80103156 <mpsearch1+0x26>
80103146:	eb 50                	jmp    80103198 <mpsearch1+0x68>
80103148:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010314f:	90                   	nop
80103150:	89 fe                	mov    %edi,%esi
80103152:	39 fb                	cmp    %edi,%ebx
80103154:	76 42                	jbe    80103198 <mpsearch1+0x68>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103156:	83 ec 04             	sub    $0x4,%esp
80103159:	8d 7e 10             	lea    0x10(%esi),%edi
8010315c:	6a 04                	push   $0x4
8010315e:	68 d8 74 10 80       	push   $0x801074d8
80103163:	56                   	push   %esi
80103164:	e8 a7 14 00 00       	call   80104610 <memcmp>
80103169:	83 c4 10             	add    $0x10,%esp
8010316c:	85 c0                	test   %eax,%eax
8010316e:	75 e0                	jne    80103150 <mpsearch1+0x20>
80103170:	89 f1                	mov    %esi,%ecx
80103172:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    sum += addr[i];
80103178:	0f b6 11             	movzbl (%ecx),%edx
8010317b:	83 c1 01             	add    $0x1,%ecx
8010317e:	01 d0                	add    %edx,%eax
  for(i=0; i<len; i++)
80103180:	39 f9                	cmp    %edi,%ecx
80103182:	75 f4                	jne    80103178 <mpsearch1+0x48>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103184:	84 c0                	test   %al,%al
80103186:	75 c8                	jne    80103150 <mpsearch1+0x20>
      return (struct mp*)p;
  return 0;
}
80103188:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010318b:	89 f0                	mov    %esi,%eax
8010318d:	5b                   	pop    %ebx
8010318e:	5e                   	pop    %esi
8010318f:	5f                   	pop    %edi
80103190:	5d                   	pop    %ebp
80103191:	c3                   	ret    
80103192:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103198:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
8010319b:	31 f6                	xor    %esi,%esi
}
8010319d:	5b                   	pop    %ebx
8010319e:	89 f0                	mov    %esi,%eax
801031a0:	5e                   	pop    %esi
801031a1:	5f                   	pop    %edi
801031a2:	5d                   	pop    %ebp
801031a3:	c3                   	ret    
801031a4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801031ab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801031af:	90                   	nop

801031b0 <mpinit>:
  return conf;
}

void
mpinit(void)
{
801031b0:	55                   	push   %ebp
801031b1:	89 e5                	mov    %esp,%ebp
801031b3:	57                   	push   %edi
801031b4:	56                   	push   %esi
801031b5:	53                   	push   %ebx
801031b6:	83 ec 1c             	sub    $0x1c,%esp
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
801031b9:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
801031c0:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
801031c7:	c1 e0 08             	shl    $0x8,%eax
801031ca:	09 d0                	or     %edx,%eax
801031cc:	c1 e0 04             	shl    $0x4,%eax
801031cf:	75 1b                	jne    801031ec <mpinit+0x3c>
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
801031d1:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
801031d8:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
801031df:	c1 e0 08             	shl    $0x8,%eax
801031e2:	09 d0                	or     %edx,%eax
801031e4:	c1 e0 0a             	shl    $0xa,%eax
    if((mp = mpsearch1(p-1024, 1024)))
801031e7:	2d 00 04 00 00       	sub    $0x400,%eax
    if((mp = mpsearch1(p, 1024)))
801031ec:	ba 00 04 00 00       	mov    $0x400,%edx
801031f1:	e8 3a ff ff ff       	call   80103130 <mpsearch1>
801031f6:	89 c7                	mov    %eax,%edi
801031f8:	85 c0                	test   %eax,%eax
801031fa:	0f 84 c0 00 00 00    	je     801032c0 <mpinit+0x110>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103200:	8b 5f 04             	mov    0x4(%edi),%ebx
80103203:	85 db                	test   %ebx,%ebx
80103205:	0f 84 d5 00 00 00    	je     801032e0 <mpinit+0x130>
  if(memcmp(conf, "PCMP", 4) != 0)
8010320b:	83 ec 04             	sub    $0x4,%esp
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
8010320e:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
  if(memcmp(conf, "PCMP", 4) != 0)
80103214:	6a 04                	push   $0x4
80103216:	68 f5 74 10 80       	push   $0x801074f5
8010321b:	50                   	push   %eax
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
8010321c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
8010321f:	e8 ec 13 00 00       	call   80104610 <memcmp>
80103224:	83 c4 10             	add    $0x10,%esp
80103227:	85 c0                	test   %eax,%eax
80103229:	0f 85 b1 00 00 00    	jne    801032e0 <mpinit+0x130>
  if(conf->version != 1 && conf->version != 4)
8010322f:	0f b6 83 06 00 00 80 	movzbl -0x7ffffffa(%ebx),%eax
80103236:	3c 01                	cmp    $0x1,%al
80103238:	0f 95 c2             	setne  %dl
8010323b:	3c 04                	cmp    $0x4,%al
8010323d:	0f 95 c0             	setne  %al
80103240:	20 c2                	and    %al,%dl
80103242:	0f 85 98 00 00 00    	jne    801032e0 <mpinit+0x130>
  if(sum((uchar*)conf, conf->length) != 0)
80103248:	0f b7 8b 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%ecx
  for(i=0; i<len; i++)
8010324f:	66 85 c9             	test   %cx,%cx
80103252:	74 21                	je     80103275 <mpinit+0xc5>
80103254:	89 d8                	mov    %ebx,%eax
80103256:	8d 34 19             	lea    (%ecx,%ebx,1),%esi
  sum = 0;
80103259:	31 d2                	xor    %edx,%edx
8010325b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010325f:	90                   	nop
    sum += addr[i];
80103260:	0f b6 88 00 00 00 80 	movzbl -0x80000000(%eax),%ecx
80103267:	83 c0 01             	add    $0x1,%eax
8010326a:	01 ca                	add    %ecx,%edx
  for(i=0; i<len; i++)
8010326c:	39 c6                	cmp    %eax,%esi
8010326e:	75 f0                	jne    80103260 <mpinit+0xb0>
80103270:	84 d2                	test   %dl,%dl
80103272:	0f 95 c2             	setne  %dl
  struct mp *mp;
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
80103275:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80103278:	85 c9                	test   %ecx,%ecx
8010327a:	74 64                	je     801032e0 <mpinit+0x130>
8010327c:	84 d2                	test   %dl,%dl
8010327e:	75 60                	jne    801032e0 <mpinit+0x130>
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
80103280:	8b 83 24 00 00 80    	mov    -0x7fffffdc(%ebx),%eax
80103286:	a3 7c 26 11 80       	mov    %eax,0x8011267c
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
8010328b:	0f b7 93 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edx
80103292:	8d 83 2c 00 00 80    	lea    -0x7fffffd4(%ebx),%eax
  ismp = 1;
80103298:	bb 01 00 00 00       	mov    $0x1,%ebx
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
8010329d:	01 d1                	add    %edx,%ecx
8010329f:	89 ce                	mov    %ecx,%esi
801032a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801032a8:	39 c6                	cmp    %eax,%esi
801032aa:	76 4b                	jbe    801032f7 <mpinit+0x147>
    switch(*p){
801032ac:	0f b6 10             	movzbl (%eax),%edx
801032af:	80 fa 04             	cmp    $0x4,%dl
801032b2:	0f 87 bf 00 00 00    	ja     80103377 <mpinit+0x1c7>
801032b8:	ff 24 95 1c 75 10 80 	jmp    *-0x7fef8ae4(,%edx,4)
801032bf:	90                   	nop
  return mpsearch1(0xF0000, 0x10000);
801032c0:	ba 00 00 01 00       	mov    $0x10000,%edx
801032c5:	b8 00 00 0f 00       	mov    $0xf0000,%eax
801032ca:	e8 61 fe ff ff       	call   80103130 <mpsearch1>
801032cf:	89 c7                	mov    %eax,%edi
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
801032d1:	85 c0                	test   %eax,%eax
801032d3:	0f 85 27 ff ff ff    	jne    80103200 <mpinit+0x50>
801032d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    panic("Expect to run on an SMP");
801032e0:	83 ec 0c             	sub    $0xc,%esp
801032e3:	68 dd 74 10 80       	push   $0x801074dd
801032e8:	e8 a3 d0 ff ff       	call   80100390 <panic>
801032ed:	8d 76 00             	lea    0x0(%esi),%esi
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
801032f0:	83 c0 08             	add    $0x8,%eax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801032f3:	39 c6                	cmp    %eax,%esi
801032f5:	77 b5                	ja     801032ac <mpinit+0xfc>
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
801032f7:	85 db                	test   %ebx,%ebx
801032f9:	74 6f                	je     8010336a <mpinit+0x1ba>
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
801032fb:	80 7f 0c 00          	cmpb   $0x0,0xc(%edi)
801032ff:	74 15                	je     80103316 <mpinit+0x166>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103301:	b8 70 00 00 00       	mov    $0x70,%eax
80103306:	ba 22 00 00 00       	mov    $0x22,%edx
8010330b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010330c:	ba 23 00 00 00       	mov    $0x23,%edx
80103311:	ec                   	in     (%dx),%al
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
80103312:	83 c8 01             	or     $0x1,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103315:	ee                   	out    %al,(%dx)
  }
}
80103316:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103319:	5b                   	pop    %ebx
8010331a:	5e                   	pop    %esi
8010331b:	5f                   	pop    %edi
8010331c:	5d                   	pop    %ebp
8010331d:	c3                   	ret    
8010331e:	66 90                	xchg   %ax,%ax
      if(ncpu < NCPU) {
80103320:	8b 15 00 2d 11 80    	mov    0x80112d00,%edx
80103326:	83 fa 07             	cmp    $0x7,%edx
80103329:	7f 1f                	jg     8010334a <mpinit+0x19a>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
8010332b:	69 ca b0 00 00 00    	imul   $0xb0,%edx,%ecx
80103331:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80103334:	0f b6 50 01          	movzbl 0x1(%eax),%edx
80103338:	88 91 80 27 11 80    	mov    %dl,-0x7feed880(%ecx)
        ncpu++;
8010333e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103341:	83 c2 01             	add    $0x1,%edx
80103344:	89 15 00 2d 11 80    	mov    %edx,0x80112d00
      p += sizeof(struct mpproc);
8010334a:	83 c0 14             	add    $0x14,%eax
      continue;
8010334d:	e9 56 ff ff ff       	jmp    801032a8 <mpinit+0xf8>
80103352:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      ioapicid = ioapic->apicno;
80103358:	0f b6 50 01          	movzbl 0x1(%eax),%edx
      p += sizeof(struct mpioapic);
8010335c:	83 c0 08             	add    $0x8,%eax
      ioapicid = ioapic->apicno;
8010335f:	88 15 60 27 11 80    	mov    %dl,0x80112760
      continue;
80103365:	e9 3e ff ff ff       	jmp    801032a8 <mpinit+0xf8>
    panic("Didn't find a suitable machine");
8010336a:	83 ec 0c             	sub    $0xc,%esp
8010336d:	68 fc 74 10 80       	push   $0x801074fc
80103372:	e8 19 d0 ff ff       	call   80100390 <panic>
      ismp = 0;
80103377:	31 db                	xor    %ebx,%ebx
80103379:	e9 31 ff ff ff       	jmp    801032af <mpinit+0xff>
8010337e:	66 90                	xchg   %ax,%ax

80103380 <picinit>:
80103380:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103385:	ba 21 00 00 00       	mov    $0x21,%edx
8010338a:	ee                   	out    %al,(%dx)
8010338b:	ba a1 00 00 00       	mov    $0xa1,%edx
80103390:	ee                   	out    %al,(%dx)
picinit(void)
{
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
80103391:	c3                   	ret    
80103392:	66 90                	xchg   %ax,%ax
80103394:	66 90                	xchg   %ax,%ax
80103396:	66 90                	xchg   %ax,%ax
80103398:	66 90                	xchg   %ax,%ax
8010339a:	66 90                	xchg   %ax,%ax
8010339c:	66 90                	xchg   %ax,%ax
8010339e:	66 90                	xchg   %ax,%ax

801033a0 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
801033a0:	55                   	push   %ebp
801033a1:	89 e5                	mov    %esp,%ebp
801033a3:	57                   	push   %edi
801033a4:	56                   	push   %esi
801033a5:	53                   	push   %ebx
801033a6:	83 ec 0c             	sub    $0xc,%esp
801033a9:	8b 5d 08             	mov    0x8(%ebp),%ebx
801033ac:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
801033af:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
801033b5:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
801033bb:	e8 40 da ff ff       	call   80100e00 <filealloc>
801033c0:	89 03                	mov    %eax,(%ebx)
801033c2:	85 c0                	test   %eax,%eax
801033c4:	0f 84 a8 00 00 00    	je     80103472 <pipealloc+0xd2>
801033ca:	e8 31 da ff ff       	call   80100e00 <filealloc>
801033cf:	89 06                	mov    %eax,(%esi)
801033d1:	85 c0                	test   %eax,%eax
801033d3:	0f 84 87 00 00 00    	je     80103460 <pipealloc+0xc0>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
801033d9:	e8 d2 f1 ff ff       	call   801025b0 <kalloc>
801033de:	89 c7                	mov    %eax,%edi
801033e0:	85 c0                	test   %eax,%eax
801033e2:	0f 84 b0 00 00 00    	je     80103498 <pipealloc+0xf8>
    goto bad;
  p->readopen = 1;
801033e8:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
801033ef:	00 00 00 
  p->writeopen = 1;
  p->nwrite = 0;
  p->nread = 0;
  initlock(&p->lock, "pipe");
801033f2:	83 ec 08             	sub    $0x8,%esp
  p->writeopen = 1;
801033f5:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
801033fc:	00 00 00 
  p->nwrite = 0;
801033ff:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
80103406:	00 00 00 
  p->nread = 0;
80103409:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
80103410:	00 00 00 
  initlock(&p->lock, "pipe");
80103413:	68 30 75 10 80       	push   $0x80107530
80103418:	50                   	push   %eax
80103419:	e8 32 0f 00 00       	call   80104350 <initlock>
  (*f0)->type = FD_PIPE;
8010341e:	8b 03                	mov    (%ebx),%eax
  (*f0)->pipe = p;
  (*f1)->type = FD_PIPE;
  (*f1)->readable = 0;
  (*f1)->writable = 1;
  (*f1)->pipe = p;
  return 0;
80103420:	83 c4 10             	add    $0x10,%esp
  (*f0)->type = FD_PIPE;
80103423:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
80103429:	8b 03                	mov    (%ebx),%eax
8010342b:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
8010342f:	8b 03                	mov    (%ebx),%eax
80103431:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
80103435:	8b 03                	mov    (%ebx),%eax
80103437:	89 78 0c             	mov    %edi,0xc(%eax)
  (*f1)->type = FD_PIPE;
8010343a:	8b 06                	mov    (%esi),%eax
8010343c:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
80103442:	8b 06                	mov    (%esi),%eax
80103444:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
80103448:	8b 06                	mov    (%esi),%eax
8010344a:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
8010344e:	8b 06                	mov    (%esi),%eax
80103450:	89 78 0c             	mov    %edi,0xc(%eax)
  if(*f0)
    fileclose(*f0);
  if(*f1)
    fileclose(*f1);
  return -1;
}
80103453:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80103456:	31 c0                	xor    %eax,%eax
}
80103458:	5b                   	pop    %ebx
80103459:	5e                   	pop    %esi
8010345a:	5f                   	pop    %edi
8010345b:	5d                   	pop    %ebp
8010345c:	c3                   	ret    
8010345d:	8d 76 00             	lea    0x0(%esi),%esi
  if(*f0)
80103460:	8b 03                	mov    (%ebx),%eax
80103462:	85 c0                	test   %eax,%eax
80103464:	74 1e                	je     80103484 <pipealloc+0xe4>
    fileclose(*f0);
80103466:	83 ec 0c             	sub    $0xc,%esp
80103469:	50                   	push   %eax
8010346a:	e8 51 da ff ff       	call   80100ec0 <fileclose>
8010346f:	83 c4 10             	add    $0x10,%esp
  if(*f1)
80103472:	8b 06                	mov    (%esi),%eax
80103474:	85 c0                	test   %eax,%eax
80103476:	74 0c                	je     80103484 <pipealloc+0xe4>
    fileclose(*f1);
80103478:	83 ec 0c             	sub    $0xc,%esp
8010347b:	50                   	push   %eax
8010347c:	e8 3f da ff ff       	call   80100ec0 <fileclose>
80103481:	83 c4 10             	add    $0x10,%esp
}
80103484:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return -1;
80103487:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010348c:	5b                   	pop    %ebx
8010348d:	5e                   	pop    %esi
8010348e:	5f                   	pop    %edi
8010348f:	5d                   	pop    %ebp
80103490:	c3                   	ret    
80103491:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(*f0)
80103498:	8b 03                	mov    (%ebx),%eax
8010349a:	85 c0                	test   %eax,%eax
8010349c:	75 c8                	jne    80103466 <pipealloc+0xc6>
8010349e:	eb d2                	jmp    80103472 <pipealloc+0xd2>

801034a0 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
801034a0:	55                   	push   %ebp
801034a1:	89 e5                	mov    %esp,%ebp
801034a3:	56                   	push   %esi
801034a4:	53                   	push   %ebx
801034a5:	8b 5d 08             	mov    0x8(%ebp),%ebx
801034a8:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
801034ab:	83 ec 0c             	sub    $0xc,%esp
801034ae:	53                   	push   %ebx
801034af:	e8 fc 0f 00 00       	call   801044b0 <acquire>
  if(writable){
801034b4:	83 c4 10             	add    $0x10,%esp
801034b7:	85 f6                	test   %esi,%esi
801034b9:	74 65                	je     80103520 <pipeclose+0x80>
    p->writeopen = 0;
    wakeup(&p->nread);
801034bb:	83 ec 0c             	sub    $0xc,%esp
801034be:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
    p->writeopen = 0;
801034c4:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
801034cb:	00 00 00 
    wakeup(&p->nread);
801034ce:	50                   	push   %eax
801034cf:	e8 ac 0b 00 00       	call   80104080 <wakeup>
801034d4:	83 c4 10             	add    $0x10,%esp
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
801034d7:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
801034dd:	85 d2                	test   %edx,%edx
801034df:	75 0a                	jne    801034eb <pipeclose+0x4b>
801034e1:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
801034e7:	85 c0                	test   %eax,%eax
801034e9:	74 15                	je     80103500 <pipeclose+0x60>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
801034eb:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801034ee:	8d 65 f8             	lea    -0x8(%ebp),%esp
801034f1:	5b                   	pop    %ebx
801034f2:	5e                   	pop    %esi
801034f3:	5d                   	pop    %ebp
    release(&p->lock);
801034f4:	e9 77 10 00 00       	jmp    80104570 <release>
801034f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    release(&p->lock);
80103500:	83 ec 0c             	sub    $0xc,%esp
80103503:	53                   	push   %ebx
80103504:	e8 67 10 00 00       	call   80104570 <release>
    kfree((char*)p);
80103509:	89 5d 08             	mov    %ebx,0x8(%ebp)
8010350c:	83 c4 10             	add    $0x10,%esp
}
8010350f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103512:	5b                   	pop    %ebx
80103513:	5e                   	pop    %esi
80103514:	5d                   	pop    %ebp
    kfree((char*)p);
80103515:	e9 d6 ee ff ff       	jmp    801023f0 <kfree>
8010351a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    wakeup(&p->nwrite);
80103520:	83 ec 0c             	sub    $0xc,%esp
80103523:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
    p->readopen = 0;
80103529:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
80103530:	00 00 00 
    wakeup(&p->nwrite);
80103533:	50                   	push   %eax
80103534:	e8 47 0b 00 00       	call   80104080 <wakeup>
80103539:	83 c4 10             	add    $0x10,%esp
8010353c:	eb 99                	jmp    801034d7 <pipeclose+0x37>
8010353e:	66 90                	xchg   %ax,%ax

80103540 <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
80103540:	55                   	push   %ebp
80103541:	89 e5                	mov    %esp,%ebp
80103543:	57                   	push   %edi
80103544:	56                   	push   %esi
80103545:	53                   	push   %ebx
80103546:	83 ec 28             	sub    $0x28,%esp
80103549:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  acquire(&p->lock);
8010354c:	53                   	push   %ebx
8010354d:	e8 5e 0f 00 00       	call   801044b0 <acquire>
  for(i = 0; i < n; i++){
80103552:	8b 45 10             	mov    0x10(%ebp),%eax
80103555:	83 c4 10             	add    $0x10,%esp
80103558:	85 c0                	test   %eax,%eax
8010355a:	0f 8e c8 00 00 00    	jle    80103628 <pipewrite+0xe8>
80103560:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80103563:	8b 83 38 02 00 00    	mov    0x238(%ebx),%eax
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
      if(p->readopen == 0 || myproc()->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
80103569:	8d bb 34 02 00 00    	lea    0x234(%ebx),%edi
8010356f:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80103572:	03 4d 10             	add    0x10(%ebp),%ecx
80103575:	89 4d e0             	mov    %ecx,-0x20(%ebp)
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103578:	8b 8b 34 02 00 00    	mov    0x234(%ebx),%ecx
8010357e:	8d 91 00 02 00 00    	lea    0x200(%ecx),%edx
80103584:	39 d0                	cmp    %edx,%eax
80103586:	75 71                	jne    801035f9 <pipewrite+0xb9>
      if(p->readopen == 0 || myproc()->killed){
80103588:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
8010358e:	85 c0                	test   %eax,%eax
80103590:	74 4e                	je     801035e0 <pipewrite+0xa0>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103592:	8d b3 38 02 00 00    	lea    0x238(%ebx),%esi
80103598:	eb 3a                	jmp    801035d4 <pipewrite+0x94>
8010359a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      wakeup(&p->nread);
801035a0:	83 ec 0c             	sub    $0xc,%esp
801035a3:	57                   	push   %edi
801035a4:	e8 d7 0a 00 00       	call   80104080 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
801035a9:	5a                   	pop    %edx
801035aa:	59                   	pop    %ecx
801035ab:	53                   	push   %ebx
801035ac:	56                   	push   %esi
801035ad:	e8 1e 09 00 00       	call   80103ed0 <sleep>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801035b2:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
801035b8:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
801035be:	83 c4 10             	add    $0x10,%esp
801035c1:	05 00 02 00 00       	add    $0x200,%eax
801035c6:	39 c2                	cmp    %eax,%edx
801035c8:	75 36                	jne    80103600 <pipewrite+0xc0>
      if(p->readopen == 0 || myproc()->killed){
801035ca:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
801035d0:	85 c0                	test   %eax,%eax
801035d2:	74 0c                	je     801035e0 <pipewrite+0xa0>
801035d4:	e8 57 03 00 00       	call   80103930 <myproc>
801035d9:	8b 40 24             	mov    0x24(%eax),%eax
801035dc:	85 c0                	test   %eax,%eax
801035de:	74 c0                	je     801035a0 <pipewrite+0x60>
        release(&p->lock);
801035e0:	83 ec 0c             	sub    $0xc,%esp
801035e3:	53                   	push   %ebx
801035e4:	e8 87 0f 00 00       	call   80104570 <release>
        return -1;
801035e9:	83 c4 10             	add    $0x10,%esp
801035ec:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
801035f1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801035f4:	5b                   	pop    %ebx
801035f5:	5e                   	pop    %esi
801035f6:	5f                   	pop    %edi
801035f7:	5d                   	pop    %ebp
801035f8:	c3                   	ret    
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801035f9:	89 c2                	mov    %eax,%edx
801035fb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801035ff:	90                   	nop
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80103600:	8b 75 e4             	mov    -0x1c(%ebp),%esi
80103603:	8d 42 01             	lea    0x1(%edx),%eax
80103606:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
8010360c:	89 83 38 02 00 00    	mov    %eax,0x238(%ebx)
80103612:	0f b6 0e             	movzbl (%esi),%ecx
80103615:	83 c6 01             	add    $0x1,%esi
80103618:	89 75 e4             	mov    %esi,-0x1c(%ebp)
8010361b:	88 4c 13 34          	mov    %cl,0x34(%ebx,%edx,1)
  for(i = 0; i < n; i++){
8010361f:	3b 75 e0             	cmp    -0x20(%ebp),%esi
80103622:	0f 85 50 ff ff ff    	jne    80103578 <pipewrite+0x38>
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
80103628:	83 ec 0c             	sub    $0xc,%esp
8010362b:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
80103631:	50                   	push   %eax
80103632:	e8 49 0a 00 00       	call   80104080 <wakeup>
  release(&p->lock);
80103637:	89 1c 24             	mov    %ebx,(%esp)
8010363a:	e8 31 0f 00 00       	call   80104570 <release>
  return n;
8010363f:	83 c4 10             	add    $0x10,%esp
80103642:	8b 45 10             	mov    0x10(%ebp),%eax
80103645:	eb aa                	jmp    801035f1 <pipewrite+0xb1>
80103647:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010364e:	66 90                	xchg   %ax,%ax

80103650 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
80103650:	55                   	push   %ebp
80103651:	89 e5                	mov    %esp,%ebp
80103653:	57                   	push   %edi
80103654:	56                   	push   %esi
80103655:	53                   	push   %ebx
80103656:	83 ec 18             	sub    $0x18,%esp
80103659:	8b 75 08             	mov    0x8(%ebp),%esi
8010365c:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
8010365f:	56                   	push   %esi
80103660:	e8 4b 0e 00 00       	call   801044b0 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103665:	83 c4 10             	add    $0x10,%esp
80103668:	8b 8e 34 02 00 00    	mov    0x234(%esi),%ecx
8010366e:	3b 8e 38 02 00 00    	cmp    0x238(%esi),%ecx
80103674:	75 6a                	jne    801036e0 <piperead+0x90>
80103676:	8b 9e 40 02 00 00    	mov    0x240(%esi),%ebx
8010367c:	85 db                	test   %ebx,%ebx
8010367e:	0f 84 c4 00 00 00    	je     80103748 <piperead+0xf8>
    if(myproc()->killed){
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
80103684:	8d 9e 34 02 00 00    	lea    0x234(%esi),%ebx
8010368a:	eb 2d                	jmp    801036b9 <piperead+0x69>
8010368c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103690:	83 ec 08             	sub    $0x8,%esp
80103693:	56                   	push   %esi
80103694:	53                   	push   %ebx
80103695:	e8 36 08 00 00       	call   80103ed0 <sleep>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
8010369a:	83 c4 10             	add    $0x10,%esp
8010369d:	8b 8e 34 02 00 00    	mov    0x234(%esi),%ecx
801036a3:	3b 8e 38 02 00 00    	cmp    0x238(%esi),%ecx
801036a9:	75 35                	jne    801036e0 <piperead+0x90>
801036ab:	8b 96 40 02 00 00    	mov    0x240(%esi),%edx
801036b1:	85 d2                	test   %edx,%edx
801036b3:	0f 84 8f 00 00 00    	je     80103748 <piperead+0xf8>
    if(myproc()->killed){
801036b9:	e8 72 02 00 00       	call   80103930 <myproc>
801036be:	8b 48 24             	mov    0x24(%eax),%ecx
801036c1:	85 c9                	test   %ecx,%ecx
801036c3:	74 cb                	je     80103690 <piperead+0x40>
      release(&p->lock);
801036c5:	83 ec 0c             	sub    $0xc,%esp
      return -1;
801036c8:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
      release(&p->lock);
801036cd:	56                   	push   %esi
801036ce:	e8 9d 0e 00 00       	call   80104570 <release>
      return -1;
801036d3:	83 c4 10             	add    $0x10,%esp
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
  release(&p->lock);
  return i;
}
801036d6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801036d9:	89 d8                	mov    %ebx,%eax
801036db:	5b                   	pop    %ebx
801036dc:	5e                   	pop    %esi
801036dd:	5f                   	pop    %edi
801036de:	5d                   	pop    %ebp
801036df:	c3                   	ret    
  for(i = 0; i < n; i++){  //DOC: piperead-copy
801036e0:	8b 45 10             	mov    0x10(%ebp),%eax
801036e3:	85 c0                	test   %eax,%eax
801036e5:	7e 61                	jle    80103748 <piperead+0xf8>
    if(p->nread == p->nwrite)
801036e7:	31 db                	xor    %ebx,%ebx
801036e9:	eb 13                	jmp    801036fe <piperead+0xae>
801036eb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801036ef:	90                   	nop
801036f0:	8b 8e 34 02 00 00    	mov    0x234(%esi),%ecx
801036f6:	3b 8e 38 02 00 00    	cmp    0x238(%esi),%ecx
801036fc:	74 1f                	je     8010371d <piperead+0xcd>
    addr[i] = p->data[p->nread++ % PIPESIZE];
801036fe:	8d 41 01             	lea    0x1(%ecx),%eax
80103701:	81 e1 ff 01 00 00    	and    $0x1ff,%ecx
80103707:	89 86 34 02 00 00    	mov    %eax,0x234(%esi)
8010370d:	0f b6 44 0e 34       	movzbl 0x34(%esi,%ecx,1),%eax
80103712:	88 04 1f             	mov    %al,(%edi,%ebx,1)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103715:	83 c3 01             	add    $0x1,%ebx
80103718:	39 5d 10             	cmp    %ebx,0x10(%ebp)
8010371b:	75 d3                	jne    801036f0 <piperead+0xa0>
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
8010371d:	83 ec 0c             	sub    $0xc,%esp
80103720:	8d 86 38 02 00 00    	lea    0x238(%esi),%eax
80103726:	50                   	push   %eax
80103727:	e8 54 09 00 00       	call   80104080 <wakeup>
  release(&p->lock);
8010372c:	89 34 24             	mov    %esi,(%esp)
8010372f:	e8 3c 0e 00 00       	call   80104570 <release>
  return i;
80103734:	83 c4 10             	add    $0x10,%esp
}
80103737:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010373a:	89 d8                	mov    %ebx,%eax
8010373c:	5b                   	pop    %ebx
8010373d:	5e                   	pop    %esi
8010373e:	5f                   	pop    %edi
8010373f:	5d                   	pop    %ebp
80103740:	c3                   	ret    
80103741:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(p->nread == p->nwrite)
80103748:	31 db                	xor    %ebx,%ebx
8010374a:	eb d1                	jmp    8010371d <piperead+0xcd>
8010374c:	66 90                	xchg   %ax,%ax
8010374e:	66 90                	xchg   %ax,%ax

80103750 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
80103750:	55                   	push   %ebp
80103751:	89 e5                	mov    %esp,%ebp
80103753:	53                   	push   %ebx
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103754:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
{
80103759:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);
8010375c:	68 20 2d 11 80       	push   $0x80112d20
80103761:	e8 4a 0d 00 00       	call   801044b0 <acquire>
80103766:	83 c4 10             	add    $0x10,%esp
80103769:	eb 10                	jmp    8010377b <allocproc+0x2b>
8010376b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010376f:	90                   	nop
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103770:	83 c3 7c             	add    $0x7c,%ebx
80103773:	81 fb 54 4c 11 80    	cmp    $0x80114c54,%ebx
80103779:	74 75                	je     801037f0 <allocproc+0xa0>
    if(p->state == UNUSED)
8010377b:	8b 43 0c             	mov    0xc(%ebx),%eax
8010377e:	85 c0                	test   %eax,%eax
80103780:	75 ee                	jne    80103770 <allocproc+0x20>
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
80103782:	a1 04 a0 10 80       	mov    0x8010a004,%eax

  release(&ptable.lock);
80103787:	83 ec 0c             	sub    $0xc,%esp
  p->state = EMBRYO;
8010378a:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
  p->pid = nextpid++;
80103791:	89 43 10             	mov    %eax,0x10(%ebx)
80103794:	8d 50 01             	lea    0x1(%eax),%edx
  release(&ptable.lock);
80103797:	68 20 2d 11 80       	push   $0x80112d20
  p->pid = nextpid++;
8010379c:	89 15 04 a0 10 80    	mov    %edx,0x8010a004
  release(&ptable.lock);
801037a2:	e8 c9 0d 00 00       	call   80104570 <release>

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
801037a7:	e8 04 ee ff ff       	call   801025b0 <kalloc>
801037ac:	83 c4 10             	add    $0x10,%esp
801037af:	89 43 08             	mov    %eax,0x8(%ebx)
801037b2:	85 c0                	test   %eax,%eax
801037b4:	74 53                	je     80103809 <allocproc+0xb9>
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
801037b6:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
801037bc:	83 ec 04             	sub    $0x4,%esp
  sp -= sizeof *p->context;
801037bf:	05 9c 0f 00 00       	add    $0xf9c,%eax
  sp -= sizeof *p->tf;
801037c4:	89 53 18             	mov    %edx,0x18(%ebx)
  *(uint*)sp = (uint)trapret;
801037c7:	c7 40 14 72 57 10 80 	movl   $0x80105772,0x14(%eax)
  p->context = (struct context*)sp;
801037ce:	89 43 1c             	mov    %eax,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
801037d1:	6a 14                	push   $0x14
801037d3:	6a 00                	push   $0x0
801037d5:	50                   	push   %eax
801037d6:	e8 e5 0d 00 00       	call   801045c0 <memset>
  p->context->eip = (uint)forkret;
801037db:	8b 43 1c             	mov    0x1c(%ebx),%eax

  return p;
801037de:	83 c4 10             	add    $0x10,%esp
  p->context->eip = (uint)forkret;
801037e1:	c7 40 10 20 38 10 80 	movl   $0x80103820,0x10(%eax)
}
801037e8:	89 d8                	mov    %ebx,%eax
801037ea:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801037ed:	c9                   	leave  
801037ee:	c3                   	ret    
801037ef:	90                   	nop
  release(&ptable.lock);
801037f0:	83 ec 0c             	sub    $0xc,%esp
  return 0;
801037f3:	31 db                	xor    %ebx,%ebx
  release(&ptable.lock);
801037f5:	68 20 2d 11 80       	push   $0x80112d20
801037fa:	e8 71 0d 00 00       	call   80104570 <release>
}
801037ff:	89 d8                	mov    %ebx,%eax
  return 0;
80103801:	83 c4 10             	add    $0x10,%esp
}
80103804:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103807:	c9                   	leave  
80103808:	c3                   	ret    
    p->state = UNUSED;
80103809:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return 0;
80103810:	31 db                	xor    %ebx,%ebx
}
80103812:	89 d8                	mov    %ebx,%eax
80103814:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103817:	c9                   	leave  
80103818:	c3                   	ret    
80103819:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103820 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
80103820:	55                   	push   %ebp
80103821:	89 e5                	mov    %esp,%ebp
80103823:	83 ec 14             	sub    $0x14,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
80103826:	68 20 2d 11 80       	push   $0x80112d20
8010382b:	e8 40 0d 00 00       	call   80104570 <release>

  if (first) {
80103830:	a1 00 a0 10 80       	mov    0x8010a000,%eax
80103835:	83 c4 10             	add    $0x10,%esp
80103838:	85 c0                	test   %eax,%eax
8010383a:	75 04                	jne    80103840 <forkret+0x20>
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}
8010383c:	c9                   	leave  
8010383d:	c3                   	ret    
8010383e:	66 90                	xchg   %ax,%ax
    first = 0;
80103840:	c7 05 00 a0 10 80 00 	movl   $0x0,0x8010a000
80103847:	00 00 00 
    iinit(ROOTDEV);
8010384a:	83 ec 0c             	sub    $0xc,%esp
8010384d:	6a 01                	push   $0x1
8010384f:	e8 cc dc ff ff       	call   80101520 <iinit>
    initlog(ROOTDEV);
80103854:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
8010385b:	e8 f0 f3 ff ff       	call   80102c50 <initlog>
80103860:	83 c4 10             	add    $0x10,%esp
}
80103863:	c9                   	leave  
80103864:	c3                   	ret    
80103865:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010386c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103870 <pinit>:
{
80103870:	55                   	push   %ebp
80103871:	89 e5                	mov    %esp,%ebp
80103873:	83 ec 10             	sub    $0x10,%esp
  initlock(&ptable.lock, "ptable");
80103876:	68 35 75 10 80       	push   $0x80107535
8010387b:	68 20 2d 11 80       	push   $0x80112d20
80103880:	e8 cb 0a 00 00       	call   80104350 <initlock>
}
80103885:	83 c4 10             	add    $0x10,%esp
80103888:	c9                   	leave  
80103889:	c3                   	ret    
8010388a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103890 <mycpu>:
{
80103890:	55                   	push   %ebp
80103891:	89 e5                	mov    %esp,%ebp
80103893:	56                   	push   %esi
80103894:	53                   	push   %ebx
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103895:	9c                   	pushf  
80103896:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103897:	f6 c4 02             	test   $0x2,%ah
8010389a:	75 5d                	jne    801038f9 <mycpu+0x69>
  apicid = lapicid();
8010389c:	e8 df ef ff ff       	call   80102880 <lapicid>
  for (i = 0; i < ncpu; ++i) {
801038a1:	8b 35 00 2d 11 80    	mov    0x80112d00,%esi
801038a7:	85 f6                	test   %esi,%esi
801038a9:	7e 41                	jle    801038ec <mycpu+0x5c>
    if (cpus[i].apicid == apicid)
801038ab:	0f b6 15 80 27 11 80 	movzbl 0x80112780,%edx
801038b2:	39 d0                	cmp    %edx,%eax
801038b4:	74 2f                	je     801038e5 <mycpu+0x55>
  for (i = 0; i < ncpu; ++i) {
801038b6:	31 d2                	xor    %edx,%edx
801038b8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801038bf:	90                   	nop
801038c0:	83 c2 01             	add    $0x1,%edx
801038c3:	39 f2                	cmp    %esi,%edx
801038c5:	74 25                	je     801038ec <mycpu+0x5c>
    if (cpus[i].apicid == apicid)
801038c7:	69 ca b0 00 00 00    	imul   $0xb0,%edx,%ecx
801038cd:	0f b6 99 80 27 11 80 	movzbl -0x7feed880(%ecx),%ebx
801038d4:	39 c3                	cmp    %eax,%ebx
801038d6:	75 e8                	jne    801038c0 <mycpu+0x30>
801038d8:	8d 81 80 27 11 80    	lea    -0x7feed880(%ecx),%eax
}
801038de:	8d 65 f8             	lea    -0x8(%ebp),%esp
801038e1:	5b                   	pop    %ebx
801038e2:	5e                   	pop    %esi
801038e3:	5d                   	pop    %ebp
801038e4:	c3                   	ret    
    if (cpus[i].apicid == apicid)
801038e5:	b8 80 27 11 80       	mov    $0x80112780,%eax
      return &cpus[i];
801038ea:	eb f2                	jmp    801038de <mycpu+0x4e>
  panic("unknown apicid\n");
801038ec:	83 ec 0c             	sub    $0xc,%esp
801038ef:	68 3c 75 10 80       	push   $0x8010753c
801038f4:	e8 97 ca ff ff       	call   80100390 <panic>
    panic("mycpu called with interrupts enabled\n");
801038f9:	83 ec 0c             	sub    $0xc,%esp
801038fc:	68 18 76 10 80       	push   $0x80107618
80103901:	e8 8a ca ff ff       	call   80100390 <panic>
80103906:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010390d:	8d 76 00             	lea    0x0(%esi),%esi

80103910 <cpuid>:
cpuid() {
80103910:	55                   	push   %ebp
80103911:	89 e5                	mov    %esp,%ebp
80103913:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
80103916:	e8 75 ff ff ff       	call   80103890 <mycpu>
}
8010391b:	c9                   	leave  
  return mycpu()-cpus;
8010391c:	2d 80 27 11 80       	sub    $0x80112780,%eax
80103921:	c1 f8 04             	sar    $0x4,%eax
80103924:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
8010392a:	c3                   	ret    
8010392b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010392f:	90                   	nop

80103930 <myproc>:
myproc(void) {
80103930:	55                   	push   %ebp
80103931:	89 e5                	mov    %esp,%ebp
80103933:	53                   	push   %ebx
80103934:	83 ec 04             	sub    $0x4,%esp
  pushcli();
80103937:	e8 84 0a 00 00       	call   801043c0 <pushcli>
  c = mycpu();
8010393c:	e8 4f ff ff ff       	call   80103890 <mycpu>
  p = c->proc;
80103941:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103947:	e8 c4 0a 00 00       	call   80104410 <popcli>
}
8010394c:	83 c4 04             	add    $0x4,%esp
8010394f:	89 d8                	mov    %ebx,%eax
80103951:	5b                   	pop    %ebx
80103952:	5d                   	pop    %ebp
80103953:	c3                   	ret    
80103954:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010395b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010395f:	90                   	nop

80103960 <userinit>:
{
80103960:	55                   	push   %ebp
80103961:	89 e5                	mov    %esp,%ebp
80103963:	53                   	push   %ebx
80103964:	83 ec 04             	sub    $0x4,%esp
  p = allocproc();
80103967:	e8 e4 fd ff ff       	call   80103750 <allocproc>
8010396c:	89 c3                	mov    %eax,%ebx
  initproc = p;
8010396e:	a3 b8 a5 10 80       	mov    %eax,0x8010a5b8
  if((p->pgdir = setupkvm()) == 0)
80103973:	e8 c8 33 00 00       	call   80106d40 <setupkvm>
80103978:	89 43 04             	mov    %eax,0x4(%ebx)
8010397b:	85 c0                	test   %eax,%eax
8010397d:	0f 84 bd 00 00 00    	je     80103a40 <userinit+0xe0>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80103983:	83 ec 04             	sub    $0x4,%esp
80103986:	68 2c 00 00 00       	push   $0x2c
8010398b:	68 60 a4 10 80       	push   $0x8010a460
80103990:	50                   	push   %eax
80103991:	e8 8a 30 00 00       	call   80106a20 <inituvm>
  memset(p->tf, 0, sizeof(*p->tf));
80103996:	83 c4 0c             	add    $0xc,%esp
  p->sz = PGSIZE;
80103999:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
8010399f:	6a 4c                	push   $0x4c
801039a1:	6a 00                	push   $0x0
801039a3:	ff 73 18             	pushl  0x18(%ebx)
801039a6:	e8 15 0c 00 00       	call   801045c0 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
801039ab:	8b 43 18             	mov    0x18(%ebx),%eax
801039ae:	ba 1b 00 00 00       	mov    $0x1b,%edx
  safestrcpy(p->name, "initcode", sizeof(p->name));
801039b3:	83 c4 0c             	add    $0xc,%esp
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
801039b6:	b9 23 00 00 00       	mov    $0x23,%ecx
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
801039bb:	66 89 50 3c          	mov    %dx,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
801039bf:	8b 43 18             	mov    0x18(%ebx),%eax
801039c2:	66 89 48 2c          	mov    %cx,0x2c(%eax)
  p->tf->es = p->tf->ds;
801039c6:	8b 43 18             	mov    0x18(%ebx),%eax
801039c9:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
801039cd:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
801039d1:	8b 43 18             	mov    0x18(%ebx),%eax
801039d4:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
801039d8:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
801039dc:	8b 43 18             	mov    0x18(%ebx),%eax
801039df:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
801039e6:	8b 43 18             	mov    0x18(%ebx),%eax
801039e9:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
801039f0:	8b 43 18             	mov    0x18(%ebx),%eax
801039f3:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
  safestrcpy(p->name, "initcode", sizeof(p->name));
801039fa:	8d 43 6c             	lea    0x6c(%ebx),%eax
801039fd:	6a 10                	push   $0x10
801039ff:	68 65 75 10 80       	push   $0x80107565
80103a04:	50                   	push   %eax
80103a05:	e8 86 0d 00 00       	call   80104790 <safestrcpy>
  p->cwd = namei("/");
80103a0a:	c7 04 24 6e 75 10 80 	movl   $0x8010756e,(%esp)
80103a11:	e8 aa e5 ff ff       	call   80101fc0 <namei>
80103a16:	89 43 68             	mov    %eax,0x68(%ebx)
  acquire(&ptable.lock);
80103a19:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103a20:	e8 8b 0a 00 00       	call   801044b0 <acquire>
  p->state = RUNNABLE;
80103a25:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  release(&ptable.lock);
80103a2c:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103a33:	e8 38 0b 00 00       	call   80104570 <release>
}
80103a38:	83 c4 10             	add    $0x10,%esp
80103a3b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103a3e:	c9                   	leave  
80103a3f:	c3                   	ret    
    panic("userinit: out of memory?");
80103a40:	83 ec 0c             	sub    $0xc,%esp
80103a43:	68 4c 75 10 80       	push   $0x8010754c
80103a48:	e8 43 c9 ff ff       	call   80100390 <panic>
80103a4d:	8d 76 00             	lea    0x0(%esi),%esi

80103a50 <growproc>:
{
80103a50:	55                   	push   %ebp
80103a51:	89 e5                	mov    %esp,%ebp
80103a53:	56                   	push   %esi
80103a54:	53                   	push   %ebx
80103a55:	8b 75 08             	mov    0x8(%ebp),%esi
  pushcli();
80103a58:	e8 63 09 00 00       	call   801043c0 <pushcli>
  c = mycpu();
80103a5d:	e8 2e fe ff ff       	call   80103890 <mycpu>
  p = c->proc;
80103a62:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103a68:	e8 a3 09 00 00       	call   80104410 <popcli>
  sz = curproc->sz;
80103a6d:	8b 03                	mov    (%ebx),%eax
  if(n > 0){
80103a6f:	85 f6                	test   %esi,%esi
80103a71:	7f 1d                	jg     80103a90 <growproc+0x40>
  } else if(n < 0){
80103a73:	75 3b                	jne    80103ab0 <growproc+0x60>
  switchuvm(curproc);
80103a75:	83 ec 0c             	sub    $0xc,%esp
  curproc->sz = sz;
80103a78:	89 03                	mov    %eax,(%ebx)
  switchuvm(curproc);
80103a7a:	53                   	push   %ebx
80103a7b:	e8 90 2e 00 00       	call   80106910 <switchuvm>
  return 0;
80103a80:	83 c4 10             	add    $0x10,%esp
80103a83:	31 c0                	xor    %eax,%eax
}
80103a85:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103a88:	5b                   	pop    %ebx
80103a89:	5e                   	pop    %esi
80103a8a:	5d                   	pop    %ebp
80103a8b:	c3                   	ret    
80103a8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103a90:	83 ec 04             	sub    $0x4,%esp
80103a93:	01 c6                	add    %eax,%esi
80103a95:	56                   	push   %esi
80103a96:	50                   	push   %eax
80103a97:	ff 73 04             	pushl  0x4(%ebx)
80103a9a:	e8 c1 30 00 00       	call   80106b60 <allocuvm>
80103a9f:	83 c4 10             	add    $0x10,%esp
80103aa2:	85 c0                	test   %eax,%eax
80103aa4:	75 cf                	jne    80103a75 <growproc+0x25>
      return -1;
80103aa6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103aab:	eb d8                	jmp    80103a85 <growproc+0x35>
80103aad:	8d 76 00             	lea    0x0(%esi),%esi
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103ab0:	83 ec 04             	sub    $0x4,%esp
80103ab3:	01 c6                	add    %eax,%esi
80103ab5:	56                   	push   %esi
80103ab6:	50                   	push   %eax
80103ab7:	ff 73 04             	pushl  0x4(%ebx)
80103aba:	e8 d1 31 00 00       	call   80106c90 <deallocuvm>
80103abf:	83 c4 10             	add    $0x10,%esp
80103ac2:	85 c0                	test   %eax,%eax
80103ac4:	75 af                	jne    80103a75 <growproc+0x25>
80103ac6:	eb de                	jmp    80103aa6 <growproc+0x56>
80103ac8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103acf:	90                   	nop

80103ad0 <fork>:
{
80103ad0:	55                   	push   %ebp
80103ad1:	89 e5                	mov    %esp,%ebp
80103ad3:	57                   	push   %edi
80103ad4:	56                   	push   %esi
80103ad5:	53                   	push   %ebx
80103ad6:	83 ec 1c             	sub    $0x1c,%esp
  pushcli();
80103ad9:	e8 e2 08 00 00       	call   801043c0 <pushcli>
  c = mycpu();
80103ade:	e8 ad fd ff ff       	call   80103890 <mycpu>
  p = c->proc;
80103ae3:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103ae9:	e8 22 09 00 00       	call   80104410 <popcli>
  if((np = allocproc()) == 0){
80103aee:	e8 5d fc ff ff       	call   80103750 <allocproc>
80103af3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103af6:	85 c0                	test   %eax,%eax
80103af8:	0f 84 b7 00 00 00    	je     80103bb5 <fork+0xe5>
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
80103afe:	83 ec 08             	sub    $0x8,%esp
80103b01:	ff 33                	pushl  (%ebx)
80103b03:	89 c7                	mov    %eax,%edi
80103b05:	ff 73 04             	pushl  0x4(%ebx)
80103b08:	e8 03 33 00 00       	call   80106e10 <copyuvm>
80103b0d:	83 c4 10             	add    $0x10,%esp
80103b10:	89 47 04             	mov    %eax,0x4(%edi)
80103b13:	85 c0                	test   %eax,%eax
80103b15:	0f 84 a1 00 00 00    	je     80103bbc <fork+0xec>
  np->sz = curproc->sz;
80103b1b:	8b 03                	mov    (%ebx),%eax
80103b1d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80103b20:	89 01                	mov    %eax,(%ecx)
  *np->tf = *curproc->tf;
80103b22:	8b 79 18             	mov    0x18(%ecx),%edi
  np->parent = curproc;
80103b25:	89 c8                	mov    %ecx,%eax
80103b27:	89 59 14             	mov    %ebx,0x14(%ecx)
  *np->tf = *curproc->tf;
80103b2a:	b9 13 00 00 00       	mov    $0x13,%ecx
80103b2f:	8b 73 18             	mov    0x18(%ebx),%esi
80103b32:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  for(i = 0; i < NOFILE; i++)
80103b34:	31 f6                	xor    %esi,%esi
  np->tf->eax = 0;
80103b36:	8b 40 18             	mov    0x18(%eax),%eax
80103b39:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
    if(curproc->ofile[i])
80103b40:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
80103b44:	85 c0                	test   %eax,%eax
80103b46:	74 13                	je     80103b5b <fork+0x8b>
      np->ofile[i] = filedup(curproc->ofile[i]);
80103b48:	83 ec 0c             	sub    $0xc,%esp
80103b4b:	50                   	push   %eax
80103b4c:	e8 1f d3 ff ff       	call   80100e70 <filedup>
80103b51:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103b54:	83 c4 10             	add    $0x10,%esp
80103b57:	89 44 b2 28          	mov    %eax,0x28(%edx,%esi,4)
  for(i = 0; i < NOFILE; i++)
80103b5b:	83 c6 01             	add    $0x1,%esi
80103b5e:	83 fe 10             	cmp    $0x10,%esi
80103b61:	75 dd                	jne    80103b40 <fork+0x70>
  np->cwd = idup(curproc->cwd);
80103b63:	83 ec 0c             	sub    $0xc,%esp
80103b66:	ff 73 68             	pushl  0x68(%ebx)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103b69:	83 c3 6c             	add    $0x6c,%ebx
  np->cwd = idup(curproc->cwd);
80103b6c:	e8 7f db ff ff       	call   801016f0 <idup>
80103b71:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103b74:	83 c4 0c             	add    $0xc,%esp
  np->cwd = idup(curproc->cwd);
80103b77:	89 47 68             	mov    %eax,0x68(%edi)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103b7a:	8d 47 6c             	lea    0x6c(%edi),%eax
80103b7d:	6a 10                	push   $0x10
80103b7f:	53                   	push   %ebx
80103b80:	50                   	push   %eax
80103b81:	e8 0a 0c 00 00       	call   80104790 <safestrcpy>
  pid = np->pid;
80103b86:	8b 5f 10             	mov    0x10(%edi),%ebx
  acquire(&ptable.lock);
80103b89:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103b90:	e8 1b 09 00 00       	call   801044b0 <acquire>
  np->state = RUNNABLE;
80103b95:	c7 47 0c 03 00 00 00 	movl   $0x3,0xc(%edi)
  release(&ptable.lock);
80103b9c:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103ba3:	e8 c8 09 00 00       	call   80104570 <release>
  return pid;
80103ba8:	83 c4 10             	add    $0x10,%esp
}
80103bab:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103bae:	89 d8                	mov    %ebx,%eax
80103bb0:	5b                   	pop    %ebx
80103bb1:	5e                   	pop    %esi
80103bb2:	5f                   	pop    %edi
80103bb3:	5d                   	pop    %ebp
80103bb4:	c3                   	ret    
    return -1;
80103bb5:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80103bba:	eb ef                	jmp    80103bab <fork+0xdb>
    kfree(np->kstack);
80103bbc:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80103bbf:	83 ec 0c             	sub    $0xc,%esp
80103bc2:	ff 73 08             	pushl  0x8(%ebx)
80103bc5:	e8 26 e8 ff ff       	call   801023f0 <kfree>
    np->kstack = 0;
80103bca:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
    return -1;
80103bd1:	83 c4 10             	add    $0x10,%esp
    np->state = UNUSED;
80103bd4:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return -1;
80103bdb:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80103be0:	eb c9                	jmp    80103bab <fork+0xdb>
80103be2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103be9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103bf0 <scheduler>:
{
80103bf0:	55                   	push   %ebp
80103bf1:	89 e5                	mov    %esp,%ebp
80103bf3:	57                   	push   %edi
80103bf4:	56                   	push   %esi
80103bf5:	53                   	push   %ebx
80103bf6:	83 ec 0c             	sub    $0xc,%esp
  struct cpu *c = mycpu();
80103bf9:	e8 92 fc ff ff       	call   80103890 <mycpu>
  c->proc = 0;
80103bfe:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80103c05:	00 00 00 
  struct cpu *c = mycpu();
80103c08:	89 c6                	mov    %eax,%esi
  c->proc = 0;
80103c0a:	8d 78 04             	lea    0x4(%eax),%edi
80103c0d:	8d 76 00             	lea    0x0(%esi),%esi
  asm volatile("sti");
80103c10:	fb                   	sti    
    acquire(&ptable.lock);
80103c11:	83 ec 0c             	sub    $0xc,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103c14:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
    acquire(&ptable.lock);
80103c19:	68 20 2d 11 80       	push   $0x80112d20
80103c1e:	e8 8d 08 00 00       	call   801044b0 <acquire>
80103c23:	83 c4 10             	add    $0x10,%esp
80103c26:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103c2d:	8d 76 00             	lea    0x0(%esi),%esi
      if(p->state != RUNNABLE)
80103c30:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
80103c34:	75 33                	jne    80103c69 <scheduler+0x79>
      switchuvm(p);
80103c36:	83 ec 0c             	sub    $0xc,%esp
      c->proc = p;
80103c39:	89 9e ac 00 00 00    	mov    %ebx,0xac(%esi)
      switchuvm(p);
80103c3f:	53                   	push   %ebx
80103c40:	e8 cb 2c 00 00       	call   80106910 <switchuvm>
      swtch(&(c->scheduler), p->context);
80103c45:	58                   	pop    %eax
80103c46:	5a                   	pop    %edx
80103c47:	ff 73 1c             	pushl  0x1c(%ebx)
80103c4a:	57                   	push   %edi
      p->state = RUNNING;
80103c4b:	c7 43 0c 04 00 00 00 	movl   $0x4,0xc(%ebx)
      swtch(&(c->scheduler), p->context);
80103c52:	e8 94 0b 00 00       	call   801047eb <swtch>
      switchkvm();
80103c57:	e8 a4 2c 00 00       	call   80106900 <switchkvm>
      c->proc = 0;
80103c5c:	83 c4 10             	add    $0x10,%esp
80103c5f:	c7 86 ac 00 00 00 00 	movl   $0x0,0xac(%esi)
80103c66:	00 00 00 
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103c69:	83 c3 7c             	add    $0x7c,%ebx
80103c6c:	81 fb 54 4c 11 80    	cmp    $0x80114c54,%ebx
80103c72:	75 bc                	jne    80103c30 <scheduler+0x40>
    release(&ptable.lock);
80103c74:	83 ec 0c             	sub    $0xc,%esp
80103c77:	68 20 2d 11 80       	push   $0x80112d20
80103c7c:	e8 ef 08 00 00       	call   80104570 <release>
    sti();
80103c81:	83 c4 10             	add    $0x10,%esp
80103c84:	eb 8a                	jmp    80103c10 <scheduler+0x20>
80103c86:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103c8d:	8d 76 00             	lea    0x0(%esi),%esi

80103c90 <sched>:
{
80103c90:	55                   	push   %ebp
80103c91:	89 e5                	mov    %esp,%ebp
80103c93:	56                   	push   %esi
80103c94:	53                   	push   %ebx
  pushcli();
80103c95:	e8 26 07 00 00       	call   801043c0 <pushcli>
  c = mycpu();
80103c9a:	e8 f1 fb ff ff       	call   80103890 <mycpu>
  p = c->proc;
80103c9f:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103ca5:	e8 66 07 00 00       	call   80104410 <popcli>
  if(!holding(&ptable.lock))
80103caa:	83 ec 0c             	sub    $0xc,%esp
80103cad:	68 20 2d 11 80       	push   $0x80112d20
80103cb2:	e8 b9 07 00 00       	call   80104470 <holding>
80103cb7:	83 c4 10             	add    $0x10,%esp
80103cba:	85 c0                	test   %eax,%eax
80103cbc:	74 4f                	je     80103d0d <sched+0x7d>
  if(mycpu()->ncli != 1)
80103cbe:	e8 cd fb ff ff       	call   80103890 <mycpu>
80103cc3:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
80103cca:	75 68                	jne    80103d34 <sched+0xa4>
  if(p->state == RUNNING)
80103ccc:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
80103cd0:	74 55                	je     80103d27 <sched+0x97>
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103cd2:	9c                   	pushf  
80103cd3:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103cd4:	f6 c4 02             	test   $0x2,%ah
80103cd7:	75 41                	jne    80103d1a <sched+0x8a>
  intena = mycpu()->intena;
80103cd9:	e8 b2 fb ff ff       	call   80103890 <mycpu>
  swtch(&p->context, mycpu()->scheduler);
80103cde:	83 c3 1c             	add    $0x1c,%ebx
  intena = mycpu()->intena;
80103ce1:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
80103ce7:	e8 a4 fb ff ff       	call   80103890 <mycpu>
80103cec:	83 ec 08             	sub    $0x8,%esp
80103cef:	ff 70 04             	pushl  0x4(%eax)
80103cf2:	53                   	push   %ebx
80103cf3:	e8 f3 0a 00 00       	call   801047eb <swtch>
  mycpu()->intena = intena;
80103cf8:	e8 93 fb ff ff       	call   80103890 <mycpu>
}
80103cfd:	83 c4 10             	add    $0x10,%esp
  mycpu()->intena = intena;
80103d00:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
80103d06:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103d09:	5b                   	pop    %ebx
80103d0a:	5e                   	pop    %esi
80103d0b:	5d                   	pop    %ebp
80103d0c:	c3                   	ret    
    panic("sched ptable.lock");
80103d0d:	83 ec 0c             	sub    $0xc,%esp
80103d10:	68 70 75 10 80       	push   $0x80107570
80103d15:	e8 76 c6 ff ff       	call   80100390 <panic>
    panic("sched interruptible");
80103d1a:	83 ec 0c             	sub    $0xc,%esp
80103d1d:	68 9c 75 10 80       	push   $0x8010759c
80103d22:	e8 69 c6 ff ff       	call   80100390 <panic>
    panic("sched running");
80103d27:	83 ec 0c             	sub    $0xc,%esp
80103d2a:	68 8e 75 10 80       	push   $0x8010758e
80103d2f:	e8 5c c6 ff ff       	call   80100390 <panic>
    panic("sched locks");
80103d34:	83 ec 0c             	sub    $0xc,%esp
80103d37:	68 82 75 10 80       	push   $0x80107582
80103d3c:	e8 4f c6 ff ff       	call   80100390 <panic>
80103d41:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103d48:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103d4f:	90                   	nop

80103d50 <exit>:
{
80103d50:	55                   	push   %ebp
80103d51:	89 e5                	mov    %esp,%ebp
80103d53:	57                   	push   %edi
80103d54:	56                   	push   %esi
80103d55:	53                   	push   %ebx
80103d56:	83 ec 0c             	sub    $0xc,%esp
  pushcli();
80103d59:	e8 62 06 00 00       	call   801043c0 <pushcli>
  c = mycpu();
80103d5e:	e8 2d fb ff ff       	call   80103890 <mycpu>
  p = c->proc;
80103d63:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80103d69:	e8 a2 06 00 00       	call   80104410 <popcli>
  if(curproc == initproc)
80103d6e:	8d 5e 28             	lea    0x28(%esi),%ebx
80103d71:	8d 7e 68             	lea    0x68(%esi),%edi
80103d74:	39 35 b8 a5 10 80    	cmp    %esi,0x8010a5b8
80103d7a:	0f 84 e7 00 00 00    	je     80103e67 <exit+0x117>
    if(curproc->ofile[fd]){
80103d80:	8b 03                	mov    (%ebx),%eax
80103d82:	85 c0                	test   %eax,%eax
80103d84:	74 12                	je     80103d98 <exit+0x48>
      fileclose(curproc->ofile[fd]);
80103d86:	83 ec 0c             	sub    $0xc,%esp
80103d89:	50                   	push   %eax
80103d8a:	e8 31 d1 ff ff       	call   80100ec0 <fileclose>
      curproc->ofile[fd] = 0;
80103d8f:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
80103d95:	83 c4 10             	add    $0x10,%esp
  for(fd = 0; fd < NOFILE; fd++){
80103d98:	83 c3 04             	add    $0x4,%ebx
80103d9b:	39 df                	cmp    %ebx,%edi
80103d9d:	75 e1                	jne    80103d80 <exit+0x30>
  begin_op();
80103d9f:	e8 4c ef ff ff       	call   80102cf0 <begin_op>
  iput(curproc->cwd);
80103da4:	83 ec 0c             	sub    $0xc,%esp
80103da7:	ff 76 68             	pushl  0x68(%esi)
80103daa:	e8 a1 da ff ff       	call   80101850 <iput>
  end_op();
80103daf:	e8 ac ef ff ff       	call   80102d60 <end_op>
  curproc->cwd = 0;
80103db4:	c7 46 68 00 00 00 00 	movl   $0x0,0x68(%esi)
  acquire(&ptable.lock);
80103dbb:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103dc2:	e8 e9 06 00 00       	call   801044b0 <acquire>
  wakeup1(curproc->parent);
80103dc7:	8b 56 14             	mov    0x14(%esi),%edx
80103dca:	83 c4 10             	add    $0x10,%esp
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103dcd:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
80103dd2:	eb 0e                	jmp    80103de2 <exit+0x92>
80103dd4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103dd8:	83 c0 7c             	add    $0x7c,%eax
80103ddb:	3d 54 4c 11 80       	cmp    $0x80114c54,%eax
80103de0:	74 1c                	je     80103dfe <exit+0xae>
    if(p->state == SLEEPING && p->chan == chan)
80103de2:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80103de6:	75 f0                	jne    80103dd8 <exit+0x88>
80103de8:	3b 50 20             	cmp    0x20(%eax),%edx
80103deb:	75 eb                	jne    80103dd8 <exit+0x88>
      p->state = RUNNABLE;
80103ded:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103df4:	83 c0 7c             	add    $0x7c,%eax
80103df7:	3d 54 4c 11 80       	cmp    $0x80114c54,%eax
80103dfc:	75 e4                	jne    80103de2 <exit+0x92>
      p->parent = initproc;
80103dfe:	8b 0d b8 a5 10 80    	mov    0x8010a5b8,%ecx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103e04:	ba 54 2d 11 80       	mov    $0x80112d54,%edx
80103e09:	eb 10                	jmp    80103e1b <exit+0xcb>
80103e0b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103e0f:	90                   	nop
80103e10:	83 c2 7c             	add    $0x7c,%edx
80103e13:	81 fa 54 4c 11 80    	cmp    $0x80114c54,%edx
80103e19:	74 33                	je     80103e4e <exit+0xfe>
    if(p->parent == curproc){
80103e1b:	39 72 14             	cmp    %esi,0x14(%edx)
80103e1e:	75 f0                	jne    80103e10 <exit+0xc0>
      if(p->state == ZOMBIE)
80103e20:	83 7a 0c 05          	cmpl   $0x5,0xc(%edx)
      p->parent = initproc;
80103e24:	89 4a 14             	mov    %ecx,0x14(%edx)
      if(p->state == ZOMBIE)
80103e27:	75 e7                	jne    80103e10 <exit+0xc0>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103e29:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
80103e2e:	eb 0a                	jmp    80103e3a <exit+0xea>
80103e30:	83 c0 7c             	add    $0x7c,%eax
80103e33:	3d 54 4c 11 80       	cmp    $0x80114c54,%eax
80103e38:	74 d6                	je     80103e10 <exit+0xc0>
    if(p->state == SLEEPING && p->chan == chan)
80103e3a:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80103e3e:	75 f0                	jne    80103e30 <exit+0xe0>
80103e40:	3b 48 20             	cmp    0x20(%eax),%ecx
80103e43:	75 eb                	jne    80103e30 <exit+0xe0>
      p->state = RUNNABLE;
80103e45:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
80103e4c:	eb e2                	jmp    80103e30 <exit+0xe0>
  curproc->state = ZOMBIE;
80103e4e:	c7 46 0c 05 00 00 00 	movl   $0x5,0xc(%esi)
  sched();
80103e55:	e8 36 fe ff ff       	call   80103c90 <sched>
  panic("zombie exit");
80103e5a:	83 ec 0c             	sub    $0xc,%esp
80103e5d:	68 bd 75 10 80       	push   $0x801075bd
80103e62:	e8 29 c5 ff ff       	call   80100390 <panic>
    panic("init exiting");
80103e67:	83 ec 0c             	sub    $0xc,%esp
80103e6a:	68 b0 75 10 80       	push   $0x801075b0
80103e6f:	e8 1c c5 ff ff       	call   80100390 <panic>
80103e74:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103e7b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103e7f:	90                   	nop

80103e80 <yield>:
{
80103e80:	55                   	push   %ebp
80103e81:	89 e5                	mov    %esp,%ebp
80103e83:	53                   	push   %ebx
80103e84:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
80103e87:	68 20 2d 11 80       	push   $0x80112d20
80103e8c:	e8 1f 06 00 00       	call   801044b0 <acquire>
  pushcli();
80103e91:	e8 2a 05 00 00       	call   801043c0 <pushcli>
  c = mycpu();
80103e96:	e8 f5 f9 ff ff       	call   80103890 <mycpu>
  p = c->proc;
80103e9b:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103ea1:	e8 6a 05 00 00       	call   80104410 <popcli>
  myproc()->state = RUNNABLE;
80103ea6:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  sched();
80103ead:	e8 de fd ff ff       	call   80103c90 <sched>
  release(&ptable.lock);
80103eb2:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103eb9:	e8 b2 06 00 00       	call   80104570 <release>
}
80103ebe:	83 c4 10             	add    $0x10,%esp
80103ec1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103ec4:	c9                   	leave  
80103ec5:	c3                   	ret    
80103ec6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103ecd:	8d 76 00             	lea    0x0(%esi),%esi

80103ed0 <sleep>:
{
80103ed0:	55                   	push   %ebp
80103ed1:	89 e5                	mov    %esp,%ebp
80103ed3:	57                   	push   %edi
80103ed4:	56                   	push   %esi
80103ed5:	53                   	push   %ebx
80103ed6:	83 ec 0c             	sub    $0xc,%esp
80103ed9:	8b 7d 08             	mov    0x8(%ebp),%edi
80103edc:	8b 75 0c             	mov    0xc(%ebp),%esi
  pushcli();
80103edf:	e8 dc 04 00 00       	call   801043c0 <pushcli>
  c = mycpu();
80103ee4:	e8 a7 f9 ff ff       	call   80103890 <mycpu>
  p = c->proc;
80103ee9:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103eef:	e8 1c 05 00 00       	call   80104410 <popcli>
  if(p == 0)
80103ef4:	85 db                	test   %ebx,%ebx
80103ef6:	0f 84 87 00 00 00    	je     80103f83 <sleep+0xb3>
  if(lk == 0)
80103efc:	85 f6                	test   %esi,%esi
80103efe:	74 76                	je     80103f76 <sleep+0xa6>
  if(lk != &ptable.lock){  //DOC: sleeplock0
80103f00:	81 fe 20 2d 11 80    	cmp    $0x80112d20,%esi
80103f06:	74 50                	je     80103f58 <sleep+0x88>
    acquire(&ptable.lock);  //DOC: sleeplock1
80103f08:	83 ec 0c             	sub    $0xc,%esp
80103f0b:	68 20 2d 11 80       	push   $0x80112d20
80103f10:	e8 9b 05 00 00       	call   801044b0 <acquire>
    release(lk);
80103f15:	89 34 24             	mov    %esi,(%esp)
80103f18:	e8 53 06 00 00       	call   80104570 <release>
  p->chan = chan;
80103f1d:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
80103f20:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80103f27:	e8 64 fd ff ff       	call   80103c90 <sched>
  p->chan = 0;
80103f2c:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
    release(&ptable.lock);
80103f33:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103f3a:	e8 31 06 00 00       	call   80104570 <release>
    acquire(lk);
80103f3f:	89 75 08             	mov    %esi,0x8(%ebp)
80103f42:	83 c4 10             	add    $0x10,%esp
}
80103f45:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103f48:	5b                   	pop    %ebx
80103f49:	5e                   	pop    %esi
80103f4a:	5f                   	pop    %edi
80103f4b:	5d                   	pop    %ebp
    acquire(lk);
80103f4c:	e9 5f 05 00 00       	jmp    801044b0 <acquire>
80103f51:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  p->chan = chan;
80103f58:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
80103f5b:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80103f62:	e8 29 fd ff ff       	call   80103c90 <sched>
  p->chan = 0;
80103f67:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
80103f6e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103f71:	5b                   	pop    %ebx
80103f72:	5e                   	pop    %esi
80103f73:	5f                   	pop    %edi
80103f74:	5d                   	pop    %ebp
80103f75:	c3                   	ret    
    panic("sleep without lk");
80103f76:	83 ec 0c             	sub    $0xc,%esp
80103f79:	68 cf 75 10 80       	push   $0x801075cf
80103f7e:	e8 0d c4 ff ff       	call   80100390 <panic>
    panic("sleep");
80103f83:	83 ec 0c             	sub    $0xc,%esp
80103f86:	68 c9 75 10 80       	push   $0x801075c9
80103f8b:	e8 00 c4 ff ff       	call   80100390 <panic>

80103f90 <wait>:
{
80103f90:	55                   	push   %ebp
80103f91:	89 e5                	mov    %esp,%ebp
80103f93:	56                   	push   %esi
80103f94:	53                   	push   %ebx
  pushcli();
80103f95:	e8 26 04 00 00       	call   801043c0 <pushcli>
  c = mycpu();
80103f9a:	e8 f1 f8 ff ff       	call   80103890 <mycpu>
  p = c->proc;
80103f9f:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80103fa5:	e8 66 04 00 00       	call   80104410 <popcli>
  acquire(&ptable.lock);
80103faa:	83 ec 0c             	sub    $0xc,%esp
80103fad:	68 20 2d 11 80       	push   $0x80112d20
80103fb2:	e8 f9 04 00 00       	call   801044b0 <acquire>
80103fb7:	83 c4 10             	add    $0x10,%esp
    havekids = 0;
80103fba:	31 c0                	xor    %eax,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103fbc:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
80103fc1:	eb 10                	jmp    80103fd3 <wait+0x43>
80103fc3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103fc7:	90                   	nop
80103fc8:	83 c3 7c             	add    $0x7c,%ebx
80103fcb:	81 fb 54 4c 11 80    	cmp    $0x80114c54,%ebx
80103fd1:	74 1b                	je     80103fee <wait+0x5e>
      if(p->parent != curproc)
80103fd3:	39 73 14             	cmp    %esi,0x14(%ebx)
80103fd6:	75 f0                	jne    80103fc8 <wait+0x38>
      if(p->state == ZOMBIE){
80103fd8:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
80103fdc:	74 32                	je     80104010 <wait+0x80>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103fde:	83 c3 7c             	add    $0x7c,%ebx
      havekids = 1;
80103fe1:	b8 01 00 00 00       	mov    $0x1,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103fe6:	81 fb 54 4c 11 80    	cmp    $0x80114c54,%ebx
80103fec:	75 e5                	jne    80103fd3 <wait+0x43>
    if(!havekids || curproc->killed){
80103fee:	85 c0                	test   %eax,%eax
80103ff0:	74 74                	je     80104066 <wait+0xd6>
80103ff2:	8b 46 24             	mov    0x24(%esi),%eax
80103ff5:	85 c0                	test   %eax,%eax
80103ff7:	75 6d                	jne    80104066 <wait+0xd6>
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
80103ff9:	83 ec 08             	sub    $0x8,%esp
80103ffc:	68 20 2d 11 80       	push   $0x80112d20
80104001:	56                   	push   %esi
80104002:	e8 c9 fe ff ff       	call   80103ed0 <sleep>
    havekids = 0;
80104007:	83 c4 10             	add    $0x10,%esp
8010400a:	eb ae                	jmp    80103fba <wait+0x2a>
8010400c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        kfree(p->kstack);
80104010:	83 ec 0c             	sub    $0xc,%esp
80104013:	ff 73 08             	pushl  0x8(%ebx)
        pid = p->pid;
80104016:	8b 73 10             	mov    0x10(%ebx),%esi
        kfree(p->kstack);
80104019:	e8 d2 e3 ff ff       	call   801023f0 <kfree>
        freevm(p->pgdir);
8010401e:	5a                   	pop    %edx
8010401f:	ff 73 04             	pushl  0x4(%ebx)
        p->kstack = 0;
80104022:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir);
80104029:	e8 92 2c 00 00       	call   80106cc0 <freevm>
        release(&ptable.lock);
8010402e:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
        p->pid = 0;
80104035:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->parent = 0;
8010403c:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
80104043:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->killed = 0;
80104047:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        p->state = UNUSED;
8010404e:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        release(&ptable.lock);
80104055:	e8 16 05 00 00       	call   80104570 <release>
        return pid;
8010405a:	83 c4 10             	add    $0x10,%esp
}
8010405d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104060:	89 f0                	mov    %esi,%eax
80104062:	5b                   	pop    %ebx
80104063:	5e                   	pop    %esi
80104064:	5d                   	pop    %ebp
80104065:	c3                   	ret    
      release(&ptable.lock);
80104066:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80104069:	be ff ff ff ff       	mov    $0xffffffff,%esi
      release(&ptable.lock);
8010406e:	68 20 2d 11 80       	push   $0x80112d20
80104073:	e8 f8 04 00 00       	call   80104570 <release>
      return -1;
80104078:	83 c4 10             	add    $0x10,%esp
8010407b:	eb e0                	jmp    8010405d <wait+0xcd>
8010407d:	8d 76 00             	lea    0x0(%esi),%esi

80104080 <wakeup>:
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
80104080:	55                   	push   %ebp
80104081:	89 e5                	mov    %esp,%ebp
80104083:	53                   	push   %ebx
80104084:	83 ec 10             	sub    $0x10,%esp
80104087:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
8010408a:	68 20 2d 11 80       	push   $0x80112d20
8010408f:	e8 1c 04 00 00       	call   801044b0 <acquire>
80104094:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104097:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
8010409c:	eb 0c                	jmp    801040aa <wakeup+0x2a>
8010409e:	66 90                	xchg   %ax,%ax
801040a0:	83 c0 7c             	add    $0x7c,%eax
801040a3:	3d 54 4c 11 80       	cmp    $0x80114c54,%eax
801040a8:	74 1c                	je     801040c6 <wakeup+0x46>
    if(p->state == SLEEPING && p->chan == chan)
801040aa:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
801040ae:	75 f0                	jne    801040a0 <wakeup+0x20>
801040b0:	3b 58 20             	cmp    0x20(%eax),%ebx
801040b3:	75 eb                	jne    801040a0 <wakeup+0x20>
      p->state = RUNNABLE;
801040b5:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801040bc:	83 c0 7c             	add    $0x7c,%eax
801040bf:	3d 54 4c 11 80       	cmp    $0x80114c54,%eax
801040c4:	75 e4                	jne    801040aa <wakeup+0x2a>
  wakeup1(chan);
  release(&ptable.lock);
801040c6:	c7 45 08 20 2d 11 80 	movl   $0x80112d20,0x8(%ebp)
}
801040cd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801040d0:	c9                   	leave  
  release(&ptable.lock);
801040d1:	e9 9a 04 00 00       	jmp    80104570 <release>
801040d6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801040dd:	8d 76 00             	lea    0x0(%esi),%esi

801040e0 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
801040e0:	55                   	push   %ebp
801040e1:	89 e5                	mov    %esp,%ebp
801040e3:	53                   	push   %ebx
801040e4:	83 ec 10             	sub    $0x10,%esp
801040e7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
801040ea:	68 20 2d 11 80       	push   $0x80112d20
801040ef:	e8 bc 03 00 00       	call   801044b0 <acquire>
801040f4:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801040f7:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
801040fc:	eb 0c                	jmp    8010410a <kill+0x2a>
801040fe:	66 90                	xchg   %ax,%ax
80104100:	83 c0 7c             	add    $0x7c,%eax
80104103:	3d 54 4c 11 80       	cmp    $0x80114c54,%eax
80104108:	74 36                	je     80104140 <kill+0x60>
    if(p->pid == pid){
8010410a:	39 58 10             	cmp    %ebx,0x10(%eax)
8010410d:	75 f1                	jne    80104100 <kill+0x20>
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
8010410f:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
      p->killed = 1;
80104113:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      if(p->state == SLEEPING)
8010411a:	75 07                	jne    80104123 <kill+0x43>
        p->state = RUNNABLE;
8010411c:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
      release(&ptable.lock);
80104123:	83 ec 0c             	sub    $0xc,%esp
80104126:	68 20 2d 11 80       	push   $0x80112d20
8010412b:	e8 40 04 00 00       	call   80104570 <release>
      return 0;
80104130:	83 c4 10             	add    $0x10,%esp
80104133:	31 c0                	xor    %eax,%eax
    }
  }
  release(&ptable.lock);
  return -1;
}
80104135:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104138:	c9                   	leave  
80104139:	c3                   	ret    
8010413a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  release(&ptable.lock);
80104140:	83 ec 0c             	sub    $0xc,%esp
80104143:	68 20 2d 11 80       	push   $0x80112d20
80104148:	e8 23 04 00 00       	call   80104570 <release>
  return -1;
8010414d:	83 c4 10             	add    $0x10,%esp
80104150:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104155:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104158:	c9                   	leave  
80104159:	c3                   	ret    
8010415a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104160 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
80104160:	55                   	push   %ebp
80104161:	89 e5                	mov    %esp,%ebp
80104163:	57                   	push   %edi
80104164:	56                   	push   %esi
80104165:	8d 75 e8             	lea    -0x18(%ebp),%esi
80104168:	53                   	push   %ebx
80104169:	bb c0 2d 11 80       	mov    $0x80112dc0,%ebx
8010416e:	83 ec 3c             	sub    $0x3c,%esp
80104171:	eb 24                	jmp    80104197 <procdump+0x37>
80104173:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104177:	90                   	nop
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
80104178:	83 ec 0c             	sub    $0xc,%esp
8010417b:	68 5b 79 10 80       	push   $0x8010795b
80104180:	e8 2b c5 ff ff       	call   801006b0 <cprintf>
80104185:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104188:	83 c3 7c             	add    $0x7c,%ebx
8010418b:	81 fb c0 4c 11 80    	cmp    $0x80114cc0,%ebx
80104191:	0f 84 81 00 00 00    	je     80104218 <procdump+0xb8>
    if(p->state == UNUSED)
80104197:	8b 43 a0             	mov    -0x60(%ebx),%eax
8010419a:	85 c0                	test   %eax,%eax
8010419c:	74 ea                	je     80104188 <procdump+0x28>
      state = "???";
8010419e:	ba e0 75 10 80       	mov    $0x801075e0,%edx
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
801041a3:	83 f8 05             	cmp    $0x5,%eax
801041a6:	77 11                	ja     801041b9 <procdump+0x59>
801041a8:	8b 14 85 40 76 10 80 	mov    -0x7fef89c0(,%eax,4),%edx
      state = "???";
801041af:	b8 e0 75 10 80       	mov    $0x801075e0,%eax
801041b4:	85 d2                	test   %edx,%edx
801041b6:	0f 44 d0             	cmove  %eax,%edx
    cprintf("%d %s %s", p->pid, state, p->name);
801041b9:	53                   	push   %ebx
801041ba:	52                   	push   %edx
801041bb:	ff 73 a4             	pushl  -0x5c(%ebx)
801041be:	68 e4 75 10 80       	push   $0x801075e4
801041c3:	e8 e8 c4 ff ff       	call   801006b0 <cprintf>
    if(p->state == SLEEPING){
801041c8:	83 c4 10             	add    $0x10,%esp
801041cb:	83 7b a0 02          	cmpl   $0x2,-0x60(%ebx)
801041cf:	75 a7                	jne    80104178 <procdump+0x18>
      getcallerpcs((uint*)p->context->ebp+2, pc);
801041d1:	83 ec 08             	sub    $0x8,%esp
801041d4:	8d 45 c0             	lea    -0x40(%ebp),%eax
801041d7:	8d 7d c0             	lea    -0x40(%ebp),%edi
801041da:	50                   	push   %eax
801041db:	8b 43 b0             	mov    -0x50(%ebx),%eax
801041de:	8b 40 0c             	mov    0xc(%eax),%eax
801041e1:	83 c0 08             	add    $0x8,%eax
801041e4:	50                   	push   %eax
801041e5:	e8 86 01 00 00       	call   80104370 <getcallerpcs>
      for(i=0; i<10 && pc[i] != 0; i++)
801041ea:	83 c4 10             	add    $0x10,%esp
801041ed:	8d 76 00             	lea    0x0(%esi),%esi
801041f0:	8b 17                	mov    (%edi),%edx
801041f2:	85 d2                	test   %edx,%edx
801041f4:	74 82                	je     80104178 <procdump+0x18>
        cprintf(" %p", pc[i]);
801041f6:	83 ec 08             	sub    $0x8,%esp
801041f9:	83 c7 04             	add    $0x4,%edi
801041fc:	52                   	push   %edx
801041fd:	68 21 70 10 80       	push   $0x80107021
80104202:	e8 a9 c4 ff ff       	call   801006b0 <cprintf>
      for(i=0; i<10 && pc[i] != 0; i++)
80104207:	83 c4 10             	add    $0x10,%esp
8010420a:	39 fe                	cmp    %edi,%esi
8010420c:	75 e2                	jne    801041f0 <procdump+0x90>
8010420e:	e9 65 ff ff ff       	jmp    80104178 <procdump+0x18>
80104213:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104217:	90                   	nop
  }
}
80104218:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010421b:	5b                   	pop    %ebx
8010421c:	5e                   	pop    %esi
8010421d:	5f                   	pop    %edi
8010421e:	5d                   	pop    %ebp
8010421f:	c3                   	ret    

80104220 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
80104220:	55                   	push   %ebp
80104221:	89 e5                	mov    %esp,%ebp
80104223:	53                   	push   %ebx
80104224:	83 ec 0c             	sub    $0xc,%esp
80104227:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
8010422a:	68 58 76 10 80       	push   $0x80107658
8010422f:	8d 43 04             	lea    0x4(%ebx),%eax
80104232:	50                   	push   %eax
80104233:	e8 18 01 00 00       	call   80104350 <initlock>
  lk->name = name;
80104238:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
8010423b:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
}
80104241:	83 c4 10             	add    $0x10,%esp
  lk->pid = 0;
80104244:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  lk->name = name;
8010424b:	89 43 38             	mov    %eax,0x38(%ebx)
}
8010424e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104251:	c9                   	leave  
80104252:	c3                   	ret    
80104253:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010425a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104260 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
80104260:	55                   	push   %ebp
80104261:	89 e5                	mov    %esp,%ebp
80104263:	56                   	push   %esi
80104264:	53                   	push   %ebx
80104265:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104268:	8d 73 04             	lea    0x4(%ebx),%esi
8010426b:	83 ec 0c             	sub    $0xc,%esp
8010426e:	56                   	push   %esi
8010426f:	e8 3c 02 00 00       	call   801044b0 <acquire>
  while (lk->locked) {
80104274:	8b 13                	mov    (%ebx),%edx
80104276:	83 c4 10             	add    $0x10,%esp
80104279:	85 d2                	test   %edx,%edx
8010427b:	74 16                	je     80104293 <acquiresleep+0x33>
8010427d:	8d 76 00             	lea    0x0(%esi),%esi
    sleep(lk, &lk->lk);
80104280:	83 ec 08             	sub    $0x8,%esp
80104283:	56                   	push   %esi
80104284:	53                   	push   %ebx
80104285:	e8 46 fc ff ff       	call   80103ed0 <sleep>
  while (lk->locked) {
8010428a:	8b 03                	mov    (%ebx),%eax
8010428c:	83 c4 10             	add    $0x10,%esp
8010428f:	85 c0                	test   %eax,%eax
80104291:	75 ed                	jne    80104280 <acquiresleep+0x20>
  }
  lk->locked = 1;
80104293:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
80104299:	e8 92 f6 ff ff       	call   80103930 <myproc>
8010429e:	8b 40 10             	mov    0x10(%eax),%eax
801042a1:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
801042a4:	89 75 08             	mov    %esi,0x8(%ebp)
}
801042a7:	8d 65 f8             	lea    -0x8(%ebp),%esp
801042aa:	5b                   	pop    %ebx
801042ab:	5e                   	pop    %esi
801042ac:	5d                   	pop    %ebp
  release(&lk->lk);
801042ad:	e9 be 02 00 00       	jmp    80104570 <release>
801042b2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801042b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801042c0 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
801042c0:	55                   	push   %ebp
801042c1:	89 e5                	mov    %esp,%ebp
801042c3:	56                   	push   %esi
801042c4:	53                   	push   %ebx
801042c5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
801042c8:	8d 73 04             	lea    0x4(%ebx),%esi
801042cb:	83 ec 0c             	sub    $0xc,%esp
801042ce:	56                   	push   %esi
801042cf:	e8 dc 01 00 00       	call   801044b0 <acquire>
  lk->locked = 0;
801042d4:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
801042da:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
801042e1:	89 1c 24             	mov    %ebx,(%esp)
801042e4:	e8 97 fd ff ff       	call   80104080 <wakeup>
  release(&lk->lk);
801042e9:	89 75 08             	mov    %esi,0x8(%ebp)
801042ec:	83 c4 10             	add    $0x10,%esp
}
801042ef:	8d 65 f8             	lea    -0x8(%ebp),%esp
801042f2:	5b                   	pop    %ebx
801042f3:	5e                   	pop    %esi
801042f4:	5d                   	pop    %ebp
  release(&lk->lk);
801042f5:	e9 76 02 00 00       	jmp    80104570 <release>
801042fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104300 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
80104300:	55                   	push   %ebp
80104301:	89 e5                	mov    %esp,%ebp
80104303:	57                   	push   %edi
80104304:	31 ff                	xor    %edi,%edi
80104306:	56                   	push   %esi
80104307:	53                   	push   %ebx
80104308:	83 ec 18             	sub    $0x18,%esp
8010430b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;
  
  acquire(&lk->lk);
8010430e:	8d 73 04             	lea    0x4(%ebx),%esi
80104311:	56                   	push   %esi
80104312:	e8 99 01 00 00       	call   801044b0 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
80104317:	8b 03                	mov    (%ebx),%eax
80104319:	83 c4 10             	add    $0x10,%esp
8010431c:	85 c0                	test   %eax,%eax
8010431e:	75 18                	jne    80104338 <holdingsleep+0x38>
  release(&lk->lk);
80104320:	83 ec 0c             	sub    $0xc,%esp
80104323:	56                   	push   %esi
80104324:	e8 47 02 00 00       	call   80104570 <release>
  return r;
}
80104329:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010432c:	89 f8                	mov    %edi,%eax
8010432e:	5b                   	pop    %ebx
8010432f:	5e                   	pop    %esi
80104330:	5f                   	pop    %edi
80104331:	5d                   	pop    %ebp
80104332:	c3                   	ret    
80104333:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104337:	90                   	nop
  r = lk->locked && (lk->pid == myproc()->pid);
80104338:	8b 5b 3c             	mov    0x3c(%ebx),%ebx
8010433b:	e8 f0 f5 ff ff       	call   80103930 <myproc>
80104340:	39 58 10             	cmp    %ebx,0x10(%eax)
80104343:	0f 94 c0             	sete   %al
80104346:	0f b6 c0             	movzbl %al,%eax
80104349:	89 c7                	mov    %eax,%edi
8010434b:	eb d3                	jmp    80104320 <holdingsleep+0x20>
8010434d:	66 90                	xchg   %ax,%ax
8010434f:	90                   	nop

80104350 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80104350:	55                   	push   %ebp
80104351:	89 e5                	mov    %esp,%ebp
80104353:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
80104356:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
80104359:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->name = name;
8010435f:	89 50 04             	mov    %edx,0x4(%eax)
  lk->cpu = 0;
80104362:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80104369:	5d                   	pop    %ebp
8010436a:	c3                   	ret    
8010436b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010436f:	90                   	nop

80104370 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80104370:	55                   	push   %ebp
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80104371:	31 d2                	xor    %edx,%edx
{
80104373:	89 e5                	mov    %esp,%ebp
80104375:	53                   	push   %ebx
  ebp = (uint*)v - 2;
80104376:	8b 45 08             	mov    0x8(%ebp),%eax
{
80104379:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  ebp = (uint*)v - 2;
8010437c:	83 e8 08             	sub    $0x8,%eax
  for(i = 0; i < 10; i++){
8010437f:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104380:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
80104386:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
8010438c:	77 1a                	ja     801043a8 <getcallerpcs+0x38>
      break;
    pcs[i] = ebp[1];     // saved %eip
8010438e:	8b 58 04             	mov    0x4(%eax),%ebx
80104391:	89 1c 91             	mov    %ebx,(%ecx,%edx,4)
  for(i = 0; i < 10; i++){
80104394:	83 c2 01             	add    $0x1,%edx
    ebp = (uint*)ebp[0]; // saved %ebp
80104397:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80104399:	83 fa 0a             	cmp    $0xa,%edx
8010439c:	75 e2                	jne    80104380 <getcallerpcs+0x10>
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
8010439e:	5b                   	pop    %ebx
8010439f:	5d                   	pop    %ebp
801043a0:	c3                   	ret    
801043a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(; i < 10; i++)
801043a8:	8d 04 91             	lea    (%ecx,%edx,4),%eax
801043ab:	8d 51 28             	lea    0x28(%ecx),%edx
801043ae:	66 90                	xchg   %ax,%ax
    pcs[i] = 0;
801043b0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
801043b6:	83 c0 04             	add    $0x4,%eax
801043b9:	39 d0                	cmp    %edx,%eax
801043bb:	75 f3                	jne    801043b0 <getcallerpcs+0x40>
}
801043bd:	5b                   	pop    %ebx
801043be:	5d                   	pop    %ebp
801043bf:	c3                   	ret    

801043c0 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
801043c0:	55                   	push   %ebp
801043c1:	89 e5                	mov    %esp,%ebp
801043c3:	53                   	push   %ebx
801043c4:	83 ec 04             	sub    $0x4,%esp
801043c7:	9c                   	pushf  
801043c8:	5b                   	pop    %ebx
  asm volatile("cli");
801043c9:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
801043ca:	e8 c1 f4 ff ff       	call   80103890 <mycpu>
801043cf:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
801043d5:	85 c0                	test   %eax,%eax
801043d7:	74 17                	je     801043f0 <pushcli+0x30>
    mycpu()->intena = eflags & FL_IF;
  mycpu()->ncli += 1;
801043d9:	e8 b2 f4 ff ff       	call   80103890 <mycpu>
801043de:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
801043e5:	83 c4 04             	add    $0x4,%esp
801043e8:	5b                   	pop    %ebx
801043e9:	5d                   	pop    %ebp
801043ea:	c3                   	ret    
801043eb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801043ef:	90                   	nop
    mycpu()->intena = eflags & FL_IF;
801043f0:	e8 9b f4 ff ff       	call   80103890 <mycpu>
801043f5:	81 e3 00 02 00 00    	and    $0x200,%ebx
801043fb:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
80104401:	eb d6                	jmp    801043d9 <pushcli+0x19>
80104403:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010440a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104410 <popcli>:

void
popcli(void)
{
80104410:	55                   	push   %ebp
80104411:	89 e5                	mov    %esp,%ebp
80104413:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104416:	9c                   	pushf  
80104417:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80104418:	f6 c4 02             	test   $0x2,%ah
8010441b:	75 35                	jne    80104452 <popcli+0x42>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
8010441d:	e8 6e f4 ff ff       	call   80103890 <mycpu>
80104422:	83 a8 a4 00 00 00 01 	subl   $0x1,0xa4(%eax)
80104429:	78 34                	js     8010445f <popcli+0x4f>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
8010442b:	e8 60 f4 ff ff       	call   80103890 <mycpu>
80104430:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
80104436:	85 d2                	test   %edx,%edx
80104438:	74 06                	je     80104440 <popcli+0x30>
    sti();
}
8010443a:	c9                   	leave  
8010443b:	c3                   	ret    
8010443c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104440:	e8 4b f4 ff ff       	call   80103890 <mycpu>
80104445:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
8010444b:	85 c0                	test   %eax,%eax
8010444d:	74 eb                	je     8010443a <popcli+0x2a>
  asm volatile("sti");
8010444f:	fb                   	sti    
}
80104450:	c9                   	leave  
80104451:	c3                   	ret    
    panic("popcli - interruptible");
80104452:	83 ec 0c             	sub    $0xc,%esp
80104455:	68 63 76 10 80       	push   $0x80107663
8010445a:	e8 31 bf ff ff       	call   80100390 <panic>
    panic("popcli");
8010445f:	83 ec 0c             	sub    $0xc,%esp
80104462:	68 7a 76 10 80       	push   $0x8010767a
80104467:	e8 24 bf ff ff       	call   80100390 <panic>
8010446c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104470 <holding>:
{
80104470:	55                   	push   %ebp
80104471:	89 e5                	mov    %esp,%ebp
80104473:	56                   	push   %esi
80104474:	53                   	push   %ebx
80104475:	8b 75 08             	mov    0x8(%ebp),%esi
80104478:	31 db                	xor    %ebx,%ebx
  pushcli();
8010447a:	e8 41 ff ff ff       	call   801043c0 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
8010447f:	8b 06                	mov    (%esi),%eax
80104481:	85 c0                	test   %eax,%eax
80104483:	75 0b                	jne    80104490 <holding+0x20>
  popcli();
80104485:	e8 86 ff ff ff       	call   80104410 <popcli>
}
8010448a:	89 d8                	mov    %ebx,%eax
8010448c:	5b                   	pop    %ebx
8010448d:	5e                   	pop    %esi
8010448e:	5d                   	pop    %ebp
8010448f:	c3                   	ret    
  r = lock->locked && lock->cpu == mycpu();
80104490:	8b 5e 08             	mov    0x8(%esi),%ebx
80104493:	e8 f8 f3 ff ff       	call   80103890 <mycpu>
80104498:	39 c3                	cmp    %eax,%ebx
8010449a:	0f 94 c3             	sete   %bl
  popcli();
8010449d:	e8 6e ff ff ff       	call   80104410 <popcli>
  r = lock->locked && lock->cpu == mycpu();
801044a2:	0f b6 db             	movzbl %bl,%ebx
}
801044a5:	89 d8                	mov    %ebx,%eax
801044a7:	5b                   	pop    %ebx
801044a8:	5e                   	pop    %esi
801044a9:	5d                   	pop    %ebp
801044aa:	c3                   	ret    
801044ab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801044af:	90                   	nop

801044b0 <acquire>:
{
801044b0:	55                   	push   %ebp
801044b1:	89 e5                	mov    %esp,%ebp
801044b3:	56                   	push   %esi
801044b4:	53                   	push   %ebx
  pushcli(); // disable interrupts to avoid deadlock.
801044b5:	e8 06 ff ff ff       	call   801043c0 <pushcli>
  if(holding(lk))
801044ba:	8b 5d 08             	mov    0x8(%ebp),%ebx
801044bd:	83 ec 0c             	sub    $0xc,%esp
801044c0:	53                   	push   %ebx
801044c1:	e8 aa ff ff ff       	call   80104470 <holding>
801044c6:	83 c4 10             	add    $0x10,%esp
801044c9:	85 c0                	test   %eax,%eax
801044cb:	0f 85 83 00 00 00    	jne    80104554 <acquire+0xa4>
801044d1:	89 c6                	mov    %eax,%esi
  asm volatile("lock; xchgl %0, %1" :
801044d3:	ba 01 00 00 00       	mov    $0x1,%edx
801044d8:	eb 09                	jmp    801044e3 <acquire+0x33>
801044da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801044e0:	8b 5d 08             	mov    0x8(%ebp),%ebx
801044e3:	89 d0                	mov    %edx,%eax
801044e5:	f0 87 03             	lock xchg %eax,(%ebx)
  while(xchg(&lk->locked, 1) != 0)
801044e8:	85 c0                	test   %eax,%eax
801044ea:	75 f4                	jne    801044e0 <acquire+0x30>
  __sync_synchronize();
801044ec:	0f ae f0             	mfence 
  lk->cpu = mycpu();
801044ef:	8b 5d 08             	mov    0x8(%ebp),%ebx
801044f2:	e8 99 f3 ff ff       	call   80103890 <mycpu>
801044f7:	89 43 08             	mov    %eax,0x8(%ebx)
  ebp = (uint*)v - 2;
801044fa:	89 e8                	mov    %ebp,%eax
801044fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104500:	8d 90 00 00 00 80    	lea    -0x80000000(%eax),%edx
80104506:	81 fa fe ff ff 7f    	cmp    $0x7ffffffe,%edx
8010450c:	77 22                	ja     80104530 <acquire+0x80>
    pcs[i] = ebp[1];     // saved %eip
8010450e:	8b 50 04             	mov    0x4(%eax),%edx
80104511:	89 54 b3 0c          	mov    %edx,0xc(%ebx,%esi,4)
  for(i = 0; i < 10; i++){
80104515:	83 c6 01             	add    $0x1,%esi
    ebp = (uint*)ebp[0]; // saved %ebp
80104518:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
8010451a:	83 fe 0a             	cmp    $0xa,%esi
8010451d:	75 e1                	jne    80104500 <acquire+0x50>
}
8010451f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104522:	5b                   	pop    %ebx
80104523:	5e                   	pop    %esi
80104524:	5d                   	pop    %ebp
80104525:	c3                   	ret    
80104526:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010452d:	8d 76 00             	lea    0x0(%esi),%esi
  for(; i < 10; i++)
80104530:	8d 44 b3 0c          	lea    0xc(%ebx,%esi,4),%eax
80104534:	83 c3 34             	add    $0x34,%ebx
80104537:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010453e:	66 90                	xchg   %ax,%ax
    pcs[i] = 0;
80104540:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
80104546:	83 c0 04             	add    $0x4,%eax
80104549:	39 d8                	cmp    %ebx,%eax
8010454b:	75 f3                	jne    80104540 <acquire+0x90>
}
8010454d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104550:	5b                   	pop    %ebx
80104551:	5e                   	pop    %esi
80104552:	5d                   	pop    %ebp
80104553:	c3                   	ret    
    panic("acquire");
80104554:	83 ec 0c             	sub    $0xc,%esp
80104557:	68 81 76 10 80       	push   $0x80107681
8010455c:	e8 2f be ff ff       	call   80100390 <panic>
80104561:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104568:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010456f:	90                   	nop

80104570 <release>:
{
80104570:	55                   	push   %ebp
80104571:	89 e5                	mov    %esp,%ebp
80104573:	53                   	push   %ebx
80104574:	83 ec 10             	sub    $0x10,%esp
80104577:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holding(lk))
8010457a:	53                   	push   %ebx
8010457b:	e8 f0 fe ff ff       	call   80104470 <holding>
80104580:	83 c4 10             	add    $0x10,%esp
80104583:	85 c0                	test   %eax,%eax
80104585:	74 20                	je     801045a7 <release+0x37>
  lk->pcs[0] = 0;
80104587:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
8010458e:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
80104595:	0f ae f0             	mfence 
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
80104598:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
}
8010459e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801045a1:	c9                   	leave  
  popcli();
801045a2:	e9 69 fe ff ff       	jmp    80104410 <popcli>
    panic("release");
801045a7:	83 ec 0c             	sub    $0xc,%esp
801045aa:	68 89 76 10 80       	push   $0x80107689
801045af:	e8 dc bd ff ff       	call   80100390 <panic>
801045b4:	66 90                	xchg   %ax,%ax
801045b6:	66 90                	xchg   %ax,%ax
801045b8:	66 90                	xchg   %ax,%ax
801045ba:	66 90                	xchg   %ax,%ax
801045bc:	66 90                	xchg   %ax,%ax
801045be:	66 90                	xchg   %ax,%ax

801045c0 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
801045c0:	55                   	push   %ebp
801045c1:	89 e5                	mov    %esp,%ebp
801045c3:	57                   	push   %edi
801045c4:	8b 55 08             	mov    0x8(%ebp),%edx
801045c7:	8b 4d 10             	mov    0x10(%ebp),%ecx
801045ca:	53                   	push   %ebx
  if ((int)dst%4 == 0 && n%4 == 0){
801045cb:	89 d0                	mov    %edx,%eax
801045cd:	09 c8                	or     %ecx,%eax
801045cf:	a8 03                	test   $0x3,%al
801045d1:	75 2d                	jne    80104600 <memset+0x40>
    c &= 0xFF;
801045d3:	0f b6 7d 0c          	movzbl 0xc(%ebp),%edi
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
801045d7:	c1 e9 02             	shr    $0x2,%ecx
801045da:	89 f8                	mov    %edi,%eax
801045dc:	89 fb                	mov    %edi,%ebx
801045de:	c1 e0 18             	shl    $0x18,%eax
801045e1:	c1 e3 10             	shl    $0x10,%ebx
801045e4:	09 d8                	or     %ebx,%eax
801045e6:	09 f8                	or     %edi,%eax
801045e8:	c1 e7 08             	shl    $0x8,%edi
801045eb:	09 f8                	or     %edi,%eax
  asm volatile("cld; rep stosl" :
801045ed:	89 d7                	mov    %edx,%edi
801045ef:	fc                   	cld    
801045f0:	f3 ab                	rep stos %eax,%es:(%edi)
  } else
    stosb(dst, c, n);
  return dst;
}
801045f2:	5b                   	pop    %ebx
801045f3:	89 d0                	mov    %edx,%eax
801045f5:	5f                   	pop    %edi
801045f6:	5d                   	pop    %ebp
801045f7:	c3                   	ret    
801045f8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801045ff:	90                   	nop
  asm volatile("cld; rep stosb" :
80104600:	89 d7                	mov    %edx,%edi
80104602:	8b 45 0c             	mov    0xc(%ebp),%eax
80104605:	fc                   	cld    
80104606:	f3 aa                	rep stos %al,%es:(%edi)
80104608:	5b                   	pop    %ebx
80104609:	89 d0                	mov    %edx,%eax
8010460b:	5f                   	pop    %edi
8010460c:	5d                   	pop    %ebp
8010460d:	c3                   	ret    
8010460e:	66 90                	xchg   %ax,%ax

80104610 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80104610:	55                   	push   %ebp
80104611:	89 e5                	mov    %esp,%ebp
80104613:	56                   	push   %esi
80104614:	8b 75 10             	mov    0x10(%ebp),%esi
80104617:	8b 45 08             	mov    0x8(%ebp),%eax
8010461a:	53                   	push   %ebx
8010461b:	8b 55 0c             	mov    0xc(%ebp),%edx
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
8010461e:	85 f6                	test   %esi,%esi
80104620:	74 22                	je     80104644 <memcmp+0x34>
    if(*s1 != *s2)
80104622:	0f b6 08             	movzbl (%eax),%ecx
80104625:	0f b6 1a             	movzbl (%edx),%ebx
80104628:	01 c6                	add    %eax,%esi
8010462a:	38 cb                	cmp    %cl,%bl
8010462c:	74 0c                	je     8010463a <memcmp+0x2a>
8010462e:	eb 20                	jmp    80104650 <memcmp+0x40>
80104630:	0f b6 08             	movzbl (%eax),%ecx
80104633:	0f b6 1a             	movzbl (%edx),%ebx
80104636:	38 d9                	cmp    %bl,%cl
80104638:	75 16                	jne    80104650 <memcmp+0x40>
      return *s1 - *s2;
    s1++, s2++;
8010463a:	83 c0 01             	add    $0x1,%eax
8010463d:	83 c2 01             	add    $0x1,%edx
  while(n-- > 0){
80104640:	39 c6                	cmp    %eax,%esi
80104642:	75 ec                	jne    80104630 <memcmp+0x20>
  }

  return 0;
}
80104644:	5b                   	pop    %ebx
  return 0;
80104645:	31 c0                	xor    %eax,%eax
}
80104647:	5e                   	pop    %esi
80104648:	5d                   	pop    %ebp
80104649:	c3                   	ret    
8010464a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      return *s1 - *s2;
80104650:	0f b6 c1             	movzbl %cl,%eax
80104653:	29 d8                	sub    %ebx,%eax
}
80104655:	5b                   	pop    %ebx
80104656:	5e                   	pop    %esi
80104657:	5d                   	pop    %ebp
80104658:	c3                   	ret    
80104659:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104660 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80104660:	55                   	push   %ebp
80104661:	89 e5                	mov    %esp,%ebp
80104663:	57                   	push   %edi
80104664:	8b 45 08             	mov    0x8(%ebp),%eax
80104667:	8b 4d 10             	mov    0x10(%ebp),%ecx
8010466a:	56                   	push   %esi
8010466b:	8b 75 0c             	mov    0xc(%ebp),%esi
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
8010466e:	39 c6                	cmp    %eax,%esi
80104670:	73 26                	jae    80104698 <memmove+0x38>
80104672:	8d 3c 0e             	lea    (%esi,%ecx,1),%edi
80104675:	39 f8                	cmp    %edi,%eax
80104677:	73 1f                	jae    80104698 <memmove+0x38>
80104679:	8d 51 ff             	lea    -0x1(%ecx),%edx
    s += n;
    d += n;
    while(n-- > 0)
8010467c:	85 c9                	test   %ecx,%ecx
8010467e:	74 0f                	je     8010468f <memmove+0x2f>
      *--d = *--s;
80104680:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
80104684:	88 0c 10             	mov    %cl,(%eax,%edx,1)
    while(n-- > 0)
80104687:	83 ea 01             	sub    $0x1,%edx
8010468a:	83 fa ff             	cmp    $0xffffffff,%edx
8010468d:	75 f1                	jne    80104680 <memmove+0x20>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
8010468f:	5e                   	pop    %esi
80104690:	5f                   	pop    %edi
80104691:	5d                   	pop    %ebp
80104692:	c3                   	ret    
80104693:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104697:	90                   	nop
    while(n-- > 0)
80104698:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
8010469b:	89 c7                	mov    %eax,%edi
8010469d:	85 c9                	test   %ecx,%ecx
8010469f:	74 ee                	je     8010468f <memmove+0x2f>
801046a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      *d++ = *s++;
801046a8:	a4                   	movsb  %ds:(%esi),%es:(%edi)
    while(n-- > 0)
801046a9:	39 d6                	cmp    %edx,%esi
801046ab:	75 fb                	jne    801046a8 <memmove+0x48>
}
801046ad:	5e                   	pop    %esi
801046ae:	5f                   	pop    %edi
801046af:	5d                   	pop    %ebp
801046b0:	c3                   	ret    
801046b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801046b8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801046bf:	90                   	nop

801046c0 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
  return memmove(dst, src, n);
801046c0:	eb 9e                	jmp    80104660 <memmove>
801046c2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801046c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801046d0 <strncmp>:
}

int
strncmp(const char *p, const char *q, uint n)
{
801046d0:	55                   	push   %ebp
801046d1:	89 e5                	mov    %esp,%ebp
801046d3:	57                   	push   %edi
801046d4:	8b 7d 10             	mov    0x10(%ebp),%edi
801046d7:	8b 4d 08             	mov    0x8(%ebp),%ecx
801046da:	56                   	push   %esi
801046db:	8b 75 0c             	mov    0xc(%ebp),%esi
801046de:	53                   	push   %ebx
  while(n > 0 && *p && *p == *q)
801046df:	85 ff                	test   %edi,%edi
801046e1:	74 2f                	je     80104712 <strncmp+0x42>
801046e3:	0f b6 11             	movzbl (%ecx),%edx
801046e6:	0f b6 1e             	movzbl (%esi),%ebx
801046e9:	84 d2                	test   %dl,%dl
801046eb:	74 37                	je     80104724 <strncmp+0x54>
801046ed:	38 da                	cmp    %bl,%dl
801046ef:	75 33                	jne    80104724 <strncmp+0x54>
801046f1:	01 f7                	add    %esi,%edi
801046f3:	eb 13                	jmp    80104708 <strncmp+0x38>
801046f5:	8d 76 00             	lea    0x0(%esi),%esi
801046f8:	0f b6 11             	movzbl (%ecx),%edx
801046fb:	84 d2                	test   %dl,%dl
801046fd:	74 21                	je     80104720 <strncmp+0x50>
801046ff:	0f b6 18             	movzbl (%eax),%ebx
80104702:	89 c6                	mov    %eax,%esi
80104704:	38 da                	cmp    %bl,%dl
80104706:	75 1c                	jne    80104724 <strncmp+0x54>
    n--, p++, q++;
80104708:	8d 46 01             	lea    0x1(%esi),%eax
8010470b:	83 c1 01             	add    $0x1,%ecx
  while(n > 0 && *p && *p == *q)
8010470e:	39 f8                	cmp    %edi,%eax
80104710:	75 e6                	jne    801046f8 <strncmp+0x28>
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
}
80104712:	5b                   	pop    %ebx
    return 0;
80104713:	31 c0                	xor    %eax,%eax
}
80104715:	5e                   	pop    %esi
80104716:	5f                   	pop    %edi
80104717:	5d                   	pop    %ebp
80104718:	c3                   	ret    
80104719:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104720:	0f b6 5e 01          	movzbl 0x1(%esi),%ebx
  return (uchar)*p - (uchar)*q;
80104724:	0f b6 c2             	movzbl %dl,%eax
80104727:	29 d8                	sub    %ebx,%eax
}
80104729:	5b                   	pop    %ebx
8010472a:	5e                   	pop    %esi
8010472b:	5f                   	pop    %edi
8010472c:	5d                   	pop    %ebp
8010472d:	c3                   	ret    
8010472e:	66 90                	xchg   %ax,%ax

80104730 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80104730:	55                   	push   %ebp
80104731:	89 e5                	mov    %esp,%ebp
80104733:	57                   	push   %edi
80104734:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
80104737:	8b 4d 08             	mov    0x8(%ebp),%ecx
{
8010473a:	56                   	push   %esi
8010473b:	53                   	push   %ebx
8010473c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  while(n-- > 0 && (*s++ = *t++) != 0)
8010473f:	eb 1a                	jmp    8010475b <strncpy+0x2b>
80104741:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104748:	83 c2 01             	add    $0x1,%edx
8010474b:	0f b6 42 ff          	movzbl -0x1(%edx),%eax
8010474f:	83 c1 01             	add    $0x1,%ecx
80104752:	88 41 ff             	mov    %al,-0x1(%ecx)
80104755:	84 c0                	test   %al,%al
80104757:	74 09                	je     80104762 <strncpy+0x32>
80104759:	89 fb                	mov    %edi,%ebx
8010475b:	8d 7b ff             	lea    -0x1(%ebx),%edi
8010475e:	85 db                	test   %ebx,%ebx
80104760:	7f e6                	jg     80104748 <strncpy+0x18>
    ;
  while(n-- > 0)
80104762:	89 ce                	mov    %ecx,%esi
80104764:	85 ff                	test   %edi,%edi
80104766:	7e 1b                	jle    80104783 <strncpy+0x53>
80104768:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010476f:	90                   	nop
    *s++ = 0;
80104770:	83 c6 01             	add    $0x1,%esi
80104773:	c6 46 ff 00          	movb   $0x0,-0x1(%esi)
  while(n-- > 0)
80104777:	89 f2                	mov    %esi,%edx
80104779:	f7 d2                	not    %edx
8010477b:	01 ca                	add    %ecx,%edx
8010477d:	01 da                	add    %ebx,%edx
8010477f:	85 d2                	test   %edx,%edx
80104781:	7f ed                	jg     80104770 <strncpy+0x40>
  return os;
}
80104783:	5b                   	pop    %ebx
80104784:	8b 45 08             	mov    0x8(%ebp),%eax
80104787:	5e                   	pop    %esi
80104788:	5f                   	pop    %edi
80104789:	5d                   	pop    %ebp
8010478a:	c3                   	ret    
8010478b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010478f:	90                   	nop

80104790 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80104790:	55                   	push   %ebp
80104791:	89 e5                	mov    %esp,%ebp
80104793:	56                   	push   %esi
80104794:	8b 4d 10             	mov    0x10(%ebp),%ecx
80104797:	8b 45 08             	mov    0x8(%ebp),%eax
8010479a:	53                   	push   %ebx
8010479b:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *os;

  os = s;
  if(n <= 0)
8010479e:	85 c9                	test   %ecx,%ecx
801047a0:	7e 26                	jle    801047c8 <safestrcpy+0x38>
801047a2:	8d 74 0a ff          	lea    -0x1(%edx,%ecx,1),%esi
801047a6:	89 c1                	mov    %eax,%ecx
801047a8:	eb 17                	jmp    801047c1 <safestrcpy+0x31>
801047aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
801047b0:	83 c2 01             	add    $0x1,%edx
801047b3:	0f b6 5a ff          	movzbl -0x1(%edx),%ebx
801047b7:	83 c1 01             	add    $0x1,%ecx
801047ba:	88 59 ff             	mov    %bl,-0x1(%ecx)
801047bd:	84 db                	test   %bl,%bl
801047bf:	74 04                	je     801047c5 <safestrcpy+0x35>
801047c1:	39 f2                	cmp    %esi,%edx
801047c3:	75 eb                	jne    801047b0 <safestrcpy+0x20>
    ;
  *s = 0;
801047c5:	c6 01 00             	movb   $0x0,(%ecx)
  return os;
}
801047c8:	5b                   	pop    %ebx
801047c9:	5e                   	pop    %esi
801047ca:	5d                   	pop    %ebp
801047cb:	c3                   	ret    
801047cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801047d0 <strlen>:

int
strlen(const char *s)
{
801047d0:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
801047d1:	31 c0                	xor    %eax,%eax
{
801047d3:	89 e5                	mov    %esp,%ebp
801047d5:	8b 55 08             	mov    0x8(%ebp),%edx
  for(n = 0; s[n]; n++)
801047d8:	80 3a 00             	cmpb   $0x0,(%edx)
801047db:	74 0c                	je     801047e9 <strlen+0x19>
801047dd:	8d 76 00             	lea    0x0(%esi),%esi
801047e0:	83 c0 01             	add    $0x1,%eax
801047e3:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
801047e7:	75 f7                	jne    801047e0 <strlen+0x10>
    ;
  return n;
}
801047e9:	5d                   	pop    %ebp
801047ea:	c3                   	ret    

801047eb <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
801047eb:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
801047ef:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-saved registers
  pushl %ebp
801047f3:	55                   	push   %ebp
  pushl %ebx
801047f4:	53                   	push   %ebx
  pushl %esi
801047f5:	56                   	push   %esi
  pushl %edi
801047f6:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
801047f7:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
801047f9:	89 d4                	mov    %edx,%esp

  # Load new callee-saved registers
  popl %edi
801047fb:	5f                   	pop    %edi
  popl %esi
801047fc:	5e                   	pop    %esi
  popl %ebx
801047fd:	5b                   	pop    %ebx
  popl %ebp
801047fe:	5d                   	pop    %ebp
  ret
801047ff:	c3                   	ret    

80104800 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80104800:	55                   	push   %ebp
80104801:	89 e5                	mov    %esp,%ebp
80104803:	53                   	push   %ebx
80104804:	83 ec 04             	sub    $0x4,%esp
80104807:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
8010480a:	e8 21 f1 ff ff       	call   80103930 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
8010480f:	8b 00                	mov    (%eax),%eax
80104811:	39 d8                	cmp    %ebx,%eax
80104813:	76 1b                	jbe    80104830 <fetchint+0x30>
80104815:	8d 53 04             	lea    0x4(%ebx),%edx
80104818:	39 d0                	cmp    %edx,%eax
8010481a:	72 14                	jb     80104830 <fetchint+0x30>
    return -1;
  *ip = *(int*)(addr);
8010481c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010481f:	8b 13                	mov    (%ebx),%edx
80104821:	89 10                	mov    %edx,(%eax)
  return 0;
80104823:	31 c0                	xor    %eax,%eax
}
80104825:	83 c4 04             	add    $0x4,%esp
80104828:	5b                   	pop    %ebx
80104829:	5d                   	pop    %ebp
8010482a:	c3                   	ret    
8010482b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010482f:	90                   	nop
    return -1;
80104830:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104835:	eb ee                	jmp    80104825 <fetchint+0x25>
80104837:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010483e:	66 90                	xchg   %ax,%ax

80104840 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80104840:	55                   	push   %ebp
80104841:	89 e5                	mov    %esp,%ebp
80104843:	53                   	push   %ebx
80104844:	83 ec 04             	sub    $0x4,%esp
80104847:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
8010484a:	e8 e1 f0 ff ff       	call   80103930 <myproc>

  if(addr >= curproc->sz)
8010484f:	39 18                	cmp    %ebx,(%eax)
80104851:	76 29                	jbe    8010487c <fetchstr+0x3c>
    return -1;
  *pp = (char*)addr;
80104853:	8b 55 0c             	mov    0xc(%ebp),%edx
80104856:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
80104858:	8b 10                	mov    (%eax),%edx
  for(s = *pp; s < ep; s++){
8010485a:	39 d3                	cmp    %edx,%ebx
8010485c:	73 1e                	jae    8010487c <fetchstr+0x3c>
    if(*s == 0)
8010485e:	80 3b 00             	cmpb   $0x0,(%ebx)
80104861:	74 35                	je     80104898 <fetchstr+0x58>
80104863:	89 d8                	mov    %ebx,%eax
80104865:	eb 0e                	jmp    80104875 <fetchstr+0x35>
80104867:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010486e:	66 90                	xchg   %ax,%ax
80104870:	80 38 00             	cmpb   $0x0,(%eax)
80104873:	74 1b                	je     80104890 <fetchstr+0x50>
  for(s = *pp; s < ep; s++){
80104875:	83 c0 01             	add    $0x1,%eax
80104878:	39 c2                	cmp    %eax,%edx
8010487a:	77 f4                	ja     80104870 <fetchstr+0x30>
    return -1;
8010487c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
      return s - *pp;
  }
  return -1;
}
80104881:	83 c4 04             	add    $0x4,%esp
80104884:	5b                   	pop    %ebx
80104885:	5d                   	pop    %ebp
80104886:	c3                   	ret    
80104887:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010488e:	66 90                	xchg   %ax,%ax
80104890:	83 c4 04             	add    $0x4,%esp
80104893:	29 d8                	sub    %ebx,%eax
80104895:	5b                   	pop    %ebx
80104896:	5d                   	pop    %ebp
80104897:	c3                   	ret    
    if(*s == 0)
80104898:	31 c0                	xor    %eax,%eax
      return s - *pp;
8010489a:	eb e5                	jmp    80104881 <fetchstr+0x41>
8010489c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801048a0 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
801048a0:	55                   	push   %ebp
801048a1:	89 e5                	mov    %esp,%ebp
801048a3:	56                   	push   %esi
801048a4:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
801048a5:	e8 86 f0 ff ff       	call   80103930 <myproc>
801048aa:	8b 55 08             	mov    0x8(%ebp),%edx
801048ad:	8b 40 18             	mov    0x18(%eax),%eax
801048b0:	8b 40 44             	mov    0x44(%eax),%eax
801048b3:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
801048b6:	e8 75 f0 ff ff       	call   80103930 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
801048bb:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
801048be:	8b 00                	mov    (%eax),%eax
801048c0:	39 c6                	cmp    %eax,%esi
801048c2:	73 1c                	jae    801048e0 <argint+0x40>
801048c4:	8d 53 08             	lea    0x8(%ebx),%edx
801048c7:	39 d0                	cmp    %edx,%eax
801048c9:	72 15                	jb     801048e0 <argint+0x40>
  *ip = *(int*)(addr);
801048cb:	8b 45 0c             	mov    0xc(%ebp),%eax
801048ce:	8b 53 04             	mov    0x4(%ebx),%edx
801048d1:	89 10                	mov    %edx,(%eax)
  return 0;
801048d3:	31 c0                	xor    %eax,%eax
}
801048d5:	5b                   	pop    %ebx
801048d6:	5e                   	pop    %esi
801048d7:	5d                   	pop    %ebp
801048d8:	c3                   	ret    
801048d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
801048e0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
801048e5:	eb ee                	jmp    801048d5 <argint+0x35>
801048e7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801048ee:	66 90                	xchg   %ax,%ax

801048f0 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
801048f0:	55                   	push   %ebp
801048f1:	89 e5                	mov    %esp,%ebp
801048f3:	56                   	push   %esi
801048f4:	53                   	push   %ebx
801048f5:	83 ec 10             	sub    $0x10,%esp
801048f8:	8b 5d 10             	mov    0x10(%ebp),%ebx
  int i;
  struct proc *curproc = myproc();
801048fb:	e8 30 f0 ff ff       	call   80103930 <myproc>
 
  if(argint(n, &i) < 0)
80104900:	83 ec 08             	sub    $0x8,%esp
  struct proc *curproc = myproc();
80104903:	89 c6                	mov    %eax,%esi
  if(argint(n, &i) < 0)
80104905:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104908:	50                   	push   %eax
80104909:	ff 75 08             	pushl  0x8(%ebp)
8010490c:	e8 8f ff ff ff       	call   801048a0 <argint>
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80104911:	83 c4 10             	add    $0x10,%esp
80104914:	85 c0                	test   %eax,%eax
80104916:	78 28                	js     80104940 <argptr+0x50>
80104918:	85 db                	test   %ebx,%ebx
8010491a:	78 24                	js     80104940 <argptr+0x50>
8010491c:	8b 16                	mov    (%esi),%edx
8010491e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104921:	39 c2                	cmp    %eax,%edx
80104923:	76 1b                	jbe    80104940 <argptr+0x50>
80104925:	01 c3                	add    %eax,%ebx
80104927:	39 da                	cmp    %ebx,%edx
80104929:	72 15                	jb     80104940 <argptr+0x50>
    return -1;
  *pp = (char*)i;
8010492b:	8b 55 0c             	mov    0xc(%ebp),%edx
8010492e:	89 02                	mov    %eax,(%edx)
  return 0;
80104930:	31 c0                	xor    %eax,%eax
}
80104932:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104935:	5b                   	pop    %ebx
80104936:	5e                   	pop    %esi
80104937:	5d                   	pop    %ebp
80104938:	c3                   	ret    
80104939:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80104940:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104945:	eb eb                	jmp    80104932 <argptr+0x42>
80104947:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010494e:	66 90                	xchg   %ax,%ax

80104950 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80104950:	55                   	push   %ebp
80104951:	89 e5                	mov    %esp,%ebp
80104953:	83 ec 20             	sub    $0x20,%esp
  int addr;
  if(argint(n, &addr) < 0)
80104956:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104959:	50                   	push   %eax
8010495a:	ff 75 08             	pushl  0x8(%ebp)
8010495d:	e8 3e ff ff ff       	call   801048a0 <argint>
80104962:	83 c4 10             	add    $0x10,%esp
80104965:	85 c0                	test   %eax,%eax
80104967:	78 17                	js     80104980 <argstr+0x30>
    return -1;
  return fetchstr(addr, pp);
80104969:	83 ec 08             	sub    $0x8,%esp
8010496c:	ff 75 0c             	pushl  0xc(%ebp)
8010496f:	ff 75 f4             	pushl  -0xc(%ebp)
80104972:	e8 c9 fe ff ff       	call   80104840 <fetchstr>
80104977:	83 c4 10             	add    $0x10,%esp
}
8010497a:	c9                   	leave  
8010497b:	c3                   	ret    
8010497c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104980:	c9                   	leave  
    return -1;
80104981:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104986:	c3                   	ret    
80104987:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010498e:	66 90                	xchg   %ax,%ax

80104990 <syscall>:
[SYS_freemem] sys_freemem,
};

void
syscall(void)
{
80104990:	55                   	push   %ebp
80104991:	89 e5                	mov    %esp,%ebp
80104993:	53                   	push   %ebx
80104994:	83 ec 04             	sub    $0x4,%esp
  int num;
  struct proc *curproc = myproc();
80104997:	e8 94 ef ff ff       	call   80103930 <myproc>
8010499c:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
8010499e:	8b 40 18             	mov    0x18(%eax),%eax
801049a1:	8b 40 1c             	mov    0x1c(%eax),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
801049a4:	8d 50 ff             	lea    -0x1(%eax),%edx
801049a7:	83 fa 15             	cmp    $0x15,%edx
801049aa:	77 1c                	ja     801049c8 <syscall+0x38>
801049ac:	8b 14 85 c0 76 10 80 	mov    -0x7fef8940(,%eax,4),%edx
801049b3:	85 d2                	test   %edx,%edx
801049b5:	74 11                	je     801049c8 <syscall+0x38>
    curproc->tf->eax = syscalls[num]();
801049b7:	ff d2                	call   *%edx
801049b9:	8b 53 18             	mov    0x18(%ebx),%edx
801049bc:	89 42 1c             	mov    %eax,0x1c(%edx)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
801049bf:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801049c2:	c9                   	leave  
801049c3:	c3                   	ret    
801049c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    cprintf("%d %s: unknown sys call %d\n",
801049c8:	50                   	push   %eax
            curproc->pid, curproc->name, num);
801049c9:	8d 43 6c             	lea    0x6c(%ebx),%eax
    cprintf("%d %s: unknown sys call %d\n",
801049cc:	50                   	push   %eax
801049cd:	ff 73 10             	pushl  0x10(%ebx)
801049d0:	68 91 76 10 80       	push   $0x80107691
801049d5:	e8 d6 bc ff ff       	call   801006b0 <cprintf>
    curproc->tf->eax = -1;
801049da:	8b 43 18             	mov    0x18(%ebx),%eax
801049dd:	83 c4 10             	add    $0x10,%esp
801049e0:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
}
801049e7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801049ea:	c9                   	leave  
801049eb:	c3                   	ret    
801049ec:	66 90                	xchg   %ax,%ax
801049ee:	66 90                	xchg   %ax,%ax

801049f0 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
801049f0:	55                   	push   %ebp
801049f1:	89 e5                	mov    %esp,%ebp
801049f3:	57                   	push   %edi
801049f4:	56                   	push   %esi
801049f5:	53                   	push   %ebx
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
801049f6:	8d 5d da             	lea    -0x26(%ebp),%ebx
{
801049f9:	83 ec 44             	sub    $0x44,%esp
801049fc:	89 4d c0             	mov    %ecx,-0x40(%ebp)
801049ff:	8b 4d 08             	mov    0x8(%ebp),%ecx
  if((dp = nameiparent(path, name)) == 0)
80104a02:	53                   	push   %ebx
80104a03:	50                   	push   %eax
{
80104a04:	89 55 c4             	mov    %edx,-0x3c(%ebp)
80104a07:	89 4d bc             	mov    %ecx,-0x44(%ebp)
  if((dp = nameiparent(path, name)) == 0)
80104a0a:	e8 d1 d5 ff ff       	call   80101fe0 <nameiparent>
80104a0f:	83 c4 10             	add    $0x10,%esp
80104a12:	85 c0                	test   %eax,%eax
80104a14:	0f 84 46 01 00 00    	je     80104b60 <create+0x170>
    return 0;
  ilock(dp);
80104a1a:	83 ec 0c             	sub    $0xc,%esp
80104a1d:	89 c6                	mov    %eax,%esi
80104a1f:	50                   	push   %eax
80104a20:	e8 fb cc ff ff       	call   80101720 <ilock>

  if((ip = dirlookup(dp, name, &off)) != 0){
80104a25:	83 c4 0c             	add    $0xc,%esp
80104a28:	8d 45 d4             	lea    -0x2c(%ebp),%eax
80104a2b:	50                   	push   %eax
80104a2c:	53                   	push   %ebx
80104a2d:	56                   	push   %esi
80104a2e:	e8 1d d2 ff ff       	call   80101c50 <dirlookup>
80104a33:	83 c4 10             	add    $0x10,%esp
80104a36:	89 c7                	mov    %eax,%edi
80104a38:	85 c0                	test   %eax,%eax
80104a3a:	74 54                	je     80104a90 <create+0xa0>
    iunlockput(dp);
80104a3c:	83 ec 0c             	sub    $0xc,%esp
80104a3f:	56                   	push   %esi
80104a40:	e8 6b cf ff ff       	call   801019b0 <iunlockput>
    ilock(ip);
80104a45:	89 3c 24             	mov    %edi,(%esp)
80104a48:	e8 d3 cc ff ff       	call   80101720 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
80104a4d:	83 c4 10             	add    $0x10,%esp
80104a50:	66 83 7d c4 02       	cmpw   $0x2,-0x3c(%ebp)
80104a55:	75 19                	jne    80104a70 <create+0x80>
80104a57:	66 83 7f 50 02       	cmpw   $0x2,0x50(%edi)
80104a5c:	75 12                	jne    80104a70 <create+0x80>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
80104a5e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104a61:	89 f8                	mov    %edi,%eax
80104a63:	5b                   	pop    %ebx
80104a64:	5e                   	pop    %esi
80104a65:	5f                   	pop    %edi
80104a66:	5d                   	pop    %ebp
80104a67:	c3                   	ret    
80104a68:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104a6f:	90                   	nop
    iunlockput(ip);
80104a70:	83 ec 0c             	sub    $0xc,%esp
80104a73:	57                   	push   %edi
    return 0;
80104a74:	31 ff                	xor    %edi,%edi
    iunlockput(ip);
80104a76:	e8 35 cf ff ff       	call   801019b0 <iunlockput>
    return 0;
80104a7b:	83 c4 10             	add    $0x10,%esp
}
80104a7e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104a81:	89 f8                	mov    %edi,%eax
80104a83:	5b                   	pop    %ebx
80104a84:	5e                   	pop    %esi
80104a85:	5f                   	pop    %edi
80104a86:	5d                   	pop    %ebp
80104a87:	c3                   	ret    
80104a88:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104a8f:	90                   	nop
  if((ip = ialloc(dp->dev, type)) == 0)
80104a90:	0f bf 45 c4          	movswl -0x3c(%ebp),%eax
80104a94:	83 ec 08             	sub    $0x8,%esp
80104a97:	50                   	push   %eax
80104a98:	ff 36                	pushl  (%esi)
80104a9a:	e8 11 cb ff ff       	call   801015b0 <ialloc>
80104a9f:	83 c4 10             	add    $0x10,%esp
80104aa2:	89 c7                	mov    %eax,%edi
80104aa4:	85 c0                	test   %eax,%eax
80104aa6:	0f 84 cd 00 00 00    	je     80104b79 <create+0x189>
  ilock(ip);
80104aac:	83 ec 0c             	sub    $0xc,%esp
80104aaf:	50                   	push   %eax
80104ab0:	e8 6b cc ff ff       	call   80101720 <ilock>
  ip->major = major;
80104ab5:	0f b7 45 c0          	movzwl -0x40(%ebp),%eax
80104ab9:	66 89 47 52          	mov    %ax,0x52(%edi)
  ip->minor = minor;
80104abd:	0f b7 45 bc          	movzwl -0x44(%ebp),%eax
80104ac1:	66 89 47 54          	mov    %ax,0x54(%edi)
  ip->nlink = 1;
80104ac5:	b8 01 00 00 00       	mov    $0x1,%eax
80104aca:	66 89 47 56          	mov    %ax,0x56(%edi)
  iupdate(ip);
80104ace:	89 3c 24             	mov    %edi,(%esp)
80104ad1:	e8 9a cb ff ff       	call   80101670 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
80104ad6:	83 c4 10             	add    $0x10,%esp
80104ad9:	66 83 7d c4 01       	cmpw   $0x1,-0x3c(%ebp)
80104ade:	74 30                	je     80104b10 <create+0x120>
  if(dirlink(dp, name, ip->inum) < 0)
80104ae0:	83 ec 04             	sub    $0x4,%esp
80104ae3:	ff 77 04             	pushl  0x4(%edi)
80104ae6:	53                   	push   %ebx
80104ae7:	56                   	push   %esi
80104ae8:	e8 13 d4 ff ff       	call   80101f00 <dirlink>
80104aed:	83 c4 10             	add    $0x10,%esp
80104af0:	85 c0                	test   %eax,%eax
80104af2:	78 78                	js     80104b6c <create+0x17c>
  iunlockput(dp);
80104af4:	83 ec 0c             	sub    $0xc,%esp
80104af7:	56                   	push   %esi
80104af8:	e8 b3 ce ff ff       	call   801019b0 <iunlockput>
  return ip;
80104afd:	83 c4 10             	add    $0x10,%esp
}
80104b00:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104b03:	89 f8                	mov    %edi,%eax
80104b05:	5b                   	pop    %ebx
80104b06:	5e                   	pop    %esi
80104b07:	5f                   	pop    %edi
80104b08:	5d                   	pop    %ebp
80104b09:	c3                   	ret    
80104b0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iupdate(dp);
80104b10:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink++;  // for ".."
80104b13:	66 83 46 56 01       	addw   $0x1,0x56(%esi)
    iupdate(dp);
80104b18:	56                   	push   %esi
80104b19:	e8 52 cb ff ff       	call   80101670 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
80104b1e:	83 c4 0c             	add    $0xc,%esp
80104b21:	ff 77 04             	pushl  0x4(%edi)
80104b24:	68 38 77 10 80       	push   $0x80107738
80104b29:	57                   	push   %edi
80104b2a:	e8 d1 d3 ff ff       	call   80101f00 <dirlink>
80104b2f:	83 c4 10             	add    $0x10,%esp
80104b32:	85 c0                	test   %eax,%eax
80104b34:	78 18                	js     80104b4e <create+0x15e>
80104b36:	83 ec 04             	sub    $0x4,%esp
80104b39:	ff 76 04             	pushl  0x4(%esi)
80104b3c:	68 37 77 10 80       	push   $0x80107737
80104b41:	57                   	push   %edi
80104b42:	e8 b9 d3 ff ff       	call   80101f00 <dirlink>
80104b47:	83 c4 10             	add    $0x10,%esp
80104b4a:	85 c0                	test   %eax,%eax
80104b4c:	79 92                	jns    80104ae0 <create+0xf0>
      panic("create dots");
80104b4e:	83 ec 0c             	sub    $0xc,%esp
80104b51:	68 2b 77 10 80       	push   $0x8010772b
80104b56:	e8 35 b8 ff ff       	call   80100390 <panic>
80104b5b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104b5f:	90                   	nop
}
80104b60:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
80104b63:	31 ff                	xor    %edi,%edi
}
80104b65:	5b                   	pop    %ebx
80104b66:	89 f8                	mov    %edi,%eax
80104b68:	5e                   	pop    %esi
80104b69:	5f                   	pop    %edi
80104b6a:	5d                   	pop    %ebp
80104b6b:	c3                   	ret    
    panic("create: dirlink");
80104b6c:	83 ec 0c             	sub    $0xc,%esp
80104b6f:	68 3a 77 10 80       	push   $0x8010773a
80104b74:	e8 17 b8 ff ff       	call   80100390 <panic>
    panic("create: ialloc");
80104b79:	83 ec 0c             	sub    $0xc,%esp
80104b7c:	68 1c 77 10 80       	push   $0x8010771c
80104b81:	e8 0a b8 ff ff       	call   80100390 <panic>
80104b86:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104b8d:	8d 76 00             	lea    0x0(%esi),%esi

80104b90 <argfd.constprop.0>:
argfd(int n, int *pfd, struct file **pf)
80104b90:	55                   	push   %ebp
80104b91:	89 e5                	mov    %esp,%ebp
80104b93:	56                   	push   %esi
80104b94:	89 d6                	mov    %edx,%esi
80104b96:	53                   	push   %ebx
80104b97:	89 c3                	mov    %eax,%ebx
  if(argint(n, &fd) < 0)
80104b99:	8d 45 f4             	lea    -0xc(%ebp),%eax
argfd(int n, int *pfd, struct file **pf)
80104b9c:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80104b9f:	50                   	push   %eax
80104ba0:	6a 00                	push   $0x0
80104ba2:	e8 f9 fc ff ff       	call   801048a0 <argint>
80104ba7:	83 c4 10             	add    $0x10,%esp
80104baa:	85 c0                	test   %eax,%eax
80104bac:	78 2a                	js     80104bd8 <argfd.constprop.0+0x48>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80104bae:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104bb2:	77 24                	ja     80104bd8 <argfd.constprop.0+0x48>
80104bb4:	e8 77 ed ff ff       	call   80103930 <myproc>
80104bb9:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104bbc:	8b 44 90 28          	mov    0x28(%eax,%edx,4),%eax
80104bc0:	85 c0                	test   %eax,%eax
80104bc2:	74 14                	je     80104bd8 <argfd.constprop.0+0x48>
  if(pfd)
80104bc4:	85 db                	test   %ebx,%ebx
80104bc6:	74 02                	je     80104bca <argfd.constprop.0+0x3a>
    *pfd = fd;
80104bc8:	89 13                	mov    %edx,(%ebx)
    *pf = f;
80104bca:	89 06                	mov    %eax,(%esi)
  return 0;
80104bcc:	31 c0                	xor    %eax,%eax
}
80104bce:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104bd1:	5b                   	pop    %ebx
80104bd2:	5e                   	pop    %esi
80104bd3:	5d                   	pop    %ebp
80104bd4:	c3                   	ret    
80104bd5:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80104bd8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104bdd:	eb ef                	jmp    80104bce <argfd.constprop.0+0x3e>
80104bdf:	90                   	nop

80104be0 <sys_dup>:
{
80104be0:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0)
80104be1:	31 c0                	xor    %eax,%eax
{
80104be3:	89 e5                	mov    %esp,%ebp
80104be5:	56                   	push   %esi
80104be6:	53                   	push   %ebx
  if(argfd(0, 0, &f) < 0)
80104be7:	8d 55 f4             	lea    -0xc(%ebp),%edx
{
80104bea:	83 ec 10             	sub    $0x10,%esp
  if(argfd(0, 0, &f) < 0)
80104bed:	e8 9e ff ff ff       	call   80104b90 <argfd.constprop.0>
80104bf2:	85 c0                	test   %eax,%eax
80104bf4:	78 1a                	js     80104c10 <sys_dup+0x30>
  if((fd=fdalloc(f)) < 0)
80104bf6:	8b 75 f4             	mov    -0xc(%ebp),%esi
  for(fd = 0; fd < NOFILE; fd++){
80104bf9:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
80104bfb:	e8 30 ed ff ff       	call   80103930 <myproc>
    if(curproc->ofile[fd] == 0){
80104c00:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80104c04:	85 d2                	test   %edx,%edx
80104c06:	74 18                	je     80104c20 <sys_dup+0x40>
  for(fd = 0; fd < NOFILE; fd++){
80104c08:	83 c3 01             	add    $0x1,%ebx
80104c0b:	83 fb 10             	cmp    $0x10,%ebx
80104c0e:	75 f0                	jne    80104c00 <sys_dup+0x20>
}
80104c10:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return -1;
80104c13:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
}
80104c18:	89 d8                	mov    %ebx,%eax
80104c1a:	5b                   	pop    %ebx
80104c1b:	5e                   	pop    %esi
80104c1c:	5d                   	pop    %ebp
80104c1d:	c3                   	ret    
80104c1e:	66 90                	xchg   %ax,%ax
      curproc->ofile[fd] = f;
80104c20:	89 74 98 28          	mov    %esi,0x28(%eax,%ebx,4)
  filedup(f);
80104c24:	83 ec 0c             	sub    $0xc,%esp
80104c27:	ff 75 f4             	pushl  -0xc(%ebp)
80104c2a:	e8 41 c2 ff ff       	call   80100e70 <filedup>
  return fd;
80104c2f:	83 c4 10             	add    $0x10,%esp
}
80104c32:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104c35:	89 d8                	mov    %ebx,%eax
80104c37:	5b                   	pop    %ebx
80104c38:	5e                   	pop    %esi
80104c39:	5d                   	pop    %ebp
80104c3a:	c3                   	ret    
80104c3b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104c3f:	90                   	nop

80104c40 <sys_read>:
{
80104c40:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104c41:	31 c0                	xor    %eax,%eax
{
80104c43:	89 e5                	mov    %esp,%ebp
80104c45:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104c48:	8d 55 ec             	lea    -0x14(%ebp),%edx
80104c4b:	e8 40 ff ff ff       	call   80104b90 <argfd.constprop.0>
80104c50:	85 c0                	test   %eax,%eax
80104c52:	78 4c                	js     80104ca0 <sys_read+0x60>
80104c54:	83 ec 08             	sub    $0x8,%esp
80104c57:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104c5a:	50                   	push   %eax
80104c5b:	6a 02                	push   $0x2
80104c5d:	e8 3e fc ff ff       	call   801048a0 <argint>
80104c62:	83 c4 10             	add    $0x10,%esp
80104c65:	85 c0                	test   %eax,%eax
80104c67:	78 37                	js     80104ca0 <sys_read+0x60>
80104c69:	83 ec 04             	sub    $0x4,%esp
80104c6c:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104c6f:	ff 75 f0             	pushl  -0x10(%ebp)
80104c72:	50                   	push   %eax
80104c73:	6a 01                	push   $0x1
80104c75:	e8 76 fc ff ff       	call   801048f0 <argptr>
80104c7a:	83 c4 10             	add    $0x10,%esp
80104c7d:	85 c0                	test   %eax,%eax
80104c7f:	78 1f                	js     80104ca0 <sys_read+0x60>
  return fileread(f, p, n);
80104c81:	83 ec 04             	sub    $0x4,%esp
80104c84:	ff 75 f0             	pushl  -0x10(%ebp)
80104c87:	ff 75 f4             	pushl  -0xc(%ebp)
80104c8a:	ff 75 ec             	pushl  -0x14(%ebp)
80104c8d:	e8 5e c3 ff ff       	call   80100ff0 <fileread>
80104c92:	83 c4 10             	add    $0x10,%esp
}
80104c95:	c9                   	leave  
80104c96:	c3                   	ret    
80104c97:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104c9e:	66 90                	xchg   %ax,%ax
80104ca0:	c9                   	leave  
    return -1;
80104ca1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104ca6:	c3                   	ret    
80104ca7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104cae:	66 90                	xchg   %ax,%ax

80104cb0 <sys_write>:
{
80104cb0:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104cb1:	31 c0                	xor    %eax,%eax
{
80104cb3:	89 e5                	mov    %esp,%ebp
80104cb5:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104cb8:	8d 55 ec             	lea    -0x14(%ebp),%edx
80104cbb:	e8 d0 fe ff ff       	call   80104b90 <argfd.constprop.0>
80104cc0:	85 c0                	test   %eax,%eax
80104cc2:	78 4c                	js     80104d10 <sys_write+0x60>
80104cc4:	83 ec 08             	sub    $0x8,%esp
80104cc7:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104cca:	50                   	push   %eax
80104ccb:	6a 02                	push   $0x2
80104ccd:	e8 ce fb ff ff       	call   801048a0 <argint>
80104cd2:	83 c4 10             	add    $0x10,%esp
80104cd5:	85 c0                	test   %eax,%eax
80104cd7:	78 37                	js     80104d10 <sys_write+0x60>
80104cd9:	83 ec 04             	sub    $0x4,%esp
80104cdc:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104cdf:	ff 75 f0             	pushl  -0x10(%ebp)
80104ce2:	50                   	push   %eax
80104ce3:	6a 01                	push   $0x1
80104ce5:	e8 06 fc ff ff       	call   801048f0 <argptr>
80104cea:	83 c4 10             	add    $0x10,%esp
80104ced:	85 c0                	test   %eax,%eax
80104cef:	78 1f                	js     80104d10 <sys_write+0x60>
  return filewrite(f, p, n);
80104cf1:	83 ec 04             	sub    $0x4,%esp
80104cf4:	ff 75 f0             	pushl  -0x10(%ebp)
80104cf7:	ff 75 f4             	pushl  -0xc(%ebp)
80104cfa:	ff 75 ec             	pushl  -0x14(%ebp)
80104cfd:	e8 7e c3 ff ff       	call   80101080 <filewrite>
80104d02:	83 c4 10             	add    $0x10,%esp
}
80104d05:	c9                   	leave  
80104d06:	c3                   	ret    
80104d07:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104d0e:	66 90                	xchg   %ax,%ax
80104d10:	c9                   	leave  
    return -1;
80104d11:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104d16:	c3                   	ret    
80104d17:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104d1e:	66 90                	xchg   %ax,%ax

80104d20 <sys_close>:
{
80104d20:	55                   	push   %ebp
80104d21:	89 e5                	mov    %esp,%ebp
80104d23:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, &fd, &f) < 0)
80104d26:	8d 55 f4             	lea    -0xc(%ebp),%edx
80104d29:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104d2c:	e8 5f fe ff ff       	call   80104b90 <argfd.constprop.0>
80104d31:	85 c0                	test   %eax,%eax
80104d33:	78 2b                	js     80104d60 <sys_close+0x40>
  myproc()->ofile[fd] = 0;
80104d35:	e8 f6 eb ff ff       	call   80103930 <myproc>
80104d3a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  fileclose(f);
80104d3d:	83 ec 0c             	sub    $0xc,%esp
  myproc()->ofile[fd] = 0;
80104d40:	c7 44 90 28 00 00 00 	movl   $0x0,0x28(%eax,%edx,4)
80104d47:	00 
  fileclose(f);
80104d48:	ff 75 f4             	pushl  -0xc(%ebp)
80104d4b:	e8 70 c1 ff ff       	call   80100ec0 <fileclose>
  return 0;
80104d50:	83 c4 10             	add    $0x10,%esp
80104d53:	31 c0                	xor    %eax,%eax
}
80104d55:	c9                   	leave  
80104d56:	c3                   	ret    
80104d57:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104d5e:	66 90                	xchg   %ax,%ax
80104d60:	c9                   	leave  
    return -1;
80104d61:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104d66:	c3                   	ret    
80104d67:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104d6e:	66 90                	xchg   %ax,%ax

80104d70 <sys_fstat>:
{
80104d70:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80104d71:	31 c0                	xor    %eax,%eax
{
80104d73:	89 e5                	mov    %esp,%ebp
80104d75:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80104d78:	8d 55 f0             	lea    -0x10(%ebp),%edx
80104d7b:	e8 10 fe ff ff       	call   80104b90 <argfd.constprop.0>
80104d80:	85 c0                	test   %eax,%eax
80104d82:	78 2c                	js     80104db0 <sys_fstat+0x40>
80104d84:	83 ec 04             	sub    $0x4,%esp
80104d87:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104d8a:	6a 14                	push   $0x14
80104d8c:	50                   	push   %eax
80104d8d:	6a 01                	push   $0x1
80104d8f:	e8 5c fb ff ff       	call   801048f0 <argptr>
80104d94:	83 c4 10             	add    $0x10,%esp
80104d97:	85 c0                	test   %eax,%eax
80104d99:	78 15                	js     80104db0 <sys_fstat+0x40>
  return filestat(f, st);
80104d9b:	83 ec 08             	sub    $0x8,%esp
80104d9e:	ff 75 f4             	pushl  -0xc(%ebp)
80104da1:	ff 75 f0             	pushl  -0x10(%ebp)
80104da4:	e8 f7 c1 ff ff       	call   80100fa0 <filestat>
80104da9:	83 c4 10             	add    $0x10,%esp
}
80104dac:	c9                   	leave  
80104dad:	c3                   	ret    
80104dae:	66 90                	xchg   %ax,%ax
80104db0:	c9                   	leave  
    return -1;
80104db1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104db6:	c3                   	ret    
80104db7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104dbe:	66 90                	xchg   %ax,%ax

80104dc0 <sys_link>:
{
80104dc0:	55                   	push   %ebp
80104dc1:	89 e5                	mov    %esp,%ebp
80104dc3:	57                   	push   %edi
80104dc4:	56                   	push   %esi
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80104dc5:	8d 45 d4             	lea    -0x2c(%ebp),%eax
{
80104dc8:	53                   	push   %ebx
80104dc9:	83 ec 34             	sub    $0x34,%esp
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80104dcc:	50                   	push   %eax
80104dcd:	6a 00                	push   $0x0
80104dcf:	e8 7c fb ff ff       	call   80104950 <argstr>
80104dd4:	83 c4 10             	add    $0x10,%esp
80104dd7:	85 c0                	test   %eax,%eax
80104dd9:	0f 88 fb 00 00 00    	js     80104eda <sys_link+0x11a>
80104ddf:	83 ec 08             	sub    $0x8,%esp
80104de2:	8d 45 d0             	lea    -0x30(%ebp),%eax
80104de5:	50                   	push   %eax
80104de6:	6a 01                	push   $0x1
80104de8:	e8 63 fb ff ff       	call   80104950 <argstr>
80104ded:	83 c4 10             	add    $0x10,%esp
80104df0:	85 c0                	test   %eax,%eax
80104df2:	0f 88 e2 00 00 00    	js     80104eda <sys_link+0x11a>
  begin_op();
80104df8:	e8 f3 de ff ff       	call   80102cf0 <begin_op>
  if((ip = namei(old)) == 0){
80104dfd:	83 ec 0c             	sub    $0xc,%esp
80104e00:	ff 75 d4             	pushl  -0x2c(%ebp)
80104e03:	e8 b8 d1 ff ff       	call   80101fc0 <namei>
80104e08:	83 c4 10             	add    $0x10,%esp
80104e0b:	89 c3                	mov    %eax,%ebx
80104e0d:	85 c0                	test   %eax,%eax
80104e0f:	0f 84 e4 00 00 00    	je     80104ef9 <sys_link+0x139>
  ilock(ip);
80104e15:	83 ec 0c             	sub    $0xc,%esp
80104e18:	50                   	push   %eax
80104e19:	e8 02 c9 ff ff       	call   80101720 <ilock>
  if(ip->type == T_DIR){
80104e1e:	83 c4 10             	add    $0x10,%esp
80104e21:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80104e26:	0f 84 b5 00 00 00    	je     80104ee1 <sys_link+0x121>
  iupdate(ip);
80104e2c:	83 ec 0c             	sub    $0xc,%esp
  ip->nlink++;
80104e2f:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  if((dp = nameiparent(new, name)) == 0)
80104e34:	8d 7d da             	lea    -0x26(%ebp),%edi
  iupdate(ip);
80104e37:	53                   	push   %ebx
80104e38:	e8 33 c8 ff ff       	call   80101670 <iupdate>
  iunlock(ip);
80104e3d:	89 1c 24             	mov    %ebx,(%esp)
80104e40:	e8 bb c9 ff ff       	call   80101800 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
80104e45:	58                   	pop    %eax
80104e46:	5a                   	pop    %edx
80104e47:	57                   	push   %edi
80104e48:	ff 75 d0             	pushl  -0x30(%ebp)
80104e4b:	e8 90 d1 ff ff       	call   80101fe0 <nameiparent>
80104e50:	83 c4 10             	add    $0x10,%esp
80104e53:	89 c6                	mov    %eax,%esi
80104e55:	85 c0                	test   %eax,%eax
80104e57:	74 5b                	je     80104eb4 <sys_link+0xf4>
  ilock(dp);
80104e59:	83 ec 0c             	sub    $0xc,%esp
80104e5c:	50                   	push   %eax
80104e5d:	e8 be c8 ff ff       	call   80101720 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80104e62:	83 c4 10             	add    $0x10,%esp
80104e65:	8b 03                	mov    (%ebx),%eax
80104e67:	39 06                	cmp    %eax,(%esi)
80104e69:	75 3d                	jne    80104ea8 <sys_link+0xe8>
80104e6b:	83 ec 04             	sub    $0x4,%esp
80104e6e:	ff 73 04             	pushl  0x4(%ebx)
80104e71:	57                   	push   %edi
80104e72:	56                   	push   %esi
80104e73:	e8 88 d0 ff ff       	call   80101f00 <dirlink>
80104e78:	83 c4 10             	add    $0x10,%esp
80104e7b:	85 c0                	test   %eax,%eax
80104e7d:	78 29                	js     80104ea8 <sys_link+0xe8>
  iunlockput(dp);
80104e7f:	83 ec 0c             	sub    $0xc,%esp
80104e82:	56                   	push   %esi
80104e83:	e8 28 cb ff ff       	call   801019b0 <iunlockput>
  iput(ip);
80104e88:	89 1c 24             	mov    %ebx,(%esp)
80104e8b:	e8 c0 c9 ff ff       	call   80101850 <iput>
  end_op();
80104e90:	e8 cb de ff ff       	call   80102d60 <end_op>
  return 0;
80104e95:	83 c4 10             	add    $0x10,%esp
80104e98:	31 c0                	xor    %eax,%eax
}
80104e9a:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104e9d:	5b                   	pop    %ebx
80104e9e:	5e                   	pop    %esi
80104e9f:	5f                   	pop    %edi
80104ea0:	5d                   	pop    %ebp
80104ea1:	c3                   	ret    
80104ea2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(dp);
80104ea8:	83 ec 0c             	sub    $0xc,%esp
80104eab:	56                   	push   %esi
80104eac:	e8 ff ca ff ff       	call   801019b0 <iunlockput>
    goto bad;
80104eb1:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
80104eb4:	83 ec 0c             	sub    $0xc,%esp
80104eb7:	53                   	push   %ebx
80104eb8:	e8 63 c8 ff ff       	call   80101720 <ilock>
  ip->nlink--;
80104ebd:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80104ec2:	89 1c 24             	mov    %ebx,(%esp)
80104ec5:	e8 a6 c7 ff ff       	call   80101670 <iupdate>
  iunlockput(ip);
80104eca:	89 1c 24             	mov    %ebx,(%esp)
80104ecd:	e8 de ca ff ff       	call   801019b0 <iunlockput>
  end_op();
80104ed2:	e8 89 de ff ff       	call   80102d60 <end_op>
  return -1;
80104ed7:	83 c4 10             	add    $0x10,%esp
80104eda:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104edf:	eb b9                	jmp    80104e9a <sys_link+0xda>
    iunlockput(ip);
80104ee1:	83 ec 0c             	sub    $0xc,%esp
80104ee4:	53                   	push   %ebx
80104ee5:	e8 c6 ca ff ff       	call   801019b0 <iunlockput>
    end_op();
80104eea:	e8 71 de ff ff       	call   80102d60 <end_op>
    return -1;
80104eef:	83 c4 10             	add    $0x10,%esp
80104ef2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104ef7:	eb a1                	jmp    80104e9a <sys_link+0xda>
    end_op();
80104ef9:	e8 62 de ff ff       	call   80102d60 <end_op>
    return -1;
80104efe:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104f03:	eb 95                	jmp    80104e9a <sys_link+0xda>
80104f05:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104f0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104f10 <sys_unlink>:
{
80104f10:	55                   	push   %ebp
80104f11:	89 e5                	mov    %esp,%ebp
80104f13:	57                   	push   %edi
80104f14:	56                   	push   %esi
  if(argstr(0, &path) < 0)
80104f15:	8d 45 c0             	lea    -0x40(%ebp),%eax
{
80104f18:	53                   	push   %ebx
80104f19:	83 ec 54             	sub    $0x54,%esp
  if(argstr(0, &path) < 0)
80104f1c:	50                   	push   %eax
80104f1d:	6a 00                	push   $0x0
80104f1f:	e8 2c fa ff ff       	call   80104950 <argstr>
80104f24:	83 c4 10             	add    $0x10,%esp
80104f27:	85 c0                	test   %eax,%eax
80104f29:	0f 88 91 01 00 00    	js     801050c0 <sys_unlink+0x1b0>
  begin_op();
80104f2f:	e8 bc dd ff ff       	call   80102cf0 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80104f34:	8d 5d ca             	lea    -0x36(%ebp),%ebx
80104f37:	83 ec 08             	sub    $0x8,%esp
80104f3a:	53                   	push   %ebx
80104f3b:	ff 75 c0             	pushl  -0x40(%ebp)
80104f3e:	e8 9d d0 ff ff       	call   80101fe0 <nameiparent>
80104f43:	83 c4 10             	add    $0x10,%esp
80104f46:	89 c6                	mov    %eax,%esi
80104f48:	85 c0                	test   %eax,%eax
80104f4a:	0f 84 7a 01 00 00    	je     801050ca <sys_unlink+0x1ba>
  ilock(dp);
80104f50:	83 ec 0c             	sub    $0xc,%esp
80104f53:	50                   	push   %eax
80104f54:	e8 c7 c7 ff ff       	call   80101720 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
80104f59:	58                   	pop    %eax
80104f5a:	5a                   	pop    %edx
80104f5b:	68 38 77 10 80       	push   $0x80107738
80104f60:	53                   	push   %ebx
80104f61:	e8 ca cc ff ff       	call   80101c30 <namecmp>
80104f66:	83 c4 10             	add    $0x10,%esp
80104f69:	85 c0                	test   %eax,%eax
80104f6b:	0f 84 0f 01 00 00    	je     80105080 <sys_unlink+0x170>
80104f71:	83 ec 08             	sub    $0x8,%esp
80104f74:	68 37 77 10 80       	push   $0x80107737
80104f79:	53                   	push   %ebx
80104f7a:	e8 b1 cc ff ff       	call   80101c30 <namecmp>
80104f7f:	83 c4 10             	add    $0x10,%esp
80104f82:	85 c0                	test   %eax,%eax
80104f84:	0f 84 f6 00 00 00    	je     80105080 <sys_unlink+0x170>
  if((ip = dirlookup(dp, name, &off)) == 0)
80104f8a:	83 ec 04             	sub    $0x4,%esp
80104f8d:	8d 45 c4             	lea    -0x3c(%ebp),%eax
80104f90:	50                   	push   %eax
80104f91:	53                   	push   %ebx
80104f92:	56                   	push   %esi
80104f93:	e8 b8 cc ff ff       	call   80101c50 <dirlookup>
80104f98:	83 c4 10             	add    $0x10,%esp
80104f9b:	89 c3                	mov    %eax,%ebx
80104f9d:	85 c0                	test   %eax,%eax
80104f9f:	0f 84 db 00 00 00    	je     80105080 <sys_unlink+0x170>
  ilock(ip);
80104fa5:	83 ec 0c             	sub    $0xc,%esp
80104fa8:	50                   	push   %eax
80104fa9:	e8 72 c7 ff ff       	call   80101720 <ilock>
  if(ip->nlink < 1)
80104fae:	83 c4 10             	add    $0x10,%esp
80104fb1:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
80104fb6:	0f 8e 37 01 00 00    	jle    801050f3 <sys_unlink+0x1e3>
  if(ip->type == T_DIR && !isdirempty(ip)){
80104fbc:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80104fc1:	8d 7d d8             	lea    -0x28(%ebp),%edi
80104fc4:	74 6a                	je     80105030 <sys_unlink+0x120>
  memset(&de, 0, sizeof(de));
80104fc6:	83 ec 04             	sub    $0x4,%esp
80104fc9:	6a 10                	push   $0x10
80104fcb:	6a 00                	push   $0x0
80104fcd:	57                   	push   %edi
80104fce:	e8 ed f5 ff ff       	call   801045c0 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80104fd3:	6a 10                	push   $0x10
80104fd5:	ff 75 c4             	pushl  -0x3c(%ebp)
80104fd8:	57                   	push   %edi
80104fd9:	56                   	push   %esi
80104fda:	e8 21 cb ff ff       	call   80101b00 <writei>
80104fdf:	83 c4 20             	add    $0x20,%esp
80104fe2:	83 f8 10             	cmp    $0x10,%eax
80104fe5:	0f 85 fb 00 00 00    	jne    801050e6 <sys_unlink+0x1d6>
  if(ip->type == T_DIR){
80104feb:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80104ff0:	0f 84 aa 00 00 00    	je     801050a0 <sys_unlink+0x190>
  iunlockput(dp);
80104ff6:	83 ec 0c             	sub    $0xc,%esp
80104ff9:	56                   	push   %esi
80104ffa:	e8 b1 c9 ff ff       	call   801019b0 <iunlockput>
  ip->nlink--;
80104fff:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80105004:	89 1c 24             	mov    %ebx,(%esp)
80105007:	e8 64 c6 ff ff       	call   80101670 <iupdate>
  iunlockput(ip);
8010500c:	89 1c 24             	mov    %ebx,(%esp)
8010500f:	e8 9c c9 ff ff       	call   801019b0 <iunlockput>
  end_op();
80105014:	e8 47 dd ff ff       	call   80102d60 <end_op>
  return 0;
80105019:	83 c4 10             	add    $0x10,%esp
8010501c:	31 c0                	xor    %eax,%eax
}
8010501e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105021:	5b                   	pop    %ebx
80105022:	5e                   	pop    %esi
80105023:	5f                   	pop    %edi
80105024:	5d                   	pop    %ebp
80105025:	c3                   	ret    
80105026:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010502d:	8d 76 00             	lea    0x0(%esi),%esi
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80105030:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
80105034:	76 90                	jbe    80104fc6 <sys_unlink+0xb6>
80105036:	ba 20 00 00 00       	mov    $0x20,%edx
8010503b:	eb 0f                	jmp    8010504c <sys_unlink+0x13c>
8010503d:	8d 76 00             	lea    0x0(%esi),%esi
80105040:	83 c2 10             	add    $0x10,%edx
80105043:	39 53 58             	cmp    %edx,0x58(%ebx)
80105046:	0f 86 7a ff ff ff    	jbe    80104fc6 <sys_unlink+0xb6>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
8010504c:	6a 10                	push   $0x10
8010504e:	52                   	push   %edx
8010504f:	57                   	push   %edi
80105050:	53                   	push   %ebx
80105051:	89 55 b4             	mov    %edx,-0x4c(%ebp)
80105054:	e8 a7 c9 ff ff       	call   80101a00 <readi>
80105059:	83 c4 10             	add    $0x10,%esp
8010505c:	8b 55 b4             	mov    -0x4c(%ebp),%edx
8010505f:	83 f8 10             	cmp    $0x10,%eax
80105062:	75 75                	jne    801050d9 <sys_unlink+0x1c9>
    if(de.inum != 0)
80105064:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80105069:	74 d5                	je     80105040 <sys_unlink+0x130>
    iunlockput(ip);
8010506b:	83 ec 0c             	sub    $0xc,%esp
8010506e:	53                   	push   %ebx
8010506f:	e8 3c c9 ff ff       	call   801019b0 <iunlockput>
    goto bad;
80105074:	83 c4 10             	add    $0x10,%esp
80105077:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010507e:	66 90                	xchg   %ax,%ax
  iunlockput(dp);
80105080:	83 ec 0c             	sub    $0xc,%esp
80105083:	56                   	push   %esi
80105084:	e8 27 c9 ff ff       	call   801019b0 <iunlockput>
  end_op();
80105089:	e8 d2 dc ff ff       	call   80102d60 <end_op>
  return -1;
8010508e:	83 c4 10             	add    $0x10,%esp
80105091:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105096:	eb 86                	jmp    8010501e <sys_unlink+0x10e>
80105098:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010509f:	90                   	nop
    iupdate(dp);
801050a0:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink--;
801050a3:	66 83 6e 56 01       	subw   $0x1,0x56(%esi)
    iupdate(dp);
801050a8:	56                   	push   %esi
801050a9:	e8 c2 c5 ff ff       	call   80101670 <iupdate>
801050ae:	83 c4 10             	add    $0x10,%esp
801050b1:	e9 40 ff ff ff       	jmp    80104ff6 <sys_unlink+0xe6>
801050b6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801050bd:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
801050c0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801050c5:	e9 54 ff ff ff       	jmp    8010501e <sys_unlink+0x10e>
    end_op();
801050ca:	e8 91 dc ff ff       	call   80102d60 <end_op>
    return -1;
801050cf:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801050d4:	e9 45 ff ff ff       	jmp    8010501e <sys_unlink+0x10e>
      panic("isdirempty: readi");
801050d9:	83 ec 0c             	sub    $0xc,%esp
801050dc:	68 5c 77 10 80       	push   $0x8010775c
801050e1:	e8 aa b2 ff ff       	call   80100390 <panic>
    panic("unlink: writei");
801050e6:	83 ec 0c             	sub    $0xc,%esp
801050e9:	68 6e 77 10 80       	push   $0x8010776e
801050ee:	e8 9d b2 ff ff       	call   80100390 <panic>
    panic("unlink: nlink < 1");
801050f3:	83 ec 0c             	sub    $0xc,%esp
801050f6:	68 4a 77 10 80       	push   $0x8010774a
801050fb:	e8 90 b2 ff ff       	call   80100390 <panic>

80105100 <sys_open>:

int
sys_open(void)
{
80105100:	55                   	push   %ebp
80105101:	89 e5                	mov    %esp,%ebp
80105103:	57                   	push   %edi
80105104:	56                   	push   %esi
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105105:	8d 45 e0             	lea    -0x20(%ebp),%eax
{
80105108:	53                   	push   %ebx
80105109:	83 ec 24             	sub    $0x24,%esp
  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
8010510c:	50                   	push   %eax
8010510d:	6a 00                	push   $0x0
8010510f:	e8 3c f8 ff ff       	call   80104950 <argstr>
80105114:	83 c4 10             	add    $0x10,%esp
80105117:	85 c0                	test   %eax,%eax
80105119:	0f 88 8e 00 00 00    	js     801051ad <sys_open+0xad>
8010511f:	83 ec 08             	sub    $0x8,%esp
80105122:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105125:	50                   	push   %eax
80105126:	6a 01                	push   $0x1
80105128:	e8 73 f7 ff ff       	call   801048a0 <argint>
8010512d:	83 c4 10             	add    $0x10,%esp
80105130:	85 c0                	test   %eax,%eax
80105132:	78 79                	js     801051ad <sys_open+0xad>
    return -1;

  begin_op();
80105134:	e8 b7 db ff ff       	call   80102cf0 <begin_op>

  if(omode & O_CREATE){
80105139:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
8010513d:	75 79                	jne    801051b8 <sys_open+0xb8>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
8010513f:	83 ec 0c             	sub    $0xc,%esp
80105142:	ff 75 e0             	pushl  -0x20(%ebp)
80105145:	e8 76 ce ff ff       	call   80101fc0 <namei>
8010514a:	83 c4 10             	add    $0x10,%esp
8010514d:	89 c6                	mov    %eax,%esi
8010514f:	85 c0                	test   %eax,%eax
80105151:	0f 84 7e 00 00 00    	je     801051d5 <sys_open+0xd5>
      end_op();
      return -1;
    }
    ilock(ip);
80105157:	83 ec 0c             	sub    $0xc,%esp
8010515a:	50                   	push   %eax
8010515b:	e8 c0 c5 ff ff       	call   80101720 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
80105160:	83 c4 10             	add    $0x10,%esp
80105163:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80105168:	0f 84 c2 00 00 00    	je     80105230 <sys_open+0x130>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
8010516e:	e8 8d bc ff ff       	call   80100e00 <filealloc>
80105173:	89 c7                	mov    %eax,%edi
80105175:	85 c0                	test   %eax,%eax
80105177:	74 23                	je     8010519c <sys_open+0x9c>
  struct proc *curproc = myproc();
80105179:	e8 b2 e7 ff ff       	call   80103930 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
8010517e:	31 db                	xor    %ebx,%ebx
    if(curproc->ofile[fd] == 0){
80105180:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80105184:	85 d2                	test   %edx,%edx
80105186:	74 60                	je     801051e8 <sys_open+0xe8>
  for(fd = 0; fd < NOFILE; fd++){
80105188:	83 c3 01             	add    $0x1,%ebx
8010518b:	83 fb 10             	cmp    $0x10,%ebx
8010518e:	75 f0                	jne    80105180 <sys_open+0x80>
    if(f)
      fileclose(f);
80105190:	83 ec 0c             	sub    $0xc,%esp
80105193:	57                   	push   %edi
80105194:	e8 27 bd ff ff       	call   80100ec0 <fileclose>
80105199:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
8010519c:	83 ec 0c             	sub    $0xc,%esp
8010519f:	56                   	push   %esi
801051a0:	e8 0b c8 ff ff       	call   801019b0 <iunlockput>
    end_op();
801051a5:	e8 b6 db ff ff       	call   80102d60 <end_op>
    return -1;
801051aa:	83 c4 10             	add    $0x10,%esp
801051ad:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801051b2:	eb 6d                	jmp    80105221 <sys_open+0x121>
801051b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    ip = create(path, T_FILE, 0, 0);
801051b8:	83 ec 0c             	sub    $0xc,%esp
801051bb:	8b 45 e0             	mov    -0x20(%ebp),%eax
801051be:	31 c9                	xor    %ecx,%ecx
801051c0:	ba 02 00 00 00       	mov    $0x2,%edx
801051c5:	6a 00                	push   $0x0
801051c7:	e8 24 f8 ff ff       	call   801049f0 <create>
    if(ip == 0){
801051cc:	83 c4 10             	add    $0x10,%esp
    ip = create(path, T_FILE, 0, 0);
801051cf:	89 c6                	mov    %eax,%esi
    if(ip == 0){
801051d1:	85 c0                	test   %eax,%eax
801051d3:	75 99                	jne    8010516e <sys_open+0x6e>
      end_op();
801051d5:	e8 86 db ff ff       	call   80102d60 <end_op>
      return -1;
801051da:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801051df:	eb 40                	jmp    80105221 <sys_open+0x121>
801051e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  }
  iunlock(ip);
801051e8:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
801051eb:	89 7c 98 28          	mov    %edi,0x28(%eax,%ebx,4)
  iunlock(ip);
801051ef:	56                   	push   %esi
801051f0:	e8 0b c6 ff ff       	call   80101800 <iunlock>
  end_op();
801051f5:	e8 66 db ff ff       	call   80102d60 <end_op>

  f->type = FD_INODE;
801051fa:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
80105200:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105203:	83 c4 10             	add    $0x10,%esp
  f->ip = ip;
80105206:	89 77 10             	mov    %esi,0x10(%edi)
  f->readable = !(omode & O_WRONLY);
80105209:	89 d0                	mov    %edx,%eax
  f->off = 0;
8010520b:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(omode & O_WRONLY);
80105212:	f7 d0                	not    %eax
80105214:	83 e0 01             	and    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105217:	83 e2 03             	and    $0x3,%edx
  f->readable = !(omode & O_WRONLY);
8010521a:	88 47 08             	mov    %al,0x8(%edi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
8010521d:	0f 95 47 09          	setne  0x9(%edi)
  return fd;
}
80105221:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105224:	89 d8                	mov    %ebx,%eax
80105226:	5b                   	pop    %ebx
80105227:	5e                   	pop    %esi
80105228:	5f                   	pop    %edi
80105229:	5d                   	pop    %ebp
8010522a:	c3                   	ret    
8010522b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010522f:	90                   	nop
    if(ip->type == T_DIR && omode != O_RDONLY){
80105230:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80105233:	85 c9                	test   %ecx,%ecx
80105235:	0f 84 33 ff ff ff    	je     8010516e <sys_open+0x6e>
8010523b:	e9 5c ff ff ff       	jmp    8010519c <sys_open+0x9c>

80105240 <sys_mkdir>:

int
sys_mkdir(void)
{
80105240:	55                   	push   %ebp
80105241:	89 e5                	mov    %esp,%ebp
80105243:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
80105246:	e8 a5 da ff ff       	call   80102cf0 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
8010524b:	83 ec 08             	sub    $0x8,%esp
8010524e:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105251:	50                   	push   %eax
80105252:	6a 00                	push   $0x0
80105254:	e8 f7 f6 ff ff       	call   80104950 <argstr>
80105259:	83 c4 10             	add    $0x10,%esp
8010525c:	85 c0                	test   %eax,%eax
8010525e:	78 30                	js     80105290 <sys_mkdir+0x50>
80105260:	83 ec 0c             	sub    $0xc,%esp
80105263:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105266:	31 c9                	xor    %ecx,%ecx
80105268:	ba 01 00 00 00       	mov    $0x1,%edx
8010526d:	6a 00                	push   $0x0
8010526f:	e8 7c f7 ff ff       	call   801049f0 <create>
80105274:	83 c4 10             	add    $0x10,%esp
80105277:	85 c0                	test   %eax,%eax
80105279:	74 15                	je     80105290 <sys_mkdir+0x50>
    end_op();
    return -1;
  }
  iunlockput(ip);
8010527b:	83 ec 0c             	sub    $0xc,%esp
8010527e:	50                   	push   %eax
8010527f:	e8 2c c7 ff ff       	call   801019b0 <iunlockput>
  end_op();
80105284:	e8 d7 da ff ff       	call   80102d60 <end_op>
  return 0;
80105289:	83 c4 10             	add    $0x10,%esp
8010528c:	31 c0                	xor    %eax,%eax
}
8010528e:	c9                   	leave  
8010528f:	c3                   	ret    
    end_op();
80105290:	e8 cb da ff ff       	call   80102d60 <end_op>
    return -1;
80105295:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010529a:	c9                   	leave  
8010529b:	c3                   	ret    
8010529c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801052a0 <sys_mknod>:

int
sys_mknod(void)
{
801052a0:	55                   	push   %ebp
801052a1:	89 e5                	mov    %esp,%ebp
801052a3:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
801052a6:	e8 45 da ff ff       	call   80102cf0 <begin_op>
  if((argstr(0, &path)) < 0 ||
801052ab:	83 ec 08             	sub    $0x8,%esp
801052ae:	8d 45 ec             	lea    -0x14(%ebp),%eax
801052b1:	50                   	push   %eax
801052b2:	6a 00                	push   $0x0
801052b4:	e8 97 f6 ff ff       	call   80104950 <argstr>
801052b9:	83 c4 10             	add    $0x10,%esp
801052bc:	85 c0                	test   %eax,%eax
801052be:	78 60                	js     80105320 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
801052c0:	83 ec 08             	sub    $0x8,%esp
801052c3:	8d 45 f0             	lea    -0x10(%ebp),%eax
801052c6:	50                   	push   %eax
801052c7:	6a 01                	push   $0x1
801052c9:	e8 d2 f5 ff ff       	call   801048a0 <argint>
  if((argstr(0, &path)) < 0 ||
801052ce:	83 c4 10             	add    $0x10,%esp
801052d1:	85 c0                	test   %eax,%eax
801052d3:	78 4b                	js     80105320 <sys_mknod+0x80>
     argint(2, &minor) < 0 ||
801052d5:	83 ec 08             	sub    $0x8,%esp
801052d8:	8d 45 f4             	lea    -0xc(%ebp),%eax
801052db:	50                   	push   %eax
801052dc:	6a 02                	push   $0x2
801052de:	e8 bd f5 ff ff       	call   801048a0 <argint>
     argint(1, &major) < 0 ||
801052e3:	83 c4 10             	add    $0x10,%esp
801052e6:	85 c0                	test   %eax,%eax
801052e8:	78 36                	js     80105320 <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
801052ea:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
801052ee:	83 ec 0c             	sub    $0xc,%esp
801052f1:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
801052f5:	ba 03 00 00 00       	mov    $0x3,%edx
801052fa:	50                   	push   %eax
801052fb:	8b 45 ec             	mov    -0x14(%ebp),%eax
801052fe:	e8 ed f6 ff ff       	call   801049f0 <create>
     argint(2, &minor) < 0 ||
80105303:	83 c4 10             	add    $0x10,%esp
80105306:	85 c0                	test   %eax,%eax
80105308:	74 16                	je     80105320 <sys_mknod+0x80>
    end_op();
    return -1;
  }
  iunlockput(ip);
8010530a:	83 ec 0c             	sub    $0xc,%esp
8010530d:	50                   	push   %eax
8010530e:	e8 9d c6 ff ff       	call   801019b0 <iunlockput>
  end_op();
80105313:	e8 48 da ff ff       	call   80102d60 <end_op>
  return 0;
80105318:	83 c4 10             	add    $0x10,%esp
8010531b:	31 c0                	xor    %eax,%eax
}
8010531d:	c9                   	leave  
8010531e:	c3                   	ret    
8010531f:	90                   	nop
    end_op();
80105320:	e8 3b da ff ff       	call   80102d60 <end_op>
    return -1;
80105325:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010532a:	c9                   	leave  
8010532b:	c3                   	ret    
8010532c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105330 <sys_chdir>:

int
sys_chdir(void)
{
80105330:	55                   	push   %ebp
80105331:	89 e5                	mov    %esp,%ebp
80105333:	56                   	push   %esi
80105334:	53                   	push   %ebx
80105335:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
80105338:	e8 f3 e5 ff ff       	call   80103930 <myproc>
8010533d:	89 c6                	mov    %eax,%esi
  
  begin_op();
8010533f:	e8 ac d9 ff ff       	call   80102cf0 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
80105344:	83 ec 08             	sub    $0x8,%esp
80105347:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010534a:	50                   	push   %eax
8010534b:	6a 00                	push   $0x0
8010534d:	e8 fe f5 ff ff       	call   80104950 <argstr>
80105352:	83 c4 10             	add    $0x10,%esp
80105355:	85 c0                	test   %eax,%eax
80105357:	78 77                	js     801053d0 <sys_chdir+0xa0>
80105359:	83 ec 0c             	sub    $0xc,%esp
8010535c:	ff 75 f4             	pushl  -0xc(%ebp)
8010535f:	e8 5c cc ff ff       	call   80101fc0 <namei>
80105364:	83 c4 10             	add    $0x10,%esp
80105367:	89 c3                	mov    %eax,%ebx
80105369:	85 c0                	test   %eax,%eax
8010536b:	74 63                	je     801053d0 <sys_chdir+0xa0>
    end_op();
    return -1;
  }
  ilock(ip);
8010536d:	83 ec 0c             	sub    $0xc,%esp
80105370:	50                   	push   %eax
80105371:	e8 aa c3 ff ff       	call   80101720 <ilock>
  if(ip->type != T_DIR){
80105376:	83 c4 10             	add    $0x10,%esp
80105379:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
8010537e:	75 30                	jne    801053b0 <sys_chdir+0x80>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105380:	83 ec 0c             	sub    $0xc,%esp
80105383:	53                   	push   %ebx
80105384:	e8 77 c4 ff ff       	call   80101800 <iunlock>
  iput(curproc->cwd);
80105389:	58                   	pop    %eax
8010538a:	ff 76 68             	pushl  0x68(%esi)
8010538d:	e8 be c4 ff ff       	call   80101850 <iput>
  end_op();
80105392:	e8 c9 d9 ff ff       	call   80102d60 <end_op>
  curproc->cwd = ip;
80105397:	89 5e 68             	mov    %ebx,0x68(%esi)
  return 0;
8010539a:	83 c4 10             	add    $0x10,%esp
8010539d:	31 c0                	xor    %eax,%eax
}
8010539f:	8d 65 f8             	lea    -0x8(%ebp),%esp
801053a2:	5b                   	pop    %ebx
801053a3:	5e                   	pop    %esi
801053a4:	5d                   	pop    %ebp
801053a5:	c3                   	ret    
801053a6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801053ad:	8d 76 00             	lea    0x0(%esi),%esi
    iunlockput(ip);
801053b0:	83 ec 0c             	sub    $0xc,%esp
801053b3:	53                   	push   %ebx
801053b4:	e8 f7 c5 ff ff       	call   801019b0 <iunlockput>
    end_op();
801053b9:	e8 a2 d9 ff ff       	call   80102d60 <end_op>
    return -1;
801053be:	83 c4 10             	add    $0x10,%esp
801053c1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801053c6:	eb d7                	jmp    8010539f <sys_chdir+0x6f>
801053c8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801053cf:	90                   	nop
    end_op();
801053d0:	e8 8b d9 ff ff       	call   80102d60 <end_op>
    return -1;
801053d5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801053da:	eb c3                	jmp    8010539f <sys_chdir+0x6f>
801053dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801053e0 <sys_exec>:

int
sys_exec(void)
{
801053e0:	55                   	push   %ebp
801053e1:	89 e5                	mov    %esp,%ebp
801053e3:	57                   	push   %edi
801053e4:	56                   	push   %esi
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
801053e5:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
{
801053eb:	53                   	push   %ebx
801053ec:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
801053f2:	50                   	push   %eax
801053f3:	6a 00                	push   $0x0
801053f5:	e8 56 f5 ff ff       	call   80104950 <argstr>
801053fa:	83 c4 10             	add    $0x10,%esp
801053fd:	85 c0                	test   %eax,%eax
801053ff:	0f 88 87 00 00 00    	js     8010548c <sys_exec+0xac>
80105405:	83 ec 08             	sub    $0x8,%esp
80105408:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
8010540e:	50                   	push   %eax
8010540f:	6a 01                	push   $0x1
80105411:	e8 8a f4 ff ff       	call   801048a0 <argint>
80105416:	83 c4 10             	add    $0x10,%esp
80105419:	85 c0                	test   %eax,%eax
8010541b:	78 6f                	js     8010548c <sys_exec+0xac>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
8010541d:	83 ec 04             	sub    $0x4,%esp
80105420:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
  for(i=0;; i++){
80105426:	31 db                	xor    %ebx,%ebx
  memset(argv, 0, sizeof(argv));
80105428:	68 80 00 00 00       	push   $0x80
8010542d:	8d bd 64 ff ff ff    	lea    -0x9c(%ebp),%edi
80105433:	6a 00                	push   $0x0
80105435:	50                   	push   %eax
80105436:	e8 85 f1 ff ff       	call   801045c0 <memset>
8010543b:	83 c4 10             	add    $0x10,%esp
8010543e:	66 90                	xchg   %ax,%ax
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
80105440:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
80105446:	8d 34 9d 00 00 00 00 	lea    0x0(,%ebx,4),%esi
8010544d:	83 ec 08             	sub    $0x8,%esp
80105450:	57                   	push   %edi
80105451:	01 f0                	add    %esi,%eax
80105453:	50                   	push   %eax
80105454:	e8 a7 f3 ff ff       	call   80104800 <fetchint>
80105459:	83 c4 10             	add    $0x10,%esp
8010545c:	85 c0                	test   %eax,%eax
8010545e:	78 2c                	js     8010548c <sys_exec+0xac>
      return -1;
    if(uarg == 0){
80105460:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
80105466:	85 c0                	test   %eax,%eax
80105468:	74 36                	je     801054a0 <sys_exec+0xc0>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
8010546a:	8d 8d 68 ff ff ff    	lea    -0x98(%ebp),%ecx
80105470:	83 ec 08             	sub    $0x8,%esp
80105473:	8d 14 31             	lea    (%ecx,%esi,1),%edx
80105476:	52                   	push   %edx
80105477:	50                   	push   %eax
80105478:	e8 c3 f3 ff ff       	call   80104840 <fetchstr>
8010547d:	83 c4 10             	add    $0x10,%esp
80105480:	85 c0                	test   %eax,%eax
80105482:	78 08                	js     8010548c <sys_exec+0xac>
  for(i=0;; i++){
80105484:	83 c3 01             	add    $0x1,%ebx
    if(i >= NELEM(argv))
80105487:	83 fb 20             	cmp    $0x20,%ebx
8010548a:	75 b4                	jne    80105440 <sys_exec+0x60>
      return -1;
  }
  return exec(path, argv);
}
8010548c:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
8010548f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105494:	5b                   	pop    %ebx
80105495:	5e                   	pop    %esi
80105496:	5f                   	pop    %edi
80105497:	5d                   	pop    %ebp
80105498:	c3                   	ret    
80105499:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return exec(path, argv);
801054a0:	83 ec 08             	sub    $0x8,%esp
801054a3:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
      argv[i] = 0;
801054a9:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
801054b0:	00 00 00 00 
  return exec(path, argv);
801054b4:	50                   	push   %eax
801054b5:	ff b5 5c ff ff ff    	pushl  -0xa4(%ebp)
801054bb:	e8 c0 b5 ff ff       	call   80100a80 <exec>
801054c0:	83 c4 10             	add    $0x10,%esp
}
801054c3:	8d 65 f4             	lea    -0xc(%ebp),%esp
801054c6:	5b                   	pop    %ebx
801054c7:	5e                   	pop    %esi
801054c8:	5f                   	pop    %edi
801054c9:	5d                   	pop    %ebp
801054ca:	c3                   	ret    
801054cb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801054cf:	90                   	nop

801054d0 <sys_pipe>:

int
sys_pipe(void)
{
801054d0:	55                   	push   %ebp
801054d1:	89 e5                	mov    %esp,%ebp
801054d3:	57                   	push   %edi
801054d4:	56                   	push   %esi
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
801054d5:	8d 45 dc             	lea    -0x24(%ebp),%eax
{
801054d8:	53                   	push   %ebx
801054d9:	83 ec 20             	sub    $0x20,%esp
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
801054dc:	6a 08                	push   $0x8
801054de:	50                   	push   %eax
801054df:	6a 00                	push   $0x0
801054e1:	e8 0a f4 ff ff       	call   801048f0 <argptr>
801054e6:	83 c4 10             	add    $0x10,%esp
801054e9:	85 c0                	test   %eax,%eax
801054eb:	78 4a                	js     80105537 <sys_pipe+0x67>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
801054ed:	83 ec 08             	sub    $0x8,%esp
801054f0:	8d 45 e4             	lea    -0x1c(%ebp),%eax
801054f3:	50                   	push   %eax
801054f4:	8d 45 e0             	lea    -0x20(%ebp),%eax
801054f7:	50                   	push   %eax
801054f8:	e8 a3 de ff ff       	call   801033a0 <pipealloc>
801054fd:	83 c4 10             	add    $0x10,%esp
80105500:	85 c0                	test   %eax,%eax
80105502:	78 33                	js     80105537 <sys_pipe+0x67>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105504:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(fd = 0; fd < NOFILE; fd++){
80105507:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
80105509:	e8 22 e4 ff ff       	call   80103930 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
8010550e:	66 90                	xchg   %ax,%ax
    if(curproc->ofile[fd] == 0){
80105510:	8b 74 98 28          	mov    0x28(%eax,%ebx,4),%esi
80105514:	85 f6                	test   %esi,%esi
80105516:	74 28                	je     80105540 <sys_pipe+0x70>
  for(fd = 0; fd < NOFILE; fd++){
80105518:	83 c3 01             	add    $0x1,%ebx
8010551b:	83 fb 10             	cmp    $0x10,%ebx
8010551e:	75 f0                	jne    80105510 <sys_pipe+0x40>
    if(fd0 >= 0)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
80105520:	83 ec 0c             	sub    $0xc,%esp
80105523:	ff 75 e0             	pushl  -0x20(%ebp)
80105526:	e8 95 b9 ff ff       	call   80100ec0 <fileclose>
    fileclose(wf);
8010552b:	58                   	pop    %eax
8010552c:	ff 75 e4             	pushl  -0x1c(%ebp)
8010552f:	e8 8c b9 ff ff       	call   80100ec0 <fileclose>
    return -1;
80105534:	83 c4 10             	add    $0x10,%esp
80105537:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010553c:	eb 53                	jmp    80105591 <sys_pipe+0xc1>
8010553e:	66 90                	xchg   %ax,%ax
      curproc->ofile[fd] = f;
80105540:	8d 73 08             	lea    0x8(%ebx),%esi
80105543:	89 7c b0 08          	mov    %edi,0x8(%eax,%esi,4)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105547:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  struct proc *curproc = myproc();
8010554a:	e8 e1 e3 ff ff       	call   80103930 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
8010554f:	31 d2                	xor    %edx,%edx
80105551:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd] == 0){
80105558:	8b 4c 90 28          	mov    0x28(%eax,%edx,4),%ecx
8010555c:	85 c9                	test   %ecx,%ecx
8010555e:	74 20                	je     80105580 <sys_pipe+0xb0>
  for(fd = 0; fd < NOFILE; fd++){
80105560:	83 c2 01             	add    $0x1,%edx
80105563:	83 fa 10             	cmp    $0x10,%edx
80105566:	75 f0                	jne    80105558 <sys_pipe+0x88>
      myproc()->ofile[fd0] = 0;
80105568:	e8 c3 e3 ff ff       	call   80103930 <myproc>
8010556d:	c7 44 b0 08 00 00 00 	movl   $0x0,0x8(%eax,%esi,4)
80105574:	00 
80105575:	eb a9                	jmp    80105520 <sys_pipe+0x50>
80105577:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010557e:	66 90                	xchg   %ax,%ax
      curproc->ofile[fd] = f;
80105580:	89 7c 90 28          	mov    %edi,0x28(%eax,%edx,4)
  }
  fd[0] = fd0;
80105584:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105587:	89 18                	mov    %ebx,(%eax)
  fd[1] = fd1;
80105589:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010558c:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
8010558f:	31 c0                	xor    %eax,%eax
}
80105591:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105594:	5b                   	pop    %ebx
80105595:	5e                   	pop    %esi
80105596:	5f                   	pop    %edi
80105597:	5d                   	pop    %ebp
80105598:	c3                   	ret    
80105599:	66 90                	xchg   %ax,%ax
8010559b:	66 90                	xchg   %ax,%ax
8010559d:	66 90                	xchg   %ax,%ax
8010559f:	90                   	nop

801055a0 <sys_fork>:
#include "proc.h"

int
sys_fork(void)
{
  return fork();
801055a0:	e9 2b e5 ff ff       	jmp    80103ad0 <fork>
801055a5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801055ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801055b0 <sys_exit>:
}

int
sys_exit(void)
{
801055b0:	55                   	push   %ebp
801055b1:	89 e5                	mov    %esp,%ebp
801055b3:	83 ec 08             	sub    $0x8,%esp
  exit();
801055b6:	e8 95 e7 ff ff       	call   80103d50 <exit>
  return 0;  // not reached
}
801055bb:	31 c0                	xor    %eax,%eax
801055bd:	c9                   	leave  
801055be:	c3                   	ret    
801055bf:	90                   	nop

801055c0 <sys_wait>:

int
sys_wait(void)
{
  return wait();
801055c0:	e9 cb e9 ff ff       	jmp    80103f90 <wait>
801055c5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801055cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801055d0 <sys_kill>:
}

int
sys_kill(void)
{
801055d0:	55                   	push   %ebp
801055d1:	89 e5                	mov    %esp,%ebp
801055d3:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if(argint(0, &pid) < 0)
801055d6:	8d 45 f4             	lea    -0xc(%ebp),%eax
801055d9:	50                   	push   %eax
801055da:	6a 00                	push   $0x0
801055dc:	e8 bf f2 ff ff       	call   801048a0 <argint>
801055e1:	83 c4 10             	add    $0x10,%esp
801055e4:	85 c0                	test   %eax,%eax
801055e6:	78 18                	js     80105600 <sys_kill+0x30>
    return -1;
  return kill(pid);
801055e8:	83 ec 0c             	sub    $0xc,%esp
801055eb:	ff 75 f4             	pushl  -0xc(%ebp)
801055ee:	e8 ed ea ff ff       	call   801040e0 <kill>
801055f3:	83 c4 10             	add    $0x10,%esp
}
801055f6:	c9                   	leave  
801055f7:	c3                   	ret    
801055f8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801055ff:	90                   	nop
80105600:	c9                   	leave  
    return -1;
80105601:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105606:	c3                   	ret    
80105607:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010560e:	66 90                	xchg   %ax,%ax

80105610 <sys_getpid>:

int
sys_getpid(void)
{
80105610:	55                   	push   %ebp
80105611:	89 e5                	mov    %esp,%ebp
80105613:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
80105616:	e8 15 e3 ff ff       	call   80103930 <myproc>
8010561b:	8b 40 10             	mov    0x10(%eax),%eax
}
8010561e:	c9                   	leave  
8010561f:	c3                   	ret    

80105620 <sys_freemem>:

int
sys_freemem(void)
{  
  return freemem();
80105620:	e9 0b d0 ff ff       	jmp    80102630 <freemem>
80105625:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010562c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105630 <sys_sbrk>:
}

int
sys_sbrk(void)
{
80105630:	55                   	push   %ebp
80105631:	89 e5                	mov    %esp,%ebp
80105633:	53                   	push   %ebx
  int addr;
  int n;

  if(argint(0, &n) < 0)
80105634:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105637:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
8010563a:	50                   	push   %eax
8010563b:	6a 00                	push   $0x0
8010563d:	e8 5e f2 ff ff       	call   801048a0 <argint>
80105642:	83 c4 10             	add    $0x10,%esp
80105645:	85 c0                	test   %eax,%eax
80105647:	78 27                	js     80105670 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->sz;
80105649:	e8 e2 e2 ff ff       	call   80103930 <myproc>
  if(growproc(n) < 0)
8010564e:	83 ec 0c             	sub    $0xc,%esp
  addr = myproc()->sz;
80105651:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
80105653:	ff 75 f4             	pushl  -0xc(%ebp)
80105656:	e8 f5 e3 ff ff       	call   80103a50 <growproc>
8010565b:	83 c4 10             	add    $0x10,%esp
8010565e:	85 c0                	test   %eax,%eax
80105660:	78 0e                	js     80105670 <sys_sbrk+0x40>
    return -1;
  return addr;
}
80105662:	89 d8                	mov    %ebx,%eax
80105664:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105667:	c9                   	leave  
80105668:	c3                   	ret    
80105669:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105670:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105675:	eb eb                	jmp    80105662 <sys_sbrk+0x32>
80105677:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010567e:	66 90                	xchg   %ax,%ax

80105680 <sys_sleep>:

int
sys_sleep(void)
{
80105680:	55                   	push   %ebp
80105681:	89 e5                	mov    %esp,%ebp
80105683:	53                   	push   %ebx
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
80105684:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105687:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
8010568a:	50                   	push   %eax
8010568b:	6a 00                	push   $0x0
8010568d:	e8 0e f2 ff ff       	call   801048a0 <argint>
80105692:	83 c4 10             	add    $0x10,%esp
80105695:	85 c0                	test   %eax,%eax
80105697:	0f 88 8a 00 00 00    	js     80105727 <sys_sleep+0xa7>
    return -1;
  acquire(&tickslock);
8010569d:	83 ec 0c             	sub    $0xc,%esp
801056a0:	68 60 4c 11 80       	push   $0x80114c60
801056a5:	e8 06 ee ff ff       	call   801044b0 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
801056aa:	8b 55 f4             	mov    -0xc(%ebp),%edx
  ticks0 = ticks;
801056ad:	8b 1d a0 54 11 80    	mov    0x801154a0,%ebx
  while(ticks - ticks0 < n){
801056b3:	83 c4 10             	add    $0x10,%esp
801056b6:	85 d2                	test   %edx,%edx
801056b8:	75 27                	jne    801056e1 <sys_sleep+0x61>
801056ba:	eb 54                	jmp    80105710 <sys_sleep+0x90>
801056bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
801056c0:	83 ec 08             	sub    $0x8,%esp
801056c3:	68 60 4c 11 80       	push   $0x80114c60
801056c8:	68 a0 54 11 80       	push   $0x801154a0
801056cd:	e8 fe e7 ff ff       	call   80103ed0 <sleep>
  while(ticks - ticks0 < n){
801056d2:	a1 a0 54 11 80       	mov    0x801154a0,%eax
801056d7:	83 c4 10             	add    $0x10,%esp
801056da:	29 d8                	sub    %ebx,%eax
801056dc:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801056df:	73 2f                	jae    80105710 <sys_sleep+0x90>
    if(myproc()->killed){
801056e1:	e8 4a e2 ff ff       	call   80103930 <myproc>
801056e6:	8b 40 24             	mov    0x24(%eax),%eax
801056e9:	85 c0                	test   %eax,%eax
801056eb:	74 d3                	je     801056c0 <sys_sleep+0x40>
      release(&tickslock);
801056ed:	83 ec 0c             	sub    $0xc,%esp
801056f0:	68 60 4c 11 80       	push   $0x80114c60
801056f5:	e8 76 ee ff ff       	call   80104570 <release>
      return -1;
801056fa:	83 c4 10             	add    $0x10,%esp
801056fd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  release(&tickslock);
  return 0;
}
80105702:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105705:	c9                   	leave  
80105706:	c3                   	ret    
80105707:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010570e:	66 90                	xchg   %ax,%ax
  release(&tickslock);
80105710:	83 ec 0c             	sub    $0xc,%esp
80105713:	68 60 4c 11 80       	push   $0x80114c60
80105718:	e8 53 ee ff ff       	call   80104570 <release>
  return 0;
8010571d:	83 c4 10             	add    $0x10,%esp
80105720:	31 c0                	xor    %eax,%eax
}
80105722:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105725:	c9                   	leave  
80105726:	c3                   	ret    
    return -1;
80105727:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010572c:	eb f4                	jmp    80105722 <sys_sleep+0xa2>
8010572e:	66 90                	xchg   %ax,%ax

80105730 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80105730:	55                   	push   %ebp
80105731:	89 e5                	mov    %esp,%ebp
80105733:	53                   	push   %ebx
80105734:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
80105737:	68 60 4c 11 80       	push   $0x80114c60
8010573c:	e8 6f ed ff ff       	call   801044b0 <acquire>
  xticks = ticks;
80105741:	8b 1d a0 54 11 80    	mov    0x801154a0,%ebx
  release(&tickslock);
80105747:	c7 04 24 60 4c 11 80 	movl   $0x80114c60,(%esp)
8010574e:	e8 1d ee ff ff       	call   80104570 <release>
  return xticks;
}
80105753:	89 d8                	mov    %ebx,%eax
80105755:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105758:	c9                   	leave  
80105759:	c3                   	ret    

8010575a <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
8010575a:	1e                   	push   %ds
  pushl %es
8010575b:	06                   	push   %es
  pushl %fs
8010575c:	0f a0                	push   %fs
  pushl %gs
8010575e:	0f a8                	push   %gs
  pushal
80105760:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
80105761:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80105765:	8e d8                	mov    %eax,%ds
  movw %ax, %es
80105767:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
80105769:	54                   	push   %esp
  call trap
8010576a:	e8 c1 00 00 00       	call   80105830 <trap>
  addl $4, %esp
8010576f:	83 c4 04             	add    $0x4,%esp

80105772 <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
80105772:	61                   	popa   
  popl %gs
80105773:	0f a9                	pop    %gs
  popl %fs
80105775:	0f a1                	pop    %fs
  popl %es
80105777:	07                   	pop    %es
  popl %ds
80105778:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
80105779:	83 c4 08             	add    $0x8,%esp
  iret
8010577c:	cf                   	iret   
8010577d:	66 90                	xchg   %ax,%ax
8010577f:	90                   	nop

80105780 <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80105780:	55                   	push   %ebp
  int i;

  for(i = 0; i < 256; i++)
80105781:	31 c0                	xor    %eax,%eax
{
80105783:	89 e5                	mov    %esp,%ebp
80105785:	83 ec 08             	sub    $0x8,%esp
80105788:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010578f:	90                   	nop
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80105790:	8b 14 85 08 a0 10 80 	mov    -0x7fef5ff8(,%eax,4),%edx
80105797:	c7 04 c5 a2 4c 11 80 	movl   $0x8e000008,-0x7feeb35e(,%eax,8)
8010579e:	08 00 00 8e 
801057a2:	66 89 14 c5 a0 4c 11 	mov    %dx,-0x7feeb360(,%eax,8)
801057a9:	80 
801057aa:	c1 ea 10             	shr    $0x10,%edx
801057ad:	66 89 14 c5 a6 4c 11 	mov    %dx,-0x7feeb35a(,%eax,8)
801057b4:	80 
  for(i = 0; i < 256; i++)
801057b5:	83 c0 01             	add    $0x1,%eax
801057b8:	3d 00 01 00 00       	cmp    $0x100,%eax
801057bd:	75 d1                	jne    80105790 <tvinit+0x10>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);

  initlock(&tickslock, "time");
801057bf:	83 ec 08             	sub    $0x8,%esp
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
801057c2:	a1 08 a1 10 80       	mov    0x8010a108,%eax
801057c7:	c7 05 a2 4e 11 80 08 	movl   $0xef000008,0x80114ea2
801057ce:	00 00 ef 
  initlock(&tickslock, "time");
801057d1:	68 7d 77 10 80       	push   $0x8010777d
801057d6:	68 60 4c 11 80       	push   $0x80114c60
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
801057db:	66 a3 a0 4e 11 80    	mov    %ax,0x80114ea0
801057e1:	c1 e8 10             	shr    $0x10,%eax
801057e4:	66 a3 a6 4e 11 80    	mov    %ax,0x80114ea6
  initlock(&tickslock, "time");
801057ea:	e8 61 eb ff ff       	call   80104350 <initlock>
}
801057ef:	83 c4 10             	add    $0x10,%esp
801057f2:	c9                   	leave  
801057f3:	c3                   	ret    
801057f4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801057fb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801057ff:	90                   	nop

80105800 <idtinit>:

void
idtinit(void)
{
80105800:	55                   	push   %ebp
  pd[0] = size-1;
80105801:	b8 ff 07 00 00       	mov    $0x7ff,%eax
80105806:	89 e5                	mov    %esp,%ebp
80105808:	83 ec 10             	sub    $0x10,%esp
8010580b:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
8010580f:	b8 a0 4c 11 80       	mov    $0x80114ca0,%eax
80105814:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80105818:	c1 e8 10             	shr    $0x10,%eax
8010581b:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
8010581f:	8d 45 fa             	lea    -0x6(%ebp),%eax
80105822:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
80105825:	c9                   	leave  
80105826:	c3                   	ret    
80105827:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010582e:	66 90                	xchg   %ax,%ax

80105830 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80105830:	55                   	push   %ebp
80105831:	89 e5                	mov    %esp,%ebp
80105833:	57                   	push   %edi
80105834:	56                   	push   %esi
80105835:	53                   	push   %ebx
80105836:	83 ec 1c             	sub    $0x1c,%esp
80105839:	8b 7d 08             	mov    0x8(%ebp),%edi
  if(tf->trapno == T_SYSCALL){
8010583c:	8b 47 30             	mov    0x30(%edi),%eax
8010583f:	83 f8 40             	cmp    $0x40,%eax
80105842:	0f 84 b8 01 00 00    	je     80105a00 <trap+0x1d0>
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
80105848:	83 e8 20             	sub    $0x20,%eax
8010584b:	83 f8 1f             	cmp    $0x1f,%eax
8010584e:	77 10                	ja     80105860 <trap+0x30>
80105850:	ff 24 85 24 78 10 80 	jmp    *-0x7fef87dc(,%eax,4)
80105857:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010585e:	66 90                	xchg   %ax,%ax
    lapiceoi();
    break;

  //PAGEBREAK: 13
  default:
    if(myproc() == 0 || (tf->cs&3) == 0){
80105860:	e8 cb e0 ff ff       	call   80103930 <myproc>
80105865:	8b 5f 38             	mov    0x38(%edi),%ebx
80105868:	85 c0                	test   %eax,%eax
8010586a:	0f 84 17 02 00 00    	je     80105a87 <trap+0x257>
80105870:	f6 47 3c 03          	testb  $0x3,0x3c(%edi)
80105874:	0f 84 0d 02 00 00    	je     80105a87 <trap+0x257>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
8010587a:	0f 20 d1             	mov    %cr2,%ecx
8010587d:	89 4d d8             	mov    %ecx,-0x28(%ebp)
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105880:	e8 8b e0 ff ff       	call   80103910 <cpuid>
80105885:	8b 77 30             	mov    0x30(%edi),%esi
80105888:	89 45 dc             	mov    %eax,-0x24(%ebp)
8010588b:	8b 47 34             	mov    0x34(%edi),%eax
8010588e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
80105891:	e8 9a e0 ff ff       	call   80103930 <myproc>
80105896:	89 45 e0             	mov    %eax,-0x20(%ebp)
80105899:	e8 92 e0 ff ff       	call   80103930 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
8010589e:	8b 4d d8             	mov    -0x28(%ebp),%ecx
801058a1:	8b 55 dc             	mov    -0x24(%ebp),%edx
801058a4:	51                   	push   %ecx
801058a5:	53                   	push   %ebx
801058a6:	52                   	push   %edx
            myproc()->pid, myproc()->name, tf->trapno,
801058a7:	8b 55 e0             	mov    -0x20(%ebp),%edx
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801058aa:	ff 75 e4             	pushl  -0x1c(%ebp)
            myproc()->pid, myproc()->name, tf->trapno,
801058ad:	83 c2 6c             	add    $0x6c,%edx
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801058b0:	56                   	push   %esi
801058b1:	52                   	push   %edx
801058b2:	ff 70 10             	pushl  0x10(%eax)
801058b5:	68 e0 77 10 80       	push   $0x801077e0
801058ba:	e8 f1 ad ff ff       	call   801006b0 <cprintf>
            tf->err, cpuid(), tf->eip, rcr2());
    myproc()->killed = 1;
801058bf:	83 c4 20             	add    $0x20,%esp
801058c2:	e8 69 e0 ff ff       	call   80103930 <myproc>
801058c7:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801058ce:	e8 5d e0 ff ff       	call   80103930 <myproc>
801058d3:	85 c0                	test   %eax,%eax
801058d5:	74 1d                	je     801058f4 <trap+0xc4>
801058d7:	e8 54 e0 ff ff       	call   80103930 <myproc>
801058dc:	8b 50 24             	mov    0x24(%eax),%edx
801058df:	85 d2                	test   %edx,%edx
801058e1:	74 11                	je     801058f4 <trap+0xc4>
801058e3:	0f b7 47 3c          	movzwl 0x3c(%edi),%eax
801058e7:	83 e0 03             	and    $0x3,%eax
801058ea:	66 83 f8 03          	cmp    $0x3,%ax
801058ee:	0f 84 44 01 00 00    	je     80105a38 <trap+0x208>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
801058f4:	e8 37 e0 ff ff       	call   80103930 <myproc>
801058f9:	85 c0                	test   %eax,%eax
801058fb:	74 0b                	je     80105908 <trap+0xd8>
801058fd:	e8 2e e0 ff ff       	call   80103930 <myproc>
80105902:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
80105906:	74 38                	je     80105940 <trap+0x110>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105908:	e8 23 e0 ff ff       	call   80103930 <myproc>
8010590d:	85 c0                	test   %eax,%eax
8010590f:	74 1d                	je     8010592e <trap+0xfe>
80105911:	e8 1a e0 ff ff       	call   80103930 <myproc>
80105916:	8b 40 24             	mov    0x24(%eax),%eax
80105919:	85 c0                	test   %eax,%eax
8010591b:	74 11                	je     8010592e <trap+0xfe>
8010591d:	0f b7 47 3c          	movzwl 0x3c(%edi),%eax
80105921:	83 e0 03             	and    $0x3,%eax
80105924:	66 83 f8 03          	cmp    $0x3,%ax
80105928:	0f 84 fb 00 00 00    	je     80105a29 <trap+0x1f9>
    exit();
}
8010592e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105931:	5b                   	pop    %ebx
80105932:	5e                   	pop    %esi
80105933:	5f                   	pop    %edi
80105934:	5d                   	pop    %ebp
80105935:	c3                   	ret    
80105936:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010593d:	8d 76 00             	lea    0x0(%esi),%esi
  if(myproc() && myproc()->state == RUNNING &&
80105940:	83 7f 30 20          	cmpl   $0x20,0x30(%edi)
80105944:	75 c2                	jne    80105908 <trap+0xd8>
    yield();
80105946:	e8 35 e5 ff ff       	call   80103e80 <yield>
8010594b:	eb bb                	jmp    80105908 <trap+0xd8>
8010594d:	8d 76 00             	lea    0x0(%esi),%esi
    if(cpuid() == 0){
80105950:	e8 bb df ff ff       	call   80103910 <cpuid>
80105955:	85 c0                	test   %eax,%eax
80105957:	0f 84 eb 00 00 00    	je     80105a48 <trap+0x218>
    lapiceoi();
8010595d:	e8 3e cf ff ff       	call   801028a0 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105962:	e8 c9 df ff ff       	call   80103930 <myproc>
80105967:	85 c0                	test   %eax,%eax
80105969:	0f 85 68 ff ff ff    	jne    801058d7 <trap+0xa7>
8010596f:	eb 83                	jmp    801058f4 <trap+0xc4>
80105971:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kbdintr();
80105978:	e8 e3 cd ff ff       	call   80102760 <kbdintr>
    lapiceoi();
8010597d:	e8 1e cf ff ff       	call   801028a0 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105982:	e8 a9 df ff ff       	call   80103930 <myproc>
80105987:	85 c0                	test   %eax,%eax
80105989:	0f 85 48 ff ff ff    	jne    801058d7 <trap+0xa7>
8010598f:	e9 60 ff ff ff       	jmp    801058f4 <trap+0xc4>
80105994:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    uartintr();
80105998:	e8 83 02 00 00       	call   80105c20 <uartintr>
    lapiceoi();
8010599d:	e8 fe ce ff ff       	call   801028a0 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801059a2:	e8 89 df ff ff       	call   80103930 <myproc>
801059a7:	85 c0                	test   %eax,%eax
801059a9:	0f 85 28 ff ff ff    	jne    801058d7 <trap+0xa7>
801059af:	e9 40 ff ff ff       	jmp    801058f4 <trap+0xc4>
801059b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
801059b8:	8b 77 38             	mov    0x38(%edi),%esi
801059bb:	0f b7 5f 3c          	movzwl 0x3c(%edi),%ebx
801059bf:	e8 4c df ff ff       	call   80103910 <cpuid>
801059c4:	56                   	push   %esi
801059c5:	53                   	push   %ebx
801059c6:	50                   	push   %eax
801059c7:	68 88 77 10 80       	push   $0x80107788
801059cc:	e8 df ac ff ff       	call   801006b0 <cprintf>
    lapiceoi();
801059d1:	e8 ca ce ff ff       	call   801028a0 <lapiceoi>
    break;
801059d6:	83 c4 10             	add    $0x10,%esp
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801059d9:	e8 52 df ff ff       	call   80103930 <myproc>
801059de:	85 c0                	test   %eax,%eax
801059e0:	0f 85 f1 fe ff ff    	jne    801058d7 <trap+0xa7>
801059e6:	e9 09 ff ff ff       	jmp    801058f4 <trap+0xc4>
801059eb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801059ef:	90                   	nop
    ideintr();
801059f0:	e8 6b c7 ff ff       	call   80102160 <ideintr>
801059f5:	e9 63 ff ff ff       	jmp    8010595d <trap+0x12d>
801059fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(myproc()->killed)
80105a00:	e8 2b df ff ff       	call   80103930 <myproc>
80105a05:	8b 58 24             	mov    0x24(%eax),%ebx
80105a08:	85 db                	test   %ebx,%ebx
80105a0a:	75 74                	jne    80105a80 <trap+0x250>
    myproc()->tf = tf;
80105a0c:	e8 1f df ff ff       	call   80103930 <myproc>
80105a11:	89 78 18             	mov    %edi,0x18(%eax)
    syscall();
80105a14:	e8 77 ef ff ff       	call   80104990 <syscall>
    if(myproc()->killed)
80105a19:	e8 12 df ff ff       	call   80103930 <myproc>
80105a1e:	8b 48 24             	mov    0x24(%eax),%ecx
80105a21:	85 c9                	test   %ecx,%ecx
80105a23:	0f 84 05 ff ff ff    	je     8010592e <trap+0xfe>
}
80105a29:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105a2c:	5b                   	pop    %ebx
80105a2d:	5e                   	pop    %esi
80105a2e:	5f                   	pop    %edi
80105a2f:	5d                   	pop    %ebp
      exit();
80105a30:	e9 1b e3 ff ff       	jmp    80103d50 <exit>
80105a35:	8d 76 00             	lea    0x0(%esi),%esi
    exit();
80105a38:	e8 13 e3 ff ff       	call   80103d50 <exit>
80105a3d:	e9 b2 fe ff ff       	jmp    801058f4 <trap+0xc4>
80105a42:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      acquire(&tickslock);
80105a48:	83 ec 0c             	sub    $0xc,%esp
80105a4b:	68 60 4c 11 80       	push   $0x80114c60
80105a50:	e8 5b ea ff ff       	call   801044b0 <acquire>
      wakeup(&ticks);
80105a55:	c7 04 24 a0 54 11 80 	movl   $0x801154a0,(%esp)
      ticks++;
80105a5c:	83 05 a0 54 11 80 01 	addl   $0x1,0x801154a0
      wakeup(&ticks);
80105a63:	e8 18 e6 ff ff       	call   80104080 <wakeup>
      release(&tickslock);
80105a68:	c7 04 24 60 4c 11 80 	movl   $0x80114c60,(%esp)
80105a6f:	e8 fc ea ff ff       	call   80104570 <release>
80105a74:	83 c4 10             	add    $0x10,%esp
    lapiceoi();
80105a77:	e9 e1 fe ff ff       	jmp    8010595d <trap+0x12d>
80105a7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      exit();
80105a80:	e8 cb e2 ff ff       	call   80103d50 <exit>
80105a85:	eb 85                	jmp    80105a0c <trap+0x1dc>
80105a87:	0f 20 d6             	mov    %cr2,%esi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80105a8a:	e8 81 de ff ff       	call   80103910 <cpuid>
80105a8f:	83 ec 0c             	sub    $0xc,%esp
80105a92:	56                   	push   %esi
80105a93:	53                   	push   %ebx
80105a94:	50                   	push   %eax
80105a95:	ff 77 30             	pushl  0x30(%edi)
80105a98:	68 ac 77 10 80       	push   $0x801077ac
80105a9d:	e8 0e ac ff ff       	call   801006b0 <cprintf>
      panic("trap");
80105aa2:	83 c4 14             	add    $0x14,%esp
80105aa5:	68 82 77 10 80       	push   $0x80107782
80105aaa:	e8 e1 a8 ff ff       	call   80100390 <panic>
80105aaf:	90                   	nop

80105ab0 <uartgetc>:
}

static int
uartgetc(void)
{
  if(!uart)
80105ab0:	a1 bc a5 10 80       	mov    0x8010a5bc,%eax
80105ab5:	85 c0                	test   %eax,%eax
80105ab7:	74 17                	je     80105ad0 <uartgetc+0x20>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105ab9:	ba fd 03 00 00       	mov    $0x3fd,%edx
80105abe:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
80105abf:	a8 01                	test   $0x1,%al
80105ac1:	74 0d                	je     80105ad0 <uartgetc+0x20>
80105ac3:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105ac8:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
80105ac9:	0f b6 c0             	movzbl %al,%eax
80105acc:	c3                   	ret    
80105acd:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80105ad0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105ad5:	c3                   	ret    
80105ad6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105add:	8d 76 00             	lea    0x0(%esi),%esi

80105ae0 <uartputc.part.0>:
uartputc(int c)
80105ae0:	55                   	push   %ebp
80105ae1:	89 e5                	mov    %esp,%ebp
80105ae3:	57                   	push   %edi
80105ae4:	89 c7                	mov    %eax,%edi
80105ae6:	56                   	push   %esi
80105ae7:	be fd 03 00 00       	mov    $0x3fd,%esi
80105aec:	53                   	push   %ebx
80105aed:	bb 80 00 00 00       	mov    $0x80,%ebx
80105af2:	83 ec 0c             	sub    $0xc,%esp
80105af5:	eb 1b                	jmp    80105b12 <uartputc.part.0+0x32>
80105af7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105afe:	66 90                	xchg   %ax,%ax
    microdelay(10);
80105b00:	83 ec 0c             	sub    $0xc,%esp
80105b03:	6a 0a                	push   $0xa
80105b05:	e8 b6 cd ff ff       	call   801028c0 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80105b0a:	83 c4 10             	add    $0x10,%esp
80105b0d:	83 eb 01             	sub    $0x1,%ebx
80105b10:	74 07                	je     80105b19 <uartputc.part.0+0x39>
80105b12:	89 f2                	mov    %esi,%edx
80105b14:	ec                   	in     (%dx),%al
80105b15:	a8 20                	test   $0x20,%al
80105b17:	74 e7                	je     80105b00 <uartputc.part.0+0x20>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80105b19:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105b1e:	89 f8                	mov    %edi,%eax
80105b20:	ee                   	out    %al,(%dx)
}
80105b21:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105b24:	5b                   	pop    %ebx
80105b25:	5e                   	pop    %esi
80105b26:	5f                   	pop    %edi
80105b27:	5d                   	pop    %ebp
80105b28:	c3                   	ret    
80105b29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105b30 <uartinit>:
{
80105b30:	55                   	push   %ebp
80105b31:	31 c9                	xor    %ecx,%ecx
80105b33:	89 c8                	mov    %ecx,%eax
80105b35:	89 e5                	mov    %esp,%ebp
80105b37:	57                   	push   %edi
80105b38:	56                   	push   %esi
80105b39:	53                   	push   %ebx
80105b3a:	bb fa 03 00 00       	mov    $0x3fa,%ebx
80105b3f:	89 da                	mov    %ebx,%edx
80105b41:	83 ec 0c             	sub    $0xc,%esp
80105b44:	ee                   	out    %al,(%dx)
80105b45:	bf fb 03 00 00       	mov    $0x3fb,%edi
80105b4a:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
80105b4f:	89 fa                	mov    %edi,%edx
80105b51:	ee                   	out    %al,(%dx)
80105b52:	b8 0c 00 00 00       	mov    $0xc,%eax
80105b57:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105b5c:	ee                   	out    %al,(%dx)
80105b5d:	be f9 03 00 00       	mov    $0x3f9,%esi
80105b62:	89 c8                	mov    %ecx,%eax
80105b64:	89 f2                	mov    %esi,%edx
80105b66:	ee                   	out    %al,(%dx)
80105b67:	b8 03 00 00 00       	mov    $0x3,%eax
80105b6c:	89 fa                	mov    %edi,%edx
80105b6e:	ee                   	out    %al,(%dx)
80105b6f:	ba fc 03 00 00       	mov    $0x3fc,%edx
80105b74:	89 c8                	mov    %ecx,%eax
80105b76:	ee                   	out    %al,(%dx)
80105b77:	b8 01 00 00 00       	mov    $0x1,%eax
80105b7c:	89 f2                	mov    %esi,%edx
80105b7e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105b7f:	ba fd 03 00 00       	mov    $0x3fd,%edx
80105b84:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
80105b85:	3c ff                	cmp    $0xff,%al
80105b87:	74 56                	je     80105bdf <uartinit+0xaf>
  uart = 1;
80105b89:	c7 05 bc a5 10 80 01 	movl   $0x1,0x8010a5bc
80105b90:	00 00 00 
80105b93:	89 da                	mov    %ebx,%edx
80105b95:	ec                   	in     (%dx),%al
80105b96:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105b9b:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
80105b9c:	83 ec 08             	sub    $0x8,%esp
80105b9f:	be 76 00 00 00       	mov    $0x76,%esi
  for(p="xv6...\n"; *p; p++)
80105ba4:	bb a4 78 10 80       	mov    $0x801078a4,%ebx
  ioapicenable(IRQ_COM1, 0);
80105ba9:	6a 00                	push   $0x0
80105bab:	6a 04                	push   $0x4
80105bad:	e8 fe c7 ff ff       	call   801023b0 <ioapicenable>
80105bb2:	83 c4 10             	add    $0x10,%esp
  for(p="xv6...\n"; *p; p++)
80105bb5:	b8 78 00 00 00       	mov    $0x78,%eax
80105bba:	eb 08                	jmp    80105bc4 <uartinit+0x94>
80105bbc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105bc0:	0f b6 73 01          	movzbl 0x1(%ebx),%esi
  if(!uart)
80105bc4:	8b 15 bc a5 10 80    	mov    0x8010a5bc,%edx
80105bca:	85 d2                	test   %edx,%edx
80105bcc:	74 08                	je     80105bd6 <uartinit+0xa6>
    uartputc(*p);
80105bce:	0f be c0             	movsbl %al,%eax
80105bd1:	e8 0a ff ff ff       	call   80105ae0 <uartputc.part.0>
  for(p="xv6...\n"; *p; p++)
80105bd6:	89 f0                	mov    %esi,%eax
80105bd8:	83 c3 01             	add    $0x1,%ebx
80105bdb:	84 c0                	test   %al,%al
80105bdd:	75 e1                	jne    80105bc0 <uartinit+0x90>
}
80105bdf:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105be2:	5b                   	pop    %ebx
80105be3:	5e                   	pop    %esi
80105be4:	5f                   	pop    %edi
80105be5:	5d                   	pop    %ebp
80105be6:	c3                   	ret    
80105be7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105bee:	66 90                	xchg   %ax,%ax

80105bf0 <uartputc>:
{
80105bf0:	55                   	push   %ebp
  if(!uart)
80105bf1:	8b 15 bc a5 10 80    	mov    0x8010a5bc,%edx
{
80105bf7:	89 e5                	mov    %esp,%ebp
80105bf9:	8b 45 08             	mov    0x8(%ebp),%eax
  if(!uart)
80105bfc:	85 d2                	test   %edx,%edx
80105bfe:	74 10                	je     80105c10 <uartputc+0x20>
}
80105c00:	5d                   	pop    %ebp
80105c01:	e9 da fe ff ff       	jmp    80105ae0 <uartputc.part.0>
80105c06:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105c0d:	8d 76 00             	lea    0x0(%esi),%esi
80105c10:	5d                   	pop    %ebp
80105c11:	c3                   	ret    
80105c12:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105c19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105c20 <uartintr>:

void
uartintr(void)
{
80105c20:	55                   	push   %ebp
80105c21:	89 e5                	mov    %esp,%ebp
80105c23:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
80105c26:	68 b0 5a 10 80       	push   $0x80105ab0
80105c2b:	e8 30 ac ff ff       	call   80100860 <consoleintr>
}
80105c30:	83 c4 10             	add    $0x10,%esp
80105c33:	c9                   	leave  
80105c34:	c3                   	ret    

80105c35 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80105c35:	6a 00                	push   $0x0
  pushl $0
80105c37:	6a 00                	push   $0x0
  jmp alltraps
80105c39:	e9 1c fb ff ff       	jmp    8010575a <alltraps>

80105c3e <vector1>:
.globl vector1
vector1:
  pushl $0
80105c3e:	6a 00                	push   $0x0
  pushl $1
80105c40:	6a 01                	push   $0x1
  jmp alltraps
80105c42:	e9 13 fb ff ff       	jmp    8010575a <alltraps>

80105c47 <vector2>:
.globl vector2
vector2:
  pushl $0
80105c47:	6a 00                	push   $0x0
  pushl $2
80105c49:	6a 02                	push   $0x2
  jmp alltraps
80105c4b:	e9 0a fb ff ff       	jmp    8010575a <alltraps>

80105c50 <vector3>:
.globl vector3
vector3:
  pushl $0
80105c50:	6a 00                	push   $0x0
  pushl $3
80105c52:	6a 03                	push   $0x3
  jmp alltraps
80105c54:	e9 01 fb ff ff       	jmp    8010575a <alltraps>

80105c59 <vector4>:
.globl vector4
vector4:
  pushl $0
80105c59:	6a 00                	push   $0x0
  pushl $4
80105c5b:	6a 04                	push   $0x4
  jmp alltraps
80105c5d:	e9 f8 fa ff ff       	jmp    8010575a <alltraps>

80105c62 <vector5>:
.globl vector5
vector5:
  pushl $0
80105c62:	6a 00                	push   $0x0
  pushl $5
80105c64:	6a 05                	push   $0x5
  jmp alltraps
80105c66:	e9 ef fa ff ff       	jmp    8010575a <alltraps>

80105c6b <vector6>:
.globl vector6
vector6:
  pushl $0
80105c6b:	6a 00                	push   $0x0
  pushl $6
80105c6d:	6a 06                	push   $0x6
  jmp alltraps
80105c6f:	e9 e6 fa ff ff       	jmp    8010575a <alltraps>

80105c74 <vector7>:
.globl vector7
vector7:
  pushl $0
80105c74:	6a 00                	push   $0x0
  pushl $7
80105c76:	6a 07                	push   $0x7
  jmp alltraps
80105c78:	e9 dd fa ff ff       	jmp    8010575a <alltraps>

80105c7d <vector8>:
.globl vector8
vector8:
  pushl $8
80105c7d:	6a 08                	push   $0x8
  jmp alltraps
80105c7f:	e9 d6 fa ff ff       	jmp    8010575a <alltraps>

80105c84 <vector9>:
.globl vector9
vector9:
  pushl $0
80105c84:	6a 00                	push   $0x0
  pushl $9
80105c86:	6a 09                	push   $0x9
  jmp alltraps
80105c88:	e9 cd fa ff ff       	jmp    8010575a <alltraps>

80105c8d <vector10>:
.globl vector10
vector10:
  pushl $10
80105c8d:	6a 0a                	push   $0xa
  jmp alltraps
80105c8f:	e9 c6 fa ff ff       	jmp    8010575a <alltraps>

80105c94 <vector11>:
.globl vector11
vector11:
  pushl $11
80105c94:	6a 0b                	push   $0xb
  jmp alltraps
80105c96:	e9 bf fa ff ff       	jmp    8010575a <alltraps>

80105c9b <vector12>:
.globl vector12
vector12:
  pushl $12
80105c9b:	6a 0c                	push   $0xc
  jmp alltraps
80105c9d:	e9 b8 fa ff ff       	jmp    8010575a <alltraps>

80105ca2 <vector13>:
.globl vector13
vector13:
  pushl $13
80105ca2:	6a 0d                	push   $0xd
  jmp alltraps
80105ca4:	e9 b1 fa ff ff       	jmp    8010575a <alltraps>

80105ca9 <vector14>:
.globl vector14
vector14:
  pushl $14
80105ca9:	6a 0e                	push   $0xe
  jmp alltraps
80105cab:	e9 aa fa ff ff       	jmp    8010575a <alltraps>

80105cb0 <vector15>:
.globl vector15
vector15:
  pushl $0
80105cb0:	6a 00                	push   $0x0
  pushl $15
80105cb2:	6a 0f                	push   $0xf
  jmp alltraps
80105cb4:	e9 a1 fa ff ff       	jmp    8010575a <alltraps>

80105cb9 <vector16>:
.globl vector16
vector16:
  pushl $0
80105cb9:	6a 00                	push   $0x0
  pushl $16
80105cbb:	6a 10                	push   $0x10
  jmp alltraps
80105cbd:	e9 98 fa ff ff       	jmp    8010575a <alltraps>

80105cc2 <vector17>:
.globl vector17
vector17:
  pushl $17
80105cc2:	6a 11                	push   $0x11
  jmp alltraps
80105cc4:	e9 91 fa ff ff       	jmp    8010575a <alltraps>

80105cc9 <vector18>:
.globl vector18
vector18:
  pushl $0
80105cc9:	6a 00                	push   $0x0
  pushl $18
80105ccb:	6a 12                	push   $0x12
  jmp alltraps
80105ccd:	e9 88 fa ff ff       	jmp    8010575a <alltraps>

80105cd2 <vector19>:
.globl vector19
vector19:
  pushl $0
80105cd2:	6a 00                	push   $0x0
  pushl $19
80105cd4:	6a 13                	push   $0x13
  jmp alltraps
80105cd6:	e9 7f fa ff ff       	jmp    8010575a <alltraps>

80105cdb <vector20>:
.globl vector20
vector20:
  pushl $0
80105cdb:	6a 00                	push   $0x0
  pushl $20
80105cdd:	6a 14                	push   $0x14
  jmp alltraps
80105cdf:	e9 76 fa ff ff       	jmp    8010575a <alltraps>

80105ce4 <vector21>:
.globl vector21
vector21:
  pushl $0
80105ce4:	6a 00                	push   $0x0
  pushl $21
80105ce6:	6a 15                	push   $0x15
  jmp alltraps
80105ce8:	e9 6d fa ff ff       	jmp    8010575a <alltraps>

80105ced <vector22>:
.globl vector22
vector22:
  pushl $0
80105ced:	6a 00                	push   $0x0
  pushl $22
80105cef:	6a 16                	push   $0x16
  jmp alltraps
80105cf1:	e9 64 fa ff ff       	jmp    8010575a <alltraps>

80105cf6 <vector23>:
.globl vector23
vector23:
  pushl $0
80105cf6:	6a 00                	push   $0x0
  pushl $23
80105cf8:	6a 17                	push   $0x17
  jmp alltraps
80105cfa:	e9 5b fa ff ff       	jmp    8010575a <alltraps>

80105cff <vector24>:
.globl vector24
vector24:
  pushl $0
80105cff:	6a 00                	push   $0x0
  pushl $24
80105d01:	6a 18                	push   $0x18
  jmp alltraps
80105d03:	e9 52 fa ff ff       	jmp    8010575a <alltraps>

80105d08 <vector25>:
.globl vector25
vector25:
  pushl $0
80105d08:	6a 00                	push   $0x0
  pushl $25
80105d0a:	6a 19                	push   $0x19
  jmp alltraps
80105d0c:	e9 49 fa ff ff       	jmp    8010575a <alltraps>

80105d11 <vector26>:
.globl vector26
vector26:
  pushl $0
80105d11:	6a 00                	push   $0x0
  pushl $26
80105d13:	6a 1a                	push   $0x1a
  jmp alltraps
80105d15:	e9 40 fa ff ff       	jmp    8010575a <alltraps>

80105d1a <vector27>:
.globl vector27
vector27:
  pushl $0
80105d1a:	6a 00                	push   $0x0
  pushl $27
80105d1c:	6a 1b                	push   $0x1b
  jmp alltraps
80105d1e:	e9 37 fa ff ff       	jmp    8010575a <alltraps>

80105d23 <vector28>:
.globl vector28
vector28:
  pushl $0
80105d23:	6a 00                	push   $0x0
  pushl $28
80105d25:	6a 1c                	push   $0x1c
  jmp alltraps
80105d27:	e9 2e fa ff ff       	jmp    8010575a <alltraps>

80105d2c <vector29>:
.globl vector29
vector29:
  pushl $0
80105d2c:	6a 00                	push   $0x0
  pushl $29
80105d2e:	6a 1d                	push   $0x1d
  jmp alltraps
80105d30:	e9 25 fa ff ff       	jmp    8010575a <alltraps>

80105d35 <vector30>:
.globl vector30
vector30:
  pushl $0
80105d35:	6a 00                	push   $0x0
  pushl $30
80105d37:	6a 1e                	push   $0x1e
  jmp alltraps
80105d39:	e9 1c fa ff ff       	jmp    8010575a <alltraps>

80105d3e <vector31>:
.globl vector31
vector31:
  pushl $0
80105d3e:	6a 00                	push   $0x0
  pushl $31
80105d40:	6a 1f                	push   $0x1f
  jmp alltraps
80105d42:	e9 13 fa ff ff       	jmp    8010575a <alltraps>

80105d47 <vector32>:
.globl vector32
vector32:
  pushl $0
80105d47:	6a 00                	push   $0x0
  pushl $32
80105d49:	6a 20                	push   $0x20
  jmp alltraps
80105d4b:	e9 0a fa ff ff       	jmp    8010575a <alltraps>

80105d50 <vector33>:
.globl vector33
vector33:
  pushl $0
80105d50:	6a 00                	push   $0x0
  pushl $33
80105d52:	6a 21                	push   $0x21
  jmp alltraps
80105d54:	e9 01 fa ff ff       	jmp    8010575a <alltraps>

80105d59 <vector34>:
.globl vector34
vector34:
  pushl $0
80105d59:	6a 00                	push   $0x0
  pushl $34
80105d5b:	6a 22                	push   $0x22
  jmp alltraps
80105d5d:	e9 f8 f9 ff ff       	jmp    8010575a <alltraps>

80105d62 <vector35>:
.globl vector35
vector35:
  pushl $0
80105d62:	6a 00                	push   $0x0
  pushl $35
80105d64:	6a 23                	push   $0x23
  jmp alltraps
80105d66:	e9 ef f9 ff ff       	jmp    8010575a <alltraps>

80105d6b <vector36>:
.globl vector36
vector36:
  pushl $0
80105d6b:	6a 00                	push   $0x0
  pushl $36
80105d6d:	6a 24                	push   $0x24
  jmp alltraps
80105d6f:	e9 e6 f9 ff ff       	jmp    8010575a <alltraps>

80105d74 <vector37>:
.globl vector37
vector37:
  pushl $0
80105d74:	6a 00                	push   $0x0
  pushl $37
80105d76:	6a 25                	push   $0x25
  jmp alltraps
80105d78:	e9 dd f9 ff ff       	jmp    8010575a <alltraps>

80105d7d <vector38>:
.globl vector38
vector38:
  pushl $0
80105d7d:	6a 00                	push   $0x0
  pushl $38
80105d7f:	6a 26                	push   $0x26
  jmp alltraps
80105d81:	e9 d4 f9 ff ff       	jmp    8010575a <alltraps>

80105d86 <vector39>:
.globl vector39
vector39:
  pushl $0
80105d86:	6a 00                	push   $0x0
  pushl $39
80105d88:	6a 27                	push   $0x27
  jmp alltraps
80105d8a:	e9 cb f9 ff ff       	jmp    8010575a <alltraps>

80105d8f <vector40>:
.globl vector40
vector40:
  pushl $0
80105d8f:	6a 00                	push   $0x0
  pushl $40
80105d91:	6a 28                	push   $0x28
  jmp alltraps
80105d93:	e9 c2 f9 ff ff       	jmp    8010575a <alltraps>

80105d98 <vector41>:
.globl vector41
vector41:
  pushl $0
80105d98:	6a 00                	push   $0x0
  pushl $41
80105d9a:	6a 29                	push   $0x29
  jmp alltraps
80105d9c:	e9 b9 f9 ff ff       	jmp    8010575a <alltraps>

80105da1 <vector42>:
.globl vector42
vector42:
  pushl $0
80105da1:	6a 00                	push   $0x0
  pushl $42
80105da3:	6a 2a                	push   $0x2a
  jmp alltraps
80105da5:	e9 b0 f9 ff ff       	jmp    8010575a <alltraps>

80105daa <vector43>:
.globl vector43
vector43:
  pushl $0
80105daa:	6a 00                	push   $0x0
  pushl $43
80105dac:	6a 2b                	push   $0x2b
  jmp alltraps
80105dae:	e9 a7 f9 ff ff       	jmp    8010575a <alltraps>

80105db3 <vector44>:
.globl vector44
vector44:
  pushl $0
80105db3:	6a 00                	push   $0x0
  pushl $44
80105db5:	6a 2c                	push   $0x2c
  jmp alltraps
80105db7:	e9 9e f9 ff ff       	jmp    8010575a <alltraps>

80105dbc <vector45>:
.globl vector45
vector45:
  pushl $0
80105dbc:	6a 00                	push   $0x0
  pushl $45
80105dbe:	6a 2d                	push   $0x2d
  jmp alltraps
80105dc0:	e9 95 f9 ff ff       	jmp    8010575a <alltraps>

80105dc5 <vector46>:
.globl vector46
vector46:
  pushl $0
80105dc5:	6a 00                	push   $0x0
  pushl $46
80105dc7:	6a 2e                	push   $0x2e
  jmp alltraps
80105dc9:	e9 8c f9 ff ff       	jmp    8010575a <alltraps>

80105dce <vector47>:
.globl vector47
vector47:
  pushl $0
80105dce:	6a 00                	push   $0x0
  pushl $47
80105dd0:	6a 2f                	push   $0x2f
  jmp alltraps
80105dd2:	e9 83 f9 ff ff       	jmp    8010575a <alltraps>

80105dd7 <vector48>:
.globl vector48
vector48:
  pushl $0
80105dd7:	6a 00                	push   $0x0
  pushl $48
80105dd9:	6a 30                	push   $0x30
  jmp alltraps
80105ddb:	e9 7a f9 ff ff       	jmp    8010575a <alltraps>

80105de0 <vector49>:
.globl vector49
vector49:
  pushl $0
80105de0:	6a 00                	push   $0x0
  pushl $49
80105de2:	6a 31                	push   $0x31
  jmp alltraps
80105de4:	e9 71 f9 ff ff       	jmp    8010575a <alltraps>

80105de9 <vector50>:
.globl vector50
vector50:
  pushl $0
80105de9:	6a 00                	push   $0x0
  pushl $50
80105deb:	6a 32                	push   $0x32
  jmp alltraps
80105ded:	e9 68 f9 ff ff       	jmp    8010575a <alltraps>

80105df2 <vector51>:
.globl vector51
vector51:
  pushl $0
80105df2:	6a 00                	push   $0x0
  pushl $51
80105df4:	6a 33                	push   $0x33
  jmp alltraps
80105df6:	e9 5f f9 ff ff       	jmp    8010575a <alltraps>

80105dfb <vector52>:
.globl vector52
vector52:
  pushl $0
80105dfb:	6a 00                	push   $0x0
  pushl $52
80105dfd:	6a 34                	push   $0x34
  jmp alltraps
80105dff:	e9 56 f9 ff ff       	jmp    8010575a <alltraps>

80105e04 <vector53>:
.globl vector53
vector53:
  pushl $0
80105e04:	6a 00                	push   $0x0
  pushl $53
80105e06:	6a 35                	push   $0x35
  jmp alltraps
80105e08:	e9 4d f9 ff ff       	jmp    8010575a <alltraps>

80105e0d <vector54>:
.globl vector54
vector54:
  pushl $0
80105e0d:	6a 00                	push   $0x0
  pushl $54
80105e0f:	6a 36                	push   $0x36
  jmp alltraps
80105e11:	e9 44 f9 ff ff       	jmp    8010575a <alltraps>

80105e16 <vector55>:
.globl vector55
vector55:
  pushl $0
80105e16:	6a 00                	push   $0x0
  pushl $55
80105e18:	6a 37                	push   $0x37
  jmp alltraps
80105e1a:	e9 3b f9 ff ff       	jmp    8010575a <alltraps>

80105e1f <vector56>:
.globl vector56
vector56:
  pushl $0
80105e1f:	6a 00                	push   $0x0
  pushl $56
80105e21:	6a 38                	push   $0x38
  jmp alltraps
80105e23:	e9 32 f9 ff ff       	jmp    8010575a <alltraps>

80105e28 <vector57>:
.globl vector57
vector57:
  pushl $0
80105e28:	6a 00                	push   $0x0
  pushl $57
80105e2a:	6a 39                	push   $0x39
  jmp alltraps
80105e2c:	e9 29 f9 ff ff       	jmp    8010575a <alltraps>

80105e31 <vector58>:
.globl vector58
vector58:
  pushl $0
80105e31:	6a 00                	push   $0x0
  pushl $58
80105e33:	6a 3a                	push   $0x3a
  jmp alltraps
80105e35:	e9 20 f9 ff ff       	jmp    8010575a <alltraps>

80105e3a <vector59>:
.globl vector59
vector59:
  pushl $0
80105e3a:	6a 00                	push   $0x0
  pushl $59
80105e3c:	6a 3b                	push   $0x3b
  jmp alltraps
80105e3e:	e9 17 f9 ff ff       	jmp    8010575a <alltraps>

80105e43 <vector60>:
.globl vector60
vector60:
  pushl $0
80105e43:	6a 00                	push   $0x0
  pushl $60
80105e45:	6a 3c                	push   $0x3c
  jmp alltraps
80105e47:	e9 0e f9 ff ff       	jmp    8010575a <alltraps>

80105e4c <vector61>:
.globl vector61
vector61:
  pushl $0
80105e4c:	6a 00                	push   $0x0
  pushl $61
80105e4e:	6a 3d                	push   $0x3d
  jmp alltraps
80105e50:	e9 05 f9 ff ff       	jmp    8010575a <alltraps>

80105e55 <vector62>:
.globl vector62
vector62:
  pushl $0
80105e55:	6a 00                	push   $0x0
  pushl $62
80105e57:	6a 3e                	push   $0x3e
  jmp alltraps
80105e59:	e9 fc f8 ff ff       	jmp    8010575a <alltraps>

80105e5e <vector63>:
.globl vector63
vector63:
  pushl $0
80105e5e:	6a 00                	push   $0x0
  pushl $63
80105e60:	6a 3f                	push   $0x3f
  jmp alltraps
80105e62:	e9 f3 f8 ff ff       	jmp    8010575a <alltraps>

80105e67 <vector64>:
.globl vector64
vector64:
  pushl $0
80105e67:	6a 00                	push   $0x0
  pushl $64
80105e69:	6a 40                	push   $0x40
  jmp alltraps
80105e6b:	e9 ea f8 ff ff       	jmp    8010575a <alltraps>

80105e70 <vector65>:
.globl vector65
vector65:
  pushl $0
80105e70:	6a 00                	push   $0x0
  pushl $65
80105e72:	6a 41                	push   $0x41
  jmp alltraps
80105e74:	e9 e1 f8 ff ff       	jmp    8010575a <alltraps>

80105e79 <vector66>:
.globl vector66
vector66:
  pushl $0
80105e79:	6a 00                	push   $0x0
  pushl $66
80105e7b:	6a 42                	push   $0x42
  jmp alltraps
80105e7d:	e9 d8 f8 ff ff       	jmp    8010575a <alltraps>

80105e82 <vector67>:
.globl vector67
vector67:
  pushl $0
80105e82:	6a 00                	push   $0x0
  pushl $67
80105e84:	6a 43                	push   $0x43
  jmp alltraps
80105e86:	e9 cf f8 ff ff       	jmp    8010575a <alltraps>

80105e8b <vector68>:
.globl vector68
vector68:
  pushl $0
80105e8b:	6a 00                	push   $0x0
  pushl $68
80105e8d:	6a 44                	push   $0x44
  jmp alltraps
80105e8f:	e9 c6 f8 ff ff       	jmp    8010575a <alltraps>

80105e94 <vector69>:
.globl vector69
vector69:
  pushl $0
80105e94:	6a 00                	push   $0x0
  pushl $69
80105e96:	6a 45                	push   $0x45
  jmp alltraps
80105e98:	e9 bd f8 ff ff       	jmp    8010575a <alltraps>

80105e9d <vector70>:
.globl vector70
vector70:
  pushl $0
80105e9d:	6a 00                	push   $0x0
  pushl $70
80105e9f:	6a 46                	push   $0x46
  jmp alltraps
80105ea1:	e9 b4 f8 ff ff       	jmp    8010575a <alltraps>

80105ea6 <vector71>:
.globl vector71
vector71:
  pushl $0
80105ea6:	6a 00                	push   $0x0
  pushl $71
80105ea8:	6a 47                	push   $0x47
  jmp alltraps
80105eaa:	e9 ab f8 ff ff       	jmp    8010575a <alltraps>

80105eaf <vector72>:
.globl vector72
vector72:
  pushl $0
80105eaf:	6a 00                	push   $0x0
  pushl $72
80105eb1:	6a 48                	push   $0x48
  jmp alltraps
80105eb3:	e9 a2 f8 ff ff       	jmp    8010575a <alltraps>

80105eb8 <vector73>:
.globl vector73
vector73:
  pushl $0
80105eb8:	6a 00                	push   $0x0
  pushl $73
80105eba:	6a 49                	push   $0x49
  jmp alltraps
80105ebc:	e9 99 f8 ff ff       	jmp    8010575a <alltraps>

80105ec1 <vector74>:
.globl vector74
vector74:
  pushl $0
80105ec1:	6a 00                	push   $0x0
  pushl $74
80105ec3:	6a 4a                	push   $0x4a
  jmp alltraps
80105ec5:	e9 90 f8 ff ff       	jmp    8010575a <alltraps>

80105eca <vector75>:
.globl vector75
vector75:
  pushl $0
80105eca:	6a 00                	push   $0x0
  pushl $75
80105ecc:	6a 4b                	push   $0x4b
  jmp alltraps
80105ece:	e9 87 f8 ff ff       	jmp    8010575a <alltraps>

80105ed3 <vector76>:
.globl vector76
vector76:
  pushl $0
80105ed3:	6a 00                	push   $0x0
  pushl $76
80105ed5:	6a 4c                	push   $0x4c
  jmp alltraps
80105ed7:	e9 7e f8 ff ff       	jmp    8010575a <alltraps>

80105edc <vector77>:
.globl vector77
vector77:
  pushl $0
80105edc:	6a 00                	push   $0x0
  pushl $77
80105ede:	6a 4d                	push   $0x4d
  jmp alltraps
80105ee0:	e9 75 f8 ff ff       	jmp    8010575a <alltraps>

80105ee5 <vector78>:
.globl vector78
vector78:
  pushl $0
80105ee5:	6a 00                	push   $0x0
  pushl $78
80105ee7:	6a 4e                	push   $0x4e
  jmp alltraps
80105ee9:	e9 6c f8 ff ff       	jmp    8010575a <alltraps>

80105eee <vector79>:
.globl vector79
vector79:
  pushl $0
80105eee:	6a 00                	push   $0x0
  pushl $79
80105ef0:	6a 4f                	push   $0x4f
  jmp alltraps
80105ef2:	e9 63 f8 ff ff       	jmp    8010575a <alltraps>

80105ef7 <vector80>:
.globl vector80
vector80:
  pushl $0
80105ef7:	6a 00                	push   $0x0
  pushl $80
80105ef9:	6a 50                	push   $0x50
  jmp alltraps
80105efb:	e9 5a f8 ff ff       	jmp    8010575a <alltraps>

80105f00 <vector81>:
.globl vector81
vector81:
  pushl $0
80105f00:	6a 00                	push   $0x0
  pushl $81
80105f02:	6a 51                	push   $0x51
  jmp alltraps
80105f04:	e9 51 f8 ff ff       	jmp    8010575a <alltraps>

80105f09 <vector82>:
.globl vector82
vector82:
  pushl $0
80105f09:	6a 00                	push   $0x0
  pushl $82
80105f0b:	6a 52                	push   $0x52
  jmp alltraps
80105f0d:	e9 48 f8 ff ff       	jmp    8010575a <alltraps>

80105f12 <vector83>:
.globl vector83
vector83:
  pushl $0
80105f12:	6a 00                	push   $0x0
  pushl $83
80105f14:	6a 53                	push   $0x53
  jmp alltraps
80105f16:	e9 3f f8 ff ff       	jmp    8010575a <alltraps>

80105f1b <vector84>:
.globl vector84
vector84:
  pushl $0
80105f1b:	6a 00                	push   $0x0
  pushl $84
80105f1d:	6a 54                	push   $0x54
  jmp alltraps
80105f1f:	e9 36 f8 ff ff       	jmp    8010575a <alltraps>

80105f24 <vector85>:
.globl vector85
vector85:
  pushl $0
80105f24:	6a 00                	push   $0x0
  pushl $85
80105f26:	6a 55                	push   $0x55
  jmp alltraps
80105f28:	e9 2d f8 ff ff       	jmp    8010575a <alltraps>

80105f2d <vector86>:
.globl vector86
vector86:
  pushl $0
80105f2d:	6a 00                	push   $0x0
  pushl $86
80105f2f:	6a 56                	push   $0x56
  jmp alltraps
80105f31:	e9 24 f8 ff ff       	jmp    8010575a <alltraps>

80105f36 <vector87>:
.globl vector87
vector87:
  pushl $0
80105f36:	6a 00                	push   $0x0
  pushl $87
80105f38:	6a 57                	push   $0x57
  jmp alltraps
80105f3a:	e9 1b f8 ff ff       	jmp    8010575a <alltraps>

80105f3f <vector88>:
.globl vector88
vector88:
  pushl $0
80105f3f:	6a 00                	push   $0x0
  pushl $88
80105f41:	6a 58                	push   $0x58
  jmp alltraps
80105f43:	e9 12 f8 ff ff       	jmp    8010575a <alltraps>

80105f48 <vector89>:
.globl vector89
vector89:
  pushl $0
80105f48:	6a 00                	push   $0x0
  pushl $89
80105f4a:	6a 59                	push   $0x59
  jmp alltraps
80105f4c:	e9 09 f8 ff ff       	jmp    8010575a <alltraps>

80105f51 <vector90>:
.globl vector90
vector90:
  pushl $0
80105f51:	6a 00                	push   $0x0
  pushl $90
80105f53:	6a 5a                	push   $0x5a
  jmp alltraps
80105f55:	e9 00 f8 ff ff       	jmp    8010575a <alltraps>

80105f5a <vector91>:
.globl vector91
vector91:
  pushl $0
80105f5a:	6a 00                	push   $0x0
  pushl $91
80105f5c:	6a 5b                	push   $0x5b
  jmp alltraps
80105f5e:	e9 f7 f7 ff ff       	jmp    8010575a <alltraps>

80105f63 <vector92>:
.globl vector92
vector92:
  pushl $0
80105f63:	6a 00                	push   $0x0
  pushl $92
80105f65:	6a 5c                	push   $0x5c
  jmp alltraps
80105f67:	e9 ee f7 ff ff       	jmp    8010575a <alltraps>

80105f6c <vector93>:
.globl vector93
vector93:
  pushl $0
80105f6c:	6a 00                	push   $0x0
  pushl $93
80105f6e:	6a 5d                	push   $0x5d
  jmp alltraps
80105f70:	e9 e5 f7 ff ff       	jmp    8010575a <alltraps>

80105f75 <vector94>:
.globl vector94
vector94:
  pushl $0
80105f75:	6a 00                	push   $0x0
  pushl $94
80105f77:	6a 5e                	push   $0x5e
  jmp alltraps
80105f79:	e9 dc f7 ff ff       	jmp    8010575a <alltraps>

80105f7e <vector95>:
.globl vector95
vector95:
  pushl $0
80105f7e:	6a 00                	push   $0x0
  pushl $95
80105f80:	6a 5f                	push   $0x5f
  jmp alltraps
80105f82:	e9 d3 f7 ff ff       	jmp    8010575a <alltraps>

80105f87 <vector96>:
.globl vector96
vector96:
  pushl $0
80105f87:	6a 00                	push   $0x0
  pushl $96
80105f89:	6a 60                	push   $0x60
  jmp alltraps
80105f8b:	e9 ca f7 ff ff       	jmp    8010575a <alltraps>

80105f90 <vector97>:
.globl vector97
vector97:
  pushl $0
80105f90:	6a 00                	push   $0x0
  pushl $97
80105f92:	6a 61                	push   $0x61
  jmp alltraps
80105f94:	e9 c1 f7 ff ff       	jmp    8010575a <alltraps>

80105f99 <vector98>:
.globl vector98
vector98:
  pushl $0
80105f99:	6a 00                	push   $0x0
  pushl $98
80105f9b:	6a 62                	push   $0x62
  jmp alltraps
80105f9d:	e9 b8 f7 ff ff       	jmp    8010575a <alltraps>

80105fa2 <vector99>:
.globl vector99
vector99:
  pushl $0
80105fa2:	6a 00                	push   $0x0
  pushl $99
80105fa4:	6a 63                	push   $0x63
  jmp alltraps
80105fa6:	e9 af f7 ff ff       	jmp    8010575a <alltraps>

80105fab <vector100>:
.globl vector100
vector100:
  pushl $0
80105fab:	6a 00                	push   $0x0
  pushl $100
80105fad:	6a 64                	push   $0x64
  jmp alltraps
80105faf:	e9 a6 f7 ff ff       	jmp    8010575a <alltraps>

80105fb4 <vector101>:
.globl vector101
vector101:
  pushl $0
80105fb4:	6a 00                	push   $0x0
  pushl $101
80105fb6:	6a 65                	push   $0x65
  jmp alltraps
80105fb8:	e9 9d f7 ff ff       	jmp    8010575a <alltraps>

80105fbd <vector102>:
.globl vector102
vector102:
  pushl $0
80105fbd:	6a 00                	push   $0x0
  pushl $102
80105fbf:	6a 66                	push   $0x66
  jmp alltraps
80105fc1:	e9 94 f7 ff ff       	jmp    8010575a <alltraps>

80105fc6 <vector103>:
.globl vector103
vector103:
  pushl $0
80105fc6:	6a 00                	push   $0x0
  pushl $103
80105fc8:	6a 67                	push   $0x67
  jmp alltraps
80105fca:	e9 8b f7 ff ff       	jmp    8010575a <alltraps>

80105fcf <vector104>:
.globl vector104
vector104:
  pushl $0
80105fcf:	6a 00                	push   $0x0
  pushl $104
80105fd1:	6a 68                	push   $0x68
  jmp alltraps
80105fd3:	e9 82 f7 ff ff       	jmp    8010575a <alltraps>

80105fd8 <vector105>:
.globl vector105
vector105:
  pushl $0
80105fd8:	6a 00                	push   $0x0
  pushl $105
80105fda:	6a 69                	push   $0x69
  jmp alltraps
80105fdc:	e9 79 f7 ff ff       	jmp    8010575a <alltraps>

80105fe1 <vector106>:
.globl vector106
vector106:
  pushl $0
80105fe1:	6a 00                	push   $0x0
  pushl $106
80105fe3:	6a 6a                	push   $0x6a
  jmp alltraps
80105fe5:	e9 70 f7 ff ff       	jmp    8010575a <alltraps>

80105fea <vector107>:
.globl vector107
vector107:
  pushl $0
80105fea:	6a 00                	push   $0x0
  pushl $107
80105fec:	6a 6b                	push   $0x6b
  jmp alltraps
80105fee:	e9 67 f7 ff ff       	jmp    8010575a <alltraps>

80105ff3 <vector108>:
.globl vector108
vector108:
  pushl $0
80105ff3:	6a 00                	push   $0x0
  pushl $108
80105ff5:	6a 6c                	push   $0x6c
  jmp alltraps
80105ff7:	e9 5e f7 ff ff       	jmp    8010575a <alltraps>

80105ffc <vector109>:
.globl vector109
vector109:
  pushl $0
80105ffc:	6a 00                	push   $0x0
  pushl $109
80105ffe:	6a 6d                	push   $0x6d
  jmp alltraps
80106000:	e9 55 f7 ff ff       	jmp    8010575a <alltraps>

80106005 <vector110>:
.globl vector110
vector110:
  pushl $0
80106005:	6a 00                	push   $0x0
  pushl $110
80106007:	6a 6e                	push   $0x6e
  jmp alltraps
80106009:	e9 4c f7 ff ff       	jmp    8010575a <alltraps>

8010600e <vector111>:
.globl vector111
vector111:
  pushl $0
8010600e:	6a 00                	push   $0x0
  pushl $111
80106010:	6a 6f                	push   $0x6f
  jmp alltraps
80106012:	e9 43 f7 ff ff       	jmp    8010575a <alltraps>

80106017 <vector112>:
.globl vector112
vector112:
  pushl $0
80106017:	6a 00                	push   $0x0
  pushl $112
80106019:	6a 70                	push   $0x70
  jmp alltraps
8010601b:	e9 3a f7 ff ff       	jmp    8010575a <alltraps>

80106020 <vector113>:
.globl vector113
vector113:
  pushl $0
80106020:	6a 00                	push   $0x0
  pushl $113
80106022:	6a 71                	push   $0x71
  jmp alltraps
80106024:	e9 31 f7 ff ff       	jmp    8010575a <alltraps>

80106029 <vector114>:
.globl vector114
vector114:
  pushl $0
80106029:	6a 00                	push   $0x0
  pushl $114
8010602b:	6a 72                	push   $0x72
  jmp alltraps
8010602d:	e9 28 f7 ff ff       	jmp    8010575a <alltraps>

80106032 <vector115>:
.globl vector115
vector115:
  pushl $0
80106032:	6a 00                	push   $0x0
  pushl $115
80106034:	6a 73                	push   $0x73
  jmp alltraps
80106036:	e9 1f f7 ff ff       	jmp    8010575a <alltraps>

8010603b <vector116>:
.globl vector116
vector116:
  pushl $0
8010603b:	6a 00                	push   $0x0
  pushl $116
8010603d:	6a 74                	push   $0x74
  jmp alltraps
8010603f:	e9 16 f7 ff ff       	jmp    8010575a <alltraps>

80106044 <vector117>:
.globl vector117
vector117:
  pushl $0
80106044:	6a 00                	push   $0x0
  pushl $117
80106046:	6a 75                	push   $0x75
  jmp alltraps
80106048:	e9 0d f7 ff ff       	jmp    8010575a <alltraps>

8010604d <vector118>:
.globl vector118
vector118:
  pushl $0
8010604d:	6a 00                	push   $0x0
  pushl $118
8010604f:	6a 76                	push   $0x76
  jmp alltraps
80106051:	e9 04 f7 ff ff       	jmp    8010575a <alltraps>

80106056 <vector119>:
.globl vector119
vector119:
  pushl $0
80106056:	6a 00                	push   $0x0
  pushl $119
80106058:	6a 77                	push   $0x77
  jmp alltraps
8010605a:	e9 fb f6 ff ff       	jmp    8010575a <alltraps>

8010605f <vector120>:
.globl vector120
vector120:
  pushl $0
8010605f:	6a 00                	push   $0x0
  pushl $120
80106061:	6a 78                	push   $0x78
  jmp alltraps
80106063:	e9 f2 f6 ff ff       	jmp    8010575a <alltraps>

80106068 <vector121>:
.globl vector121
vector121:
  pushl $0
80106068:	6a 00                	push   $0x0
  pushl $121
8010606a:	6a 79                	push   $0x79
  jmp alltraps
8010606c:	e9 e9 f6 ff ff       	jmp    8010575a <alltraps>

80106071 <vector122>:
.globl vector122
vector122:
  pushl $0
80106071:	6a 00                	push   $0x0
  pushl $122
80106073:	6a 7a                	push   $0x7a
  jmp alltraps
80106075:	e9 e0 f6 ff ff       	jmp    8010575a <alltraps>

8010607a <vector123>:
.globl vector123
vector123:
  pushl $0
8010607a:	6a 00                	push   $0x0
  pushl $123
8010607c:	6a 7b                	push   $0x7b
  jmp alltraps
8010607e:	e9 d7 f6 ff ff       	jmp    8010575a <alltraps>

80106083 <vector124>:
.globl vector124
vector124:
  pushl $0
80106083:	6a 00                	push   $0x0
  pushl $124
80106085:	6a 7c                	push   $0x7c
  jmp alltraps
80106087:	e9 ce f6 ff ff       	jmp    8010575a <alltraps>

8010608c <vector125>:
.globl vector125
vector125:
  pushl $0
8010608c:	6a 00                	push   $0x0
  pushl $125
8010608e:	6a 7d                	push   $0x7d
  jmp alltraps
80106090:	e9 c5 f6 ff ff       	jmp    8010575a <alltraps>

80106095 <vector126>:
.globl vector126
vector126:
  pushl $0
80106095:	6a 00                	push   $0x0
  pushl $126
80106097:	6a 7e                	push   $0x7e
  jmp alltraps
80106099:	e9 bc f6 ff ff       	jmp    8010575a <alltraps>

8010609e <vector127>:
.globl vector127
vector127:
  pushl $0
8010609e:	6a 00                	push   $0x0
  pushl $127
801060a0:	6a 7f                	push   $0x7f
  jmp alltraps
801060a2:	e9 b3 f6 ff ff       	jmp    8010575a <alltraps>

801060a7 <vector128>:
.globl vector128
vector128:
  pushl $0
801060a7:	6a 00                	push   $0x0
  pushl $128
801060a9:	68 80 00 00 00       	push   $0x80
  jmp alltraps
801060ae:	e9 a7 f6 ff ff       	jmp    8010575a <alltraps>

801060b3 <vector129>:
.globl vector129
vector129:
  pushl $0
801060b3:	6a 00                	push   $0x0
  pushl $129
801060b5:	68 81 00 00 00       	push   $0x81
  jmp alltraps
801060ba:	e9 9b f6 ff ff       	jmp    8010575a <alltraps>

801060bf <vector130>:
.globl vector130
vector130:
  pushl $0
801060bf:	6a 00                	push   $0x0
  pushl $130
801060c1:	68 82 00 00 00       	push   $0x82
  jmp alltraps
801060c6:	e9 8f f6 ff ff       	jmp    8010575a <alltraps>

801060cb <vector131>:
.globl vector131
vector131:
  pushl $0
801060cb:	6a 00                	push   $0x0
  pushl $131
801060cd:	68 83 00 00 00       	push   $0x83
  jmp alltraps
801060d2:	e9 83 f6 ff ff       	jmp    8010575a <alltraps>

801060d7 <vector132>:
.globl vector132
vector132:
  pushl $0
801060d7:	6a 00                	push   $0x0
  pushl $132
801060d9:	68 84 00 00 00       	push   $0x84
  jmp alltraps
801060de:	e9 77 f6 ff ff       	jmp    8010575a <alltraps>

801060e3 <vector133>:
.globl vector133
vector133:
  pushl $0
801060e3:	6a 00                	push   $0x0
  pushl $133
801060e5:	68 85 00 00 00       	push   $0x85
  jmp alltraps
801060ea:	e9 6b f6 ff ff       	jmp    8010575a <alltraps>

801060ef <vector134>:
.globl vector134
vector134:
  pushl $0
801060ef:	6a 00                	push   $0x0
  pushl $134
801060f1:	68 86 00 00 00       	push   $0x86
  jmp alltraps
801060f6:	e9 5f f6 ff ff       	jmp    8010575a <alltraps>

801060fb <vector135>:
.globl vector135
vector135:
  pushl $0
801060fb:	6a 00                	push   $0x0
  pushl $135
801060fd:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80106102:	e9 53 f6 ff ff       	jmp    8010575a <alltraps>

80106107 <vector136>:
.globl vector136
vector136:
  pushl $0
80106107:	6a 00                	push   $0x0
  pushl $136
80106109:	68 88 00 00 00       	push   $0x88
  jmp alltraps
8010610e:	e9 47 f6 ff ff       	jmp    8010575a <alltraps>

80106113 <vector137>:
.globl vector137
vector137:
  pushl $0
80106113:	6a 00                	push   $0x0
  pushl $137
80106115:	68 89 00 00 00       	push   $0x89
  jmp alltraps
8010611a:	e9 3b f6 ff ff       	jmp    8010575a <alltraps>

8010611f <vector138>:
.globl vector138
vector138:
  pushl $0
8010611f:	6a 00                	push   $0x0
  pushl $138
80106121:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
80106126:	e9 2f f6 ff ff       	jmp    8010575a <alltraps>

8010612b <vector139>:
.globl vector139
vector139:
  pushl $0
8010612b:	6a 00                	push   $0x0
  pushl $139
8010612d:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80106132:	e9 23 f6 ff ff       	jmp    8010575a <alltraps>

80106137 <vector140>:
.globl vector140
vector140:
  pushl $0
80106137:	6a 00                	push   $0x0
  pushl $140
80106139:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
8010613e:	e9 17 f6 ff ff       	jmp    8010575a <alltraps>

80106143 <vector141>:
.globl vector141
vector141:
  pushl $0
80106143:	6a 00                	push   $0x0
  pushl $141
80106145:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
8010614a:	e9 0b f6 ff ff       	jmp    8010575a <alltraps>

8010614f <vector142>:
.globl vector142
vector142:
  pushl $0
8010614f:	6a 00                	push   $0x0
  pushl $142
80106151:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80106156:	e9 ff f5 ff ff       	jmp    8010575a <alltraps>

8010615b <vector143>:
.globl vector143
vector143:
  pushl $0
8010615b:	6a 00                	push   $0x0
  pushl $143
8010615d:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80106162:	e9 f3 f5 ff ff       	jmp    8010575a <alltraps>

80106167 <vector144>:
.globl vector144
vector144:
  pushl $0
80106167:	6a 00                	push   $0x0
  pushl $144
80106169:	68 90 00 00 00       	push   $0x90
  jmp alltraps
8010616e:	e9 e7 f5 ff ff       	jmp    8010575a <alltraps>

80106173 <vector145>:
.globl vector145
vector145:
  pushl $0
80106173:	6a 00                	push   $0x0
  pushl $145
80106175:	68 91 00 00 00       	push   $0x91
  jmp alltraps
8010617a:	e9 db f5 ff ff       	jmp    8010575a <alltraps>

8010617f <vector146>:
.globl vector146
vector146:
  pushl $0
8010617f:	6a 00                	push   $0x0
  pushl $146
80106181:	68 92 00 00 00       	push   $0x92
  jmp alltraps
80106186:	e9 cf f5 ff ff       	jmp    8010575a <alltraps>

8010618b <vector147>:
.globl vector147
vector147:
  pushl $0
8010618b:	6a 00                	push   $0x0
  pushl $147
8010618d:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80106192:	e9 c3 f5 ff ff       	jmp    8010575a <alltraps>

80106197 <vector148>:
.globl vector148
vector148:
  pushl $0
80106197:	6a 00                	push   $0x0
  pushl $148
80106199:	68 94 00 00 00       	push   $0x94
  jmp alltraps
8010619e:	e9 b7 f5 ff ff       	jmp    8010575a <alltraps>

801061a3 <vector149>:
.globl vector149
vector149:
  pushl $0
801061a3:	6a 00                	push   $0x0
  pushl $149
801061a5:	68 95 00 00 00       	push   $0x95
  jmp alltraps
801061aa:	e9 ab f5 ff ff       	jmp    8010575a <alltraps>

801061af <vector150>:
.globl vector150
vector150:
  pushl $0
801061af:	6a 00                	push   $0x0
  pushl $150
801061b1:	68 96 00 00 00       	push   $0x96
  jmp alltraps
801061b6:	e9 9f f5 ff ff       	jmp    8010575a <alltraps>

801061bb <vector151>:
.globl vector151
vector151:
  pushl $0
801061bb:	6a 00                	push   $0x0
  pushl $151
801061bd:	68 97 00 00 00       	push   $0x97
  jmp alltraps
801061c2:	e9 93 f5 ff ff       	jmp    8010575a <alltraps>

801061c7 <vector152>:
.globl vector152
vector152:
  pushl $0
801061c7:	6a 00                	push   $0x0
  pushl $152
801061c9:	68 98 00 00 00       	push   $0x98
  jmp alltraps
801061ce:	e9 87 f5 ff ff       	jmp    8010575a <alltraps>

801061d3 <vector153>:
.globl vector153
vector153:
  pushl $0
801061d3:	6a 00                	push   $0x0
  pushl $153
801061d5:	68 99 00 00 00       	push   $0x99
  jmp alltraps
801061da:	e9 7b f5 ff ff       	jmp    8010575a <alltraps>

801061df <vector154>:
.globl vector154
vector154:
  pushl $0
801061df:	6a 00                	push   $0x0
  pushl $154
801061e1:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
801061e6:	e9 6f f5 ff ff       	jmp    8010575a <alltraps>

801061eb <vector155>:
.globl vector155
vector155:
  pushl $0
801061eb:	6a 00                	push   $0x0
  pushl $155
801061ed:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
801061f2:	e9 63 f5 ff ff       	jmp    8010575a <alltraps>

801061f7 <vector156>:
.globl vector156
vector156:
  pushl $0
801061f7:	6a 00                	push   $0x0
  pushl $156
801061f9:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
801061fe:	e9 57 f5 ff ff       	jmp    8010575a <alltraps>

80106203 <vector157>:
.globl vector157
vector157:
  pushl $0
80106203:	6a 00                	push   $0x0
  pushl $157
80106205:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
8010620a:	e9 4b f5 ff ff       	jmp    8010575a <alltraps>

8010620f <vector158>:
.globl vector158
vector158:
  pushl $0
8010620f:	6a 00                	push   $0x0
  pushl $158
80106211:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80106216:	e9 3f f5 ff ff       	jmp    8010575a <alltraps>

8010621b <vector159>:
.globl vector159
vector159:
  pushl $0
8010621b:	6a 00                	push   $0x0
  pushl $159
8010621d:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80106222:	e9 33 f5 ff ff       	jmp    8010575a <alltraps>

80106227 <vector160>:
.globl vector160
vector160:
  pushl $0
80106227:	6a 00                	push   $0x0
  pushl $160
80106229:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
8010622e:	e9 27 f5 ff ff       	jmp    8010575a <alltraps>

80106233 <vector161>:
.globl vector161
vector161:
  pushl $0
80106233:	6a 00                	push   $0x0
  pushl $161
80106235:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
8010623a:	e9 1b f5 ff ff       	jmp    8010575a <alltraps>

8010623f <vector162>:
.globl vector162
vector162:
  pushl $0
8010623f:	6a 00                	push   $0x0
  pushl $162
80106241:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80106246:	e9 0f f5 ff ff       	jmp    8010575a <alltraps>

8010624b <vector163>:
.globl vector163
vector163:
  pushl $0
8010624b:	6a 00                	push   $0x0
  pushl $163
8010624d:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80106252:	e9 03 f5 ff ff       	jmp    8010575a <alltraps>

80106257 <vector164>:
.globl vector164
vector164:
  pushl $0
80106257:	6a 00                	push   $0x0
  pushl $164
80106259:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
8010625e:	e9 f7 f4 ff ff       	jmp    8010575a <alltraps>

80106263 <vector165>:
.globl vector165
vector165:
  pushl $0
80106263:	6a 00                	push   $0x0
  pushl $165
80106265:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
8010626a:	e9 eb f4 ff ff       	jmp    8010575a <alltraps>

8010626f <vector166>:
.globl vector166
vector166:
  pushl $0
8010626f:	6a 00                	push   $0x0
  pushl $166
80106271:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80106276:	e9 df f4 ff ff       	jmp    8010575a <alltraps>

8010627b <vector167>:
.globl vector167
vector167:
  pushl $0
8010627b:	6a 00                	push   $0x0
  pushl $167
8010627d:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80106282:	e9 d3 f4 ff ff       	jmp    8010575a <alltraps>

80106287 <vector168>:
.globl vector168
vector168:
  pushl $0
80106287:	6a 00                	push   $0x0
  pushl $168
80106289:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
8010628e:	e9 c7 f4 ff ff       	jmp    8010575a <alltraps>

80106293 <vector169>:
.globl vector169
vector169:
  pushl $0
80106293:	6a 00                	push   $0x0
  pushl $169
80106295:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
8010629a:	e9 bb f4 ff ff       	jmp    8010575a <alltraps>

8010629f <vector170>:
.globl vector170
vector170:
  pushl $0
8010629f:	6a 00                	push   $0x0
  pushl $170
801062a1:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
801062a6:	e9 af f4 ff ff       	jmp    8010575a <alltraps>

801062ab <vector171>:
.globl vector171
vector171:
  pushl $0
801062ab:	6a 00                	push   $0x0
  pushl $171
801062ad:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
801062b2:	e9 a3 f4 ff ff       	jmp    8010575a <alltraps>

801062b7 <vector172>:
.globl vector172
vector172:
  pushl $0
801062b7:	6a 00                	push   $0x0
  pushl $172
801062b9:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
801062be:	e9 97 f4 ff ff       	jmp    8010575a <alltraps>

801062c3 <vector173>:
.globl vector173
vector173:
  pushl $0
801062c3:	6a 00                	push   $0x0
  pushl $173
801062c5:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
801062ca:	e9 8b f4 ff ff       	jmp    8010575a <alltraps>

801062cf <vector174>:
.globl vector174
vector174:
  pushl $0
801062cf:	6a 00                	push   $0x0
  pushl $174
801062d1:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
801062d6:	e9 7f f4 ff ff       	jmp    8010575a <alltraps>

801062db <vector175>:
.globl vector175
vector175:
  pushl $0
801062db:	6a 00                	push   $0x0
  pushl $175
801062dd:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
801062e2:	e9 73 f4 ff ff       	jmp    8010575a <alltraps>

801062e7 <vector176>:
.globl vector176
vector176:
  pushl $0
801062e7:	6a 00                	push   $0x0
  pushl $176
801062e9:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
801062ee:	e9 67 f4 ff ff       	jmp    8010575a <alltraps>

801062f3 <vector177>:
.globl vector177
vector177:
  pushl $0
801062f3:	6a 00                	push   $0x0
  pushl $177
801062f5:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
801062fa:	e9 5b f4 ff ff       	jmp    8010575a <alltraps>

801062ff <vector178>:
.globl vector178
vector178:
  pushl $0
801062ff:	6a 00                	push   $0x0
  pushl $178
80106301:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80106306:	e9 4f f4 ff ff       	jmp    8010575a <alltraps>

8010630b <vector179>:
.globl vector179
vector179:
  pushl $0
8010630b:	6a 00                	push   $0x0
  pushl $179
8010630d:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80106312:	e9 43 f4 ff ff       	jmp    8010575a <alltraps>

80106317 <vector180>:
.globl vector180
vector180:
  pushl $0
80106317:	6a 00                	push   $0x0
  pushl $180
80106319:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
8010631e:	e9 37 f4 ff ff       	jmp    8010575a <alltraps>

80106323 <vector181>:
.globl vector181
vector181:
  pushl $0
80106323:	6a 00                	push   $0x0
  pushl $181
80106325:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
8010632a:	e9 2b f4 ff ff       	jmp    8010575a <alltraps>

8010632f <vector182>:
.globl vector182
vector182:
  pushl $0
8010632f:	6a 00                	push   $0x0
  pushl $182
80106331:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80106336:	e9 1f f4 ff ff       	jmp    8010575a <alltraps>

8010633b <vector183>:
.globl vector183
vector183:
  pushl $0
8010633b:	6a 00                	push   $0x0
  pushl $183
8010633d:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80106342:	e9 13 f4 ff ff       	jmp    8010575a <alltraps>

80106347 <vector184>:
.globl vector184
vector184:
  pushl $0
80106347:	6a 00                	push   $0x0
  pushl $184
80106349:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
8010634e:	e9 07 f4 ff ff       	jmp    8010575a <alltraps>

80106353 <vector185>:
.globl vector185
vector185:
  pushl $0
80106353:	6a 00                	push   $0x0
  pushl $185
80106355:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
8010635a:	e9 fb f3 ff ff       	jmp    8010575a <alltraps>

8010635f <vector186>:
.globl vector186
vector186:
  pushl $0
8010635f:	6a 00                	push   $0x0
  pushl $186
80106361:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80106366:	e9 ef f3 ff ff       	jmp    8010575a <alltraps>

8010636b <vector187>:
.globl vector187
vector187:
  pushl $0
8010636b:	6a 00                	push   $0x0
  pushl $187
8010636d:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80106372:	e9 e3 f3 ff ff       	jmp    8010575a <alltraps>

80106377 <vector188>:
.globl vector188
vector188:
  pushl $0
80106377:	6a 00                	push   $0x0
  pushl $188
80106379:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
8010637e:	e9 d7 f3 ff ff       	jmp    8010575a <alltraps>

80106383 <vector189>:
.globl vector189
vector189:
  pushl $0
80106383:	6a 00                	push   $0x0
  pushl $189
80106385:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
8010638a:	e9 cb f3 ff ff       	jmp    8010575a <alltraps>

8010638f <vector190>:
.globl vector190
vector190:
  pushl $0
8010638f:	6a 00                	push   $0x0
  pushl $190
80106391:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80106396:	e9 bf f3 ff ff       	jmp    8010575a <alltraps>

8010639b <vector191>:
.globl vector191
vector191:
  pushl $0
8010639b:	6a 00                	push   $0x0
  pushl $191
8010639d:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
801063a2:	e9 b3 f3 ff ff       	jmp    8010575a <alltraps>

801063a7 <vector192>:
.globl vector192
vector192:
  pushl $0
801063a7:	6a 00                	push   $0x0
  pushl $192
801063a9:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
801063ae:	e9 a7 f3 ff ff       	jmp    8010575a <alltraps>

801063b3 <vector193>:
.globl vector193
vector193:
  pushl $0
801063b3:	6a 00                	push   $0x0
  pushl $193
801063b5:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
801063ba:	e9 9b f3 ff ff       	jmp    8010575a <alltraps>

801063bf <vector194>:
.globl vector194
vector194:
  pushl $0
801063bf:	6a 00                	push   $0x0
  pushl $194
801063c1:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
801063c6:	e9 8f f3 ff ff       	jmp    8010575a <alltraps>

801063cb <vector195>:
.globl vector195
vector195:
  pushl $0
801063cb:	6a 00                	push   $0x0
  pushl $195
801063cd:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
801063d2:	e9 83 f3 ff ff       	jmp    8010575a <alltraps>

801063d7 <vector196>:
.globl vector196
vector196:
  pushl $0
801063d7:	6a 00                	push   $0x0
  pushl $196
801063d9:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
801063de:	e9 77 f3 ff ff       	jmp    8010575a <alltraps>

801063e3 <vector197>:
.globl vector197
vector197:
  pushl $0
801063e3:	6a 00                	push   $0x0
  pushl $197
801063e5:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
801063ea:	e9 6b f3 ff ff       	jmp    8010575a <alltraps>

801063ef <vector198>:
.globl vector198
vector198:
  pushl $0
801063ef:	6a 00                	push   $0x0
  pushl $198
801063f1:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
801063f6:	e9 5f f3 ff ff       	jmp    8010575a <alltraps>

801063fb <vector199>:
.globl vector199
vector199:
  pushl $0
801063fb:	6a 00                	push   $0x0
  pushl $199
801063fd:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80106402:	e9 53 f3 ff ff       	jmp    8010575a <alltraps>

80106407 <vector200>:
.globl vector200
vector200:
  pushl $0
80106407:	6a 00                	push   $0x0
  pushl $200
80106409:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
8010640e:	e9 47 f3 ff ff       	jmp    8010575a <alltraps>

80106413 <vector201>:
.globl vector201
vector201:
  pushl $0
80106413:	6a 00                	push   $0x0
  pushl $201
80106415:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
8010641a:	e9 3b f3 ff ff       	jmp    8010575a <alltraps>

8010641f <vector202>:
.globl vector202
vector202:
  pushl $0
8010641f:	6a 00                	push   $0x0
  pushl $202
80106421:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80106426:	e9 2f f3 ff ff       	jmp    8010575a <alltraps>

8010642b <vector203>:
.globl vector203
vector203:
  pushl $0
8010642b:	6a 00                	push   $0x0
  pushl $203
8010642d:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80106432:	e9 23 f3 ff ff       	jmp    8010575a <alltraps>

80106437 <vector204>:
.globl vector204
vector204:
  pushl $0
80106437:	6a 00                	push   $0x0
  pushl $204
80106439:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
8010643e:	e9 17 f3 ff ff       	jmp    8010575a <alltraps>

80106443 <vector205>:
.globl vector205
vector205:
  pushl $0
80106443:	6a 00                	push   $0x0
  pushl $205
80106445:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
8010644a:	e9 0b f3 ff ff       	jmp    8010575a <alltraps>

8010644f <vector206>:
.globl vector206
vector206:
  pushl $0
8010644f:	6a 00                	push   $0x0
  pushl $206
80106451:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80106456:	e9 ff f2 ff ff       	jmp    8010575a <alltraps>

8010645b <vector207>:
.globl vector207
vector207:
  pushl $0
8010645b:	6a 00                	push   $0x0
  pushl $207
8010645d:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80106462:	e9 f3 f2 ff ff       	jmp    8010575a <alltraps>

80106467 <vector208>:
.globl vector208
vector208:
  pushl $0
80106467:	6a 00                	push   $0x0
  pushl $208
80106469:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
8010646e:	e9 e7 f2 ff ff       	jmp    8010575a <alltraps>

80106473 <vector209>:
.globl vector209
vector209:
  pushl $0
80106473:	6a 00                	push   $0x0
  pushl $209
80106475:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
8010647a:	e9 db f2 ff ff       	jmp    8010575a <alltraps>

8010647f <vector210>:
.globl vector210
vector210:
  pushl $0
8010647f:	6a 00                	push   $0x0
  pushl $210
80106481:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80106486:	e9 cf f2 ff ff       	jmp    8010575a <alltraps>

8010648b <vector211>:
.globl vector211
vector211:
  pushl $0
8010648b:	6a 00                	push   $0x0
  pushl $211
8010648d:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80106492:	e9 c3 f2 ff ff       	jmp    8010575a <alltraps>

80106497 <vector212>:
.globl vector212
vector212:
  pushl $0
80106497:	6a 00                	push   $0x0
  pushl $212
80106499:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
8010649e:	e9 b7 f2 ff ff       	jmp    8010575a <alltraps>

801064a3 <vector213>:
.globl vector213
vector213:
  pushl $0
801064a3:	6a 00                	push   $0x0
  pushl $213
801064a5:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
801064aa:	e9 ab f2 ff ff       	jmp    8010575a <alltraps>

801064af <vector214>:
.globl vector214
vector214:
  pushl $0
801064af:	6a 00                	push   $0x0
  pushl $214
801064b1:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
801064b6:	e9 9f f2 ff ff       	jmp    8010575a <alltraps>

801064bb <vector215>:
.globl vector215
vector215:
  pushl $0
801064bb:	6a 00                	push   $0x0
  pushl $215
801064bd:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
801064c2:	e9 93 f2 ff ff       	jmp    8010575a <alltraps>

801064c7 <vector216>:
.globl vector216
vector216:
  pushl $0
801064c7:	6a 00                	push   $0x0
  pushl $216
801064c9:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
801064ce:	e9 87 f2 ff ff       	jmp    8010575a <alltraps>

801064d3 <vector217>:
.globl vector217
vector217:
  pushl $0
801064d3:	6a 00                	push   $0x0
  pushl $217
801064d5:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
801064da:	e9 7b f2 ff ff       	jmp    8010575a <alltraps>

801064df <vector218>:
.globl vector218
vector218:
  pushl $0
801064df:	6a 00                	push   $0x0
  pushl $218
801064e1:	68 da 00 00 00       	push   $0xda
  jmp alltraps
801064e6:	e9 6f f2 ff ff       	jmp    8010575a <alltraps>

801064eb <vector219>:
.globl vector219
vector219:
  pushl $0
801064eb:	6a 00                	push   $0x0
  pushl $219
801064ed:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
801064f2:	e9 63 f2 ff ff       	jmp    8010575a <alltraps>

801064f7 <vector220>:
.globl vector220
vector220:
  pushl $0
801064f7:	6a 00                	push   $0x0
  pushl $220
801064f9:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
801064fe:	e9 57 f2 ff ff       	jmp    8010575a <alltraps>

80106503 <vector221>:
.globl vector221
vector221:
  pushl $0
80106503:	6a 00                	push   $0x0
  pushl $221
80106505:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
8010650a:	e9 4b f2 ff ff       	jmp    8010575a <alltraps>

8010650f <vector222>:
.globl vector222
vector222:
  pushl $0
8010650f:	6a 00                	push   $0x0
  pushl $222
80106511:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80106516:	e9 3f f2 ff ff       	jmp    8010575a <alltraps>

8010651b <vector223>:
.globl vector223
vector223:
  pushl $0
8010651b:	6a 00                	push   $0x0
  pushl $223
8010651d:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80106522:	e9 33 f2 ff ff       	jmp    8010575a <alltraps>

80106527 <vector224>:
.globl vector224
vector224:
  pushl $0
80106527:	6a 00                	push   $0x0
  pushl $224
80106529:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
8010652e:	e9 27 f2 ff ff       	jmp    8010575a <alltraps>

80106533 <vector225>:
.globl vector225
vector225:
  pushl $0
80106533:	6a 00                	push   $0x0
  pushl $225
80106535:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
8010653a:	e9 1b f2 ff ff       	jmp    8010575a <alltraps>

8010653f <vector226>:
.globl vector226
vector226:
  pushl $0
8010653f:	6a 00                	push   $0x0
  pushl $226
80106541:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80106546:	e9 0f f2 ff ff       	jmp    8010575a <alltraps>

8010654b <vector227>:
.globl vector227
vector227:
  pushl $0
8010654b:	6a 00                	push   $0x0
  pushl $227
8010654d:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80106552:	e9 03 f2 ff ff       	jmp    8010575a <alltraps>

80106557 <vector228>:
.globl vector228
vector228:
  pushl $0
80106557:	6a 00                	push   $0x0
  pushl $228
80106559:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
8010655e:	e9 f7 f1 ff ff       	jmp    8010575a <alltraps>

80106563 <vector229>:
.globl vector229
vector229:
  pushl $0
80106563:	6a 00                	push   $0x0
  pushl $229
80106565:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
8010656a:	e9 eb f1 ff ff       	jmp    8010575a <alltraps>

8010656f <vector230>:
.globl vector230
vector230:
  pushl $0
8010656f:	6a 00                	push   $0x0
  pushl $230
80106571:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80106576:	e9 df f1 ff ff       	jmp    8010575a <alltraps>

8010657b <vector231>:
.globl vector231
vector231:
  pushl $0
8010657b:	6a 00                	push   $0x0
  pushl $231
8010657d:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80106582:	e9 d3 f1 ff ff       	jmp    8010575a <alltraps>

80106587 <vector232>:
.globl vector232
vector232:
  pushl $0
80106587:	6a 00                	push   $0x0
  pushl $232
80106589:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
8010658e:	e9 c7 f1 ff ff       	jmp    8010575a <alltraps>

80106593 <vector233>:
.globl vector233
vector233:
  pushl $0
80106593:	6a 00                	push   $0x0
  pushl $233
80106595:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
8010659a:	e9 bb f1 ff ff       	jmp    8010575a <alltraps>

8010659f <vector234>:
.globl vector234
vector234:
  pushl $0
8010659f:	6a 00                	push   $0x0
  pushl $234
801065a1:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
801065a6:	e9 af f1 ff ff       	jmp    8010575a <alltraps>

801065ab <vector235>:
.globl vector235
vector235:
  pushl $0
801065ab:	6a 00                	push   $0x0
  pushl $235
801065ad:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
801065b2:	e9 a3 f1 ff ff       	jmp    8010575a <alltraps>

801065b7 <vector236>:
.globl vector236
vector236:
  pushl $0
801065b7:	6a 00                	push   $0x0
  pushl $236
801065b9:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
801065be:	e9 97 f1 ff ff       	jmp    8010575a <alltraps>

801065c3 <vector237>:
.globl vector237
vector237:
  pushl $0
801065c3:	6a 00                	push   $0x0
  pushl $237
801065c5:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
801065ca:	e9 8b f1 ff ff       	jmp    8010575a <alltraps>

801065cf <vector238>:
.globl vector238
vector238:
  pushl $0
801065cf:	6a 00                	push   $0x0
  pushl $238
801065d1:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
801065d6:	e9 7f f1 ff ff       	jmp    8010575a <alltraps>

801065db <vector239>:
.globl vector239
vector239:
  pushl $0
801065db:	6a 00                	push   $0x0
  pushl $239
801065dd:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
801065e2:	e9 73 f1 ff ff       	jmp    8010575a <alltraps>

801065e7 <vector240>:
.globl vector240
vector240:
  pushl $0
801065e7:	6a 00                	push   $0x0
  pushl $240
801065e9:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
801065ee:	e9 67 f1 ff ff       	jmp    8010575a <alltraps>

801065f3 <vector241>:
.globl vector241
vector241:
  pushl $0
801065f3:	6a 00                	push   $0x0
  pushl $241
801065f5:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
801065fa:	e9 5b f1 ff ff       	jmp    8010575a <alltraps>

801065ff <vector242>:
.globl vector242
vector242:
  pushl $0
801065ff:	6a 00                	push   $0x0
  pushl $242
80106601:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80106606:	e9 4f f1 ff ff       	jmp    8010575a <alltraps>

8010660b <vector243>:
.globl vector243
vector243:
  pushl $0
8010660b:	6a 00                	push   $0x0
  pushl $243
8010660d:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80106612:	e9 43 f1 ff ff       	jmp    8010575a <alltraps>

80106617 <vector244>:
.globl vector244
vector244:
  pushl $0
80106617:	6a 00                	push   $0x0
  pushl $244
80106619:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
8010661e:	e9 37 f1 ff ff       	jmp    8010575a <alltraps>

80106623 <vector245>:
.globl vector245
vector245:
  pushl $0
80106623:	6a 00                	push   $0x0
  pushl $245
80106625:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
8010662a:	e9 2b f1 ff ff       	jmp    8010575a <alltraps>

8010662f <vector246>:
.globl vector246
vector246:
  pushl $0
8010662f:	6a 00                	push   $0x0
  pushl $246
80106631:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80106636:	e9 1f f1 ff ff       	jmp    8010575a <alltraps>

8010663b <vector247>:
.globl vector247
vector247:
  pushl $0
8010663b:	6a 00                	push   $0x0
  pushl $247
8010663d:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80106642:	e9 13 f1 ff ff       	jmp    8010575a <alltraps>

80106647 <vector248>:
.globl vector248
vector248:
  pushl $0
80106647:	6a 00                	push   $0x0
  pushl $248
80106649:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
8010664e:	e9 07 f1 ff ff       	jmp    8010575a <alltraps>

80106653 <vector249>:
.globl vector249
vector249:
  pushl $0
80106653:	6a 00                	push   $0x0
  pushl $249
80106655:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
8010665a:	e9 fb f0 ff ff       	jmp    8010575a <alltraps>

8010665f <vector250>:
.globl vector250
vector250:
  pushl $0
8010665f:	6a 00                	push   $0x0
  pushl $250
80106661:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80106666:	e9 ef f0 ff ff       	jmp    8010575a <alltraps>

8010666b <vector251>:
.globl vector251
vector251:
  pushl $0
8010666b:	6a 00                	push   $0x0
  pushl $251
8010666d:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80106672:	e9 e3 f0 ff ff       	jmp    8010575a <alltraps>

80106677 <vector252>:
.globl vector252
vector252:
  pushl $0
80106677:	6a 00                	push   $0x0
  pushl $252
80106679:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
8010667e:	e9 d7 f0 ff ff       	jmp    8010575a <alltraps>

80106683 <vector253>:
.globl vector253
vector253:
  pushl $0
80106683:	6a 00                	push   $0x0
  pushl $253
80106685:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
8010668a:	e9 cb f0 ff ff       	jmp    8010575a <alltraps>

8010668f <vector254>:
.globl vector254
vector254:
  pushl $0
8010668f:	6a 00                	push   $0x0
  pushl $254
80106691:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80106696:	e9 bf f0 ff ff       	jmp    8010575a <alltraps>

8010669b <vector255>:
.globl vector255
vector255:
  pushl $0
8010669b:	6a 00                	push   $0x0
  pushl $255
8010669d:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
801066a2:	e9 b3 f0 ff ff       	jmp    8010575a <alltraps>
801066a7:	66 90                	xchg   %ax,%ax
801066a9:	66 90                	xchg   %ax,%ax
801066ab:	66 90                	xchg   %ax,%ax
801066ad:	66 90                	xchg   %ax,%ax
801066af:	90                   	nop

801066b0 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
801066b0:	55                   	push   %ebp
801066b1:	89 e5                	mov    %esp,%ebp
801066b3:	57                   	push   %edi
801066b4:	56                   	push   %esi
801066b5:	89 d6                	mov    %edx,%esi
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
801066b7:	c1 ea 16             	shr    $0x16,%edx
{
801066ba:	53                   	push   %ebx
  pde = &pgdir[PDX(va)];
801066bb:	8d 3c 90             	lea    (%eax,%edx,4),%edi
{
801066be:	83 ec 0c             	sub    $0xc,%esp
  if(*pde & PTE_P){
801066c1:	8b 07                	mov    (%edi),%eax
801066c3:	a8 01                	test   $0x1,%al
801066c5:	74 29                	je     801066f0 <walkpgdir+0x40>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
801066c7:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801066cc:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
801066d2:	c1 ee 0a             	shr    $0xa,%esi
}
801066d5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return &pgtab[PTX(va)];
801066d8:	89 f2                	mov    %esi,%edx
801066da:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
801066e0:	8d 04 13             	lea    (%ebx,%edx,1),%eax
}
801066e3:	5b                   	pop    %ebx
801066e4:	5e                   	pop    %esi
801066e5:	5f                   	pop    %edi
801066e6:	5d                   	pop    %ebp
801066e7:	c3                   	ret    
801066e8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801066ef:	90                   	nop
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
801066f0:	85 c9                	test   %ecx,%ecx
801066f2:	74 2c                	je     80106720 <walkpgdir+0x70>
801066f4:	e8 b7 be ff ff       	call   801025b0 <kalloc>
801066f9:	89 c3                	mov    %eax,%ebx
801066fb:	85 c0                	test   %eax,%eax
801066fd:	74 21                	je     80106720 <walkpgdir+0x70>
    memset(pgtab, 0, PGSIZE);
801066ff:	83 ec 04             	sub    $0x4,%esp
80106702:	68 00 10 00 00       	push   $0x1000
80106707:	6a 00                	push   $0x0
80106709:	50                   	push   %eax
8010670a:	e8 b1 de ff ff       	call   801045c0 <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
8010670f:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106715:	83 c4 10             	add    $0x10,%esp
80106718:	83 c8 07             	or     $0x7,%eax
8010671b:	89 07                	mov    %eax,(%edi)
8010671d:	eb b3                	jmp    801066d2 <walkpgdir+0x22>
8010671f:	90                   	nop
}
80106720:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return 0;
80106723:	31 c0                	xor    %eax,%eax
}
80106725:	5b                   	pop    %ebx
80106726:	5e                   	pop    %esi
80106727:	5f                   	pop    %edi
80106728:	5d                   	pop    %ebp
80106729:	c3                   	ret    
8010672a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106730 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
80106730:	55                   	push   %ebp
80106731:	89 e5                	mov    %esp,%ebp
80106733:	57                   	push   %edi
80106734:	56                   	push   %esi
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
80106735:	89 d6                	mov    %edx,%esi
{
80106737:	53                   	push   %ebx
  a = (char*)PGROUNDDOWN((uint)va);
80106738:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
{
8010673e:	83 ec 1c             	sub    $0x1c,%esp
80106741:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80106744:	8b 7d 08             	mov    0x8(%ebp),%edi
80106747:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
8010674b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106750:	89 45 e0             	mov    %eax,-0x20(%ebp)
80106753:	29 f7                	sub    %esi,%edi
80106755:	eb 21                	jmp    80106778 <mappages+0x48>
80106757:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010675e:	66 90                	xchg   %ax,%ax
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
80106760:	f6 00 01             	testb  $0x1,(%eax)
80106763:	75 45                	jne    801067aa <mappages+0x7a>
      panic("remap");
    *pte = pa | perm | PTE_P;
80106765:	0b 5d 0c             	or     0xc(%ebp),%ebx
80106768:	83 cb 01             	or     $0x1,%ebx
8010676b:	89 18                	mov    %ebx,(%eax)
    if(a == last)
8010676d:	3b 75 e0             	cmp    -0x20(%ebp),%esi
80106770:	74 2e                	je     801067a0 <mappages+0x70>
      break;
    a += PGSIZE;
80106772:	81 c6 00 10 00 00    	add    $0x1000,%esi
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80106778:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010677b:	b9 01 00 00 00       	mov    $0x1,%ecx
80106780:	89 f2                	mov    %esi,%edx
80106782:	8d 1c 3e             	lea    (%esi,%edi,1),%ebx
80106785:	e8 26 ff ff ff       	call   801066b0 <walkpgdir>
8010678a:	85 c0                	test   %eax,%eax
8010678c:	75 d2                	jne    80106760 <mappages+0x30>
    pa += PGSIZE;
  }
  return 0;
}
8010678e:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80106791:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106796:	5b                   	pop    %ebx
80106797:	5e                   	pop    %esi
80106798:	5f                   	pop    %edi
80106799:	5d                   	pop    %ebp
8010679a:	c3                   	ret    
8010679b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010679f:	90                   	nop
801067a0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801067a3:	31 c0                	xor    %eax,%eax
}
801067a5:	5b                   	pop    %ebx
801067a6:	5e                   	pop    %esi
801067a7:	5f                   	pop    %edi
801067a8:	5d                   	pop    %ebp
801067a9:	c3                   	ret    
      panic("remap");
801067aa:	83 ec 0c             	sub    $0xc,%esp
801067ad:	68 ac 78 10 80       	push   $0x801078ac
801067b2:	e8 d9 9b ff ff       	call   80100390 <panic>
801067b7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801067be:	66 90                	xchg   %ax,%ax

801067c0 <deallocuvm.part.0>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
801067c0:	55                   	push   %ebp
801067c1:	89 e5                	mov    %esp,%ebp
801067c3:	57                   	push   %edi
801067c4:	89 c7                	mov    %eax,%edi
801067c6:	56                   	push   %esi
801067c7:	53                   	push   %ebx
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
801067c8:	8d 99 ff 0f 00 00    	lea    0xfff(%ecx),%ebx
801067ce:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
801067d4:	83 ec 1c             	sub    $0x1c,%esp
801067d7:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  for(; a  < oldsz; a += PGSIZE){
801067da:	39 d3                	cmp    %edx,%ebx
801067dc:	73 5a                	jae    80106838 <deallocuvm.part.0+0x78>
801067de:	89 d6                	mov    %edx,%esi
801067e0:	eb 10                	jmp    801067f2 <deallocuvm.part.0+0x32>
801067e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801067e8:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801067ee:	39 de                	cmp    %ebx,%esi
801067f0:	76 46                	jbe    80106838 <deallocuvm.part.0+0x78>
    pte = walkpgdir(pgdir, (char*)a, 0);
801067f2:	31 c9                	xor    %ecx,%ecx
801067f4:	89 da                	mov    %ebx,%edx
801067f6:	89 f8                	mov    %edi,%eax
801067f8:	e8 b3 fe ff ff       	call   801066b0 <walkpgdir>
    if(!pte)
801067fd:	85 c0                	test   %eax,%eax
801067ff:	74 47                	je     80106848 <deallocuvm.part.0+0x88>
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
    else if((*pte & PTE_P) != 0){
80106801:	8b 10                	mov    (%eax),%edx
80106803:	f6 c2 01             	test   $0x1,%dl
80106806:	74 e0                	je     801067e8 <deallocuvm.part.0+0x28>
      pa = PTE_ADDR(*pte);
      if(pa == 0)
80106808:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
8010680e:	74 46                	je     80106856 <deallocuvm.part.0+0x96>
        panic("kfree");
      char *v = P2V(pa);
      kfree(v);
80106810:	83 ec 0c             	sub    $0xc,%esp
      char *v = P2V(pa);
80106813:	81 c2 00 00 00 80    	add    $0x80000000,%edx
80106819:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      kfree(v);
8010681c:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106822:	52                   	push   %edx
80106823:	e8 c8 bb ff ff       	call   801023f0 <kfree>
      *pte = 0;
80106828:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010682b:	83 c4 10             	add    $0x10,%esp
8010682e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; a  < oldsz; a += PGSIZE){
80106834:	39 de                	cmp    %ebx,%esi
80106836:	77 ba                	ja     801067f2 <deallocuvm.part.0+0x32>
    }
  }
  return newsz;
}
80106838:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010683b:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010683e:	5b                   	pop    %ebx
8010683f:	5e                   	pop    %esi
80106840:	5f                   	pop    %edi
80106841:	5d                   	pop    %ebp
80106842:	c3                   	ret    
80106843:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106847:	90                   	nop
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
80106848:	81 e3 00 00 c0 ff    	and    $0xffc00000,%ebx
8010684e:	81 c3 00 00 40 00    	add    $0x400000,%ebx
80106854:	eb 98                	jmp    801067ee <deallocuvm.part.0+0x2e>
        panic("kfree");
80106856:	83 ec 0c             	sub    $0xc,%esp
80106859:	68 46 72 10 80       	push   $0x80107246
8010685e:	e8 2d 9b ff ff       	call   80100390 <panic>
80106863:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010686a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106870 <seginit>:
{
80106870:	55                   	push   %ebp
80106871:	89 e5                	mov    %esp,%ebp
80106873:	83 ec 18             	sub    $0x18,%esp
  c = &cpus[cpuid()];
80106876:	e8 95 d0 ff ff       	call   80103910 <cpuid>
  pd[0] = size-1;
8010687b:	ba 2f 00 00 00       	mov    $0x2f,%edx
80106880:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
80106886:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
8010688a:	c7 80 f8 27 11 80 ff 	movl   $0xffff,-0x7feed808(%eax)
80106891:	ff 00 00 
80106894:	c7 80 fc 27 11 80 00 	movl   $0xcf9a00,-0x7feed804(%eax)
8010689b:	9a cf 00 
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
8010689e:	c7 80 00 28 11 80 ff 	movl   $0xffff,-0x7feed800(%eax)
801068a5:	ff 00 00 
801068a8:	c7 80 04 28 11 80 00 	movl   $0xcf9200,-0x7feed7fc(%eax)
801068af:	92 cf 00 
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
801068b2:	c7 80 08 28 11 80 ff 	movl   $0xffff,-0x7feed7f8(%eax)
801068b9:	ff 00 00 
801068bc:	c7 80 0c 28 11 80 00 	movl   $0xcffa00,-0x7feed7f4(%eax)
801068c3:	fa cf 00 
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
801068c6:	c7 80 10 28 11 80 ff 	movl   $0xffff,-0x7feed7f0(%eax)
801068cd:	ff 00 00 
801068d0:	c7 80 14 28 11 80 00 	movl   $0xcff200,-0x7feed7ec(%eax)
801068d7:	f2 cf 00 
  lgdt(c->gdt, sizeof(c->gdt));
801068da:	05 f0 27 11 80       	add    $0x801127f0,%eax
  pd[1] = (uint)p;
801068df:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
801068e3:	c1 e8 10             	shr    $0x10,%eax
801068e6:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
801068ea:	8d 45 f2             	lea    -0xe(%ebp),%eax
801068ed:	0f 01 10             	lgdtl  (%eax)
}
801068f0:	c9                   	leave  
801068f1:	c3                   	ret    
801068f2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801068f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106900 <switchkvm>:
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80106900:	a1 a4 54 11 80       	mov    0x801154a4,%eax
80106905:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
8010690a:	0f 22 d8             	mov    %eax,%cr3
}
8010690d:	c3                   	ret    
8010690e:	66 90                	xchg   %ax,%ax

80106910 <switchuvm>:
{
80106910:	55                   	push   %ebp
80106911:	89 e5                	mov    %esp,%ebp
80106913:	57                   	push   %edi
80106914:	56                   	push   %esi
80106915:	53                   	push   %ebx
80106916:	83 ec 1c             	sub    $0x1c,%esp
80106919:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(p == 0)
8010691c:	85 db                	test   %ebx,%ebx
8010691e:	0f 84 cb 00 00 00    	je     801069ef <switchuvm+0xdf>
  if(p->kstack == 0)
80106924:	8b 43 08             	mov    0x8(%ebx),%eax
80106927:	85 c0                	test   %eax,%eax
80106929:	0f 84 da 00 00 00    	je     80106a09 <switchuvm+0xf9>
  if(p->pgdir == 0)
8010692f:	8b 43 04             	mov    0x4(%ebx),%eax
80106932:	85 c0                	test   %eax,%eax
80106934:	0f 84 c2 00 00 00    	je     801069fc <switchuvm+0xec>
  pushcli();
8010693a:	e8 81 da ff ff       	call   801043c0 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
8010693f:	e8 4c cf ff ff       	call   80103890 <mycpu>
80106944:	89 c6                	mov    %eax,%esi
80106946:	e8 45 cf ff ff       	call   80103890 <mycpu>
8010694b:	89 c7                	mov    %eax,%edi
8010694d:	e8 3e cf ff ff       	call   80103890 <mycpu>
80106952:	83 c7 08             	add    $0x8,%edi
80106955:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106958:	e8 33 cf ff ff       	call   80103890 <mycpu>
8010695d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80106960:	ba 67 00 00 00       	mov    $0x67,%edx
80106965:	66 89 be 9a 00 00 00 	mov    %di,0x9a(%esi)
8010696c:	83 c0 08             	add    $0x8,%eax
8010696f:	66 89 96 98 00 00 00 	mov    %dx,0x98(%esi)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80106976:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
8010697b:	83 c1 08             	add    $0x8,%ecx
8010697e:	c1 e8 18             	shr    $0x18,%eax
80106981:	c1 e9 10             	shr    $0x10,%ecx
80106984:	88 86 9f 00 00 00    	mov    %al,0x9f(%esi)
8010698a:	88 8e 9c 00 00 00    	mov    %cl,0x9c(%esi)
80106990:	b9 99 40 00 00       	mov    $0x4099,%ecx
80106995:	66 89 8e 9d 00 00 00 	mov    %cx,0x9d(%esi)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
8010699c:	be 10 00 00 00       	mov    $0x10,%esi
  mycpu()->gdt[SEG_TSS].s = 0;
801069a1:	e8 ea ce ff ff       	call   80103890 <mycpu>
801069a6:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
801069ad:	e8 de ce ff ff       	call   80103890 <mycpu>
801069b2:	66 89 70 10          	mov    %si,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
801069b6:	8b 73 08             	mov    0x8(%ebx),%esi
801069b9:	81 c6 00 10 00 00    	add    $0x1000,%esi
801069bf:	e8 cc ce ff ff       	call   80103890 <mycpu>
801069c4:	89 70 0c             	mov    %esi,0xc(%eax)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
801069c7:	e8 c4 ce ff ff       	call   80103890 <mycpu>
801069cc:	66 89 78 6e          	mov    %di,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
801069d0:	b8 28 00 00 00       	mov    $0x28,%eax
801069d5:	0f 00 d8             	ltr    %ax
  lcr3(V2P(p->pgdir));  // switch to process's address space
801069d8:	8b 43 04             	mov    0x4(%ebx),%eax
801069db:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
801069e0:	0f 22 d8             	mov    %eax,%cr3
}
801069e3:	8d 65 f4             	lea    -0xc(%ebp),%esp
801069e6:	5b                   	pop    %ebx
801069e7:	5e                   	pop    %esi
801069e8:	5f                   	pop    %edi
801069e9:	5d                   	pop    %ebp
  popcli();
801069ea:	e9 21 da ff ff       	jmp    80104410 <popcli>
    panic("switchuvm: no process");
801069ef:	83 ec 0c             	sub    $0xc,%esp
801069f2:	68 b2 78 10 80       	push   $0x801078b2
801069f7:	e8 94 99 ff ff       	call   80100390 <panic>
    panic("switchuvm: no pgdir");
801069fc:	83 ec 0c             	sub    $0xc,%esp
801069ff:	68 dd 78 10 80       	push   $0x801078dd
80106a04:	e8 87 99 ff ff       	call   80100390 <panic>
    panic("switchuvm: no kstack");
80106a09:	83 ec 0c             	sub    $0xc,%esp
80106a0c:	68 c8 78 10 80       	push   $0x801078c8
80106a11:	e8 7a 99 ff ff       	call   80100390 <panic>
80106a16:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106a1d:	8d 76 00             	lea    0x0(%esi),%esi

80106a20 <inituvm>:
{
80106a20:	55                   	push   %ebp
80106a21:	89 e5                	mov    %esp,%ebp
80106a23:	57                   	push   %edi
80106a24:	56                   	push   %esi
80106a25:	53                   	push   %ebx
80106a26:	83 ec 1c             	sub    $0x1c,%esp
80106a29:	8b 45 08             	mov    0x8(%ebp),%eax
80106a2c:	8b 75 10             	mov    0x10(%ebp),%esi
80106a2f:	8b 7d 0c             	mov    0xc(%ebp),%edi
80106a32:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(sz >= PGSIZE)
80106a35:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
80106a3b:	77 49                	ja     80106a86 <inituvm+0x66>
  mem = kalloc();
80106a3d:	e8 6e bb ff ff       	call   801025b0 <kalloc>
  memset(mem, 0, PGSIZE);
80106a42:	83 ec 04             	sub    $0x4,%esp
80106a45:	68 00 10 00 00       	push   $0x1000
  mem = kalloc();
80106a4a:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
80106a4c:	6a 00                	push   $0x0
80106a4e:	50                   	push   %eax
80106a4f:	e8 6c db ff ff       	call   801045c0 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
80106a54:	58                   	pop    %eax
80106a55:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106a5b:	5a                   	pop    %edx
80106a5c:	6a 06                	push   $0x6
80106a5e:	b9 00 10 00 00       	mov    $0x1000,%ecx
80106a63:	31 d2                	xor    %edx,%edx
80106a65:	50                   	push   %eax
80106a66:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106a69:	e8 c2 fc ff ff       	call   80106730 <mappages>
  memmove(mem, init, sz);
80106a6e:	89 75 10             	mov    %esi,0x10(%ebp)
80106a71:	83 c4 10             	add    $0x10,%esp
80106a74:	89 7d 0c             	mov    %edi,0xc(%ebp)
80106a77:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
80106a7a:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106a7d:	5b                   	pop    %ebx
80106a7e:	5e                   	pop    %esi
80106a7f:	5f                   	pop    %edi
80106a80:	5d                   	pop    %ebp
  memmove(mem, init, sz);
80106a81:	e9 da db ff ff       	jmp    80104660 <memmove>
    panic("inituvm: more than a page");
80106a86:	83 ec 0c             	sub    $0xc,%esp
80106a89:	68 f1 78 10 80       	push   $0x801078f1
80106a8e:	e8 fd 98 ff ff       	call   80100390 <panic>
80106a93:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106a9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106aa0 <loaduvm>:
{
80106aa0:	55                   	push   %ebp
80106aa1:	89 e5                	mov    %esp,%ebp
80106aa3:	57                   	push   %edi
80106aa4:	56                   	push   %esi
80106aa5:	53                   	push   %ebx
80106aa6:	83 ec 1c             	sub    $0x1c,%esp
80106aa9:	8b 45 0c             	mov    0xc(%ebp),%eax
80106aac:	8b 75 18             	mov    0x18(%ebp),%esi
  if((uint) addr % PGSIZE != 0)
80106aaf:	a9 ff 0f 00 00       	test   $0xfff,%eax
80106ab4:	0f 85 8d 00 00 00    	jne    80106b47 <loaduvm+0xa7>
  for(i = 0; i < sz; i += PGSIZE){
80106aba:	01 f0                	add    %esi,%eax
80106abc:	89 f3                	mov    %esi,%ebx
80106abe:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(readi(ip, P2V(pa), offset+i, n) != n)
80106ac1:	8b 45 14             	mov    0x14(%ebp),%eax
80106ac4:	01 f0                	add    %esi,%eax
80106ac6:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(i = 0; i < sz; i += PGSIZE){
80106ac9:	85 f6                	test   %esi,%esi
80106acb:	75 11                	jne    80106ade <loaduvm+0x3e>
80106acd:	eb 61                	jmp    80106b30 <loaduvm+0x90>
80106acf:	90                   	nop
80106ad0:	81 eb 00 10 00 00    	sub    $0x1000,%ebx
80106ad6:	89 f0                	mov    %esi,%eax
80106ad8:	29 d8                	sub    %ebx,%eax
80106ada:	39 c6                	cmp    %eax,%esi
80106adc:	76 52                	jbe    80106b30 <loaduvm+0x90>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80106ade:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80106ae1:	8b 45 08             	mov    0x8(%ebp),%eax
80106ae4:	31 c9                	xor    %ecx,%ecx
80106ae6:	29 da                	sub    %ebx,%edx
80106ae8:	e8 c3 fb ff ff       	call   801066b0 <walkpgdir>
80106aed:	85 c0                	test   %eax,%eax
80106aef:	74 49                	je     80106b3a <loaduvm+0x9a>
    pa = PTE_ADDR(*pte);
80106af1:	8b 00                	mov    (%eax),%eax
    if(readi(ip, P2V(pa), offset+i, n) != n)
80106af3:	8b 4d e0             	mov    -0x20(%ebp),%ecx
    if(sz - i < PGSIZE)
80106af6:	bf 00 10 00 00       	mov    $0x1000,%edi
    pa = PTE_ADDR(*pte);
80106afb:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(sz - i < PGSIZE)
80106b00:	81 fb ff 0f 00 00    	cmp    $0xfff,%ebx
80106b06:	0f 46 fb             	cmovbe %ebx,%edi
    if(readi(ip, P2V(pa), offset+i, n) != n)
80106b09:	29 d9                	sub    %ebx,%ecx
80106b0b:	05 00 00 00 80       	add    $0x80000000,%eax
80106b10:	57                   	push   %edi
80106b11:	51                   	push   %ecx
80106b12:	50                   	push   %eax
80106b13:	ff 75 10             	pushl  0x10(%ebp)
80106b16:	e8 e5 ae ff ff       	call   80101a00 <readi>
80106b1b:	83 c4 10             	add    $0x10,%esp
80106b1e:	39 f8                	cmp    %edi,%eax
80106b20:	74 ae                	je     80106ad0 <loaduvm+0x30>
}
80106b22:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80106b25:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106b2a:	5b                   	pop    %ebx
80106b2b:	5e                   	pop    %esi
80106b2c:	5f                   	pop    %edi
80106b2d:	5d                   	pop    %ebp
80106b2e:	c3                   	ret    
80106b2f:	90                   	nop
80106b30:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80106b33:	31 c0                	xor    %eax,%eax
}
80106b35:	5b                   	pop    %ebx
80106b36:	5e                   	pop    %esi
80106b37:	5f                   	pop    %edi
80106b38:	5d                   	pop    %ebp
80106b39:	c3                   	ret    
      panic("loaduvm: address should exist");
80106b3a:	83 ec 0c             	sub    $0xc,%esp
80106b3d:	68 0b 79 10 80       	push   $0x8010790b
80106b42:	e8 49 98 ff ff       	call   80100390 <panic>
    panic("loaduvm: addr must be page aligned");
80106b47:	83 ec 0c             	sub    $0xc,%esp
80106b4a:	68 ac 79 10 80       	push   $0x801079ac
80106b4f:	e8 3c 98 ff ff       	call   80100390 <panic>
80106b54:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106b5b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106b5f:	90                   	nop

80106b60 <allocuvm>:
{
80106b60:	55                   	push   %ebp
80106b61:	89 e5                	mov    %esp,%ebp
80106b63:	57                   	push   %edi
80106b64:	56                   	push   %esi
80106b65:	53                   	push   %ebx
80106b66:	83 ec 1c             	sub    $0x1c,%esp
  if(newsz >= KERNBASE)
80106b69:	8b 7d 10             	mov    0x10(%ebp),%edi
80106b6c:	85 ff                	test   %edi,%edi
80106b6e:	0f 88 bc 00 00 00    	js     80106c30 <allocuvm+0xd0>
  if(newsz < oldsz)
80106b74:	3b 7d 0c             	cmp    0xc(%ebp),%edi
80106b77:	0f 82 a3 00 00 00    	jb     80106c20 <allocuvm+0xc0>
  a = PGROUNDUP(oldsz);
80106b7d:	8b 45 0c             	mov    0xc(%ebp),%eax
80106b80:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80106b86:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; a < newsz; a += PGSIZE){
80106b8c:	39 5d 10             	cmp    %ebx,0x10(%ebp)
80106b8f:	0f 86 8e 00 00 00    	jbe    80106c23 <allocuvm+0xc3>
80106b95:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80106b98:	8b 7d 08             	mov    0x8(%ebp),%edi
80106b9b:	eb 42                	jmp    80106bdf <allocuvm+0x7f>
80106b9d:	8d 76 00             	lea    0x0(%esi),%esi
    memset(mem, 0, PGSIZE);
80106ba0:	83 ec 04             	sub    $0x4,%esp
80106ba3:	68 00 10 00 00       	push   $0x1000
80106ba8:	6a 00                	push   $0x0
80106baa:	50                   	push   %eax
80106bab:	e8 10 da ff ff       	call   801045c0 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
80106bb0:	58                   	pop    %eax
80106bb1:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
80106bb7:	5a                   	pop    %edx
80106bb8:	6a 06                	push   $0x6
80106bba:	b9 00 10 00 00       	mov    $0x1000,%ecx
80106bbf:	89 da                	mov    %ebx,%edx
80106bc1:	50                   	push   %eax
80106bc2:	89 f8                	mov    %edi,%eax
80106bc4:	e8 67 fb ff ff       	call   80106730 <mappages>
80106bc9:	83 c4 10             	add    $0x10,%esp
80106bcc:	85 c0                	test   %eax,%eax
80106bce:	78 70                	js     80106c40 <allocuvm+0xe0>
  for(; a < newsz; a += PGSIZE){
80106bd0:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106bd6:	39 5d 10             	cmp    %ebx,0x10(%ebp)
80106bd9:	0f 86 a1 00 00 00    	jbe    80106c80 <allocuvm+0x120>
    mem = kalloc();
80106bdf:	e8 cc b9 ff ff       	call   801025b0 <kalloc>
80106be4:	89 c6                	mov    %eax,%esi
    if(mem == 0){
80106be6:	85 c0                	test   %eax,%eax
80106be8:	75 b6                	jne    80106ba0 <allocuvm+0x40>
      cprintf("allocuvm out of memory\n");
80106bea:	83 ec 0c             	sub    $0xc,%esp
80106bed:	68 29 79 10 80       	push   $0x80107929
80106bf2:	e8 b9 9a ff ff       	call   801006b0 <cprintf>
  if(newsz >= oldsz)
80106bf7:	83 c4 10             	add    $0x10,%esp
80106bfa:	8b 45 0c             	mov    0xc(%ebp),%eax
80106bfd:	39 45 10             	cmp    %eax,0x10(%ebp)
80106c00:	74 2e                	je     80106c30 <allocuvm+0xd0>
80106c02:	89 c1                	mov    %eax,%ecx
80106c04:	8b 55 10             	mov    0x10(%ebp),%edx
80106c07:	8b 45 08             	mov    0x8(%ebp),%eax
      return 0;
80106c0a:	31 ff                	xor    %edi,%edi
80106c0c:	e8 af fb ff ff       	call   801067c0 <deallocuvm.part.0>
}
80106c11:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106c14:	89 f8                	mov    %edi,%eax
80106c16:	5b                   	pop    %ebx
80106c17:	5e                   	pop    %esi
80106c18:	5f                   	pop    %edi
80106c19:	5d                   	pop    %ebp
80106c1a:	c3                   	ret    
80106c1b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106c1f:	90                   	nop
    return oldsz;
80106c20:	8b 7d 0c             	mov    0xc(%ebp),%edi
}
80106c23:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106c26:	89 f8                	mov    %edi,%eax
80106c28:	5b                   	pop    %ebx
80106c29:	5e                   	pop    %esi
80106c2a:	5f                   	pop    %edi
80106c2b:	5d                   	pop    %ebp
80106c2c:	c3                   	ret    
80106c2d:	8d 76 00             	lea    0x0(%esi),%esi
80106c30:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
80106c33:	31 ff                	xor    %edi,%edi
}
80106c35:	5b                   	pop    %ebx
80106c36:	89 f8                	mov    %edi,%eax
80106c38:	5e                   	pop    %esi
80106c39:	5f                   	pop    %edi
80106c3a:	5d                   	pop    %ebp
80106c3b:	c3                   	ret    
80106c3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      cprintf("allocuvm out of memory (2)\n");
80106c40:	83 ec 0c             	sub    $0xc,%esp
80106c43:	68 41 79 10 80       	push   $0x80107941
80106c48:	e8 63 9a ff ff       	call   801006b0 <cprintf>
  if(newsz >= oldsz)
80106c4d:	83 c4 10             	add    $0x10,%esp
80106c50:	8b 45 0c             	mov    0xc(%ebp),%eax
80106c53:	39 45 10             	cmp    %eax,0x10(%ebp)
80106c56:	74 0d                	je     80106c65 <allocuvm+0x105>
80106c58:	89 c1                	mov    %eax,%ecx
80106c5a:	8b 55 10             	mov    0x10(%ebp),%edx
80106c5d:	8b 45 08             	mov    0x8(%ebp),%eax
80106c60:	e8 5b fb ff ff       	call   801067c0 <deallocuvm.part.0>
      kfree(mem);
80106c65:	83 ec 0c             	sub    $0xc,%esp
      return 0;
80106c68:	31 ff                	xor    %edi,%edi
      kfree(mem);
80106c6a:	56                   	push   %esi
80106c6b:	e8 80 b7 ff ff       	call   801023f0 <kfree>
      return 0;
80106c70:	83 c4 10             	add    $0x10,%esp
}
80106c73:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106c76:	89 f8                	mov    %edi,%eax
80106c78:	5b                   	pop    %ebx
80106c79:	5e                   	pop    %esi
80106c7a:	5f                   	pop    %edi
80106c7b:	5d                   	pop    %ebp
80106c7c:	c3                   	ret    
80106c7d:	8d 76 00             	lea    0x0(%esi),%esi
80106c80:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80106c83:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106c86:	5b                   	pop    %ebx
80106c87:	5e                   	pop    %esi
80106c88:	89 f8                	mov    %edi,%eax
80106c8a:	5f                   	pop    %edi
80106c8b:	5d                   	pop    %ebp
80106c8c:	c3                   	ret    
80106c8d:	8d 76 00             	lea    0x0(%esi),%esi

80106c90 <deallocuvm>:
{
80106c90:	55                   	push   %ebp
80106c91:	89 e5                	mov    %esp,%ebp
80106c93:	8b 55 0c             	mov    0xc(%ebp),%edx
80106c96:	8b 4d 10             	mov    0x10(%ebp),%ecx
80106c99:	8b 45 08             	mov    0x8(%ebp),%eax
  if(newsz >= oldsz)
80106c9c:	39 d1                	cmp    %edx,%ecx
80106c9e:	73 10                	jae    80106cb0 <deallocuvm+0x20>
}
80106ca0:	5d                   	pop    %ebp
80106ca1:	e9 1a fb ff ff       	jmp    801067c0 <deallocuvm.part.0>
80106ca6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106cad:	8d 76 00             	lea    0x0(%esi),%esi
80106cb0:	89 d0                	mov    %edx,%eax
80106cb2:	5d                   	pop    %ebp
80106cb3:	c3                   	ret    
80106cb4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106cbb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106cbf:	90                   	nop

80106cc0 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80106cc0:	55                   	push   %ebp
80106cc1:	89 e5                	mov    %esp,%ebp
80106cc3:	57                   	push   %edi
80106cc4:	56                   	push   %esi
80106cc5:	53                   	push   %ebx
80106cc6:	83 ec 0c             	sub    $0xc,%esp
80106cc9:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
80106ccc:	85 f6                	test   %esi,%esi
80106cce:	74 59                	je     80106d29 <freevm+0x69>
  if(newsz >= oldsz)
80106cd0:	31 c9                	xor    %ecx,%ecx
80106cd2:	ba 00 00 00 80       	mov    $0x80000000,%edx
80106cd7:	89 f0                	mov    %esi,%eax
80106cd9:	89 f3                	mov    %esi,%ebx
80106cdb:	e8 e0 fa ff ff       	call   801067c0 <deallocuvm.part.0>
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80106ce0:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
80106ce6:	eb 0f                	jmp    80106cf7 <freevm+0x37>
80106ce8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106cef:	90                   	nop
80106cf0:	83 c3 04             	add    $0x4,%ebx
80106cf3:	39 df                	cmp    %ebx,%edi
80106cf5:	74 23                	je     80106d1a <freevm+0x5a>
    if(pgdir[i] & PTE_P){
80106cf7:	8b 03                	mov    (%ebx),%eax
80106cf9:	a8 01                	test   $0x1,%al
80106cfb:	74 f3                	je     80106cf0 <freevm+0x30>
      char * v = P2V(PTE_ADDR(pgdir[i]));
80106cfd:	25 00 f0 ff ff       	and    $0xfffff000,%eax
      kfree(v);
80106d02:	83 ec 0c             	sub    $0xc,%esp
80106d05:	83 c3 04             	add    $0x4,%ebx
      char * v = P2V(PTE_ADDR(pgdir[i]));
80106d08:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
80106d0d:	50                   	push   %eax
80106d0e:	e8 dd b6 ff ff       	call   801023f0 <kfree>
80106d13:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
80106d16:	39 df                	cmp    %ebx,%edi
80106d18:	75 dd                	jne    80106cf7 <freevm+0x37>
    }
  }
  kfree((char*)pgdir);
80106d1a:	89 75 08             	mov    %esi,0x8(%ebp)
}
80106d1d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106d20:	5b                   	pop    %ebx
80106d21:	5e                   	pop    %esi
80106d22:	5f                   	pop    %edi
80106d23:	5d                   	pop    %ebp
  kfree((char*)pgdir);
80106d24:	e9 c7 b6 ff ff       	jmp    801023f0 <kfree>
    panic("freevm: no pgdir");
80106d29:	83 ec 0c             	sub    $0xc,%esp
80106d2c:	68 5d 79 10 80       	push   $0x8010795d
80106d31:	e8 5a 96 ff ff       	call   80100390 <panic>
80106d36:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106d3d:	8d 76 00             	lea    0x0(%esi),%esi

80106d40 <setupkvm>:
{
80106d40:	55                   	push   %ebp
80106d41:	89 e5                	mov    %esp,%ebp
80106d43:	56                   	push   %esi
80106d44:	53                   	push   %ebx
  if((pgdir = (pde_t*)kalloc()) == 0)
80106d45:	e8 66 b8 ff ff       	call   801025b0 <kalloc>
80106d4a:	89 c6                	mov    %eax,%esi
80106d4c:	85 c0                	test   %eax,%eax
80106d4e:	74 42                	je     80106d92 <setupkvm+0x52>
  memset(pgdir, 0, PGSIZE);
80106d50:	83 ec 04             	sub    $0x4,%esp
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80106d53:	bb 20 a4 10 80       	mov    $0x8010a420,%ebx
  memset(pgdir, 0, PGSIZE);
80106d58:	68 00 10 00 00       	push   $0x1000
80106d5d:	6a 00                	push   $0x0
80106d5f:	50                   	push   %eax
80106d60:	e8 5b d8 ff ff       	call   801045c0 <memset>
80106d65:	83 c4 10             	add    $0x10,%esp
                (uint)k->phys_start, k->perm) < 0) {
80106d68:	8b 43 04             	mov    0x4(%ebx),%eax
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
80106d6b:	83 ec 08             	sub    $0x8,%esp
80106d6e:	8b 4b 08             	mov    0x8(%ebx),%ecx
80106d71:	ff 73 0c             	pushl  0xc(%ebx)
80106d74:	8b 13                	mov    (%ebx),%edx
80106d76:	50                   	push   %eax
80106d77:	29 c1                	sub    %eax,%ecx
80106d79:	89 f0                	mov    %esi,%eax
80106d7b:	e8 b0 f9 ff ff       	call   80106730 <mappages>
80106d80:	83 c4 10             	add    $0x10,%esp
80106d83:	85 c0                	test   %eax,%eax
80106d85:	78 19                	js     80106da0 <setupkvm+0x60>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80106d87:	83 c3 10             	add    $0x10,%ebx
80106d8a:	81 fb 60 a4 10 80    	cmp    $0x8010a460,%ebx
80106d90:	75 d6                	jne    80106d68 <setupkvm+0x28>
}
80106d92:	8d 65 f8             	lea    -0x8(%ebp),%esp
80106d95:	89 f0                	mov    %esi,%eax
80106d97:	5b                   	pop    %ebx
80106d98:	5e                   	pop    %esi
80106d99:	5d                   	pop    %ebp
80106d9a:	c3                   	ret    
80106d9b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106d9f:	90                   	nop
      freevm(pgdir);
80106da0:	83 ec 0c             	sub    $0xc,%esp
80106da3:	56                   	push   %esi
      return 0;
80106da4:	31 f6                	xor    %esi,%esi
      freevm(pgdir);
80106da6:	e8 15 ff ff ff       	call   80106cc0 <freevm>
      return 0;
80106dab:	83 c4 10             	add    $0x10,%esp
}
80106dae:	8d 65 f8             	lea    -0x8(%ebp),%esp
80106db1:	89 f0                	mov    %esi,%eax
80106db3:	5b                   	pop    %ebx
80106db4:	5e                   	pop    %esi
80106db5:	5d                   	pop    %ebp
80106db6:	c3                   	ret    
80106db7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106dbe:	66 90                	xchg   %ax,%ax

80106dc0 <kvmalloc>:
{
80106dc0:	55                   	push   %ebp
80106dc1:	89 e5                	mov    %esp,%ebp
80106dc3:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80106dc6:	e8 75 ff ff ff       	call   80106d40 <setupkvm>
80106dcb:	a3 a4 54 11 80       	mov    %eax,0x801154a4
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80106dd0:	05 00 00 00 80       	add    $0x80000000,%eax
80106dd5:	0f 22 d8             	mov    %eax,%cr3
}
80106dd8:	c9                   	leave  
80106dd9:	c3                   	ret    
80106dda:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106de0 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80106de0:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80106de1:	31 c9                	xor    %ecx,%ecx
{
80106de3:	89 e5                	mov    %esp,%ebp
80106de5:	83 ec 08             	sub    $0x8,%esp
  pte = walkpgdir(pgdir, uva, 0);
80106de8:	8b 55 0c             	mov    0xc(%ebp),%edx
80106deb:	8b 45 08             	mov    0x8(%ebp),%eax
80106dee:	e8 bd f8 ff ff       	call   801066b0 <walkpgdir>
  if(pte == 0)
80106df3:	85 c0                	test   %eax,%eax
80106df5:	74 05                	je     80106dfc <clearpteu+0x1c>
    panic("clearpteu");
  *pte &= ~PTE_U;
80106df7:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
80106dfa:	c9                   	leave  
80106dfb:	c3                   	ret    
    panic("clearpteu");
80106dfc:	83 ec 0c             	sub    $0xc,%esp
80106dff:	68 6e 79 10 80       	push   $0x8010796e
80106e04:	e8 87 95 ff ff       	call   80100390 <panic>
80106e09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106e10 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80106e10:	55                   	push   %ebp
80106e11:	89 e5                	mov    %esp,%ebp
80106e13:	57                   	push   %edi
80106e14:	56                   	push   %esi
80106e15:	53                   	push   %ebx
80106e16:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
80106e19:	e8 22 ff ff ff       	call   80106d40 <setupkvm>
80106e1e:	89 45 e0             	mov    %eax,-0x20(%ebp)
80106e21:	85 c0                	test   %eax,%eax
80106e23:	0f 84 9f 00 00 00    	je     80106ec8 <copyuvm+0xb8>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80106e29:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80106e2c:	85 c9                	test   %ecx,%ecx
80106e2e:	0f 84 94 00 00 00    	je     80106ec8 <copyuvm+0xb8>
80106e34:	31 ff                	xor    %edi,%edi
80106e36:	eb 4a                	jmp    80106e82 <copyuvm+0x72>
80106e38:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106e3f:	90                   	nop
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
80106e40:	83 ec 04             	sub    $0x4,%esp
80106e43:	81 c3 00 00 00 80    	add    $0x80000000,%ebx
80106e49:	68 00 10 00 00       	push   $0x1000
80106e4e:	53                   	push   %ebx
80106e4f:	50                   	push   %eax
80106e50:	e8 0b d8 ff ff       	call   80104660 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
80106e55:	58                   	pop    %eax
80106e56:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
80106e5c:	5a                   	pop    %edx
80106e5d:	ff 75 e4             	pushl  -0x1c(%ebp)
80106e60:	b9 00 10 00 00       	mov    $0x1000,%ecx
80106e65:	89 fa                	mov    %edi,%edx
80106e67:	50                   	push   %eax
80106e68:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106e6b:	e8 c0 f8 ff ff       	call   80106730 <mappages>
80106e70:	83 c4 10             	add    $0x10,%esp
80106e73:	85 c0                	test   %eax,%eax
80106e75:	78 61                	js     80106ed8 <copyuvm+0xc8>
  for(i = 0; i < sz; i += PGSIZE){
80106e77:	81 c7 00 10 00 00    	add    $0x1000,%edi
80106e7d:	39 7d 0c             	cmp    %edi,0xc(%ebp)
80106e80:	76 46                	jbe    80106ec8 <copyuvm+0xb8>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80106e82:	8b 45 08             	mov    0x8(%ebp),%eax
80106e85:	31 c9                	xor    %ecx,%ecx
80106e87:	89 fa                	mov    %edi,%edx
80106e89:	e8 22 f8 ff ff       	call   801066b0 <walkpgdir>
80106e8e:	85 c0                	test   %eax,%eax
80106e90:	74 61                	je     80106ef3 <copyuvm+0xe3>
    if(!(*pte & PTE_P))
80106e92:	8b 00                	mov    (%eax),%eax
80106e94:	a8 01                	test   $0x1,%al
80106e96:	74 4e                	je     80106ee6 <copyuvm+0xd6>
    pa = PTE_ADDR(*pte);
80106e98:	89 c3                	mov    %eax,%ebx
    flags = PTE_FLAGS(*pte);
80106e9a:	25 ff 0f 00 00       	and    $0xfff,%eax
80106e9f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    pa = PTE_ADDR(*pte);
80106ea2:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
    if((mem = kalloc()) == 0)
80106ea8:	e8 03 b7 ff ff       	call   801025b0 <kalloc>
80106ead:	89 c6                	mov    %eax,%esi
80106eaf:	85 c0                	test   %eax,%eax
80106eb1:	75 8d                	jne    80106e40 <copyuvm+0x30>
    }
  }
  return d;

bad:
  freevm(d);
80106eb3:	83 ec 0c             	sub    $0xc,%esp
80106eb6:	ff 75 e0             	pushl  -0x20(%ebp)
80106eb9:	e8 02 fe ff ff       	call   80106cc0 <freevm>
  return 0;
80106ebe:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
80106ec5:	83 c4 10             	add    $0x10,%esp
}
80106ec8:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106ecb:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106ece:	5b                   	pop    %ebx
80106ecf:	5e                   	pop    %esi
80106ed0:	5f                   	pop    %edi
80106ed1:	5d                   	pop    %ebp
80106ed2:	c3                   	ret    
80106ed3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106ed7:	90                   	nop
      kfree(mem);
80106ed8:	83 ec 0c             	sub    $0xc,%esp
80106edb:	56                   	push   %esi
80106edc:	e8 0f b5 ff ff       	call   801023f0 <kfree>
      goto bad;
80106ee1:	83 c4 10             	add    $0x10,%esp
80106ee4:	eb cd                	jmp    80106eb3 <copyuvm+0xa3>
      panic("copyuvm: page not present");
80106ee6:	83 ec 0c             	sub    $0xc,%esp
80106ee9:	68 92 79 10 80       	push   $0x80107992
80106eee:	e8 9d 94 ff ff       	call   80100390 <panic>
      panic("copyuvm: pte should exist");
80106ef3:	83 ec 0c             	sub    $0xc,%esp
80106ef6:	68 78 79 10 80       	push   $0x80107978
80106efb:	e8 90 94 ff ff       	call   80100390 <panic>

80106f00 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80106f00:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80106f01:	31 c9                	xor    %ecx,%ecx
{
80106f03:	89 e5                	mov    %esp,%ebp
80106f05:	83 ec 08             	sub    $0x8,%esp
  pte = walkpgdir(pgdir, uva, 0);
80106f08:	8b 55 0c             	mov    0xc(%ebp),%edx
80106f0b:	8b 45 08             	mov    0x8(%ebp),%eax
80106f0e:	e8 9d f7 ff ff       	call   801066b0 <walkpgdir>
  if((*pte & PTE_P) == 0)
80106f13:	8b 00                	mov    (%eax),%eax
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
}
80106f15:	c9                   	leave  
  if((*pte & PTE_U) == 0)
80106f16:	89 c2                	mov    %eax,%edx
  return (char*)P2V(PTE_ADDR(*pte));
80106f18:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  if((*pte & PTE_U) == 0)
80106f1d:	83 e2 05             	and    $0x5,%edx
  return (char*)P2V(PTE_ADDR(*pte));
80106f20:	05 00 00 00 80       	add    $0x80000000,%eax
80106f25:	83 fa 05             	cmp    $0x5,%edx
80106f28:	ba 00 00 00 00       	mov    $0x0,%edx
80106f2d:	0f 45 c2             	cmovne %edx,%eax
}
80106f30:	c3                   	ret    
80106f31:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106f38:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106f3f:	90                   	nop

80106f40 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80106f40:	55                   	push   %ebp
80106f41:	89 e5                	mov    %esp,%ebp
80106f43:	57                   	push   %edi
80106f44:	56                   	push   %esi
80106f45:	53                   	push   %ebx
80106f46:	83 ec 0c             	sub    $0xc,%esp
80106f49:	8b 75 14             	mov    0x14(%ebp),%esi
80106f4c:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80106f4f:	85 f6                	test   %esi,%esi
80106f51:	75 38                	jne    80106f8b <copyout+0x4b>
80106f53:	eb 6b                	jmp    80106fc0 <copyout+0x80>
80106f55:	8d 76 00             	lea    0x0(%esi),%esi
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (va - va0);
80106f58:	8b 55 0c             	mov    0xc(%ebp),%edx
80106f5b:	89 fb                	mov    %edi,%ebx
80106f5d:	29 d3                	sub    %edx,%ebx
80106f5f:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    if(n > len)
80106f65:	39 f3                	cmp    %esi,%ebx
80106f67:	0f 47 de             	cmova  %esi,%ebx
      n = len;
    memmove(pa0 + (va - va0), buf, n);
80106f6a:	29 fa                	sub    %edi,%edx
80106f6c:	83 ec 04             	sub    $0x4,%esp
80106f6f:	01 c2                	add    %eax,%edx
80106f71:	53                   	push   %ebx
80106f72:	ff 75 10             	pushl  0x10(%ebp)
80106f75:	52                   	push   %edx
80106f76:	e8 e5 d6 ff ff       	call   80104660 <memmove>
    len -= n;
    buf += n;
80106f7b:	01 5d 10             	add    %ebx,0x10(%ebp)
    va = va0 + PGSIZE;
80106f7e:	8d 97 00 10 00 00    	lea    0x1000(%edi),%edx
  while(len > 0){
80106f84:	83 c4 10             	add    $0x10,%esp
80106f87:	29 de                	sub    %ebx,%esi
80106f89:	74 35                	je     80106fc0 <copyout+0x80>
    va0 = (uint)PGROUNDDOWN(va);
80106f8b:	89 d7                	mov    %edx,%edi
    pa0 = uva2ka(pgdir, (char*)va0);
80106f8d:	83 ec 08             	sub    $0x8,%esp
    va0 = (uint)PGROUNDDOWN(va);
80106f90:	89 55 0c             	mov    %edx,0xc(%ebp)
80106f93:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    pa0 = uva2ka(pgdir, (char*)va0);
80106f99:	57                   	push   %edi
80106f9a:	ff 75 08             	pushl  0x8(%ebp)
80106f9d:	e8 5e ff ff ff       	call   80106f00 <uva2ka>
    if(pa0 == 0)
80106fa2:	83 c4 10             	add    $0x10,%esp
80106fa5:	85 c0                	test   %eax,%eax
80106fa7:	75 af                	jne    80106f58 <copyout+0x18>
  }
  return 0;
}
80106fa9:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80106fac:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106fb1:	5b                   	pop    %ebx
80106fb2:	5e                   	pop    %esi
80106fb3:	5f                   	pop    %edi
80106fb4:	5d                   	pop    %ebp
80106fb5:	c3                   	ret    
80106fb6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106fbd:	8d 76 00             	lea    0x0(%esi),%esi
80106fc0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80106fc3:	31 c0                	xor    %eax,%eax
}
80106fc5:	5b                   	pop    %ebx
80106fc6:	5e                   	pop    %esi
80106fc7:	5f                   	pop    %edi
80106fc8:	5d                   	pop    %ebp
80106fc9:	c3                   	ret    
