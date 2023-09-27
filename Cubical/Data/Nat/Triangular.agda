{-# OPTIONS --safe #-}
module Cubical.Data.Nat.Triangular where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Function

open import Cubical.Data.FinData

open import Cubical.Algebra.CommSemiring
open import Cubical.Algebra.CommSemiring.Instances.Nat
open import Cubical.Algebra.Semiring.BigOps

open import Cubical.Tactics.NatSolver.Reflection

open Sum (CommSemiring→Semiring ℕasCSR)
open CommSemiringStr (snd ℕasCSR)

-- the first n natural number, i.e. {0,1,...,n-1}
first : (n : ℕ) → FinVec ℕ n
first n i = toℕ i

firstDecompose : (n : ℕ) → first (suc n) ∘ weakenFin ≡ first n
firstDecompose n i l =
  elim
    (λ l → first (suc _) (weakenFin l) ≡ first _ l)
    refl
    (λ _ → weakenRespToℕ _)
    l i

sumFormula : (n : ℕ) → 2 · (∑ (first (suc n))) ≡ n · (n + 1)
sumFormula zero = refl
sumFormula (suc n) =
  2 · ∑ (first (2 + n))                                                ≡⟨ step0 ⟩
  2 · (∑ (first (2 + n) ∘ weakenFin) + first (2 + n) (fromℕ (suc n)))  ≡⟨ step1 ⟩
  2 · (∑ (first (2 + n) ∘ weakenFin) + (suc n))                        ≡⟨ step2 ⟩
  2 · (∑ (first (1 + n)) + (suc n))                                    ≡⟨ step3 ⟩
  2 · ∑ (first (1 + n)) + 2 · (suc n)                                  ≡⟨ step4 ⟩
  n · (n + 1) + 2 · (suc n)                                            ≡⟨ useSolver n ⟩
  (suc n) · (suc (n + 1))                                              ∎
  where
    step0 = cong (λ u → 2 · u) (∑Last (first (2 + n)))
    step1 = cong (λ u → 2 · (∑ (first (2 + n) ∘ weakenFin) + u)) (toFromId _)
    step2 = cong (λ u → 2 · ((∑ u) + (suc n))) (firstDecompose (suc n))
    step3 = ·DistR+ 2 (∑ (first (1 + n))) (suc n)
    step4 = cong (λ u → u + 2 · (suc n)) (sumFormula n)

    useSolver : ∀ (n : ℕ) → n · (n + 1) + 2 · (suc n) ≡ (suc n) · (suc (n + 1))
    useSolver = solve
