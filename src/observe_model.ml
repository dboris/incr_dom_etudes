open! Core_kernel
open Incr_dom

(* Observe model changes and trigger effectful computation. *)

module App = struct
    module Model = struct
        type t = int

        (* val cutoff : t ‑> t ‑> bool *)
        let cutoff t1 t2 =
            compare t1 t2 = 0
        ;;
    end

    module Action = struct
        type t = Increment
        [@@deriving sexp]

        (* val should_log : t ‑> bool *)
        let should_log _t = true
    end

    module State = struct
        type t = unit
    end

    (* val apply_action :
        Action.t ->
        Model.t ->
        State.t ->
        schedule_action:(Action.t -> unit) ->
        Model.t *)
    let apply_action Action.Increment model _state ~schedule_action:_ =
        model + 1
    ;;

    (* val update_visibility : Model.t ‑> Model.t *)
    let update_visibility model = model

    (* val on_startup :
        schedule_action:(Action.t ‑> unit) ‑>
        Model.t ‑>
        State.t Async_kernel.Deferred.t *)
    let on_startup ~schedule_action:_ _model =
        Async_kernel.return ()
    ;;

    (* val on_display :
        old_model:Model.t ->
        Model.t ->
        State.t ->
        schedule_action:(Action.t -> unit) ->
        unit *)
    let on_display ~old_model:_ _model _state ~schedule_action:_ = ()

    (* val view :
        Model.t Incr.t ‑>
        inject:(Action.t ‑> Vdom.Event.t) ‑>
        Vdom.Node.t Incr.t *)
    let view model ~inject =
        let open Incr.Let_syntax in
        let open Lib.Util in
        Console.log "view called" ;

        (* Two ways to observe model changes: *)

        Incr.Observer.(on_update_exn (Incr.observe model) ~f:(
            function
            | Update.Changed (_old_val,new_val) ->
                new_val
                |> string_of_int
                |> (^) "count1: "
                |> Console.log
            | Update.Invalidated ->
                Console.log "Invalidated"
            | _ -> ())) ;

        Incr.(on_update model ~f:(
            function
            | Update.Changed (_old_val,new_val) ->
                new_val
                |> string_of_int
                |> (^) "count2: "
                |> Console.log
            | Update.Invalidated ->
                Console.log "Invalidated"
            | _ -> ())) ;

        let open Vdom in
        let on_click _event = inject Action.Increment in

        (*
            let%map P = M in E
            expands to
            map M ~f:(fun P -> E)
        *)
        let%map count = model in
        Console.log "view inside map" ;
        Node.body [] [
            Node.button
                [ Attr.on_click on_click ]
                [ Node.text "Increment" ];
            Node.div
                []
                [ Node.text @@ string_of_int count ]
        ]
    ;;
end

let () =
    Start_app.simple (module App) ~initial_model:0
;;