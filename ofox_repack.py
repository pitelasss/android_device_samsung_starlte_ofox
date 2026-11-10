#!/usr/bin/env python3
# Repacks an OrangeFox/TWRP recovery image (Android boot header v0/v1/v2) into the
# Samsung Exynos 9810 format: header v0 with the DTBH device tree in the "dt" slot,
# followed by SEANDROIDENFORCE.
#   ofox_repack.py <input.img> <dtb.img> <output.img> [board] [max_size]
import hashlib, struct, sys

if len(sys.argv) < 4:
    sys.exit('uso: ofox_repack.py <input.img> <dtb.img> <output.img> [board] [max_size]')
src, dtb_path, out = sys.argv[1:4]
board = sys.argv[4] if len(sys.argv) > 4 else ''
max_size = int(sys.argv[5]) if len(sys.argv) > 5 else 67108864

d = open(src, 'rb').read()
if d[:8] != b'ANDROID!':
    sys.exit('ERRO: %s nao e uma boot image Android' % src)
ksize, kaddr, rsize, raddr, ssize, saddr, taddr, page, hver = struct.unpack('<9I', d[8:44])
if hver > 2:
    sys.exit('ERRO: header_version %d nao suportado' % hver)
cmdline = d[64:64 + 512].split(b'\0')[0]
pad = lambda n: (n + page - 1) // page * page
kernel = d[page:page + ksize]
ramdisk = d[page + pad(ksize):page + pad(ksize) + rsize]
if ramdisk[:2] != b'\x1f\x8b':
    sys.exit('ERRO: o ramdisk nao e gzip (o kernel DS-ACK so descomprime gzip). '
             'Nao uses OF_USE_LZMA_COMPRESSION / LZMA_RAMDISK_TARGETS.')
if kernel[56:60] != b'ARMd':
    sys.exit('ERRO: kernel sem cabecalho arm64')
dt = open(dtb_path, 'rb').read()
if dt[:4] != b'DTBH':
    sys.exit('ERRO: %s nao e um DTB Samsung (DTBH)' % dtb_path)

BASE, PAGE = 0x10000000, 2048
p = lambda b: b + b'\0' * (-len(b) % PAGE)
sha = hashlib.sha1()
for x in (kernel, ramdisk, b'', dt):
    sha.update(x); sha.update(struct.pack('<I', len(x)))
hdr = struct.pack('<8s10I16s512s32s1024s', b'ANDROID!',
    len(kernel), BASE + 0x8000, len(ramdisk), BASE + 0x01000000,
    0, BASE + 0x00f00000, BASE + 0x100, PAGE, len(dt), 0,
    board.encode(), cmdline, sha.digest().ljust(32, b'\0'), b'')
img = p(hdr) + p(kernel) + p(ramdisk) + p(dt) + b'SEANDROIDENFORCE'
open(out, 'wb').write(img)
print('repack OK: %s  %d bytes (kernel %d, ramdisk %d gzip, dt %d), cmdline=%r'
      % (out, len(img), len(kernel), len(ramdisk), len(dt), cmdline.decode()))
if len(img) > max_size:
    sys.exit('ERRO: imagem com %d bytes, maior que a particao (%d)' % (len(img), max_size))
