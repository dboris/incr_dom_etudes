open Incr_dom

(* The minimal incr_dom app *)

module App = struct
    module Model = struct
        type t = unit

        (* val cutoff : t ‑> t ‑> bool *)
        let cutoff t1 t2 =
            compare t1 t2 = 0
        ;;
    end

    module Action = struct
        type t = Dummy_action
        [@@deriving sexp]

        (* val should_log : t ‑> bool *)
        let should_log _t = false
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
    let apply_action _action model _state ~schedule_action:_ = model

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
    let view _model ~inject:_ =
        let open Vdom in
        Incr.const @@
            Node.body [] [
                Node.text "Hola, mundo!"
            ]
    ;;
end

let () =
    Start_app.simple (module App) ~initial_model:()