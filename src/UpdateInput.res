include InputTypes

module Response = {
  type t

  @send
  external json: t => Js.Promise.t<Js.Json.t> = "json"

  @send
  external text: t => Js.Promise.t<string> = "text"

  @get
  external ok: t => bool = "ok"

  @get
  external status: t => int = "status"

  @get
  external statusText: t => string = "statusText"
}

@val
external fetch: (
  string,
  {"method": string, "headers": Js.Dict.t<string>, "body": string}, // The body should be a JSON string
) => Js.Promise.t<Response.t> = "fetch"

// Function to update inputs
let updateInputs = (inputs: InputTypes.inputsType): Js.Promise.t<Response.t> => {
  let url = "http://localhost:12346/updateInputs" // Replace with the actual server port

  let headers = Js.Dict.fromArray([("Content-Type", "application/json")])

  // Create a dictionary for the request body
  let body = Js.Dict.fromArray([
    ("top", Js.Json.string(inputs.top)),
    ("left", Js.Json.string(inputs.left)),
    ("right", Js.Json.string(inputs.right)),
    ("bottom", Js.Json.string(inputs.bottom)),
    ("outerTop", Js.Json.string(inputs.outerTop)),
    ("outerleft", Js.Json.string(inputs.outerleft)),
    ("outerRight", Js.Json.string(inputs.outerRight)),
    ("outerbottom", Js.Json.string(inputs.outerbottom)),
  ])

  // Convert the dictionary to a JSON string
  let bodyOption = Js.Json.stringify(Js.Json.object_(body))

  let options = {
    "method": "POST",
    "headers": headers,
    "body": bodyOption,
  }

  fetch(url, options)
}
