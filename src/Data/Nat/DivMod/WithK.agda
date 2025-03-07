------------------------------------------------------------------------
-- The Agda standard library
--
-- More efficient mod and divMod operations (require the K axiom)
------------------------------------------------------------------------

{-# OPTIONS --with-K --safe #-}

module Data.Nat.DivMod.WithK where

open import Data.Nat using (ℕ; NonZero; _+_; _*_; _≟_)
open import Data.Nat.DivMod hiding (_mod_; _divMod_)
open import Data.Nat.Properties using (≤⇒≤″)
open import Data.Nat.WithK
open import Data.Fin.Base using (Fin; toℕ; fromℕ<″)
open import Data.Fin.Properties using (toℕ-fromℕ<″)
open import Function.Base using (_$_)
open import Relation.Binary.PropositionalEquality
  using (refl; sym; cong; module ≡-Reasoning)
open import Relation.Binary.PropositionalEquality.WithK

open ≡-Reasoning

infixl 7 _mod_ _divMod_

------------------------------------------------------------------------
-- Certified modulus

_mod_ : (dividend divisor : ℕ) → .{{ _ : NonZero divisor }} → Fin divisor
a mod n = fromℕ<″ (a % n) (≤″-erase (≤⇒≤″ (m%n<n a n)))

------------------------------------------------------------------------
-- Returns modulus and division result with correctness proof

_divMod_ : (dividend divisor : ℕ) → .{{ NonZero divisor }} →
           DivMod dividend divisor
a divMod n = result (a / n) (a mod n) $ ≡-erase $ begin
  a                                 ≡⟨ m≡m%n+[m/n]*n a n ⟩
  a % n              + [a/n]*n      ≡⟨ cong (_+ [a/n]*n) (sym (toℕ-fromℕ<″ lemma′)) ⟩
  toℕ (fromℕ<″ _ lemma′) + [a/n]*n  ∎
  where
  lemma′ = ≤″-erase (≤⇒≤″ (m%n<n a n))
  [a/n]*n = a / n * n
