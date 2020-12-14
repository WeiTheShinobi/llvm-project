; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -vector-combine -S -mtriple=x86_64-- -mattr=sse2 | FileCheck %s
; RUN: opt < %s -vector-combine -S -mtriple=x86_64-- -mattr=avx2 | FileCheck %s

target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"

define float @matching_fp_scalar(float* align 16 dereferenceable(16) %p) {
; CHECK-LABEL: @matching_fp_scalar(
; CHECK-NEXT:    [[R:%.*]] = load float, float* [[P:%.*]], align 16
; CHECK-NEXT:    ret float [[R]]
;
  %r = load float, float* %p, align 16
  ret float %r
}

define float @matching_fp_scalar_volatile(float* align 16 dereferenceable(16) %p) {
; CHECK-LABEL: @matching_fp_scalar_volatile(
; CHECK-NEXT:    [[R:%.*]] = load volatile float, float* [[P:%.*]], align 16
; CHECK-NEXT:    ret float [[R]]
;
  %r = load volatile float, float* %p, align 16
  ret float %r
}

define double @larger_fp_scalar(float* align 16 dereferenceable(16) %p) {
; CHECK-LABEL: @larger_fp_scalar(
; CHECK-NEXT:    [[BC:%.*]] = bitcast float* [[P:%.*]] to double*
; CHECK-NEXT:    [[R:%.*]] = load double, double* [[BC]], align 16
; CHECK-NEXT:    ret double [[R]]
;
  %bc = bitcast float* %p to double*
  %r = load double, double* %bc, align 16
  ret double %r
}

define float @smaller_fp_scalar(double* align 16 dereferenceable(16) %p) {
; CHECK-LABEL: @smaller_fp_scalar(
; CHECK-NEXT:    [[BC:%.*]] = bitcast double* [[P:%.*]] to float*
; CHECK-NEXT:    [[R:%.*]] = load float, float* [[BC]], align 16
; CHECK-NEXT:    ret float [[R]]
;
  %bc = bitcast double* %p to float*
  %r = load float, float* %bc, align 16
  ret float %r
}

define float @matching_fp_vector(<4 x float>* align 16 dereferenceable(16) %p) {
; CHECK-LABEL: @matching_fp_vector(
; CHECK-NEXT:    [[BC:%.*]] = bitcast <4 x float>* [[P:%.*]] to float*
; CHECK-NEXT:    [[R:%.*]] = load float, float* [[BC]], align 16
; CHECK-NEXT:    ret float [[R]]
;
  %bc = bitcast <4 x float>* %p to float*
  %r = load float, float* %bc, align 16
  ret float %r
}

define float @matching_fp_vector_gep00(<4 x float>* align 16 dereferenceable(16) %p) {
; CHECK-LABEL: @matching_fp_vector_gep00(
; CHECK-NEXT:    [[GEP:%.*]] = getelementptr inbounds <4 x float>, <4 x float>* [[P:%.*]], i64 0, i64 0
; CHECK-NEXT:    [[R:%.*]] = load float, float* [[GEP]], align 16
; CHECK-NEXT:    ret float [[R]]
;
  %gep = getelementptr inbounds <4 x float>, <4 x float>* %p, i64 0, i64 0
  %r = load float, float* %gep, align 16
  ret float %r
}

define float @matching_fp_vector_gep01(<4 x float>* align 16 dereferenceable(20) %p) {
; CHECK-LABEL: @matching_fp_vector_gep01(
; CHECK-NEXT:    [[GEP:%.*]] = getelementptr inbounds <4 x float>, <4 x float>* [[P:%.*]], i64 0, i64 1
; CHECK-NEXT:    [[R:%.*]] = load float, float* [[GEP]], align 4
; CHECK-NEXT:    ret float [[R]]
;
  %gep = getelementptr inbounds <4 x float>, <4 x float>* %p, i64 0, i64 1
  %r = load float, float* %gep, align 4
  ret float %r
}

define float @matching_fp_vector_gep01_deref(<4 x float>* align 16 dereferenceable(19) %p) {
; CHECK-LABEL: @matching_fp_vector_gep01_deref(
; CHECK-NEXT:    [[GEP:%.*]] = getelementptr inbounds <4 x float>, <4 x float>* [[P:%.*]], i64 0, i64 1
; CHECK-NEXT:    [[R:%.*]] = load float, float* [[GEP]], align 4
; CHECK-NEXT:    ret float [[R]]
;
  %gep = getelementptr inbounds <4 x float>, <4 x float>* %p, i64 0, i64 1
  %r = load float, float* %gep, align 4
  ret float %r
}

define float @matching_fp_vector_gep10(<4 x float>* align 16 dereferenceable(32) %p) {
; CHECK-LABEL: @matching_fp_vector_gep10(
; CHECK-NEXT:    [[GEP:%.*]] = getelementptr inbounds <4 x float>, <4 x float>* [[P:%.*]], i64 1, i64 0
; CHECK-NEXT:    [[R:%.*]] = load float, float* [[GEP]], align 16
; CHECK-NEXT:    ret float [[R]]
;
  %gep = getelementptr inbounds <4 x float>, <4 x float>* %p, i64 1, i64 0
  %r = load float, float* %gep, align 16
  ret float %r
}

define float @matching_fp_vector_gep10_deref(<4 x float>* align 16 dereferenceable(31) %p) {
; CHECK-LABEL: @matching_fp_vector_gep10_deref(
; CHECK-NEXT:    [[GEP:%.*]] = getelementptr inbounds <4 x float>, <4 x float>* [[P:%.*]], i64 1, i64 0
; CHECK-NEXT:    [[R:%.*]] = load float, float* [[GEP]], align 16
; CHECK-NEXT:    ret float [[R]]
;
  %gep = getelementptr inbounds <4 x float>, <4 x float>* %p, i64 1, i64 0
  %r = load float, float* %gep, align 16
  ret float %r
}

define float @nonmatching_int_vector(<2 x i64>* align 16 dereferenceable(16) %p) {
; CHECK-LABEL: @nonmatching_int_vector(
; CHECK-NEXT:    [[BC:%.*]] = bitcast <2 x i64>* [[P:%.*]] to float*
; CHECK-NEXT:    [[R:%.*]] = load float, float* [[BC]], align 16
; CHECK-NEXT:    ret float [[R]]
;
  %bc = bitcast <2 x i64>* %p to float*
  %r = load float, float* %bc, align 16
  ret float %r
}

define double @less_aligned(double* align 4 dereferenceable(16) %p) {
; CHECK-LABEL: @less_aligned(
; CHECK-NEXT:    [[R:%.*]] = load double, double* [[P:%.*]], align 4
; CHECK-NEXT:    ret double [[R]]
;
  %r = load double, double* %p, align 4
  ret double %r
}

define float @matching_fp_scalar_small_deref(float* align 16 dereferenceable(15) %p) {
; CHECK-LABEL: @matching_fp_scalar_small_deref(
; CHECK-NEXT:    [[R:%.*]] = load float, float* [[P:%.*]], align 16
; CHECK-NEXT:    ret float [[R]]
;
  %r = load float, float* %p, align 16
  ret float %r
}

define i64 @larger_int_scalar(<4 x float>* align 16 dereferenceable(16) %p) {
; CHECK-LABEL: @larger_int_scalar(
; CHECK-NEXT:    [[BC:%.*]] = bitcast <4 x float>* [[P:%.*]] to i64*
; CHECK-NEXT:    [[R:%.*]] = load i64, i64* [[BC]], align 16
; CHECK-NEXT:    ret i64 [[R]]
;
  %bc = bitcast <4 x float>* %p to i64*
  %r = load i64, i64* %bc, align 16
  ret i64 %r
}

define i8 @smaller_int_scalar(<4 x float>* align 16 dereferenceable(16) %p) {
; CHECK-LABEL: @smaller_int_scalar(
; CHECK-NEXT:    [[BC:%.*]] = bitcast <4 x float>* [[P:%.*]] to i8*
; CHECK-NEXT:    [[R:%.*]] = load i8, i8* [[BC]], align 16
; CHECK-NEXT:    ret i8 [[R]]
;
  %bc = bitcast <4 x float>* %p to i8*
  %r = load i8, i8* %bc, align 16
  ret i8 %r
}

define double @larger_fp_scalar_256bit_vec(<8 x float>* align 32 dereferenceable(32) %p) {
; CHECK-LABEL: @larger_fp_scalar_256bit_vec(
; CHECK-NEXT:    [[BC:%.*]] = bitcast <8 x float>* [[P:%.*]] to double*
; CHECK-NEXT:    [[R:%.*]] = load double, double* [[BC]], align 32
; CHECK-NEXT:    ret double [[R]]
;
  %bc = bitcast <8 x float>* %p to double*
  %r = load double, double* %bc, align 32
  ret double %r
}

define <4 x float> @load_f32_insert_v4f32(float* align 16 dereferenceable(16) %p) {
; CHECK-LABEL: @load_f32_insert_v4f32(
; CHECK-NEXT:    [[TMP1:%.*]] = bitcast float* [[P:%.*]] to <4 x float>*
; CHECK-NEXT:    [[TMP2:%.*]] = load <4 x float>, <4 x float>* [[TMP1]], align 4
; CHECK-NEXT:    [[R:%.*]] = shufflevector <4 x float> [[TMP2]], <4 x float> undef, <4 x i32> <i32 0, i32 undef, i32 undef, i32 undef>
; CHECK-NEXT:    ret <4 x float> [[R]]
;
  %s = load float, float* %p, align 4
  %r = insertelement <4 x float> undef, float %s, i32 0
  ret <4 x float> %r
}

define <4 x float> @casted_load_f32_insert_v4f32(<4 x float>* align 4 dereferenceable(16) %p) {
; CHECK-LABEL: @casted_load_f32_insert_v4f32(
; CHECK-NEXT:    [[TMP1:%.*]] = load <4 x float>, <4 x float>* [[P:%.*]], align 4
; CHECK-NEXT:    [[R:%.*]] = shufflevector <4 x float> [[TMP1]], <4 x float> undef, <4 x i32> <i32 0, i32 undef, i32 undef, i32 undef>
; CHECK-NEXT:    ret <4 x float> [[R]]
;
  %b = bitcast <4 x float>* %p to float*
  %s = load float, float* %b, align 4
  %r = insertelement <4 x float> undef, float %s, i32 0
  ret <4 x float> %r
}

; Element type does not change cost.

define <4 x i32> @load_i32_insert_v4i32(i32* align 16 dereferenceable(16) %p) {
; CHECK-LABEL: @load_i32_insert_v4i32(
; CHECK-NEXT:    [[TMP1:%.*]] = bitcast i32* [[P:%.*]] to <4 x i32>*
; CHECK-NEXT:    [[TMP2:%.*]] = load <4 x i32>, <4 x i32>* [[TMP1]], align 4
; CHECK-NEXT:    [[R:%.*]] = shufflevector <4 x i32> [[TMP2]], <4 x i32> undef, <4 x i32> <i32 0, i32 undef, i32 undef, i32 undef>
; CHECK-NEXT:    ret <4 x i32> [[R]]
;
  %s = load i32, i32* %p, align 4
  %r = insertelement <4 x i32> undef, i32 %s, i32 0
  ret <4 x i32> %r
}

; Pointer type does not change cost.

define <4 x i32> @casted_load_i32_insert_v4i32(<16 x i8>* align 4 dereferenceable(16) %p) {
; CHECK-LABEL: @casted_load_i32_insert_v4i32(
; CHECK-NEXT:    [[TMP1:%.*]] = bitcast <16 x i8>* [[P:%.*]] to <4 x i32>*
; CHECK-NEXT:    [[TMP2:%.*]] = load <4 x i32>, <4 x i32>* [[TMP1]], align 4
; CHECK-NEXT:    [[R:%.*]] = shufflevector <4 x i32> [[TMP2]], <4 x i32> undef, <4 x i32> <i32 0, i32 undef, i32 undef, i32 undef>
; CHECK-NEXT:    ret <4 x i32> [[R]]
;
  %b = bitcast <16 x i8>* %p to i32*
  %s = load i32, i32* %b, align 4
  %r = insertelement <4 x i32> undef, i32 %s, i32 0
  ret <4 x i32> %r
}

; This is canonical form for vector element access.

define <4 x float> @gep00_load_f32_insert_v4f32(<4 x float>* align 16 dereferenceable(16) %p) {
; CHECK-LABEL: @gep00_load_f32_insert_v4f32(
; CHECK-NEXT:    [[TMP1:%.*]] = load <4 x float>, <4 x float>* [[P:%.*]], align 16
; CHECK-NEXT:    [[R:%.*]] = shufflevector <4 x float> [[TMP1]], <4 x float> undef, <4 x i32> <i32 0, i32 undef, i32 undef, i32 undef>
; CHECK-NEXT:    ret <4 x float> [[R]]
;
  %gep = getelementptr inbounds <4 x float>, <4 x float>* %p, i64 0, i64 0
  %s = load float, float* %gep, align 16
  %r = insertelement <4 x float> undef, float %s, i64 0
  ret <4 x float> %r
}

; Should work with addrspace as well.

define <4 x float> @gep00_load_f32_insert_v4f32_addrspace(<4 x float> addrspace(44)* align 16 dereferenceable(16) %p) {
; CHECK-LABEL: @gep00_load_f32_insert_v4f32_addrspace(
; CHECK-NEXT:    [[TMP1:%.*]] = load <4 x float>, <4 x float> addrspace(44)* [[P:%.*]], align 16
; CHECK-NEXT:    [[R:%.*]] = shufflevector <4 x float> [[TMP1]], <4 x float> undef, <4 x i32> <i32 0, i32 undef, i32 undef, i32 undef>
; CHECK-NEXT:    ret <4 x float> [[R]]
;
  %gep = getelementptr inbounds <4 x float>, <4 x float> addrspace(44)* %p, i64 0, i64 0
  %s = load float, float addrspace(44)* %gep, align 16
  %r = insertelement <4 x float> undef, float %s, i64 0
  ret <4 x float> %r
}

; If there are enough dereferenceable bytes, we can offset the vector load.

define <8 x i16> @gep01_load_i16_insert_v8i16(<8 x i16>* align 16 dereferenceable(18) %p) {
; CHECK-LABEL: @gep01_load_i16_insert_v8i16(
; CHECK-NEXT:    [[GEP:%.*]] = getelementptr inbounds <8 x i16>, <8 x i16>* [[P:%.*]], i64 0, i64 1
; CHECK-NEXT:    [[TMP1:%.*]] = bitcast i16* [[GEP]] to <8 x i16>*
; CHECK-NEXT:    [[TMP2:%.*]] = load <8 x i16>, <8 x i16>* [[TMP1]], align 2
; CHECK-NEXT:    [[R:%.*]] = shufflevector <8 x i16> [[TMP2]], <8 x i16> undef, <8 x i32> <i32 0, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef>
; CHECK-NEXT:    ret <8 x i16> [[R]]
;
  %gep = getelementptr inbounds <8 x i16>, <8 x i16>* %p, i64 0, i64 1
  %s = load i16, i16* %gep, align 2
  %r = insertelement <8 x i16> undef, i16 %s, i64 0
  ret <8 x i16> %r
}

; Negative test - can't safely load the offset vector, but could load+shuffle.

define <8 x i16> @gep01_load_i16_insert_v8i16_deref(<8 x i16>* align 16 dereferenceable(17) %p) {
; CHECK-LABEL: @gep01_load_i16_insert_v8i16_deref(
; CHECK-NEXT:    [[GEP:%.*]] = getelementptr inbounds <8 x i16>, <8 x i16>* [[P:%.*]], i64 0, i64 1
; CHECK-NEXT:    [[S:%.*]] = load i16, i16* [[GEP]], align 2
; CHECK-NEXT:    [[R:%.*]] = insertelement <8 x i16> undef, i16 [[S]], i64 0
; CHECK-NEXT:    ret <8 x i16> [[R]]
;
  %gep = getelementptr inbounds <8 x i16>, <8 x i16>* %p, i64 0, i64 1
  %s = load i16, i16* %gep, align 2
  %r = insertelement <8 x i16> undef, i16 %s, i64 0
  ret <8 x i16> %r
}

; TODO: Verify that alignment of the new load is not over-specified.

define <8 x i16> @gep01_load_i16_insert_v8i16_deref_minalign(<8 x i16>* align 2 dereferenceable(16) %p) {
; CHECK-LABEL: @gep01_load_i16_insert_v8i16_deref_minalign(
; CHECK-NEXT:    [[GEP:%.*]] = getelementptr inbounds <8 x i16>, <8 x i16>* [[P:%.*]], i64 0, i64 1
; CHECK-NEXT:    [[S:%.*]] = load i16, i16* [[GEP]], align 8
; CHECK-NEXT:    [[R:%.*]] = insertelement <8 x i16> undef, i16 [[S]], i64 0
; CHECK-NEXT:    ret <8 x i16> [[R]]
;
  %gep = getelementptr inbounds <8 x i16>, <8 x i16>* %p, i64 0, i64 1
  %s = load i16, i16* %gep, align 8
  %r = insertelement <8 x i16> undef, i16 %s, i64 0
  ret <8 x i16> %r
}

; If there are enough dereferenceable bytes, we can offset the vector load.

define <8 x i16> @gep10_load_i16_insert_v8i16(<8 x i16>* align 16 dereferenceable(32) %p) {
; CHECK-LABEL: @gep10_load_i16_insert_v8i16(
; CHECK-NEXT:    [[GEP:%.*]] = getelementptr inbounds <8 x i16>, <8 x i16>* [[P:%.*]], i64 1, i64 0
; CHECK-NEXT:    [[TMP1:%.*]] = bitcast i16* [[GEP]] to <8 x i16>*
; CHECK-NEXT:    [[TMP2:%.*]] = load <8 x i16>, <8 x i16>* [[TMP1]], align 16
; CHECK-NEXT:    [[R:%.*]] = shufflevector <8 x i16> [[TMP2]], <8 x i16> undef, <8 x i32> <i32 0, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef>
; CHECK-NEXT:    ret <8 x i16> [[R]]
;
  %gep = getelementptr inbounds <8 x i16>, <8 x i16>* %p, i64 1, i64 0
  %s = load i16, i16* %gep, align 16
  %r = insertelement <8 x i16> undef, i16 %s, i64 0
  ret <8 x i16> %r
}

; Negative test - disable under asan because widened load can cause spurious
; use-after-poison issues when __asan_poison_memory_region is used.

define <8 x i16> @gep10_load_i16_insert_v8i16_asan(<8 x i16>* align 16 dereferenceable(32) %p) sanitize_address {
; CHECK-LABEL: @gep10_load_i16_insert_v8i16_asan(
; CHECK-NEXT:    [[GEP:%.*]] = getelementptr inbounds <8 x i16>, <8 x i16>* [[P:%.*]], i64 1, i64 0
; CHECK-NEXT:    [[S:%.*]] = load i16, i16* [[GEP]], align 16
; CHECK-NEXT:    [[R:%.*]] = insertelement <8 x i16> undef, i16 [[S]], i64 0
; CHECK-NEXT:    ret <8 x i16> [[R]]
;
  %gep = getelementptr inbounds <8 x i16>, <8 x i16>* %p, i64 1, i64 0
  %s = load i16, i16* %gep, align 16
  %r = insertelement <8 x i16> undef, i16 %s, i64 0
  ret <8 x i16> %r
}

; hwasan and memtag should be similarly suppressed.

define <8 x i16> @gep10_load_i16_insert_v8i16_hwasan(<8 x i16>* align 16 dereferenceable(32) %p) sanitize_hwaddress {
; CHECK-LABEL: @gep10_load_i16_insert_v8i16_hwasan(
; CHECK-NEXT:    [[GEP:%.*]] = getelementptr inbounds <8 x i16>, <8 x i16>* [[P:%.*]], i64 1, i64 0
; CHECK-NEXT:    [[S:%.*]] = load i16, i16* [[GEP]], align 16
; CHECK-NEXT:    [[R:%.*]] = insertelement <8 x i16> undef, i16 [[S]], i64 0
; CHECK-NEXT:    ret <8 x i16> [[R]]
;
  %gep = getelementptr inbounds <8 x i16>, <8 x i16>* %p, i64 1, i64 0
  %s = load i16, i16* %gep, align 16
  %r = insertelement <8 x i16> undef, i16 %s, i64 0
  ret <8 x i16> %r
}

define <8 x i16> @gep10_load_i16_insert_v8i16_memtag(<8 x i16>* align 16 dereferenceable(32) %p) sanitize_memtag {
; CHECK-LABEL: @gep10_load_i16_insert_v8i16_memtag(
; CHECK-NEXT:    [[GEP:%.*]] = getelementptr inbounds <8 x i16>, <8 x i16>* [[P:%.*]], i64 1, i64 0
; CHECK-NEXT:    [[S:%.*]] = load i16, i16* [[GEP]], align 16
; CHECK-NEXT:    [[R:%.*]] = insertelement <8 x i16> undef, i16 [[S]], i64 0
; CHECK-NEXT:    ret <8 x i16> [[R]]
;
  %gep = getelementptr inbounds <8 x i16>, <8 x i16>* %p, i64 1, i64 0
  %s = load i16, i16* %gep, align 16
  %r = insertelement <8 x i16> undef, i16 %s, i64 0
  ret <8 x i16> %r
}

; Negative test - disable under tsan because widened load may overlap bytes
; being concurrently modified. tsan does not know that some bytes are undef.

define <8 x i16> @gep10_load_i16_insert_v8i16_tsan(<8 x i16>* align 16 dereferenceable(32) %p) sanitize_thread {
; CHECK-LABEL: @gep10_load_i16_insert_v8i16_tsan(
; CHECK-NEXT:    [[GEP:%.*]] = getelementptr inbounds <8 x i16>, <8 x i16>* [[P:%.*]], i64 1, i64 0
; CHECK-NEXT:    [[S:%.*]] = load i16, i16* [[GEP]], align 16
; CHECK-NEXT:    [[R:%.*]] = insertelement <8 x i16> undef, i16 [[S]], i64 0
; CHECK-NEXT:    ret <8 x i16> [[R]]
;
  %gep = getelementptr inbounds <8 x i16>, <8 x i16>* %p, i64 1, i64 0
  %s = load i16, i16* %gep, align 16
  %r = insertelement <8 x i16> undef, i16 %s, i64 0
  ret <8 x i16> %r
}

; Negative test - can't safely load the offset vector, but could load+shuffle.

define <8 x i16> @gep10_load_i16_insert_v8i16_deref(<8 x i16>* align 16 dereferenceable(31) %p) {
; CHECK-LABEL: @gep10_load_i16_insert_v8i16_deref(
; CHECK-NEXT:    [[GEP:%.*]] = getelementptr inbounds <8 x i16>, <8 x i16>* [[P:%.*]], i64 1, i64 0
; CHECK-NEXT:    [[S:%.*]] = load i16, i16* [[GEP]], align 16
; CHECK-NEXT:    [[R:%.*]] = insertelement <8 x i16> undef, i16 [[S]], i64 0
; CHECK-NEXT:    ret <8 x i16> [[R]]
;
  %gep = getelementptr inbounds <8 x i16>, <8 x i16>* %p, i64 1, i64 0
  %s = load i16, i16* %gep, align 16
  %r = insertelement <8 x i16> undef, i16 %s, i64 0
  ret <8 x i16> %r
}

; Negative test - do not alter volatile.

define <4 x float> @load_f32_insert_v4f32_volatile(float* align 16 dereferenceable(16) %p) {
; CHECK-LABEL: @load_f32_insert_v4f32_volatile(
; CHECK-NEXT:    [[S:%.*]] = load volatile float, float* [[P:%.*]], align 4
; CHECK-NEXT:    [[R:%.*]] = insertelement <4 x float> undef, float [[S]], i32 0
; CHECK-NEXT:    ret <4 x float> [[R]]
;
  %s = load volatile float, float* %p, align 4
  %r = insertelement <4 x float> undef, float %s, i32 0
  ret <4 x float> %r
}

; Negative test? - pointer is not as aligned as load.

define <4 x float> @load_f32_insert_v4f32_align(float* align 1 dereferenceable(16) %p) {
; CHECK-LABEL: @load_f32_insert_v4f32_align(
; CHECK-NEXT:    [[S:%.*]] = load float, float* [[P:%.*]], align 4
; CHECK-NEXT:    [[R:%.*]] = insertelement <4 x float> undef, float [[S]], i32 0
; CHECK-NEXT:    ret <4 x float> [[R]]
;
  %s = load float, float* %p, align 4
  %r = insertelement <4 x float> undef, float %s, i32 0
  ret <4 x float> %r
}

; Negative test - not enough bytes.

define <4 x float> @load_f32_insert_v4f32_deref(float* align 4 dereferenceable(15) %p) {
; CHECK-LABEL: @load_f32_insert_v4f32_deref(
; CHECK-NEXT:    [[S:%.*]] = load float, float* [[P:%.*]], align 4
; CHECK-NEXT:    [[R:%.*]] = insertelement <4 x float> undef, float [[S]], i32 0
; CHECK-NEXT:    ret <4 x float> [[R]]
;
  %s = load float, float* %p, align 4
  %r = insertelement <4 x float> undef, float %s, i32 0
  ret <4 x float> %r
}

define <8 x i32> @load_i32_insert_v8i32(i32* align 16 dereferenceable(16) %p) {
; CHECK-LABEL: @load_i32_insert_v8i32(
; CHECK-NEXT:    [[TMP1:%.*]] = bitcast i32* [[P:%.*]] to <4 x i32>*
; CHECK-NEXT:    [[TMP2:%.*]] = load <4 x i32>, <4 x i32>* [[TMP1]], align 4
; CHECK-NEXT:    [[R:%.*]] = shufflevector <4 x i32> [[TMP2]], <4 x i32> undef, <8 x i32> <i32 0, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef>
; CHECK-NEXT:    ret <8 x i32> [[R]]
;
  %s = load i32, i32* %p, align 4
  %r = insertelement <8 x i32> undef, i32 %s, i32 0
  ret <8 x i32> %r
}

define <8 x i32> @casted_load_i32_insert_v8i32(<4 x i32>* align 4 dereferenceable(16) %p) {
; CHECK-LABEL: @casted_load_i32_insert_v8i32(
; CHECK-NEXT:    [[TMP1:%.*]] = load <4 x i32>, <4 x i32>* [[P:%.*]], align 4
; CHECK-NEXT:    [[R:%.*]] = shufflevector <4 x i32> [[TMP1]], <4 x i32> undef, <8 x i32> <i32 0, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef>
; CHECK-NEXT:    ret <8 x i32> [[R]]
;
  %b = bitcast <4 x i32>* %p to i32*
  %s = load i32, i32* %b, align 4
  %r = insertelement <8 x i32> undef, i32 %s, i32 0
  ret <8 x i32> %r
}

define <16 x float> @load_f32_insert_v16f32(float* align 16 dereferenceable(16) %p) {
; CHECK-LABEL: @load_f32_insert_v16f32(
; CHECK-NEXT:    [[TMP1:%.*]] = bitcast float* [[P:%.*]] to <4 x float>*
; CHECK-NEXT:    [[TMP2:%.*]] = load <4 x float>, <4 x float>* [[TMP1]], align 4
; CHECK-NEXT:    [[R:%.*]] = shufflevector <4 x float> [[TMP2]], <4 x float> undef, <16 x i32> <i32 0, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef>
; CHECK-NEXT:    ret <16 x float> [[R]]
;
  %s = load float, float* %p, align 4
  %r = insertelement <16 x float> undef, float %s, i32 0
  ret <16 x float> %r
}

define <2 x float> @load_f32_insert_v2f32(float* align 16 dereferenceable(16) %p) {
; CHECK-LABEL: @load_f32_insert_v2f32(
; CHECK-NEXT:    [[TMP1:%.*]] = bitcast float* [[P:%.*]] to <4 x float>*
; CHECK-NEXT:    [[TMP2:%.*]] = load <4 x float>, <4 x float>* [[TMP1]], align 4
; CHECK-NEXT:    [[R:%.*]] = shufflevector <4 x float> [[TMP2]], <4 x float> undef, <2 x i32> <i32 0, i32 undef>
; CHECK-NEXT:    ret <2 x float> [[R]]
;
  %s = load float, float* %p, align 4
  %r = insertelement <2 x float> undef, float %s, i32 0
  ret <2 x float> %r
}

; Negative test - suppress load widening for asan/hwasan/memtag/tsan.

define <2 x float> @load_f32_insert_v2f32_asan(float* align 16 dereferenceable(16) %p) sanitize_address {
; CHECK-LABEL: @load_f32_insert_v2f32_asan(
; CHECK-NEXT:    [[S:%.*]] = load float, float* [[P:%.*]], align 4
; CHECK-NEXT:    [[R:%.*]] = insertelement <2 x float> undef, float [[S]], i32 0
; CHECK-NEXT:    ret <2 x float> [[R]]
;
  %s = load float, float* %p, align 4
  %r = insertelement <2 x float> undef, float %s, i32 0
  ret <2 x float> %r
}

declare float* @getscaleptr()
define void @PR47558_multiple_use_load(<2 x float>* nocapture nonnull %resultptr, <2 x float>* nocapture nonnull readonly %opptr) {
; CHECK-LABEL: @PR47558_multiple_use_load(
; CHECK-NEXT:    [[SCALEPTR:%.*]] = tail call nonnull align 16 dereferenceable(64) float* @getscaleptr()
; CHECK-NEXT:    [[OP:%.*]] = load <2 x float>, <2 x float>* [[OPPTR:%.*]], align 4
; CHECK-NEXT:    [[SCALE:%.*]] = load float, float* [[SCALEPTR]], align 16
; CHECK-NEXT:    [[T1:%.*]] = insertelement <2 x float> undef, float [[SCALE]], i32 0
; CHECK-NEXT:    [[T2:%.*]] = insertelement <2 x float> [[T1]], float [[SCALE]], i32 1
; CHECK-NEXT:    [[T3:%.*]] = fmul <2 x float> [[OP]], [[T2]]
; CHECK-NEXT:    [[T4:%.*]] = extractelement <2 x float> [[T3]], i32 0
; CHECK-NEXT:    [[RESULT0:%.*]] = insertelement <2 x float> undef, float [[T4]], i32 0
; CHECK-NEXT:    [[T5:%.*]] = extractelement <2 x float> [[T3]], i32 1
; CHECK-NEXT:    [[RESULT1:%.*]] = insertelement <2 x float> [[RESULT0]], float [[T5]], i32 1
; CHECK-NEXT:    store <2 x float> [[RESULT1]], <2 x float>* [[RESULTPTR:%.*]], align 8
; CHECK-NEXT:    ret void
;
  %scaleptr = tail call nonnull align 16 dereferenceable(64) float* @getscaleptr()
  %op = load <2 x float>, <2 x float>* %opptr, align 4
  %scale = load float, float* %scaleptr, align 16
  %t1 = insertelement <2 x float> undef, float %scale, i32 0
  %t2 = insertelement <2 x float> %t1, float %scale, i32 1
  %t3 = fmul <2 x float> %op, %t2
  %t4 = extractelement <2 x float> %t3, i32 0
  %result0 = insertelement <2 x float> undef, float %t4, i32 0
  %t5 = extractelement <2 x float> %t3, i32 1
  %result1 = insertelement <2 x float> %result0, float %t5, i32 1
  store <2 x float> %result1, <2 x float>* %resultptr, align 8
  ret void
}

define <4 x float> @load_v2f32_extract_insert_v4f32(<2 x float>* align 16 dereferenceable(16) %p) {
; CHECK-LABEL: @load_v2f32_extract_insert_v4f32(
; CHECK-NEXT:    [[TMP1:%.*]] = bitcast <2 x float>* [[P:%.*]] to <4 x float>*
; CHECK-NEXT:    [[TMP2:%.*]] = load <4 x float>, <4 x float>* [[TMP1]], align 4
; CHECK-NEXT:    [[R:%.*]] = shufflevector <4 x float> [[TMP2]], <4 x float> undef, <4 x i32> <i32 0, i32 undef, i32 undef, i32 undef>
; CHECK-NEXT:    ret <4 x float> [[R]]
;
  %l = load <2 x float>, <2 x float>* %p, align 4
  %s = extractelement <2 x float> %l, i32 0
  %r = insertelement <4 x float> undef, float %s, i32 0
  ret <4 x float> %r
}

define <4 x float> @load_v8f32_extract_insert_v4f32(<8 x float>* align 16 dereferenceable(16) %p) {
; CHECK-LABEL: @load_v8f32_extract_insert_v4f32(
; CHECK-NEXT:    [[TMP1:%.*]] = bitcast <8 x float>* [[P:%.*]] to <4 x float>*
; CHECK-NEXT:    [[TMP2:%.*]] = load <4 x float>, <4 x float>* [[TMP1]], align 4
; CHECK-NEXT:    [[R:%.*]] = shufflevector <4 x float> [[TMP2]], <4 x float> undef, <4 x i32> <i32 0, i32 undef, i32 undef, i32 undef>
; CHECK-NEXT:    ret <4 x float> [[R]]
;
  %l = load <8 x float>, <8 x float>* %p, align 4
  %s = extractelement <8 x float> %l, i32 0
  %r = insertelement <4 x float> undef, float %s, i32 0
  ret <4 x float> %r
}

define <8 x i32> @load_v1i32_extract_insert_v8i32_extra_use(<1 x i32>* align 16 dereferenceable(16) %p, <1 x i32>* %store_ptr) {
; CHECK-LABEL: @load_v1i32_extract_insert_v8i32_extra_use(
; CHECK-NEXT:    [[L:%.*]] = load <1 x i32>, <1 x i32>* [[P:%.*]], align 4
; CHECK-NEXT:    store <1 x i32> [[L]], <1 x i32>* [[STORE_PTR:%.*]], align 4
; CHECK-NEXT:    [[S:%.*]] = extractelement <1 x i32> [[L]], i32 0
; CHECK-NEXT:    [[R:%.*]] = insertelement <8 x i32> undef, i32 [[S]], i32 0
; CHECK-NEXT:    ret <8 x i32> [[R]]
;
  %l = load <1 x i32>, <1 x i32>* %p, align 4
  store <1 x i32> %l, <1 x i32>* %store_ptr
  %s = extractelement <1 x i32> %l, i32 0
  %r = insertelement <8 x i32> undef, i32 %s, i32 0
  ret <8 x i32> %r
}

; TODO: Can't safely load the offset vector, but can load+shuffle if it is profitable.

define <8 x i16> @gep1_load_v2i16_extract_insert_v8i16(<2 x i16>* align 16 dereferenceable(16) %p) {
; CHECK-LABEL: @gep1_load_v2i16_extract_insert_v8i16(
; CHECK-NEXT:    [[GEP:%.*]] = getelementptr inbounds <2 x i16>, <2 x i16>* [[P:%.*]], i64 1
; CHECK-NEXT:    [[L:%.*]] = load <2 x i16>, <2 x i16>* [[GEP]], align 2
; CHECK-NEXT:    [[S:%.*]] = extractelement <2 x i16> [[L]], i32 0
; CHECK-NEXT:    [[R:%.*]] = insertelement <8 x i16> undef, i16 [[S]], i64 0
; CHECK-NEXT:    ret <8 x i16> [[R]]
;
  %gep = getelementptr inbounds <2 x i16>, <2 x i16>* %p, i64 1
  %l = load <2 x i16>, <2 x i16>* %gep, align 2
  %s = extractelement <2 x i16> %l, i32 0
  %r = insertelement <8 x i16> undef, i16 %s, i64 0
  ret <8 x i16> %r
}
