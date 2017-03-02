(module
    (memory 1)

    (func $addr_limit (result i32)
      (i32.mul (current_memory) (i32.const 0x10000))
    )

    (func (export "i8.load") (param $i i32) (result i32)
      (i32.load8_u (i32.add (call $addr_limit) (get_local $i)))
    )

    (func (export "i8.store") (param $i i32) (param $v i32)
      (i32.store8 (i32.add (call $addr_limit) (get_local $i)) (get_local $v))
    )

    (func (export "i16.load") (param $i i32) (result i32)
      (i32.load16_u (i32.add (call $addr_limit) (get_local $i)))
    )

    (func (export "i16.store") (param $i i32) (param $v i32)
      (i32.store16 (i32.add (call $addr_limit) (get_local $i)) (get_local $v))
    )

    (func (export "i32.store") (param $i i32) (param $v i32)
      (i32.store (i32.add (call $addr_limit) (get_local $i)) (get_local $v))
    )

    (func (export "i32.load") (param $i i32) (result i32)
      (i32.load (i32.add (call $addr_limit) (get_local $i)))
    )

    (func (export "i64.store") (param $i i32) (param $v i64)
      (i64.store (i32.add (call $addr_limit) (get_local $i)) (get_local $v))
    )

    (func (export "i64.load") (param $i i32) (result i64)
      (i64.load (i32.add (call $addr_limit) (get_local $i)))
    )

    (func (export "f32.store") (param $i i32) (param $v f32)
      (f32.store (i32.add (call $addr_limit) (get_local $i)) (get_local $v))
    )

    (func (export "f32.load") (param $i i32) (result f32)
      (f32.load (i32.add (call $addr_limit) (get_local $i)))
    )

    (func (export "f64.store") (param $i i32) (param $v f64)
      (f64.store (i32.add (call $addr_limit) (get_local $i)) (get_local $v))
    )

    (func (export "f64.load") (param $i i32) (result f64)
      (f64.load (i32.add (call $addr_limit) (get_local $i)))
    )

    (func (export "grow_memory") (param i32) (result i32)
      (grow_memory (get_local 0))
    )
)

;; Test that stores that are half out of bounds don't store anything to the
;; low half.
;; FIXME: Tests commented out below due to https://github.com/WebAssembly/spec/issues/438
(assert_trap (invoke "i16.store" (i32.const -1) (i32.const 0x01234567)) "out of bounds memory access")
;;(assert_return (invoke "i8.load" (i32.const -1)) (i32.const 0))
(assert_trap (invoke "i32.store" (i32.const -2) (i32.const 0x01234567)) "out of bounds memory access")
;;(assert_return (invoke "i16.load" (i32.const -2)) (i32.const 0))
(assert_trap (invoke "i64.store" (i32.const -4) (i64.const 0x0123456789abcdef)) "out of bounds memory access")
;;(assert_return (invoke "i32.load" (i32.const -4)) (i32.const 0))
(assert_trap (invoke "f32.store" (i32.const -2) (f32.const 0x1.468acep-125)) "out of bounds memory access")
;;(assert_return (invoke "i16.load" (i32.const -2)) (i32.const 0))
(assert_trap (invoke "f64.store" (i32.const -4) (f64.const 0x1.3456789abcdefp-1005)) "out of bounds memory access")
;;(assert_return (invoke "i32.load" (i32.const -4)) (i32.const 0))

;; Test that loads and stores slightly beyond the end trap.
(assert_trap (invoke "i8.store" (i32.const 0) (i32.const 13)) "out of bounds memory access")
(assert_trap (invoke "i8.load" (i32.const 0)) "out of bounds memory access")

(assert_trap (invoke "i16.store" (i32.const 0) (i32.const 13)) "out of bounds memory access")
(assert_trap (invoke "i16.load" (i32.const 0)) "out of bounds memory access")

(assert_trap (invoke "i32.store" (i32.const -3) (i32.const 13)) "out of bounds memory access")
(assert_trap (invoke "i32.load" (i32.const -3)) "out of bounds memory access")
(assert_trap (invoke "i32.store" (i32.const -1) (i32.const 13)) "out of bounds memory access")
(assert_trap (invoke "i32.load" (i32.const -1)) "out of bounds memory access")
(assert_trap (invoke "i32.store" (i32.const 0) (i32.const 13)) "out of bounds memory access")
(assert_trap (invoke "i32.load" (i32.const 0)) "out of bounds memory access")

(assert_trap (invoke "i64.store" (i32.const -7) (i64.const 169)) "out of bounds memory access")
(assert_trap (invoke "i64.load" (i32.const -7)) "out of bounds memory access")
(assert_trap (invoke "i64.store" (i32.const -1) (i64.const 169)) "out of bounds memory access")
(assert_trap (invoke "i64.load" (i32.const -1)) "out of bounds memory access")
(assert_trap (invoke "i64.store" (i32.const 0) (i64.const 169)) "out of bounds memory access")
(assert_trap (invoke "i64.load" (i32.const 0)) "out of bounds memory access")

(assert_trap (invoke "f32.store" (i32.const -3) (f32.const 13)) "out of bounds memory access")
(assert_trap (invoke "f32.load" (i32.const -3)) "out of bounds memory access")
(assert_trap (invoke "f32.store" (i32.const -1) (f32.const 13)) "out of bounds memory access")
(assert_trap (invoke "f32.load" (i32.const -1)) "out of bounds memory access")
(assert_trap (invoke "f32.store" (i32.const 0) (f32.const 13)) "out of bounds memory access")
(assert_trap (invoke "f32.load" (i32.const 0)) "out of bounds memory access")

(assert_trap (invoke "f64.store" (i32.const -7) (f64.const 169)) "out of bounds memory access")
(assert_trap (invoke "f64.load" (i32.const -7)) "out of bounds memory access")
(assert_trap (invoke "f64.store" (i32.const -1) (f64.const 169)) "out of bounds memory access")
(assert_trap (invoke "f64.load" (i32.const -1)) "out of bounds memory access")
(assert_trap (invoke "f64.store" (i32.const 0) (f64.const 169)) "out of bounds memory access")
(assert_trap (invoke "f64.load" (i32.const 0)) "out of bounds memory access")

;; Test that loads and stores to a value well out of bounds trap.
(assert_trap (invoke "i8.store" (i32.const 0x80000000) (i32.const 13)) "out of bounds memory access")
(assert_trap (invoke "i8.load" (i32.const 0x80000000)) "out of bounds memory access")
(assert_trap (invoke "i16.store" (i32.const 0x80000000) (i32.const 13)) "out of bounds memory access")
(assert_trap (invoke "i16.load" (i32.const 0x80000000)) "out of bounds memory access")
(assert_trap (invoke "i32.store" (i32.const 0x80000000) (i32.const 13)) "out of bounds memory access")
(assert_trap (invoke "i32.load" (i32.const 0x80000000)) "out of bounds memory access")
(assert_trap (invoke "i64.store" (i32.const 0x80000000) (i64.const 169)) "out of bounds memory access")
(assert_trap (invoke "i64.load" (i32.const 0x80000000)) "out of bounds memory access")
(assert_trap (invoke "f32.store" (i32.const 0x80000000) (i32.const 13)) "out of bounds memory access")
(assert_trap (invoke "f32.load" (i32.const 0x80000000)) "out of bounds memory access")
(assert_trap (invoke "f64.store" (i32.const 0x80000000) (i64.const 169)) "out of bounds memory access")
(assert_trap (invoke "f64.load" (i32.const 0x80000000)) "out of bounds memory access")

;; Test that loads and stores to the greatest in-bounds address succeed.
(assert_return (invoke "i8.store" (i32.const -1) (i32.const 0x8090a0b0)))
(assert_return (invoke "i8.load" (i32.const -1)) (i32.const 0xb0))
(assert_return (invoke "i16.store" (i32.const -2) (i32.const 0xf0e0d0c0)))
(assert_return (invoke "i16.load" (i32.const -2)) (i32.const 0xd0c0))
(assert_return (invoke "i32.store" (i32.const -4) (i32.const 0x01234567)))
(assert_return (invoke "i32.load" (i32.const -4)) (i32.const 0x01234567))
(assert_return (invoke "i64.store" (i32.const -8) (i64.const 0xfedceb9876543210)))
(assert_return (invoke "i64.load" (i32.const -8)) (i64.const 0xfedceb9876543210))
(assert_return (invoke "f32.store" (i32.const -4) (f32.const 0x1.921fb6p+1)))
(assert_return (invoke "f32.load" (i32.const -4)) (f32.const 0x1.921fb6p+1))
(assert_return (invoke "f64.store" (i32.const -8) (f64.const 0x1.5bf0a8b145769p+1)))
(assert_return (invoke "f64.load" (i32.const -8)) (f64.const 0x1.5bf0a8b145769p+1))

(assert_return (invoke "grow_memory" (i32.const 0x10001)) (i32.const -1))
