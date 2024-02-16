open Ppx_yojson_conv_lib.Yojson_conv.Primitives
open Lang_model
include Yojson.Safe

let json_to_field_opt name f o =
  ( name
  , match o with
    | Some v -> f v
    | None -> `Null )
;;

type client_t =
  { 
   mutable url : string
  ; c : Curl.t
  }

let create_client  =
  let base_url = "http://localhost:8080" in
  {  url = base_url; c = Ezcurl_lwt.make () }
;;

type role =
  [ `System
  | `User
  | `Assistant
  ]

let yojson_of_role = function
  | `System -> `String "system"
  | `User -> `String "user"
  | `Assistant -> `String "assistant"
;;

  
let send_raw_k
  k
  (client : client_t)
  (prompt : string)  
  ()
  =
  (* print_endline ( "DEBUG:" ^ prompt );  *)
  let body =
    List.filter
      (fun (_, v) -> v <> `Null)
      [ "n_predict", `Int 128
      ; "prompt",`String prompt
      ]
    |> fun l -> Yojson.Safe.to_string (`Assoc l)
  in
  let headers =
    [ "content-type", "application/json"
    ]
  in
  let endpoint = "/completion" in
  let%lwt resp =
    Ezcurl_lwt.post
      ~client:client.c
      ~headers
      ~content:(`String body)
      ~url:(client.url ^ endpoint)
      ~params:[]
      ()
  in
  k resp

type llama_cpp_timings =
  { 
    predicted_ms: float
  ;predicted_n:int
  ;predicted_per_second:float
  ;predicted_per_token_ms:float
  ;prompt_ms:float
  ;prompt_n:int
  ;prompt_per_second:float
  ;prompt_per_token_ms:float
  } [@@deriving yojson]

type llama_cpp_generation_settings =
  {
    dynatemp_exponent:float
  ; dynatemp_range:float
  ; frequency_penalty:float
  ; grammar:string
  ; ignore_eos:bool
  ; logit_bias: (int list)
  ; min_p :float
  ; mirostat:int
  ; mirostat_eta:float
  ; mirostat_tau:float
  ; model:string     
  ; n_ctx: int 
  ; n_keep: int
  ; n_predict: int
  ; n_probs: int
  ; penalize_nl: bool
  ; penalty_prompt_tokens: (string list)
  ; presence_penalty: float
  ; repeat_last_n: int
  ; repeat_penalty: float
  ; seed: int
  ; stop: (string list)
  ; stream : bool
  ; temperature: float
  ; tfs_z: float
  ; top_k: int
  ; top_p: float
  ; typical_p: float
  ; use_penalty_prompt_tokens: bool
  }
[@@deriving yojson]
  
type llama_cpp_response =
  {
    content: string
  ; generation_settings: llama_cpp_generation_settings
  ; model : string
  ; prompt : string
  ; slot_id: int
  ; stop : bool 
  ; stopped_eos : bool
  ; stopped_limit : bool
  ; stopped_word : bool
  ; stopping_word : string      
  ;timings : llama_cpp_timings
  ;tokens_cached:int
  ;tokens_evaluated:int
  ;tokens_predicted:int
  ;truncated:bool
  }
[@@deriving yojson]

let contains s1 s2 =
  let re = Str.regexp_string s2
  in
  try ignore (Str.search_forward re s1 0); true
  with Not_found -> false

let myproc (body:string):string =
  if contains body "error"  then
    (print_endline ( "DEBUGBODY:" ^ body ) );

  if (String.length body ) == 0 then ""
  else
    try
      print_endline ( "JSON:" ^ body );  
      let json = Yojson.Safe.from_string body in

      let record_opt = (llama_cpp_response_of_yojson json) in
      record_opt.content
    with
    | Ppx_yojson_conv_lib.Yojson_conv.Of_yojson_error (loc, exn) ->
      Printf.eprintf "Loc at  %s\n" (Printexc.to_string loc);
      Printf.eprintf "Error at  %s\n" (Yojson.Safe.show exn); "ERROR2"
  (* | exn -> *)
  (*   Printf.eprintf "Unexpected error: %s\n" (   to_string exn); "errorr2" *)


    
let split_n = String.split_on_char '\n'
    
let extract_content1 body = 
  let fpp =  (split_n body ) in
  let fp2 = List.map myproc fpp  in
  String.concat "" fp2
let extract_content body = 
  Lwt.return (extract_content1 body)

let send =
  send_raw_k
  @@ function
  | Ok { body; _ } -> extract_content body
  | Error (_code, e) -> Lwt.fail_with e

type (* 't_key, *) t_key_string = string
type (* url 't_address, *) t_address_string = string

type (* 't_temperature, *) t_temperature_float = Float.t
type (* 't_max_tokens, *) t_max_tokens_int = Int.t
type (* assistent prompt 't_system_content, *) t_system_content_string = string
type (* 't_prompt, *) t_prompt_string = string
type (* 't_response *) t_response_string = string


let dobind1 prompt the_client  =
  let newprompt = prompt in
  let%lwt result = send the_client newprompt () in
  Lwt.return result

let dobind prompt the_client  =
  let result = Lwt_main.run (dobind1 prompt the_client ) in
  result
    
    
class llama_cpp_lang_model  = object (* (self) *)
  inherit [client_t] openai_like_lang_model
  method  lang_init  () : client_t Lang_model.client_t  =
    let client = create_client  in
    mk_client_t client

  method  lang_auth  (self: 't_connection) (_ (*key*) :'t_key):'t_connection = self 
  method  lang_open   (self: 't_connection) (url (*address*): 't_address) =
    self.agt_driver.url <- url;
    self
  method  lang_set_model (self: 't_connection) (_ : 't_model) =
    self
  method  lang_set_grammar (self: 't_connection) (grammar: 't_grammar_string) =
    self.agt_grammar <- grammar;
    self
    
  method  lang_set_temp  (self: 't_connection) (_ (*temp*) :'t_temperature) = self

  method  lang_set_max_tokens (self: 't_connection) (_ (*token*): 't_max_tokens) = self
  method  lang_set_system_content (self: 't_connection) (_ (*prompt*): 't_prompt)=  self
  method  lang_prompt
           (connection : 't_connection)
           (prompt:'t_prompt) :'t_response=
    let connection1 =  connection.agt_driver in
    let res:string = (dobind prompt connection1 ) in  
    " Result: " ^ res
end

module LlamaCppClientModule
         ( A: LLMClientModule
           with type t =
                       llama_cpp_lang_model
         )  = struct
  let init ()  = new llama_cpp_lang_model
end

module LlamaCppClientModule2 = struct
  let init ()  = new llama_cpp_lang_model
end

module type LLMClientModuleLlamaCpp2 = sig
  val init : unit -> llama_cpp_lang_model      
end





