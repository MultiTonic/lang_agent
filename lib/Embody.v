(** File generated by coq-of-ocaml *)
Require Import CoqOfOCaml.CoqOfOCaml.
Require Import CoqOfOCaml.Settings.

Module mythos.
  Record record {t_author t_mythos t_archetypes t_language t_emotions
    t_prompt_type t_response_type : Set} : Set := Build {
    create : t_author -> t_mythos;
    invoke : t_prompt_type -> t_response_type;
    evoke : t_prompt_type -> t_emotions;
    reify : t_mythos -> t_archetypes;
    embody : t_archetypes -> t_mythos;
    translate : t_mythos -> t_language -> t_language;
  }.
  Arguments record : clear implicits.
  Definition with_create
    {t_t_author t_t_mythos t_t_archetypes t_t_language t_t_emotions
      t_t_prompt_type t_t_response_type} create
    (r :
      record t_t_author t_t_mythos t_t_archetypes t_t_language t_t_emotions
        t_t_prompt_type t_t_response_type) :=
    Build t_t_author t_t_mythos t_t_archetypes t_t_language t_t_emotions
      t_t_prompt_type t_t_response_type create r.(invoke) r.(evoke) r.(reify)
      r.(embody) r.(translate).
  Definition with_invoke
    {t_t_author t_t_mythos t_t_archetypes t_t_language t_t_emotions
      t_t_prompt_type t_t_response_type} invoke
    (r :
      record t_t_author t_t_mythos t_t_archetypes t_t_language t_t_emotions
        t_t_prompt_type t_t_response_type) :=
    Build t_t_author t_t_mythos t_t_archetypes t_t_language t_t_emotions
      t_t_prompt_type t_t_response_type r.(create) invoke r.(evoke) r.(reify)
      r.(embody) r.(translate).
  Definition with_evoke
    {t_t_author t_t_mythos t_t_archetypes t_t_language t_t_emotions
      t_t_prompt_type t_t_response_type} evoke
    (r :
      record t_t_author t_t_mythos t_t_archetypes t_t_language t_t_emotions
        t_t_prompt_type t_t_response_type) :=
    Build t_t_author t_t_mythos t_t_archetypes t_t_language t_t_emotions
      t_t_prompt_type t_t_response_type r.(create) r.(invoke) evoke r.(reify)
      r.(embody) r.(translate).
  Definition with_reify
    {t_t_author t_t_mythos t_t_archetypes t_t_language t_t_emotions
      t_t_prompt_type t_t_response_type} reify
    (r :
      record t_t_author t_t_mythos t_t_archetypes t_t_language t_t_emotions
        t_t_prompt_type t_t_response_type) :=
    Build t_t_author t_t_mythos t_t_archetypes t_t_language t_t_emotions
      t_t_prompt_type t_t_response_type r.(create) r.(invoke) r.(evoke) reify
      r.(embody) r.(translate).
  Definition with_embody
    {t_t_author t_t_mythos t_t_archetypes t_t_language t_t_emotions
      t_t_prompt_type t_t_response_type} embody
    (r :
      record t_t_author t_t_mythos t_t_archetypes t_t_language t_t_emotions
        t_t_prompt_type t_t_response_type) :=
    Build t_t_author t_t_mythos t_t_archetypes t_t_language t_t_emotions
      t_t_prompt_type t_t_response_type r.(create) r.(invoke) r.(evoke)
      r.(reify) embody r.(translate).
  Definition with_translate
    {t_t_author t_t_mythos t_t_archetypes t_t_language t_t_emotions
      t_t_prompt_type t_t_response_type} translate
    (r :
      record t_t_author t_t_mythos t_t_archetypes t_t_language t_t_emotions
        t_t_prompt_type t_t_response_type) :=
    Build t_t_author t_t_mythos t_t_archetypes t_t_language t_t_emotions
      t_t_prompt_type t_t_response_type r.(create) r.(invoke) r.(evoke)
      r.(reify) r.(embody) translate.
End mythos.
Definition mythos := mythos.record.

Definition embody {A B C D E F G : Set} (mythos0 : mythos A B C D E F G)
  : C -> B := mythos0.(mythos.embody).