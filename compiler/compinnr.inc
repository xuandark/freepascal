{
    This file is part of the Free Pascal run time library and compiler.
    Copyright (c) 1998-2002 by the Free Pascal development team

    Internal Function/Constant Evaluator numbers

    See the file COPYING.FPC, included in this distribution,
    for details about the copyright.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

 **********************************************************************}

const
{ Internal functions }
   in_lo_word           = 1;
   in_hi_word           = 2;
   in_lo_long           = 3;
   in_hi_long           = 4;
   in_ord_x             = 5;
   in_length_x          = 6;
   in_chr_byte          = 7;
   in_write_x           = 14;
   in_writeln_x         = 15;
   in_read_x            = 16;
   in_readln_x          = 17;
   in_concat_x          = 18;
   in_assigned_x        = 19;
   in_str_x_string      = 20;
   in_ofs_x             = 21;
   in_sizeof_x          = 22;
   in_typeof_x          = 23;
   in_val_x             = 24;
   in_reset_x           = 25;
   in_rewrite_x         = 26;
   in_low_x             = 27;
   in_high_x            = 28;
   in_seg_x             = 29;
   in_pred_x            = 30;
   in_succ_x            = 31;
   in_reset_typedfile   = 32;
   in_rewrite_typedfile = 33;
   in_settextbuf_file_x = 34;
   in_inc_x             = 35;
   in_dec_x             = 36;
   in_include_x_y       = 37;
   in_exclude_x_y       = 38;
   in_break             = 39;
   in_continue          = 40;
   in_assert_x_y        = 41;
   in_addr_x            = 42;
   in_typeinfo_x        = 43;
   in_setlength_x       = 44;
   in_finalize_x        = 45;
   in_new_x             = 46;
   in_dispose_x         = 47;
   in_exit              = 48;
   in_copy_x            = 49;
   in_initialize_x      = 50;
   in_leave             = 51; {macpas}
   in_cycle             = 52; {macpas}
   in_slice_x           = 53;
   in_unaligned_x       = 54;
   in_get_frame         = 56;
   in_get_caller_addr   = 57;
   in_get_caller_frame  = 58;
   in_pack_x_y_z        = 59;
   in_unpack_x_y_z      = 60;
   in_bitsizeof_x       = 61;
   in_writestr_x        = 62;
   in_readstr_x         = 63;
   in_abs_long          = 64;
   in_ror_x             = 65;
   in_ror_x_x           = 66;
   in_rol_x             = 67;
   in_rol_x_x           = 68;
   in_objc_selector_x   = 69;


{ Internal constant functions }
   in_const_sqr        = 100;
   in_const_abs        = 101;
   in_const_odd        = 102;
   in_const_ptr        = 103;
   in_const_swap_word  = 104;
   in_const_swap_long  = 105;
   in_lo_qword         = 106;
   in_hi_qword         = 107;
   in_const_swap_qword = 108;
   in_prefetch_var     = 109;

{ FPU functions }
   in_trunc_real       = 120;
   in_round_real       = 121;
   in_frac_real        = 122;
   in_int_real         = 123;
   in_exp_real         = 124;
   in_cos_real         = 125;
   in_pi_real          = 126;
   in_abs_real         = 127;
   in_sqr_real         = 128;
   in_sqrt_real        = 129;
   in_arctan_real      = 130;
   in_ln_real          = 131;
   in_sin_real         = 132;

{ MMX functions }
  { these contants are used by the mmx unit }

   { MMX }
   in_mmx_pcmpeqb      = 200;
   in_mmx_pcmpeqw      = 201;
   in_mmx_pcmpeqd      = 202;
   in_mmx_pcmpgtb      = 203;
   in_mmx_pcmpgtw      = 204;
   in_mmx_pcmpgtd      = 205;

   { 3DNow }

   { SSE }

