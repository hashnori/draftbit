%raw(`require("./HomePanel.css")`)
include InputTypes

open Js.Promise

@genType @genType.as("HomePanel") @react.component
let make = () => {
  // Define the initial state with empty strings
  let initialInputs: InputTypes.inputsType = {
    top: "",
    left: "",
    right: "",
    bottom: "",
    outerTop: "",
    outerleft: "",
    outerRight: "",
    outerbottom: "",
  }

  let (inputs, setInputs) = React.useState(() => initialInputs)
  let now = Js.Date.make()
  
  let dateTimeStr = Js.Date.toLocaleString(now)

  React.useEffect1(() => {
    Fetch.fetchJson(`http://localhost:12346/updateInputs`)
    |> Js.Promise.then_(inputsJson => {
      Js.Promise.resolve(setInputs(_ => Obj.magic(inputsJson)))
    })
    |> catch(_error => {
      Js.log("Failed to fetch inputs from API")
      Js.Promise.resolve()
    })
    |> ignore
    None
  }, [])

  // The component UI
  <aside className="HomePanel">
    <div className="MarginsPaddingContainer">
      <div className="mobileScreeMain">
        <div className="panelData">
          //outer margin
          <p
            style={ReactDOM.Style.make(
              ~marginTop=inputs.outerTop,
              ~marginLeft=inputs.outerleft,
              ~marginRight=inputs.outerRight,
              ~marginBottom=inputs.outerbottom,
              ~paddingTop=inputs.top,
              ~paddingLeft=inputs.left,
              ~paddingRight=inputs.right,
              ~paddingBottom=inputs.bottom,
              (),
            )}>
            <span style={ReactDOM.Style.make(~fontSize="24px", ~fontWeight="bold", ())}>
              {React.string(dateTimeStr)}
            </span>
          </p>
        </div>
      </div>
    </div>
  </aside>
}
