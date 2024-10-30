%raw(`require("./PropertiesPanel.css")`)
include InputTypes

open Js.Promise

module Collapsible = {
  @genType @react.component
  let make = (~title, ~children) => {
    let (collapsed, toggle) = React.useState(() => false)

    <section className="Collapsible">
      <button className="Collapsible-button" onClick={_e => toggle(_ => !collapsed)}>
        <span> {React.string(title)} </span> <span> {React.string(collapsed ? "+" : "-")} </span>
      </button>
      {collapsed ? React.null : <div className="Collapsible-content"> {children} </div>}
    </section>
  }
}

// This component provides a simplified example of fetching JSON data from
// the backend and rendering it on the screen.
module ViewExamples = {
  // Type of the data returned by the /examples endpoint
  type example = {
    id: int,
    some_int: int,
    some_text: string,
  }
  @genType @react.component
  let make = () => {
    let (examples: option<array<example>>, setExamples) = React.useState(_ => None)

    React.useEffect1(() => {
      // Fetch the data from /examples and set the state when the promise resolves
      Fetch.fetchJson(`http://localhost:12346/examples`)
      |> Js.Promise.then_(examplesJson => {
        // NOTE: this uses an unsafe type cast, as safely parsing JSON in rescript is somewhat advanced.
        Js.Promise.resolve(setExamples(_ => Some(Obj.magic(examplesJson))))
      })
      |> ignore
      None
    }, [setExamples])

    <div>
      {switch examples {
      | None => React.string("Loading examples....")
      | Some(examples) =>
        examples
        ->Js.Array2.map(example =>
          React.string(`Int: ${example.some_int->Js.Int.toString}, Str: ${example.some_text}`)
        )
        ->React.array
      }}
    </div>
  }
}

@genType @genType.as("PropertiesPanel") @react.component
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
    outerbottom: ""
  }
  let initialValue = ""
  // Use React's useState with the initial state
  let (inputs, setInputs) = React.useState(() => initialInputs)
  let (activeKey, setActiveKey) = React.useState(() => initialValue)

  // Fetch data from API to get initial inputs
React.useEffect1(() => {
  Fetch.fetchJson(`http://localhost:12346/updateInputs`)
  |> Js.Promise.then_(inputsJson => {
    Js.Promise.resolve(setInputs(_ => Obj.magic(inputsJson)))
  })
  |> ignore
  None
}, [activeKey]) // Add dependency on `activeKey` if needed


  // Update handleChange to also call updateInputs
  let handleChange = (key: string, value: string) => {
    let newInputs = switch key {
    | "top" => {...inputs, top: value}
    | "left" => {...inputs, left: value}
    | "right" => {...inputs, right: value}
    | "bottom" => {...inputs, bottom: value}
    | "outerTop" => {...inputs, outerTop: value}
    |  "outerleft" => {...inputs, outerleft: value} 
    | "outerRight" => {...inputs, outerRight: value}
    | "outerbottom" => {...inputs, outerbottom: value}

    | _ => inputs
    }

    // Update the state with the new inputs
    setInputs(_ => newInputs)

    // Update the server with the new values
    UpdateInput.updateInputs(newInputs)
    |> then_(res => {
      if UpdateInput.Response.ok(res) {
        Js.log("Inputs updated successfully")
        Js.Promise.resolve() // Use `Js.Promise.resolve()` to return a unit promise
      } else {
        res->UpdateInput.Response.text
          |> then_(text => {
            Js.log2("Failed to update inputs:", text)
            Js.Promise.resolve()
          })
      }
    })
    |> catch(error => {
      Js.log2("Error during update:", error)
      Js.Promise.resolve()
    })
    |> ignore // Use `ignore` to disregard the result of the promise
  }

  // Helper function to handle onChange event
  let onInputChange = (key, e) => {
    let value = ReactEvent.Form.target(e)["value"]
    handleChange(key, value)
  }

  let handleCrossClick = (key: string) => {
    Js.log(key)
    setActiveKey(_ => key)
    Js.log("Event triggered")
  }

  let outerRightClass = if activeKey == "outerRight" {
    "hoverItemDetail active"
  } else {
    "hoverItemDetail"
  }

  let outerTopClass = if activeKey == "outerTop" {
    "hoverItemDetail active"
  } else {
    "hoverItemDetail"
  }

    let outerBottomClass = if activeKey == "outerbottom" {
    "hoverItemDetail active"
  } else {
    "hoverItemDetail"
  }

let outerLeftClass = if activeKey == "outerleft" {
  "hoverItemDetail active"
} else {
  "hoverItemDetail"
}
  // The component UI
  <aside className="PropertiesPanel">
    <Collapsible title="Load examples"> <ViewExamples /> </Collapsible>
    <Collapsible title="Margins & Padding">
      <div className="MarginsPaddingContainer">
        <div className={activeKey===""?"outerElementsForMargin":"outerElementsForMargin active"}>
          <div className="input">
            <div className={outerRightClass}>
              <div className="headingDetail">
                <h6> {React.string("paddingLeft")} </h6>
                <span className="crossIcon" onClick={e => handleCrossClick("")}>
                  {React.string("X")}
                </span>
                <p> {React.string("Inline style, current breakpoint")} </p>
                <div className="staticValue">
                  <p> {React.string("20 : 00")} </p>
                  <input
                    type_="text"
                    value={inputs.outerRight}
                    onChange={e => onInputChange("outerRight", e)}
                  />
                  <span> {React.string("px")} </span>
                </div>
              </div>
            </div>
            <span className="defaultLabel" onClick={event => handleCrossClick("outerRight")}>
              {React.string({inputs.outerRight})}
            </span>
          </div>




          <div className="input">
            <div className={outerTopClass}>
              <div className="headingDetail">
                <h6> {React.string("paddingLeft")} </h6>
                <span className="crossIcon" onClick={e => handleCrossClick("")}>
                  {React.string("X")}
                </span>
                <p> {React.string("Inline style, current breakpoint")} </p>
                <div className="staticValue">
                  <p> {React.string("20 : 00")} </p>
                  <input
                    type_="text"
                    value={inputs.outerTop}
                    onChange={e => onInputChange("outerTop", e)}
                  />
                  <span> {React.string("px")} </span>
                </div>
              </div>
            </div>
            <span className="defaultLabel" onClick={event => handleCrossClick("outerTop")}>
              {React.string({inputs.outerTop})}
            </span>
          </div>




           <div className="input">
            <div className={outerBottomClass}>
              <div className="headingDetail">
                <h6> {React.string("paddingLeft")} </h6>
                <span className="crossIcon" onClick={e => handleCrossClick("")}>
                  {React.string("X")}
                </span>
                <p> {React.string("Inline style, current breakpoint")} </p>
                <div className="staticValue">
                  <p> {React.string("20 : 00")} </p>
                  <input
                    type_="text"
                    value={inputs.outerbottom}
                    onChange={e => onInputChange("outerbottom", e)}
                  />
                  <span> {React.string("px")} </span>
                </div>
              </div>
            </div>
            <span className="defaultLabel" onClick={event => handleCrossClick("outerbottom")}>
              {React.string({inputs.outerbottom})}
            </span>
          </div>




          <div className="input">
            <div className={outerLeftClass}>
              <div className="headingDetail">
                <h6> {React.string("paddingLeft")} </h6>
                <span className="crossIcon" onClick={e => handleCrossClick("")}>
                   {React.string("X")}
                </span>
                <p> {React.string("Inline style, current breakpoint")} </p>
                <div className="staticValue">
                  <p> {React.string("20 : 00")} </p>
                  <input
                    type_="text"
                     value={inputs.outerleft}
                    onChange={e => onInputChange("outerleft", e)}
                  />
                  <span> {React.string("px")} </span>
                </div>
              </div>
            </div>
               <span className="defaultLabel" onClick={event => handleCrossClick("outerleft")}>
              {React.string({inputs.outerleft})}
            </span>
          </div>



        </div>
        <div className="MarginsPaddingBox">



          <input
            className="defaultLabel"
            type_="text"
            value={inputs.top}
            onChange={e => onInputChange("top", e)}
          />




          
          <div className="MarginsPaddingInnerBox">
            <input
              className="changedLabel"
              type_="text"
              value={inputs.left}
              onChange={e => onInputChange("left", e)}
            />
            <input
              className="changedLabel"
              type_="text"
              value={inputs.right}
              onChange={e => onInputChange("right", e)}
            />
          </div>
          <input
            className="defaultLabel"
            type_="text"
            value={inputs.bottom}
            onChange={e => onInputChange("bottom", e)}
          />
        </div>
      </div>
    </Collapsible>
    <Collapsible title="Size"> <span> {React.string("example")} </span> </Collapsible>
  </aside>
}
