open Js_of_ocaml

module Console = struct
    let log msg =
        (* let m = Js.string msg in *)
        (* Firebug.console##log m *)
        (* Firebug.console##log @@ Js.string msg ; *)
        Firebug.console##log (Js.string msg)
    ;;
end