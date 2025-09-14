; ---------- AHK v2 GUI Simulation Example - Retro / Lain Style ----------
#Requires Autohotkey v2.0
#SingleInstance Force
CoordMode("Mouse", "Screen")
CoordMode("Pixel", "Screen")

; ---------- Colors & Positions ----------
textColor := 0x00FF00       ; Neon green
highlightColor := 0xFF00FF  ; Neon purple
bgColor := 0x000000         ; Black
groupBoxColor := 0x111111
y := 10

; ---------- Create Main GUI ----------
MyGui := Gui(, "Simulation Control v2")
MyGui.BackColor := bgColor
MyGui.SetFont("s10 c" textColor, "Consolas")

; ---------- Simulation Level Dropdown ----------
MyGui.Add("Text", "x10 y" y " w150 h20", "Simulation Level:")
SimLevelDrop := MyGui.Add("DropDownList", "x170 y" y " w120 h120", ["Low","Medium","High","Extreme"])
SimLevelDrop.Value := 2
SimLevelDrop.BackColor := 0x111111
y += 40

; ---------- Feature Checkboxes ----------
MyGui.Add("Text", "x10 y" y " w150 h20", "Enable Features:")
y += 25
FeatureA := MyGui.Add("Checkbox", "x30 y" y " w150 h20", "Feature A")
FeatureB := MyGui.Add("Checkbox", "x30 y" y+25 " w150 h20", "Feature B")
FeatureC := MyGui.Add("Checkbox", "x30 y" y+50 " w150 h20", "Feature C")
y += 90

; ---------- Characters Group ----------
CharGroup := MyGui.Add("GroupBox", "x10 y" y " w200 h110", "Characters")
Char1 := MyGui.Add("Checkbox", "x20 y" (y+20) " w150 h20", "Warden")
Char2 := MyGui.Add("Checkbox", "x20 y" (y+45) " w150 h20", "Blackprior")
Char3 := MyGui.Add("Checkbox", "x20 y" (y+70) " w150 h20", "All Others")
y += 130

; ---------- Scripts Group ----------
ScriptGroup := MyGui.Add("GroupBox", "x10 y" y " w300 h120", "Scripts for 1x1/2x2/4x4")
Script1 := MyGui.Add("Checkbox", "x20 y" (y+20) " w200 h20", "Dodge B/Unblockables")
Script2 := MyGui.Add("Checkbox", "x20 y" (y+45) " w200 h20", "Flip Bashes/Unblockables")
HelpBtn := MyGui.Add("Button", "x230 y" (y+20) " w50 h20", "?")
y += 140

; ---------- Buttons ----------
StartBtn := MyGui.Add("Button", "x10 y" y " w120 h30", "Start Simulation")
ResetBtn := MyGui.Add("Button", "x150 y" y " w120 h30", "Reset Settings")
for Btn in [StartBtn, ResetBtn, HelpBtn] {
    Btn.BackColor := 0x111111
    Btn.SetFont("c" highlightColor)
}
y += 50

; ---------- Status Text ----------
StatusText := MyGui.Add("Text", "x10 y" y " w400 h30", "Status: Idle")
y += 40

; ---------- Event Handlers ----------
StartBtn.OnEvent("Click", StartSimulation)
ResetBtn.OnEvent("Click", ResetSimulation)
HelpBtn.OnEvent("Click", ButtonH)  ; Moved after function definition
MyGui.OnEvent("Close", GuiClose)

; ---------- Hover Effect Timer ----------
SetTimer(CheckMouseOver, 100)

; ---------- Show GUI ----------
MyGui.Show("w420 h" y + 20)

; ---------- Hover Effect Function ----------
CheckMouseOver() {
    static prevBtn := ""
    try {
        MouseGetPos(, , &win, &ctrl)
        if (win = MyGui.Hwnd) {
            for BtnName in ["StartBtn","ResetBtn","HelpBtn"] {
                Btn := %BtnName%
                if (ctrl = Btn.Hwnd) {
                    if (prevBtn != Btn) {
                        if (prevBtn)
                            prevBtn.BackColor := 0x111111
                        Btn.BackColor := 0x222222
                        prevBtn := Btn
                    }
                    return
                }
            }
        }
        if (prevBtn) {
            prevBtn.BackColor := 0x111111
            prevBtn := ""
        }
    }
}

; ---------- Button Functions ----------
StartSimulation(*) {
    SimLevel := SimLevelDrop.Text
    Status := "Running Simulation - Level: " SimLevel
    if FeatureA.Value
        Status .= " | Feature A ON"
    if FeatureB.Value
        Status .= " | Feature B ON"
    if FeatureC.Value
        Status .= " | Feature C ON"
    StatusText.Text := "Status: " Status
}

ResetSimulation(*) {
    SimLevelDrop.Value := 2
    FeatureA.Value := false
    FeatureB.Value := false
    FeatureC.Value := false
    StatusText.Text := "Status: Idle"
}

ButtonH(*) {
    MsgBox("How this works: Select scripts and characters, then start simulation.")
}

GuiClose(*) {
    ExitApp
}