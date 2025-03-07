------------------------------------------------------------------------
-- The Agda standard library
--
-- Lists where at least one element satisfies a given property
------------------------------------------------------------------------

{-# OPTIONS --cubical-compatible --safe #-}

module Data.List.Relation.Unary.Any where

open import Data.Empty
open import Data.Fin.Base using (Fin; zero; suc)
open import Data.List.Base as List using (List; []; [_]; _∷_)
open import Data.Product as Prod using (∃; _,_)
open import Data.Sum.Base as Sum using (_⊎_; inj₁; inj₂)
open import Level using (Level; _⊔_)
open import Relation.Nullary using (¬_; yes; no; _⊎-dec_)
import Relation.Nullary.Decidable as Dec
open import Relation.Nullary.Negation using (contradiction)
open import Relation.Unary hiding (_∈_)

private
  variable
    a p q : Level
    A : Set a
    P Q : Pred A p
    x : A
    xs : List A

------------------------------------------------------------------------
-- Definition

-- Given a predicate P, then Any P xs means that at least one element
-- in xs satisfies P. See `Relation.Unary` for an explanation of
-- predicates.

data Any {A : Set a} (P : Pred A p) : Pred (List A) (a ⊔ p) where
  here  : ∀ {x xs} (px  : P x)      → Any P (x ∷ xs)
  there : ∀ {x xs} (pxs : Any P xs) → Any P (x ∷ xs)

------------------------------------------------------------------------
-- Operations on Any

head : ¬ Any P xs → Any P (x ∷ xs) → P x
head ¬pxs (here px)   = px
head ¬pxs (there pxs) = contradiction pxs ¬pxs

tail : ¬ P x → Any P (x ∷ xs) → Any P xs
tail ¬px (here  px)  = ⊥-elim (¬px px)
tail ¬px (there pxs) = pxs

map : P ⊆ Q → Any P ⊆ Any Q
map g (here px)   = here (g px)
map g (there pxs) = there (map g pxs)

-- `index x∈xs` is the list position (zero-based) which `x∈xs` points to.

index : Any P xs → Fin (List.length xs)
index (here  px)  = zero
index (there pxs) = suc (index pxs)

lookup : {P : Pred A p} → Any P xs → A
lookup {xs = xs} p = List.lookup xs (index p)

_∷=_ : {P : Pred A p} → Any P xs → A → List A
_∷=_ {xs = xs} x∈xs v = xs List.[ index x∈xs ]∷= v

infixl 4 _─_
_─_ : {P : Pred A p} → ∀ xs → Any P xs → List A
xs ─ x∈xs = xs List.─ index x∈xs

-- If any element satisfies P, then P is satisfied.

satisfied : Any P xs → ∃ P
satisfied (here px)   = _ , px
satisfied (there pxs) = satisfied pxs

toSum : Any P (x ∷ xs) → P x ⊎ Any P xs
toSum (here px)   = inj₁ px
toSum (there pxs) = inj₂ pxs

fromSum : P x ⊎ Any P xs → Any P (x ∷ xs)
fromSum (inj₁ px)  = here px
fromSum (inj₂ pxs) = there pxs

------------------------------------------------------------------------
-- Properties of predicates preserved by Any

any? : Decidable P → Decidable (Any P)
any? P? []       = no λ()
any? P? (x ∷ xs) = Dec.map′ fromSum toSum (P? x ⊎-dec any? P? xs)

satisfiable : Satisfiable P → Satisfiable (Any P)
satisfiable (x , Px) = [ x ] , here Px


------------------------------------------------------------------------
-- DEPRECATED
------------------------------------------------------------------------
-- Please use the new names as continuing support for the old names is
-- not guaranteed.

-- Version 1.4

any = any?
{-# WARNING_ON_USAGE any
"Warning: any was deprecated in v1.4.
Please use any? instead."
#-}
