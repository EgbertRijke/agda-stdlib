------------------------------------------------------------------------
-- The Agda standard library
--
-- Operations on and properties of decidable relations
------------------------------------------------------------------------

{-# OPTIONS --without-K --safe #-}

module Relation.Nullary.Decidable where

open import Level using (Level)
open import Data.Bool.Base using (true; false)
open import Data.Empty using (⊥-elim)
open import Function.Base
open import Function.Equality    using (_⟨$⟩_; module Π)
open import Function using (Injection; module Injection; module Equivalence; _⇔_; _↔_; mk↔′)
open import Relation.Binary      using (Setoid; module Setoid; Decidable)
open import Relation.Nullary
open import Relation.Nullary.Reflects using (invert)
open import Relation.Binary.PropositionalEquality using (cong′)

private
  variable
    p q : Level
    P : Set p
    Q : Set q

------------------------------------------------------------------------
-- Re-exporting the core definitions

open import Relation.Nullary.Decidable.Core public

------------------------------------------------------------------------
-- Maps

map : P ⇔ Q → Dec P → Dec Q
map P⇔Q = map′ f g
  where open Equivalence P⇔Q

module _ {a₁ a₂ b₁ b₂} {A : Setoid a₁ a₂} {B : Setoid b₁ b₂}
         (inj : Injection A B)
  where

  open Injection inj
  open Setoid A using () renaming (_≈_ to _≈A_)
  open Setoid B using () renaming (_≈_ to _≈B_)

  -- If there is an injection from one setoid to another, and the
  -- latter's equivalence relation is decidable, then the former's
  -- equivalence relation is also decidable.

  via-injection : Decidable _≈B_ → Decidable _≈A_
  via-injection dec x y =
    map′ injective cong (dec (f x) (f y))

------------------------------------------------------------------------
-- A lemma relating True and Dec

True-↔ : (dec : Dec P) → Irrelevant P → True dec ↔ P
True-↔ (true  because  [p]) irr = mk↔′ (λ _ → invert [p]) _ (irr (invert [p])) cong′
True-↔ (false because ofⁿ ¬p) _ = mk↔′ (λ ()) (invert (ofⁿ ¬p)) (⊥-elim ∘ ¬p) λ ()
