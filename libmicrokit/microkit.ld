/*
 * Copyright 2021, Breakaway Consulting Pty. Ltd.
 *
 * SPDX-License-Identifier: BSD-2-Clause
 */
PHDRS
{
    text PT_LOAD FLAGS(5);
    rodata PT_LOAD FLAGS(4);
    data PT_LOAD FLAGS(6);
    bss PT_LOAD FLAGS(6);
}

ENTRY(_start);

SECTIONS
{
    . = 0x200000;

    .text :
    {
        _text = .;
        *(.text.start)
        *(.text*)
        _text_end = .;
    } :text

    . = ALIGN(0x1000);

    .rodata :
    {
	_rodata = .;
	*(.rodata)
	_rodata_end = .;
    } :rodata

    . = ALIGN(0x1000);

    /* For some reason the ABI puts init array
     * into writable memory, so we have to follow suit */
    .init_array :
    {
        PROVIDE(__init_array_start = .);
        KEEP (*(SORT(.init_array.*)))
        KEEP (*(.init_array*))
        PROVIDE(__init_array_end = .);
    } :data

    .data :
    {
        _data = .;
        *(.data)
        *libmicrokit.a:*(.bss*)
        . = ALIGN(8);
        __global_pointer$ = . + 0x800;
        *(.srodata)
        *(.sdata)
        _data_end = .;
    } :data

    . = ALIGN(0x1000);

    .bss  :
    {
        _bss = .;
        *(.sbss)
        *(.bss)
        *(.bss*)
        *(COMMON)
        . = ALIGN(4);
        _bss_end = .;
    } :bss

    . = ALIGN(0x1000);
    .ipc_buffer (NOLOAD): {
        __sel4_ipc_buffer_obj = .;
    }
}
