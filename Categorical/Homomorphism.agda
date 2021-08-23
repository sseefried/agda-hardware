{-# OPTIONS --safe --without-K #-}

module Categorical.Homomorphism where

open import Level

open import Categorical.Raw public
open import Categorical.Laws as L
       hiding (Category; Cartesian; CartesianClosed)
open import Categorical.Reasoning

private
  variable
    o ℓ o₁ ℓ₁ o₂ ℓ₂ : Level
    obj₁ obj₂ : Set o
    a b c d : obj₁

open import Categorical.Equiv  public

open ≈-Reasoning

-- Category homomorphism (functor)
record CategoryH {obj₁ : Set o₁} (_⇨₁_ : obj₁ → obj₁ → Set ℓ₁)
                 {obj₂ : Set o₂} (_⇨₂_ : obj₂ → obj₂ → Set ℓ₂)
                 {q} ⦃ _ : Equivalent q _⇨₂_ ⦄
                 ⦃ _ : Category _⇨₁_ ⦄
                 ⦃ _ : Category _⇨₂_ ⦄
                 ⦃ Hₒ : Homomorphismₒ obj₁ obj₂ ⦄
                 ⦃ H : Homomorphism _⇨₁_ _⇨₂_ ⦄
       : Set (o₁ ⊔ ℓ₁ ⊔ o₂ ⊔ ℓ₂ ⊔ q) where
  field
    F-id : Fₘ (id {_⇨_ = _⇨₁_}{a = a}) ≈ id
    F-∘  : ∀ {g : b ⇨₁ c} {f : a ⇨₁ b} → Fₘ (g ∘ f) ≈ Fₘ g ∘ Fₘ f
    -- TODO: make g and f explicit arguments? Wait and see.

open CategoryH ⦃ … ⦄ public

id-CategoryH : {obj : Set o} {_⇨_ : obj → obj → Set ℓ}
               {q : Level} ⦃ _ : Equivalent q _⇨_ ⦄
               ⦃ _ : Category _⇨_ ⦄
             → CategoryH _⇨_ _⇨_ ⦃ Hₒ = id-Hₒ ⦄ ⦃ H = id-H ⦄
id-CategoryH = record { F-id = refl ; F-∘ = refl }

record ProductsH
    (obj₁ : Set o₁) ⦃ _ : Products obj₁ ⦄
    {obj₂ : Set o₂} ⦃ _ : Products obj₂ ⦄
    (_⇨₂′_ : obj₂ → obj₂ → Set ℓ₂) ⦃ _ : Category _⇨₂′_ ⦄
    ⦃ Hₒ : Homomorphismₒ obj₁ obj₂ ⦄
    {q} ⦃ _ : Equivalent q _⇨₂′_ ⦄
    : Set (o₁ ⊔ o₂ ⊔ ℓ₂ ⊔ q) where
  private infix 0 _⇨₂_; _⇨₂_ = _⇨₂′_
  field
    -- https://ncatlab.org/nlab/show/monoidal+functor
    ε : ⊤ ⇨₂ Fₒ ⊤
    μ : {a b : obj₁} → Fₒ a × Fₒ b ⇨₂ Fₒ (a × b)

    -- *Strong*
    ε⁻¹ : Fₒ ⊤ ⇨₂ ⊤
    μ⁻¹ : {a b : obj₁} → Fₒ (a × b) ⇨₂ Fₒ a × Fₒ b

    ε⁻¹∘ε : ε⁻¹ ∘ ε ≈ id
    ε∘ε⁻¹ : ε ∘ ε⁻¹ ≈ id

    μ⁻¹∘μ : μ⁻¹ ∘ μ {a}{b} ≈ id
    μ∘μ⁻¹ : μ ∘ μ⁻¹ {a}{b} ≈ id

  -- -- Maybe useful along with second′ and _⊗′_
  -- first′ : {a b c : obj₁} ⦃ _ : Cartesian _⇨₂_ ⦄
  --        → (Fₒ a ⇨₂ Fₒ c) → (Fₒ (a × b) ⇨₂ Fₒ (c × b))
  -- first′ f = μ ∘ first f ∘ μ⁻¹

open ProductsH ⦃ … ⦄ public

id-ProductsH : ∀ {obj : Set o} ⦃ _ : Products obj ⦄
                 {_⇨_ : obj → obj → Set ℓ} ⦃ _ : Category _⇨_ ⦄
                 {q} ⦃ _ : Equivalent q _⇨_ ⦄ ⦃ _ : L.Category _⇨_ ⦄
             → ProductsH obj _⇨_ ⦃ Hₒ = id-Hₒ ⦄
id-ProductsH =
  record { ε = id ; μ = id ; ε⁻¹ = id ; μ⁻¹ = id
         ; ε⁻¹∘ε = L.identityˡ ; ε∘ε⁻¹ = L.identityˡ
         ; μ⁻¹∘μ = L.identityˡ ; μ∘μ⁻¹ = L.identityˡ
         }

-- Cartesian homomorphism (cartesian functor)
record CartesianH
         {obj₁ : Set o₁} ⦃ _ : Products obj₁ ⦄ (_⇨₁_ : obj₁ → obj₁ → Set ℓ₁)
         {obj₂ : Set o₂} ⦃ _ : Products obj₂ ⦄ (_⇨₂_ : obj₂ → obj₂ → Set ℓ₂)
         {q} ⦃ _ : Equivalent q _⇨₂_ ⦄
         ⦃ _ : Category _⇨₁_ ⦄ ⦃ _ : Cartesian _⇨₁_ ⦄
         ⦃ _ : Category _⇨₂_ ⦄ ⦃ _ : Cartesian _⇨₂_ ⦄
         ⦃ Hₒ : Homomorphismₒ obj₁ obj₂ ⦄
         ⦃ H : Homomorphism _⇨₁_ _⇨₂_ ⦄
         ⦃ pH : ProductsH obj₁ _⇨₂_ ⦄
       : Set (o₁ ⊔ ℓ₁ ⊔ o₂ ⊔ ℓ₂ ⊔ q) where
  field
    F-!   : ∀ {a : obj₁} → Fₘ {a = a} ! ≈ ε ∘ !
    F-▵   : ∀ {a c d} {f : a ⇨₁ c}{g : a ⇨₁ d} → Fₘ (f ▵ g) ≈ μ ∘ (Fₘ f ▵ Fₘ g)
    F-exl : ∀ {a b : obj₁} → Fₘ exl ∘ μ {a = a}{b} ≈ exl
    F-exr : ∀ {a b : obj₁} → Fₘ exr ∘ μ {a = a}{b} ≈ exr

  module _ ⦃ _ : L.Category _⇨₂_ ⦄ where

    F-!′ : {a : obj₁} → ε⁻¹ ∘ Fₘ {a = a} ! ≈ !
    F-!′ = ∘≈ʳ F-! ; ∘-assoc-elimˡ ε⁻¹∘ε

    F-▵′ : {f : a ⇨₁ c}{g : a ⇨₁ d} → μ⁻¹ ∘ Fₘ (f ▵ g) ≈ Fₘ f ▵ Fₘ g
    F-▵′ = ∘≈ʳ F-▵ ; ∘-assoc-elimˡ μ⁻¹∘μ

    F-exl′ : {a b : obj₁} → Fₘ exl ≈ exl ∘ μ⁻¹ {a = a}{b}
    F-exl′ = introʳ μ∘μ⁻¹ ; ∘-assocˡ′ F-exl

    F-exr′ : {a b : obj₁} → Fₘ exr ≈ exr ∘ μ⁻¹ {a = a}{b}
    F-exr′ = introʳ μ∘μ⁻¹ ; ∘-assocˡ′ F-exr

    module _ ⦃ _ : L.Cartesian _⇨₂_ ⦄ ⦃ _ : CategoryH _⇨₁_ _⇨₂_ ⦄ where

      F-⊗ : ∀ {a b c d}{f : a ⇨₁ c}{g : b ⇨₁ d} → Fₘ (f ⊗ g) ∘ μ ≈ μ ∘ (Fₘ f ⊗ Fₘ g)
      F-⊗ {f = f}{g} =
        begin
          Fₘ (f ∘ exl ▵ g ∘ exr) ∘ μ
        ≈⟨ ∘≈ˡ (F-▵ ; ∘≈ʳ (▵≈ F-∘ F-∘)) ⟩
          (μ ∘ (Fₘ f ∘ Fₘ exl ▵ Fₘ g ∘ Fₘ exr)) ∘ μ
        ≈⟨ ∘-assocʳ ⟩
          μ ∘ ((Fₘ f ∘ Fₘ exl ▵ Fₘ g ∘ Fₘ exr) ∘ μ)
        ≈⟨ ∘≈ʳ (▵∘ ; ▵≈ (∘-assocʳ′ F-exl) (∘-assocʳ′ F-exr)) ⟩
          μ ∘ (Fₘ f ∘ exl ▵ Fₘ g ∘ exr)
        ∎

      -- I wonder whether proofs become simpler and/or more regular if we switch
      -- all axioms and lemmas to the form "Fₘ ... ≈ ...". One experiment:
      F-⊗′ : ∀ {a b c d}{f : a ⇨₁ c}{g : b ⇨₁ d} → Fₘ (f ⊗ g) ≈ μ ∘ (Fₘ f ⊗ Fₘ g) ∘ μ⁻¹
      F-⊗′ {f = f}{g} =
        begin
          Fₘ (f ∘ exl ▵ g ∘ exr)
        ≈⟨ F-▵ ; ∘≈ʳ (▵≈ F-∘ F-∘) ⟩
          μ ∘ (Fₘ f ∘ Fₘ exl ▵ Fₘ g ∘ Fₘ exr)
        ≈⟨ ∘≈ʳ (▵≈ (∘≈ʳ F-exl′ ; ∘-assocˡ) (∘≈ʳ F-exr′ ; ∘-assocˡ)) ⟩
          μ ∘ ((Fₘ f ∘ exl) ∘ μ⁻¹ ▵ (Fₘ g ∘ exr) ∘ μ⁻¹)
        ≈⟨ ∘≈ʳ (sym ▵∘) ⟩
          μ ∘ (Fₘ f ∘ exl ▵ Fₘ g ∘ exr) ∘ μ⁻¹
        ∎

      F-first : ∀ {a b c : obj₁}{f : a ⇨₁ c}
               → Fₘ (first {b = b} f) ∘ μ ≈ μ ∘ first (Fₘ f)
      F-first = F-⊗ ; ∘≈ʳ (⊗≈ʳ F-id)

      F-first′ : ∀ {a b c : obj₁}{f : a ⇨₁ c}
               → Fₘ (first {b = b} f) ≈ μ ∘ first (Fₘ f) ∘ μ⁻¹
      F-first′ = introʳ μ∘μ⁻¹ ; ∘-assocˡʳ′ F-first

      F-second : ∀ {a b d : obj₁}{g : b ⇨₁ d}
               → Fₘ (second {a = a} g) ∘ μ ≈ μ ∘ second (Fₘ g)
      F-second = F-⊗ ; ∘≈ʳ (⊗≈ˡ F-id)

      F-second′ : ∀ {a b d : obj₁}{g : b ⇨₁ d}
                → Fₘ (second {a = a} g) ≈ μ ∘ second (Fₘ g) ∘ μ⁻¹
      F-second′ = F-⊗′ ; ∘≈ʳ (∘≈ˡ (⊗≈ˡ F-id))

      -- F-assocˡ′ : ∀ {a b c : obj₁}
      --    → Fₘ (assocˡ {a = a}{b}{c}) ≈ μ ∘ first μ ∘ assocˡ ∘ second μ⁻¹ ∘ μ⁻¹
      -- F-assocˡ′ =
      --   begin
      --     Fₘ assocˡ
      --   ≡⟨⟩
      --     Fₘ (second exl ▵ exr ∘ exr)
      --   ≈⟨ F-▵ ⟩
      --     μ ∘ (Fₘ (second exl) ▵ Fₘ (exr ∘ exr))
      --   ≈⟨ ∘≈ʳ (▵≈ʳ F-∘) ⟩
      --     μ ∘ (Fₘ (second exl) ▵ Fₘ exr ∘ Fₘ exr)
      --   ≈⟨ ∘≈ʳ (▵≈ˡ F-second′) ⟩
      --     μ ∘ (μ ∘ second (Fₘ exl) ∘ μ⁻¹ ▵ Fₘ exr ∘ Fₘ exr)
      --   ≈⟨ ∘≈ʳ (▵≈ˡ (∘≈ʳ (∘≈ˡ (⊗≈ʳ F-exl′)))) ⟩
      --     μ ∘ (μ ∘ second (exl ∘ μ⁻¹) ∘ μ⁻¹ ▵ Fₘ exr ∘ Fₘ exr)
      --   ≈⟨ ∘≈ʳ (▵≈ʳ {!!}) ⟩
      --     μ ∘ (μ ∘ second (exl ∘ μ⁻¹) ∘ μ⁻¹ ▵ (exr ∘ μ⁻¹) ∘ (exr ∘ μ⁻¹))
      --   ≈⟨ ∘≈ʳ (▵≈ˡ {!!}) ⟩
      --     μ ∘ (μ ∘ second exl ∘ second μ⁻¹ ∘ μ⁻¹ ▵ (exr ∘ μ⁻¹) ∘ (exr ∘ μ⁻¹))
      --   ≈⟨ {!!} ⟩
      --     μ ∘ first μ ∘ (second exl ▵ exr ∘ exr) ∘ second μ⁻¹ ∘ μ⁻¹
      --   ≡⟨⟩
      --     μ ∘ first μ ∘ assocˡ ∘ second μ⁻¹ ∘ μ⁻¹
      --   ∎

      F-assocˡ : ∀ {a b c : obj₁}
         → Fₘ (assocˡ {a = a}{b}{c}) ∘ μ ∘ second μ ≈ μ ∘ first μ ∘ assocˡ
      F-assocˡ =
        begin
          Fₘ assocˡ ∘ μ ∘ second μ
        ≡⟨⟩
          Fₘ (second exl ▵ exr ∘ exr) ∘ μ ∘ second μ
        ≈⟨ ∘≈ˡ F-▵ ⟩
          (μ ∘ (Fₘ (second exl) ▵ Fₘ (exr ∘ exr))) ∘ μ ∘ second μ
        ≈⟨ ∘-assocˡ′ (∘-assocʳ′ ▵∘ ; ∘≈ʳ (▵≈ʳ (∘≈ˡ F-∘ ; ∘-assocʳ′ F-exr))) ⟩
          (μ ∘ (Fₘ (second exl) ∘ μ ▵ Fₘ exr ∘ exr)) ∘ second μ
        ≈⟨ ∘-assocʳ′ (▵∘ ; ▵≈ ∘-assocʳ ∘-assocʳ ; ▵≈ʳ (∘≈ʳ exr∘▵ ; ∘-assocˡ′ F-exr)) ⟩
          μ ∘ (Fₘ (second exl) ∘ μ ∘ second μ ▵ exr ∘ exr)
        ≈⟨ ∘≈ʳ (▵≈ˡ (∘-assocˡ′ F-second)) ⟩
          μ ∘ ((μ ∘ second (Fₘ exl)) ∘ second μ ▵ exr ∘ exr)
        ≈⟨ ∘≈ʳ (▵≈ˡ (∘-assocʳ′ (second∘⊗ ; ⊗≈ʳ F-exl))) ⟩
          μ ∘ (μ ∘ second exl ▵ exr ∘ exr)
        ≈⟨ ∘≈ʳ (sym first∘▵) ⟩
          μ ∘ first μ ∘ (second exl ▵ exr ∘ exr)
        ≡⟨⟩
          μ ∘ first μ ∘ assocˡ
        ∎

      -- F-assocˡ′ : ∀ {a b c : obj₁}
      --    → Fₘ (assocˡ {a = a}{b}{c}) ≈ μ ∘ first μ ∘ assocˡ ∘ second μ⁻¹ ∘ μ⁻¹
      -- F-assocˡ′ =
      --   begin
      --     Fₘ assocˡ
      --   ≈⟨ sym (∘≈ʳ (∘≈ʳ {!∘-assocˡ ∘ elimˡ ?!} ; {!!}) ; elimʳ {!!}) ⟩
      --     Fₘ assocˡ ∘ μ ∘ second μ ∘ second μ⁻¹ ∘ μ⁻¹
      --   ≈⟨ (∘-assocˡ³ ; ∘≈ˡ F-assocˡ ; ∘-assocʳ³) ⟩
      --     μ ∘ first μ ∘ assocˡ ∘ second μ⁻¹ ∘ μ⁻¹
      --   ∎

      -- F-assocʳ : ∀ {a b c : obj₁}
      --    → Fₘ (assocʳ {a = a}{b}{c}) ∘ μ ∘ first μ ≈ μ ∘ second μ ∘ assocʳ
      -- F-assocʳ = {!!}

open CartesianH ⦃ … ⦄ public

id-CartesianH : {obj : Set o} {_⇨_ : obj → obj → Set ℓ} ⦃ _ : Products obj ⦄
                {q : Level} ⦃ _ : Equivalent q _⇨_ ⦄
                ⦃ _ :   Category _⇨_ ⦄ ⦃ _ :   Cartesian _⇨_ ⦄
                ⦃ _ : L.Category _⇨_ ⦄ ⦃ _ : L.Cartesian _⇨_ ⦄
              → CartesianH _⇨_ _⇨_ ⦃ Hₒ = id-Hₒ ⦄ ⦃ H = id-H ⦄ ⦃ pH = id-ProductsH ⦄
id-CartesianH = record
  { F-!   = sym identityˡ
  ; F-▵   = sym identityˡ
  ; F-exl = identityʳ
  ; F-exr = identityʳ
  }

record ExponentialsH
    (obj₁ : Set o₁) ⦃ _ : Exponentials obj₁ ⦄
    {obj₂ : Set o₂} ⦃ _ : Exponentials obj₂ ⦄ (_⇨₂′_ : obj₂ → obj₂ → Set ℓ₂)
    ⦃ Hₒ : Homomorphismₒ obj₁ obj₂ ⦄
    : Set (o₁ ⊔ o₂ ⊔ ℓ₂) where
  private infix 0 _⇨₂_; _⇨₂_ = _⇨₂′_
  field
    ν : {a b : obj₁} → (Fₒ a ⇛ Fₒ b) ⇨₂ Fₒ (a ⇛ b)

    -- *Strong*?
    ν⁻¹ : {a b : obj₁} → Fₒ (a ⇛ b) ⇨₂ (Fₒ a ⇛ Fₒ b)

open ExponentialsH ⦃ … ⦄ public

-- TODO: CartesianClosedH

record BooleanH
    (obj₁ : Set o₁) ⦃ _ : Boolean obj₁ ⦄
    {obj₂ : Set o₂} ⦃ _ : Boolean obj₂ ⦄ (_⇨₂′_ : obj₂ → obj₂ → Set ℓ₂)
    ⦃ Hₒ : Homomorphismₒ obj₁ obj₂ ⦄
    -- {q : Level} ⦃ _ : Equivalent q _⇨₂′_ ⦄
    : Set (o₁ ⊔ o₂ ⊔ ℓ₂ {- ⊔ q -}) where
  private infix 0 _⇨₂_; _⇨₂_ = _⇨₂′_
  field
    β   : Bool ⇨₂ Fₒ Bool
    β⁻¹ : Fₒ Bool ⇨₂ Bool
  
    -- -- Oops. These two need Category _⇨₂_, which we won't always have,
    -- -- e.g., for primitives.
    -- -- TODO: Maybe split off StrongBooleanH with β⁻¹ and the inverse
    -- -- properties, and similarly for ProductsH.
    -- β⁻¹∘β : β⁻¹ ∘ β ≈ id
    -- β∘β⁻¹ : β ∘ β⁻¹ ≈ id

open BooleanH ⦃ … ⦄ public

id-booleanH : {obj : Set o} ⦃ _ : Boolean obj ⦄
              {_⇨₁_ : obj → obj → Set ℓ₁} {_⇨₂_ : obj → obj → Set ℓ₂}
              ⦃ _ : Category _⇨₂_ ⦄
              -- {q : Level} ⦃ _ : Equivalent q _⇨₂_ ⦄
              -- ⦃ _ : L.Category _⇨₂_ ⦃ rcat = cat₂ ⦄ ⦄
            → BooleanH obj _⇨₂_ ⦃ Hₒ = id-Hₒ ⦄
id-booleanH = record
  { β   = id
  ; β⁻¹ = id
  -- ; β⁻¹∘β = {!identityˡ!}
  -- ; β∘β⁻¹ = {!identityˡ!}
  }

record LogicH
    {obj₁ : Set o₁} (_⇨₁′_ : obj₁ → obj₁ → Set ℓ₁)
    {obj₂ : Set o₂} (_⇨₂′_ : obj₂ → obj₂ → Set ℓ₂)
    {q} ⦃ _ : Equivalent q _⇨₂′_ ⦄
    ⦃ _ : Boolean obj₁ ⦄ ⦃ _ : Products obj₁ ⦄ ⦃ _ : Logic _⇨₁′_ ⦄
    ⦃ _ : Boolean obj₂ ⦄ ⦃ _ : Products obj₂ ⦄ ⦃ _ : Logic _⇨₂′_ ⦄
    ⦃ _ : Category _⇨₂′_ ⦄ ⦃ _ : Cartesian _⇨₂′_ ⦄
    ⦃ Hₒ : Homomorphismₒ obj₁ obj₂ ⦄
    ⦃ H : Homomorphism _⇨₁′_ _⇨₂′_ ⦄
    ⦃ productsH : ProductsH obj₁ _⇨₂′_ ⦄
    ⦃ booleanH  : BooleanH obj₁ _⇨₂′_ ⦄
  : Set (o₁ ⊔ ℓ₁ ⊔ o₂ ⊔ ℓ₂ ⊔ q) where
  private infix 0 _⇨₁_; _⇨₁_ = _⇨₁′_
  private infix 0 _⇨₂_; _⇨₂_ = _⇨₂′_

  field
    F-false : Fₘ false ∘ ε ≈ β ∘ false
    F-true  : Fₘ true  ∘ ε ≈ β ∘ true
    F-not   : Fₘ not   ∘ β ≈ β ∘ not
    F-∧     : Fₘ ∧   ∘ μ ∘ (β ⊗ β) ≈ β ∘ ∧
    F-∨     : Fₘ ∨   ∘ μ ∘ (β ⊗ β) ≈ β ∘ ∨
    F-xor   : Fₘ xor ∘ μ ∘ (β ⊗ β) ≈ β ∘ xor
    F-cond  : ∀ {a : obj₁} → Fₘ cond ∘ μ ∘ (β ⊗ μ {a = a}) ≈ cond

open LogicH ⦃ … ⦄ public

-- TODO: id-logicH
