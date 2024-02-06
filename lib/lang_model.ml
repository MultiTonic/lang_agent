(* Intuitional language model
   everyone creates different versions of this.
 *)

(*
  similar to total2 of unimath
 *)
class type  [
          't_a,
          't_b
        ]
    pair_type =
  object
  end

class type  [
          't_state_machine
        ] protocol_type = object
  method state_machine  :  unit -> 't_state_machine
end

class type  [
          't_address,
          't_connection
          (* 't_size*)
        ] network_type = object
  method connect  :  't_address -> 't_connection
end

class type  [
          't_key,
          't_auth
        ] auth_type = object
  method authenticate  : 't_key -> 't_auth
end

class type  [
          't_address,
          't_key,
          't_auth,
          't_state_machine
        ] connection_type = object
  method connect  :  't_address -> 't_connection
end

class type
    [
      't_auth,
      't_network,
      't_protocol,
      't_connection
    ] connection_type2 = object
  method connect  : 't_auth -> 't_network ->'t_protocol -> 't_connection
end

class type [
          't_name,
          't_attributes,
          't_stories,
          't_embodiments,
          't_identity
        ]
             archtype_type = object  
end

class type [
          't_call_to_adventure,
          't_refusal,
          't_resurrection
            (*fill in the rest*)
        ]
             heros_journey_type = object  
end



class type
    [
      't_context,
      't_environment,
      't_goal,
      't_language,
      't_state_machine,
      't_protocol,
      't_project,
      't_notations,
      't_error_retry_handler,
      't_logging_handler,
      't_introspection_visitor,      
      't_short_term_memory,
      't_long_term_memory,
      't_lemmas,
      't_proofs,

        't_sets,
        't_types,
        't_propositions,

        't_universes,
        't_objects,

        't_validators,
        't_grammars,

      't_prelude,

      't_string
    ] introspector_prompt_model = object
  method prompt_type  : 't_auth -> 't_network ->'t_protocol -> 't_string
end

class type  [
          't_name,
          't_param,
          't_params,
          't_method,
          't_method_param,
          't_type,
          't_val,
          't_vals      
        ]
    class_type_result =
  object
    method begin_type :
             't_name ->
             't_params ->
             't_methods ->
             't_vals ->
             't_type (*result*)
             
    method begin_method :
             't_name ->
             't_params ->
             't_method (*result*)

    method add_method :
             't_methods ->
             't_method ->
             't_methods (*result*)

    method begin_val :
             't_name ->
             't_type ->
             't_val (*result*)

    method add_val :
             't_vals ->
             't_val ->
             't_vals (*result*)       
  end

class type  [
          't_string,
          't_nat,
          't_real
        ]
    model_params =
  object
    method request :
             (*prompt*)  't_prompt ->
             (*tokens*)  't_nat ->
             (*temp*)    't_real ->
             (*top_k*)   't_nat ->
             (*top_n*)   't_nat ->
             (* output *) 't_result
  end

class type
    [
      't_connection
     ,'t_model_params
     ,'t_style
     ,'t_prompt
     ,'t_result
        (* 'model, *)
    ] 
    lang_model =
  object
    (* A method that generates text given a prompt and a style *)
    method generate_text : 't_connection -> 't_model_params -> 't_style -> 't_prompt -> 't_result

  end


    (* (\* A method that completes a prompt given a style *\) *)
    (* method complete_prompt : string -> string -> string *)
    (* (\* A method that answers a question given a context and a style *\) *)
    (* method answer_question : string -> string -> string -> string *)

    (* method  get_tag: unit -> string *)


      (* 'error_handler, and retry *)
      (* 'visitor, *)
      (* 'introspection, *)
      (* 'short_term_memory, *)
      (* 'long_term_memory, *)
      (* 'goals, *)
      (* 'lemmas, *)
      (* 'proofs, *)
      (* 'sets, *)
      (* 'types, *)
      (* 'propositions, *)
      (* 'universes, *)
      (* 'objects, *)
      (* 'validators, *)
      (* 'grammars *)


(* create a ocaml abstract typeclass of mythos *)
class type [
          't_region,
          't_epoch,
          't_language,
          't_archtypes,
          't_names,
          't_prompt_type,
          't_response_type
        ]
             mythos = object
  method invoke : 't_prompt_type -> 't_response_type
end

(*
  now create a mythos of athena please  
 *)

class type archtype_warrior = object
  
end

class type archtype_woman = object
  
end

class  t_archtype_athena : [
    archtype_warrior,
    archtype_woman
  ] pair_type =
  object
  end
class t_names_nil = object
end
class greek_athena_mythos : [
    't_region_greece,
    't_epoch_classical,
    't_language_classical_greek,
    t_archtype_athena,
    t_names_nil,
    string,
    string
  ] mythos = object
(* (self)
  This is a mythos of Athena, the goddess of wisdom
      and warfare in Greek mythology.
 *)
  method invoke (prompt:'t_string) = "Is it because of your mother you say " ^ prompt
end