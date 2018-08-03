open Incr_dom

(* Test minimal interactivity *)

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
        let open Vdom in
        let on_click _event = inject Action.Increment in

        (*
            let%map P = M in E
            expands to
            map M ~f:(fun P -> E)
        *)
        let open Incr.Let_syntax in
        let%map count = model in
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