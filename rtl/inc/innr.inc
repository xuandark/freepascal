{
    This file is part of the Free Pascal run time library and compiler.
    Copyright (c) 1999-2000 by the Free Pascal development team

    Internal Function/Constant Evaluator numbers

    See the file COPYING.FPC, included in this distribution,
    for details about the copyright.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

 **********************************************************************}

const
{ Internal functions }
   fpc_in_lo_word           = 1;
   fpc_in_hi_word           = 2;
   fpc_in_lo_long           = 3;
   fpc_in_hi_long           = 4;
   fpc_in_ord_x             = 5;
   fpc_in_length_string     = 6;
   fpc_in_chr_byte          = 7;
   fpc_in_write_x           = 14;
   fpc_in_writeln_x         = 15;
   fpc_in_read_x            = 16;
   fpc_in_readln_x          = 17;
   fpc_in_concat_x          = 18;
   fpc_in_assigned_x        = 19;
   fpc_in_str_x_string      = 20;
   fpc_in_ofs_x             = 21;
   fpc_in_sizeof_x          = 22;
   fpc_in_typeof_x          = 23;
   fpc_in_val_x             = 24;
   fpc_in_reset_x           = 25;
   fpc_in_rewrite_x         = 26;
   fpc_in_low_x             = 27;
   fpc_in_high_x            = 28;
   fpc_in_seg_x             = 29;
   fpc_in_pred_x            = 30;
   fpc_in_succ_x            = 31;
   fpc_in_reset_typedfile   = 32;
   fpc_in_rewrite_typedfile = 33;
   fpc_in_settextbuf_file_x = 34;
   fpc_in_inc_x             = 35;
   fpc_in_dec_x             = 36;
   fpc_in_include_x_y       = 37;
   fpc_in_exclude_x_y       = 38;
   fpc_in_break             = 39;
   fpc_in_continue          = 40;
   fpc_in_assert_x_y        = 41;
   fpc_in_addr_x            = 42;
   fpc_in_typeinfo_x        = 43;
   fpc_in_setlength_x       = 44;
   fpc_in_finalize_x        = 45;
   fpc_in_new_x             = 46;
   fpc_in_dispose_x         = 47;
   fpc_in_exit              = 48;
   fpc_in_copy_x            = 49;
   fpc_in_initialize_x      = 50;
   fpc_in_leave             = 51; {macpas}
   fpc_in_cycle             = 52; {macpas}
   fpc_in_slice             = 53;
   fpc_in_move_x            = 54;
   fpc_in_fillchar_x        = 55;
   fpc_in_get_frame         = 56;
   fpc_in_get_caller_addr   = 57;
   fpc_in_get_caller_frame  = 58;
   fpc_in_pack_x_y_z        = 59;
   fpc_in_unpack_x_y_z      = 60;
   fpc_in_bitsizeof_x       = 61;
   fpc_in_writestr_x        = 62;
   fpc_in_readstr_x         = 63;
   fpc_in_abs_long          = 64;
   fpc_in_ror_x             = 65;
   fpc_in_ror_x_x           = 66;
   fpc_in_rol_x             = 67;
   fpc_in_rol_x_x           = 68;
   fpc_objc_selector_x      = 69;

{ Internal constant functions }
   fpc_in_const_sqr        = 100;
   fpc_in_const_abs        = 101;
   fpc_in_const_odd        = 102;
   fpc_in_const_ptr        = 103;
   fpc_in_const_swap_word  = 104;
   fpc_in_const_swap_long  = 105;
   fpc_in_lo_qword         = 106;
   fpc_in_hi_qword         = 107;
   fpc_in_const_swap_qword = 108;
   fpc_in_prefetch_var     = 109;

{ FPU functions }
   fpc_in_trunc_real       = 120;
   fpc_in_round_real       = 121;
   fpc_in_frac_real        = 122;
   fpc_in_int_real         = 123;
   fpc_in_exp_real         = 124;
   fpc_in_cos_real         = 125;
   fpc_in_pi_real          = 126;
   fpc_in_abs_real         = 127;
   fpc_in_sqr_real         = 128;
   fpc_in_sqrt_real        = 129;
   fpc_in_arctan_real      = 130;
   fpc_in_ln_real          = 131;
   fpc_in_sin_real         = 132;

{ MMX functions }
{ these contants are used by the mmx unit }

   { MMX }
   fpc_in_mmx_pcmpeqb      = 200;
   fpc_in_mmx_pcmpeqw      = 201;
   fpc_in_mmx_pcmpeqd      = 202;
   fpc_in_mmx_pcmpgtb      = 203;
   fpc_in_mmx_pcmpgtw      = 204;
   fpc_in_mmx_pcmpgtd      = 205;

   { 3DNow }

   { SSE }

