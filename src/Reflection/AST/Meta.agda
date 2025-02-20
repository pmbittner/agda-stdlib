------------------------------------------------------------------------
-- The Agda standard library
--
-- Metavariables used in the reflection machinery
------------------------------------------------------------------------

{-# OPTIONS --cubical-compatible --safe #-}

module Reflection.AST.Meta where

import Data.Nat.Properties as ℕₚ                using (_≟_)
open import Function                             using (_on_)
open import Relation.Nullary.Decidable           using (map′)
open import Relation.Binary                      using (Rel; Decidable; DecidableEquality)
import Relation.Binary.Construct.On as On
open import Relation.Binary.PropositionalEquality using (_≡_; cong)

open import Agda.Builtin.Reflection public
  using (Meta) renaming (primMetaToNat to toℕ; primMetaEquality to _≡ᵇ_)

open import Agda.Builtin.Reflection.Properties public
  renaming (primMetaToNatInjective to toℕ-injective)

-- Equality of metas is decidable.

_≈_ : Rel Meta _
_≈_ = _≡_ on toℕ

_≈?_ : Decidable _≈_
_≈?_ = On.decidable toℕ _≡_ ℕₚ._≟_

infix 4 _≟_
_≟_ : DecidableEquality Meta
m ≟ n = map′ (toℕ-injective _ _) (cong toℕ) (m ≈? n)
