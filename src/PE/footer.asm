; PE with NT headers in appended data

; Ange Albertini, BSD LICENCE 2009-2013

%include 'consts.inc'

IMAGEBASE equ 400000h
org IMAGEBASE
bits 32

SECTIONALIGN equ 1000h
FILEALIGN equ 200h

istruc IMAGE_DOS_HEADER
    at IMAGE_DOS_HEADER.e_magic,  db 'MZ'
    at IMAGE_DOS_HEADER.e_lfanew, dd NT_Headers - IMAGEBASE - (SECTIONALIGN - FILEALIGN)
iend

section progbits vstart=IMAGEBASE + SECTIONALIGN align=FILEALIGN

%include 'code_printf.inc'

Msg db " * NT headers at the bottom of the file", 0ah, 0
_d

%include 'imports_printfexitprocess.inc'

align FILEALIGN, db 0

; align 4, db 0 ; we're already aligned

%include 'nthd_std.inc'

%include 'dd_imports.inc'

SIZEOFOPTIONALHEADER equ $ - OptionalHeader
SectionHeader:
istruc IMAGE_SECTION_HEADER
    at IMAGE_SECTION_HEADER.VirtualSize,      dd SECTIONALIGN
    at IMAGE_SECTION_HEADER.VirtualAddress,   dd SECTIONALIGN
    at IMAGE_SECTION_HEADER.SizeOfRawData,    dd FILEALIGN
    at IMAGE_SECTION_HEADER.PointerToRawData, dd FILEALIGN
    at IMAGE_SECTION_HEADER.Characteristics,  dd IMAGE_SCN_MEM_EXECUTE | IMAGE_SCN_MEM_WRITE
iend
NUMBEROFSECTIONS equ ($ - SectionHeader) / IMAGE_SECTION_HEADER_size
SIZEOFIMAGE EQU $ - IMAGEBASE - (SECTIONALIGN - FILEALIGN)
SIZEOFHEADERS equ $ - IMAGEBASE - (SECTIONALIGN - FILEALIGN)
