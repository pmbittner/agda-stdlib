------------------------------------------------------------------------
-- The Agda standard library
--
-- Base definitions for the right-biased universe-sensitive functor
-- and monad instances for the Product type.
--
-- To minimize the universe level of the RawFunctor, we require that
-- elements of B are "lifted" to a copy of B at a higher universe level
-- (a ⊔ b). See the Data.Product.Effectful.Examples for how this is
-- done.
------------------------------------------------------------------------

{-# OPTIONS --cubical-compatible --safe #-}

open import Level

module Data.Product.Effectful.Right.Base
  {b} (B : Set b) (a : Level) where

open import Data.Product using (_×_; map₁; proj₁; proj₂; <_,_>)
open import Effect.Functor using (RawFunctor)
open import Effect.Comonad using (RawComonad)

------------------------------------------------------------------------
-- Definitions

Productᵣ : Set (a ⊔ b) → Set (a ⊔ b)
Productᵣ A = A × B

functor : RawFunctor Productᵣ
functor = record { _<$>_ = map₁ }

comonad : RawComonad Productᵣ
comonad = record
  { extract = proj₁
  ; extend  = <_, proj₂ >
  }
